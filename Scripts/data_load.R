# This file merely repeats table processing from intro_data.qmd for use in other files.

library(readr)
library(dplyr)
library(purrr)
library(ggplot2)

diabetes_raw <- read_csv("./data/diabetes_binary_health_indicators_BRFSS2015.csv")

predictors <- c("BMI", "Smoker", "PhysActivity", "Fruits", "Veggies", "HvyAlcoholConsump", "Education", "Income")

diabetes_raw <- diabetes_raw |> 
  select(all_of(c("Diabetes_binary", predictors)))

# no missing values, so we'll continue
diabetes_raw |>
  is.na() |>
  colSums()

diabetes_tbl <- diabetes_raw |> 
  mutate(BMI = as.numeric(BMI)) |> 
  mutate(across(all_of(c("Diabetes_binary", "Smoker", "PhysActivity", "Fruits", "Veggies", "HvyAlcoholConsump")), ~factor(.x, levels = c(0, 1), labels = c("No", "Yes")))) |> 
  mutate(Education = factor(Education, 
                            levels = c(seq(1:6)), 
                            labels = c(
                              "Never attended school or only kindergarten", 
                              "Grades 1 through 8 (Elementary)",
                              "Grades 9 through 11 (Some high school)",
                              "Grade 12 or GED (High school graduate)",
                              "College 1 year to 3 years (Some college or technical school)",
                              "College 4 years or more (College graduate)"))) |> 
  mutate(Income = factor(Income,
                         levels = c(1:8),
                         labels = c(
                           "Less than $10,000",
                           "$10,000 to less than $15,000",
                           "$15,000 to less than $20,000",
                           "$20,000 to less than $25,000",
                           "$25,000 to less than $35,000",
                           "$35,000 to less than $50,000",
                           "$50,000 to less than $75,000",
                           "$75,000 or more"
                         ))) |> 
  rename("DiabetesOutcome" = "Diabetes_binary")

#saveRDS(diabetes_tbl, file = "./Saved Objects/diabetes_tbl.RDS")
