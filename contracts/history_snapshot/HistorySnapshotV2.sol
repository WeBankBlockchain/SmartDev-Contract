// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;
pragma experimental ABIEncoderV2;

/**
 * @dev 历史状态快照合约：通过块高来查询某一个值任何历史状态
 * @author ashinnotfound
 */
contract HistorySnapshotV2{

    constructor() public {
       isAvailable[msg.sender] = true; 
    }
    // 权限mapping
    mapping(address => bool) isAvailable;
    // 控制权限访问修饰符
    modifier valid(){
        require(isAvailable[msg.sender], "HistorySnapshotV2::operate failed: No right");
        _;
    }
    // 添加授权事件
    event LogAddAvailable(address addr, address operator);
    // 删除授权事件
    event LogDelelteAvailable(address addr, address operator);
    /**
     * @dev 添加授权
     * @param _addr 目标用户
     */
    function addAvailable(address _addr) public valid {
        isAvailable[_addr] = true;
        emit LogAddAvailable(_addr, msg.sender);
    }
    /**
     * @dev 删除授权
     * @param _addr 目标用户
     */
    function deleteAvailable(address _addr) public valid {
        isAvailable[_addr] = false;
        emit LogDelelteAvailable(_addr, msg.sender);
    }


    // 历史状态map 字段名=>块号=>数据
    mapping(string => mapping(uint256 => bytes)) private historyMap;
    // 块号数组map 字段名=>记录的块号
    mapping(string => uint256[]) private blockArrayMap;

    // 更新历史状态快照事件 (字段，类型，值(bytes)，操作者, 块号)
    event LogUpdateHistorySnapshot(string field, string valueType, bytes value, address operator, uint256 blockNumber);

    /**
     * @dev 增加bytes类型的历史快照
     * @param _field 存储字段
     * @param _value 存储的值
     */
    function updateBytes(string memory _field, bytes memory _value) public valid {
        historyMap[_field][block.number] = _value;
        blockArrayMap[_field].push(block.number);

        emit LogUpdateHistorySnapshot(_field, "bytes", historyMap[_field][block.number], msg.sender, block.number);
    }
    /**
     * @dev 增加bytes32类型的历史快照
     * @param _field 存储字段
     * @param _value 存储的值
     */
    function updateBytes32(string memory _field, bytes32 _value) public valid {
        historyMap[_field][block.number] = abi.encode(_value);
        blockArrayMap[_field].push(block.number);

        emit LogUpdateHistorySnapshot(_field, "bytes32", historyMap[_field][block.number], msg.sender, block.number);
    }
    /**
     * @dev 增加string类型的历史快照
     * @param _field 存储字段
     * @param _value 存储的值
     */
    function updateString(string memory _field, string memory _value) public valid {
        historyMap[_field][block.number] = abi.encode(_value);
        blockArrayMap[_field].push(block.number);
        
        emit LogUpdateHistorySnapshot(_field, "string", historyMap[_field][block.number], msg.sender, block.number);
    }
    /**
     * @dev 增加uint256类型的历史快照
     * @param _field 存储字段
     * @param _value 存储的值
     */
    function updateUint256(string memory _field, uint256 _value) public valid {
        historyMap[_field][block.number] = abi.encode(_value);
        blockArrayMap[_field].push(block.number);
        
        emit LogUpdateHistorySnapshot(_field, "uint256", historyMap[_field][block.number], msg.sender, block.number);
    }
    /**
     * @dev 增加address类型的历史快照
     * @param _field 存储字段
     * @param _value 存储的值
     */
    function updateAddress(string memory _field, address _value) public valid {
        historyMap[_field][block.number] = abi.encode(_value);
        blockArrayMap[_field].push(block.number);
        
        emit LogUpdateHistorySnapshot(_field, "address", historyMap[_field][block.number], msg.sender, block.number);
    }
    /**
     * @dev 增加bool类型的历史快照
     * @param _field 存储字段
     * @param _value 存储的值
     */
    function updateBool(string memory _field, bool _value) public valid {
        historyMap[_field][block.number] = abi.encode(_value);
        blockArrayMap[_field].push(block.number);
        
        emit LogUpdateHistorySnapshot(_field, "bool", historyMap[_field][block.number], msg.sender, block.number);
    }

    /**
     * @dev 获取bytes类型的历史快照
     * @param _field 存储字段
     * @param _blockNumber 块号(如果为0则获取最新值)
     * @return 获取到的历史快照
     */
    function getBytes(string memory _field, uint256 _blockNumber) public view returns (bytes memory){
        return historyMap[_field][blockArrayMap[_field][getIndex(_blockNumber, blockArrayMap[_field])]];
    }
    /**
     * @dev 获取bytes32类型的历史快照
     * @param _field 存储字段
     * @param _blockNumber 块号(如果为0则获取最新值)
     * @return 获取到的历史快照
     */
    function getBytes32(string memory _field, uint256 _blockNumber) public view returns (bytes32){
        return abi.decode(historyMap[_field][blockArrayMap[_field][getIndex(_blockNumber, blockArrayMap[_field])]], (bytes32));
    }
    /**
     * @dev 获取string类型的历史快照
     * @param _field 存储字段
     * @param _blockNumber 块号(如果为0则获取最新值)
     * @return 获取到的历史快照
     */
    function getString(string memory _field, uint256 _blockNumber) public view returns (string memory){
        return abi.decode(historyMap[_field][blockArrayMap[_field][getIndex(_blockNumber, blockArrayMap[_field])]], (string));
    }
    /**
     * @dev 获取uint256类型的历史快照
     * @param _field 存储字段
     * @param _blockNumber 块号(如果为0则获取最新值)
     * @return 获取到的历史快照
     */
    function getUint256(string memory _field, uint256 _blockNumber) public view returns (uint256){
        return abi.decode(historyMap[_field][blockArrayMap[_field][getIndex(_blockNumber, blockArrayMap[_field])]], (uint256));
    }
    /**
     * @dev 获取address类型的历史快照
     * @param _field 存储字段
     * @param _blockNumber 块号(如果为0则获取最新值)
     * @return 获取到的历史快照
     */
    function getAddress(string memory _field, uint256 _blockNumber) public view returns (address){
        return abi.decode(historyMap[_field][blockArrayMap[_field][getIndex(_blockNumber, blockArrayMap[_field])]], (address));
    }
    /**
     * @dev 获取bool类型的历史快照
     * @param _field 存储字段
     * @param _blockNumber 块号(如果为0则获取最新值)
     * @return 获取到的历史快照
     */
    function getBool(string memory _field, uint256 _blockNumber) public view returns (bool){
        return abi.decode(historyMap[_field][blockArrayMap[_field][getIndex(_blockNumber, blockArrayMap[_field])]], (bool));
    }

    /**
     * @dev 获取bytes类型的所有历史快照节点
     * @param _field 存储字段
     * @return blockNumbers 获取到的历史快照
     * @return values 获取到的历史快照对应的值
     */
    function getBytesHistory(string memory _field) public view returns (uint256[] memory blockNumbers, bytes[] memory values){
        blockNumbers = blockArrayMap[_field];
        values = new bytes[](blockNumbers.length);
        
        for(uint256 i = 0; i < blockNumbers.length; i++){
            values[i] = historyMap[_field][blockNumbers[i]];
        }   
    }

    /**
     * @dev 获取bytes32类型的所有历史快照节点
     * @param _field 存储字段
     * @return blockNumbers 获取到的历史快照
     * @return values 获取到的历史快照对应的值
     */
    function getBytes32History(string memory _field) public view returns (uint256[] memory blockNumbers, bytes32[] memory values){
        blockNumbers = blockArrayMap[_field];
        values = new bytes32[](blockNumbers.length);
        
        for(uint256 i = 0; i < blockNumbers.length; i++){
            values[i] = abi.decode(historyMap[_field][blockNumbers[i]], (bytes32));
        }   
    }
    /**
     * @dev 获取string类型的所有历史快照节点
     * @param _field 存储字段
     * @return blockNumbers 获取到的历史快照
     * @return values 获取到的历史快照对应的值
     */
    function getStringHistory(string memory _field) public view returns (uint256[] memory blockNumbers, string[] memory values){
        blockNumbers = blockArrayMap[_field];
        values = new string[](blockNumbers.length);

        for(uint256 i = 0; i < blockNumbers.length; i++){
            values[i] = abi.decode(historyMap[_field][blockNumbers[i]], (string));
        }   
    }
    /**
     * @dev 获取uint256类型的所有历史快照节点
     * @param _field 存储字段
     * @return blockNumbers 获取到的历史快照
     * @return values 获取到的历史快照对应的值
     */
    function getUint256History(string memory _field) public view returns (uint256[] memory blockNumbers, uint256[] memory values){
        blockNumbers = blockArrayMap[_field];
        values = new uint256[](blockNumbers.length);        

        for(uint256 i = 0; i < blockNumbers.length; i++){
            values[i] = abi.decode(historyMap[_field][blockNumbers[i]], (uint256));
        }   
    }
    /**
     * @dev 获取address类型的所有历史快照节点
     * @param _field 存储字段
     * @return blockNumbers 获取到的历史快照
     * @return values 获取到的历史快照对应的值
     */
    function getAddressHistory(string memory _field) public view returns (uint256[] memory blockNumbers, address[] memory values){
        blockNumbers = blockArrayMap[_field];
        values = new address[](blockNumbers.length);
        
        for(uint256 i = 0; i < blockNumbers.length; i++){
            values[i] = abi.decode(historyMap[_field][blockNumbers[i]], (address));
        }   
    }
    /**
     * @dev 获取bool类型的所有历史快照节点
     * @param _field 存储字段
     * @return blockNumbers 获取到的历史快照
     * @return values 获取到的历史快照对应的值
     */
    function getBoolHistory(string memory _field) public view returns (uint256[] memory blockNumbers, bool[] memory values){
        blockNumbers = blockArrayMap[_field];
        values = new bool[](blockNumbers.length);

        for(uint256 i = 0; i < blockNumbers.length; i++){
            values[i] = abi.decode(historyMap[_field][blockNumbers[i]], (bool));
        }   
    }

    /**
     * @dev 辅助方法:二分法获取array中第一个小于_blockNumber的块号下标
     * @param _blockNumber 要查询的块号(如果为0则获取最新值)
     * @param array 块号数组
     * @return result 计算得到的块号下标
     */
    function getIndex(uint256 _blockNumber, uint256[] memory array) internal pure returns (uint256 result) {
        require(array.length != 0, "HistorySnapshotV2::operate failed: Snapshot for this field is empty");
        if (_blockNumber == 0){
            return array.length - 1;
        }

        uint256 left = 0;
        uint256 right = array.length - 1;

        while (left <= right) {
            uint256 mid = (left + right) >> 2;
            if (array[mid] == _blockNumber) {
                return mid;
            } else if (array[mid] < _blockNumber) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }

        return right;
    }
}