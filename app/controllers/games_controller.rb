require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    @letters << ['a', 'e', 'i', 'o', 'u'][rand(5)] #Always adds a vowel first.
    11.times{ @letters << ('a'..'z').to_a[rand(26)] }
    @letters.shuffle!
  end

  def score
    available_array = params[:available_letters].split(" ")
    user_array = params[:answer].split("")
    @check = check_dictionary(params[:answer])
    @round_score = 0
    session[:score] = 0 if session[:score].nil?
    if compare_arrays(available_array, user_array) && @check['found'] == true
      @result = 'Well done'
      @round_score = (user_array.length * 5)
      session[:score] += @round_score
    elsif compare_arrays(available_array, user_array) == false
      @result = 'Try again'
    elsif @check['found'] == false
      @result = 'That is not an English word'
    end
  end

  private

  def compare_arrays(available_array, user_array)
    user_array.all? do |letter|
      available_array.count(letter) >= user_array.count(letter)
    end
  end

  def check_dictionary(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionary_hash = URI.open(url).read
    JSON.parse(dictionary_hash)
  end
end
