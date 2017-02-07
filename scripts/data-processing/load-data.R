
biweekly_province_counts <- function(credentials, delivery, disease) {
  stmt <- paste0("SELECT disease, geocode_province, ",
    "date_sick_year, date_sick_biweek, ",
    "array_avg(array_cat_agg(date_sick_array)) AS mean_date_sick, sum(count) AS count ",
    "FROM province_level_biweekly_case_counts ",
    "WHERE date_delivered <= '", delivery, "' AND disease = '26' ",
    "GROUP BY disease, geocode_province, date_sick_year, date_sick_biweek ")
  conn <- connect(credentials) 
  counts <- dbGetQuery(conn, stmt)
  dbDisconnect(conn)
  province_biweekly_counts <- counts %>% 
    mutate(date_sick = biweek_to_date(date_sick_biweek, date_sick_year)) %>%
    arrange(geocode_province, date_sick)
  return(province_biweekly_counts)
}

biweekly_district_counts <- function(credentials, delivery, disease) {
  stmt <- paste0("SELECT disease, geocode_district, ",
    "date_sick_year, date_sick_biweek, ",
    "array_avg(array_cat_agg(date_sick_array)) AS mean_date_sick, sum(count) AS count ",
    "FROM district_level_biweekly_case_counts ",
    "WHERE date_delivered <= '", delivery, "' AND disease = '26' ",
    "GROUP BY disease, geocode_district, date_sick_year, date_sick_biweek ")
  conn <- connect(credentials) 
  counts <- dbGetQuery(conn, stmt)
  dbDisconnect(conn)
  district_biweekly_counts <- counts %>% 
    mutate(date_sick = biweek_to_date(date_sick_biweek, date_sick_year)) %>%
    arrange(geocode_district, date_sick)
  return(district_biweekly_counts)
}



time_machine_biweekly_province_counts <- function(credentials, deliveries, disease) {
  counts <- list()
  for (i in seq_along(deliveries)) {
    delivery <- deliveries[i]
    counts[[as.character(delivery)]] <- 
      biweekly_province_counts(credentials, delivery, disease) 
  }
  return(counts)
}




