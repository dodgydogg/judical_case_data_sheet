library(tidyverse)
library(progress)
library(stringr)
library(sjmisc)
library(writexl)
# 此script設計用於地方法院刑事案件的資料清理，且僅限於一個被告、一個罪名的案件
# 地院刑事**DM
# 地院簡易刑事**EM

start.time <- Sys.time()

# initialize variables
txt_file_list <- list.files(pattern = "\\**DM.刑事訴訟.txt$", recursive = TRUE) # list of txt files
temp_list <- list() 
temp_lines <- list() 
temp_case_list <- list() 
paired_df <- data.frame(matrix(ncol = 131, nrow = 0)) 
paired_df[nrow(paired_df) + 1,] <- NA 
pb <- txtProgressBar(min = 0, max = length(txt_file_list), style = 3) 


for (i in 1:length(txt_file_list)) { # go through each .txt file
  temp_lines <- readLines(txt_file_list[i], encoding = "UTF-8") # list of each row in string
  for (j in 1:length(temp_lines)) { # go through each row in string
    if (temp_lines[j] != "#") {
      temp_case_list[length(temp_case_list) + 1] <- str_split(temp_lines[j], pattern = "!", simplify = FALSE)
    }else if (temp_lines[j] == "#") { # if the row is "#", then it is the end of a case
      n_of_defendant <- 0 # initialize the number of defendants and charges in a case
      n_of_charge <- 0 # initialize the number of defendants and charges in a case
      for (vec in temp_case_list){ # calculate the number of defendants and charges in a case
        if (vec[1] == "1") {
          n_of_defendant <- n_of_defendant + 1
        } else if (vec[1] == "1.1") {
          n_of_charge <- n_of_charge + 1
        }
      }
      if (n_of_defendant == 1 & n_of_charge == 1){ 
        for (vec in temp_case_list){ # go through each row in a case
          type_indicator <- vec[1]
          if (type_indicator == "0" & length(vec) == 29) {
            paired_df[nrow(paired_df), 1:29] <- vec
          } else if (type_indicator == "1" & length(vec) == 72) {
            paired_df[nrow(paired_df), 30:101] <- vec
          } else if (type_indicator == "1.1" & length(vec) == 20) {
            paired_df[nrow(paired_df), 102:121] <- vec
          } else if (type_indicator == "1.1.1" & length(vec) == 3) {
            paired_df[nrow(paired_df), 122:124] <- vec
          } else if (type_indicator == "1.1.2" & length(vec) == 3) {
            paired_df[nrow(paired_df), 125:127] <- vec
          } else if (type_indicator == "1.1.3" & length(vec) == 3) {
            paired_df[nrow(paired_df), 128:130] <- vec
          }
        }
        paired_df[nrow(paired_df) + 1,] <- NA
      }
      temp_case_list <- list()
    }
  }
  setTxtProgressBar(pb, i)
}

saveRDS(paired_df, "terminated_case_data.rds")
write_xlsx(paired_df, "terminated_case_data.xlsx")

end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken








