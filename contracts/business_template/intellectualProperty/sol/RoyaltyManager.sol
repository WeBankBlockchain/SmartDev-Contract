pragma solidity ^0.4.25;

contract RoyaltyManager {

    struct Pricing {
        uint256 price;//售卖价格
        mapping(address => uint256) distribution;//每个参与者的分成，可以是百分比【需要业务端限制百分比，比如这里为10，标识10%】，也可以数值等其他设定
    }

    mapping(bytes32 => Pricing) public pricings;

    event PricingSet(bytes32 indexed workHash, uint256 price);
    event DistributionUpdated(bytes32 indexed workHash, address indexed participant, uint256 percentage);
    event PricingRevoked(bytes32 indexed workHash);

    modifier onlyWorkOwner(address workOwner) {
        require(tx.origin == workOwner, "只有作品拥有者可以进行操作");
        _;
    }

    function setPricing(bytes32 workHash, address workOwner, uint256 price) public onlyWorkOwner(workOwner) {
        pricings[workHash].price = price;
        emit PricingSet(workHash, price);
    }
    //更新收益分配
    function updateDistribution(bytes32 workHash, address workOwner, address participant, uint256 percentage) public onlyWorkOwner(workOwner) {
        pricings[workHash].distribution[participant] = percentage;
        emit DistributionUpdated(workHash, participant, percentage);
    }
    
    function revokePricing(bytes32 workHash, address workOwner) public onlyWorkOwner(workOwner) {
        delete pricings[workHash];
        emit PricingRevoked(workHash);
    }
}
