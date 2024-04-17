from django.shortcuts import render, redirect
from django.conf import settings
import json
from django.views import generic  
import datetime
from datetime import datetime
from itertools import groupby
from django.http import HttpResponseBadRequest
from django.contrib import messages  # for user messages
# Create your views here.


# Function to read data from news.json and process it
def get_news_data():
    with open(settings.NEWS_JSON_PATH, 'r') as f:
        data = json.load(f)
    return data

# View function to handle news article pages
def article(request, link):
    news_data = get_news_data()
    for item in news_data:
        if item['link'] == link:  # Ensure link conversion to integer
            context = {
                'article': item,
            }
            return render(request, 'news/list_item_page.html', context)
    
    return render(request, '404.html', status=404)  # Handle non-existent articles



def index(request):
  """
  Renders the index page with a list of news articles grouped by date.
  """
  
  news_data = get_news_data()


  # Sort news articles by date in descending order (newest first)
  sorted_news = sorted(news_data, key=lambda item: datetime.strptime(item["created"], "%Y-%m-%d %H:%M:%S"), reverse=True)

  # Group articles by date
  grouped_news = groupby(sorted_news, key=lambda item: item["created"].split()[0])  # Extract date only (YYYY-MM-DD)
  q = request.GET.get('q')

  if q:
     sorted_news = [article for article in sorted_news if q.lower() in article['title'].lower()]
  else:
     sorted_news
  
  
  return render(request, 'news/index.html', {'grouped_news': sorted_news})
 

def create_article(request):
  if request.method == 'POST':
    # Get data from the form
    title = request.POST.get('title')
    text = request.POST.get('text')

    # Validate data (optional, add checks for empty fields)

    # Read existing news data
    with open(settings.NEWS_JSON_PATH, 'r') as f:
      news_data = json.load(f)

    # Create new article data
    new_article = {
      'title': title,
      'text': text,
      'created': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),  # Convert datetime to string
    }

    # Add new article to the list
    news_data.append(new_article)

    # Save updated news data
    with open(settings.NEWS_JSON_PATH, 'w') as f:
      json.dump(news_data, f, indent=4)

    # Success message
    messages.success(request, 'Article created successfully!')
    
    return render(request, 'news/create_article.html')
  else:
    return render(request, 'news/create_article.html')  # Render form template

def new_list(request):
   q = request.GET.get('q')
   if q:
    articles = [article for article in articles if q.lower() in article['title'].lower()]
    print(articles)
