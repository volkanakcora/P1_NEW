from django.shortcuts import render
import pandas as pd 

def home(request):
    return render(request, "index.html")



def getPredictions(sentence):
    import pickle
    model = pickle.load(open("nlpclassifier.sav", "rb"))
    scaled = pickle.load(open("scaler.sav","rb"))
    prediction = model.predict(scaled.transform(pd.Series([sentence])))

    if prediction == 0:
        return "this comment is negative"
    elif prediction == 1:
        return "this comment is positive"
    else:
        return "error dude error..."

def result(request):
    sentence = str(request.GET["sentence"])

    result = getPredictions(sentence)

    return render(request,"result.html", {'result':result})



   