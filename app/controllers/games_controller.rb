require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = generate_grid
    @player_guess = ''
  end

  def score
    @player_guess = params[:word].downcase
    @letters = params[:grid].split(" ")
    @start_time = params[:start_time]

    @result = run_game
  end

  private

  def generate_grid
    letters = ('a'..'z').to_a.shuffle * 10
    letters.take(10)
  end

  def can_build_word?
    @player_guess.chars.all? { |c| @letters.count(c) >= 1 }
  end

  def english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@player_guess}"
    word = JSON.parse(open(url).read)
    word['found']
  end

  def run_game
    if can_build_word? && english_word?
      "Well done!"
    elsif !english_word?
      "Sorry, '#{@player_guess.upcase}' doesn't seem to be an english word."
    elsif !can_build_word?
      "Sorry, cannot build '#{@player_guess.upcase}' out of '#{@letters.join(' - ').upcase}'."
    end
  end
end
