import sys
from flask import Flask, render_template, request, redirect
import requests
from flask import Flask, render_template, request, redirect, flash
from flask_sqlalchemy import SQLAlchemy
import requests
import os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///weather.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# OpenWeatherMap API key
API_KEY = 'b435a561c9c15256cb2c45c9674b02cf'

# Define the City model
class City(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)



# Sample data for testing
predefined_weather_data = [
    {"city": "BOSTON", "temperature": 9, "weather_state": "Chilly", "time": "night"},
    {"city": "NEW YORK", "temperature": 32, "weather_state": "Sunny", "time": "day"},
    {"city": "EDMONTON", "temperature": -15, "weather_state": "Cold", "time": "evening-morning"},
]

@app.route('/')
def index():
    # Get city names from the database
    cities = City.query.all()

    # Get weather data for each city
    weather_data = []
    for city in cities:
        weather_data.append(get_weather_data(city.name))

    # Pass the weather data to the template
    return render_template('index.html', weather_data=weather_data)

@app.route('/add', methods=['GET', 'POST'])
@app.route('/add', methods=['POST'])
def add_city():
    # Get the city name from the form
    city_name = request.form.get('city_name')

    # Check if the city already exists in the database
    existing_city = City.query.filter_by(name=city_name).first()
    if existing_city:
        flash(f'{city_name} is already in the list!', 'warning')
    else:
        # Add the new city to the database
        new_city = City(name=city_name)
        db.session.add(new_city)
        db.session.commit()
        flash(f'{city_name} added successfully!', 'success')

    # Redirect to the main page
    return redirect('/')
def get_weather_data(city_name):
    # Construct the API URL
    api_url = f'http://api.openweathermap.org/data/2.5/weather?q={city_name}&appid={API_KEY}'

    try:
        # Make a GET request to the OpenWeather API
        response = requests.get(api_url)
        data = response.json()

        # Extract relevant information from the API response
        temperature = data['main']['temp']
        weather_state = data['weather'][0]['main']
        time_of_day = determine_time_of_day(data['timezone'])

        # Convert temperature from Kelvin to Celsius
        temperature_celsius = round(temperature - 273.15, 2)

        # Return the weather data in the required format
        return {"city": city_name, "temperature": temperature_celsius, "weather_state": weather_state, "time": time_of_day}
    except Exception as e:
        print(f"Error fetching weather data: {e}")
        # Return a default data in case of an error
        return {"city": city_name, "temperature": "N/A", "weather_state": "N/A", "time": "N/A"}

def determine_time_of_day(timezone):
    # You can implement logic here to determine the time of day based on the timezone
    # For simplicity, returning 'day' for positive timezone and 'night' for negative timezone
    return 'day' if timezone > 0 else 'night'

# Set the secret key for the Flask app
app.config['SECRET_KEY'] = os.urandom(24)


if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    if len(sys.argv) > 1:
        arg_host, arg_port = sys.argv[1].split(':')
        app.run(host=arg_host, port=arg_port)
    else:
        app.run()
