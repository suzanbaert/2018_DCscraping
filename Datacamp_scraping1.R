library(rvest)
library(xml2)
library(stringr)
library(purrr)

robotstxt::paths_allowed("https://www.datacamp.com/courses/")


#modify scraping scripts
modify_script <- function(phantomjs_link, url, local_html) {
  script <- readLines("_scrape_basescript.js")
  script[5] <- paste0("var path = '", local_html, "'")
  script[7] <- paste0("page.open('", url, "', function (status) {" )
  
  writeLines(script, con = phantomjs_link)  
}


#main_page_links ####

get_mainpages <- function(technology) {
  Sys.sleep(1)
  
  #get the js script
  phantomjs_link <- paste0("phantomJS_scripts/scrape_mainpage_", technology, ".js")
  url <- paste0("https://www.datacamp.com/courses/tech:", technology)
  local_html <- paste0("phantomJS_htmlpages/mainpage_", technology, ".html")
  modify_script(phantomjs_link, url, local_html)
  
  #read course file
  system_call <- paste("E:///phantomjs/bin/phantomjs", phantomjs_link)
  system(system_call)

  data.frame(technology = technology,
             links = XML::getHTMLLinks(local_html),
             stringsAsFactors = FALSE)
}


#get all course links
all_links <- map_df(c("r", "python"), get_mainpages)


all_courses <- all_links[c(59:214, 325:390), ]
all_courses <- all_courses[duplicated(all_courses), ]
all_courses$links <- str_replace(all_courses$links, "/courses/", "")





#### Trying one link ####

course_link <- all_r_links[1]
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

phantom_link <- paste0("phantomJS_htmlpages/", "free-introduction-to-r", ".html")

#scraping links
participants <- read_html(phantom_link) %>% 
  html_node(css = ".header-hero__footer") %>% 
  html_text() %>%
  str_replace_all("\\,", "") %>% 
  str_extract("[0-9]+ Participants") %>% 
  str_extract("[0-9]+")

participants <- read_html(phantom_link) %>% 
  html_node(css = ".header-hero__stat--participants") %>% 
  html_text() %>%
  readr::parse_number()





#### To a function ####


scrape_participants <- function(technology, course) {
  Sys.sleep(1)
  
  #get the js script
  phantomjs_link <- paste0("phantomJS_scripts/scrape_", course, ".js")
  url <- paste0("https://www.datacamp.com/courses/", course)
  local_html <- paste0("phantomJS_htmlpages/", course, ".html")
  modify_script(phantomjs_link, url, local_html)
  
  #read course file
  system_call <- paste("E:///phantomjs/bin/phantomjs", phantomjs_link)
  system(system_call)

  
  #scraping links
  participants <- read_html(local_html) %>% 
    html_node(css = ".header-hero__stat--participants") %>% 
    html_text() %>%
    readr::parse_number()
  
  data.frame(technology = technology,
             course = course,
             date = Sys.Date(),
             participants = participants,
             stringsAsFactors = FALSE)
}


particants <- purrr::map2_df(all_courses$technology, all_courses$links, scrape_participants)
saveRDS(particants, "data/participants180419.RDS")




#resources
"https://www.r-bloggers.com/web-scraping-javascript-rendered-sites/"
"http://blog.brooke.science/posts/scraping-javascript-websites-in-r/"
