# tic-tac-toe
simple masm tic tac toe game using masm for x86 processor
1.  You must use a two-dimensional arrayand Base-Index operands (Row-major order) 
throughout the game.  The game board is created with characters.
              -| -| -
              -| -| - This is an example of the empty board.
              -| -| -

              -| x | -
              -| o | - This is an example of a game in progress.
              -| - | -
2.  All Procedures will be called with PROTO/INVOKE/PROC.  I will be checking for this.  DO NOT 
USE USES as discussed in class.The only exception is the Irvine32 library.  These must be called
with CALL.
3.  If the game is player vs computer, start the game by randomly choosing which of player or
computerto make first move. Display who will go first.The first player will be assigned the
letter x.  

  a. The computerchooses a move by selecting an open positionrandomly.  (We are not
  developing Artificial Intelligenceso don’t waste your time on this).
    i)However, if the game is player vs computer, and the center square is
    available on the computer’s first turn, the computer MUST choose that
    square (regardless of whether or not the computer the first or second
    player).
    ii)Afterwards,or if the center square is taken (see above)all moves by the 
    computer will be random.
    
   b. The player will enter a move via the keyboard.
    i)  Youmust check to see if it is a valid move, i.e. notan already occupied 
    ‘square’, or a square that is non-existent.
    ii)  Keep asking for a move until a valid move is entered.
    iii)  As the player selects a square, that square’s background should turn to blue
    on white (x) or white on blue(o), depending on whose turn it is. 
    
   c. After each move,clear the screen and redisplay the game with the new move 
   entered.
   
   d. At the conclusion of each game of tic-tac-toe, ask if the player wishes to playagain. 
   Yes,even if it is computer vs computer.  
   
   e.  Have a menu option that allows the user to check statistics.
    i)How many games played
    ii)How many games won by Player 1
    iii)How many games won by Player 2
    iv)How many games resulted in a draw
   f.  When the user chooses to exitthe program, the above statistics will be displayed until
   a key is pressed.
   
4.  If the game is computer vs computer after each move display thecurrent state of the game
for 1seconds, before allowing another move to be made.The user just watchesthe game 
being played.

5.  When the game ends, display who won(player 1 or player 2)orif the game was a draw.
  a. If someone (either player or computer) wins, highlight thewinning path (either three 
  x’s or three o’s) with black on yellowas the final display.
  
6.  The game will start with a menu.  The options are player vs computer, computer vs 
computer, and exit.

7.  As always, variables used by a procedure must either be passed to that procedure or created
within the procedure.  Only Main PROC can directly access the variables initialized in .data.  All
others must be local to the procedures.  

8.  Style counts to include proper commenting.You must (at the beginning of your code) 
include your name and any special functionality you have implemented.  

9.  I reserve the right to award extra credit for innovative code and implementation thereof.
