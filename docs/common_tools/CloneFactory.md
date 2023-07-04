## 说明
如果我们正要部署相同的合约，合约的每个实例都将具有相同的字节码。因此，每个部署存储所有字节码会反复促进字节码的 gas 成本浪费。

对此的解决方案是：只部署一个合约实例原型，让所有其他合约实例原型充当代理，将调用委托给合约的第一个实例原型，并允许函数在代理合约的上下文中运行。这样，合约的每个实例原型都会有自己的状态，并且只需将我们建立的合约实例用作原型库即可。

> 这个示例是克隆多方投票治理合约，通过业务工厂合约创建多方投票治理合约，当然其他业务也可以用这种方式，比如根据某个积分合约克隆出不同的积分合约等等。

## 使用
> 我们将部署原型合约、克隆工厂合约、业务工厂合约
> 原型合约参考：多方投票治理合约 Ballot.sol
- 部署原型合约
- 部署克隆工厂合约
- 部署业务工厂合约

## 属性
- _CLONE_FACTORY_: 克隆工厂合约地址
- _BALLOT_TEMPLATE_: 原型合约地址
 
## 接口
- constructor(address cloneFactory, address ballotTemplate): 创建业务工厂合约
- createBallot(bytes32 _subjectName, bytes32[] memory _proposalNames): 创建一个新的投票合约，并返回新的投票合约的地址。
- updateBallotTemplate(address newBallotTemplate): 管理员操作更新原型合约地址

## 示例
> 原型合约 Ballot.sol 得到合约地址
> 部署克隆工厂合约 CloneFactory.sol 得到合约地址
> 部署业务工厂合约 BallotFactory.sol 得到合约地址

1. 部署 `BallotFactory.sol` 传入 `克隆工厂合约地址`, `原型合约地址`

2. 调用 `createBallot` 传入投票合约的基本信息来创建一个新的投票合约，并返回新的投票合约的地址。

3. 可以调用 `updateBallotTemplate` 来更新原型合约地址

4. ...
