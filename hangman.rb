class Hangman
   def initialize
      @word=choose_word
      @guess_left= (@word.length > 6) ? 8 : 6
      @wrong_guesses=[]
      @progress=["_"]*@word.length
      @gameboard=GameBoard.new(@guess_left,@wrong_guesses,@progress)
      @player=Player.new
      @win=false
   end
   
   def choose_word
      words=File.read('google-10000-english-no-swears.txt')
      words=words.split
      in_range = words.select {|word| word.length.between?(5, 12)}
      word = in_range.sample
   end

   def play_game
      puts "\nPlay Hangman!\n"
      while @guess_left>0 && @win==false
         @gameboard.show_board
         guess = @player.take_guess
         guess=='save' ? save_game : analyze_guess(guess)
      end
      @gameboard.show_result(@win,@word)
   end

   def save_game
      p "saved"
   end

   def analyze_guess(guess)
      if @word.include?(guess)
         word_c=@word.chars
         word_c.each_with_index {|c,index| @progress[index]=guess if c==guess}
      else 
         puts "\nThat letter is not part of the secret word.\n"
         @wrong_guesses << guess
         @guess_left-=1
      end
      @gameboard.update_board(@guess_left,@wrong_guesses,@progress)
      if @progress.join==@word
         @win=true
      end
   end
   
end

#shows current state of the game
class GameBoard
   def initialize(guess_left,wrong_guesses,progress)
      @guess_left=guess_left
      @wrong_guesses=wrong_guesses
      @progress=progress
   end

   def show_board
      puts "\nCurrent Progress: #{@progress.join}\n"
      puts "\nWrong Guesses: #{@wrong_guesses.join(" ")}\n"
      puts "\nRemaining Letters: [#{(('a'..'z').to_a-@wrong_guesses-@progress).join(" ").upcase}]\n"
      puts "\n#{@guess_left} Trys left\n"
   end

   def update_board(guess_left,wrong_guesses,progress)
      @guess_left=guess_left
      @wrong_guesses=wrong_guesses
      @progress=progress
   end

   def show_result(win,secret_word)
      if win==true
         puts "\nYou got the secret word [#{secret_word.upcase}]!\n"
      else
         puts "\nYou Lost. Secret word was [#{secret_word.upcase}].\n"
      end
   end
end

class Player
   def take_guess
      puts "\nTake a guess! (Type 'save' if you want to save your progess.)\n"
      alphabet=('a'..'z').to_a
      guess=''
      until alphabet.include?(guess)
         guess=gets.chomp.downcase
         break if guess=='save'
      end
      guess
   end
end

Hangman.new.play_game
