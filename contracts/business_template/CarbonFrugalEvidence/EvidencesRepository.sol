pragma solidity ^0.4.24;

library EvidencesRepository {
    struct Evidence {
        mapping (address=>mapping(bytes32=>EvidenceInfo)) bearer;
    }
    
    struct EvidenceInfo{
       string dataJson;//ԭʼժҪ����
       bytes signStr;//ժҪ����Hashǩ��
       string timeCertificate;//��ʱƾ֤
       bool existState;// true ������flase �ر�
       uint createTimeStamp;//����ʱ���
       bool removeState;//�Ƴ� ��ʶ������Ϊtrue
       uint removeTimeStamp;//ɾ��ʱ���
   }
    
    function add(Evidence storage evidence, address account,bytes32 dataHash, string dataJson,bytes signStr,string timeCertificate) internal {
        require(!has(evidence, account,dataHash), "EvidencesRepositorys add: ��ǰ��֤Hash�Ѿ����ڣ�");
      
         evidence.bearer[account][dataHash].dataJson = dataJson;
         evidence.bearer[account][dataHash].signStr = signStr;
         evidence.bearer[account][dataHash].timeCertificate = timeCertificate;
         evidence.bearer[account][dataHash].existState = true;
         evidence.bearer[account][dataHash].createTimeStamp = now;
    }

    function remove(Evidence storage evidence, address account,bytes32 dataHash) internal {
        require(has(evidence, account,dataHash), "EvidencesRepositorys remove: �����ڵ�ǰ��ע���û�!");
        evidence.bearer[account][dataHash].removeState= true;
        evidence.bearer[account][dataHash].removeTimeStamp = now;
    }

    function has(Evidence storage evidence, address account,bytes32 dataHash) internal view returns (bool) {
        require(account != address(0), "EvidencesRepositorys has: �˻�Ϊ�յ�ַ��");
        return evidence.bearer[account][dataHash].existState;
    }
    
    //���Ҷ�Ӧ���û���֤
    function selectEvidence(Evidence storage evidence,address account,bytes32 dataHash) internal view returns(string){
        return evidence.bearer[account][dataHash].dataJson;
    }
}
