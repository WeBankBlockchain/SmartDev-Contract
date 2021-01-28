
contract TableFactory {
    function openTable(string memory) public view returns (Table) {} //open table
    function createTable(string memory, string memory, string memory) public returns (int256) {} //create table
}

//select condition
contract Condition {
    function EQ(string memory, int256) public view{}
    function EQ(string memory, string memory) public view{}

    function NE(string memory, int256) public view{}
    function NE(string memory, string memory) public view{}

    function GT(string memory, int256) public view{}
    function GE(string memory, int256) public view{}

    function LT(string memory, int256) public view{}
    function LE(string memory, int256) public view{}

    function limit(int256) public view{}
    function limit(int256, int256) public view{}
}

//one record
contract Entry {
    function getInt(string memory) public view returns (int256) {}
    function getUInt(string memory) public view returns (uint256) {}
    function getAddress(string memory) public view returns (address) {}
    function getBytes64(string memory) public view returns (bytes1[64] memory) {}
    function getBytes32(string memory) public view returns (bytes32) {}
    function getString(string memory) public view returns (string memory) {}

    function set(string memory, int256) public {}
    function set(string memory, uint256) public {}
    function set(string memory, string memory) public {}
    function set(string memory, address) public {}
}

//record sets
contract Entries {
    function get(int256) public view returns (Entry) {}
    function size() public view returns (int256) {}
}

//Table main contract
contract Table {
    function select(string memory, Condition) public view returns (Entries) {}
    function insert(string memory, Entry) public returns (int256) {}
    function update(string memory, Entry, Condition) public returns (int256) {}
    function remove(string memory, Condition) public returns (int256) {}

    function newEntry() public view returns (Entry) {}
    function newCondition() public view returns (Condition) {}
}

contract KVTableFactory {
    function openTable(string memory) public view returns (KVTable) {}
    function createTable(string memory, string memory, string memory) public returns (int256) {}
}

//KVTable per permiary key has only one Entry
contract KVTable {
    function get(string memory) public view returns (bool, Entry) {}
    function set(string memory, Entry) public returns (int256) {}
    function newEntry() public view returns (Entry) {}
}
