var webPage = require('webpage');
var page = webPage.create();
     
var fs = require('fs');
var path = 'phantomJS_htmlpages/mainpage2.html'
           
page.open('https://www.datacamp.com/courses/tech:r', function (status) {
  var content = page.content;
  fs.write(path,content,'w')
  phantom.exit();});
