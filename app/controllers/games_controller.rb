require 'json'
require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample}
  end

  def score
    try = params[:word].chars
    grid = params[:letters]
    if is_english_word? && compare_words(try, grid)
      return @result = "yeah!"
    end
  end


private

  def is_english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    player_guess_serialized = URI.open(url).read
    player_guess = JSON.parse(player_guess_serialized)
    return player_guess["found"]
  end

  def compare_words(try,grid)
    try.all? {|letter| grid.count(letter) >= try.count(letter)}
  end
end

