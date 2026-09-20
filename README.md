# Predictive Failure Detection in Industrial Robots Using Machine Learning in R

## 📌 Project Overview

This project develops a machine learning-based predictive maintenance system using **R** to identify potential machine failures before they occur.

The project uses the **AI4I 2020 Predictive Maintenance Dataset**, a synthetic industrial predictive-maintenance dataset containing machine operating conditions and failure information.

The system compares multiple machine learning algorithms and develops a Random Forest model for failure prediction.

> **Note:** The dataset is synthetic predictive-maintenance data. It is used as a proxy for industrial machine/robot failure prediction and does not represent real sensor data from a specific industrial robot.

---

## 🎯 Objectives

* Predict whether a machine is likely to experience failure.
* Perform data preprocessing and exploratory data analysis.
* Engineer useful predictive features.
* Compare multiple machine learning algorithms.
* Evaluate models using classification metrics and ROC-AUC.
* Identify important features contributing to predictions.
* Perform Random Forest hyperparameter tuning.
* Build a Shiny web application for interactive failure prediction.

---

## 🗂️ Project Structure

```text
Predictive_Robot_Failure/
│
├── data/
│   ├── raw/
│   │   └── ai4i2020.csv
│   └── processed/
│       ├── ai4i2020_clean.csv
│       └── ai4i2020_feature_engineered.csv
│
├── R/
│   ├── 01_load_dataset.R
│   ├── 02_preprocessing.R
│   ├── 03_eda.R
│   ├── 04_feature_engineering.R
│   ├── 05_logistic_regression.R
│   ├── 05_ml_preparation.R
│   ├── 06_decision_tree.R
│   ├── 07_random_forest.R
│   ├── 08_svm.R
│   ├── 09_model_comparison.R
│   ├── 10_roc_auc.R
│   ├── 11_feature_importance.R
│   ├── 12_hyperparameter_tuning.R
│   ├── 13_model_evaluation.R
│   ├── 14_failure_prediction.R
│   ├── 15_visualization.R
│   ├── 16_save_final_model.R
│   ├── 17_prediction_demo.R
│   └── 18_project_check.R
│
├── models/
│   ├── logistic_model.rds
│   ├── decision_tree_model.rds
│   ├── random_forest_model.rds
│   ├── svm_model.rds
│   └── final_random_forest_model.rds
│
├── plots/
│   ├── feature_importance.png
│   ├── final_failure_distribution.png
│   ├── final_speed_torque.png
│   ├── roc_curve_comparison.png
│   └── tool_wear_vs_torque.png
│
├── results/
│   ├── auc_results.csv
│   ├── feature_importance.csv
│   ├── final_feature_importance.csv
│   ├── final_model_evaluation.csv
│   ├── hyperparameter_tuning.csv
│   └── model_comparison.csv
│
├── app/
│   └── app.R
│
└── .gitignore
```

---

## 📊 Dataset

The project uses the **AI4I 2020 Predictive Maintenance Dataset**.

### Dataset characteristics

* 10,000 machine records
* 14 original attributes
* Machine operating conditions
* Machine failure indicator
* Multiple failure-mode indicators

The target variable is:

```text
Machine failure
```

The dataset contains a highly imbalanced target:

* No failure: 9,661 records
* Failure: 339 records

---

## ⚙️ Feature Engineering

Two additional features were created:

### Temperature Difference

```text
Temperature_Difference =
Process Temperature - Air Temperature
```

### Power

```text
Power =
Rotational Speed × Torque
```

For the final machine-learning models, `Temperature_Difference` was excluded because it is mathematically dependent on the two temperature variables.

Failure-mode indicators (`TWF`, `HDF`, `PWF`, `OSF`, `RNF`) were also excluded from the final predictors to reduce target leakage.

---

## 🤖 Machine Learning Models

The following algorithms were implemented:

1. Logistic Regression
2. Decision Tree
3. Random Forest
4. Support Vector Machine (SVM)

The data was divided into:

```text
Training set: 80%
Testing set: 20%
```

A fixed random seed was used for reproducibility.

---

## 📈 Model Results

| Model               | Accuracy | Precision | Recall | F1 Score | ROC-AUC |
| ------------------- | -------: | --------: | -----: | -------: | ------: |
| Logistic Regression |   97.00% |    72.73% | 32.00% |   44.44% |   0.948 |
| Decision Tree       |   98.45% |    90.74% | 65.33% |   75.97% |   0.897 |
| Random Forest       |   98.65% |    96.15% | 66.67% |   78.74% |   0.975 |
| SVM                 |   97.05% |    94.44% | 22.67% |   36.56% |   0.950 |

These results are based on the project's held-out test split.

---

## 🌲 Final Random Forest Model

The Random Forest model was further evaluated with different numbers of trees:

```text
100 trees → Accuracy: 98.65%
200 trees → Accuracy: 98.60%
300 trees → Accuracy: 98.60%
500 trees → Accuracy: 98.75%
```

The final model uses:

```text
Number of trees = 500
```

### Final evaluation

```text
Accuracy           = 98.65%
Precision          = 96.15%
Recall             = 66.67%
Specificity        = 99.90%
F1 Score           = 78.74%
Balanced Accuracy  = 83.28%
ROC-AUC            = 0.975
```

---

## 🔍 Feature Importance

The Random Forest model was used to analyze feature importance.

The analysis includes features such as:

* Tool Wear
* Air Temperature
* Rotational Speed
* Power
* Torque
* Process Temperature
* Machine Type

The generated visualization is available at:

```text
plots/feature_importance.png
```

---

## 📊 Visualizations

The project generates several visualizations:

### Feature Importance

![Feature Importance](plots/feature_importance.png)

### Failure Distribution

![Failure Distribution](plots/final_failure_distribution.png)

### Speed vs Torque

![Speed vs Torque](plots/final_speed_torque.png)

### ROC Curve

![ROC Curve](plots/roc_curve_comparison.png)

### Tool Wear vs Torque

![Tool Wear vs Torque](plots/tool_wear_vs_torque.png)

---

## 🖥️ Shiny Application

The project includes an interactive **Shiny** application.

The application allows the user to enter:

* Machine Type
* Air Temperature
* Process Temperature
* Rotational Speed
* Torque
* Tool Wear

The application then provides:

* Predicted machine failure status
* Failure probability
* No-failure probability
* Supporting visualizations

---

## ▶️ How to Run the Project

### 1. Clone the repository

```bash
git clone https://github.com/sriyathid-commits/predictive-robot-failure-detection-r.git
```

### 2. Open the project in RStudio

Open the project folder:

```text
Predictive_Robot_Failure
```

### 3. Install required packages

Run:

```r
install.packages(c(
  "dplyr",
  "readr",
  "ggplot2",
  "caret",
  "randomForest",
  "e1071",
  "pROC",
  "shiny"
))
```

### 4. Run the complete pipeline

Run the R scripts in the following order:

```text
01_load_dataset.R
02_preprocessing.R
03_eda.R
04_feature_engineering.R
05_ml_preparation.R
05_logistic_regression.R
06_decision_tree.R
07_random_forest.R
08_svm.R
09_model_comparison.R
10_roc_auc.R
11_feature_importance.R
12_hyperparameter_tuning.R
13_model_evaluation.R
14_failure_prediction.R
15_visualization.R
16_save_final_model.R
17_prediction_demo.R
18_project_check.R
```

### 5. Run the Shiny application

From the project root in RStudio:

```r
shiny::runApp("app")
```

---

## 🛠️ Technologies Used

* R
* RStudio
* Machine Learning
* Random Forest
* Decision Tree
* Logistic Regression
* Support Vector Machine
* ggplot2
* dplyr
* caret
* randomForest
* e1071
* pROC
* Shiny

---

## 💡 Applications

This project demonstrates how machine learning can be used for:

* Predictive maintenance
* Industrial failure detection
* Equipment monitoring
* Preventive maintenance planning
* Machine-condition analysis
* Data-driven industrial decision support

---

## ⚠️ Limitations

* The AI4I 2020 dataset is synthetic.
* The dataset does not represent measurements from a specific physical robot.
* The failure classes are highly imbalanced.
* Model performance on this dataset may not represent performance on real industrial equipment.
* Real deployment would require validated sensor data and domain-specific testing.

---

## 👩‍💻 Author

**Sriyathi Dharavath**

B.E. Artificial Intelligence & Data Science
Chaitanya Bharathi Institute of Technology, Hyderabad

GitHub: https://github.com/sriyathid-commits
