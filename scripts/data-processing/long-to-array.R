
grouped_df_to_matrix <- function(data=NULL, 
  group_prefix='geocode',
  group=c('province', 'district', 'subdistrict', 'village'), 
  time_prefix='date_sick',
  time=c('year', 'month', 'biweek', 'week'),
  variable='count'
) {
  groups <- paste(group_prefix, group, sep='_') %>% `[`(., . %in% colnames(data))
  group_keys <- data[,groups,drop=FALSE] %>% as.list %>% do.call(what=paste, args=.)
  unique_group_keys <- unique(group_keys)
  n_groups <- length(unique_group_keys)

  times <- paste(time_prefix, time, sep='_') %>% `[`(., . %in% colnames(data))
  time_keys <- data[,times,drop=FALSE] %>% as.list %>% do.call(what=paste, args=.)
  unique_time_keys <- unique(time_keys)
  n_times <- length(unique_time_keys)
 
  data <- data[,c(groups, times, variable)]
  var <- data[[variable]]
  o <- matrix(data=NA, nrow=n_groups, ncol=n_times)
  for ( i in 1:n_groups ) {
    group_key <- unique_group_keys[i]
    for ( j in 1:n_times ) {
      time_key <- unique_time_keys[j]
      row_idx <- which(group_keys == group_key & time_keys == time_key)
      if (length(row_idx) == 0) {
        o[i,j] <- 0
      } else {
        if (length(row_idx) == 1) {
          o[i,j] <- var[row_idx]
        } else {
          cat("i: ", i, ", j: ", j, ", values: ", var[row_idx], "\n")
          cat("group_key: ", group_key, ", time_key: ", time_key, ", values: ", var[row_idx], "\n")
          stop("Multiple values per group are unnacceptable.")
        }
      }
    }
  }
  ## Also return row metadata 
  ## Also return column metadata
  return(o)
}





