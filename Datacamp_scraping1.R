library(rvest)

robotstxt::paths_allowed("https://www.datacamp.com/courses/tech:r")




url <- "https://www.datacamp.com/courses/tech:r"




# write the javascript code to a new scrape.js file
writeLines("var webPage = require('webpage');
           var page = webPage.create();
           
           var fs = require('fs');
           var path = 'phantomJS_pages/mainpage.html'
           
           page.open('https://www.datacamp.com/courses/tech:r', function (status) {
           var content = page.content;
           fs.write(path,content,'w')
           phantom.exit();});",
           
           con = "phantomJS_calls/scrape_mainpage2.js")





# Download website via system call
# first argument location of phantomjs, then location of scraping script
system("E:///phantomjs/bin/phantomjs phantomJS_calls/scrape_mainpage2.js")











#resources
"https://www.r-bloggers.com/web-scraping-javascript-rendered-sites/"
"http://blog.brooke.science/posts/scraping-javascript-websites-in-r/"
