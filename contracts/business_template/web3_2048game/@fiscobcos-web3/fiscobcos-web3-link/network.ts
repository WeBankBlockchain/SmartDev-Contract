import { fetcher } from '../fiscobcos-web3-utils/request';
// TODO: wtf it is ?
const DEFAULT_FLAG = 1;

export default class FiscoNetworkServer {
    private readonly _provide: string;
    public groudId: string;

    constructor(provide: string, groupId: string) {
        this._provide = provide;
        this.groudId = groupId;
    }
    
    getClientVersion() {}
    getBlockNumber() {}
    getPbftView() {}
    getSealerList() {}
    getObserverList() {}

    getBlockHeaderByNumber() {}
    getBlockHashByNumber() {}
    getTransactionByHash() {}
    getTransactinByBlockHashAndIndex() {}
    getTransactionByBlockNumberAndIndex() {}
    getPendingTransactions() {}
    getPendingTxSize() {}
    getCode() {}
    getTotalTransactionCount() {}
    getSystemConfigByKey() {}
    
    async call(caller: string, contractAddress: string, value?: string, data?: string):Promise<any> {
        const requestData = {
            method: 'call',
            params: [
                DEFAULT_FLAG, 
                {
                    'from': caller,
                    'to': contractAddress,
                    'value': value,
                    'data': data,
                },
            ],
            id: this.groudId,
        }
        console.log('requestData', JSON.stringify(requestData), this._provide);
        const resp = await fetcher(
            this._provide,
            {body: JSON.stringify(requestData)}
        );
        return resp;
    }

    async sendRawTransaction(params: string | any):Promise<any> {
        console.log('sendRawTransaction', params);
        const requestData = {
            method: 'sendRawTransaction',
            params: [
                DEFAULT_FLAG,
                params,
            ],
            id: this.groudId,
        };
        console.log('requestData', JSON.stringify(requestData), this._provide);
        const resp = await fetcher(
            this._provide,
            {body: JSON.stringify(requestData)}
        );
        return resp;
    }

    sendRawTransactionAndGetProof() {
    }
}