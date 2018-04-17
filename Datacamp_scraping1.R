library(rvest)
library(xml2)
library(stringr)

robotstxt::paths_allowed("https://www.datacamp.com/courses/tech:r")




url <- "https://www.datacamp.com/courses/tech:r"


#main_page_links ####

# write the javascript code to a new scrape.js file
writeLines(
"var webPage = require('webpage');
var page = webPage.create();
     
var fs = require('fs');
var path = 'phantomJS_htmlpages/mainpage2.html'
           
page.open('https://www.datacamp.com/courses/tech:r', function (status) {
  var content = page.content;
  fs.write(path,content,'w')
  phantom.exit();});",
           
con = "phantomJS_scripts/scrape_mainpage.js")


# Download website via system call
# first argument location of phantomjs, then location of scraping script
system("E:///phantomjs/bin/phantomjs phantomJS_scripts/scrape_mainpage2.js")


#scraping links
read_html("phantomJS_htmlpages/mainpage.html")

all_r_links <- XML::getHTMLLinks("phantomJS_htmlpages/mainpage.html")
all_r_links <- all_r_links[59:214]
all_r_links <- all_r_links[duplicated(all_r_links)]





#### Trying one link ####

course_link <- all_r_links[1]
course_link <- str_replace(course_link, "/courses/", "")
phantom_link <- paste0("phantomJS_htmlpages/", course_link, ".html")
url_link <- paste0("https://www.datacamp.com/courses/", course_link)

script <- readLines("phantomJS_scripts/scrape_mainpage2.js")

#change line 5 with phantomjs link
script[5] <- paste0("var path = '", phantom_link, "'")

#change line 7 for website link
script[7] <- paste0("page.open('", url_link, "', function (status) {" )

writeLines(script, con = "phantomJS_scripts/scrape_course1.js" )  


#read course file
# Download website via system call
# first argument location of phantomjs, then location of scraping script
system("E:///phantomjs/bin/phantomjs phantomJS_scripts/scrape_course1.js")

#scraping links
participants <- read_html(phantom_link) %>% 
  html_node(css = ".header-hero__footer") %>% 
  html_text() %>%
  str_replace_all("\\,", "") %>% 
  str_extract("[0-9]+ Participants") %>% 
  str_extract("[0-9]+")






#resources
"https://www.r-bloggers.com/web-scraping-javascript-rendered-sites/"
"http://blog.brooke.science/posts/scraping-javascript-websites-in-r/"
