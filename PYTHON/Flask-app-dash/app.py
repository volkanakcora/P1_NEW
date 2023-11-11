import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
import plotly.graph_objs as go
import os
# Connect to main app.py file
import base64

# Connect to your app pages
from apps import story_points




app = dash.Dash(__name__)


app.layout = html.Div(children=[
    
    html.Div([
        html.H1(children='Story Points - Line Graph'),

        html.Div(children=''' Seeing points in yearly/
            
        '''),

        dcc.Graph(
            id='graph1',
            figure= story_points.figLine
        ),  
    ],style= {'marginLeft': 10, 'marginRight': 1500, 'marginTop': 0, 'marginBottom': 10, 'width': '49%'
           
            }),
    
    html.Div([
        html.H1(children='Maintenance Points'),

        html.Div(children='''
            Dash: A web application framework for Python.
        '''),

        dcc.Graph(
            id='graph2',
            figure=story_points.fig2
        ),  
    ], style= {'marginLeft': 1205, 'marginRight': 10, 'marginTop': -498, 'marginBottom': 10,'width': '49%', "background" : "lightblue"
            }),

    html.Div(children=[
        html.H1(children='STORY POINTS'),
        html.Div(children=''),
        dcc.Graph(figure = story_points.fig3)
    ]),
])




if __name__ == '__main__':
    app.run_server(debug=True)




# dcc.Graph(
#         id='example-graph',
#         figure={
#             'data': [story_points.trace1,story_points.trace2],
#             'layout':
#             go.Layout(title='Story Points/Years', barmode='group',)
#         }),