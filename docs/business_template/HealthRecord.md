## 医疗档案模板背景说明

在医疗信息跨机构之间流通与共享的过程中会有很多数据共享的需求。但目前在医疗行业普遍存在医疗数据收集不全、管理不规范、存在信息孤岛、泄露个体隐私、数据灰色交易等多种问题，这些问题造成组织之间协作的信任成本高昂，从而制约了整个医疗行业服务质量的发展。区块链技术在数据共享安全、协同治理以及数据真实可溯不可篡改方面的优势，为不同机构间数据共享提供了便利。

## 场景说明

本模板提供患者医疗健康数据链上存证和数据共享的场景。该场景中，包含几个角色：患者、医生、第三方机构医疗信息使用者：

    - 患者/医生/第三方机构注册上链：患者/医生/第三方机构册个人相关信息，在链上存储；
    - 患者授权给医生/第三方机构：患者将自己id信息共享授权给医生/第三方机构；
    - 医生增加患者病历文件；医生获得患者授权后，将诊断报告文件信息上链，包括文件名、文件类型、文件哈希以及文件密钥；
    - 患者病历文件密钥获取：患者/医生/第三方机构去链上获取病历文件密钥信息；用于应用层对诊断报告文件解密；
    - 患者病历信息查询：患者/医生/第三方机构去链上查询患者的病历文件信息；


HealthRecord合约：对外服务的唯一接口。包含：
- signupPatient(string memory _ssid, string memory _name, uint8 _age): 患者注册
- signupDoctor(string memory _name): 医生注册
- signupAgency(string memory _name)：第三方数据共享机构注册
- grantAccessToDoctor(address doctor_id) public checkPatient(msg.sender) checkDoctor(doctor_id): 患者给医生授权，将医生id加入患者所属医生列表以及患者id加入医生管理的患者列表
- getPatientInfoForDoctor(address pat): 医生获取相应患者信息
- getPatientInfo(): 患者本人查询个人病历信息
- getFileSecret(bytes32 fileHashId, string memory role, address id, address pat):获取文件密钥，在获取密钥后，在应用层对诊断报告文件进行解密
- getFileInfoDoctor(address doc, address pat, bytes32 fileHashId): 医生查询患者某一诊断病历文件信息
- getFileInfoPatient(address pat, bytes32 fileHashId): 患者查询自己某一诊断病历文件信息
- grantAccessToAgency(address agency_id)：患者给机构授权，将机构id加入患者所属机构列表以及患者id加入机构管理的患者列表
- getPatientInfoForAgency(address pat): 第三方机构获取机构下患者信息
- getFileInfoAgency(address agy, address pat, bytes32 fileHashId): 第三方机构查询患者某一诊断病历文件信息


## 使用示例

假如现在要创建一个医疗档案合约，整个过程如下：

合约初始化：

    - 管理员部署HealthRecord合约和Auth合约
    
合约调用：

    - 调用注册合约方法先进行相关机构及人员注册；
    - 再进行其他合约方法调用；
    
    


