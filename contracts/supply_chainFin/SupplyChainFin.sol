// SPDX-License-Identifier: MIT
// 使用 SPDX 许可证标识，指定合约采用 MIT 许可证
// 这个 Solidity 合约是一个供应链金融智能合约，它允许主管、公司和银行参与交易。合约中包含了用于添加公司和银行、创建收据以及查询公司和银行地址的功能。addCompany 函数添加新公司，addBank 函数添加新银行（仅合约所有者可用）。bankToCompanyReceipt、companyToCompanyReceipt 和 companyToBankReceipt 函数分别创建银行向公司、公司向公司以及公司向银行的交易收据。getAllCompanyAddress 和 getAllBankAddress 函数用于获取所有公司和银行的地址列表。整体上，该合约提供了供应链金融交易的基本功能，并通过事件记录关键操作。
pragma solidity ^0.8.0;

// 导入 Ownable 合约，用于权限控制
import './Ownable.sol';

// SupplyChainFin 合约，继承 Ownable 合约的权限控制功能
contract SupplyChainFin is Ownable {
    // 定义 Supervisor、Company、Bank 和 Receipt 数据结构
    struct Supervisor {
        string supervisorName; // 主管姓名
        address supervisorAddress; // 主管地址
    }

    struct Company {
        string companyName;           // 公司名称
        address companyAddress;       // 公司地址
        uint creditAsset;             // 信用资产
        uint[] acceptReceiptIndex;    // 接收收据索引列表
        uint[] sendReceiptIndex;      // 发送收据索引列表
    }

    struct Bank {
        string bankName;              // 银行名称
        address bankAddress;          // 银行地址
        uint creditAsset;             // 信用资产
        uint[] acceptReceiptIndex;    // 接收收据索引列表
        uint[] sendReceiptIndex;      // 发送收据索引列表
    }

    struct Receipt {
        address senderAddress;        // 发件人地址
        address accepterAddress;      // 收件人地址
        uint8 receiptType;            // 收据类型
        uint8 transferType;           // 转账类型
        uint amount;                  // 金额
    }

    // 存储 Company、Bank 和 Receipt 信息的映射
    mapping(address => Company) public companyMap;
    mapping(address => Bank) public bankMap;
    mapping(uint => Receipt) public receiptMap;

    Supervisor public superviosrIns;     // 主管实例
    address[] public companies;          // 公司地址数组
    address[] public banks;              // 银行地址数组
    uint public receiptIndex;            // 收据索引

    // 用于记录重要合约操作的事件
    event CompanyAdded(address indexed companyAddress, string companyName);
    event BankAdded(address indexed bankAddress, string bankName);
    event BankToCompanyReceiptAdded(address indexed senderAddress, address indexed accepterAddress, uint receiptIndex);
    event CompanyToCompanyReceiptAdded(address indexed senderAddress, address indexed accepterAddress, uint receiptIndex);
    event CompanyToBankReceiptAdded(address indexed senderAddress, address indexed accepterAddress, uint receiptIndex);

    // 构造函数，用于初始化合约，并指定一个主管
    constructor(string memory supervisorName) {
        receiptIndex = 0;
        superviosrIns = Supervisor(supervisorName, msg.sender);
    }

    // 添加新公司到合约，记录公司名称和地址
    function addCompany(string memory name, address companyAddress) public returns (bool) {
        require(companyAddress != address(0), "无效的公司地址");
        Company memory newCompany = Company(name, companyAddress, 0, new uint[](0), new uint[](0));
        companies.push(companyAddress);
        companyMap[companyAddress] = newCompany;
        emit CompanyAdded(companyAddress, name);
        return true;
    }

    // 仅合约所有者可添加新银行，记录银行名称、地址和信用资产
    function addBank(string memory name, address bankAddress, uint credit) public onlyOwner {
        require(bankAddress != address(0), "无效的银行地址");
        Bank memory newBank = Bank(name, bankAddress, credit, new uint[](0), new uint[](0));
        banks.push(bankAddress);
        bankMap[bankAddress] = newBank;
        emit BankAdded(bankAddress, name);
    }

    // 银行向公司创建收据，记录发送者、接收者、金额等信息
    function bankToCompanyReceipt(address senderAddress, address accepterAddress, uint amount, uint8 receiptType) public returns (uint) {
        require(msg.sender == accepterAddress, "只有受款人可以创建此收据");
        require(amount > 0, "金额必须大于0");

        Bank storage bank = bankMap[senderAddress];
        Company storage company = companyMap[accepterAddress];

        require(bytes(bank.bankName).length > 0, "银行不存在");
        require(bytes(company.companyName).length > 0, "公司不存在");
        require(bank.creditAsset >= amount, "银行信用额度不足");

        Receipt memory newReceipt = Receipt(senderAddress, accepterAddress, receiptType, 1, amount);
        receiptIndex++;
        receiptMap[receiptIndex] = newReceipt;
        company.sendReceiptIndex.push(receiptIndex);
        bank.acceptReceiptIndex.push(receiptIndex);
        bank.creditAsset -= amount;
        company.creditAsset += amount;

        emit BankToCompanyReceiptAdded(senderAddress, accepterAddress, receiptIndex);
        return 200;
    }

    // 公司向另一公司创建收据，记录发送者、接收者、金额等信息
    function companyToCompanyReceipt(address senderAddress, address accepterAddress, uint amount, uint8 receiptType) public returns (uint) {
        require(msg.sender == accepterAddress, "只有受款人可以创建此收据");
        require(amount > 0, "金额必须大于0");

        Company storage senderCompany = companyMap[senderAddress];
        Company storage accepterCompany = companyMap[accepterAddress];

        require(bytes(senderCompany.companyName).length > 0, "发款公司不存在");
        require(bytes(accepterCompany.companyName).length > 0, "收款公司不存在");
        require(accepterCompany.creditAsset >= amount, "收款公司信用额度不足");

        Receipt memory newReceipt = Receipt(senderAddress, accepterAddress, receiptType, 2, amount);
        receiptIndex++;
        receiptMap[receiptIndex] = newReceipt;
        senderCompany.sendReceiptIndex.push(receiptIndex);
        accepterCompany.acceptReceiptIndex.push(receiptIndex);

        senderCompany.creditAsset -= amount;
        accepterCompany.creditAsset += amount;

        emit CompanyToCompanyReceiptAdded(senderAddress, accepterAddress, receiptIndex);
        return 200;
    }

    // 公司向银行创建收据，记录发送者、接收者、金额等信息
    function companyToBankReceipt(address senderAddress, address accepterAddress, uint amount, uint8 receiptType) public returns (uint) {
        require(msg.sender == accepterAddress, "只有受款人可以创建此收据");
        require(amount > 0, "金额必须大于0");

        Bank storage bank = bankMap[accepterAddress];
        Company storage accepterCompany = companyMap[senderAddress];

        require(bytes(bank.bankName).length > 0, "银行不存在");
        require(bytes(accepterCompany.companyName).length > 0, "公司不存在");
        require(accepterCompany.creditAsset >= amount, "公司信用额度不足");

        Receipt memory newReceipt = Receipt(senderAddress, accepterAddress, receiptType, 3, amount);
        receiptIndex++;
        receiptMap[receiptIndex] = newReceipt;
        bank.sendReceiptIndex.push(receiptIndex);
        accepterCompany.acceptReceiptIndex.push(receiptIndex);

        bank.creditAsset += amount;
        accepterCompany.creditAsset -= amount;

        emit CompanyToBankReceiptAdded(senderAddress, accepterAddress, receiptIndex);
        return 200;
    }

    // 获取所有公司地址的函数
    function getAllCompanyAddress() public view returns (address[] memory) {
        return companies;
    }

    // 获取所有银行地址的函数
    function getAllBankAddress() public view returns (address[] memory) {
        return banks;
    }
}
