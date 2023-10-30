import { ControllerFunc, callContract } from './controllers';

/** ######### PORT ######### */
export const DEFAULT_RUN_PORT = 3002;
// root path 
export const DEFAULT_ROOT_PATH = '/fiscobcos';

/** ######### GET ROUTERS LIST ######### */
// test
export const getRoutes = [
    { path: '/test', params:''},
];

/** ######### POST ROUTERS LIST ######### */
export const postRoutes = [
    { path: '/getClientVersion', controllerFunc: callContract },
    { path: '/getBlockNumber', controllerFunc: callContract },
    { path: '/getPbftView', controllerFunc: callContract },
    { path: '/getSealerList', controllerFunc: callContract },
    { path: '/getObserverList', controllerFunc: callContract },
    { path: '/getBlockHeaderByNumber', controllerFunc: callContract },
    { path: '/getBlockHashByNumber', controllerFunc: callContract },
    { path: '/getTransactionByHash', controllerFunc: callContract },
    { path: '/getTransactinByBlockHashAndIndex', controllerFunc: callContract },
    { path: '/getTransactionByBlockNumberAndIndex', controllerFunc: callContract },
    { path: '/getPendingTransactions', controllerFunc: callContract },
    { path: '/getPendingTxSize', controllerFunc: callContract },
    { path: '/getCode', controllerFunc: callContract },
    { path: '/getTotalTransactionCount', controllerFunc: callContract },
    { path: '/getSystemConfigByKey', controllerFunc: callContract },
    { path: '/call', controllerFunc: callContract },
    { path: '/sendRawTransaction', controllerFunc: callContract },
    { path: '/sendRawTransactionAndGetProof', controllerFunc: callContract },
    { path: '/getTransactionByHashWithProof', controllerFunc: callContract },
    { path: '/getTransactionReceiptByHashWithProof', controllerFunc: callContract },
    { path: '/generateGroup', controllerFunc: callContract },
    { path: '/startGroup', controllerFunc: callContract },
    { path: '/stopGroup', controllerFunc: callContract },
    { path: '/removeGroup', controllerFunc: callContract },
    { path: '/recoverGroup', controllerFunc: callContract },
    { path: '/queryGroupStatus', controllerFunc: callContract },
    { path: '/getNodeInfo', controllerFunc: callContract },
    { path: '/getBatchReceiptsByBlockNumberAndRange', controllerFunc: callContract },
    { path: '/getBatchReceiptsByBlockHashAndRange', controllerFunc: callContract },
];
