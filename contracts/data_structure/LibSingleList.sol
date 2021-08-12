 pragma solidity ^0.4.25;
 
 library LibSingleList {
     bytes32 constant private NULL = bytes32(0);
     struct ListNode{
         bytes32 nextNode;
         bool exist;
     }
     struct List{
        mapping(bytes32 => ListNode) data;
        bytes32 header;
        bytes32 tail;
        uint256 size;
    }

    struct Iterate{
        bytes32 value;
        bytes32 prevNode;
    }
    
    function pushBack(List storage self, bytes32 ele) internal {
        require(!self.data[ele].exist, "the element is already exists");
        if(self.size == 0){
            addFirstNode(self, ele);
        } else {
            self.data[ele] = ListNode({nextNode:NULL, exist:true});
            self.data[self.tail].nextNode = ele;
            self.tail = ele;
        }

        self.size++;
    }
    
    function pushFront(List storage self, bytes32 ele) internal {
        require(!self.data[ele].exist, "the element is already exists");
        if(self.size == 0){
           addFirstNode(self, ele);
        } else {
            self.data[ele] = ListNode({nextNode:self.header, exist:true});
            self.header = ele;
        }
        self.size++;
    }
    //删除一个元素 o(n)
    function remove(List storage self, bytes32 ele) internal  {
        Iterate memory iter = find(self, ele);
        if(iter.value != NULL){
            remove(self, iter);
        }
    }
    //查找 o(n)
    function find(List storage self, bytes32 ele) internal returns(Iterate memory) {
        require(self.data[ele].exist, "the node is not exists" ); 
        bytes32 prev = NULL;
        bytes32 beg = self.header;
        while(beg != NULL){
            if(beg == ele){
                Iterate memory iter = Iterate({value:ele, prevNode:prev});
                return iter;
            }
            prev = beg;
            beg = self.data[beg].nextNode;
        }
        return Iterate({value:NULL, prevNode:NULL});
    }

    function remove(List storage self, Iterate memory iter) internal returns(Iterate memory){
        require(self.data[iter.value].exist, "the node is not exists" );
        Iterate memory nextIter = Iterate({value:self.data[iter.value].nextNode, prevNode:iter.prevNode});
        if(iter.prevNode == NULL) {
            self.header = self.data[iter.value].nextNode;
        } else {
            self.data[iter.prevNode].nextNode = self.data[iter.value].nextNode;
        }
        delete self.data[iter.value];
        if(self.header == NULL){
            self.tail = NULL;
        }
        self.size--;
        return nextIter;
    }

    function insertNext(List storage self, Iterate memory iter, bytes32 ele)internal {
        require(self.data[iter.value].exist, "the node is not exists" );
        bytes32 next = self.data[iter.value].nextNode;
        self.data[ele] = ListNode({nextNode:next, exist:true});
        self.data[iter.value].nextNode = ele;
        if(self.tail == iter.value){
            self.tail = ele;
        }
        self.size++;
    }

    function insertPrev(List storage self, Iterate memory iter, bytes32 ele) internal{
        require(self.data[iter.value].exist, "the node is not exists" );
        self.data[ele] = ListNode({nextNode:iter.value, exist:true});
        if(self.header == iter.value){
            self.header = ele;
        } else {
            require(self.data[iter.prevNode].exist, "the prev node is not exists" );
            self.data[iter.prevNode].nextNode = ele;
        }
         self.size++;
    }
    
    function addFirstNode(List storage self, bytes32 ele)  private {
        ListNode memory node = ListNode({nextNode:NULL, exist:true});
        self.data[ele] = node;
        self.header =  ele;
        self.tail = ele;
    }

    function getBack(List storage self) internal returns(bytes32) {
        require(self.size > 0, "the list is empty" ); 
        return self.tail;
    }

    function getFront(List storage self) internal returns(bytes32) {
        require(self.size > 0, "the list is empty" ); 
        return self.header;
    }
    
    function getSize(List storage self) internal view returns(uint256){
       return self.size;
    }
    
    function isEmpty(List storage self) internal view returns(bool){
        return self.size == 0;
    }

    function isExists(List storage self, bytes32 ele) internal view returns(bool){
        return self.data[ele].exist;
    }
    
    function begin(List storage self) internal view returns(Iterate){
        Iterate memory iter = Iterate({value:self.header, prevNode:NULL});
        return iter;   
    }
    
    function isEnd(List storage self, Iterate memory iter) internal view returns(bool){
        return iter.value == NULL;
    }
    
    function nextNode(List storage self, Iterate memory iter) internal view returns(Iterate){
        require(self.data[iter.value].exist, "the node is not exists" );
        Iterate memory nextIter = Iterate({value:self.data[iter.value].nextNode, prevNode:iter.value});
        return nextIter;
    }
    
 }