import streamlit as st
import pandas as pd
import pickle
import numpy as np

# Load the model and data
model = pickle.load(open('LinearRegressionModel.pkl', 'rb'))
car_data = pd.read_csv('Cleaned_Car_data.csv')

# Prepare the data for dropdown menus
companies = sorted(car_data['company'].unique())
years = sorted(car_data['year'].unique(), reverse=True)
fuel_types = car_data['fuel_type'].unique()

# Streamlit app
st.title("Car Price Predictor")

# Function to get car models based on selected company
def get_car_models(selected_company):
    if selected_company == "Select Company":
        return []
    return sorted(car_data[car_data['company'] == selected_company]['name'].unique())

# Create dropdowns and input field
company = st.selectbox("Select the company:", ["Select Company"] + companies)
car_models = get_car_models(company)
car_model = st.selectbox("Select the model:", car_models)
year = st.selectbox("Select Year of Purchase:", years)
fuel_type = st.selectbox("Select the Fuel Type:", fuel_types)
kilo_driven = st.number_input("Enter the Number of Kilometres that the car has travelled:", min_value=0, step=1)

# Predict button
if st.button("Predict Price"):
    if company == "Select Company":
        st.write("Please select a valid company.")
    else:
        input_data = pd.DataFrame([[car_model, company, year, kilo_driven, fuel_type]],
                                  columns=['name', 'company', 'year', 'kms_driven', 'fuel_type'])
        prediction = model.predict(input_data)[0] / 100000  # Convert prediction to lacs
        st.write(f"Prediction: ₹ {prediction:.2f} Lacs")
