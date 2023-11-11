
import pandas as pd 
import nltk
from textblob import Word
from nltk.corpus import stopwords



class data_process:
    def data_preparation(self,data):
        data = data.apply(lambda x: " ".join(x.lower() for x in x.split()))
        data = data.str.replace('[^\w\s]','')
        
        data = data.str.replace('\d','')
             
        sw = stopwords.words("english")
        data = data.apply(lambda x: " ".join(x for x in x.split() if x not in sw))
        sil = pd.Series(' '.join(data).split()).value_counts()[-1000:]
        data = data.apply(lambda x: " ".join(x for x in x.split() if x not in sil))
        from textblob import Word
        data = data.apply(lambda x: " ".join([Word(word).lemmatize() for word in x.split()]))
        return data  

   

