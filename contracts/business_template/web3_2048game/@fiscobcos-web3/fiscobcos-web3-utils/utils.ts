export function hexToNumber(hexNumber: any): number {
    return Number(BigInt(hexNumber));
}

export function hexArrayToNumber(hexNumbers: Array<any>): Array<number> {
    return hexNumbers.map(hexNumber => hexToNumber(hexNumber));
}
