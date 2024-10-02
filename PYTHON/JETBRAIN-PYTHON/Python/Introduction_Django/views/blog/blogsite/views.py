from django.shortcuts import render
from .models import Article
# Create your views here.
from django.http import HttpResponse
from django.views import generic  


class ArticleListView(generic.ListView):
    model = Article
    context_object_name = 'articles'
    queryset = Article.objects.all()
    template_name = 'blogsite/index.html'

    def get_context_data(self, **kwargs):
        num_articles = Article.objects.all().count()
        context = super(ArticleListView, self).get_context_data(**kwargs)
        context['greetings_to'] = 'Anonymous'
        context['num_articles'] = num_articles
        return context
    
class ArticleDetailView(generic.DetailView):
    model = Article
    template_name = 'blogsite/article.html'

def contributors(request):
    return HttpResponse("Contributors of our community")

# in the views.py file:
def contributors(request, age, name, experience):
    return HttpResponse(f"""
            <h2>Contributor of our community:</h2>
            <p>Name: {name}</p>
            <p>Age: {age}</p>
            <p>Experience and some info you'd like to share: {experience}</p>
    """)
