
import dash
import dash_core_components as dcc
import dash_html_components as html
import plotly.graph_objs as go
import pandas as pd
from dash.dependencies import Input, Output
from numpy import random

app = dash.Dash()

df = pd.read_csv('Automobile_data.csv')
df['price'] = random.randint(5,len(df))*0.10 + df['price']

app.layout = html.Div([
                html.Div([
                    dcc.Graph(id='mpg-scatter',
                              figure={
                                  'data':[go.Scatter(
                                      x=df['price'],
                                      y=df['city.mpg'],
                                      text=df['make'],
    #                                   hoverinfo='text',
                                      mode='markers'
                                  )],
                                  'layout':go.Layout(
                                      title='MPG vs Model Year',
                                      xaxis={'title':'Model Year'},
                                      yaxis={'title':'MPG'},
                                      hovermode='closest'
                                   )

                              }
                    )
                ],style={'width':'50%','display':'inline-block'}),
                
                html.Div([
                    dcc.Graph(id='mpg-acceleration',
                              figure={
                                  'data':[go.Scatter(x=[0,1],
                                                    y=[0,1],
                                                    mode='lines')
                                      
                                  ],
                                  'layout':go.Layout(title='Acceleration',margin={'l':0})
                              }
                    )
                ],style={'width':'20%','height':'50%','display':'inline-block'}),
    
                html.Div([
                    dcc.Markdown(id='mpg-metrics')
                ],style={'width':'20%','display':'inline-block'})
])


# @app.callback(Output('mpg-acceleration','figure'),
#              [Input('mpg-scatter','hoverData')])
# def callback_graph(hoverData):
#     df_index = df["engine.size"]
#     figure = {'data':[go.Scatter(x=[],
#                                 y=[[df_index]['engine.size']],
#                                 mode = "box",)],
#              'layout':go.Layout(title=df.iloc[df_index]['make'],
#                                 xaxis={'visible':False},
#                                 yaxis={'visible':False},
#                                 margin={'l':0},
#                                 height = 300 
#                                )}
#     return figure

@app.callback(Output('mpg-metrics','children'),
             [Input('mpg-scatter','hoverData')])
def callback_stats(hoverData):
    df_index = hoverData['points'][0]['pointIndex']
    metrics = """
            
            Horse Power = {}
            """.format(df.iloc[df_index]['engine.size'],
                      df.iloc[df_index]['engine.size'])
    return metrics
    

if __name__ == '__main__':
    app.run_server()
#view rawA Guide to Plotly Dash Interactive Visualizations.py hosted with ❤ by GitHub