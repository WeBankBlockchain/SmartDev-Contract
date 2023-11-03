pragma solidity ^0.4.25;

import "./LibBytes32Set.sol";
contract Bytes32SetDemo {
    
    using LibBytes32Set for LibBytes32Set.Bytes32Set;

    LibBytes32Set.Bytes32Set private bytesSet;
    LibBytes32Set.Bytes32Set private bytesSet2;

    function add() public view returns (bool) {
        return
            bytesSet.add(
                0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCF
            );
    }

    // 检查集合中是否包含指定的元素
    function contains() public view returns (bool) {
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCF
        );
        return
            bytesSet.contains(
                0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCF
            );
    }

    // 获取所有元素
    function getAll() public view returns (bytes32[]) {
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA
        );
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB
        );
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC
        );
        return bytesSet.getAll();
    }

    // 删除指定的元素并返回剩余元素
    function remove(bytes32 del) public view returns (bytes32[]) {
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA
        );
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB
        );
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC
        );
        bytesSet.remove(del);
        return bytesSet.getAll();
    }

    // 删除指定的元素并返回指定元素位置
    function removeAndAtPositon(bytes32 del, bytes32 key)
        public
        view
        returns (bool, uint256)
    {
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA
        );
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB
        );
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC
        );
        bytesSet.remove(del);
        return bytesSet.atPosition(key);
    }

    // 获取集合的大小
    function getSize() public view returns (uint256) {
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA
        );
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB
        );
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC
        );
        return bytesSet.getSize();
    }

    // 根据索引获取集合中的元素
    function getByIndex(uint256 index) public view returns (bytes32) {
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA
        );
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB
        );
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC
        );
        return bytesSet.getByIndex(index);
    }

    // 检查指定元素在集合中的位置
    function atPosition() public view returns (bool, uint256) {
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA
        );
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB
        );
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC
        );
        return
            bytesSet.atPosition(
                0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC
            );
    }

    // 求两个集合的并集
    function union() public view returns (bytes32[] memory) {
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);

        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCD);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCE);
        return bytesSet.union(bytesSet2);
    }

    // 求两个集合的差集
    function relative() public view returns (bytes32[] memory) {
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);

        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCD);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCE);
        return bytesSet.relative(bytesSet2);
    }

    // 求两个集合的交集
    function intersect() public view returns (bytes32[] memory) {
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);

        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCD);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCE);
        return bytesSet.intersect(bytesSet2);
    }
}