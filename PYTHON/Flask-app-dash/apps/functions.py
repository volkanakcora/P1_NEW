import numpy as np 
import pandas as pd 



def data_processing(data):
    data["Custom field (Story Points)"] = data["Custom field (Story Points)"].fillna(0)
    data['Custom field (Story Points)'] = np.where(data['Custom field (Story Points)'].between(0.0,1.0), 1, data['Custom field (Story Points)'])
    data["Resolved"] = pd.to_datetime(data["Resolved"])
    data["Resolved"] = data["Resolved"].apply(lambda x: x.year)
    df =  pd.DataFrame(data[["Custom field (Story Points)","Resolved","Project name"]])
    df_new = pd.DataFrame(df.groupby("Resolved").sum()["Custom field (Story Points)"])
    df_new = df_new.reset_index()
    return df_new




def total_calculation(data, ame):
    data["Resolved"] = pd.to_datetime(data["Resolved"])
    data["Resolved"] = data["Resolved"].apply(lambda x: x.year)
    data["Custom field (Story Points)"] = data["Custom field (Story Points)"].fillna(0)
    data['Custom field (Story Points)'] = np.where(data['Custom field (Story Points)'].between(0.0,1.0), 1, data['Custom field (Story Points)'])
    data['Issue'] = np.where(data['Comment.22'],ame, data['Comment.22'])
    maintenance_final =  pd.DataFrame(data[["Custom field (Story Points)","Resolved","Issue"]])
    return maintenance_final



def percentage_calculation(data):
    year = data[(data["Resolved"] == 2019)]
    dev = data[(data["Resolved"] == 2020)]
    man = data[(data["Resolved"] == 2021)]
    dev['percent'] = (dev['Custom field (Story Points)'] / dev['Custom field (Story Points)'].sum()) * 100
    man['percent'] = (man['Custom field (Story Points)'] / man['Custom field (Story Points)'].sum()) * 100
    year['percent'] = (year['Custom field (Story Points)'] / year['Custom field (Story Points)'].sum()) * 100
    last_vers_dude = dev.append(man)
    last_vers_dude = last_vers_dude.append(year)
    last_vers_dude["percent"] = last_vers_dude["percent"].round(2)
    last_vers_dude = last_vers_dude.sort_values("Resolved")
    return last_vers_dude



def line_processing(data,ame):
    data["Custom field (Story Points)"] = data["Custom field (Story Points)"].fillna(0)
    data['Custom field (Story Points)'] = np.where(data['Custom field (Story Points)'].between(0.0,1.0), 1, data['Custom field (Story Points)'])
    data["Resolved"] = pd.to_datetime(data["Resolved"])
    data["Year"] = data["Resolved"].apply(lambda x: x.year)
    data["Month"] = data["Resolved"].apply(lambda x: x.month)
    data["Resolved"] = data["Resolved"].apply(lambda x: x.date())
    data['Issue'] = np.where(data['Comment.23'],ame, data['Comment.23'])
    df_new =  pd.DataFrame(data[["Custom field (Story Points)","Year","Issue","Month","Resolved"]])
    return df_new

    