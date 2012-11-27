/**
 * 检查字符串的合法性
 * input为需要检查的字符串，checkString为合法字符串
 * 郑东晖 2002-09-18
 * @return
 */
  function check(input,checkString)
  {
    var ok = true;
    if(input==null||input.length==0) return ok;
    for (var i = 0; i < input.length; i++)
    {
      var chr = input.charAt(i);
      var found = false;
      for (var j = 0; j < checkString.length; j++)
      {
        if (chr == checkString.charAt(j)) found = true;
      }
      if (!found) ok = false;
    }
    return ok;
  }

  /**
   * 检查非法字符
   * input为输入的字符串，checkString为非法的字符串
   * 郑东晖 2002-09-18
   * @return
   */
  function errCheck(input,checkString)
  {
    var ok = true;
    for (var i = 0; i < input.length; i++)
    {
      var chr = input.charAt(i);
      var found = true;
      for (var j = 0; j < checkString.length; j++)
      {
        if (chr == checkString.charAt(j)) found = false;
      }
      if (!found) ok = false;
    }
    return ok;
  }

  /**
   * 根据输入的年月来判断应该显示的日期
   * x,y,z分别是年、月、日的对象
   * 郑东晖 2002-09-18
   * @return
   */
  function generateDate(x,y,z)
  {
    if(!check(x,"1234567890"))
    {
      alert("年份输入有误，请输入数字!");
      return false;
    }

    //判断闰年
    var dayfor2=28;
    if((x % 100 != 0 && x % 4==0)||( x % 100 == 0 && x % 400==0)) dayfor2=29;


    //闰年2月
    if(y==2) dayOfMonth=dayfor2;
    //非2月
    if(y!=2)
    {
      dayOfMonth=30
    }
    //大月

    if((y<8&&y % 2==1) || (y > 7 &&y % 2 ==0)) dayOfMonth=31;

	if(z<1 || z>dayOfMonth)
	{
		return false;
	}
    return true;

  }

  /**
   * 检查电话号码
   * 郑东晖 2002-09-18
   * @return
   */
  function telCheck(input)
  {
    return check(input,"0123456789-() +");
  }

  /**
   * 纯数字检查
   * 郑东晖 2002-09-18
   * @return
   */
  function digCheck(input)
  {
    return check(input,"0123456789");
  }

  /**
   * 检查登陆名，只能a-z,A-Z,_,0-9字母开头
   * 郑东晖 2002-09-18
   * @return
   */
  function loginCheck(input)
  {
    result=true;
    result=check(input,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_");
    if(!check(input.charAt[0],"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")) result=false;
    return result;
  }
  /**
   * 检查链接，只能包含a-z,A-Z,_,0-9,.,
   * zhubin 2004-07-12
   * @return
   */
  function linkCheck(input)
  {
    result=true;
    result=check(input,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_.:/");
    return result;
  }

  /**
   * 描述性文字检查非法字符&%$'
   * 郑东晖 2002-09-18
   * @return
   */
  function descCheck(input)
  {
    return errCheck(input,"&%$'");
  }

  /**
   * 小数判断
   * 郑东晖 2002-09-18
   * @return
   */
  function floatCheck(input)
  {
    //return check(input,"0123456789.");
    var regE = /^(([0-9])+)(.([0-9])+)?$/;
    if(regE.test(input))
      return true;
    else
      return false;
  }
  /**
   * 整数判断
   *@author 黄永欣 2005-06-06
   * 数量
   * @return
   */
  function amountCheck(input)
  {
    var regE = /^(([0-9])+)$/;
    if(regE.test(input))
      return true;
    else
      return false;
  }
   /**
   * 小数判断
   *@author 黄永欣 2005-06-06
   * 检查是否符合元的输入法（小数有两位）
   * @return
   */
   function yuanCheck(input)
  {
    
    var regE = /^(([0-9])+)(.([0-9]){1,2})?$/;
    if(regE.test(input))
      return true;
    else
      return false;
  }

  /**
   * 输入名称判断
   * fisher
   * @return
   */
  function nameCheck(input){
  	return errCheck(input,"!$&%'");
  }

  /**
   * 输入时间判断，只能为yyyy-MM-dd格式
   * fisher
   * @return
   */
  function dateCheck(checkDate){
  var regE = /^(\d{4})-([1-9]|0[1-9]|1[0-2])-([1-9]|0[1-9]|[1-2]\d|3[0-1])$/;
  if(regE.test(checkDate))
  {
  x=checkDate.substring(0,checkDate.indexOf("-"));
  y=checkDate.substring(checkDate.indexOf("-")+1,checkDate.lastIndexOf("-"));
  z=checkDate.substring(checkDate.lastIndexOf("-")+1,checkDate.length);

  return generateDate(x,y,z);
  }
  else
      return false;
  }

  function cardNoCheck(input){
    return check(input,"1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM");
  }

  /**
   * 输入ip地址判断,判断ip地址的合法性
   * zhubin
   * @return
   */
   function checkIp(input) {
      if(input==null||input.length==0) return true;
      var flag = true;
      for (var i = 0; i < input.length; i++) {
          var chr = input.charAt(i);
          if(chr=="-") {
             flag=false;
          }
      }
      if(flag==false) {
          if(!check(input,"0123456789.-"))return false;
          var j=0;
          for (var i = 0; i < input.length; i++) {
            var chr = input.charAt(i);
            if(chr==".")j++;
          }
          if(j!=6) return false;
      } else {
          if(!check(input,"0123456789.*"))return false;
          var j=0;
          for (var i = 0; i < input.length; i++) {
            var chr = input.charAt(i);
            if(chr==".")j++;
    }
    if(j!=3) return false;
    }
      return true;
   }
/**
*判断输入时间的有效性，时间格式应遵循hh:mm:ss
*张琦  2004-6-25
*/
   function checkTime(str)
   {
       var regE=/^([0-1][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]/;
       if(!regE.test(str))
       return false;
       else
       return true;
   }
/**
*判断输入email的有效性
*张琦   2004-6-25
*/
   function checkEmail(email)
   {
	   var regE = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/;
	   if(regE.test(email))
		  return true;
	   else
		  return false;
   }

/**
*判断身份证的有效性
*张琦    2004-6-25
*/
   function checkId(id)
   {
       if (id.length!=15 && id.length!=18)
       {
		   return false;
       }
	   return digCheck(id);
   }

   /**
    * 分转成元
    * fisher 2004-6-28
    */
    function fenToYuan(money){
      return money/100;
    }
    
    /**
     * 元转成分
     * tracy 2004-6-28
     */
    function yuanToFen(money){
      return money*100;
    }

    /**
     * 检测输入数据的位数
     * fisher 2004-7-9
     */
    function checkSize(input,size){
      var l = input.replace(/[^\x00-\xff]/g,"**");
      var tmp = l.length;
      if(tmp>size)return false;
      else return true;
    }

    /**
     * 检测文件是否为.xls文件
     * fisher 2004-7-12
     */
    function checkURL(input){
      var regE = /(.txt)$|(.xls)$/;
      if(regE.test(input))
        return true;
      else
        return false;
    }
