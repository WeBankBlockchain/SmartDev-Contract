pragma solidity ^0.4.25;
import "Evidence.sol";

contract EvidenceFactory{
        address[] signers;  //存储签名者地址
		event newEvidenceEvent(address addr); //新签证事件，返回地址
		//传入签名内容 string类型，创建合约Evidence并初始化
        function newEvidence(string evi)public returns(address)
        {
            //this:代表当前工厂合约的地址
            Evidence evidence = new Evidence(evi, this);
            newEvidenceEvent(evidence);
            return evidence;
        }
        //获得签证信息
        function getEvidence(address addr) public constant returns(string,address[],address[]){
            return Evidence(addr).getEvidence();
        }
        
                
        function addSignatures(address addr) public returns(bool) {
            return Evidence(addr).addSignatures();
        }
        //初始化合约，导入签名者们的地址（数组传参）为合法签名者地址
        //只有合法签名者才有资格进行签证
        constructor(address[] evidenceSigners){
            for(uint i=0; i<evidenceSigners.length; ++i) {
            signers.push(evidenceSigners[i]);
			}
		}
        // 验证身份是否为合法签名者地址
        function verify(address addr)public constant returns(bool){
                for(uint i=0; i<signers.length; ++i) {
                if (addr == signers[i])
                {
                    return true;
                }
            }
            return false;
        }
        //根据索引值返回合约签名者地址
        function getSigner(uint index)public constant returns(address){
            uint listSize = signers.length;
            //判断索引值是否越界
            if(index < listSize)
            {
                return signers[index];
            }
            else
            {
                return 0;
            }
    
        }
        //获取当前合约签名者人数
        function getSignersSize() public constant returns(uint){
            return signers.length;
        }
        //返回所有合约签名者的地址
        function getSigners() public constant returns(address[]){
            return signers;
        }
}