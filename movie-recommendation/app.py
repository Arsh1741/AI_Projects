import pickle
import streamlit as st


def recommend(movie):
    index = movies_dict[movies_dict['title'] == movie].index[0]
    movies_list = sorted(list(enumerate(similarity[index])), reverse=True, key=lambda x: x[1])[1:6]
    recommended_movies = []

    for i in movies_list:
        recommended_movies.append(movies_dict.iloc[i[0]].title)
    return recommended_movies

movies_dict = pickle.load(open('movie_list.pkl', 'rb'))
similarity = pickle.load(open('similarity.pkl', 'rb'))


st.header('Movie Recommender System')


selected_movie = st.selectbox(
    "Select a movie",
    movies_dict['title'].values)

if st.button('Show Recommendation'):
    recommendations = recommend(selected_movie)
    for i in recommendations:
        st.write(i)
