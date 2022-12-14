## 说明
多方投票治理

## 使用
> 多方投票治理合约 Ballot.sol
- 部署合约
- `constructor` 传入 `bytes32`, `bytes32[]`
  - bytes32: 主题名称
  - bytes32[]: 提案内容集
- ...

## 属性
- chairperson: 发起人
- subjectName: 主题名称
- voters: 投票人信息
 - uint weight: 投票权重
 - bool voted: 是否已投票
 - address delegate: 授权地址
 - uint vote: 提案的索引
- proposals: 提案信息集合
 - bytes32 name: 提案名称
 - uint voteCount: 投票次数
 
## 接口
- constructor(bytes32 _subjectName, bytes32[] memory _proposalNames): 创建提案合约
- giveRightToVote(address _voter): 提案合约创建人给指定地址投票权限
- delegate(address _ballot, address _to): 将指定提案合约的投票权授权给指定地址
- vote(address _ballot, uint _proposal): 给指定提案投票
- winningProposal(address _ballot): 返回指定提案合约的最多票数提案的索引
- winnerName(address _ballot): 返回指定提案合约的最多票数提案的名称
- getChairperson(): 获取发起人
- getSubjectName(): 获取主题名称
- getVoters(address _ballot, address _voter): 获取指定提案合约的投票人的信息
- getProposalsLength(address _ballot): 获取指定提案合约的提案个数
- getProposals(address _ballot, uint _proposalIndex): 获取指定提案合约的指定提案的信息

## 示例
> 部署 Ballot.sol

1. 部署 `Ballot.sol` 传入 `主题名称`, `提案内容集`

2. 调用 `giveRightToVote` 添加新投票人

3. 可以调用 `delegate(address _ballot, address _to)` 将指定提案合约的投票权授权给指定地址

4. 可以调用 `vote(address _ballot, uint _proposal)` 给指定提案投票

4. 调用 `winnerName(address _ballot):` 获取指定提案合约的最多票数提案的名称

5. ...
