# 病历管理合约
## 数据结构：

### CaseHistory：定义了一个病历的结构体，包含了病历的各个字段，如主诉、现病史、既往史等。
#### 函数：

+ addCaseHistoryBaseInfo：添加病历基本信息的函数。需要传入主诉、现病史、既往史等参数，并指定主治医生、患者和医院的ID。该函数会创建一个新的病历对象，并将其保存到caseHistoryInfos映射中，并返回这个病历的索引。
+ addCaseHistoryDiagnosticTests：添加病历辅助检查信息的函数。需要传入病历的索引、辅助检查结果和患者ID。该函数会将辅助检查结果添加到对应病历对象的diagnosticTests字段中。
+ addCaseHistoryPreliminaryDiagnosis：添加病历初步诊断和诊疗信息的函数。需要传入病历的索引、初步诊断结果、诊疗方案和患者ID。该函数会将初步诊断结果和诊疗方案添加到对应病历对象的preliminaryDiagnosis和diagnosisAndTreatment字段中。
## 注意事项：

+ addCaseHistoryDiagnosticTests和addCaseHistoryPreliminaryDiagnosis函数在调用之前，需要先确认调用者是否为该患者的主治医生。
每个患者可以有多个病历信息，通过患者ID和索引来进行查找和管理。

# 病人管理合约
这个合约是一个患者基本信息管理合约，用于存储和管理患者的基本信息。以下是合约中定义的数据结构和函数的解释：

### 数据结构：

+ PatientInfo：定义了患者的基本信息结构体，包含身份证、姓名、年龄、性别和电话等字段。
函数：

+ addPatient：添加患者的函数。需要传入身份证、姓名、年龄、性别和电话等参数，并对传入的参数进行校验。如果校验通过，则创建一个新的患者对象，并将其保存到patientInfos映射中。
+ updateAge：更新患者年龄的函数。需要传入身份证和新的年龄参数，并确保调用者是该患者本人。如果年龄参数的长度大于0，则更新患者对象中对应的年龄字段。
+ updatePhone：更新患者电话号码的函数。需要传入身份证和新的电话号码参数，并确保调用者是该患者本人。如果电话号码参数的长度大于0，则更新患者对象中对应的电话号码字段。
+ registration：患者挂号的函数。需要传入身份证和医生的地址参数。该函数会将医生地址添加到对应患者在views映射中的权限列表中，表示该医生有权限查看该患者的基本信息。
+ authDoctor：由系统管理员强制授权医生查看患者基本信息的函数。需要传入身份证和医生的地址参数，并确保调用者是合约的拥有者（系统管理员）。该函数会将医生地址添加到对应患者在views映射中的权限列表中，表示该医生有权限查看该患者的基本信息。
+ getPatientBaseInfo：获取患者基本信息的函数。需要传入身份证参数，并确保调用者具有查看该患者基本信息的权限。如果满足条件，则返回患者的姓名、年龄、性别和电话号码等信息。
注意事项：

+ addPatient函数在调用之前，会进行一系列的参数校验，包括身份证长度、姓名长度、年龄、性别和电话号码长度等。
每个患者都有一个唯一的身份证作为标识，用于管理其基本信息。
医生可以通过挂号或由系统管理员授权的方式获得查看患者基本信息的权限。
+ checkViewAddr修饰器用于限制只有具有查看权限的用户才能执行某些函数操作。
合约使用了Ownable.sol库来管理合约的所有权，并使用了StrUtils.sol和Roles.sol库来处理字符串和角色权限的相关操作。

# 医院信息管理合约
这是一个医院信息管理合约，用于存储和管理医院、科室和医生的基本信息。以下是合约中定义的数据结构和函数的解释：

## 数据结构：

+ Hospital：定义了医院的基本信息结构体，包含医院ID、医院名称、医院简介和科室等字段。
+ Department：定义了科室的基本信息结构体，包含科室ID、科室名称、科室简介、出诊时间、出诊地点、咨询电话和医生等字段。
+ Doctor：定义了医生的基本信息结构体，包含医生ID、职称、医生姓名和医生简介等字段。
函数：

+ addHospital：添加医院的函数。需要传入医院ID、医院名称、医院简介和医院地址参数，并对传入的参数进行校验。如果校验通过，则创建一个新的医院对象，并将其保存到hospitalInfos映射中。
+ updateHospitaShortIntroduction：更新医院简介的函数。需要传入医院ID和新的医院简介参数，并确保调用者是合约的拥有者（系统管理员）。如果医院ID存在且校验通过，则更新医院对象中对应的医院简介字段。
+ addHospitalDepartment：添加医院科室的函数。需要传入医院ID、科室ID、科室名称、科室简介、出诊时间、出诊地点和咨询电话等参数，并确保调用者是合约的拥有者（系统管理员）。如果医院ID存在且校验通过，则创建一个新的科室对象，并将其保存到对应医院在departments映射中的科室列表中。
+ updateDepartmentShortIntroduction：更新科室简介的函数。需要传入医院ID、科室ID和新的科室简介参数，并确保调用者是合约的拥有者（系统管理员）。如果医院ID和科室ID存在且校验通过，则更新科室对象中对应的科室简介字段。
+ updateDepartmentVisitTime：更新科室出诊时间的函数。需要传入医院ID、科室ID和新的出诊时间参数，并确保调用者是合约的拥有者（系统管理员）。如果医院ID和科室ID存在且校验通过，则更新科室对象中对应的出诊时间字段。
+ addDoctor：添加医生的函数。需要传入医院ID、科室ID、职称、医生姓名和医生简介等参数，并确保调用者是合约的拥有者（系统管理员）。如果医院ID和科室ID存在且校验通过，则创建一个新的医生对象，并将其保存到对应科室在doctors映射中的医生列表中。
+ updateDoctorJobTitle：更新医生职称的函数。需要传入医院ID、科室ID、医生ID和新的职称参数，并确保调用者是合约的拥有者（系统管理员）。如果医院ID、科室ID和医生ID存在且校验通过，则更新医生对象中对应的职称字段。
+ updateDoctorShortIntroduction：更新医生简介的函数。需要传入医院ID、科室ID、医生ID和新的医生简介参数，并确保调用者是合约的拥有者（系统管理员）。如果医院ID、科室ID和医生ID存在且校验通过，则更新医生对象中对应的医生简介字段。
+ getHosipitalBaseInfo：获取这是一个医院合约，用于管理医院、科室和医生的信息。以下是合约中的主要部分：
+ 结构体：Hospital、Department和Doctor分别表示医院、科室和医生的信息。
+ 映射：hospitalInfos保存了医院信息，hospitalRegisters用于判断某个医院是否已存在。
+ 修饰符：MustNoExist用于检查医院ID是否已存在，MustYesExist用于检查医院ID是否已存在。
+ 函数：
+ addHospital：添加医院信息。
+ updateHospitaShortIntroduction：更新医院简介。
+ addHospitalDepartment：添加医院科室信息。
+ updateDepartmentShortIntroduction：更新科室简介。
+ updateDepartmentVisitTime：更新科室出诊时间。
+ addDoctor：添加医生信息。
+ updateDoctorJobTitle：更新医生职称。
+ updateDoctorShortIntroduction：更新医生简介。
+ getHosipitalBaseInfo：获取医院基本信息。
+ getDepartmentIndex：获取科室索引。
+ getDepartmentBaseInfo：获取科室基本信息。
+ getDoctorIndex：获取医生索引。
+ getDoctorBaseInfo：获取医生基本信息。
+ 此合约允许管理员添加和更新医院、科室和医生的信息，并提供了通过医院ID、科室ID和医生ID获取相应信息的函数。同时，它还使用了Roles库来管理用户角色。请注意，此合约假定传入的参数有效且已进行验证。