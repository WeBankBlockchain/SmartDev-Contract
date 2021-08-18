pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

//学生成绩管理系统示例
//分三个维度记录， 分别为 年份、班级、学号

import "./DataTable.sol";

//学生成绩
contract Grades is DataItem{
    struct gradeNode{
        bytes32 subject;
        int16 score;
    }
    gradeNode[] grades;
    
    function add(bytes32 subj, int16 sc) public {
        grades.push(gradeNode({subject:subj, score:sc}));
    }
    function getGrades()public view returns(gradeNode[] memory){
        return grades;
    }
}

contract Class is DataItem, Map{
    
}


contract StudentsGradesDemo{
    DataTable schoolGrades;
    
    event newStudentEvent(bytes32 studentId);
    event newClassEvent(bytes32 classId);
    
    event logAddr(address  addr);
    event logVal(bytes32  val);
    event logScore(int16 score);
    
    constructor(){
         schoolGrades = new DataTable();
    }
    //添加成绩
    function addGrades(bytes32 year, bytes32 classId, bytes32 studentId, bytes32 subject, int16 score) public {
        Class class;
        if(schoolGrades.isExists(year, classId)){
            class = Class(schoolGrades.getItem(year, classId));
        } else {
            class = new Class();
            schoolGrades.insertItem(year, classId, class);
            emit newClassEvent(classId);
        }
        if(class.isExists(studentId)){
            Grades gds = Grades(class.getValue(studentId));
            gds.add(subject, score);
        } else {
            Grades gd = new Grades();
            gd.add(subject, score);
            class.insert(studentId, gd);
            emit newStudentEvent(studentId);
        }
    }
    //查询学生所有科目的成绩
    function select(bytes32 year, bytes32 classId, bytes32 studentId) public  returns(Grades.gradeNode[] memory){
        require(schoolGrades.isExists(year, classId), "The year class is not exists" );
        Class class = Class(schoolGrades.getItem(year, classId));
        emit logAddr(class);
        require(class.isExists(studentId), "The student is not exists" );
        Grades gd = Grades(class.getValue(studentId));
        return gd.getGrades();
    }
    
    //查询总分
     function selectTotal(bytes32 year, bytes32 classId, bytes32 studentId) public  returns(int16 totalScore){
         Grades.gradeNode[] memory gdList = select(year, classId, studentId);
         for(var i = 0; i < gdList.length; i++){
             totalScore += gdList[i].score;
         }
         return totalScore;
     }
     //查询班上总分最高的学生
     function selectClassFirst(bytes32 year, bytes32 classId) public returns(bytes32, int16){
         require(schoolGrades.isExists(year, classId), "The year class is not exists" );
         Class class = Class(schoolGrades.getItem(year, classId));
         int16 nScore = 0;
         bytes32 strudentId;
         
       
        for(Pair item = class.iterate_start(); class.can_iterate(item);item = class.iterate_next(item)){
            emit logVal(item.getKey());
             
            var totalScore = selectTotal(year, classId, item.getKey());
            emit  logScore(totalScore);
               
            if(totalScore > nScore){
                 nScore = totalScore;
                 strudentId = item.getKey();
             }
          }
         return (strudentId,nScore);
     }

     //查询年级总分最高的学生
     function selectYearFirst(bytes32 year) public  returns(bytes32, bytes32, int16){
         var  row = schoolGrades.getRow(year);        
         int16 bScore = 0;
         bytes32 classId;
         bytes32 strudentId;
         for(Pair classIt = row.iterate_start(); row.can_iterate(classIt); classIt = row.iterate_next(classIt)){
             Class class = Class(classIt.getValue());
             for(Pair it = class.iterate_start(); class.can_iterate(it); it = class.iterate_next(it)){
                 var totalScore = selectTotal(year, classIt.getKey(), it.getKey());
                 if(totalScore > bScore){
                     bScore = totalScore;
                     strudentId = it.getKey();
                     classId = classIt.getKey();
                 }
             }
         }
         return (classId,strudentId,bScore);
     }
     
     function testAdd() public  {
         addGrades(bytes32("2021"), bytes32("101"), bytes32("20210101"), bytes32("ch"), 120);
         addGrades(bytes32("2021"), bytes32("101"), bytes32("20210101"), bytes32("en"), 110);
         addGrades(bytes32("2021"), bytes32("101"), bytes32("20210101"), bytes32("math"), 130);
	  
         addGrades(bytes32("2021"), bytes32("101"), bytes32("20210102"), bytes32("ch"), 140);
         addGrades(bytes32("2021"), bytes32("101"), bytes32("20210102"), bytes32("en"), 100);
         addGrades(bytes32("2021"), bytes32("101"), bytes32("20210102"), bytes32("math"), 110);
	  
         addGrades(bytes32("2021"), bytes32("102"), bytes32("20210201"), bytes32("ch"), 140);
         addGrades(bytes32("2021"), bytes32("102"), bytes32("20210201"), bytes32("en"), 110);
         addGrades(bytes32("2021"), bytes32("102"), bytes32("20210201"), bytes32("math"), 130);
							  
         addGrades(bytes32("2020"), bytes32("102"), bytes32("20210201"), bytes32("ch"), 130);
         addGrades(bytes32("2020"), bytes32("102"), bytes32("20210201"), bytes32("en"), 140);
         addGrades(bytes32("2020"), bytes32("102"), bytes32("20210201"), bytes32("math"), 120);
     
     }
     
       function testSelect() public  returns(int16) {
         return selectTotal(bytes32("2021"), bytes32("101"), bytes32("20210101"));
     }
       function testClassFirst() public  returns(bytes32, int16) {
         return selectClassFirst(bytes32("2021"), bytes32("101"));
     }
       function testYearFirst() public  returns(bytes32, bytes32, int16) {
         return selectYearFirst(bytes32("2021"));
     }
}