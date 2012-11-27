/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

    
//判断是否输入数据<input type="text" name="aa"><br>
//判断数量<input type="text" name="bb" onChange="return isNumber(this,'');"><br>
 
//判断数量,可以为负数<input type="text" name="dd" onChange="return isNegative(this,'');"><br>
 
//判断金额<input type="text" name="cc" onChange="return isMoney(this,'');"><br>
 
//判断时间<input type="text" name="ee" onChange="return isDate(this)"><br> 
//
//去掉空格
function Trim(str){
    if(str.charAt(0) == " "){
        str = str.slice(1);
        str = Trim(str);
    }
    return str;
}
//判断是否是空
function isEmpty(pObj,errMsg){
    var obj = eval(pObj);
    if( obj == null || Trim(obj.value) == ""){
        if (errMsg == null || errMsg =="")
            alert("输入为空!");
        else
            alert(errMsg); 
        obj.focus(); 
        return false;
    }
    return true;
}
//判断是否是数字
function isNumber(pObj,errMsg){
    var obj = eval(pObj);
    strRef = "1234567890";
    if(!isEmpty(pObj,errMsg))return false;
    for (i=0;i<obj.value.length;i++) {
        tempChar= obj.value.substring(i,i+1);
        if (strRef.indexOf(tempChar,0)==-1) {
            if (errMsg == null || errMsg =="")
                alert("数据不符合要求,请检查");
            else
                alert(errMsg);
            if(obj.type=="text") 
                obj.focus(); 
            return false; 
        }
    }
    return true;
}


//判断是否是数字,数字可以为负数
function isNegative(pObj,errMsg){
    var obj = eval(pObj);
    strRef = "1234567890-";
    if(!isEmpty(pObj,errMsg))return false;
    for (i=0;i<obj.value.length;i++) {
        tempChar= obj.value.substring(i,i+1);
        if (strRef.indexOf(tempChar,0)==-1) {
            if (errMsg == null || errMsg =="")
                alert("数据不符合要求,请检查");
            else
                alert(errMsg);
            if(obj.type=="text") 
                obj.focus(); 
            return false; 
        }else{
            if(i>0){
                if(obj.value.substring(i,i+1)=="-"){
                    if (errMsg == null || errMsg =="")
                        alert("数据不符合要求,请检查");
                    else
                        alert(errMsg);   
                    if(obj.type=="text") 
                        obj.focus(); 
                    return false; 
                }
            }
        }
    }
    return true;
}

//判断是否是钱的形式
function isMoney(pObj,errMsg){
    var obj = eval(pObj);
    strRef = "1234567890.";
    if(!isEmpty(pObj,errMsg)) return false;
    for (i=0;i<obj.value.length;i++) {
        tempChar= obj.value.substring(i,i+1);
        if (strRef.indexOf(tempChar,0)==-1) {
            if (errMsg == null || errMsg =="")
                alert("数据不符合要求,请检查");
            else
                alert(errMsg);   
            if(obj.type=="text") 
                obj.focus(); 
            return false; 
        }else{
            tempLen=obj.value.indexOf(".");
            if(tempLen!=-1){
                strLen=obj.value.substring(tempLen+1,obj.value.length);
                if(strLen.length>2){
                    if (errMsg == null || errMsg =="")
                        alert("数据不符合要求,请检查");
                    else
                        alert(errMsg);   
                    if(obj.type=="text") 
                        obj.focus(); 
                    return false; 
                }
            }
        }
    }
    return true;
}

function isLeapYear(year)
{
    if((year%4==0&&year%100!=0)||(year%400==0))
    {
        return true;
    } 
    return false;
}

//判断时间是否正确
function isDate(checktext){
    var datetime;
    var year,month,day;
    var gone,gtwo;
    if(Trim(checktext.value)!=""){
        datetime=Trim(checktext.value);
        if(datetime.length==10){
            year=datetime.substring(0,4);
            if(isNaN(year)==true){
                alert("请输入日期!格式为(yyyy-mm-dd) \n例(2001-01-01)！");
                checktext.focus();
                return false;
            }
            gone=datetime.substring(4,5);
            month=datetime.substring(5,7);
            if(isNaN(month)==true){
                alert("请输入日期!格式为(yyyy-mm-dd) \n例(2001-01-01)！");
                checktext.focus();
                return false;
            }
            gtwo=datetime.substring(7,8);
            day=datetime.substring(8,10);
            if(isNaN(day)==true){
                alert("请输入日期!格式为(yyyy-mm-dd) \n例(2001-01-01)！");
                checktext.focus();
                return false;
            }
            if((gone=="-")&&(gtwo=="-")){
                if(month<1||month>12) {
                    alert("月份必须在01和12之间!");
                    checktext.focus();
                    return false;
                }
                if(day<1||day>31){
                    alert("日期必须在01和31之间!");
                    checktext.focus();
                    return false;
                }else{
                    if(month==2){ 
                        if(isLeapYear(year)&&day>29){
                            alert("二月份日期必须在01到29之间!");
                            checktext.focus();
                            return false;
                        }      
                        if(!isLeapYear(year)&&day>28){
                            alert("二月份日期必须在01到28之间!");
                            checktext.focus();
                            return false;
                        }
                    }
                    if((month==4||month==6||month==9||month==11)&&(day>30)){
                        alert("在四，六，九，十一月份 \n日期必须在01到30之间!");
                        checktext.focus();
                        return false;
                    }
                }
            }else{
                alert("请输入日期!格式为(yyyy-mm-dd) \n例(2001-01-01)");
                checktext.focus();
                return false;
            }
        }else{
            alert("请输入日期!格式为(yyyy-mm-dd) \n例(2001-01-01)");
            checktext.focus();
            return false;
        }
    }else{
        return true;
    }
    return true;
}

//数字大于0
function overZero(pObj,errMsg){
    var obj = eval(pObj);
    if(isNumber(obj,errMsg)){
        if(obj.value<1){
            alert(errMsg);
            obj.focus();
            return false;        
        }
    }else{ return false;}
    return true;
}
