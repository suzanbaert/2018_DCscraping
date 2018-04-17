var webPage = require('webpage');
var page = webPage.create();
     
var fs = require('fs');
var path = 'phantomJS_htmlpages/free-introduction-to-r.html'
           
page.open('https://www.datacamp.com/courses/free-introduction-to-r', function (status) {
  var content = page.content;
  fs.write(path,content,'w')
  phantom.exit();});
