pragma solidity ^0.4.25;

library LibMerkleTree {
    bytes32 constant private NULL = bytes32(0);

    struct MerkleTree {
        MerkleNode root;
        mapping(bytes32 => MerkleNode) nodes;
		uint nodesCount;
    }
    struct MerkleNode {
        bytes32 value;
        bytes32 left;
        bytes32 right;
    }

    // ------------------------------------------------------------------------
    //函数名： 构建默克尔树
    //参数： _leafs 所有原始叶子节点数据，双sha256哈希生成的结果
    //参数： _tree  用于存储生成的默克尔树，必须是空的
    // ------------------------------------------------------------------------
    function constructMerkleTree(bytes32[] memory _leafs, MerkleTree storage _tree) internal {
		require(isEmpty(_tree));
		
        MerkleNode[] memory nodeList = new MerkleNode[](_leafs.length);
		uint nodeListSize = 0;
		
        for(uint i=0; i<_leafs.length; i++) {
            nodeList[nodeListSize].value = _leafs[i];
			nodeList[nodeListSize].left  = NULL;
			nodeList[nodeListSize].right = NULL;
			nodeListSize++;
        }
		
        MerkleNode[] memory resultNodeList = new MerkleNode[]((nodeListSize+1)/2);
        for(;;) {
			uint resultNodeListSize = 0;
			
            for(i=0; i<nodeListSize; i+=2) {
                //每连续两个节点构造一个新的节点
                bytes32 left = nodeList[i].value;
                _tree.nodes[left] = nodeList[i];
				_tree.nodesCount++;
                bytes32 right;
                if(i+1 < nodeListSize) {
                    right = nodeList[i+1].value;
                    _tree.nodes[right] = nodeList[i+1];
                } else {
                    right = left;
                }
				_tree.nodesCount++;
                resultNodeList[resultNodeListSize].value = sha256(sha256(concat(left, right)));
				resultNodeList[resultNodeListSize].left  = left;
				resultNodeList[resultNodeListSize].right = right;
				resultNodeListSize++;
            }

            if(resultNodeListSize == 1) {
                _tree.root = resultNodeList[0];
				_tree.nodesCount++;
				return;
            } else {
                //把nodeList清空
                nodeListSize = 0;

                //把resultNodeList数据复制到nodeList中
                for(uint j=0; j<resultNodeListSize; j++) {
                    nodeList[nodeListSize] = resultNodeList[j];
                    nodeListSize++;
                }
            }
        }
    }

    // ------------------------------------------------------------------------
    // 功能： 验证默克尔树
    // 参数： root 默克尔树根节点
    // 返回： 默克尔树是否正确
    // ------------------------------------------------------------------------
    function verifyMerkleTree(MerkleTree storage _tree) internal view returns(bool) {
        MerkleNode[] memory nodeList =  new MerkleNode[](_tree.nodesCount);
		uint nodeListSize = 0;
        
        nodeList[0] = _tree.root;
		nodeListSize++;
        for(uint i=0; i<_tree.nodesCount; i++) { 
            if(nodeList[i].left == NULL && nodeList[i].right == NULL) {
                continue;
            }
            if(nodeList[i].value != sha256(sha256(concat(nodeList[i].left, nodeList[i].right)))) {
                return false;
            }

			nodeList[nodeListSize] = _tree.nodes[nodeList[i].left];
			nodeListSize++;
			
			//当左右子树相同的时候只需要验证左子树就行了
			if(nodeList[i].right != nodeList[i].left) {
				nodeList[nodeListSize] = _tree.nodes[nodeList[i].right];
				nodeListSize++;
			}
        }
        return true;
    }
    
    //todo: 清空默克尔树

	// ------------------------------------------------------------------------
    // 功能： 判断一棵默克尔树是否为空
    // 参数： root 默克尔树根节点
    // 返回： 默克尔树是否正确
    // ------------------------------------------------------------------------
	function isEmpty(MerkleTree storage _tree) internal view returns(bool) {
        return _tree.nodesCount == 0;
    }
    
	// ------------------------------------------------------------------------
    // 功能： 连接两个类型为bytes32数据输出一个类型为bytes数据
    // 参数： b1 第一个bytes32数据
	// 参数： b2 第二个bytes32数据
    // 返回： 连接后的数据
    // ------------------------------------------------------------------------
    function concat(bytes32 b1, bytes32 b2) internal returns (bytes memory)
	{
		bytes memory result = new bytes(64);
		assembly {
			mstore(add(result, 32), b1)
			mstore(add(result, 64), b2)
		}
		return result;
	}
}