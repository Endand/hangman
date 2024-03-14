# Hangman Game

This is a simple command-line Hangman game implemented in Ruby.

## How to Play

1. Run the Hangman game by executing the `hangman.rb` file with 'ruby hangman.rb' on the console.
2. The game will randomly select a secret word from a list of English words.
3. You have a limited number of guesses to figure out the secret word.
4. Type a letter to guess it. If the letter is part of the secret word, it will be revealed. Otherwise, you lose a guess.
5. You can type "save" at any time to save your progress and exit the game.
   - You can then load the save data when you re-run the program.
6. If you correctly guess all the letters in the secret word, you win! Otherwise, you lose.

## Features

- Random selection of secret words from a list of English words.
- Saving and loading game progress.
- Interactive command-line interface.
- Error handling for invalid inputs.
