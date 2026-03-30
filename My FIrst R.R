# This is my first R script!

# Ctrl + Enter is a quick way to run your code!
# Basic operations are permitted (similar to python), as well as comments!

x <- 2 # Defining a variable!

# You can find the global scope of variables in the right hand side "Enviorment".
# The history tab shows previous commands, and you can directly insert a selection into the console or script.
# There is a file explorer, package manager, and documentation in the bottom right.
# If you need help with a function, type "?", or help() in front of it. Immediately finds it in the doc.

?print
help("geom_point")
??geom_point

# The package isn't installed, so it returns NULL.
# 
# Addition
# 
# Subtraction
# 
# Multiplication
# 
# Division
# 
# Power
# 
# Modulo  %%
# 
# # # Math Functions
    # abs(-1)
    # sqrt(1)
    # ceiling()
    # floor()
    # trig: (x is in radians)
    # cos(), sin(), tan()
    # inverse trig:
    # acos(), asin(), atan()
    # log(), log10(), log(x, base = b)
    # exp(x) = e^x
    # d[dist] = density distribution
    # p[dist] = probability distribution
    # q[dist] = quantile
    # r[dist] = randomly gen
# 
# Data Types
#   numeric types: integer, double (num)
#   complex (cplx)
#   character/string (chr)
#   
list1 <- list(c(1,3,5), c("a", "b", "c"), "d", 1.1)
list2 <- list(list1, "second_element")
# Length
length(list2)
# You can quickly type the "assignment" operator (<-) with Alt+"-".
# If you want to make an object a constant, we can type the object in UPPERCASE.
# If you want the object to change sometimes, aka making it a parameter, you can type the object in camelCase. # nolint
# 
# Object Rules:
    # Objects can NOT start with a digit.
    # The only punctuation marks that can be used are "." and "_".
    # Objects that start with a "." are hidden.
    # Objects are case sensitive.
    # 

# Vectors
# A vector is a sequence of data elements of the same basic type.
# You can create a vector with the c() function (combine).

vec1 <- c(1,2,3,4,5)
vec2 <- c("a", "b", "c", "d")
first_134 <- 1:134  # creates a vector from 1 to 134
seq1 <- seq(1, 10, by=2)  # creates a sequence from 1 to 10 with step size of 2
# We can use -char to ignore the element in a vector.
rep1 <- rep("Rocks", times=3)  # repeats "Rocks"
# To pick elements of a vector, use square brackets [] after the vector's name.
vec1[2]    # second element
vec2[4:5]  # fourth and fifth elements

vec1_und3 <- vec1[vec1 < 3]  # elements of vec1 less than 20

# 'C' func updates the value of a vector.
# 
# Functions
# 
# All functions consist of the same components: 
# Name, Input, Args, Output, and Rule : definition of a function
# Name: how we invoke it
# Input: symbol that refers to the independent quantities that form the relationship (vars, parameters)
# Arg: an expression that represents the 
# 
getMdistance <- function(p,q){
  dist <- sum(abs(p-q))
  return(dist)
}

getMDistance(c(1,2), c(2,4))

# Built-in Functions
# 
# R has many built in functions such as...
# function
# return
# typeof
# view
# str
# c
# seq
# list
# matrix
# data.frame
# array
# plot
# 
# Logic Functions:
# 
# Logical functions are a bit different, they return logical values (TRUE, FALSE)
# Comparisons:
#   A == C: same val
#   A != C do NOT have same val
#   A > C
#   A < C
#   A >=
#   A <= C
#   is.* functions also return logical values
#   
#   We can use comparison functions inside if statements, but conditions must evaluate to logical values.
#   
if (condition1) {
  action(s) to take when condition1 is TRUE
} else if (condition 2) {
  other action(s) to take when condition2 is TRUE
} else {
  action(s) to take when no other condition is TRUE
}

# if CANNOT work with vectors, we have to use ifelse.

# if-else
getAbs <- function(x){
  if (x>= 0){
    return (x)
  }
  else{
    return (-x)
  }
}
x <- {-2 -1 0 1 2}
ifelse(x>=0, x, -x) # 2, 1, 0, 1, 2

# We can use logic functions to...
# 
# 
# Plan for Simulating a Coin
#   Goal: Create an R func that will allow a user to simulate flipping a coin
#   Needs: Probability, Result, Function's name, subraction, sample, assignment op, function and return commands
#   Steps:
#     1. Create our plan
#     2. Create a blank R script
#     3. Copy the contents of the Function_TransitionDoc.R to our blank script
#     4. Fill in the template according to our plan.
#     5. Define our function.
#       i. assign the result of the function commapnd to our function's name with our input.
#       ii. Calculate the probability of getting a tail.
#       
# Vectorization:
#   A function is vectorized if we can apply the function to all of the elements of a vector without
#   needing to program a loop or write individual commands for each element. Most built-in functions
#   are vectorized. If your function is purely mathematical, it should be mostly vectorized.

x <- c("1981-05-31", "2020-02-22")

for (i in seq_along(x)) {
  
}

# Piping
# CTRL + SHIFT + M -> |> 
# This is the piping operator, allows passing of the output of a function to the input of another.
# Think of it like a factory conveyor belt!
# (supported since stock R since 4.1.0)
# 
# The magrittr pipe is still used in tidyverse packages, being written as %>%.
# %<>%: Assignment pipe (updates the variable in place).
# %T>%: Tee pipe (allows side effects like plotting without breaking the chain).
# %$%: Exposition pipe (exposes column names from data frames).
# 
# Native Pipe Placeholder (_): Introduced in R 4.2.0, the _ placeholder allows you to specify where 
# the left-hand side (LHS) value should be inserted in a function call on the right-hand side (RHS) of the native pipe (|>).  
# It must be used in a named argument and can only appear once in the RHS expression.  
# For example: 
mtcars |> lm(mpg ~ disp, data = _)
lm(mpg ~ disp, data = mtcars).

some_dataframe |> _[, 1:5]
  some_function(arg2 = _, arg1 = 5)