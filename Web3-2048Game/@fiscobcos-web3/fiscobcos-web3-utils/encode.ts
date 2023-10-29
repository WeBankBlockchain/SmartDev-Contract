import { Interface, hexlify, serializeTransaction } from 'ethers/lib/utils';
import { ethers } from 'ethers';

export function encodeValue(value: number | string): string { 
    return `0x${value.toString(16)}`;
}

export function hexlifyData(data: any): string {
    return hexlify(data);
}

export function parseUnits(value: any): string {
    return parseUnits(value);
}

export function encodeHexData(data: string | any): string {
    return "0x" + Buffer.from(data, 'utf8').toString('hex');
}

export function encodeContractData(
    abi: string | Array<any> | any,
    funcName: string,
    args?: Array<any | string | number>
): string {
    const handleABI = typeof abi === 'string' ? JSON.parse(abi) : abi;
    // Ethers library: v6.7.x 
    const contractInstance = new Interface(handleABI);
    // data[0:4] funcName bytes(4 bytes)
    // data[5:]  other args bytes...
    const data = contractInstance.encodeFunctionData(funcName, args);
    return data;
}

export function decodeContractData(
    abi: string | Array<any> | any,
    funcName: string,
    data: string | any,
): any {
    const handleABI = typeof abi === 'string' ? JSON.parse(abi) : abi;
    const contractInterface = new Interface(handleABI);
    const decodedData = contractInterface.decodeFunctionResult('getAllPlayersScore', data);
    return decodedData;
}

/** Default sign raw transaction wallet */
const DEFAULT_SIGNER = '0x73da1bc338e365ad654180e3ae731a5fed4ffe55d7c91aab05cc9aeeab01ea23';

export interface RawTxBody {
    randomid?: number,
    gasPrice?: string,
    gasLimit?: string,    
    to: string;
    value?: string,
    data?: string,
    fiscoChainId?: string,
    groupId?: number,
    extraData?: string
}

/**
 * @function createCustomRawTransaction
 * @description Signs a custom raw transaction using a wallet. Note that this may not fully support the standard Ethereum transaction structure.
 * @param txnBody - The transaction body containing necessary fields for signing.
 * @param abi - The ABI of the contract you're interacting with.
 * @param funcName - The name of the function you want to call on the contract.
 * @param args - The arguments for the function you're calling.
 * @returns A promise that resolves to the signed transaction string.
 */
export async function createCustomRawTransaction(
    txnBody: RawTxBody,
    abi: string | Array<any> | any, 
    funcName: string,
    args?: Array<any | string | number>,
): Promise<string> {
    // Parse the ABI if it's a string, otherwise use it as is.
    const handleABI = typeof abi === 'string' ? JSON.parse(abi) : abi;

    // Create a wallet instance using the default signer's private key.
    const wallet = new ethers.Wallet(DEFAULT_SIGNER);

    // Populate the transaction body with necessary fields.
    txnBody.randomid = Math.random();
    txnBody.gasPrice = '30000000';
    txnBody.gasLimit = '30000000';
    txnBody.value = '0';
    txnBody.data = encodeContractData(handleABI, funcName, args);
    txnBody.fiscoChainId = '1'; // Assuming '1' is the chainId for your network.
    txnBody.groupId = 1;   // Assuming '1' is the groupId for your network.
    txnBody.extraData = txnBody.extraData ?? '';

    // Sign the transaction using the wallet instance.
    const signedTransaction = await wallet.signTransaction(txnBody);

    return signedTransaction;
}
