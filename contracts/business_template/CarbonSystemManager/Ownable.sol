pragma solidity ^0.4.25;


contract Ownable {
    // 定义角色枚举类型
    enum Role { Enterprise, Regulator }
    
    uint256 internal constant TOTAL_EMISSION = 1000;
    // 默认按照100元一个碳额度
    uint256 internal constant EXCESS_BALANCE = 3;
    bool internal constant AUDIT_SUCCESS = true;
    bool internal constant AUDIT_FAILED = false;

    // 企业账户的事件
    event RegisterAccount(address indexed _acount,string indexed _name);
    // 上传审核的事件
    event UploadQualification(address indexed _acount,string indexed _name,string indexed _content);
    // 审批企业申请的事件
    event VerifyQualification(address indexed _enterpriseAddr,uint256 indexed _emissionLimit);
    // 交易碳额度
    event TransferEmissionLimit(address indexed _from,address indexed _to,uint256 indexed _amount);
    // 出售碳额度
    event SellEmissionLimit(uint256 indexed _emissionLimitCount,uint256 indexed _amount);
    // 更新企业账户的余额
    event UpdateBalnce(address indexed _enterpriseAddr,uint256 indexed _amount);
    // 更新企业账户的碳排放额度
    event UpdateEmissionLimit(address indexed _enterpriseAddr,uint256 indexed _emissionLimit);
}