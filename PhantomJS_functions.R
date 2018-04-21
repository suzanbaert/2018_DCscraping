#this on will just write the script
write_phantomJS_script <- function(phantomJS_script_link, url, local_html) {
  
  script <- c("var webPage = require('webpage');",
              "var page = webPage.create();",
              "",
              "var fs = require('fs');",
              "var path = 'yourlocalfile.html'",
              "",
              "page.open('https://url', function (status) {",
              " var content = page.content;",
              " fs.write(path,content,'w')",
              " phantom.exit();});")
  
  script[5] <- paste0("var path = '", local_html, "'")
  script[7] <- paste0("page.open('", url, "', function (status) {" )
  
  writeLines(script, con = phantomjs_script)  
}




#execute phantomJS and write a local html
execute_phantomJS <- function(phantomJS_link = ".phantomjs/bin/phantomjs", phantomJS_script_link) {
  system_call <- paste(phantomJS_link, phantomjs_link)
  system(system_call)
  }



#combination - write script and execute
get_local_html <- function(phantomJS_link, url, local_html_location = "local_html_files") {
  
  #pasting the links
  dir.create(local_html_location, showWarnings = FALSE)
  phantomJS_script_link <- paste0(local_html_location, "/phantomJS.js")
  local_html <- paste0(local_html_location, "/local_html.html")
  
  #modifying the script
  script <- c("var webPage = require('webpage');",
              "var page = webPage.create();",
              "",
              "var fs = require('fs');",
              "var path = 'yourlocalfile.html'",
              "",
              "page.open('https://url', function (status) {",
              " var content = page.content;",
              " fs.write(path,content,'w')",
              " phantom.exit();});")
  
  script[5] <- paste0("var path = '", local_html, "'")
  script[7] <- paste0("page.open('", url, "', function (status) {" )
  
  writeLines(script, con = phantomJS_script_link)  
  
  #execute script
  system_call <- paste(phantomJS_link, phantomJS_script_link)
  system(system_call)
  
  file.remove(phantomJS_script_link)
}
  
  
  

write_phantomJS_script(phantomjs_link, url, local_html)
execute_phantomJS(phantomJS_link = "E:///phantomjs/bin/phantomjs", phantomjs_link)

get_local_html(phantomJS_link, url)


phantomJS_link <- "E:///phantomjs/bin/phantomjs"
url <- "http://www.standaard.be"
