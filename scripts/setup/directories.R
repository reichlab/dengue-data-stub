
build_tree <- function() {
  directories <- c('data','simulation')
  for (d in directories) {
    path <- file.path('build',d)
    if (!dir.exists(path))
      dir.create(path=file.path('build',d))
  }
}




