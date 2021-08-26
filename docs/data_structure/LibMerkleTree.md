# LibMerkleTree.sol

LibMerkleTree提供了默克尔树的生成和验证方法。

## 使用方法

首先需要通过import引入LibMerkleTree类库，然后通过"."进行方法调用，如下为调用LibMerkleTree方法的例子：

```
pragma solidity ^0.4.25;

import "./LibMerkleTree.sol";

contract MerkleTreeDemo {
    using LibMerkleTree for LibMerkleTree.MerkleTree;
    
    
    LibMerkleTree.MerkleTree simpleMerkleTree;
	LibMerkleTree.MerkleTree evenLeafsMerkleTree;
    LibMerkleTree.MerkleTree oddLeafsMerkleTree;
	
	event PrintRoot(bytes32 v);
    
	//测试自行构建简单的2叶子节点的默克尔树
    function constructSimpleMerkleTree(bytes32 _left, bytes32 _right) public {
        bytes32[] memory leafs = new bytes32[](2);
        leafs[0] = _left;
        leafs[1] = _right;
        LibMerkleTree.constructMerkleTree(leafs, simpleMerkleTree);
		emit PrintRoot(simpleMerkleTree.root.value);
    }
    
	//测试构建叶子节点数量是偶数的默克尔树
    function constructEvenLeafsMerkleTree() public {
        bytes32[] memory leafs = new bytes32[](4);
        leafs[0] = 0x876dd0a3ef4a2816ffd1c12ab649825a958b0ff3bb3d6f3e1250f13ddbf0148c;
        leafs[1] = 0xc40297f730dd7b5a99567eb8d27b78758f607507c52292d02d4031895b52f2ff;
        leafs[2] = 0xc46e239ab7d28e2c019b6d66ad8fae98a56ef1f21aeecb94d1b1718186f05963;
        leafs[3] = 0x1d0cb83721529a062d9675b98d6e5c587e4a770fc84ed00abc5a5de04568a6e9;
        
        LibMerkleTree.constructMerkleTree(leafs, evenLeafsMerkleTree);
        require(evenLeafsMerkleTree.root.value == 0x6657a9252aacd5c0b2940996ecff952228c3067cc38d4885efb5a4ac4247e9f3);
    }
	
	//测试构建叶子节点数量是奇数的默克尔树
	function constructOddLeafsMerkleTree() public {
        bytes32[] memory leafs = new bytes32[](9);
        leafs[0] = 0xa3f3ac605d5e4727f4ea72e9346a5d586f0231460fd52ad9895bc8240d871def;
        leafs[1] = 0x076d0317ee70ee36cf396a9871ab3bf6f8e6d538d7f8a9062437dcb71c75fcf9;
        leafs[2] = 0x2ee1e12587e497ada70d9bd10d31e83f0a924825b96cb8d04e8936d793fb60db;
        leafs[3] = 0x7ad8b910d0c7ba2369bc7f18bb53d80e1869ba2c32274996cebe1ae264bc0e22;
        leafs[4] = 0x4e3f8ef2e91349a9059cb4f01e54ab2597c1387161d3da89919f7ea6acdbb371;
        leafs[5] = 0xe0c28dbf9f266a8997e1a02ef44af3a1ee48202253d86161d71282d01e5e30fe;
        leafs[6] = 0x8719e60a59869e70a7a7a5d4ff6ceb979cd5abe60721d4402aaf365719ebd221;
        leafs[7] = 0x5310aedf9c8068f1e862ac9186724f7fdedb0aa9819833af4f4016fca6d21fdd;
        leafs[8] = 0x201f4587ec86b58297edc2dd32d6fcd998aa794308aac802a8af3be0e081d674;
        
        LibMerkleTree.constructMerkleTree(leafs, oddLeafsMerkleTree);
		require(oddLeafsMerkleTree.root.value == 0x5275289558f51c9966699404ae2294730c3c9f9bda53523ce50e9b95e558da2f);
    }
    
	//测试成功验证叶子节点数量是奇数的默克尔树
    function verifyOddLeafsMerkleTreeSuccess() public view {
        require(LibMerkleTree.verifyMerkleTree(oddLeafsMerkleTree));
    }
	
    //测试成功验证叶子节点数量是偶数的默克尔树
    function verifyEvenLeafsMerkleTreeSuccess() public view {
        require(LibMerkleTree.verifyMerkleTree(evenLeafsMerkleTree));
    }
	
	//故意修改叶子节点数量是偶数的默克尔树根节点数据，让执行验证默克尔树失败
	function verifyEvenLeafsMerkleTreeFailed() public {
		evenLeafsMerkleTree.root.value = 0x123456;
        require(!LibMerkleTree.verifyMerkleTree(evenLeafsMerkleTree));
    }
}
```
### demo中的函数调用顺序 
1. constructEvenLeafsMerkleTree
2. constructOddLeafsMerkleTree
3. verifyOddLeafsMerkleTreeSuccess
4. verifyEvenLeafsMerkleTreeSuccess
5. verifyEvenLeafsMerkleTreeFailed
6. constructSimpleMerkleTree


## API列表

编号 | API | API描述
---|---|---
1 | *constructMerkleTree(bytes32[] memory _leafs, MerkleTree storage _tree) public* |构建默克尔树
2 | *verifyMerkleTree(MerkleTree storage _tree) public view returns(bool)* |验证默克尔树


## API详情

### ***1. constructMerkleTree 函数***

构建默克尔树

#### 参数

- _leafs：原始数据，用于构建默克尔树的叶子节点
- _tree: 存储生成的默克尔树数据

#### 返回值


#### 实例

```
pragma solidity ^0.4.25;

import "./LibMerkleTree.sol";

contract MerkleTreeDemo {
    using LibMerkleTree for LibMerkleTree.MerkleTree;
    
    
    LibMerkleTree.MerkleTree simpleMerkleTree;
	LibMerkleTree.MerkleTree evenLeafsMerkleTree;
    LibMerkleTree.MerkleTree oddLeafsMerkleTree;
	
	event PrintRoot(bytes32 v);
    
	//测试自行构建简单的2叶子节点的默克尔树
    function constructSimpleMerkleTree(bytes32 _left, bytes32 _right) public {
        bytes32[] memory leafs = new bytes32[](2);
        leafs[0] = _left;
        leafs[1] = _right;
        LibMerkleTree.constructMerkleTree(leafs, simpleMerkleTree);
		emit PrintRoot(simpleMerkleTree.root.value);
    }
    
	//测试构建叶子节点数量是偶数的默克尔树
    function constructEvenLeafsMerkleTree() public {
        bytes32[] memory leafs = new bytes32[](4);
        leafs[0] = 0x876dd0a3ef4a2816ffd1c12ab649825a958b0ff3bb3d6f3e1250f13ddbf0148c;
        leafs[1] = 0xc40297f730dd7b5a99567eb8d27b78758f607507c52292d02d4031895b52f2ff;
        leafs[2] = 0xc46e239ab7d28e2c019b6d66ad8fae98a56ef1f21aeecb94d1b1718186f05963;
        leafs[3] = 0x1d0cb83721529a062d9675b98d6e5c587e4a770fc84ed00abc5a5de04568a6e9;
        
        LibMerkleTree.constructMerkleTree(leafs, evenLeafsMerkleTree);
        require(evenLeafsMerkleTree.root.value == 0x6657a9252aacd5c0b2940996ecff952228c3067cc38d4885efb5a4ac4247e9f3);
    }
	
	//测试构建叶子节点数量是奇数的默克尔树
	function constructOddLeafsMerkleTree() public {
        bytes32[] memory leafs = new bytes32[](9);
        leafs[0] = 0xa3f3ac605d5e4727f4ea72e9346a5d586f0231460fd52ad9895bc8240d871def;
        leafs[1] = 0x076d0317ee70ee36cf396a9871ab3bf6f8e6d538d7f8a9062437dcb71c75fcf9;
        leafs[2] = 0x2ee1e12587e497ada70d9bd10d31e83f0a924825b96cb8d04e8936d793fb60db;
        leafs[3] = 0x7ad8b910d0c7ba2369bc7f18bb53d80e1869ba2c32274996cebe1ae264bc0e22;
        leafs[4] = 0x4e3f8ef2e91349a9059cb4f01e54ab2597c1387161d3da89919f7ea6acdbb371;
        leafs[5] = 0xe0c28dbf9f266a8997e1a02ef44af3a1ee48202253d86161d71282d01e5e30fe;
        leafs[6] = 0x8719e60a59869e70a7a7a5d4ff6ceb979cd5abe60721d4402aaf365719ebd221;
        leafs[7] = 0x5310aedf9c8068f1e862ac9186724f7fdedb0aa9819833af4f4016fca6d21fdd;
        leafs[8] = 0x201f4587ec86b58297edc2dd32d6fcd998aa794308aac802a8af3be0e081d674;
        
        LibMerkleTree.constructMerkleTree(leafs, oddLeafsMerkleTree);
		require(oddLeafsMerkleTree.root.value == 0x5275289558f51c9966699404ae2294730c3c9f9bda53523ce50e9b95e558da2f);
    }
}
```
### ***2. verifyMerkleTree 函数***

验证默克尔树是否正确无误

#### 参数

- _tree: 待验证的默克尔树

#### 返回值

- bool：默克尔树正确返回true，有错误返回false

#### 实例

```
pragma solidity ^0.4.25;

import "./LibMerkleTree.sol";

contract MerkleTreeDemo {
    using LibMerkleTree for LibMerkleTree.MerkleTree;
    
	LibMerkleTree.MerkleTree evenLeafsMerkleTree;
    
	//测试构建叶子节点数量是偶数的默克尔树
    function constructEvenLeafsMerkleTree() public {
        bytes32[] memory leafs = new bytes32[](4);
        leafs[0] = 0x876dd0a3ef4a2816ffd1c12ab649825a958b0ff3bb3d6f3e1250f13ddbf0148c;
        leafs[1] = 0xc40297f730dd7b5a99567eb8d27b78758f607507c52292d02d4031895b52f2ff;
        leafs[2] = 0xc46e239ab7d28e2c019b6d66ad8fae98a56ef1f21aeecb94d1b1718186f05963;
        leafs[3] = 0x1d0cb83721529a062d9675b98d6e5c587e4a770fc84ed00abc5a5de04568a6e9;
        
        LibMerkleTree.constructMerkleTree(leafs, evenLeafsMerkleTree);
        require(evenLeafsMerkleTree.root.value == 0x6657a9252aacd5c0b2940996ecff952228c3067cc38d4885efb5a4ac4247e9f3);
    }
	
    //测试成功验证叶子节点数量是偶数的默克尔树
    function verifyEvenLeafsMerkleTreeSuccess() public view {
        require(LibMerkleTree.verifyMerkleTree(evenLeafsMerkleTree));
    }
	
	//故意修改叶子节点数量是偶数的默克尔树根节点数据，让执行验证默克尔树失败
	function verifyEvenLeafsMerkleTreeFailed() public {
		evenLeafsMerkleTree.root.value = 0x123456;
        require(!LibMerkleTree.verifyMerkleTree(evenLeafsMerkleTree));
    }
}
```

