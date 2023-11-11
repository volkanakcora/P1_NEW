from django.contrib import admin
from django.urls import path

from languageclassification import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.home, name='home'),
    path('result/', views.result, name='result'),
]
