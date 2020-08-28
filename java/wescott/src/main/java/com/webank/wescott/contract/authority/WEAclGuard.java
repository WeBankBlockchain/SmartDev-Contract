package com.webank.wescott.contract.authority;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import org.fisco.bcos.channel.client.TransactionSucCallback;
import org.fisco.bcos.channel.event.filter.EventLogPushWithDecodeCallback;
import org.fisco.bcos.web3j.abi.EventEncoder;
import org.fisco.bcos.web3j.abi.FunctionReturnDecoder;
import org.fisco.bcos.web3j.abi.TypeReference;
import org.fisco.bcos.web3j.abi.datatypes.Address;
import org.fisco.bcos.web3j.abi.datatypes.Bool;
import org.fisco.bcos.web3j.abi.datatypes.Event;
import org.fisco.bcos.web3j.abi.datatypes.Function;
import org.fisco.bcos.web3j.abi.datatypes.Type;
import org.fisco.bcos.web3j.abi.datatypes.Utf8String;
import org.fisco.bcos.web3j.abi.datatypes.generated.Bytes4;
import org.fisco.bcos.web3j.crypto.Credentials;
import org.fisco.bcos.web3j.protocol.Web3j;
import org.fisco.bcos.web3j.protocol.core.RemoteCall;
import org.fisco.bcos.web3j.protocol.core.methods.response.Log;
import org.fisco.bcos.web3j.protocol.core.methods.response.TransactionReceipt;
import org.fisco.bcos.web3j.tuples.generated.Tuple1;
import org.fisco.bcos.web3j.tuples.generated.Tuple2;
import org.fisco.bcos.web3j.tuples.generated.Tuple3;
import org.fisco.bcos.web3j.tx.Contract;
import org.fisco.bcos.web3j.tx.TransactionManager;
import org.fisco.bcos.web3j.tx.gas.ContractGasProvider;
import org.fisco.bcos.web3j.tx.txdecode.TransactionDecoder;

/**
 * <p>Auto generated code.
 * <p><strong>Do not modify!</strong>
 * <p>Please use the <a href="https://docs.web3j.io/command_line.html">web3j command line tools</a>,
 * or the org.fisco.bcos.web3j.codegen.SolidityFunctionWrapperGenerator in the 
 * <a href="https://github.com/web3j/web3j/tree/master/codegen">codegen module</a> to update.
 *
 * <p>Generated with web3j version none.
 */
@SuppressWarnings("unchecked")
public class WEAclGuard extends Contract {
    public static String BINARY = "608060405234801561001057600080fd5b50336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506100693361006e640100000000026401000000009004565b61022d565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16141515610158576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260268152602001807f57454261736963417574683a206f6e6c79206f776e657220697320617574686f81526020017f72697a65642e000000000000000000000000000000000000000000000000000081525060400191505060405180910390fd5b806000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055503073ffffffffffffffffffffffffffffffffffffffff166000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff167fe9babf7227595470b3626ae5ccf58b60155b302e762cffc79c52bfd8a800c53c60405160405180910390a450565b611e8c8061023c6000396000f3006080604052600436106100e6576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806313af4035146100eb5780631cbfa2cd1461012e578063214569b7146101a95780632936ff2b1461020c5780633f81a192146102755780637a9e5e4b146102cc5780639c21e9091461030f578063a2a52fd01461039b578063b2bdfa7b14610456578063b7009613146104ad578063bfc019c614610551578063c2205ee1146105dd578063d12d910214610634578063d9972b961461069d578063de63e70f14610721578063ff929a521461079c575b600080fd5b3480156100f757600080fd5b5061012c600480360381019080803573ffffffffffffffffffffffffffffffffffffffff1690602001909291905050506107ff565b005b34801561013a57600080fd5b506101a7600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff1690602001909291908035906020019082018035906020019190919293919293905050506109be565b005b3480156101b557600080fd5b5061020a600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff1690602001909291905050506109eb565b005b34801561021857600080fd5b50610221610a39565b60405180827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19167bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916815260200191505060405180910390f35b34801561028157600080fd5b5061028a610a7c565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b3480156102d857600080fd5b5061030d600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610abf565b005b34801561031b57600080fd5b50610399600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080357bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19169060200190929190505050610c89565b005b3480156103a757600080fd5b50610402600480360381019080803590602001908201803590602001908080601f0160208091040260200160405190810160405280939291908181526020018383808284378201915050505050509192919290505050610e8e565b60405180827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19167bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916815260200191505060405180910390f35b34801561046257600080fd5b5061046b610efa565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b3480156104b957600080fd5b50610537600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080357bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19169060200190929190505050610f1f565b604051808215151515815260200191505060405180910390f35b34801561055d57600080fd5b506105db600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080357bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19169060200190929190505050611917565b005b3480156105e957600080fd5b506105f2611b1c565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34801561064057600080fd5b50610649611b42565b60405180827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19167bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916815260200191505060405180910390f35b3480156106a957600080fd5b50610707600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080357bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19169060200190929190505050611b6d565b604051808215151515815260200191505060405180910390f35b34801561072d57600080fd5b5061079a600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803590602001908201803590602001919091929391929390505050611de5565b005b3480156107a857600080fd5b506107fd600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050611e12565b005b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161415156108e9576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260268152602001807f57454261736963417574683a206f6e6c79206f776e657220697320617574686f81526020017f72697a65642e000000000000000000000000000000000000000000000000000081525060400191505060405180910390fd5b806000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055503073ffffffffffffffffffffffffffffffffffffffff166000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff167fe9babf7227595470b3626ae5ccf58b60155b302e762cffc79c52bfd8a800c53c60405160405180910390a450565b6109e584848484604051808383808284378201915050925050506040518091039020610c89565b50505050565b610a3582827fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7c010000000000000000000000000000000000000000000000000000000002611917565b5050565b7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7c01000000000000000000000000000000000000000000000000000000000281565b7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6c01000000000000000000000000026c01000000000000000000000000900481565b610aed336000357fffffffff0000000000000000000000000000000000000000000000000000000016611b6d565b1515610b61576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260198152602001807f5745417574683a206973206e6f7420617574686f72697a65640000000000000081525060200191505060405180910390fd5b80600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508073ffffffffffffffffffffffffffffffffffffffff167ff54834e369087f9b17bd2b73baa91085cfff591ffb3c11d2622f6cf92ae4cf6a336000357fffffffff0000000000000000000000000000000000000000000000000000000016604051808373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19167bffffffffffffffffffffffffffffffffffffffffffffffffffffffff191681526020019250505060405180910390a250565b610cb7336000357fffffffff0000000000000000000000000000000000000000000000000000000016611b6d565b1515610d2b576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260198152602001807f5745417574683a206973206e6f7420617574686f72697a65640000000000000081525060200191505060405180910390fd5b6000600260008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000837bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19167bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916815260200190815260200160002060006101000a81548160ff021916908315150217905550807bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19168273ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff167ff59111baa782faa3d5c33db8fb4d455d406e73edcf0a852a70caa6c5843eae4c60405160405180910390a4505050565b6000816040518082805190602001908083835b602083101515610ec65780518252602082019150602081019050602083039250610ea1565b6001836020036101000a03801982511681845116808217855250505050505090500191505060405180910390209050919050565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6000600260008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000837bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19167bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916815260200190815260200160002060009054906101000a900460ff16806111195750600260008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7c0100000000000000000000000000000000000000000000000000000000027bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19167bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916815260200190815260200160002060009054906101000a900460ff165b806112385750600260008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6c01000000000000000000000000026c01000000000000000000000000900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000837bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19167bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916815260200190815260200160002060009054906101000a900460ff165b806113965750600260008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6c01000000000000000000000000026c01000000000000000000000000900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7c0100000000000000000000000000000000000000000000000000000000027bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19167bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916815260200190815260200160002060009054906101000a900460ff165b806114b55750600260007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6c01000000000000000000000000026c01000000000000000000000000900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000837bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19167bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916815260200190815260200160002060009054906101000a900460ff165b806116135750600260007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6c01000000000000000000000000026c01000000000000000000000000900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7c0100000000000000000000000000000000000000000000000000000000027bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19167bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916815260200190815260200160002060009054906101000a900460ff165b806117715750600260007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6c01000000000000000000000000026c01000000000000000000000000900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6c01000000000000000000000000026c01000000000000000000000000900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000837bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19167bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916815260200190815260200160002060009054906101000a900460ff165b8061190e5750600260007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6c01000000000000000000000000026c01000000000000000000000000900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6c01000000000000000000000000026c01000000000000000000000000900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7c0100000000000000000000000000000000000000000000000000000000027bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19167bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916815260200190815260200160002060009054906101000a900460ff165b90509392505050565b611945336000357fffffffff0000000000000000000000000000000000000000000000000000000016611b6d565b15156119b9576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260198152602001807f5745417574683a206973206e6f7420617574686f72697a65640000000000000081525060200191505060405180910390fd5b6001600260008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000837bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19167bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916815260200190815260200160002060006101000a81548160ff021916908315150217905550807bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19168273ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff167fcfe11ceefe6478bea2ebfcd2f48064508489b9f54449e4bc1a2bd2afa359e01b60405160405180910390a4505050565b600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b600080357fffffffff0000000000000000000000000000000000000000000000000000000016905090565b60003073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff161415611bac5760019050611ddf565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff161415611c0a5760019050611ddf565b600073ffffffffffffffffffffffffffffffffffffffff16600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff161415611c6a5760009050611ddf565b600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663b70096138430856040518463ffffffff167c0100000000000000000000000000000000000000000000000000000000028152600401808473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020018373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19167bffffffffffffffffffffffffffffffffffffffffffffffffffffffff191681526020019350505050602060405180830381600087803b158015611da157600080fd5b505af1158015611db5573d6000803e3d6000fd5b505050506040513d6020811015611dcb57600080fd5b810190808051906020019092919050505090505b92915050565b611e0c84848484604051808383808284378201915050925050506040518091039020611917565b50505050565b611e5c82827fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7c010000000000000000000000000000000000000000000000000000000002610c89565b50505600a165627a7a723058204f6d7a9c985c7f9f6ddf197f689804819c6873b7ebfbb59ecc207af37d71c8b40029";

    public static final String ABI = "[{\"constant\":false,\"inputs\":[{\"name\":\"owner\",\"type\":\"address\"}],\"name\":\"setOwner\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"src\",\"type\":\"address\"},{\"name\":\"dst\",\"type\":\"address\"},{\"name\":\"sig\",\"type\":\"string\"}],\"name\":\"forbid\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"src\",\"type\":\"address\"},{\"name\":\"dst\",\"type\":\"address\"}],\"name\":\"permitAny\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"ANY_SIG\",\"outputs\":[{\"name\":\"\",\"type\":\"bytes4\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"ANY_ADDRESS\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"authority\",\"type\":\"address\"}],\"name\":\"setAuthority\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"src\",\"type\":\"address\"},{\"name\":\"dst\",\"type\":\"address\"},{\"name\":\"sig\",\"type\":\"bytes4\"}],\"name\":\"forbid\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"sig\",\"type\":\"string\"}],\"name\":\"getSigFromStr\",\"outputs\":[{\"name\":\"\",\"type\":\"bytes4\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"_owner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"src\",\"type\":\"address\"},{\"name\":\"dst\",\"type\":\"address\"},{\"name\":\"sig\",\"type\":\"bytes4\"}],\"name\":\"canCall\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"src\",\"type\":\"address\"},{\"name\":\"dst\",\"type\":\"address\"},{\"name\":\"sig\",\"type\":\"bytes4\"}],\"name\":\"permit\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"_authority\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"getSig\",\"outputs\":[{\"name\":\"\",\"type\":\"bytes4\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"src\",\"type\":\"address\"},{\"name\":\"sig\",\"type\":\"bytes4\"}],\"name\":\"isAuthorized\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"src\",\"type\":\"address\"},{\"name\":\"dst\",\"type\":\"address\"},{\"name\":\"sig\",\"type\":\"string\"}],\"name\":\"permit\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"src\",\"type\":\"address\"},{\"name\":\"dst\",\"type\":\"address\"}],\"name\":\"forbidAny\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"src\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"dst\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"sig\",\"type\":\"bytes4\"}],\"name\":\"LogPermit\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"src\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"dst\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"sig\",\"type\":\"bytes4\"}],\"name\":\"LogForbid\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"authority\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"from\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"sig\",\"type\":\"bytes4\"}],\"name\":\"LogSetAuthority\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"oldOwner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"contractAddress\",\"type\":\"address\"}],\"name\":\"LogSetOwner\",\"type\":\"event\"}]";

    public static final TransactionDecoder transactionDecoder = new TransactionDecoder(ABI, BINARY);

    public static final String FUNC_SETOWNER = "setOwner";

    public static final String FUNC_FORBID = "forbid";

    public static final String FUNC_PERMITANY = "permitAny";

    public static final String FUNC_ANY_SIG = "ANY_SIG";

    public static final String FUNC_ANY_ADDRESS = "ANY_ADDRESS";

    public static final String FUNC_SETAUTHORITY = "setAuthority";

    public static final String FUNC_GETSIGFROMSTR = "getSigFromStr";

    public static final String FUNC__OWNER = "_owner";

    public static final String FUNC_CANCALL = "canCall";

    public static final String FUNC_PERMIT = "permit";

    public static final String FUNC__AUTHORITY = "_authority";

    public static final String FUNC_GETSIG = "getSig";

    public static final String FUNC_ISAUTHORIZED = "isAuthorized";

    public static final String FUNC_FORBIDANY = "forbidAny";

    public static final Event LOGPERMIT_EVENT = new Event("LogPermit", 
            Arrays.<TypeReference<?>>asList(new TypeReference<Address>(true) {}, new TypeReference<Address>(true) {}, new TypeReference<Bytes4>(true) {}));
    ;

    public static final Event LOGFORBID_EVENT = new Event("LogForbid", 
            Arrays.<TypeReference<?>>asList(new TypeReference<Address>(true) {}, new TypeReference<Address>(true) {}, new TypeReference<Bytes4>(true) {}));
    ;

    public static final Event LOGSETAUTHORITY_EVENT = new Event("LogSetAuthority", 
            Arrays.<TypeReference<?>>asList(new TypeReference<Address>(true) {}, new TypeReference<Address>() {}, new TypeReference<Bytes4>() {}));
    ;

    public static final Event LOGSETOWNER_EVENT = new Event("LogSetOwner", 
            Arrays.<TypeReference<?>>asList(new TypeReference<Address>(true) {}, new TypeReference<Address>(true) {}, new TypeReference<Address>(true) {}));
    ;

    @Deprecated
    protected WEAclGuard(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    protected WEAclGuard(String contractAddress, Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        super(BINARY, contractAddress, web3j, credentials, contractGasProvider);
    }

    @Deprecated
    protected WEAclGuard(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    protected WEAclGuard(String contractAddress, Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        super(BINARY, contractAddress, web3j, transactionManager, contractGasProvider);
    }

    public static TransactionDecoder getTransactionDecoder() {
        return transactionDecoder;
    }

    public RemoteCall<TransactionReceipt> setOwner(String owner) {
        final Function function = new Function(
                FUNC_SETOWNER, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(owner)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public void setOwner(String owner, TransactionSucCallback callback) {
        final Function function = new Function(
                FUNC_SETOWNER, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(owner)), 
                Collections.<TypeReference<?>>emptyList());
        asyncExecuteTransaction(function, callback);
    }

    public String setOwnerSeq(String owner) {
        final Function function = new Function(
                FUNC_SETOWNER, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(owner)), 
                Collections.<TypeReference<?>>emptyList());
        return createTransactionSeq(function);
    }

    public Tuple1<String> getSetOwnerInput(TransactionReceipt transactionReceipt) {
        String data = transactionReceipt.getInput().substring(10);
        final Function function = new Function(FUNC_SETOWNER, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        List<Type> results = FunctionReturnDecoder.decode(data, function.getOutputParameters());;
        return new Tuple1<String>(

                (String) results.get(0).getValue()
                );
    }

    public RemoteCall<TransactionReceipt> forbid(String src, String dst, String sig) {
        final Function function = new Function(
                FUNC_FORBID, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst), 
                new org.fisco.bcos.web3j.abi.datatypes.Utf8String(sig)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public void forbid(String src, String dst, String sig, TransactionSucCallback callback) {
        final Function function = new Function(
                FUNC_FORBID, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst), 
                new org.fisco.bcos.web3j.abi.datatypes.Utf8String(sig)), 
                Collections.<TypeReference<?>>emptyList());
        asyncExecuteTransaction(function, callback);
    }

    public String forbidSeq(String src, String dst, String sig) {
        final Function function = new Function(
                FUNC_FORBID, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst), 
                new org.fisco.bcos.web3j.abi.datatypes.Utf8String(sig)), 
                Collections.<TypeReference<?>>emptyList());
        return createTransactionSeq(function);
    }

    public Tuple3<String, String, String> getForbidAddressAddressStringInput(TransactionReceipt transactionReceipt) {
        String data = transactionReceipt.getInput().substring(10);
        final Function function = new Function(FUNC_FORBID, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}, new TypeReference<Address>() {}, new TypeReference<Utf8String>() {}));
        List<Type> results = FunctionReturnDecoder.decode(data, function.getOutputParameters());;
        return new Tuple3<String, String, String>(

                (String) results.get(0).getValue(), 
                (String) results.get(1).getValue(), 
                (String) results.get(2).getValue()
                );
    }

    public RemoteCall<TransactionReceipt> permitAny(String src, String dst) {
        final Function function = new Function(
                FUNC_PERMITANY, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public void permitAny(String src, String dst, TransactionSucCallback callback) {
        final Function function = new Function(
                FUNC_PERMITANY, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst)), 
                Collections.<TypeReference<?>>emptyList());
        asyncExecuteTransaction(function, callback);
    }

    public String permitAnySeq(String src, String dst) {
        final Function function = new Function(
                FUNC_PERMITANY, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst)), 
                Collections.<TypeReference<?>>emptyList());
        return createTransactionSeq(function);
    }

    public Tuple2<String, String> getPermitAnyInput(TransactionReceipt transactionReceipt) {
        String data = transactionReceipt.getInput().substring(10);
        final Function function = new Function(FUNC_PERMITANY, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}, new TypeReference<Address>() {}));
        List<Type> results = FunctionReturnDecoder.decode(data, function.getOutputParameters());;
        return new Tuple2<String, String>(

                (String) results.get(0).getValue(), 
                (String) results.get(1).getValue()
                );
    }

    public RemoteCall<byte[]> ANY_SIG() {
        final Function function = new Function(FUNC_ANY_SIG, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bytes4>() {}));
        return executeRemoteCallSingleValueReturn(function, byte[].class);
    }

    public RemoteCall<String> ANY_ADDRESS() {
        final Function function = new Function(FUNC_ANY_ADDRESS, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteCall<TransactionReceipt> setAuthority(String authority) {
        final Function function = new Function(
                FUNC_SETAUTHORITY, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(authority)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public void setAuthority(String authority, TransactionSucCallback callback) {
        final Function function = new Function(
                FUNC_SETAUTHORITY, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(authority)), 
                Collections.<TypeReference<?>>emptyList());
        asyncExecuteTransaction(function, callback);
    }

    public String setAuthoritySeq(String authority) {
        final Function function = new Function(
                FUNC_SETAUTHORITY, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(authority)), 
                Collections.<TypeReference<?>>emptyList());
        return createTransactionSeq(function);
    }

    public Tuple1<String> getSetAuthorityInput(TransactionReceipt transactionReceipt) {
        String data = transactionReceipt.getInput().substring(10);
        final Function function = new Function(FUNC_SETAUTHORITY, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        List<Type> results = FunctionReturnDecoder.decode(data, function.getOutputParameters());;
        return new Tuple1<String>(

                (String) results.get(0).getValue()
                );
    }

    public RemoteCall<TransactionReceipt> forbid(String src, String dst, byte[] sig) {
        final Function function = new Function(
                FUNC_FORBID, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst), 
                new org.fisco.bcos.web3j.abi.datatypes.generated.Bytes4(sig)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public void forbid(String src, String dst, byte[] sig, TransactionSucCallback callback) {
        final Function function = new Function(
                FUNC_FORBID, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst), 
                new org.fisco.bcos.web3j.abi.datatypes.generated.Bytes4(sig)), 
                Collections.<TypeReference<?>>emptyList());
        asyncExecuteTransaction(function, callback);
    }

    public String forbidSeq(String src, String dst, byte[] sig) {
        final Function function = new Function(
                FUNC_FORBID, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst), 
                new org.fisco.bcos.web3j.abi.datatypes.generated.Bytes4(sig)), 
                Collections.<TypeReference<?>>emptyList());
        return createTransactionSeq(function);
    }

    public Tuple3<String, String, byte[]> getForbidAddressAddressBytes4Input(TransactionReceipt transactionReceipt) {
        String data = transactionReceipt.getInput().substring(10);
        final Function function = new Function(FUNC_FORBID, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}, new TypeReference<Address>() {}, new TypeReference<Bytes4>() {}));
        List<Type> results = FunctionReturnDecoder.decode(data, function.getOutputParameters());;
        return new Tuple3<String, String, byte[]>(

                (String) results.get(0).getValue(), 
                (String) results.get(1).getValue(), 
                (byte[]) results.get(2).getValue()
                );
    }

    public RemoteCall<byte[]> getSigFromStr(String sig) {
        final Function function = new Function(FUNC_GETSIGFROMSTR, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Utf8String(sig)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bytes4>() {}));
        return executeRemoteCallSingleValueReturn(function, byte[].class);
    }

    public RemoteCall<String> _owner() {
        final Function function = new Function(FUNC__OWNER, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteCall<Boolean> canCall(String src, String dst, byte[] sig) {
        final Function function = new Function(FUNC_CANCALL, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst), 
                new org.fisco.bcos.web3j.abi.datatypes.generated.Bytes4(sig)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bool>() {}));
        return executeRemoteCallSingleValueReturn(function, Boolean.class);
    }

    public RemoteCall<TransactionReceipt> permit(String src, String dst, byte[] sig) {
        final Function function = new Function(
                FUNC_PERMIT, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst), 
                new org.fisco.bcos.web3j.abi.datatypes.generated.Bytes4(sig)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public void permit(String src, String dst, byte[] sig, TransactionSucCallback callback) {
        final Function function = new Function(
                FUNC_PERMIT, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst), 
                new org.fisco.bcos.web3j.abi.datatypes.generated.Bytes4(sig)), 
                Collections.<TypeReference<?>>emptyList());
        asyncExecuteTransaction(function, callback);
    }

    public String permitSeq(String src, String dst, byte[] sig) {
        final Function function = new Function(
                FUNC_PERMIT, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst), 
                new org.fisco.bcos.web3j.abi.datatypes.generated.Bytes4(sig)), 
                Collections.<TypeReference<?>>emptyList());
        return createTransactionSeq(function);
    }

    public Tuple3<String, String, byte[]> getPermitAddressAddressBytes4Input(TransactionReceipt transactionReceipt) {
        String data = transactionReceipt.getInput().substring(10);
        final Function function = new Function(FUNC_PERMIT, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}, new TypeReference<Address>() {}, new TypeReference<Bytes4>() {}));
        List<Type> results = FunctionReturnDecoder.decode(data, function.getOutputParameters());;
        return new Tuple3<String, String, byte[]>(

                (String) results.get(0).getValue(), 
                (String) results.get(1).getValue(), 
                (byte[]) results.get(2).getValue()
                );
    }

    public RemoteCall<String> _authority() {
        final Function function = new Function(FUNC__AUTHORITY, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteCall<byte[]> getSig() {
        final Function function = new Function(FUNC_GETSIG, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bytes4>() {}));
        return executeRemoteCallSingleValueReturn(function, byte[].class);
    }

    public RemoteCall<Boolean> isAuthorized(String src, byte[] sig) {
        final Function function = new Function(FUNC_ISAUTHORIZED, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.generated.Bytes4(sig)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bool>() {}));
        return executeRemoteCallSingleValueReturn(function, Boolean.class);
    }

    public RemoteCall<TransactionReceipt> permit(String src, String dst, String sig) {
        final Function function = new Function(
                FUNC_PERMIT, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst), 
                new org.fisco.bcos.web3j.abi.datatypes.Utf8String(sig)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public void permit(String src, String dst, String sig, TransactionSucCallback callback) {
        final Function function = new Function(
                FUNC_PERMIT, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst), 
                new org.fisco.bcos.web3j.abi.datatypes.Utf8String(sig)), 
                Collections.<TypeReference<?>>emptyList());
        asyncExecuteTransaction(function, callback);
    }

    public String permitSeq(String src, String dst, String sig) {
        final Function function = new Function(
                FUNC_PERMIT, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst), 
                new org.fisco.bcos.web3j.abi.datatypes.Utf8String(sig)), 
                Collections.<TypeReference<?>>emptyList());
        return createTransactionSeq(function);
    }

    public Tuple3<String, String, String> getPermitAddressAddressStringInput(TransactionReceipt transactionReceipt) {
        String data = transactionReceipt.getInput().substring(10);
        final Function function = new Function(FUNC_PERMIT, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}, new TypeReference<Address>() {}, new TypeReference<Utf8String>() {}));
        List<Type> results = FunctionReturnDecoder.decode(data, function.getOutputParameters());;
        return new Tuple3<String, String, String>(

                (String) results.get(0).getValue(), 
                (String) results.get(1).getValue(), 
                (String) results.get(2).getValue()
                );
    }

    public RemoteCall<TransactionReceipt> forbidAny(String src, String dst) {
        final Function function = new Function(
                FUNC_FORBIDANY, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public void forbidAny(String src, String dst, TransactionSucCallback callback) {
        final Function function = new Function(
                FUNC_FORBIDANY, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst)), 
                Collections.<TypeReference<?>>emptyList());
        asyncExecuteTransaction(function, callback);
    }

    public String forbidAnySeq(String src, String dst) {
        final Function function = new Function(
                FUNC_FORBIDANY, 
                Arrays.<Type>asList(new org.fisco.bcos.web3j.abi.datatypes.Address(src), 
                new org.fisco.bcos.web3j.abi.datatypes.Address(dst)), 
                Collections.<TypeReference<?>>emptyList());
        return createTransactionSeq(function);
    }

    public Tuple2<String, String> getForbidAnyInput(TransactionReceipt transactionReceipt) {
        String data = transactionReceipt.getInput().substring(10);
        final Function function = new Function(FUNC_FORBIDANY, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}, new TypeReference<Address>() {}));
        List<Type> results = FunctionReturnDecoder.decode(data, function.getOutputParameters());;
        return new Tuple2<String, String>(

                (String) results.get(0).getValue(), 
                (String) results.get(1).getValue()
                );
    }

    public List<LogPermitEventResponse> getLogPermitEvents(TransactionReceipt transactionReceipt) {
        List<Contract.EventValuesWithLog> valueList = extractEventParametersWithLog(LOGPERMIT_EVENT, transactionReceipt);
        ArrayList<LogPermitEventResponse> responses = new ArrayList<LogPermitEventResponse>(valueList.size());
        for (Contract.EventValuesWithLog eventValues : valueList) {
            LogPermitEventResponse typedResponse = new LogPermitEventResponse();
            typedResponse.log = eventValues.getLog();
            typedResponse.src = (String) eventValues.getIndexedValues().get(0).getValue();
            typedResponse.dst = (String) eventValues.getIndexedValues().get(1).getValue();
            typedResponse.sig = (byte[]) eventValues.getIndexedValues().get(2).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public void registerLogPermitEventLogFilter(String fromBlock, String toBlock, List<String> otherTopcs, EventLogPushWithDecodeCallback callback) {
        String topic0 = EventEncoder.encode(LOGPERMIT_EVENT);
        registerEventLogPushFilter(ABI,BINARY,topic0,fromBlock,toBlock,otherTopcs,callback);
    }

    public void registerLogPermitEventLogFilter(EventLogPushWithDecodeCallback callback) {
        String topic0 = EventEncoder.encode(LOGPERMIT_EVENT);
        registerEventLogPushFilter(ABI,BINARY,topic0,callback);
    }

    public List<LogForbidEventResponse> getLogForbidEvents(TransactionReceipt transactionReceipt) {
        List<Contract.EventValuesWithLog> valueList = extractEventParametersWithLog(LOGFORBID_EVENT, transactionReceipt);
        ArrayList<LogForbidEventResponse> responses = new ArrayList<LogForbidEventResponse>(valueList.size());
        for (Contract.EventValuesWithLog eventValues : valueList) {
            LogForbidEventResponse typedResponse = new LogForbidEventResponse();
            typedResponse.log = eventValues.getLog();
            typedResponse.src = (String) eventValues.getIndexedValues().get(0).getValue();
            typedResponse.dst = (String) eventValues.getIndexedValues().get(1).getValue();
            typedResponse.sig = (byte[]) eventValues.getIndexedValues().get(2).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public void registerLogForbidEventLogFilter(String fromBlock, String toBlock, List<String> otherTopcs, EventLogPushWithDecodeCallback callback) {
        String topic0 = EventEncoder.encode(LOGFORBID_EVENT);
        registerEventLogPushFilter(ABI,BINARY,topic0,fromBlock,toBlock,otherTopcs,callback);
    }

    public void registerLogForbidEventLogFilter(EventLogPushWithDecodeCallback callback) {
        String topic0 = EventEncoder.encode(LOGFORBID_EVENT);
        registerEventLogPushFilter(ABI,BINARY,topic0,callback);
    }

    public List<LogSetAuthorityEventResponse> getLogSetAuthorityEvents(TransactionReceipt transactionReceipt) {
        List<Contract.EventValuesWithLog> valueList = extractEventParametersWithLog(LOGSETAUTHORITY_EVENT, transactionReceipt);
        ArrayList<LogSetAuthorityEventResponse> responses = new ArrayList<LogSetAuthorityEventResponse>(valueList.size());
        for (Contract.EventValuesWithLog eventValues : valueList) {
            LogSetAuthorityEventResponse typedResponse = new LogSetAuthorityEventResponse();
            typedResponse.log = eventValues.getLog();
            typedResponse.authority = (String) eventValues.getIndexedValues().get(0).getValue();
            typedResponse.from = (String) eventValues.getNonIndexedValues().get(0).getValue();
            typedResponse.sig = (byte[]) eventValues.getNonIndexedValues().get(1).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public void registerLogSetAuthorityEventLogFilter(String fromBlock, String toBlock, List<String> otherTopcs, EventLogPushWithDecodeCallback callback) {
        String topic0 = EventEncoder.encode(LOGSETAUTHORITY_EVENT);
        registerEventLogPushFilter(ABI,BINARY,topic0,fromBlock,toBlock,otherTopcs,callback);
    }

    public void registerLogSetAuthorityEventLogFilter(EventLogPushWithDecodeCallback callback) {
        String topic0 = EventEncoder.encode(LOGSETAUTHORITY_EVENT);
        registerEventLogPushFilter(ABI,BINARY,topic0,callback);
    }

    public List<LogSetOwnerEventResponse> getLogSetOwnerEvents(TransactionReceipt transactionReceipt) {
        List<Contract.EventValuesWithLog> valueList = extractEventParametersWithLog(LOGSETOWNER_EVENT, transactionReceipt);
        ArrayList<LogSetOwnerEventResponse> responses = new ArrayList<LogSetOwnerEventResponse>(valueList.size());
        for (Contract.EventValuesWithLog eventValues : valueList) {
            LogSetOwnerEventResponse typedResponse = new LogSetOwnerEventResponse();
            typedResponse.log = eventValues.getLog();
            typedResponse.owner = (String) eventValues.getIndexedValues().get(0).getValue();
            typedResponse.oldOwner = (String) eventValues.getIndexedValues().get(1).getValue();
            typedResponse.contractAddress = (String) eventValues.getIndexedValues().get(2).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public void registerLogSetOwnerEventLogFilter(String fromBlock, String toBlock, List<String> otherTopcs, EventLogPushWithDecodeCallback callback) {
        String topic0 = EventEncoder.encode(LOGSETOWNER_EVENT);
        registerEventLogPushFilter(ABI,BINARY,topic0,fromBlock,toBlock,otherTopcs,callback);
    }

    public void registerLogSetOwnerEventLogFilter(EventLogPushWithDecodeCallback callback) {
        String topic0 = EventEncoder.encode(LOGSETOWNER_EVENT);
        registerEventLogPushFilter(ABI,BINARY,topic0,callback);
    }

    @Deprecated
    public static WEAclGuard load(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return new WEAclGuard(contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    @Deprecated
    public static WEAclGuard load(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return new WEAclGuard(contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    public static WEAclGuard load(String contractAddress, Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        return new WEAclGuard(contractAddress, web3j, credentials, contractGasProvider);
    }

    public static WEAclGuard load(String contractAddress, Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        return new WEAclGuard(contractAddress, web3j, transactionManager, contractGasProvider);
    }

    public static RemoteCall<WEAclGuard> deploy(Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        return deployRemoteCall(WEAclGuard.class, web3j, credentials, contractGasProvider, BINARY, "");
    }

    public static RemoteCall<WEAclGuard> deploy(Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        return deployRemoteCall(WEAclGuard.class, web3j, transactionManager, contractGasProvider, BINARY, "");
    }

    @Deprecated
    public static RemoteCall<WEAclGuard> deploy(Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(WEAclGuard.class, web3j, credentials, gasPrice, gasLimit, BINARY, "");
    }

    @Deprecated
    public static RemoteCall<WEAclGuard> deploy(Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(WEAclGuard.class, web3j, transactionManager, gasPrice, gasLimit, BINARY, "");
    }

    public static class LogPermitEventResponse {
        public Log log;

        public String src;

        public String dst;

        public byte[] sig;
    }

    public static class LogForbidEventResponse {
        public Log log;

        public String src;

        public String dst;

        public byte[] sig;
    }

    public static class LogSetAuthorityEventResponse {
        public Log log;

        public String authority;

        public String from;

        public byte[] sig;
    }

    public static class LogSetOwnerEventResponse {
        public Log log;

        public String owner;

        public String oldOwner;

        public String contractAddress;
    }
}
