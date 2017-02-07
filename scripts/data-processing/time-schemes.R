# FIXME: 
# 1) Add interval calculations, 
# 2) Add range calculation, 
# 3) Add range construction.


Time <- R6::R6Class("TimeChunk")

Weekday <- R6::R6Class("Weekday",
  inherit = TimeChunk,
  private = list(
    weekday = 'numeric',
    weekday_strings = 'character',
    weekday_abbreviations = 'character',
    weekday_offset = 'numeric',
    forward_offset = function(weekday) {
      o <- ((weekday + offset - 1) %% 7) + 1
      return(o)
    },
    reverse_offset = function(weekday) {
      o <- ((weekday+ (7 - offset) - 1) %% 7) + 1
      return(o)
    }
  ),
  public = list(
    initialize = function(date=NULL, weekday=NULL, offset=0) {
      if (!is.numeric(offset) || length(offset) != 1)
        stop("Offset must be a single integer.")
      private$weekday_strings = c(
        'Sunday', 'Monday', 'Tuesday', 'Wednesday', 
        'Thursday', 'Friday', 'Saturday')
      private$weekday_abbreviations = c(
        'Sun.', 'Mon.', 'Tu.', 'Wed.',
        'Th.', 'Fri.', 'Sat.')
      if (!is.null(date)) {
        private$weekday = wday(date) %>% forward_offset
      } else if (!is.null(weekday) && is.numeric(weekday)) {
        if (any(weekday < 1) | any(weekday > 7))
          stop("Numeric weekday must be on [1,7].")
        else 
          private$weekday = weekday
      } else if (!is.null(weekday) && is.character(weekday)) {
        if (weekday %in% weekday_strings) 
          wh <- sapply(weekday, function(wday) which(weekday_strings == wday))
        else if (weekday %in% weekday_abbreviations)
          wh <- sapply(weekday, function(wday) which(weekday_abbreviations == wday))
        else if (weekday %in% weekday_abbreviations)
          wh <- sapply(weekday, function(wday) {
            which(substr(weekday_strings, 1, nchar(wday)) == wday)
          })
        else 
          stop("Weekday is a character string but fails to match weekday strings available in the class.")
        private$weekday = forward_offset(wh)
      }
    },
    sort = function() {
      private$weekday = sort(private$weekday)
      return()
    },
    label = function(numeric=FALSE, abbreviation=FALSE) {
      if (numeric) {
        o <- private$weekday
      } else {
        if (abbreviation) {
          o <- private$weekday_abbreviations[reverse_offset(private$weekday)]
        } else {
          o <- private$weekday_strings[reverse_offset(private$weekday)]
        }
      }
      return(o)
    },
    numeric = function() {
      return(private$weekday)
    },
    index = function() {
      ord <- order(private$weekday)
      return(ord)
    }
  )
)

Year <- R6::R6Class("Year",
  inherit = TimeChunk,
  private = list(
    year = 'numeric'
  ),
  public = list(
    initialize = function(year) {
      private$year = year
    },
    sort = function() {
      private$year = sort(private$year)
      return()
    },
    label = function() {
      return(as.character(private$year))
    },
    numeric = function() {
      return(private$year)
    },
    index = function() {
      return(order(private$year))
    }
  )
)

YearMonth <- R6::R6Class("YearMonth",
  inherit = TimeChunk,
  private = list(
    year = 'numeric',
    month = 'numeric',
    month_strings = 'character',
    month_abbreviations = 'character'
  ),
  public = list(
    initialize = function(year, month) {
      private$year = year
      private$month = month
      private$month_strings = c(
        'January', 'February', 'March', 
        'April',   'May',      'June',
        'July',    'August',   'Septmber',
        'October', 'November', 'December')
      private$month_abbreviations = c(
        'Jan.', 'Feb.', 'Mar.', 
        'Apr.', 'May',  'Jun.',
        'Jul.', 'Aug.', 'Sept.',
        'Oct.', 'Nov.', 'Dec.')
    },
    sort = function() {
      ord <- order(paste(private$year, private$month))
      private$year = private$year[ord]
      private$month = private$month[ord]
      return()
    },
    label = function(numeric=FALSE, abbreviation=FALSE) {
      if (numeric) {
        m <- private$month
        y <- private$year
        o <- paste0(y, '-', m)
      } else {
        if (abbreviation) {
          m <- private$month_abbreviations[private$month]
          y <- private$year %>% as.character
          o <- paste0(m, ', ', y)
        } else {
          m <- private$month_strings[private$month]
          y <- private$year %>% as.character
          o <- paste0(m, ', ', y)
        }
      }
      return(o)
    },
    numeric = function() {
      return(self$year+self$month/12)
    },
    index = function() {
      ord <- order(paste(private$year, private$month))
      return(ord)
    }
  )
)

YearBiweek <- R6::R6Class("YearBiweek",
  inherit = TimeChunk,
  private = list(
    year = 'numeric',
    biweek = 'numeric'
  ),
  public = list(
    initialize = function(date=NULL, year=year(date), biweek=NULL) {
      if (!is.null(date)) {
        year <- year(date)
        biweek <- date_to_biweek(date)
      } else if (!is.null(year) && !is.null(biweek)) {
        private$year = year
        private$biweek = biweek
      } else {
        stop("Must initialize with either date or year and biweek.")
      }
    },
    sort = function() {
      ord <- order(paste(private$year, private$biweek))
      private$year = private$year[ord]
      private$biweek = private$biweek[ord]
      return()
    },
    label = function(sortable=FALSE) {
      bw <- private$biweek
      y <- private$year
      if (sortable) {
        o <- paste0(y, '-', bw)
      } else {
        o <- paste0(bw, ', ', y)
      }
      return(o)
    },
    numeric = function() {
      return(self$year+self$biweek/26)
    },
    index = function() {
      ord <- order(paste(private$year, private$biweek))
      return(ord)
    }
  )
)

YearWeek <- R6::R6Class("YearWeek",
  inherit = TimeChunk,
  private = list(
    year = 'numeric',
    week = 'numeric'
  ),
  public = list(
    initialize = function(date=NULL, year=year(date), week=week(date)) {
      if (!is.null(date)) {
        year <- year(date)
        week <- week(date)
      } else if (!is.null(year) && !is.null(week)) {
        private$year = year
        private$week = week
      } else {
        stop("Must initialize with either date or year and week.")
      }
    },
    sort = function() {
      ord <- order(paste(private$year, private$week))
      private$year = private$year[ord]
      private$week = private$week[ord]
      return()
    },
    label = function(sortable=FALSE) {
      w <- private$week
      y <- private$year
      if (sortable) {
        o <- paste0(y, '-', w)
      } else {
        o <- paste0(w, ', ', y)
      }
      return(o)
    },
    numeric = function() {
      return(self$year+self$week/53)
    },
    index = function() {
      ord <- order(paste(private$year, private$week))
      return(ord)
    }
  )
)


YearEpiWeek <- R6::R6Class("YearEpiWeek",
  inherit = TimeChunk,
  private = list(
    year = 'numeric',
    epiweek = 'numeric'
  ),
  public = list(
    initialize = function(date=NULL, year=year(date), epiweek=epiweek(date)) {
      if (!is.null(date)) {
        year <- year(date)
        epiweek <- date_to_epiweek(date)
      } else if (!is.null(year) && !is.null(epiweek)) {
        private$year = year
        private$epiweek = epiweek
      } else {
        stop("Must initialize with either date or year and epiweek.")
      }
    },
    sort = function() {
      ord <- order(paste(private$year, private$epiweek))
      private$year = private$year[ord]
      private$epiweek = private$epiweek[ord]
      return()
    },
    label = function(sortable=FALSE) {
      w <- private$epiweek
      y <- private$year
      if (sortable) {
        o <- paste0(y, '-', w)
      } else {
        o <- paste0(w, ', ', y)
      }
      return(o)
    },
    numeric = function() {
      return(self$year+self$epiweek/53)
    },
    index = function() {
      ord <- order(paste(private$year, private$epiweek))
      return(ord)
    }
  )
)



