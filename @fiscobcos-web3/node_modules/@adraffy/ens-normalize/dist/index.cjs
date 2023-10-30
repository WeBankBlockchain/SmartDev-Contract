'use strict';

function decode_arithmetic(bytes) {
	let pos = 0;
	function u16() { return (bytes[pos++] << 8) | bytes[pos++]; }
	
	// decode the frequency table
	let symbol_count = u16();
	let total = 1;
	let acc = [0, 1]; // first symbol has frequency 1
	for (let i = 1; i < symbol_count; i++) {
		acc.push(total += u16());
	}

	// skip the sized-payload that the last 3 symbols index into
	let skip = u16();
	let pos_payload = pos;
	pos += skip;

	let read_width = 0;
	let read_buffer = 0; 
	function read_bit() {
		if (read_width == 0) {
			// this will read beyond end of buffer
			// but (undefined|0) => zero pad
			read_buffer = (read_buffer << 8) | bytes[pos++];
			read_width = 8;
		}
		return (read_buffer >> --read_width) & 1;
	}

	const N = 31;
	const FULL = 2**N;
	const HALF = FULL >>> 1;
	const QRTR = HALF >> 1;
	const MASK = FULL - 1;

	// fill register
	let register = 0;
	for (let i = 0; i < N; i++) register = (register << 1) | read_bit();

	let symbols = [];
	let low = 0;
	let range = FULL; // treat like a float
	while (true) {
		let value = Math.floor((((register - low + 1) * total) - 1) / range);
		let start = 0;
		let end = symbol_count;
		while (end - start > 1) { // binary search
			let mid = (start + end) >>> 1;
			if (value < acc[mid]) {
				end = mid;
			} else {
				start = mid;
			}
		}
		if (start == 0) break; // first symbol is end mark
		symbols.push(start);
		let a = low + Math.floor(range * acc[start]   / total);
		let b = low + Math.floor(range * acc[start+1] / total) - 1;
		while (((a ^ b) & HALF) == 0) {
			register = (register << 1) & MASK | read_bit();
			a = (a << 1) & MASK;
			b = (b << 1) & MASK | 1;
		}
		while (a & ~b & QRTR) {
			register = (register & HALF) | ((register << 1) & (MASK >>> 1)) | read_bit();
			a = (a << 1) ^ HALF;
			b = ((b ^ HALF) << 1) | HALF | 1;
		}
		low = a;
		range = 1 + b - a;
	}
	let offset = symbol_count - 4;
	return symbols.map(x => { // index into payload
		switch (x - offset) {
			case 3: return offset + 0x10100 + ((bytes[pos_payload++] << 16) | (bytes[pos_payload++] << 8) | bytes[pos_payload++]);
			case 2: return offset + 0x100 + ((bytes[pos_payload++] << 8) | bytes[pos_payload++]);
			case 1: return offset + bytes[pos_payload++];
			default: return x - 1;
		}
	});
}	

// returns an iterator which returns the next symbol
function read_payload(v) {
	let pos = 0;
	return () => v[pos++];
}
function read_compressed_payload(s) {
	return read_payload(decode_arithmetic(unsafe_atob(s)));
}

// unsafe in the sense:
// expected well-formed Base64 w/o padding 
function unsafe_atob(s) {
	let lookup = [];
	[...'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'].forEach((c, i) => lookup[c.charCodeAt(0)] = i);
	let n = s.length;
	let ret = new Uint8Array((6 * n) >> 3);
	for (let i = 0, pos = 0, width = 0, carry = 0; i < n; i++) {
		carry = (carry << 6) | lookup[s.charCodeAt(i)];
		width += 6;
		if (width >= 8) {
			ret[pos++] = (carry >> (width -= 8));
		}
	}
	return ret;
}

// eg. [0,1,2,3...] => [0,-1,1,-2,...]
function signed(i) { 
	return (i & 1) ? (~i >> 1) : (i >> 1);
}

function read_deltas(n, next) {
	let v = Array(n);
	for (let i = 0, x = 0; i < n; i++) v[i] = x += signed(next());
	return v;
}

// [123][5] => [0 3] [1 1] [0 0]
function read_sorted(next, prev = 0) {
	let ret = [];
	while (true) {
		let x = next();
		let n = next();
		if (!n) break;
		prev += x;
		for (let i = 0; i < n; i++) {
			ret.push(prev + i);
		}
		prev += n + 1;
	}
	return ret;
}

function read_sorted_arrays(next) {
	return read_array_while(() => { 
		let v = read_sorted(next);
		if (v.length) return v;
	});
}

// returns map of x => ys
function read_mapped(next) {
	let ret = [];
	while (true) {
		let w = next();
		if (w == 0) break;
		ret.push(read_linear_table(w, next));
	}
	while (true) {
		let w = next() - 1;
		if (w < 0) break;
		ret.push(read_replacement_table(w, next));
	}
	return ret.flat();
}

// read until next is falsy
// return array of read values
function read_array_while(next) {
	let v = [];
	while (true) {
		let x = next(v.length);
		if (!x) break;
		v.push(x);
	}
	return v;
}

// read w columns of length n
// return as n rows of length w
function read_transposed(n, w, next) {
	let m = Array(n).fill().map(() => []);
	for (let i = 0; i < w; i++) {
		read_deltas(n, next).forEach((x, j) => m[j].push(x));
	}
	return m;
}
 
// returns [[x, ys], [x+dx, ys+dy], [x+2*dx, ys+2*dy], ...]
// where dx/dy = steps, n = run size, w = length of y
function read_linear_table(w, next) {
	let dx = 1 + next();
	let dy = next();
	let vN = read_array_while(next);
	let m = read_transposed(vN.length, 1+w, next);
	return m.flatMap((v, i) => {
		let [x, ...ys] = v;
		return Array(vN[i]).fill().map((_, j) => {
			let j_dy = j * dy;
			return [x + j * dx, ys.map(y => y + j_dy)];
		});
	});
}

// return [[x, ys...], ...]
// where w = length of y
function read_replacement_table(w, next) { 
	let n = 1 + next();
	let m = read_transposed(n, 1+w, next);
	return m.map(v => [v[0], v.slice(1)]);
}

// created 2023-02-21T09:18:13.549Z
var r$1 = read_compressed_payload('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');
const FENCED = new Map([[8217,"apostrophe"],[8260,"fraction slash"],[12539,"middle dot"]]);
const NSM_MAX = 4;

function hex_cp(cp) {
	return cp.toString(16).toUpperCase().padStart(2, '0');
}

function quote_cp(cp) {
	return `{${hex_cp(cp)}}`; // raffy convention: like "\u{X}" w/o the "\u"
}

/*
export function explode_cp(s) {
	return [...s].map(c => c.codePointAt(0));
}
*/
function explode_cp(s) { // this is about 2x faster
	let cps = [];
	for (let pos = 0, len = s.length; pos < len; ) {
		let cp = s.codePointAt(pos);
		pos += cp < 0x10000 ? 1 : 2;
		cps.push(cp);
	}
	return cps;
}

function str_from_cps(cps) {
	const chunk = 4096;
	let len = cps.length;
	if (len < chunk) return String.fromCodePoint(...cps);
	let buf = [];
	for (let i = 0; i < len; ) {
		buf.push(String.fromCodePoint(...cps.slice(i, i += chunk)));
	}
	return buf.join('');
}

function compare_arrays(a, b) {
	let n = a.length;
	let c = n - b.length;
	for (let i = 0; c == 0 && i < n; i++) c = a[i] - b[i];
	return c;
}

// created 2023-02-21T09:18:13.549Z
var r = read_compressed_payload('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');

// https://unicode.org/reports/tr15/

function unpack_cc(packed) {
	return (packed >> 24) & 0xFF;
}
function unpack_cp(packed) {
	return packed & 0xFFFFFF;
}

const SHIFTED_RANK = new Map(read_sorted_arrays(r).flatMap((v, i) => v.map(x => [x, (i+1) << 24]))); // pre-shifted
const EXCLUSIONS = new Set(read_sorted(r));
const DECOMP = new Map();
const RECOMP = new Map();
for (let [cp, cps] of read_mapped(r)) {
	if (!EXCLUSIONS.has(cp) && cps.length == 2) {
		let [a, b] = cps;
		let bucket = RECOMP.get(a);
		if (!bucket) {
			bucket = new Map();
			RECOMP.set(a, bucket);
		}
		bucket.set(b, cp);
	}
	DECOMP.set(cp, cps.reverse()); // stored reversed
}

// algorithmic hangul
// https://www.unicode.org/versions/Unicode15.0.0/ch03.pdf (page 144)
const S0 = 0xAC00;
const L0 = 0x1100;
const V0 = 0x1161;
const T0 = 0x11A7;
const L_COUNT = 19;
const V_COUNT = 21;
const T_COUNT = 28;
const N_COUNT = V_COUNT * T_COUNT;
const S_COUNT = L_COUNT * N_COUNT;
const S1 = S0 + S_COUNT;
const L1 = L0 + L_COUNT;
const V1 = V0 + V_COUNT;
const T1 = T0 + T_COUNT;

function is_hangul(cp) {
	return cp >= S0 && cp < S1;
}

function compose_pair(a, b) {
	if (a >= L0 && a < L1 && b >= V0 && b < V1) {
		return S0 + (a - L0) * N_COUNT + (b - V0) * T_COUNT;
	} else if (is_hangul(a) && b > T0 && b < T1 && (a - S0) % T_COUNT == 0) {
		return a + (b - T0);
	} else {
		let recomp = RECOMP.get(a);
		if (recomp) {
			recomp = recomp.get(b);
			if (recomp) {
				return recomp;
			}
		}
		return -1;
	}
}

function decomposed(cps) {
	let ret = [];
	let buf = [];
	let check_order = false;
	function add(cp) {
		let cc = SHIFTED_RANK.get(cp);
		if (cc) {
			check_order = true;
			cp |= cc;
		}
		ret.push(cp);
	}
	for (let cp of cps) {
		while (true) {
			if (cp < 0x80) {
				ret.push(cp);
			} else if (is_hangul(cp)) {
				let s_index = cp - S0;
				let l_index = s_index / N_COUNT | 0;
				let v_index = (s_index % N_COUNT) / T_COUNT | 0;
				let t_index = s_index % T_COUNT;
				add(L0 + l_index);
				add(V0 + v_index);
				if (t_index > 0) add(T0 + t_index);
			} else {
				let mapped = DECOMP.get(cp);
				if (mapped) {
					buf.push(...mapped);
				} else {
					add(cp);
				}
			}
			if (!buf.length) break;
			cp = buf.pop();
		}
	}
	if (check_order && ret.length > 1) {
		let prev_cc = unpack_cc(ret[0]);
		for (let i = 1; i < ret.length; i++) {
			let cc = unpack_cc(ret[i]);
			if (cc == 0 || prev_cc <= cc) {
				prev_cc = cc;
				continue;
			}
			let j = i-1;
			while (true) {
				let tmp = ret[j+1];
				ret[j+1] = ret[j];
				ret[j] = tmp;
				if (!j) break;
				prev_cc = unpack_cc(ret[--j]);
				if (prev_cc <= cc) break;
			}
			prev_cc = unpack_cc(ret[i]);
		}
	}
	return ret;
}

function composed_from_decomposed(v) {
	let ret = [];
	let stack = [];
	let prev_cp = -1;
	let prev_cc = 0;
	for (let packed of v) {
		let cc = unpack_cc(packed);
		let cp = unpack_cp(packed);
		if (prev_cp == -1) {
			if (cc == 0) {
				prev_cp = cp;
			} else {
				ret.push(cp);
			}
		} else if (prev_cc > 0 && prev_cc >= cc) {
			if (cc == 0) {
				ret.push(prev_cp, ...stack);
				stack.length = 0;
				prev_cp = cp;
			} else {
				stack.push(cp);
			}
			prev_cc = cc;
		} else {
			let composed = compose_pair(prev_cp, cp);
			if (composed >= 0) {
				prev_cp = composed;
			} else if (prev_cc == 0 && cc == 0) {
				ret.push(prev_cp);
				prev_cp = cp;
			} else {
				stack.push(cp);
				prev_cc = cc;
			}
		}
	}
	if (prev_cp >= 0) {
		ret.push(prev_cp, ...stack);	
	}
	return ret;
}

// note: cps can be iterable
function nfd(cps) {
	return decomposed(cps).map(unpack_cp);
}
function nfc(cps) {
	return composed_from_decomposed(decomposed(cps));
}

//const t0 = performance.now();

const STOP = 0x2E;
const FE0F = 0xFE0F;
const STOP_CH = '.';
const UNIQUE_PH = 1;
const HYPHEN = 0x2D;

function read_set() {
	return new Set(read_sorted(r$1));
}
const MAPPED = new Map(read_mapped(r$1)); 
const IGNORED = read_set(); // ignored characters are not valid, so just read raw codepoints
/*
// direct include from payload is smaller that the decompression code
const FENCED = new Map(read_array_while(() => {
	let cp = r();
	if (cp) return [cp, read_str(r())];
}));
*/
// 20230217: we still need all CM for proper error formatting
// but norm only needs NSM subset that are potentially-valid
const CM = read_set();
const NSM = new Set(read_sorted(r$1).map(function(i) { return this[i]; }, [...CM]));
/*
const CM_SORTED = read_sorted(r);
const NSM = new Set(read_sorted(r).map(i => CM_SORTED[i]));
const CM = new Set(CM_SORTED);
*/
const ESCAPE = read_set(); // characters that should not be printed
const NFC_CHECK = read_set();
const CHUNKS = read_sorted_arrays(r$1);
function read_chunked() {
	// deduplicated sets + uniques
	return new Set([read_sorted(r$1).map(i => CHUNKS[i]), read_sorted(r$1)].flat(2));
}
const UNRESTRICTED = r$1();
const GROUPS = read_array_while(i => {
	// minifier property mangling seems unsafe
	// so these are manually renamed to single chars
	let N = read_array_while(r$1).map(x => x+0x60);
	if (N.length) {
		let R = i >= UNRESTRICTED; // first arent restricted
		N[0] -= 32; // capitalize
		N = str_from_cps(N);
		if (R) N=`Restricted[${N}]`;
		let P = read_chunked(); // primary
		let Q = read_chunked(); // secondary
		let V = [...P, ...Q].sort((a, b) => a-b); // derive: sorted valid
		//let M = r()-1; // combining mark
		let M = !r$1(); // not-whitelisted, check for NSM
		// code currently isn't needed
		/*if (M < 0) { // whitelisted
			M = new Map(read_array_while(() => {
				let i = r();
				if (i) return [V[i-1], read_array_while(() => {
					let v = read_array_while(r);
					if (v.length) return v.map(x => x-1);
				})];
			}));
		}*/
		return {N, P, M, R, V: new Set(V)};
	}
});
const WHOLE_VALID = read_set();
const WHOLE_MAP = new Map();
// decode compressed wholes
[...WHOLE_VALID, ...read_set()].sort((a, b) => a-b).map((cp, i, v) => {
	let d = r$1(); 
	let w = v[i] = d ? v[i-d] : {V: [], M: new Map()};
	w.V.push(cp); // add to member set
	if (!WHOLE_VALID.has(cp)) {
		WHOLE_MAP.set(cp, w);  // register with whole map
	}
});
// compute confusable-extent complements
for (let {V, M} of new Set(WHOLE_MAP.values())) {
	// connect all groups that have each whole character
	let recs = [];
	for (let cp of V) {
		let gs = GROUPS.filter(g => g.V.has(cp));
		let rec = recs.find(({G}) => gs.some(g => G.has(g)));
		if (!rec) {
			rec = {G: new Set(), V: []};
			recs.push(rec);
		}
		rec.V.push(cp);
		gs.forEach(g => rec.G.add(g));
	}
	// per character cache groups which are not a member of the extent
	let union = recs.flatMap(({G}) => [...G]);
	for (let {G, V} of recs) {
		let complement = new Set(union.filter(g => !G.has(g)));
		for (let cp of V) {
			M.set(cp, complement);
		}
	}
}
let union = new Set(); // exists in 1+ groups
let multi = new Set(); // exists in 2+ groups
for (let g of GROUPS) {
	for (let cp of g.V) {
		(union.has(cp) ? multi : union).add(cp);
	}
}
// dual purpose WHOLE_MAP: return placeholder if unique non-confusable
for (let cp of union) {
	if (!WHOLE_MAP.has(cp) && !multi.has(cp)) {
		WHOLE_MAP.set(cp, UNIQUE_PH);
	}
}
const VALID = new Set([...union, ...nfd(union)]); // possibly valid

// decode emoji
const EMOJI_SORTED = read_sorted(r$1); // temporary
//const EMOJI_SOLO = new Set(read_sorted(r).map(i => EMOJI_SORTED[i])); // not needed
const EMOJI_ROOT = read_emoji_trie([]);
function read_emoji_trie(cps) {
	let B = read_array_while(() => {
		let keys = read_sorted(r$1).map(i => EMOJI_SORTED[i]);
		if (keys.length) return read_emoji_trie(keys);
	}).sort((a, b) => b.Q.size - a.Q.size); // sort by likelihood
	let temp = r$1();
	let V = temp % 3; // valid (0 = false, 1 = true, 2 = weird)
	temp = (temp / 3)|0;
	let F = temp & 1; // allow FE0F
	temp >>= 1;
	let S = temp & 1; // save
	let C = temp & 2; // check
	return {B, V, F, S, C, Q: new Set(cps)};
}
//console.log(performance.now() - t0);

// free tagging system
class Emoji extends Array {
	get is_emoji() { return true; }
}

// create a safe to print string 
// invisibles are escaped
// leading cm uses placeholder
// quoter(cp) => string, eg. 3000 => "{3000}"
// note: in html, you'd call this function then replace [<>&] with entities
function safe_str_from_cps(cps, quoter = quote_cp) {
	//if (Number.isInteger(cps)) cps = [cps];
	//if (!Array.isArray(cps)) throw new TypeError(`expected codepoints`);
	let buf = [];
	if (is_combining_mark(cps[0])) buf.push('◌');
	let prev = 0;
	let n = cps.length;
	for (let i = 0; i < n; i++) {
		let cp = cps[i];
		if (should_escape(cp)) {
			buf.push(str_from_cps(cps.slice(prev, i)));
			buf.push(quoter(cp));
			prev = i + 1;
		}
	}
	buf.push(str_from_cps(cps.slice(prev, n)));
	return buf.join('');
}

// if escaped: {HEX}
//       else: "x" {HEX}
function quoted_cp(cp) {
	return (should_escape(cp) ? '' : `${bidi_qq(safe_str_from_cps([cp]))} `) + quote_cp(cp);
}

// 20230211: some messages can be mixed-directional and result in spillover
// use 200E after a quoted string to force the remainder of a string from 
// acquring the direction of the quote
// https://www.w3.org/International/questions/qa-bidi-unicode-controls#exceptions
function bidi_qq(s) {
	return `"${s}"\u200E`; // strong LTR
}

function check_label_extension(cps) {
	if (cps.length >= 4 && cps[2] == HYPHEN && cps[3] == HYPHEN) {
		throw new Error('invalid label extension');
	}
}
function check_leading_underscore(cps) {
	const UNDERSCORE = 0x5F;
	for (let i = cps.lastIndexOf(UNDERSCORE); i > 0; ) {
		if (cps[--i] !== UNDERSCORE) {
			throw new Error('underscore allowed only at start');
		}
	}
}
// check that a fenced cp is not leading, trailing, or touching another fenced cp
function check_fenced(cps) {
	let cp = cps[0];
	let prev = FENCED.get(cp);
	if (prev) throw error_placement(`leading ${prev}`);
	let n = cps.length;
	let last = -1; // prevents trailing from throwing
	for (let i = 1; i < n; i++) {
		cp = cps[i];
		let match = FENCED.get(cp);
		if (match) {
			// since cps[0] isn't fenced, cps[1] cannot throw
			if (last == i) throw error_placement(`${prev} + ${match}`);
			last = i + 1;
			prev = match;
		}
	}
	if (last == n) throw error_placement(`trailing ${prev}`);
}

// note: set(s) cannot be exposed because they can be modified
function is_combining_mark(cp) {
	return CM.has(cp);
}
function should_escape(cp) {
	return ESCAPE.has(cp);
}

function ens_normalize_fragment(frag, decompose) {
	let nf = decompose ? nfd : nfc;
	return frag.split(STOP_CH).map(label => str_from_cps(process(explode_cp(label), nf).flatMap(x => x.is_emoji ? filter_fe0f(x) : x))).join(STOP_CH);
}

function ens_normalize(name) {
	return flatten(ens_split(name));
}

function ens_beautify(name) {
	let split = ens_split(name, true);
	// this is experimental
	for (let {type, output, error} of split) {
		if (error) continue;

		// replace leading/trailing hyphen
		// 20230121: consider beautifing all or leading/trailing hyphen to unicode variant
		// not exactly the same in every font, but very similar: "-" vs "‐"
		/*
		const UNICODE_HYPHEN = 0x2010;
		// maybe this should replace all for visual consistancy?
		// `node tools/reg-count.js regex ^-\{2,\}` => 592
		//for (let i = 0; i < output.length; i++) if (output[i] == 0x2D) output[i] = 0x2010;
		if (output[0] == HYPHEN) output[0] = UNICODE_HYPHEN;
		let end = output.length-1;
		if (output[end] == HYPHEN) output[end] = UNICODE_HYPHEN;
		*/
		// 20230123: WHATWG URL uses "CheckHyphens" false
		// https://url.spec.whatwg.org/#idna

		// update ethereum symbol
		// ξ => Ξ if not greek
		if (type !== 'Greek') { 
			let prev = 0;
			while (true) {
				let next = output.indexOf(0x3BE, prev);
				if (next < 0) break;
				output[next] = 0x39E; 
				prev = next + 1;
			}
		}

		// 20221213: fixes bidi subdomain issue, but breaks invariant (200E is disallowed)
		// could be fixed with special case for: 2D (.) + 200E (LTR)
		//output.splice(0, 0, 0x200E);
	}
	return flatten(split);
}

function ens_split(name, preserve_emoji) {
	let offset = 0;
	// https://unicode.org/reports/tr46/#Validity_Criteria
	// 4.) "The label must not contain a U+002E ( . ) FULL STOP."
	return name.split(STOP_CH).map(label => {
		let input = explode_cp(label);
		let info = {
			input,
			offset, // codepoint, not substring!
		};
		offset += input.length + 1; // + stop
		let norm;
		try {
			// 1.) "The label must be in Unicode Normalization Form NFC"
			let tokens = info.tokens = process(input, nfc); // if we parse, we get [norm and mapped]
			let token_count = tokens.length;
			let type;
			if (!token_count) { // the label was effectively empty (could of had ignored characters)
				// 20230120: change to strict
				// https://discuss.ens.domains/t/ens-name-normalization-2nd/14564/59
				//norm = [];
				//type = 'None'; // use this instead of next match, "ASCII"
				throw new Error(`empty label`);
			} else {
				let chars = tokens[0];
				let emoji = token_count > 1 || chars.is_emoji;
				if (!emoji && chars.every(cp => cp < 0x80)) { // special case for ascii
					norm = chars;
					check_leading_underscore(norm);
					// only needed for ascii
					// 20230123: matches matches WHATWG, see note 3.3
					check_label_extension(norm);
					// cant have fenced
					// cant have cm
					// cant have wholes
					// see derive: "Fastpath ASCII"
					type = 'ASCII';
				} else {
					if (emoji) { // there is at least one emoji
						info.emoji = true; 
						chars = tokens.flatMap(x => x.is_emoji ? [] : x); // all of the nfc tokens concat together
					}
					norm = tokens.flatMap(x => !preserve_emoji && x.is_emoji ? filter_fe0f(x) : x);
					check_leading_underscore(norm);
					if (!chars.length) { // theres no text, just emoji
						type = 'Emoji';
					} else {
						// 5. "The label must not begin with a combining mark, that is: General_Category=Mark."
						if (CM.has(norm[0])) throw error_placement('leading combining mark');
						for (let i = 1; i < token_count; i++) { // we've already checked the first token
							let cps = tokens[i];
							if (!cps.is_emoji && CM.has(cps[0])) { // every text token has emoji neighbors, eg. EtEEEtEt...
								// bidi_qq() not needed since emoji is LTR and cps is a CM
								throw error_placement(`emoji + combining mark: "${str_from_cps(tokens[i-1])} + ${safe_str_from_cps([cps[0]])}"`); 
							}
						}
						check_fenced(norm);
						let unique = [...new Set(chars)];
						let [g] = determine_group(unique); // take the first match
						// see derive: "Matching Groups have Same CM Style"
						// alternative: could form a hybrid type: Latin/Japanese/...	
						check_group(g, chars); // need text in order
						check_whole(g, unique); // only need unique text (order would be required for multiple-char confusables)
						type = g.N;
						// 20230121: consider exposing restricted flag
						// it's simpler to just check for 'Restricted'
						// or even better: type.endsWith(']')
						//if (g.R) info.restricted = true;
					}
				}
			}
			info.type = type;
		} catch (err) {
			info.error = err; // use full error object
		}
		info.output = norm;
		return info;
	});
}

function check_whole(group, unique) {
	let maker;
	let shared = []; // TODO: can this be avoided?
	for (let cp of unique) {
		let whole = WHOLE_MAP.get(cp);
		if (whole === UNIQUE_PH) return; // unique, non-confusable
		if (whole) {
			let set = whole.M.get(cp); // groups which have a character that look-like this character
			maker = maker ? maker.filter(g => set.has(g)) : [...set];
			if (!maker.length) return; // confusable intersection is empty
		} else {
			shared.push(cp); 
		}
	}
	if (maker) {
		// we have 1+ confusable
		// check if any of the remaning groups
		// contain the shared characters too
		for (let g of maker) {
			if (shared.every(cp => g.V.has(cp))) {
				throw new Error(`whole-script confusable: ${group.N}/${g.N}`);
			}
		}
	}
}

// assumption: unique.size > 0
// returns list of matching groups
function determine_group(unique) {
	let groups = GROUPS;
	for (let cp of unique) {
		// note: we need to dodge CM that are whitelisted
		// but that code isn't currently necessary
		let gs = groups.filter(g => g.V.has(cp));
		if (!gs.length) {
			if (groups === GROUPS) {
				// the character was composed of valid parts
				// but it's NFC form is invalid
				throw error_disallowed(cp); // this should be rare
			} else {
				// there is no group that contains all these characters
				// throw using the highest priority group that matched
				// https://www.unicode.org/reports/tr39/#mixed_script_confusables
				throw error_group_member(groups[0], cp);
			}
		}
		groups = gs;
		if (gs.length == 1) break; // there is only one group left
	}
	// there are at least 1 group(s) with all of these characters
	return groups;
}

// throw on first error
function flatten(split) {
	return split.map(({input, error, output}) => {
		if (error) {
			// don't print label again if just a single label
			let msg = error.message;
			// bidi_qq() only necessary if msg is digits
			throw new Error(split.length == 1 ? msg : `Invalid label ${bidi_qq(safe_str_from_cps(input))}: ${msg}`); 
		}
		return str_from_cps(output);
	}).join(STOP_CH);
}

function error_disallowed(cp) {
	// TODO: add cp to error?
	return new Error(`disallowed character: ${quoted_cp(cp)}`); 
}
function error_group_member(g, cp) {
	let quoted = quoted_cp(cp);
	let gg = GROUPS.find(g => g.P.has(cp));
	if (gg) {
		quoted = `${gg.N} ${quoted}`;
	}
	return new Error(`illegal mixture: ${g.N} + ${quoted}`);
}
function error_placement(where) {
	return new Error(`illegal placement: ${where}`);
}

// assumption: cps.length > 0
// assumption: cps[0] isn't a CM
// assumption: the previous character isn't an emoji
function check_group(g, cps) {
	let {V, M} = g;
	for (let cp of cps) {
		if (!V.has(cp)) {
			// for whitelisted scripts, this will throw illegal mixture on invalid cm, eg. "e{300}{300}"
			// at the moment, it's unnecessary to introduce an extra error type
			// until there exists a whitelisted multi-character
			//   eg. if (M < 0 && is_combining_mark(cp)) { ... }
			// there are 3 cases:
			//   1. illegal cm for wrong group => mixture error
			//   2. illegal cm for same group => cm error
			//       requires set of whitelist cm per group: 
			//        eg. new Set([...g.V].flatMap(nfc).filter(cp => CM.has(cp)))
			//   3. wrong group => mixture error
			throw error_group_member(g, cp);
		}
	}
	//if (M >= 0) { // we have a known fixed cm count
	if (M) { // we need to check for NSM
		let decomposed = nfd(cps);
		for (let i = 1, e = decomposed.length; i < e; i++) { // see: assumption
			// 20230210: bugfix: using cps instead of decomposed h/t Carbon225
			/*
			if (CM.has(decomposed[i])) {
				let j = i + 1;
				while (j < e && CM.has(decomposed[j])) j++;
				if (j - i > M) {
					throw new Error(`too many combining marks: ${g.N} ${bidi_qq(str_from_cps(decomposed.slice(i-1, j)))} (${j-i}/${M})`);
				}
				i = j;
			}
			*/
			// 20230217: switch to NSM counting
			// https://www.unicode.org/reports/tr39/#Optional_Detection
			if (NSM.has(decomposed[i])) {
				let j = i + 1;
				for (let cp; j < e && NSM.has(cp = decomposed[j]); j++) {
					// a. Forbid sequences of the same nonspacing mark.
					for (let k = i; k < j; k++) { // O(n^2) but n < 100
						if (decomposed[k] == cp) {
							throw new Error(`non-spacing marks: repeated ${quoted_cp(cp)}`);
						}
					}
				}
				// parse to end so we have full nsm count
				// b. Forbid sequences of more than 4 nonspacing marks (gc=Mn or gc=Me).
				if (j - i > NSM_MAX) {
					// note: this slice starts with a base char or spacing-mark cm
					throw new Error(`non-spacing marks: too many ${bidi_qq(safe_str_from_cps(decomposed.slice(i-1, j)))} (${j-i}/${NSM_MAX})`);
				}
				i = j;
			}
		}
	}
	// *** this code currently isn't needed ***
	/*
	let cm_whitelist = M instanceof Map;
	for (let i = 0, e = cps.length; i < e; ) {
		let cp = cps[i++];
		let seqs = cm_whitelist && M.get(cp);
		if (seqs) { 
			// list of codepoints that can follow
			// if this exists, this will always be 1+
			let j = i;
			while (j < e && CM.has(cps[j])) j++;
			let cms = cps.slice(i, j);
			let match = seqs.find(seq => !compare_arrays(seq, cms));
			if (!match) throw new Error(`disallowed combining mark sequence: "${safe_str_from_cps([cp, ...cms])}"`);
			i = j;
		} else if (!V.has(cp)) {
			// https://www.unicode.org/reports/tr39/#mixed_script_confusables
			let quoted = quoted_cp(cp);
			for (let cp of cps) {
				let u = UNIQUE.get(cp);
				if (u && u !== g) {
					// if both scripts are restricted this error is confusing
					// because we don't differentiate RestrictedA from RestrictedB 
					if (!u.R) quoted = `${quoted} is ${u.N}`;
					break;
				}
			}
			throw new Error(`disallowed ${g.N} character: ${quoted}`);
			//throw new Error(`disallowed character: ${quoted} (expected ${g.N})`);
			//throw new Error(`${g.N} does not allow: ${quoted}`);
		}
	}
	if (!cm_whitelist) {
		let decomposed = nfd(cps);
		for (let i = 1, e = decomposed.length; i < e; i++) { // we know it can't be cm leading
			if (CM.has(decomposed[i])) {
				let j = i + 1;
				while (j < e && CM.has(decomposed[j])) j++;
				if (j - i > M) {
					throw new Error(`too many combining marks: "${str_from_cps(decomposed.slice(i-1, j))}" (${j-i}/${M})`);
				}
				i = j;
			}
		}
	}
	*/
}

// given a list of codepoints
// returns a list of lists, where emoji are a fully-qualified (as Array subclass)
// eg. explode_cp("abc💩d") => [[61, 62, 63], Emoji[1F4A9, FE0F], [64]]
function process(input, nf) {
	let ret = [];
	let chars = [];
	input = input.slice().reverse(); // flip so we can pop
	while (input.length) {
		let emoji = consume_emoji_reversed(input);
		if (emoji) {
			if (chars.length) {
				ret.push(nf(chars));
				chars = [];
			}
			ret.push(emoji);
		} else {
			let cp = input.pop();
			if (VALID.has(cp)) {
				chars.push(cp);
			} else {
				let cps = MAPPED.get(cp);
				if (cps) {
					chars.push(...cps);
				} else if (!IGNORED.has(cp)) {
					throw error_disallowed(cp);
				}
			}
		}
	}
	if (chars.length) {
		ret.push(nf(chars));
	}
	return ret;
}

function filter_fe0f(cps) {
	return cps.filter(cp => cp != FE0F);
}

// given array of codepoints
// returns the longest valid emoji sequence (or undefined if no match)
// *MUTATES* the supplied array
// allows optional FE0F
// disallows interleaved ignored characters
// fills (optional) eaten array with matched codepoints
function consume_emoji_reversed(cps, eaten) {
	let node = EMOJI_ROOT;
	let emoji;
	let saved;
	let stack = [];
	let pos = cps.length;
	if (eaten) eaten.length = 0; // clear input buffer (if needed)
	while (pos) {
		let cp = cps[--pos];
		node = node.B.find(x => x.Q.has(cp));
		if (!node) break;
		if (node.S) { // remember
			saved = cp;
		} else if (node.C) { // check exclusion
			if (cp === saved) break;
		}
		stack.push(cp);
		if (node.F) {
			stack.push(FE0F);
			if (pos > 0 && cps[pos - 1] == FE0F) pos--; // consume optional FE0F
		}
		if (node.V) { // this is a valid emoji (so far)
			emoji = conform_emoji_copy(stack, node);
			if (eaten) eaten.push(...cps.slice(pos).reverse()); // copy input (if needed)
			cps.length = pos; // truncate
		}
	}
	/*
	// *** this code currently isn't needed ***
	if (!emoji) {
		let cp = cps[cps.length-1];
		if (EMOJI_SOLO.has(cp)) {
			if (eaten) eaten.push(cp);
			emoji = Emoji.of(cp);
			cps.pop();
		}
	}
	*/
	return emoji;
}

// create a copy and fix any unicode quirks
function conform_emoji_copy(cps, node) {
	let copy = Emoji.from(cps); // copy stack
	if (node.V == 2) copy.splice(1, 1); // delete FE0F at position 1 (see: make.js)
	return copy;
}

// return all supported emoji as fully-qualified emoji 
// ordered by length then lexicographic 
function ens_emoji() {
	// *** this code currently isn't needed ***
	//let ret = [...EMOJI_SOLO].map(x => [x]);
	let ret = [];
	build(EMOJI_ROOT, []);
	return ret.sort(compare_arrays);
	function build(node, cps, saved) {
		if (node.S) { 
			saved = cps[cps.length-1];
		} else if (node.C) { 
			if (saved === cps[cps.length-1]) return;
		}
		if (node.F) cps.push(FE0F);
		if (node.V) ret.push(conform_emoji_copy(cps, node));
		for (let br of node.B) {
			for (let cp of br.Q) {
				build(br, [...cps, cp], saved);
			}
		}
	}
}

// ************************************************************
// tokenizer 

const TY_VALID = 'valid';
const TY_MAPPED = 'mapped';
const TY_IGNORED = 'ignored';
const TY_DISALLOWED = 'disallowed';
const TY_EMOJI = 'emoji';
const TY_NFC = 'nfc';
const TY_STOP = 'stop';

function ens_tokenize(name, {
	nf = true, // collapse unnormalized runs into a single token
} = {}) {
	let input = explode_cp(name).reverse();
	let eaten = [];
	let tokens = [];
	while (input.length) {		
		let emoji = consume_emoji_reversed(input, eaten);
		if (emoji) {
			tokens.push({type: TY_EMOJI, emoji, input: eaten.slice(), cps: filter_fe0f(emoji)});
		} else {
			let cp = input.pop();
			if (cp == STOP) {
				tokens.push({type: TY_STOP, cp});
			} else if (VALID.has(cp)) {
				tokens.push({type: TY_VALID, cps: [cp]});
			} else if (IGNORED.has(cp)) {
				tokens.push({type: TY_IGNORED, cp});
			} else {
				let cps = MAPPED.get(cp);
				if (cps) {
					tokens.push({type: TY_MAPPED, cp, cps: cps.slice()});
				} else {
					tokens.push({type: TY_DISALLOWED, cp});
				}
			}
		}
	}
	if (nf) {
		for (let i = 0, start = -1; i < tokens.length; i++) {
			let token = tokens[i];
			if (is_valid_or_mapped(token.type)) {
				if (requires_check(token.cps)) { // normalization might be needed
					let end = i + 1;
					for (let pos = end; pos < tokens.length; pos++) { // find adjacent text
						let {type, cps} = tokens[pos];
						if (is_valid_or_mapped(type)) {
							if (!requires_check(cps)) break;
							end = pos + 1;
						} else if (type !== TY_IGNORED) { // || type !== TY_DISALLOWED) { 
							break;
						}
					}
					if (start < 0) start = i;
					let slice = tokens.slice(start, end);
					let cps0 = slice.flatMap(x => is_valid_or_mapped(x.type) ? x.cps : []); // strip junk tokens
					let cps = nfc(cps0);
					if (compare_arrays(cps, cps0)) { // bundle into an nfc token
						tokens.splice(start, end - start, {
							type: TY_NFC, 
							input: cps0, // there are 3 states: tokens0 ==(process)=> input ==(nfc)=> tokens/cps
							cps, 
							tokens0: collapse_valid_tokens(slice),
							tokens: ens_tokenize(str_from_cps(cps), {nf: false})
						});
						i = start;
					} else { 
						i = end - 1; // skip to end of slice
					}
					start = -1; // reset
				} else {
					start = i; // remember last
				}
			} else if (token.type !== TY_IGNORED) { // 20221024: is this correct?
				start = -1; // reset
			}
		}
	}
	return collapse_valid_tokens(tokens);
}

function is_valid_or_mapped(type) {
	return type == TY_VALID || type == TY_MAPPED;
}

function requires_check(cps) {
	return cps.some(cp => NFC_CHECK.has(cp));
}

function collapse_valid_tokens(tokens) {
	for (let i = 0; i < tokens.length; i++) {
		if (tokens[i].type == TY_VALID) {
			let j = i + 1;
			while (j < tokens.length && tokens[j].type == TY_VALID) j++;
			tokens.splice(i, j - i, {type: TY_VALID, cps: tokens.slice(i, j).flatMap(x => x.cps)});
		}
	}
	return tokens;
}

exports.ens_beautify = ens_beautify;
exports.ens_emoji = ens_emoji;
exports.ens_normalize = ens_normalize;
exports.ens_normalize_fragment = ens_normalize_fragment;
exports.ens_split = ens_split;
exports.ens_tokenize = ens_tokenize;
exports.is_combining_mark = is_combining_mark;
exports.nfc = nfc;
exports.nfd = nfd;
exports.safe_str_from_cps = safe_str_from_cps;
exports.should_escape = should_escape;
