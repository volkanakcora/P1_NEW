from django.shortcuts import render

# Create your views here.
from django.conf import settings
from django.shortcuts import render

my_movies = [
    {
        'title': 'Catchfire',
        'year': 1990,
    },
    {
        'title': 'Mighty Ducks the Movie: The First Face-Off',
        'year': 1997,
    },
    {
        'title': 'Le Zombi de Cap-Rouge',
        'year': 1997,
    },
]


def all_films(request):
    return render(request, 'movies/index.html', {'movies': my_movies, 'director': settings.DIRECTOR})