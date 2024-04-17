from django.urls import path
from . import views

urlpatterns = [
    path('list_of_articles/', views.ArticleListView.as_view(), name='list'),
    path('contributors/', views.contributors, kwargs={"name": "Robert May", "age": 38, "experience": 
    "Two years in startup, graduated from MIT in 2020"}),
    path('', views.ArticleListView.as_view(), name='index'),
    path('article/<int:pk>', views.ArticleDetailView.as_view(), name='article-detail'),
    ]

