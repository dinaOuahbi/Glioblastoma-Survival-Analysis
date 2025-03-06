# **Gliome Survival Analysis - Clinical Data**  

## **Context**  
Glioblastoma (GBM) is the most frequent and most severe primary intraparenchymal brain tumor.  

There exists a hierarchy between various therapeutic options, favoring local treatment over systemic treatment and surgery over stereotactic radiotherapy. Surgery is classified as level 2A evidence, whereas recurrence radiotherapy is level 2B. Therefore, when a patient is considered operable, surgical intervention is systematically proposed as first-line treatment.

In light of this, we aim to compare the impact of surgical intervention and stereotactic radiotherapy on tumor progression survival, overall survival, progression-free survival, and quality of life.

## **Objective**  
- Descriptive analysis and comparison of variables between the two cohorts  
- Survival analysis: Comparison of survival in the two cohorts  
- Selection of prognostic variables in each cohort  

## **Available Data**  
Two different cohorts:  
- **Surgery Cohort**: `TheseAudrey.xlsx`; n = 29  
- **Radiotherapy Cohort**: `TheseAudreyCGFL.xlsx`; n = 22  

## **Methods**  
Each variable is tested univariately in a Cox model. A variable is considered significantly related to survival if its p-value is less than 0.10.  
Significant variables in univariate analysis are integrated into a multivariate Cox model.  
The linear predictor is computed as:  
`model = X1𝛽1 + X2𝛽2 + … + Xn𝛽n`  
Each 'beta' represents the weight of the variable X, i.e., its importance in predicting survival. The product X * β is calculated for all examples (patients), producing a continuous list representing the linear predictor.  
The linear predictor is then dichotomized at the median.

## **Important Concepts**  

### **Survival Curves**  
A survival curve defines two notions:  
- **R(t)**: the risk of death at time t  
- **S(t)**: the probability of being alive at time t  

The Kaplan-Meier (KM) method is used for non-parametric estimation of the survival function S(t). The resulting curve is a step function, where each step represents the occurrence of an event in one or more patients, depending on the magnitude of the step.

### **Interpretation of Hazard Ratio (HR):**  
- **HR > 1**: The risk of the event is proportional to the variable  
- **HR < 1**: The risk of the event is inversely proportional to the variable  
- **HR = 1**: The variable has no effect on the instantaneous risk  
