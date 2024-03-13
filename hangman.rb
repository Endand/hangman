class Hangman
   def initialize
      @word=choose_word
      @guess_left= 6
      @wrong_guesses=[]
      @progress=["_"]*@word.length
      @gameboard=GameBoard.new(@word.length,@guess_left,@wrong_guesses,@progress)
   end
   
   def choose_word
      words=File.read('google-10000-english-no-swears.txt')
      words=words.split
      in_range = words.select {|word| word.length.between?(5, 12)}
      word = in_range.sample
   end

   def show_word
      puts @word
   end

   def start_game
      puts "\nPlay Hangman!\n"
      @gameboard.show_board
   end
   
end

#shows current state of the game
class GameBoard
   def initialize(word_length,guess_left,wrong_guesses,progress)
      @word_length=word_length
      @guess_left=guess_left
      @wrong_guesses=wrong_guesses
      @progress=progress 
   end

   def show_board
      puts "\nCurrent Progress: #{@progress.join}\n"
      puts "\nWrong Guesses: #{@wrong_guesses.join(" ")}\n"
      puts "\n#{@guess_left} Trys left\n"
   end
end


Hangman.new.start_game
