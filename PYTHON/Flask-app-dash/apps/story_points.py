import dash
import dash_core_components as dcc
import dash_html_components as html
import plotly.express as px
import pandas as pd
from datetime import datetime
import numpy as np
import plotly.graph_objs as go
#from app import app
import pathlib
import os
# PATH = pathlib.Path(__file__).parent
# DATA_PATH = PATH.joinpath("./datasets").resolve()

# -*- coding: utf-8 -*-

# Run this app with `python app.py` and
# visit http://127.0.0.1:8050/ in your web browser.

import dash
import dash_core_components as dcc
import dash_html_components as html
import plotly.express as px
import pandas as pd
from datetime import datetime
import numpy as np
import plotly.graph_objs as go
import os
import csv
import seaborn as sns 
from apps import functions 

data_development = pd.read_csv(r"C:\\Users\\oh856\\Desktop\\Flask-app-dash\\datasets\\Development-Real.csv")
data_maintenance = pd.read_csv(r"C:\\Users\\oh856\\Desktop\\Flask-app-dash\\datasets\\Maintenance-Real.csv")




df_new_development = functions.data_processing(data_development)
df_new_development = df_new_development.drop(df_new_development[df_new_development.Resolved < 2019].index)
df_new_maintenance = functions.data_processing(data_maintenance)
df_new_maintenance = df_new_maintenance.drop(df_new_maintenance[df_new_maintenance.Resolved < 2019].index)


data_development = pd.read_csv("Development-Real.csv", low_memory=False)
data_maintenance = pd.read_csv("Maintenance-Real.csv", low_memory=False)
xbid = pd.read_csv("XBID-Support.csv", low_memory=False)



last_version_of_calculation = functions.total_calculation(data_development, "Development").append(functions.total_calculation(data_maintenance, "Maintenance"))
last_version_of_calculation = last_version_of_calculation.append(functions.total_calculation(xbid,"Xbid-Support"))
last_version_of_calculation = pd.DataFrame(last_version_of_calculation)




#where the percentage is calculated an functions is called
percentage = last_version_of_calculation.groupby(["Issue","Resolved"]).sum()
percentage = percentage.reset_index()
percentage = percentage.drop(percentage[percentage.Resolved < 2019].index)



# where the percentage is calculated and sorted
issue_count = last_version_of_calculation.groupby(["Issue","Resolved"]).count()
issue_count = issue_count.reset_index()
issue_count = issue_count.drop(issue_count[issue_count.Resolved < 2019].index)
issue_count = issue_count.sort_values("Resolved")

very_last_version = functions.percentage_calculation(percentage)
very_last_version["Issue_count"] = issue_count["Custom field (Story Points)"]



data_development = pd.read_csv("Development-Real.csv", low_memory=False)
data_maintenance = pd.read_csv("Maintenance-Real.csv", low_memory=False)
##### Data processing for Line Graph
df_new_development_line = functions.line_processing(data_development,"Development")
df_new_maintenance_line = functions.line_processing(data_maintenance,"Maintenance")
### Line Processing - Development
df_new_development_line = df_new_development_line.groupby("Resolved").sum()
df_new_development_line["Issue"] = df_new_development_line["Month"]
df_new_development_line["Issue"] = np.where(df_new_development_line["Issue"],"Development",df_new_development_line["Issue"])
### Line Processing - Maintenance
df_new_maintenance_line = df_new_maintenance_line.groupby("Resolved").sum()
df_new_maintenance_line["Issue"] = df_new_maintenance_line["Month"]
df_new_maintenance_line["Issue"] = np.where(df_new_maintenance_line["Issue"],"Maintenance",df_new_maintenance_line["Issue"])
## Merging two different lines
new_type = df_new_development_line.append(df_new_maintenance_line).reset_index()
new_type = new_type.sort_values("Resolved") 



fig = px.bar(df_new_development, x='Resolved', y='Custom field (Story Points)', height=400, text= "Custom field (Story Points)")
fig2 = px.bar(df_new_maintenance, x='Resolved', y='Custom field (Story Points)', height=400, text= "Custom field (Story Points)")
fig3 = px.bar(very_last_version, x="Resolved", y='Custom field (Story Points)', height=400, color="Issue", text= "Custom field (Story Points)", hover_data =["percent","Issue_count"], color_discrete_sequence=["slateblue","orangered","green"])
figLine = px.line(new_type, x='Resolved', y='Custom field (Story Points)', title='Time Series with Range Slider and Selectors', color ="Issue")

figLine.update_xaxes(
    rangeslider_visible=True,
    rangeselector=dict(
        buttons=list([
            dict(count=1, label="1m", step="month", stepmode="backward"),
            dict(count=6, label="6m", step="month", stepmode="backward"),
            dict(count=1, label="YTD", step="year", stepmode="todate"),
            dict(count=1, label="1y", step="year", stepmode="backward"),
            dict(step="all")
        ])
    )
)             
   


fig3.update_layout(
    
    hoverlabel=dict(
        bgcolor="white",
        font_size=16,
        font_family="Rockwell")
    ) 
    


    