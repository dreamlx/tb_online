// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
    function display(id){

        var traget=document.getElementById(id);
         if(traget.style.display=="none"){
                 traget.style.display="";
         }else{
                 traget.style.display="none";
       }
    }
