pragma solidity ^0.4.24;

library EvidencesRepository {
    struct Evidence {
        mapping (address=>mapping(bytes32=>EvidenceInfo)) bearer;
    }
    
    struct EvidenceInfo{
       string dataJson;//原始摘要数据
       bytes signStr;//摘要数据Hash签名
       string timeCertificate;//授时凭证
       bool existState;// true 正常，flase 关闭
       uint createTimeStamp;//创建时间戳
       bool removeState;//移除 标识，存在为true
       uint removeTimeStamp;//删除时间戳
   }
    
    function add(Evidence storage evidence, address account,bytes32 dataHash, string dataJson,bytes signStr,string timeCertificate) internal {
        require(!has(evidence, account,dataHash), "EvidencesRepositorys add: 当前存证Hash已经存在！");
      
         evidence.bearer[account][dataHash].dataJson = dataJson;
         evidence.bearer[account][dataHash].signStr = signStr;
         evidence.bearer[account][dataHash].timeCertificate = timeCertificate;
         evidence.bearer[account][dataHash].existState = true;
         evidence.bearer[account][dataHash].createTimeStamp = now;
    }

    function remove(Evidence storage evidence, address account,bytes32 dataHash) internal {
        require(has(evidence, account,dataHash), "EvidencesRepositorys remove: 不存在当前的注册用户!");
        evidence.bearer[account][dataHash].removeState= true;
        evidence.bearer[account][dataHash].removeTimeStamp = now;
    }

    function has(Evidence storage evidence, address account,bytes32 dataHash) internal view returns (bool) {
        require(account != address(0), "EvidencesRepositorys has: 账户为空地址！");
        return evidence.bearer[account][dataHash].existState;
    }
    
    //查找对应的用户存证
    function selectEvidence(Evidence storage evidence,address account,bytes32 dataHash) internal view returns(string){
        return evidence.bearer[account][dataHash].dataJson;
    }
}