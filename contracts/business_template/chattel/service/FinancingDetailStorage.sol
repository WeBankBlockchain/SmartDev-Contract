/**
 * 融资详情存储器，记录融资申请过程中的详情信息
 */
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "../utils/Table.sol";
import "../utils/LibString.sol";
import "../utils/Ownable.sol";
import "./MapStorage.sol";

contract FinancingDetailStorage is Ownable {
    
    using LibString for string;
    
    MapStorage private mapStorage;

    event InsertResult(int256);
    event UpdateResult(int256);

    TableFactory tf;
    string constant TABLE_NAME = "tf_detail";

    /**
    * 创建融资详情表
    * +---------------------------+----------------+-----------------------------------------+
    * | Field                     |     Type       |      Desc                               |
    * +---------------------------+----------------+-----------------------------------------+
    * |process_id                 |     string     |      流程ID
    * |serial_no                  |     string     |      融资编号                           
    * |amount                     |     string     |      融资申请金额（单位：分）
    * |fin_amount                 |     string     |      融资总金额（单位：分）
    * |loan_amount                |     string     |      （实际）放款金额（单位：分）
    * |ware_no                    |     string     |      仓单号（由监管方给出）             
    * |contract_no                |     string     |      合同编号（资金方填入）             
    * |mass_no                    |     string     |      出质编号（监管方填入）             
    * |pledge_type                |     string     |      抵押类型（1-动产质押贷款）
    * |debtor_name                |     string     |      借款方、融资方名称                 
    * |credit_side_name           |     string     |      出资方、资金方名称                 
    * |fin_start_date             |     string     |      融资开始日期
    * |fin_end_date               |     string     |      融资结束日期
    * |fin_days                   |     string     |      融资天数
    * |service_price              |     string     |      融资申请费用（单位：分）
    * |fund_prod_name             |     string     |      产品名称                           
    * |fund_prod_int_rate         |     string     |      利率（6.32% == 632）
    * |fund_prod_service_price    |     string     |      产品服务费（单位：分）
    * |fund_prod_period           |     string     |      还款期数
    * |payment_type               |     string     |      还款类型（1-利随本还，2-先息后本）
    * |bank_card_no               |     string     |      入账银行卡号                       
    * |bank_name                  |     string     |      入账银行名称                       
    * |remark                     |     string     |      备注（融资方发起时填入）           
    * +---------------------------+----------------+-----------------------------------------+
    */
    constructor() public {
        tf = TableFactory(0x1001);
        tf.createTable(TABLE_NAME, "id", "process_id,serial_no,amount,fin_amount,loan_amount,ware_no,contract_no,mass_no,pledge_type,debtor_name,credit_side_name,fin_start_date,fin_end_date,fin_days,service_price,fund_prod_name,fund_prod_int_rate,fund_prod_service_price,fund_prod_period,payment_type,bank_card_no,bank_name,remark");

        mapStorage = new MapStorage();
    }

    /**
    * "11,1629939590223,1555500,14500,,CD-001,HT141600002,,1,益盟股份有限公司,zjf02,2021-08-26 00:00:00,2021-09-06 00:00:00,12,0,验证资料产品2,666,0,1,1,233652000000001,中国银行,"
    * 插入数据
    */
    function insert(string memory _detailStr) public onlyOwner returns(int) {
        FinancingDetail memory _detail = convertFinancingDetail(_detailStr);
        Table table = tf.openTable(TABLE_NAME);
        require(!_isProcessIdExist(table, _detail.processId), "FinancingDetailStorage insert: current processId has already exist");
        Entry entry = table.newEntry();
        convertEntry(_detail, entry);
        int256 count = table.insert(_detail.processId, entry);
        emit InsertResult(count);
        return count;
    }

    /**
    *  11
    * "11,1629939590223,1555500,14500,,CD-001,HT141600002,,1,益盟股份有限公司,zjf02,2021-08-26 00:00:00,2021-09-06 00:00:00,12,0,验证资料产品2,666,0,1,1,233652000000001,中国银行,"
    * 更新数据
    */
    function update(string memory _processId, string memory _detailStr) public onlyOwner returns(int256) {
        FinancingDetail memory _detail = convertFinancingDetail(_detailStr);
        Table table = tf.openTable(TABLE_NAME);
        require(_isProcessIdExist(table, _detail.processId), "FinancingDetailStorage update: current processId not exist");
        Entry entry = table.newEntry();
        convertEntry(_detail, entry);
        Condition condition = table.newCondition();
        int256 count = table.update(_processId, entry, condition);
        emit UpdateResult(count);
        return count;
    }

    /**
    * 通过processId查询数据
    */
    function getDetail(string memory _processId) public view returns(string memory _json){
        Entry entry = select(_processId);
        _json = _returnData(entry);
    }

    function convertFinancingDetail(string memory _str) private returns(FinancingDetail){
        string[] memory ss = _str.split(",");
        return FinancingDetail(ss[0],ss[1],ss[2],ss[3],ss[4],ss[5],ss[6],ss[7],ss[8],ss[9],ss[10],ss[11],ss[12],ss[13],ss[14],ss[15],ss[16],ss[17],ss[18],ss[19],ss[20],ss[21],ss[22]);
    }

    function convertEntry(FinancingDetail memory _detail, Entry entry) private {
        entry.set("process_id",_detail.processId);
        entry.set("serial_no",_detail.serialNo);
        entry.set("amount",_detail.amount);
        entry.set("fin_amount",_detail.finAmount);
        entry.set("loan_amount",_detail.loanAmount);
        entry.set("ware_no",_detail.wareNo);
        entry.set("contract_no",_detail.contractNo);
        entry.set("mass_no",_detail.massNo);
        entry.set("pledge_type",_detail.pledgeType);
        entry.set("debtor_name",_detail.debtorName);
        entry.set("credit_side_name",_detail.creditSideName);
        entry.set("fin_start_date",_detail.finStartDate);
        entry.set("fin_end_date",_detail.finEndDate);
        entry.set("fin_days",_detail.finDays);
        entry.set("service_price",_detail.servicePrice);
        entry.set("fund_prod_name",_detail.fundProdName);
        entry.set("fund_prod_int_rate",_detail.fundProdIntRate);
        entry.set("fund_prod_service_price",_detail.fundProdServicePrice);
        entry.set("fund_prod_period",_detail.fundProdPeriod);
        entry.set("payment_type",_detail.paymentType);
        entry.set("bank_card_no",_detail.bankCardNo);
        entry.set("bank_name",_detail.bankName);
        entry.set("remark",_detail.remark);
    }

    /**
    *  通过processId获取实体
    */
    function select(string memory _processId) private view returns(Entry _entry){
        Table table = tf.openTable(TABLE_NAME);
        require(_isProcessIdExist(table, _processId), "FinancingDetailStorage select: current processId not exist");

        Condition condition = table.newCondition();
        _entry = table.select(_processId, condition).get(int(0));
    }

    function _isProcessIdExist(Table _table, string memory _id) internal view returns(bool) {
        Condition condition = _table.newCondition();
        return _table.select(_id, condition).size() != int(0);
    }

    //拼接成json数据
    function _returnData(Entry _entry) internal view returns(string){

        string memory _json = "{";

        _json = _json.concat("'processId':'");
        _json = _json.concat(_entry.getString("process_id"));
        _json = _json.concat("',");

        _json = _json.concat("'serialNo':'");
        _json = _json.concat(_entry.getString("serial_no"));
        _json = _json.concat("',");

        _json = _json.concat("'amount':'");
        _json = _json.concat(_entry.getString("amount"));
        _json = _json.concat("',");

        _json = _json.concat("'finAmount':'");
        _json = _json.concat(_entry.getString("fin_amount"));
        _json = _json.concat("',");

        _json = _json.concat("'loanAmount':'");
        _json = _json.concat(_entry.getString("loan_amount"));
        _json = _json.concat("',");

        _json = _json.concat("'wareNo':'");
        _json = _json.concat(_entry.getString("ware_no"));
        _json = _json.concat("',");

        _json = _json.concat("'contractNo':'");
        _json = _json.concat(_entry.getString("contract_no"));
        _json = _json.concat("',");

        _json = _json.concat("'massNo':'");
        _json = _json.concat(_entry.getString("mass_no"));
        _json = _json.concat("',");

        _json = _json.concat("'pledgeType':'");
        _json = _json.concat(_entry.getString("pledge_type"));
        _json = _json.concat("',");

        _json = _json.concat("'debtorName':'");
        _json = _json.concat(_entry.getString("debtor_name"));
        _json = _json.concat("',");

        _json = _json.concat("'creditSideName':'");
        _json = _json.concat(_entry.getString("credit_side_name"));
        _json = _json.concat("',");

        _json = _json.concat("'finStartDate':'");
        _json = _json.concat(_entry.getString("fin_start_date"));
        _json = _json.concat("',");

        _json = _json.concat("'finEndDate':'");
        _json = _json.concat(_entry.getString("fin_end_date"));
        _json = _json.concat("',");

        _json = _json.concat("'finDays':'");
        _json = _json.concat(_entry.getString("fin_days"));
        _json = _json.concat("',");

        _json = _json.concat("'servicePrice':'");
        _json = _json.concat(_entry.getString("service_price"));
        _json = _json.concat("',");

        _json = _json.concat("'fundProdName':'");
        _json = _json.concat(_entry.getString("fund_prod_name"));
        _json = _json.concat("',");

        _json = _json.concat("'fundProdIntRate':'");
        _json = _json.concat(_entry.getString("fund_prod_int_rate"));
        _json = _json.concat("',");

        _json = _json.concat("'fundProdServicePrice':'");
        _json = _json.concat(_entry.getString("fund_prod_service_price"));
        _json = _json.concat("',");

        _json = _json.concat("'fundProdPeriod':'");
        _json = _json.concat(_entry.getString("fund_prod_period"));
        _json = _json.concat("',");

        _json = _json.concat("'paymentType':'");
        _json = _json.concat(_entry.getString("payment_type"));
        _json = _json.concat("',");

        _json = _json.concat("'bankCardNo':'");
        _json = _json.concat(_entry.getString("bank_card_no"));
        _json = _json.concat("',");

        _json = _json.concat("'bankName':'");
        _json = _json.concat(_entry.getString("bank_name"));
        _json = _json.concat("',");

        _json = _json.concat("'remark':'");
        _json = _json.concat(_entry.getString("remark"));
        _json = _json.concat("'");

        _json = _json.concat("}");

        return _json;
    }
    
    struct FinancingDetail {
        string processId;                 //流程ID
        string serialNo;                  //融资编号
        string amount;                     //融资申请金额（单位：分）
        string finAmount;                 //融资总金额（单位：分）
        string loanAmount;                //（实际）放款金额（单位：分）
        string wareNo;                    //仓单号（由监管方给出）
        string contractNo;                //合同编号（资金方填入）
        string massNo;                    //出质编号（监管方填入）
        string pledgeType;                //抵押类型（1-动产质押贷款）
        string debtorName;                //借款方、融资方名称
        string creditSideName;           //出资方、资金方名称
        string finStartDate;             //融资开始日期
        string finEndDate;               //融资结束日期
        string finDays;                   //融资天数
        string servicePrice;              //融资申请费用（单位：分）
        string fundProdName;             //产品名称
        string fundProdIntRate;         //利率（6.32% == 632）
        string fundProdServicePrice;    //产品服务费（单位：分）
        string fundProdPeriod;           //还款期数
        string paymentType;               //还款类型（1-利随本还，2-先息后本）
        string bankCardNo;               //入账银行卡号
        string bankName;                  //入账银行名称
        string remark;                     //备注（融资方发起时填入）
    }

}
