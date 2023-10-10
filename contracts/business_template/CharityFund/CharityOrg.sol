pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./PublicData.sol";
import "./RolesAuth.sol";

contract CharityOrg is PublicData{
    
    RolesAuth private rolesAuth;
    
    // 慈善机构的结构体
    struct Org {
        uint256  orgId;          // 机构ID
        string   orgName;        // 机构名称
        address  orgAddress;     // 机构的地址
        uint256  orgAmount;      // 机构的账户
        int      status;         // 机构的状态
        uint256[] recordIds;     // 机构的所有公益溯源集合
        uint256[] transactions;  // 机构的所有公益捐赠交易ID集合
        uint256[] meterials;     // 机构的所有的物资申请记录ID
    }
    
    
    // 慈善机构ID
    uint256 orgId;     
    
    // 所有机构的地址
    address[] orgs;

    // 地址映射慈善机构
    mapping(address => Org) public orgMap;  
    
    
    // 修饰符函数
    modifier _AuthOrg {
        require(rolesAuth.hasOrg(msg.sender),"没有权限");
        _;
    }
    constructor() public {
        rolesAuth = new RolesAuth();
    }
    
    // 注册慈善机构
    function registerOrg(string memory _orgName) public returns(Org memory){
        require(orgMap[msg.sender].status == 0,"当前机构已注册");
        
        orgId++;
        uint256 _orgId = orgId;
        Org storage _charityOrg = orgMap[msg.sender];
        _charityOrg.orgId = _orgId;
        _charityOrg.orgName = _orgName;
        _charityOrg.orgAddress = msg.sender;
        _charityOrg.orgAmount = 0;
        _charityOrg.status = 1;
        orgs.push(msg.sender);
        
        rolesAuth.addOrg(msg.sender);
        emit Registered(msg.sender);
        return _charityOrg;
    }
    

    /**
     * @dev 查询指定机构的公益捐助交易信息（分页查询）
     * @param _orgAddress 待查询的机构地址
     * @param _page 查询的页数
     * @param _pageSize 每页的记录条数
     * @return 指定页码下的公益捐助交易信息数组
     * 
     **/
    function queryOrgTransactionPage(address _orgAddress,uint256 _page,uint256 _pageSize) public view  returns(Transaction[]){
        Org memory _org = orgMap[_orgAddress];
        require(_org.transactions.length != 0,"当前没有交易记录");
        require(_page > 0, "页数不能为0");
        uint256 startIndex = (_page - 1) * _pageSize; // 计算起始索引
        uint256 endIndex = startIndex + _pageSize > _org.transactions.length ? _org.transactions.length : startIndex + _pageSize; // 计算结束索引
        Transaction[] memory transactionArr = new Transaction[](endIndex - startIndex);
        for (uint i = startIndex; i < endIndex; i++){
            transactionArr[i - startIndex] = transactionMap[_org.transactions[i]];
        }
        return transactionArr;
    }
    
    // 查询机构的详细信息
    function queryOrg(address _orgAddress) public view returns(Org memory){
        return orgMap[_orgAddress];
    }
    
    
    // 查询所有的机构详细信息
    function queryAllOrg() public view returns(Org[] memory _orgs){
        _orgs = new Org[](orgs.length);
        for (uint i = 0; i < orgs.length; ++i){
            _orgs[i] = orgMap[orgs[i]];
        }
    }
    

    // 判断机构是否存在
    function checkOrgIsIn(address _orgAddress) public view returns(bool){
        if (orgMap[_orgAddress].status == 0){
            return false;
        }else {
            return true;
        }
    }

}