# ens-normalize.js
0-dependancy Compact ES6 [Ethereum Name Service](https://ens.domains/) (ENS) Name Normalizer that works in the browser.

* Follows [ENS Name Normalization Standard](https://github.com/adraffy/ensip-15/blob/master/ens-improvement-proposals/ensip-15-normalization-standard.md)
* Additional Implementations:
	* Python — [namehash/ens-normalize-python](https://github.com/namehash/ens-normalize-python)
* [Passes **100%**](https://adraffy.github.io/ens-normalize.js/test/validate.html) Validation Tests
* Custom [`NFC`](https://unicode.org/reports/tr15/) Implementation (or use native)
	* [Passes **100%**](https://adraffy.github.io/ens-normalize.js/test/report-nf.html) Unicode `15.0.0` [Normalization Tests](https://www.unicode.org/Public/15.0.0/ucd/NormalizationTest.txt)
* Minified File Sizes: 
	* [`27KB`](./dist/index-xnf.min.js) — native `NFC` via [nf-native.js](./src/nf-native.js) using `String.normalize()`
	* [`36KB` **Default** ](./dist/index.min.js) — custom `NFC` via [nf.js](./src/nf.js)
	* [`42KB`](./dist/all.min.js) *Everything!* — custom `NFC` + sub-libraries: [parts.js](./src/parts.js), [utils.js](./src/utils.js)
* Included Apps:
	* [**Resolver Demo**](https://adraffy.github.io/ens-normalize.js/test/resolver.html) ⭐
	* [Character Viewer](https://adraffy.github.io/ens-normalize.js/test/chars.html)
	* [Supported Emoji](https://adraffy.github.io/ens-normalize.js/test/emoji.html)
	* [Confused Explainer](https://adraffy.github.io/ens-normalize.js/test/confused.html)
* External Apps:
	* [Recent Registrations](https://raffy.antistupid.com/eth/ens-regs.html)
	* [Emoji Frequency Explorer](https://raffy.antistupid.com/eth/ens-emoji-freq.html)
	* [ENS+NFT Matcher](https://raffy.antistupid.com/eth/ens-nft-matcher.html)
	* [Batch Resolver](https://raffy.antistupid.com/eth/ens-batch-resolver.html)
	* [Punycode Coder](https://adraffy.github.io/punycode.js/test/demo.html)
* [Breakdown Reports:](https://adraffy.github.io/ens-norm-tests/test-breakdown/output/)
	* [Disallowed Characters](https://adraffy.github.io/ens-norm-tests/test-breakdown/output/disallowed.html)
	* [Different Norm](https://adraffy.github.io/ens-norm-tests/test-breakdown/output/diff.html)
	* [Illegal Mixtures](https://adraffy.github.io/ens-norm-tests/test-breakdown/output/mixtures.html)
	* [Whole-script Confusables](https://adraffy.github.io/ens-norm-tests/test-breakdown/output/wholes.html)
	* [Illegal Placement](https://adraffy.github.io/ens-norm-tests/test-breakdown/output/placement.html)
	* [Non-spacing Marks](https://adraffy.github.io/ens-norm-tests/test-breakdown/output/nsm.html)

```Javascript
import {ens_normalize} from '@adraffy/ens-normalize'; // or require()
// npm i @adraffy/ens-normalize
// browser: https://cdn.jsdelivr.net/npm/@adraffy/ens-normalize@latest/dist/index.min.js

// *** ALL errors thrown by this library are safe to print ***
// - characters are shown as {HEX} if should_escape()
// - potentially different bidi directions inside "quotes"
// - 200E is used near "quotes" to prevent spillover
// - an "error type" can be extracted by slicing up to the first (:)

// string -> string
// throws on invalid names
// output ready for namehash
let normalized = ens_normalize('RaFFY🚴‍♂️.eTh');
// => "raffy🚴‍♂.eth"

// note: does not enforce .eth TLD 3-character minimum
```

Format names with fully-qualified emoji:
```Javascript
// works like ens_normalize()
// output ready for display
let pretty = ens_beautify('1⃣2⃣.eth'); 
// => "1️⃣2️⃣.eth"

// note: normalization is unchanged:
// ens_normalize(ens_beautify(x)) == ens_normalize(x)
```

Normalize name fragments for [substring search](./test/fragment.js):
```Javascript
// these fragments fail ens_normalize() 
// but will normalize fine as fragments
let frag1 = ens_normalize_fragment('AB--');    // error: label ext
let frag2 = ens_normalize_fragment('\u{303}'); // error: leading cm
let frag3 = ens_normalize_fragment('οо');      // error: mixture
```

Input-based tokenization:
```Javascript
// string -> Token[]
// never throws
let tokens = ens_tokenize('_R💩\u{FE0F}a\u{FE0F}\u{304}\u{AD}./');
// [
//     { type: 'valid', cp: [ 95 ] }, // valid (as-is)
//     {
//         type: 'mapped', 
//         cp: 82,         // input
//         cps: [ 114 ]    // output
//     }, 
//     { 
//         type: 'emoji',
//         input: Emoji(2) [ 128169, 65039 ],  // input 
//         emoji: [ 128169, 65039 ],           // fully-qualified
//         cps: Emoji(1) [ 128169 ]            // output (normalized)
//     },
//     {
//         type: 'nfc',
//         input: [ 97, 772 ],  // input  (before nfc)
//         tokens0: [           // tokens (before nfc)
//             { type: 'valid', cps: [ 97 ] },
//             { type: 'ignored', cp: 65039 },
//             { type: 'valid', cps: [ 772 ] }
//         ],
//         cps: [ 257 ],        // output (after nfc)
//         tokens: [            // tokens (after nfc)
//             { type: 'valid', cps: [ 257 ] }
//         ]
//     },
//     { type: 'ignored', cp: 173 },
//     { type: 'stop', cp: 46 },
//     { type: 'disallowed', cp: 47 }
// ]

// note: if name is normalizable, then:
// ens_normalize(ens_tokenize(name).map(token => {
//     ** convert valid/mapped/nfc/stop to string **
// }).join('')) == ens_normalize(name)
```

Output-based tokenization:
```Javascript
// string -> Label[]
// never throws
let labels = ens_split('💩Raffy.eth_');
// [
//   {
//     input: [ 128169, 82, 97, 102, 102, 121 ],  
//     offset: 0, // index of codepoint, not substring index!
//                // (corresponding length can be inferred from input)
//     tokens: [
//       Emoji(2) [ 128169, 65039 ],   // emoji
//       [ 114, 97, 102, 102, 121 ]    // nfc-text
//     ],
//     output: [ 128169, 114, 97, 102, 102, 121 ],
//     emoji: true,
//     type: 'Latin'
//   },
//   {
//     input: [ 101, 116, 104, 95 ],
//     offset: 7,
//     tokens: [ [ 101, 116, 104, 95 ] ],
//     output: [ 101, 116, 104, 95 ],
//     error: Error('underscore allowed only at start')
//   }
// ]
```

Generate a sorted array of supported emoji codepoints:
```Javascript
// () -> number[][]
console.log(ens_emoji());
// [
//     [ 2764 ],
//     [ 128169, 65039 ],
//     [ 128105, 127997, 8205, 9877, 65039 ],
//     ...
// ]
```

Determine if a character shouldn't be printed directly:
```Javascript
// number -> bool
console.log(should_escape(0x202E)); // eg. RIGHT-TO-LEFT OVERRIDE => true
```

Determine if a character is a combining mark:
```Javascript
// number -> bool
console.log(is_combining_mark(0x20E3)); // eg. COMBINING ENCLOSING KEYCAP => true
```

## Build

* `git clone` this repo, then `npm install` 
* Follow instructions in [/derive/](./derive/) to generate data files
	* `npm run derive` 
		* [spec.json](./derive/output/spec.json)
		* [nf.json](./derive/output/nf.json)
		* [nf-tests.json](./derive/output/nf-tests.json)
* `npm run make` — compress data files from `/derive/output/`
	* [include-ens.js](./src/include-ens.js)
	* [include-nf.js](./src/include-nf.js)
* Follow instructions in [/validate/](./validate/) to generate validation tests
	* `npm run validate`
		* [tests.json](./validate/tests.json)
* `npm run test` — perform validation tests
* `npm run build` — create `/dist/`
* `npm run rebuild` — run all the commands above
* `npm run order` — create optimal group ordering and rebuild again

### Publishing to NPM

This project uses `.js` instead of `.mjs` so [package.json](./package.json) uses `type: module`.  To avoid bundling issues, `type` is [dropped during packing](./src/prepost.js).  `pre/post` hooks aren't used because they're buggy.
* `npm run pack` instead of `npm pack`
* `npm run pub` instead of `npm publish`
