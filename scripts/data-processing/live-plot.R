all_live_province_plots <- function(counts_file, out_file) {
  require(dplyr); require(ggplot2); require(maggritr)
  counts <- readRDS(counts_file) 
  deliveries <- sort(unique(data.table::rbindlist(counts$date_delivered)))
  provinces <- sort(unique(data.table::rbindlist(counts$geocode_province)))
  pdf(file=out_file, width=11.5, height=8, useDingbats=FALSE)
  for ( province in provinces ) { 
    for (i in seq_along(deliveries)) {
      pl <- ggplot(
        data=counts[[i]][counts[[i]][['geocode_province']] == province,] %>% 
          group_by(geocode_province, date_sick_year, date_sick_biweek) %>%
          summarise(count=sum(count, na.rm=TRUE)) %>%
          mutate(date_delivered = factor(deliveries[i])),
        aes(x=date_sick_year + (date_sick_biweek-1)/26, y=count, colour=factor(date_delivered))
      ) + geom_line() + scale_x_continuous(limits=c(2012, 2017.3)) + theme_minimal()
      print(pl);
    }
  }
  dev.off()
  return(out_file)
}
  



