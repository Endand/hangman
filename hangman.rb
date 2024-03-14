class Hangman
   def initialize
      @word=choose_word
      @guess_left= (@word.length > 6) ? 8 : 6
      @wrong_guesses=[]
      @progress=["_"]*@word.length
      @gameboard=GameBoard.new(@guess_left,@wrong_guesses,@progress)
      @player=Player.new
      @win=false

      check_save
      play_game
   end
   
   def choose_word
      words=File.read('google-10000-english-no-swears.txt')
      words=words.split
      in_range = words.select {|word| word.length.between?(5, 12)}
      word = in_range.sample
   end

   def play_game
      puts "\nPlay Hangman!\n\n"
      @gameboard.update_board(@guess_left,@wrong_guesses,@progress)
      while @guess_left>0 && @win==false
         @gameboard.show_board
         guess = @player.take_guess
         guess=='save' ? save_game(@guess_left,@wrong_guesses,@progress) : analyze_guess(guess)
      end
      @gameboard.show_result(@win,@word)
   end

   def save_game(guess_left,wrong_guesses,progress)
      #save the parameters into a new file
      File.open('saved_game.txt','w') do |file|
         file.puts guess_left.to_s
         file.puts wrong_guesses.join
         file.puts progress.join
      end
      puts "Progress Saved Successfully."
   end

   def analyze_guess(guess)
      if @word.include?(guess)
         puts "\nThat letter IS part of the secret word.\n"
         word_c=@word.chars
         word_c.each_with_index {|c,index| @progress[index]=guess if c==guess}
      else 
         puts "\nThat letter is NOT part of the secret word.\n"
         @wrong_guesses << guess
         @guess_left-=1
      end
      @gameboard.update_board(@guess_left,@wrong_guesses,@progress)
      if @progress.join==@word
         @win=true
      end
   end

   def check_save
      if File.exist?('saved_game.txt')
         puts "There is a save, would you like to load it?"
         yn= gets.chomp.downcase
         yn= 'n' if yn.nil? || yn.empty? 
         yn= 'y' if yn.match?(/yes/)
         
         if yn=='y'
            load_game
         else
            puts "\nStarting a New Game!\n\n"
         end
      end
   end

   def load_game
      begin
         File.open("saved_game.txt",'r') do |file|
            file.each_with_index do |line,index|
               case index
               when 0
                 @guess_left = line.to_i
               when 1
                 @wrong_guesses = line.chomp.split('')
               when 2
                 @progress = line.chomp.split('')
               end
            end
         end
      rescue 
         puts "File not found."
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
      puts "------------------------------------------------------------------"
      puts "Current Progress: #{@progress.join}\n"
      puts "\nWrong Guesses: #{@wrong_guesses.join(" ")}\n"
      puts "\nRemaining Letters: [#{(('a'..'z').to_a-@wrong_guesses-@progress).join(" ").upcase}]\n"
      puts "\n#{@guess_left} Trys left\n"
      puts "------------------------------------------------------------------"
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

Hangman.new
