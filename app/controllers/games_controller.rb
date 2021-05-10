require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    10.times do
      @grid << ('A'..'Z').to_a.sample
    end
  end

  def score
    verification = []
    @your_attempt = params[:question]
    url = "https://wagon-dictionary.herokuapp.com/#{@your_attempt}"
    answer = JSON.parse(URI.open(url).read)
    letters = @your_attempt.upcase.chars
    grid = params[:let].gsub!(/[^0-9A-Za-z]/, '').chars
    letters.each do |letter|
      if grid.include?(letter)
        verification << true
        grid.delete_at(grid.index(letter))
      else
        verification << false
      end
    end
    if verification.include?(false)
      verification = false
    else
      verification = true
    end
    if answer["found"] == true && verification == true
      @score = @your_attempt.length * 10
      @message = "You won !!"
    elsif answer["found"] == false && verification == true
      @score = 0
      @message = "You lost, not an english word"
    elsif verification == false
      @score = 0
      @message = "You lost, not in the grid"
    end
  end
end
