require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split
    @included = word_in_grid?(@word, @letters)
    @valid_word = valid_english_word?(@word)

    if @included && @valid_word
      @message = "Congratulations! #{@word} is a valid English word!"
    elsif !@included
      @message = "Sorry, but #{@word} can't be built from #{@letters.join(', ')}."
    else
      @message = "Sorry, but #{@word} is not a valid English word."
    end
  end

  private

  def word_in_grid?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def valid_english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end
end
