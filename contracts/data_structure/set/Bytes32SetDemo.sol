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

    function contains() public view returns (bool) {
        bytesSet.add(
            0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCF
        );
        return
            bytesSet.contains(
                0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCF
            );
    }

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

    function union() public view returns (bytes32[] memory) {
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);

        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCD);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCE);
        return bytesSet.union(bytesSet2);
    }

    function relative() public view returns (bytes32[] memory) {
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);

        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCD);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCE);
        return bytesSet.relative(bytesSet2);
    }

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
