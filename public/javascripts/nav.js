function changeStyle(newObj) {
	if(obj==null) {
    	obj=newObj;
        obj.className='';
    }else {
        if(obj!=newObj) {
        	obj.className='selected';
        	obj=newObj;
        	obj.className='';
        }
    }
}