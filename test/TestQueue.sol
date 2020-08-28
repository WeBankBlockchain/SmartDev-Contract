pragma solidity ^0.4.25;

import "./LibQueue.sol";

contract TestQueue {
    
    using LibQueue for LibQueue.Queue;
    
    LibQueue.Queue private queue;
    
    constructor(){
        queue = LibQueue.newQueue();
    }
    
    function f() public {
        queue.enqueue(1);
        queue.enqueue(2);
        bytes32 pop = queue.dequeue();//Expected to be 1
        uint size = queue.queueSize();//Expected to be 1
    }
    
}
