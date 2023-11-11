import networkx as nx
import numpy as np
import matplotlib.pyplot as plt
import pylab
import json 
import pandas as pd
import numpy as np
import networkx as nx
import matplotlib as mpl
# config InlineBackend.figure_format = 'retina' 
import matplotlib.cm as cmx

data = pd.read_json('rules.json')

def process_data(data, first_node, number):
    data_body = data[first_node].apply(pd.Series)
    if number != None:
        data_object = data_body[number].apply(pd.Series)
    else:
        data_object = data_body
    obj_val = data_object['object'].apply(pd.Series)['value']
    subject_val = data_object['subject'].apply(pd.Series)['value']
    predicate_val = data_object['predicate'].apply(pd.Series)
    if 'localName' in predicate_val:
        predicate_val = predicate_val['localName']
    else:
        predicate_val = predicate_val[0]

    return  [obj_val, predicate_val, subject_val]

# def process_data(data,first_node,number,node_name,sub_node):
#     data_body = data[first_node].apply(pd.Series)
#     if number != None:
#        data_object = data_body[number].apply(pd.Series)
#     else:
#         data_object = data_body
# 
    # data_object_value = data_object[node_name].apply(pd.Series)
#     data_object_valueS = data_object_value[sub_node]
#     return  data_object_valueS



first_val = process_data(data, 'body', 0)
second_val = process_data(data, 'body', 1)
consequent_val = process_data(data, 'head', None)

## Antecedents first atom
# data_object_val = process_data(data,"body",0,"object","value")
# data_prediate_val = process_data(data,"body",0,"predicate","localName")
# data_subject_val = process_data(data,"body",0,"subject","value")

# ##Antecedents second atom
# data_second_atom_object_val = process_data(data,"body",1,"object","value")
# data_second_atom_predicate_val = process_data(data,"body",1,"predicate",0)
# data_second_atom_subject_val = process_data(data,"body",1,"subject","value")

# ##Consequent
# data_consequent_object_val = process_data(data,"head",None,"object","value")
# data_consequent_predicate_val = process_data(data,"head",None,"predicate","localName")
# data_consequent_subject_val = process_data(data,"head",None,"subject","value")

ANT = [ first_val[0][0], second_val[0][0], consequent_val[0][0] ]
EDG = [ first_val[1][0], second_val[1][0], consequent_val[1][0] ]
CNS = [ first_val[2][0], second_val[2][0], consequent_val[2][0] ]

EDG = [s.replace('>', '') for s in EDG]
EDG = [s.replace('<', '') for s in EDG]

# ANT = [data_object_val[0],data_second_atom_object_val[0],data_consequent_object_val[0]] 
# EDG = [data_prediate_val[0],data_second_atom_predicate_val[0],data_consequent_predicate_val[0]]
# CNS = [data_subject_val[0],data_second_atom_subject_val[0],data_consequent_subject_val[0]]

Antecedents1 = pd.Series(CNS) 
Edges1 = pd.Series(EDG) 
Consequents1 = pd.Series(ANT)

frame = {'antecedents': Antecedents1 , "edges": Edges1, 'consequent': Consequents1 } 
frame1 = {'Body': Antecedents1,"Head": Consequents1, 'Body Second Atom': Edges1} 
rule_atoms_in_internal_datastructure = pd.DataFrame(frame) 

G = nx.DiGraph()

for node, res in rule_atoms_in_internal_datastructure.iterrows():
    G.add_edges_from([(res["antecedents"],res["consequent"])], edge_labels = res["edges"], color = "red")
    
    # G.add_edges_from([(result["antecedents"][1],result["consequent"][1])],edge_labels = result["edges"][1])
    # G.add_edges_from([(result["antecedents"][2],result["consequent"][2])],edge_labels = result["edges"][2])
    # G.add_edges_from([(result["antecedents"][3],result["consequent"][3])],edge_labels = result["edges"][3])

# G.add_edges_from([('A', 'B'),('C','D'),('G','D')], weight=1)
# G.add_edges_from([('D','A'),('D','E'),('B','D'),('D','E')], weight=2)
# G.add_edges_from([('B','C'),('E','F')], weight=3)
# G.add_edges_from([('C','F')], weight=4)




edge_labels=dict([((u,v,),d['edge_labels'])
                 for u,v,d in G.edges(data=True)])


colorize = {k:v for v, k in enumerate(sorted(set(G.nodes())))}

small, mid, big = sorted(colorize.values())
norm = mpl.colors.Normalize(vmax=big)
mapper = mpl.cm.ScalarMappable(norm=norm, cmap=mpl.cm.coolwarm)



pos=nx.spring_layout(G)
nx.draw_networkx_edge_labels(G,pos,edge_labels=edge_labels)
nx.draw(G,pos, node_color = "yellow", node_size=2500,edge_color=[mapper.to_rgba(i) for i in colorize.values()],edge_cmap=plt.cm.Reds, with_labels = True, nodelist = colorize)
pylab.legend(frame1)
pylab.show()

