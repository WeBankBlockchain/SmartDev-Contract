## 存证模板背景说明

电子存证是一种用于保存证据的手段，应用场景很多，例如在版权领域，作者可以将作品指纹保存到电子存证机构，当出现版权纠纷时，可通过取证解决纠纷。存证、取证的关键环节是电子存证服务机构，如何保证它的可信性，即存证机构本身不会对存证数据进行破坏？传统的中心化存证机构很难解决这个问题，需要由区块链技术来解决。在区块链技术中，电子账本由各个节点共同维护，其内容由共识算法决定，单一节点无法篡改已达成共识的账本数据。这一不可篡改的特性是去中心化电子存证方案的核心。该方案中，存证数据不再存储于单一机构，而是分布式地存储在所有区块链节点上。

## 场景说明

本模板支持基于多签的存证场景。该场景中，包含几个角色：存证方、审核方、存储方、取证方：

    - 存证方：提交存证申请。
    - 审核方：审核存证申请，申请通过后交由存储方保存。
    - 存储方：保存存证数据。在去中心化方案中，由区块链上的智能合约充当存储方。
    - 取证方：提取存证数据。

## 接口

提供了三个合约：Evidence合约，EvidenceRepository合约，RequestRepository合约，Authentication合约。其中Evidence合约是对外服务合约，其余合约是辅助合约，用于数据和逻辑分离。

Evidence合约：对外服务的唯一接口。包含：
    - createSaveRequest(byte32 hash, bytes ext): 存证方提交存证请求。hash是存证数据摘要，ext可选地存放说明信息
    - getRequestData(bytes32 hash): 审核方查看存证请求，以便审核。包括ext等信息
    - voteSaveRequest(bytes32 hash)：审核方批准存证请求。投票全部通过后，
    - getEvidence(bytes32 hash): 取证方查看存证数据，包括时间戳、持有人等信息

## 使用示例

假如现在要创建一个2-3投票的存证合约，然后上传存证、审核存证、查看存证，整个过程如下：

合约初始化：

    - 管理员部署EvidenceRepository合约
    - 管理员部署RequestRepository合约，构造时传入threshold参数为2、voters列表为3个投票者
    - 管理员部署Evidence合约
    - 管理员调用EvidenceRepository.allow和RequestRepository.allow，参数传入Evidence合约地址，这一步是指定仅有Evidence合约可以调用EvidenceRepository和RequestRepository
    
合约调用：

    - 存证方调用Evidence.createSaveRequest提交存证请求
    - 审核者调用Evidence.getRequestData查看存证请求；调用voteSaveRequest批准审核请求
    - 审核通过后，取证方调用Evidence.getEvidence查看存证数据






