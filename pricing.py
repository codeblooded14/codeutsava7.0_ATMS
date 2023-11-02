from flask import Flask, request, jsonify
import pandas as pd
from statsmodels.tsa.arima.model import ARIMA
import requests

app = Flask(__name__)

# Load your dataset
df = pd.read_csv("petrol_data.csv")  # Replace with the actual path to your CSV file

# Assume 'date' is already in datetime format, adjust as needed

@app.route('/predict_price', methods=['POST'])
def predict_journey_cost():
    # Get input data from the Flutter app
    data = request.get_json()

    # Extract input values
    origin_city = data['origin_city']
    destination_city = data['destination_city']
    journey_date = pd.to_datetime(data['journey_date'])
    distance_between_cities = data['distance']
    fuel_consumption = data['fuel_consumption']

    # Filter data for the selected origin and destination cities
    origin_data = df[df['city'] == origin_city][['date', 'rate']]
    destination_data = df[df['city'] == destination_city][['date', 'rate']]

    # Split data into training and testing for both origin and destination
    train_size = int(len(origin_data) * 0.8)
    origin_train, origin_test = origin_data[:train_size], origin_data[train_size:]
    destination_train, destination_test = destination_data[:train_size], destination_data[train_size:]

    # Fit ARIMA models for both origin and destination
    origin_model = ARIMA(origin_train['rate'], order=(5, 1, 0))
    origin_model_fit = origin_model.fit()

    destination_model = ARIMA(destination_train['rate'], order=(5, 1, 0))
    destination_model_fit = destination_model.fit()

    # Make predictions for both origin and destination
    origin_prediction = origin_model_fit.forecast(steps=1).values[0]
    destination_prediction = destination_model_fit.forecast(steps=1).values[0]

    # Calculate the predicted journey cost
    origin_petrol_price = origin_prediction
    destination_petrol_price = destination_prediction
    total_cost = (distance_between_cities / fuel_consumption) * (origin_petrol_price + destination_petrol_price)

    # Prepare response data
    response_data = {
        'origin_petrol_price': origin_petrol_price,
        'destination_petrol_price': destination_petrol_price,
        'journey_cost': total_cost
    }

    return jsonify(response_data)

@app.route('/carbon_emissions', methods=['GET', 'POST'])
def calculate_carbon_emissions():
    if request.method == 'POST':

        # Get input data from the Flutter app
        data = request.get_json()

        # Extract input values
        distance = data['distance']
        vehicle = data['vehicle']

        # Build the request parameters
        querystring = {"distance": str(distance), "vehicle": vehicle}

        headers = {
            "X-RapidAPI-Key": "ec044fc6eamshb257fa6cb563ee7p10ade4jsn46202fbc0f63",
            "X-RapidAPI-Host": "carbonfootprint1.p.rapidapi.com"
        }

        # Make the API request
        url = "https://carbonfootprint1.p.rapidapi.com/CarbonFootprintFromCarTravel"

        response = requests.get(url, headers=headers, params=querystring)

        if response.status_code == 200:
            data = response.json()
            emissions = data["carbonEquivalent"]
            result = {
                "carbon_emissions": emissions,
                "distance": distance
            }
            return jsonify(result)
        else:
            return jsonify({"error": "Error occurred during API request. Please try again."})

if __name__ == '__main__':
    app.run(debug=True)
