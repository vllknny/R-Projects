# bind_rows
exam_day1 <- data.frame(
  id = c(1, 2),
  score = c(80, 90)
)
exam_day1

exam_day2 <- data.frame(
  id = c(3, 4),
  score = c(85, 88)
)
exam_day2

bind_rows(exam_day1, exam_day2)


# bind_row with different column names
exam_day3 <- data.frame(
  id = c(5),
  score = 92,
  extra_credit = 5
)

bind_rows(exam_day1, exam_day3)


# bind_col: matches rows by position, not by ID
scores <- data.frame(
  id = c(1, 2, 3),
  score = c(80, 90, 85)
)

gender <- data.frame(
  gender = c("F", "M", "F")
)

bind_cols(scores, gender)

# with a wrong order

gender_wrong <- data.frame(
  gender = c("M", "F", "F")
)

bind_cols(scores, gender_wrong)

# Use join
gender_by_id <- data.frame(
  id = c(3, 1, 2),
  gender = c("F", "F", "M")
)

left_join(scores, gender_by_id, by = "id")




# Join Data Frames
students <- data.frame(
  id = c(1, 2, 3, 4),
  name = c("Alice", "Bob", "Cathy", "David")
)
students

scores <- data.frame(
  id = c(2, 3, 5),
  score = c(90, 85, 88)
)
scores

left_join(students, scores, by = "id")
right_join(students, scores, by = "id")
inner_join(students, scores, by = "id")
full_join(students, scores, by = "id")


# join_by()
## Equality joins match IDs.
students <- data.frame(
  id = c(1, 2, 3),
  name = c("Alice", "Bob", "Cathy")
)

scores <- data.frame(
  student_id = c(2, 3),
  score = c(90, 85)
)

left_join(students, scores, join_by(id == student_id))



## Inequality joins match ranges.
scores <- data.frame(
  student = c("A", "B", "C"),
  score = c(72, 88, 95)
)

grade_cutoffs <- data.frame(
  grade = c("C", "B", "A"),
  min_score = c(70, 80, 90)
)

left_join(
  scores,
  grade_cutoffs,
  join_by(score >= min_score)
)

## Rolling joins match the closest value.
### For each event, find the most recent measurement 
### whose time is less than or equal to the event time.
events <- data.frame(
  time = c(3, 8, 15),
  event = c("E1", "E2", "E3")
)
measurements <- data.frame(
  time = c(1, 5, 10, 20),
  value = c(100, 110, 120, 130)
)

left_join(
  events,
  measurements,
  join_by(closest(time <= time))
)


# Practice
## A workflow might look like
library(tidyverse)
library(dcData)
data("OrdwayBirds")
data("OrdwaySpeciesNames")

## Data wrangling / Join the data frames.
