pragma solidity ^0.4.25;



contract CopyrightManager {
   

    struct Work {
        address owner;
        string title;
        uint256 timestamp;
        string metadata;
        bool exists;
    }

    mapping(bytes32 => Work) public works;

    event WorkRegistered(bytes32 indexed workHash, address indexed owner, string title, uint256 timestamp);
    event WorkUpdated(bytes32 indexed workHash, string newTitle, string newMetadata);
    event WorkRevoked(bytes32 indexed workHash);

    modifier onlyOwner(bytes32 workHash) {
        require(works[workHash].owner == tx.origin, "只有作品拥有者可以进行操作");
        _;
    }

    function registerWork(bytes32 workHash, string _title, string _metadata) public {
        require(!works[workHash].exists, "作品已存在");
        works[workHash] = Work(tx.origin, _title, now, _metadata, true);
        emit WorkRegistered(workHash, tx.origin, _title, now);
    }

    function updateWork(bytes32 workHash, string newTitle, string newMetadata) public onlyOwner(workHash) {
        require(works[workHash].exists, "作品不存在");
        works[workHash].title = newTitle;
        works[workHash].metadata = newMetadata;
        emit WorkUpdated(workHash, newTitle, newMetadata);
    }

    function revokeWork(bytes32 workHash) public onlyOwner(workHash) {
        require(works[workHash].exists, "作品不存在");
        delete works[workHash];
        emit WorkRevoked(workHash);
    }
}
