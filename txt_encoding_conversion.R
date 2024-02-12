library(progress)

txt_file_list <- list.files(pattern = "\\.txt$", recursive = TRUE)
pb <- txtProgressBar(min = 0, max = length(txt_file_list), style = 3)

#encoding conversion
for (i in 1:length(txt_file_list)) {
  temp_convert  <- readLines(txt_file_list[i], encoding = "big-5")
  temp_converted <- iconv(temp_convert, from = "big-5", to = "UTF-8")
  writeLines(temp_converted, txt_file_list[i], useBytes = TRUE)
  setTxtProgressBar(pb, i)
}


