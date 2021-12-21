pragma solidity >=0.4.26;
import "./library.sol";
//用于做安全运算
library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}
contract LibraryMangement{
        using Library for *;
        using SafeMath for uint;
        Library.user_info user_self;
        uint public endtime;
        uint public starttime;
        address public LibraryAddress;  
        //构造函数，传入图书馆的地址，学生还书还这个地址   
        constructor(address _LibraryMangement) public{
           LibraryAddress=_LibraryMangement;
          
        }    
        //学生信息结构体                
        struct student_info{
            string sname;//学生名字
            uint sno;//学号
            address studentaddress;//注册地址
            uint time;//注册时间 时间戳防伪
            uint books_available;//可借书本数量
            uint integrity_points;//诚信积分
        }  
        mapping(bytes32 => student_info) public student_dic;
        //书本信息，包括书可租借状态及书名
         struct books{
            string booksname;//书名
            uint boooksid;
            mapping (string => uint) find_booksid;//将书本名与书本id映射起来，便于用户找书
            mapping(uint => bool) check_leasestatus;//将书本id和可租借状态关联起来
            mapping(uint => uint) return_time;//将书本的id与应该归还时间映射起来，便于查看有没有按时还
        }
        mapping(address => books) public books_dic;//即将书本信息与图书馆地址映射起来，可以理解为书全部在图书馆内
        //用户注册函数
        function student_register(string _sname,uint _sno)public returns(bytes32 secretkey){
            secretkey=Library.RegisterUser(user_self,_sname,_sno,msg.sender,block.timestamp);
            student_dic[secretkey]=student_info(_sname,_sno,msg.sender,block.timestamp,5,100);
            return secretkey;
        }  
        //管理员添加书籍函数
        function publish(string _bookname,uint _bookid)public returns(bool){
         books_dic[LibraryAddress]=books(_bookname,_bookid);//将书本信息存储到图书馆
         books_dic[LibraryAddress].find_booksid[_bookname]=_bookid;
         books_dic[LibraryAddress].check_leasestatus[_bookid]=false;//书本默认状态为false即未被租借，当书本被借走后状态改为true则不可租借
             return true;
        }   
        //学生借书函数
        function Borrowbooks(string _booksname,bytes32 _usersecretkey) public returns(string){
            uint _booksid;
            _booksid=findbooksid(_booksname);//通过书名查到书的id,如果id=0则代表书不存在
            starttime=block.timestamp;//开始借书时间
            require(_booksid!=0,"这本书不存在");
            require(student_dic[_usersecretkey].studentaddress==msg.sender,"当前用户地址不是借书者地址账户错误");
            require(student_dic[_usersecretkey].books_available>0,"您所借的书已经达到上限，还书后才可以再借");
            require(books_dic[LibraryAddress].check_leasestatus[_booksid]==false,"这本书已经被借走了，再看看其他的书吧");
            if(student_dic[_usersecretkey].integrity_points<20){
                revert("您有过多逾期还书记录，诚信积分已经低于20，被封禁借书了");
            }
            if(student_dic[_usersecretkey].integrity_points>150){
                endtime=starttime+100000;//诚信积分越多能借的期限越长
            }
            if(student_dic[_usersecretkey].integrity_points>=100 && student_dic[_usersecretkey].integrity_points<=150)
            {
                endtime=starttime+50000;
            }
            else
            {
                endtime=starttime+30000;
            }
            //上述条件均满足借书，1改变书的状态2用户可借书的 数目减1
             books_dic[LibraryAddress].check_leasestatus[_booksid]=true;//代表书已经被借走了
            books_dic[LibraryAddress].return_time[_booksid]=endtime;//将这本书的应该归还时间与书本id映射起来
            student_dic[_usersecretkey].books_available-=1;//用户可租借书本数量减1
            return("  借书成功!： ");
        }

        //归还图书函数：传入书本id和用户密钥
        function Returnbooks(uint _booksid,bytes32 _usersecretkey)public returns(string,uint){
               require(student_dic[_usersecretkey].studentaddress==msg.sender,"当前用户地址不是借书者地址账户错误");
                 require(books_dic[LibraryAddress].check_leasestatus[_booksid]==true,"这本书还没有被借走");
            //没有按时归还，还是可以归还，但是信用分要扣分
            if( books_dic[LibraryAddress].return_time[_booksid]<block.timestamp){
                //修改这本书的状态，变为可以租借
                 books_dic[LibraryAddress].check_leasestatus[_booksid]=false;
                //用户可租借书本数量加1
                student_dic[_usersecretkey].books_available+=1;
                //用户信用积分减10
                student_dic[_usersecretkey].integrity_points-=10;
                return("还书成功，您已逾期还书，信用积分扣10分，请以后注意。信用分低于20将无法借书，您目前的信用积分为:",student_dic[_usersecretkey].integrity_points);
            }
            //按时还书了
            else{
                //修改这本书的状态，变为可以租借
                books_dic[LibraryAddress].check_leasestatus[_booksid]=false;
                //用户可租借书本数量加1
                student_dic[_usersecretkey].books_available+=1;
                //用户信用积分加10
                student_dic[_usersecretkey].integrity_points+=10; 
                return("还书成功，感谢您按时还书，您的信用积分将加10分，当你分数大于150后，你可以选择用积分换取更多的借书数量，并且你允许借书的时常也将增加,您目前的信用积分为",student_dic[_usersecretkey].integrity_points);
            }
        }
       //传入用户密钥及用户想要增加的借书数量，我们设定每100分多还1本书
        function Reward(bytes32 _usersecretkey,uint num) public returns(string,uint){
            require(student_dic[_usersecretkey].integrity_points>300);
            if(student_dic[_usersecretkey].integrity_points-100*num>300){
                //调用SafeMath中的加函数
                student_dic[_usersecretkey].books_available=SafeMath.add(student_dic[_usersecretkey].books_available,num);
                //调用SafeMath中的-函数，这个优点在于它已经写好了抛出溢出情况，避免导致溢出问题
                student_dic[_usersecretkey].integrity_points=SafeMath.sub(student_dic[_usersecretkey].integrity_points,100*num);
            }
            else{
                revert("积分不够，继续积累积分");
            }
        }
     function findbooksid(string _booksname) public view returns(uint){
                return(books_dic[LibraryAddress].find_booksid[_booksname]);
        }
    

}

