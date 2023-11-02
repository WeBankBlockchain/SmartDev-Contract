type MetaParamsTypes = Array<string> | Array<Number> | Array<number |
    Record<string, string>
>

export type NetworkRequestBody = {
    // default 2.0 version
    jsonrpc: string | '2.0',
    method: string,
    // include [string, number, dict(string, string)]
    params?: MetaParamsTypes
}

export type NetworkRequestBodyFunc = (
    jsonrpc: string | null, 
    method: string, 
    params?: MetaParamsTypes
) => NetworkRequestBody;

export type JsonHeadersType = {
    'Content-Type': string;
}

export const JsonHeaders: JsonHeadersType = {
    'Content-Type': 'application/json'
};

export const NetworkRequestBodyImplementation = (): ((jsonrpc: string | null, method: string, params?: MetaParamsTypes) => NetworkRequestBody) => {
    return (jsonrpc: string | null, method: string, params?: MetaParamsTypes) => {
        const requestBody: NetworkRequestBody = {
            jsonrpc: jsonrpc ?? '2.0',
            method: method,
            params: params,
        };

        return requestBody;
    }
}

// Send transaction Response
export type TransactionResponse = {
    id: number,
    jsonrpc: string,
    result: string | Array<any> | Record<string, string> | any,
}

// See [https://fisco-bcos-documentation.readthedocs.io/zh_CN/release-2.8.0/docs/api.html#sendrawtransaction]
export type TransactionReceipt = {
    blockHash: string,
    blockNumber: string,
    contractAddress: string,
    from: string,
    gasUsed: string,
    input: string,
    logs: Array<any>,
    logsBloom: string,
    output: string,
    root: string,
    status: string,
    to: string,
    transactionHash: string,
    transactionIndex: string
}

export type TxProof = Array<Record<string, Array<string>>>;

export type TransactionResponseWithProof = TransactionResponse & TransactionReceipt;
export type TransactionResponseByHashWithProof = TransactionResponseWithProof & TxProof;

export type JsonResponse = TransactionResponseByHashWithProof | TransactionResponseWithProof | TxProof | TransactionResponse | string | any