from django.urls import path
from .views import article, index, create_article
# URL handler for news articles
urlpatterns = [
    path('', index, name='index'),
    path('<int:link>/', article, name='article'),
    path('create/', create_article, name='create_article'),
]
