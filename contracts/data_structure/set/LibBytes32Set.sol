pragma solidity ^0.4.25;
/**
* @author wpzczbyqy <weipengzhen@czbyqy.com>
* @title  bytes32类型集合操作
* 提供bytes32集合类型操作，包括新增元素，删除元素，获取元素等
**/

library LibBytes32Set {

    struct Bytes32Set {
        bytes32[] values;
        mapping(bytes32 => uint256) indexes;
    }

    /**
    *@dev byte32集合是否包含某个元素
    *@param  set bytes32类型集合
    *@param  val 待验证的值
    *@return bool 是否包含该元素，true 包含；false 不包含
    **/
    function contains(Bytes32Set storage  set, bytes32 val) internal view returns (bool) {
        return set.indexes[val] != 0;
    }

    /**
    *@dev byte32集合，增加一个元素
    *@param  set bytes32类型集合
    *@param  val 待增加的值
    *@return bool 是否成功添加了元素
    **/
    function add(Bytes32Set storage set, bytes32 val) internal view returns (bool) {

        if(!contains(set, val)){
            set.values.push(val);
            set.indexes[val] = set.values.length;
            return true;
        }
        return false;
    }

    /**
    *@dev byte32集合，删除一个元素
    *@param  set bytes32类型集合
    *@param  val 待删除的值
    *@return bool 是否成功删除了元素
    **/
    function remove(Bytes32Set storage set, bytes32 val) internal view returns (bool) {

        uint256 valueIndex = set.indexes[val];

        if(contains(set,val)){
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set.values.length - 1;

            if(toDeleteIndex != lastIndex){
                bytes32 lastValue = set.values[lastIndex];
                set.values[toDeleteIndex] = lastValue;
                set.indexes[lastValue] = valueIndex;
            }

            delete set.values[lastIndex];
            delete set.indexes[val];
            set.values.length--;

            return true;
        }

        return false;
    }

    /**
    *@dev    获取集合中的所有元素
    *@param  set bytes32类型集合
    *@return bytes32[] 返回集合中的所有元素
    **/
    function getAll(Bytes32Set storage set) internal view returns (bytes32[] memory) {
        return set.values;
    }

    /**
    *@dev    获取集合中元素的数量
    *@param  set bytes32类型集合
    *@return uint256 集合中元素数量
    **/
    function getSize(Bytes32Set storage set) internal view returns (uint256) {
        return set.values.length;
    }

    /**
    *@dev 某个元素在集合中的位置
    *@param  set bytes32类型集合
    *@param  val 待查找的值
    *@return bool,uint256 是否存在此元素与该元素的位置
    **/
    function atPosition (Bytes32Set storage set, bytes32 val) internal view returns (bool, uint256) {
        if(contains(set, val)){
            return (true, set.indexes[val]-1);
        }
        return (false, 0);
    }

    /**
    *@dev 根据索引获取集合中的元素
    *@param  set bytes32类型集合
    *@param  index 索引
    *@return bytes32 查找到的元素
    **/
    function getByIndex(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        require(index < set.values.length,"Index: index out of bounds");
        return set.values[index];
    }

    /**
    *@dev 求两个集合的并集 a ∪ b
    *@param  set a bytes32类型集合
    *@param  set b bytes32类型集合
    *@return bytes32[] 并集元素
    **/
    function union(Bytes32Set storage a, Bytes32Set storage b) internal view returns (bytes32[]){
        if(b.values.length == 0){
            return a.values;
        }
        bool isIn;

        for(uint i = 0; i < b.values.length; i++){
            isIn = contains(a, b.values[i]);
            if(!isIn){
                add(a, b.values[i]);
            }
        }

        return a.values;
    }

    /**
    *@dev 求两个集合的差 a - b
    *@param  set a bytes32类型集合
    *@param  set b bytes32类型集合
    *@return bytes32[] 差集元素
    **/
    function relative(Bytes32Set storage a, Bytes32Set storage b) internal view returns (bytes32[]){
        if(b.values.length == 0){
            return a.values;
        }
        bool isIn;

        for(uint i = 0; i < b.values.length; i++){
            isIn = contains(a, b.values[i]);
            if(isIn){
                remove(a,b.values[i]);
            }
        }

        return a.values;
    }

    /**
    *@dev 求两个集合的交集 a ∩ b
    *@param  set a bytes32类型集合
    *@param  set b bytes32类型集合
    *@return bytes32[] 交集元素
    **/
    function intersect(Bytes32Set storage a, Bytes32Set storage b) internal view returns (bytes32[]){
        if(b.values.length == 0){
            return ;
        }
        bool isIn;

        for(uint i = 0; i < a.values.length; i++){
            isIn = contains(b, a.values[i]);
            if(!isIn){
                remove(a,a.values[i]);
            }
        }

        return a.values;
    }
}