
var PIXELGIF="/images/pngfix.gif";// ����Ǹ�ͷ1*1���ص�͸��gifͼƬ�������н�b����������ҳ����ͬĿ¼��

var arVersion = navigator.appVersion.split("MSIE");
var version = parseFloat(arVersion[1]);
var pngxp=/\.png$/i;
var AlphaPNGfix= "progid:DXImageTransform.Microsoft.AlphaImageLoader";
function fixPNGAll() {
        if(!document.all) return;
        if ((version >= 5.5 && version < 7) && (document.body.filters)) {
          for(var i=0; i<document.images.length; i++) {
                var img = document.images[i];
                if(img.src && pngxp.test(img.src)) {
                  var imgName = img.src;
                  var imgID = (img.id) ? "id='" + img.id + "' " : "";
                  var imgClass = (img.className) ? "class='" + img.className + "' " : "";
                  var imgTitle = (img.title) ? "title='" + img.title + "' " : "title='" + img.alt + "' ";
                  var imgStyle = "display:inline-block;" + img.style.cssText;
                  if (img.align == "left") imgStyle = "float:left;" + imgStyle;
                  if (img.align == "right") imgStyle = "float:right;" + imgStyle;
                  if (img.parentElement.href) imgStyle = "cursor:hand;" + imgStyle;
                  var strNewHTML = "<span " + imgID + imgClass + imgTitle
                  + " style=\"" + "width:" + img.width + "px; height:" + img.height + "px;" + imgStyle + ";"
                  + "filter:" +AlphaPNGfix
                  + "(src='" + img.src + "', sizingMethod='scale');\"></span>";
                  if (img.useMap) {
                        strNewHTML += "<img style=\"position:relative; left:-" + img.width + "px;"
                        + "height:" + img.height + "px;width:" + img.width +"\" "
                        + "src=\"" + PIXELGIF + "\" usemap=\"" + img.useMap 
                        + "\" border=\"" + img.border + "\">";
                  }
                  img.outerHTML = strNewHTML;
                  i--;
                }
          }
          /* for type=image png button */
          var kmax = document.forms.length;
          for(var k=0; k<kmax; k++) {
                var fmob = document.forms[k];
                var elmarr = fmob.getElementsByTagName("input");
                var jmax = elmarr.length;
                for(var j=0; j<jmax; j++) {
                        var elmob = elmarr[j];
                        if(elmob && elmob.type=="image" && pngxp.test(elmob.src)) {
                                var origsrc = elmob.src;
                                elmob.src = PIXELGIF;
                                elmob.style.filter = AlphaPNGfix+"(src='" +origsrc +"')";
                        }
                }
          }
        }
}

function fixPNG(img) {
        if(!document.all) return;
        var img;
    if(img && img.src && pngxp.test(img.src)) {
      var imgName = img.src;
      var imgID = (img.id) ? "id='" + img.id + "' " : "";
      var imgClass = (img.className) ? "class='" + img.className + "' " : "";
      var imgTitle = (img.title) ? "title='" + img.title + "' " : "title='" + img.alt + "' ";
      var imgStyle = "display:inline-block;" + img.style.cssText;
      if (img.align == "left") imgStyle = "float:left;" + imgStyle;
      if (img.align == "right") imgStyle = "float:right;" + imgStyle;
      if (img.parentElement.href) imgStyle = "cursor:hand;" + imgStyle;
      var strNewHTML = "<span " + imgID + imgClass + imgTitle
      + " style=\"" + "width:" + img.width + "px; height:" + img.height + "px;" + imgStyle + ";"
      + "filter:" +AlphaPNGfix
      + "(src='" + img.src + "', sizingMethod='scale');\"></span>";
      if (img.useMap) {
        strNewHTML += "<img style=\"position:relative; left:-" + img.width + "px;"
        + "height:" + img.height + "px;width:" + img.width +"\" "
        + "src=\"" + PIXELGIF + "\" usemap=\"" + img.useMap 
        + "\" border=\"" + img.border + "\">";
      }
      img.outerHTML = strNewHTML;
    }
}