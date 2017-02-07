
latest_delivery <- function(credentials) {
  delivery <- all_deliveries(credentials) %>% tail(n=1)
  return(delivery)
}

all_deliveries <- function(credentials) {
  conn <- connect(credentials)
  sql <- paste("SELECT distinct(date_delivered) FROM",
               "province_level_monthly_case_counts;")
  delivery <- dbGetQuery(conn,sql) %>% 
    `[[`('date_delivered') %>% sort
  dbDisconnect(conn)
  return(delivery)
}


