library(keras)
library(magrittr)
library(tfdatasets)
library(tensorflow)

TRAIN_DATA_URL <- "https://storage.googleapis.com/tf-datasets/titanic/train.csv"
TEST_DATA_URL <- "https://storage.googleapis.com/tf-datasets/titanic/eval.csv"

train_file_path <- get_file("train_csv", TRAIN_DATA_URL)
test_file_path <- get_file("eval.csv", TEST_DATA_URL)

train_dataset <- make_csv_dataset(
  train_file_path, 
  field_delim = ",",
  batch_size = 5, 
  num_epochs = 1
)

bar <- function(aff) {
  return(aff)
}

foo <- function(x) {
  debug_x <<- x
  # y = x
  # y = tf$py_function(bar, list(x$survived, x$sex, x$age, x$n_siblings_spouses, x$parch, x$fare, x$class, x$deck, x$embark_town, x$alone), list(tf$int32, tf$string, tf$float32, tf$int32, tf$int32,  tf$float32, tf$string, tf$string, tf$string, tf$string))
  # names(y) <- c("survived", "sex", "age", "n_siblings_spouses", "parch", "fare", "class", "deck", "embark_town", "alone")
  # purrr::imap(debug_y, ~ tuple(.y, .x))
  # debug_y <<- y
  return(x)
}

train_dataset2 <- train_dataset %>% dataset_map(foo)
debug_x
debug_y
assertthat::are_equal(debug_x, debug_y %as% OrderedDict)

train_dataset2 %>% 
  reticulate::as_iterator() %>% 
  reticulate::iter_next() %>% 
  reticulate::py_to_r()
