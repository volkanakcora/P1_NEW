from textblob import TextBlob
from sklearn import model_selection, preprocessing, linear_model, naive_bayes, metrics
from sklearn.feature_extraction.text import TfidfVectorizer, CountVectorizer
from sklearn import decomposition, ensemble

import pandas, xgboost, numpy, textblob, string
from keras.preprocessing import text, sequence
from keras import layers, models, optimizers
import prep as pr  
from sklearn import model_selection, preprocessing, linear_model, naive_bayes, metrics
import pickle 

from warnings import filterwarnings
filterwarnings('ignore')


import pandas as pd 
data = pd.read_csv("train.tsv",sep = "\t")

data["Sentiment"].replace(0, value = "negatif", inplace = True)
data["Sentiment"].replace(1, value = "negatif", inplace = True)
data["Sentiment"].replace(3, value = "pozitif", inplace = True)
data["Sentiment"].replace(4, value = "pozitif", inplace = True)

data = data[(data.Sentiment == "negatif") | (data.Sentiment == "pozitif")]


df = pd.DataFrame()
df["text"] = data["Phrase"]
df["label"] = data["Sentiment"]


data_process = pr.data_process()
df["text"] = data_process.data_preparation(df['text'])


train_x, test_x, train_y, test_y = model_selection.train_test_split(df["text"],
                                                                   df["label"], 
                                                                    random_state = 1)


encoder = preprocessing.LabelEncoder()
train_y = encoder.fit_transform(train_y)
test_y = encoder.fit_transform(test_y)


#Count Vectors
vectorizer = CountVectorizer()
vectorizer.fit(train_x)

x_train_count = vectorizer.transform(train_x)
x_test_count = vectorizer.transform(test_x)



loj = linear_model.LogisticRegression()
loj_model = loj.fit(x_train_count, train_y)
accuracy = model_selection.cross_val_score(loj_model, 
                                           x_test_count, 
                                           test_y, 
                                           cv = 10).mean()



#new_comment = pd.Series("what is so bad, dissapointment")

v = CountVectorizer()
sc = v.fit(train_x)


#print(loj_model.predict(new_comment))

pickle.dump(loj_model,open("nlpclassifier.sav","wb"))
pickle.dump(sc,open("scaler.sav","wb"))