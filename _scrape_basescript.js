var webPage = require('webpage');
var page = webPage.create();
     
var fs = require('fs');
var path = 'yourlocalfile.html'
           
page.open('https://url', function (status) {
  var content = page.content;
  fs.write(path,content,'w')
  phantom.exit();});
