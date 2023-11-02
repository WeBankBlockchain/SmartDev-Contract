pragma solidity ^0.4.4;

contract EvidenceSignersDataABI
{
	function verify(address addr)public constant returns(bool){}
	function getSigner(uint index)public constant returns(address){} 
	function getSignersSize() public constant returns(uint){}
}

contract Evidence{
    
    string evidence;
    address[] signers;
    address public factoryAddr;
    
    event addSignaturesEvent(string evi);
    event newSignaturesEvent(string evi, address addr);
    event errorNewSignaturesEvent(string evi, address addr);
    event errorAddSignaturesEvent(string evi, address addr);
    event addRepeatSignaturesEvent(string evi);
    event errorRepeatSignaturesEvent(string evi, address addr);

    function CallVerify(address addr) public constant returns(bool) {
        return EvidenceSignersDataABI(factoryAddr).verify(addr);
    }

   constructor(string evi, address addr)  {
       factoryAddr = addr;
       if(CallVerify(msg.sender))
       {
           evidence = evi;
           signers.push(msg.sender);
           newSignaturesEvent(evi,addr);
       }
       else
       {
           errorNewSignaturesEvent(evi,addr);
       }
    }

    function getEvidence() public constant returns(string,address[],address[]){
        uint length = EvidenceSignersDataABI(factoryAddr).getSignersSize();
         address[] memory signerList = new address[](length);
         for(uint i= 0 ;i<length ;i++)
         {
             signerList[i] = (EvidenceSignersDataABI(factoryAddr).getSigner(i));
         }
        return(evidence,signerList,signers);
    }

    function addSignatures() public returns(bool) {
        for(uint i= 0 ;i<signers.length ;i++)
        {
            if(msg.sender == signers[i])
            {
                addRepeatSignaturesEvent(evidence);
                return true;
            }
        }
       if(CallVerify(msg.sender))
       {
            signers.push(msg.sender);
            addSignaturesEvent(evidence);
            return true;
       }
       else
       {
           errorAddSignaturesEvent(evidence,msg.sender);
           return false;
       }
    }
    
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