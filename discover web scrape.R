library(RSelenium)

rD <- rsDriver(
  browser = "chrome",
  chromever = "latest",
  port = 4445L,
  verbose = FALSE
)

remDr <- rD$client

# Replace with actual PSU Discover URL for your campus region
discover_url <- "https://discover.psu.edu"  

remDr$navigate(discover_url)

# Pause to allow JS load
Sys.sleep(5)

# If PSU requires login:
username <- "kbg5618@psu.edu"
password <- "#Foofiiscute200580089009"

# Example selectors — you’ll need to inspect them
remDr$findElement(using = "css selector", "#inputEmail")$sendKeysToElement(list(username))
remDr$findElement(using = "css selector", "#inputPassword")$sendKeysToElement(list(password, key = "enter"))
Sys.sleep(5) # wait for login

# Navigate to organizations list
org_list <- remDr$findElement(using = "css selector", ".org-listing-class") # replace with real class
org_links <- org_list$getElementAttribute("href")

club_data <- tibble(Name = character(), MeetingTime = character(), URL = character())

for (link in org_links) {
  remDr$navigate(link[[1]])
  Sys.sleep(3) # wait for JS content
  
  page <- remDr$getPageSource()[[1]] %>% read_html()
  
  name <- page %>% html_element(".org-header-class") %>% html_text2()
  meeting <- page %>% html_element(".meeting-info-class") %>% html_text2()
  
  club_data <- club_data %>% add_row(
    Name = name,
    MeetingTime = meeting,
    URL = link[[1]]
  )
}

