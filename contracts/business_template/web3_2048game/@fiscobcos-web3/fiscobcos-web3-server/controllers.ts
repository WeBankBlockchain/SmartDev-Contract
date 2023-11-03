import { Request, Response, NextFunction } from 'express';
import { request } from '../fiscobcos-web3-utils/request';
import { JsonHeaders, NetworkRequestBodyImplementation } from './types';

const DEFAULT_JSON_RPC_VERSION: string = '2.0';

/**
 * @notice          All fisco bcos features interfaces payloads 
 *                  See-https://fisco-bcos-documentation.readthedocs.io/zh_CN/release-2.8.0/docs/api.html#
 * @constant        FiscoRequestNetworkPayloads
 * @description     A collection of payloads for Fisco network requests.
 */
const FiscoRequestNetworkPayloads = {
    /** Payload for retrieving the client version */
    getClientVersionPayload: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getClientVersion'),

    /** Payload for retrieving the block number */
    getBlockNumber: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getBlockNumber'),

    /** Payload for retrieving the Pbft view */
    getPbftView: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getPbftView'),

    /** Payload for retrieving the list of sealers */
    getSealerList: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getSealerList'),

    /** Payload for retrieving the list of observers */
    getObserverList: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getObserverList'),

    /** Payload for retrieving the block header by number */
    getBlockHeaderByNumber: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getBlockHeaderByNumber'),

    /** Payload for retrieving the block hash by number */
    getBlockHashByNumber: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getBlockHashByNumber'),

    /** Payload for retrieving a transaction by its hash */
    getTransactionByHash: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getTransactionByHash'),

    /** Payload for retrieving a transaction by block hash and index */
    getTransactinByBlockHashAndIndex: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getTransactinByBlockHashAndIndex'),

    /** Payload for retrieving a transaction by block number and index */
    getTransactionByBlockNumberAndIndex: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getTransactionByBlockNumberAndIndex'),

    /** Payload for retrieving pending transactions */
    getPendingTransactions: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getPendingTransactions'),

    /** Payload for retrieving the size of pending transactions */
    getPendingTxSize: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getPendingTxSize'),

    /** Payload for retrieving the code */
    getCode: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getCode'),

    /** Payload for retrieving the total transaction count */
    getTotalTransactionCount: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getTotalTransactionCount'),

    /** Payload for retrieving system configuration by key */
    getSystemConfigByKey: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getSystemConfigByKey'),

    /** Payload for making a call */
    call: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'call'),

    /** Payload for sending a raw transaction */
    sendRawTransaction: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'sendRawTransaction'),

    /** Payload for sending a raw transaction and getting its proof */
    sendRawTransactionAndGetProof: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'sendRawTransactionAndGetProof'),

    /** Payload for retrieving a transaction by hash with its proof */
    getTransactionByHashWithProof: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getTransactionByHashWithProof'),

    /** Payload for retrieving a transaction receipt by hash with its proof */
    getTransactionReceiptByHashWithProof: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getTransactionReceiptByHashWithProof'),

    /** Payload for generating a group */
    generateGroup: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'generateGroup'),

    /** Payload for starting a group */
    startGroup: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'startGroup'),

    /** Payload for stopping a group */
    stopGroup: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'stopGroup'),

    /** Payload for removing a group */
    removeGroup: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'removeGroup'),

    /** Payload for recovering a group */
    recoverGroup: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'recoverGroup'),

    /** Payload for querying the status of a group */
    queryGroupStatus: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'queryGroupStatus'),

    /** Payload for retrieving node information */
    getNodeInfo: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getNodeInfo'),

    /** Payload for retrieving batch receipts by block number and range */
    getBatchReceiptsByBlockNumberAndRange: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getBatchReceiptsByBlockNumberAndRange'),

    /** Payload for retrieving batch receipts by block hash and range */
    getBatchReceiptsByBlockHashAndRange: NetworkRequestBodyImplementation()(DEFAULT_JSON_RPC_VERSION, 'getBatchReceiptsByBlockHashAndRange'),
}

/** ######### CONTROLLER FUNCTION EFFECT ######### */
export type ControllerFunc = (res: Request, req: Response, next?: NextFunction) => void;

/**
 * @function callContract
 * @description  Initiates any call to the smart contract based on the provided method.
 * @param req  - The Express request object containing the method type and other parameters.
 * @param res  - The Express response object.
 * @param next - The next middleware function in the Express pipeline.
 * @returns void
 */
export const callContract: ControllerFunc = async (req: Request, res: Response, next?: NextFunction) => {
    
    type FiscoMethod = keyof typeof FiscoRequestNetworkPayloads;
    const { method, params, id:value  }: any = req.body;
    const id = Number(value);

    // Check if the method is valid
    if (!(FiscoRequestNetworkPayloads as any)[method]) {
        res.status(400).json({ error: 'Invalid method' });
        return;
    }

    // Construct the request body for the smart contract call
    const requestBody = { ...(FiscoRequestNetworkPayloads as any)[method], params, id };

    console.log("methodmethodmethodmethodmethodmethod",requestBody );

    // Make the request to the specified endpoint
    const resp = await request(
        'http://localhost:8545',
        "POST",
        JsonHeaders,
        JSON.stringify(requestBody),
    );
    console.log("callContractResponseData", resp.data);

    // Send the response back to the client
    /*
    let result;
    if (method === 'getBatchReceiptsByBlockHashAndRange') {
        const receipt: TransactionResponse = resp.data;
        result = receipt;
    } else if (method === 'getBatchReceiptsByBlockNumberAndRange') {
        const receipt: TransactionResponse = resp.data;
        result = receipt;
    } else if (method === 'getNodeInfo') {
        const receipt: TransactionResponse = resp.data;
        result = receipt;
    } else {
        const receipt: TransactionResponse = resp.data;
        result = receipt;
    }*/

    // Using res.json() directly sends a JSON response
    res.json(resp.data);
};