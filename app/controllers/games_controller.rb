require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    # @current_user = session[:session_id]
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample}
    raise
  end

  def score
    try = params[:word].upcase.chars
    grid = params[:letters]
    if !word_letters_in_grid?(try, grid)
      @result = "Sorry but #{params[:word].upcase}, can't be built out of #{grid}"
    elsif !english_word?
      @result = "Sorry but #{params[:word].upcase}, is not a valid English word ..."
    else
      @result = "Congratulations! #{params[:word].upcase} is a valid English word"
      compute_score
    end
  end

  private
  def english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    player_guess_serialized = URI.open(url).read
    player_guess = JSON.parse(player_guess_serialized)
    player_guess["found"]
  end

  def word_letters_in_grid?(try, grid)
    try.all? { |letter| grid.count(letter) >= try.count(letter) }
  end

  def compute_score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    player_guess_serialized = URI.open(url).read
    player_guess = JSON.parse(player_guess_serialized)
    @score =+ player_guess["length"]
  end
end

# store each score and add it to a grand total
