library(plumber)
library(tidymodels)

rf_best_wf <- readRDS("../Saved Objects/rf_best_wf.RDS")
#preds <- rf_best_wf |> predict(diabetes_tbl)
#saveRDS(preds, file = "./Saved Objects/preds.RDS")
preds <- readRDS("../Saved Objects/preds.RDS")
diabetes_tbl <- readRDS("../Saved Objects/diabetes_tbl.RDS")

#* @apiTitle Diabetes Model API
#* @apiDescription This API returns predictions and information about a random forest model used to predict diabetes diagnosis.

#* Learn about the model
#* @get /info
function() {
    print("This model is tuned and supported by Matt Wasyluk at NC State University. It is designed to predict diabetes incidence based on lifestyle factors (as well as BMI, for the sake of having a numeric variable). It uses Alex Teboul's cleaned BRFSS 2015 survey dataset from Kaggle.")
}

#* Return a confusion matrix
#* @serializer print
#* @get /confusion
function() {
  conf_mat(cbind(diabetes_tbl, preds), DiabetesOutcome, .pred_class)
}

#* Return a prediction based on predictor values
#* @get /pred
function(BMI = 28.38, Smoker = "No", PhysActivity = "Yes", Fruits = "Yes", Veggies = "Yes", HvyAlcoholConsump = "No", Education = "College 4 years or more (College graduate)", Income = "$75,000 or more") {
  rf_best_wf |> 
    predict(data.frame(BMI = as.numeric(BMI), Smoker = Smoker, PhysActivity = PhysActivity, Fruits = Fruits, Veggies = Veggies, HvyAlcoholConsump = HvyAlcoholConsump, Education = Education, Income = Income), type = "class")
}

test_pred = function(BMI = 28.38, Smoker = "No", PhysActivity = "Yes", Fruits = "Yes", Veggies = "Yes", HvyAlcoholConsump = "No", Education = "College 4 years or more (College graduate)", Income = "$75,000 or more") {
  rf_best_wf |> 
    predict(data.frame(BMI = BMI, Smoker = Smoker, PhysActivity = PhysActivity, Fruits = Fruits, Veggies = Veggies, HvyAlcoholConsump = HvyAlcoholConsump, Education = Education, Income = Income), type = "class")
}

test_pred()
test_pred(BMI = 14)
test_pred(BMI = 50, Smoker = "Yes", PhysActivity = "No", Fruits = "No", Veggies = "No", HvyAlcoholConsump = "Yes", Education = "Grades 9 through 11 (Some high school)", Income = "$15,000 to less than $20,000")