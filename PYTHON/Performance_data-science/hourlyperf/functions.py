import numpy as np 
import pandas as pd 
import statsmodels.stats.api as sms
import seaborn as sns




def outlier_processing(x):
    Q1 = x.quantile(0.25)
    Q3 = x.quantile(0.75)
    IQR = Q3-Q1
    lower_border = Q1- 1.5*IQR
    higher_border = Q3 + 1.5*IQR
    x = pd.DataFrame(x)
    clean_data = x[~((x < (lower_border)) | (x > (higher_border))).any(axis = 1)]
    return clean_data

def confidence_interval(x):

    print(sms.DescrStatsW(x).tconfint_mean())


def visualization(BEFORE_RELEASE,AFTER_RELEASE):
    #FIRST DATA SET
    PERFORMANCE = pd.concat([BEFORE_RELEASE, AFTER_RELEASE], axis = 1)
    PERFORMANCE.columns = ["BEFORE","AFTER"]
    print("'PERFORMANCE' Veri Seti: \n\n ", PERFORMANCE.head(), "\n\n")


    #SECOND DATA SET
    #CREATE TAG FOR BEFORE
    BEFORE = np.arange(len(BEFORE_RELEASE))
    BEFORE = pd.DataFrame(BEFORE)
    BEFORE[:] = "BEFORE"
    #CONCAT VALUES
    A = pd.concat([BEFORE_RELEASE, BEFORE], axis = 1)
    #CREATE TAG FOR 'AFTER'
    AFTER = np.arange(len(AFTER_RELEASE))
    AFTER = pd.DataFrame(AFTER)
    AFTER[:] = "AFTER"

    #CONCAT VALUES
    B = pd.concat([AFTER_RELEASE, AFTER], axis = 1)

    #MERGE ALL DATA
    TOGETHER = pd.concat([A,B])
    TOGETHER

    #NAMING
    TOGETHER.columns = ["PERFORMANCE","BEFORE AFTER"]

    #VISUALIZING
    return TOGETHER

def outlier_control(x,column):
    Q1 = x.quantile(0.25)
    Q3 = x.quantile(0.75)
    IQR = Q3-Q1
    lower_border = Q1- 1.5*IQR
    higher_border = Q3 + 1.5*IQR
    x = pd.DataFrame(x)
    clean_data = x[x[column] >= higher_border[column]]
    return clean_data


    