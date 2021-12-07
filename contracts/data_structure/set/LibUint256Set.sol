pragma solidity ^0.4.25;

/**
* @author wpzczbyqy <weipengzhen@czbyqy.com>
* @title  uint256类型集合操作
* 提供uint256集合类型操作，包括新增元素，删除元素，获取元素等
**/

library LibUint256Set {

    struct Uint256Set {
        uint256[] values;
        mapping(uint256 => uint256) indexes;
    }

    /**
    *@dev uint256集合是否包含某个元素
    *@param  set uint256类型集合
    *@param  val 待验证的值
    *@return bool 是否包含该元素，true 包含；false 不包含
    **/
    function contains(Uint256Set storage  set, uint256 val) internal view returns (bool) {
        return set.indexes[val] != 0;
    }

    /**
    *@dev uint256集合，增加一个元素
    *@param  set uint256类型集合
    *@param  val 待增加的值
    *@return bool 是否成功添加了元素
    **/
    function add(Uint256Set storage set, uint256 val) internal view returns (bool) {

        if(!contains(set, val)){
            set.values.push(val);
            set.indexes[val] = set.values.length;
            return true;
        }
        return false;
    }

    /**
    *@dev uint256集合，删除一个元素
    *@param  set uint256类型集合
    *@param  val 待删除的值
    *@return bool 是否成功删除了元素
    **/
    function remove(Uint256Set storage set, uint256 val) internal view returns (bool) {

        uint256 valueIndex = set.indexes[val];

        if(contains(set,val)){
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set.values.length - 1;

            if(toDeleteIndex != lastIndex){
                uint256 lastValue = set.values[lastIndex];
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
    *@param  set uint256类型集合
    *@return uint256[] 返回集合中的所有元素
    **/
    function getAll(Uint256Set storage set) internal view returns (uint256[] memory) {
        return set.values;
    }

    /**
    *@dev    获取集合中元素的数量
    *@param  set uint256类型集合
    *@return uint256 集合中元素数量
    **/
    function getSize(Uint256Set storage set) internal view returns (uint256) {
        return set.values.length;
    }

    /**
    *@dev 某个元素在集合中的位置
    *@param  set uint256类型集合
    *@param  val 待查找的值
    *@return bool,uint256 是否存在此元素与该元素的位置
    **/
    function atPosition (Uint256Set storage set, uint256 val) internal view returns (bool, uint256) {
        if(contains(set, val)){
            return (true, set.indexes[val]-1);
        }
        return (false, 0);
    }

    /**
    *@dev 根据索引获取集合中的元素
    *@param  set uint256类型集合
    *@param  index 索引
    *@return uint256 查找到的元素
    **/
    function getByIndex(Uint256Set storage set, uint256 index) internal view returns (uint256) {
        require(index < set.values.length,"Index: index out of bounds");
        return set.values[index];
    }

    /**
    *@dev 求两个集合的并集 a ∪ b
    *@param  set a uint256类型集合
    *@param  set b uint256类型集合
    *@return uint256[] 并集元素
    **/
    function union(Uint256Set storage a, Uint256Set storage b) internal view returns (uint256[]){
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
    *@param  set a uint256类型集合
    *@param  set b uint256类型集合
    *@return uint256[] 差集元素
    **/
    function relative(Uint256Set storage a, Uint256Set storage b) internal view returns (uint256[]){
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
    *@param  set a uint256类型集合
    *@param  set b uint256类型集合
    *@return uint256[] 交集元素
    **/
    function intersect(Uint256Set storage a, Uint256Set storage b) internal view returns (uint256[]){
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