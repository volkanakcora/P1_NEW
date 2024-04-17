from django.urls import path
from . import views

urlpatterns = [
    path('bikes/', views.all_films),
] 