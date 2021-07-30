pragma solidity ^0.4.25;

contract EvidenceSignersDataABI
{
    //验证是否是合法地址
	function verify(address addr)public constant returns(bool){}
	//根据索引值返回签名者地址
	function getSigner(uint index)public constant returns(address){} 
	//返回签名人数
	function getSignersSize() public constant returns(uint){}
}

contract Evidence{
    
    string evidence; //存证信息
    address[] signers;//储存合法签名者地址
    address public factoryAddr;//工厂合约地址
    //返回事件信息，查看log->判断正确或错误的信息
    event addSignaturesEvent(string evi);
    event newSignaturesEvent(string evi, address addr);
    event errorNewSignaturesEvent(string evi, address addr);
    event errorAddSignaturesEvent(string evi, address addr);
    event addRepeatSignaturesEvent(string evi);
    event errorRepeatSignaturesEvent(string evi, address addr);
    //查看此地址是否为合法签名者地址
    function CallVerify(address addr) public constant returns(bool) {
        return EvidenceSignersDataABI(factoryAddr).verify(addr);
    }
    //初始化，创建存证合约
   constructor(string evi, address addr)  {
       factoryAddr = addr;
       //tx.origin =>启动交易的原始地址（其实就是部署者的地址）
       //如果是外部调用，在此可以理解为函数调用者地址
       if(CallVerify(tx.origin))
       {
           evidence = evi;
           signers.push(tx.origin);
           newSignaturesEvent(evi,addr);
       }
       else
       {
           errorNewSignaturesEvent(evi,addr);
       }
    }
    //返回签名信息，合约签名者地址，当前签名者地址
    function getEvidence() public constant returns(string,address[],address[]){
        uint length = EvidenceSignersDataABI(factoryAddr).getSignersSize();
         address[] memory signerList = new address[](length);
         for(uint i= 0 ;i<length ;i++)
         {
             signerList[i] = (EvidenceSignersDataABI(factoryAddr).getSigner(i));
         }
        return(evidence,signerList,signers);
    }
    //添加签名者地址（此地址必须为合约签名者地址）
    function addSignatures() public returns(bool) {
        for(uint i= 0 ;i<signers.length ;i++)
        {
            //此时的tx.orgin为当前调用此方法的调用者地址
            if(tx.origin == signers[i])
            {
                addRepeatSignaturesEvent(evidence);
                return true;
            }
        }
       if(CallVerify(tx.origin))
       {
            signers.push(tx.origin);
            addSignaturesEvent(evidence);
            return true;
       }
       else
       {
           errorAddSignaturesEvent(evidence,tx.origin);
           return false;
       }
    }
    //返回所有的合约签名者地址
    function getSigners()public constant returns(address[])
    {
         uint length = EvidenceSignersDataABI(factoryAddr).getSignersSize();
         address[] memory signerList = new address[](length);
         for(uint i= 0 ;i<length ;i++)
         {
             signerList[i] = (EvidenceSignersDataABI(factoryAddr).getSigner(i));
         }
         return signerList;
    }
}