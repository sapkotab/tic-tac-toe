TITLE final exam
;//Program Description:final exam
;//Author:Bhuwan Sapkota
;// Date: 12/14/16

INCLUDE Irvine32.inc
BtoDW PROTO,:dword,:dword
PrintBoard PROTO, :dword, :dword
changeColor PROTO, :dword, :dword, :dword
xMove PROTO,:dword,:dword,:dword,:dword
oMove PROTO,:dword,:dword,:dword,:dword
cm_oMove PROTO,:dword,:dword
cm_xMove PROTO,:dword,:dword
reset2DefaultColor PROTO,:dword,:dword
checkwin PROTO,:dword,:dword
.data
initialpromt byte "Welcome to simple tic tac toe game",13,10
			 byte "when you make the move just enter the number of intented box",13,10
			 byte "box numbers are assigned as follow",13,10
			 byte " 1 | 2 | 3 ",13,10
			byte " 4 | 5 | 6 ",13,10
			byte " 7 | 8 | 9 ",13,10,0
GameBoard  	byte " - | - | - ",13,10
			byte " - | - | - ",13,10
			byte " - | - | - ",13,10,0
DWGameBoard dword ($-GameBoard) Dup(?)					;// will store strings in double word
indexArray	byte 1,5,9
rowsize =($-indexArray)
			byte 14,18,22
			byte 27,31,35								;// store the location of game symbol in string
boardSlength dword (lengthof DWGameBoard-1)				;// stringlenth
entrypromt	byte "choose from (1-9)",13,10,0							;// entry promt
errorpromt	byte "That is not correct,Please choose again",13,10,0	;// errorpromt
menu		byte "Options",13,10
			byte "1:Player vs Computer",13,10
			byte "2:Computer vs Computer",13,10
			byte "3:Exit",13,10,0
P1win byte "Player 1 Win",13,10,0
P2win byte "Player 2 Win",13,10,0
Nowin byte "It is a tie",13,10,0
compTurn byte "Computer's turn",13,10,0
comp1Turn byte "Computer 1's turn",13,10,0
comp2Turn byte "Computer 2's turn",13,10,0
UserTurn byte "User's turn",13,10,0
gameoverMenu byte "Please choose from following",13,10
			byte "1:Replay the Game",13,10
			byte "2:Display Game Statistics",13,10
			byte "3:Exit the Game",13,10,0
gamePlayHeader byte "Total Game Played: ",0
player1Header byte "Game won by player 1: ",0
player2Header byte "Game won by player 2: ",0
tiedGameHead byte "Total Number of game tied: ",0
player1win dword 0
player2win dword 0
tiegame dword 0
.code
main PROC

	mov edx,offset initialpromt							;// initial promt
	call writestring									;// display
	call waitmsg										;// enter to continue
top:
	call clrscr											;// clearing the screen
	mov edx, offset menu								;// printing menu
	call writestring									;// display
	invoke BtoDW,offset GameBoard,offset DWGameBoard	;// filling the doubleword string
backfromerror:
	call readdec										;// reading choice
	cmp eax,1				
	je UserVsComp										;// player vs computer
	cmp eax,2
	je CompVsComp										;// computer vs computer
	cmp eax,3							
	je exits											;//exit
	mov edx,offset errorpromt
	call writestring
	jmp backfromerror						;// go to top to ask again
UserVsComp:
	call randomize							;// random seed
	mov eax,2								;// range 0-1
	call randomrange							;// procedure
	inc eax									;// making 1-2
	cmp eax,1								;// deciding who gonna play first
	je compPlay1UVC
	cmp eax,2
	je userPlay1UVC
compPlay1UVC:
		call clrscr							;// screen is clear
		invoke PrintBoard, offset DWGameBoard, boardSlength
		mov edx,offset compTurn					;// displaying computer turn
		call writestring
		mov eax,1000 								; 1 second
		call Delay
		invoke reset2DefaultColor,offset GameBoard,offset DWGameBoard
		invoke cm_xMove, 	offset DWGameBoard,offset indexArray		;// computer make move
		mov eax,1000 								; 1 second
		call Delay
		invoke checkwin,	Offset DWGameBoard,offset indexArray		;// check if anyone win
		cmp eax,3
		je tie							;// if eax is 3 it means game tied
		cmp eax,1
		jne userPlay2UVC				;// if eax = 1 means player one win
		inc player1win					;// counting the winner	
		call clrscr						;// clearing screen before winner announcment
		mov edx,offset P1win		;// announcing the winner
		call writestring
		invoke PrintBoard, offset DWGameBoard, boardSlength	;// printing the winner
		jmp gamefinish
userPlay2UVC:
		call clrscr							;// screen is clear
		invoke PrintBoard, offset DWGameBoard, boardSlength
		mov edx,offset UserTurn					;// displaying player turn
		call writestring
		invoke reset2DefaultColor,offset GameBoard,offset DWGameBoard
		invoke oMove, offset DWGameBoard,offset indexArray,offset entrypromt,offset errorpromt 	;// computer make move			
		invoke checkwin,Offset DWGameBoard,offset indexArray		;// check if anyone win
		cmp eax,3
		je tie								;// if eax is 3 it means game tied
		cmp eax,2
		jne compPlay1UVC					;// if eax = 1 means player one win
		inc player2win					;// counting the winner	
		call clrscr						;// clearing screen before winner announcment	
		mov edx,offset P2win		;// announcing the winner
		call writestring
		invoke PrintBoard, offset DWGameBoard, boardSlength	;// printing the winner
		jmp gamefinish

userPlay1UVC:
		call clrscr							;// screen is clear
		invoke PrintBoard, offset DWGameBoard, boardSlength
		mov edx,offset UserTurn					;// displaying player turn
		call writestring
		invoke reset2DefaultColor,offset GameBoard,offset DWGameBoard
		invoke xMove, offset DWGameBoard,offset indexArray,offset entrypromt,offset errorpromt 	;// computer make move			
		invoke checkwin,Offset DWGameBoard,offset indexArray		;// check if anyone win
		cmp eax,3
		je tie								;// if eax is 3 it means game tied
		cmp eax,1
		jne compPlay2UVC					;// if eax = 1 means player one win
		inc player1win					;// counting the winner	
		call clrscr						;// clearing screen before winner announcment	
		mov edx,offset P1win		;// announcing the winner
		call writestring
		invoke PrintBoard, offset DWGameBoard, boardSlength	;// printing the winner
		jmp gamefinish
compPlay2UVC:
		call clrscr							;// screen is clear
		invoke PrintBoard, offset DWGameBoard, boardSlength
		mov edx,offset compTurn					;// displaying computer turn
		call writestring
		mov eax,1000 								; 1 second
		call Delay
		invoke reset2DefaultColor,offset GameBoard,offset DWGameBoard
		invoke cm_oMove, 	offset DWGameBoard,offset indexArray		;// computer make move
		mov eax,1000 								; 1 second
		call Delay
		invoke checkwin,	Offset DWGameBoard,offset indexArray		;// check if anyone win
		cmp eax,3
		je tie							;// if eax is 3 it means game tied
		cmp eax,2
		jne userPlay1UVC				;// if eax = 1 means player one win
		inc player2win					;// counting the winner	
		call clrscr						;// clearing screen before winner announcment	
		mov edx,offset P2win		;// announcing the winner
		call writestring
		invoke PrintBoard, offset DWGameBoard, boardSlength	;// printing the winner
		jmp gamefinish
CompVsComp:
	call randomize							;// random seed
	mov eax,2								;// range 0-1
	call randomrange							;// procedure
	inc eax									;// making 1-2
	cmp eax,1								;// deciding who gonna play first
	je comp1Play1CVC
	cmp eax,2
	je comp2Play1CVC
comp1Play1CVC:
		call clrscr							;// screen is clear
		invoke PrintBoard, offset DWGameBoard, boardSlength
		mov edx,offset comp1Turn					;// displaying computer turn
		call writestring
		mov eax,1000 								; 1 second
		call Delay
		invoke reset2DefaultColor,offset GameBoard,offset DWGameBoard
		invoke cm_xMove, 	offset DWGameBoard,offset indexArray		;// computer make move
		mov eax,1000 								; 1 second
		call Delay
		invoke checkwin,	Offset DWGameBoard,offset indexArray		;// check if anyone win
		cmp eax,3
		je tie							;// if eax is 3 it means game tied
		cmp eax,1
		jne comp2Play2CVC				;// if eax = 1 means player one win
		inc player1win					;// counting the winner	
		call clrscr						;// clearing screen before winner announcment	
		mov edx,offset P1win		;// announcing the winner
		call writestring
		invoke PrintBoard, offset DWGameBoard, boardSlength	;// printing the winner
		jmp gamefinish
comp2Play2CVC:
		call clrscr							;// screen is clear
		invoke PrintBoard, offset DWGameBoard, boardSlength
		mov edx,offset comp2Turn					;// displaying computer turn
		call writestring
		mov eax,1000 								; 1 second
		call Delay
		invoke reset2DefaultColor,offset GameBoard,offset DWGameBoard
		invoke cm_oMove, 	offset DWGameBoard,offset indexArray		;// computer make move
		mov eax,1000 								; 1 second
		call Delay
		invoke checkwin,	Offset DWGameBoard,offset indexArray		;// check if anyone win
		cmp eax,3
		je tie							;// if eax is 3 it means game tied
		cmp eax,2
		jne comp1Play1CVC				;// if eax = 1 means player one win
		inc player2win					;// counting the winner	
		call clrscr						;// clearing screen before winner announcment	
		mov edx,offset P2win		;// announcing the winner
		call writestring
		invoke PrintBoard, offset DWGameBoard, boardSlength	;// printing the winner
		jmp gamefinish
comp2Play1CVC:
		call clrscr							;// screen is clear
		invoke PrintBoard, offset DWGameBoard, boardSlength
		mov edx,offset comp2Turn					;// displaying computer turn
		call writestring
		mov eax,1000 								; 1 second
		call Delay
		invoke reset2DefaultColor,offset GameBoard,offset DWGameBoard
		invoke cm_xMove, 	offset DWGameBoard,offset indexArray		;// computer make move
		mov eax,1000 								; 1 second
		call Delay
		invoke checkwin,	Offset DWGameBoard,offset indexArray		;// check if anyone win
		cmp eax,3
		je tie							;// if eax is 3 it means game tied
		cmp eax,1
		jne comp1Play2CVC				;// if eax = 1 means player one win
		inc player2win					;// counting the winner	
		call clrscr						;// clearing screen before winner announcment	
		mov edx,offset P2win		;// announcing the winner
		call writestring
		invoke PrintBoard, offset DWGameBoard, boardSlength	;// printing the winner
		jmp gamefinish
comp1Play2CVC:
		call clrscr							;// screen is clear
		invoke PrintBoard, offset DWGameBoard, boardSlength
		mov edx,offset comp1Turn					;// displaying computer turn
		call writestring
		mov eax,1000 								; 1 second
		call Delay
		invoke reset2DefaultColor,offset GameBoard,offset DWGameBoard
		invoke cm_oMove, 	offset DWGameBoard,offset indexArray		;// computer make move
		mov eax,1000 								; 1 second
		call Delay
		invoke checkwin,	Offset DWGameBoard,offset indexArray		;// check if anyone win
		cmp eax,3
		je tie							;// if eax is 3 it means game tied
		cmp eax,2
		jne comp2Play1CVC				;// if eax = 1 means player one win
		inc player1win					;// counting the winner	
		call clrscr						;// clearing screen before winner announcment	
		mov edx,offset P1win			;// announcing the winner
		call writestring
		invoke PrintBoard, offset DWGameBoard, boardSlength	;// printing the winner
		jmp gamefinish
tie:
	call clrscr						;// clearing screen before winner announcment	
	inc tiegame
	mov edx,offset Nowin		;// announcing the winner
	call writestring
	invoke PrintBoard, offset DWGameBoard, boardSlength	;// printing the winner
gamefinish:
	mov edx,offset gameoverMenu			;// display end of the game menu
	call writestring	
	call readdec			;// reading entry
	cmp eax,1
	je top				;// replay the game
	cmp eax,2
	je displayStat
	cmp eax,3			;// exit the game
	je exits
	mov edx,offset errorpromt		;// wrong entry error message
	call writestring
	jmp gamefinish
displayStat:
	mov edx, offset gamePlayHeader			;// header 
	call writestring
	mov eax,player1win					;// number
	add eax,player2win
	add eax,tiegame
	call writedec
	call crlf
	mov edx, offset player1Header			;// header 
	call writestring
	mov eax,player1win						;// number
	call writedec
	call crlf
	mov edx, offset player2Header			;// header 
	call writestring
	mov eax,player2win						;// number
	call writedec
	call crlf
	mov edx, offset tiedGameHead			;// header 
	call writestring
	mov eax,tiegame						;// number
	call writedec
	call crlf
	jmp gamefinish
exits:
	mov edx, offset gamePlayHeader			;// header 
	call writestring
	mov eax,player1win					;// number
	add eax,player2win
	add eax,tiegame
	call writedec
	call crlf
	mov edx, offset player1Header			;// header 
	call writestring
	mov eax,player1win						;// number
	call writedec
	call crlf
	mov edx, offset player2Header			;// header 
	call writestring
	mov eax,player2win						;// number
	call writedec
	call crlf
	mov edx, offset tiedGameHead			;// header 
	call writestring
	mov eax,tiegame						;// number
	call writedec
	call crlf
	call waitmsg				;// wait until key is pressed
	
EXIT
main ENDP
BtoDW PROC,source:dword,dest:dword
;//-----------------------------------------------------
;// BtoDW
;// fill the target dword string array from source byte string array
;// Receives:source and destination addrress
;// 
;//-----------------------------------------------------
.code
	mov edx,source							;// finding string lenth
	mov ebx,dest
	call strlength							;// procedure for strlength
	mov ecx, eax							;// ecx for loop through
	inc ecx									;// will copy deliminiter too
	mov esi,0								;// for index 
copyLoop:
	mov eax,0								;// clearing eax
	mov eax,7 +(0 *16)						;// clearing eax
	shl eax,8								;// shifting by a byte
	mov al,[edx][esi]						;// al has character of first array
	mov [ebx][type dword*esi],eax			;// copying to new array
	inc esi									;// loop index increment
	loop copyLoop							;// loop counter
	RET
BtoDW ENDP

PrintBoard PROC, DWString:dword, stringL:dword
;//-----------------------------------------------------
;// PrintBoard
;// print doubleword string array with color code hidden in ah
;// Receives:source addrress
;// 
;//-----------------------------------------------------
	.code
	mov ebx,DWString						;// addrress of string
	mov esi,0								;// index
	mov ecx,stringL
printLoop:
	mov eax,[ebx][type dword*esi]			;// copying first character
	ror eax,8								;// color setup because color code is strarting ah
	call settextcolor						;// procedure for textcolor
	rol eax,8								;// back to normal
	call writechar							;// calling printchar
	inc esi									;// loop increment
	loop printLoop							;// loop counter
	RET	
PrintBoard ENDP

changeColor PROC, DWString:dword, index:dword,colorcode:dword
;//-----------------------------------------------------
;// changeColor
;// change the color code hidden in double array string
;// as requested 
;//-----------------------------------------------------
	.code
	mov eax,DWString				;// addrress of array
	mov esi,index					;// index of char that need to be changed
	dec esi							;// strarting from space
	mov ecx,3						;// we also want to chage color around letter
colorLoop:
	mov ebx, colorcode				;// ebx has color code
	shl ebx,8						;// shift left to make room for character in bl
	mov bl,[eax][type dword*esi]	;// preserve character
	mov [eax][type dword*esi],ebx	;// copy back to string 
	inc esi							;// increment index
	loop colorLoop					;// loop counter
	RET		
changeColor ENDP

xMove PROC, DWString:dword,indexArray1:dword,entrypromt1:dword,errorpromt1:dword
;//-----------------------------------------------------
;// change the string accordingly with char
;// print doubleword string array with color code hidden in ah
;// Receives:source addrress,gridNo and indexArray
;//-----------------------------------------------------
	.code
	mov edx,entrypromt1							;// entrypromt addrress
	call writestring
backtoentry:									;// display
	call readdec								;// reading decimal
	cmp eax,0
	jbe wrongEntry								;// if entry is zero or below zero its error
	cmp eax,10
	jae	wrongEntry								;// if entry is 10 or above its error
	mov ecx,indexArray1
	movzx esi,byte ptr [ecx][eax-1]				;// esi will hold right index on DWString
	mov edx,DWString							;// dwstring addrress
	mov bl,'X'
	cmp [edx][type dword*esi],bl				;// comparing if entry is already occupied
	je wrongEntry								;// if it is, display error 
	mov bl,'O'
	cmp [edx][type dword*esi],bl				;// comparing if entry is already occupied
	je wrongEntry								;// if it is, display error
	mov bl,'X'
	mov [edx][type dword*esi],bl				;// if everthing good copy it
	invoke changeColor, DWString, esi,(blue +(white*16))	;// changing the color of char
	RET	
wrongEntry:
	mov edx,errorpromt1
	call writestring
	jmp backtoentry
xMove ENDP
oMove PROC, DWString:dword,indexArray1:dword,entrypromt1:dword,errorpromt1:dword
;//-----------------------------------------------------
;// change the string accordingly with char
;// print doubleword string array with color code hidden in ah
;// Receives:source addrress,gridNo and indexArray
;//-----------------------------------------------------
	.code
	mov edx,entrypromt1							;// entrypromt addrress
	call writestring
backtoentry:									;// display
	call readdec								;// reading decimal
	cmp eax,0
	jbe wrongEntry								;// if entry is zero or below zero its error
	cmp eax,10
	jae	wrongEntry								;// if entry is 10 or above its error
	mov ecx,indexArray1
	movzx esi,byte ptr [ecx][eax-1]				;// esi will hold right index on DWString
	mov edx,DWString							;// dwstring addrress
	mov bl,'X'
	cmp [edx][type dword*esi],bl				;// comparing if entry is already occupied
	je wrongEntry								;// if it is, display error 
	mov bl,'O'
	cmp [edx][type dword*esi],bl				;// comparing if entry is already occupied
	je wrongEntry								;// if it is, display error
	mov bl,'O'
	mov [edx][type dword*esi],bl				;// if everthing good copy it
	invoke changeColor, DWString, esi,(white +(blue*16))	;// changing the color of char
	RET	
wrongEntry:
	mov edx,errorpromt1
	call writestring
	jmp backtoentry
oMove ENDP

cm_oMove PROC, DWString:dword,indexArray1
;//-----------------------------------------------------
;// change the string accordingly with char by computer
;// also adjest the doubleword string array with color code hidden in second byte
;// Receives:source addrress,gridNo and indexArray
;//-----------------------------------------------------
	.code
	mov eax,5									;// going to center if available
	jmp norandom
random:
	call randomize								;// random seed
	mov eax,9									;// 0-8 range
	call randomrange							;// random number in eax
	inc eax										;// making it 1-9
norandom:
	mov ecx,indexArray1
	movzx esi,byte ptr [ecx][eax-1]				;// esi will hold right index on DWString
	mov edx,DWString							;// dwstring addrress
	mov bl,'X'
	cmp [edx][type dword*esi],bl				;// comparing if entry is already occupied
	je random
	mov bl,'O'
	cmp [edx][type dword*esi],bl				;// comparing if entry is already occupied
	je random
	mov bl,'O'
	mov [edx][type dword*esi],bl				;// if everthing good copy it
	invoke changeColor, DWString, esi,(white +(blue*16))	;// changing the color of char
	RET	
cm_oMove ENDP
cm_xMove PROC, DWString:dword,indexArray1
;//-----------------------------------------------------
;// change the string accordingly with char by computer
;// also adjest the doubleword string array with color code hidden in second byte
;// Receives:source addrress,gridNo and indexArray
;//-----------------------------------------------------
	.code
	mov eax,5									;// going to center if available
	jmp norandom
random:
	call randomize								;// random seed
	mov eax,9									;// 0-8 range
	call randomrange							;// random number in eax
	inc eax										;// making it 1-9
norandom:
	mov ecx,indexArray1
	movzx esi,byte ptr [ecx][eax-1]				;// esi will hold right index on DWString
	mov edx,DWString							;// dwstring addrress
	mov bl,'X'
	cmp [edx][type dword*esi],bl				;// comparing if entry is already occupied
	je random
	mov bl,'O'
	cmp [edx][type dword*esi],bl				;// comparing if entry is already occupied
	je random
	mov bl,'X'
	mov [edx][type dword*esi],bl				;// if everthing good copy it
	invoke changeColor, DWString, esi,(blue +(white*16))	;// changing the color of char
	RET	
cm_xMove ENDP

reset2DefaultColor PROC,source:dword,dest:dword
;//-----------------------------------------------------
;// clear all color scheme in double word string
;// receive dword string and byte string
;// 
;//-----------------------------------------------------
.code
	mov edx,source							;// finding string lenth
	call strlength							;// procedure for strlength
	mov ecx, eax							;// ecx for loop through
	mov edx,dest							;// address of dword string
	inc ecx									;// will copy deliminiter too
	mov esi,0								;// for index 
copyLoop:
	mov eax,0								;// clearing eax
	mov eax,7 +(0 *16)						;// setting the default color
	shl eax,8								;// shifting by a byte
	mov al,[edx][type dword*esi]			;// al has character of first array
	mov [edx][type dword*esi],eax			;// copying to new array
	inc esi									;// loop index increment
	loop copyLoop							;// loop counter
	RET
reset2Defaultcolor ENDP

checkwin PROC,DWString:dword,indexArray1:dword
LOCAL totalmove:dword
;//-------------------------------------------------------------------------
;// check if there is winner yet
;// receive dword string and indexArray
;// return eax =1 if x win, =2 if o win, =3 if tie, 4 if game not complete
;//-------------------------------------------------------------------------
.code
	mov ebx,DWString					;// string of double word
	mov edx,indexArray1					;// index storing string
	mov ecx,0							
	mov totalmove,ecx					;// totalmove clear
	mov ecx,9							;// you count 9 char
movecount:
	movzx esi,byte ptr [edx][ecx-1]				;//finding actual index in dword array
	movzx eax,byte ptr [ebx][type dword*esi]	;// moving that char to eax
	cmp eax,'X'									;// if it is x or o 
	je incMovCount
	cmp eax,'O'					
	je incMovCount								;// go to increment total move
backtomovecount:								;// back to loop after increment if any
	loop movecount								;// loop counter
	mov eax, totalmove
	cmp eax,5									;// if below 5 no need to check the winner
	jb toearly
	
wincheck1:
	;// checking for 1,2,3
	movzx edi,byte ptr [edx][0]					;//find the index for dword string
	mov al, byte ptr[ebx][type dword*edi]		;// move that to al
	movzx edi,byte ptr [edx][1]
	mov ah, byte ptr[ebx][type dword*edi]		;// to ah
	movzx edi,byte ptr [edx][2]
	mov cl, byte ptr[ebx][type dword*edi]		;// to cl
	cmp al,ah									;// are they equal?
	jne wincheck2								;// if not check another combination
	cmp ah,cl									;// are 2nd and 3rd equal
	jne wincheck2								;// if not check another combination
	cmp al,'-'
	je wincheck2
	push eax 
	push ecx
	;// setting up the color on dword string if winner
	movzx edi, byte ptr[edx][0]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][1]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][2]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	pop ecx 
	pop eax
	jmp onewin
wincheck2:
	;// checking for 4,5,6
	movzx edi,byte ptr [edx][3]					;//find the index for dword string
	mov al, byte ptr[ebx][type dword*edi]		;// move that to al
	movzx edi,byte ptr [edx][4]
	mov ah, byte ptr[ebx][type dword*edi]		;// to ah
	movzx edi,byte ptr [edx][5]
	mov cl, byte ptr[ebx][type dword*edi]		;// to cl
	cmp al,ah									;// are they equal?
	jne wincheck3								;// if not check another combination
	cmp ah,cl									;// are 2nd and 3rd equal
	jne wincheck3
	cmp al,'-'
	je wincheck3
	push eax 
	push ecx
	;// if not check another combination
	;// setting up the color on dword string if winner
	movzx edi, byte ptr[edx][3]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][4]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][5]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	pop ecx 
	pop eax
	jmp onewin
	;// checking for 7,8,9
wincheck3:	
	movzx edi,byte ptr [edx][6]					;//find the index for dword string
	mov al, byte ptr[ebx][type dword*edi]		;// move that to al
	movzx edi,byte ptr [edx][7]
	mov ah, byte ptr[ebx][type dword*edi]		;// to ah
	movzx edi,byte ptr [edx][8]
	mov cl, byte ptr[ebx][type dword*edi]		;// to cl
	cmp al,ah									;// are they equal?
	jne wincheck4								;// if not check another combination
	cmp ah,cl									;// are 2nd and 3rd equal
	jne wincheck4								;// if not check another combination
	cmp al,'-'
	je wincheck4
	push eax 
	push ecx
	;// setting up the color on dword string if winner
	movzx edi, byte ptr[edx][6]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][7]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][8]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	pop ecx 
	pop eax
	jmp onewin
	;// checking for 1,4,7
wincheck4:
	movzx edi,byte ptr [edx][0]					;//find the index for dword string
	mov al, byte ptr[ebx][type dword*edi]		;// move that to al
	movzx edi,byte ptr [edx][3]
	mov ah, byte ptr[ebx][type dword*edi]		;// to ah
	movzx edi,byte ptr [edx][6]
	mov cl, byte ptr[ebx][type dword*edi]		;// to cl
	cmp al,ah									;// are they equal?
	jne wincheck5								;// if not check another combination
	cmp ah,cl									;// are 2nd and 3rd equal
	jne wincheck5								;// if not check another combination
	cmp al,'-'
	je wincheck5
	push eax 
	push ecx
	;// setting up the color on dword string if winner
	movzx edi, byte ptr[edx][0]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][3]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][6]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	pop ecx 
	pop eax
	jmp onewin
	;// checking for 2,5,8
wincheck5:
	movzx edi,byte ptr [edx][1]					;//find the index for dword string
	mov al, byte ptr[ebx][type dword*edi]		;// move that to al
	movzx edi,byte ptr [edx][4]
	mov ah, byte ptr[ebx][type dword*edi]		;// to ah
	movzx edi,byte ptr [edx][7]
	mov cl, byte ptr[ebx][type dword*edi]		;// to cl
	cmp al,ah									;// are they equal?
	jne wincheck6								;// if not check another combination
	cmp ah,cl									;// are 2nd and 3rd equal
	jne wincheck6								;// if not check another combination
	cmp al,'-'
	je wincheck6
	push eax 
	push ecx
	;// setting up the color on dword string if winner
	movzx edi, byte ptr[edx][1]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][4]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][7]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	pop ecx 
	pop eax
	jmp onewin
	;// checking for 3,6,9
wincheck6:
	movzx edi,byte ptr [edx][2]					;//find the index for dword string
	mov al, byte ptr[ebx][type dword*edi]		;// move that to al
	movzx edi,byte ptr [edx][5]
	mov ah, byte ptr[ebx][type dword*edi]		;// to ah
	movzx edi,byte ptr [edx][8]
	mov cl, byte ptr[ebx][type dword*edi]		;// to cl
	cmp al,ah									;// are they equal?
	jne wincheck7								;// if not check another combination
	cmp ah,cl									;// are 2nd and 3rd equal
	jne wincheck7								;// if not check another combination
	cmp al,'-'
	je wincheck7
	push eax 
	push ecx
	;// setting up the color on dword string if winner
	movzx edi, byte ptr[edx][2]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][5]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][8]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	pop ecx 
	pop eax
	jmp onewin
	;// checking for 1,5,9
wincheck7:
	movzx edi,byte ptr [edx][0]					;//find the index for dword string
	mov al, byte ptr[ebx][type dword*edi]		;// move that to al
	movzx edi,byte ptr [edx][4]
	mov ah, byte ptr[ebx][type dword*edi]		;// to ah
	movzx edi,byte ptr [edx][8]
	mov cl, byte ptr[ebx][type dword*edi]		;// to cl
	cmp al,ah									;// are they equal?
	jne wincheck8								;// if not check another combination
	cmp ah,cl									;// are 2nd and 3rd equal
	jne wincheck8								;// if not check another combination
	cmp al,'-'
	je wincheck8
	push eax 
	push ecx
	;// setting up the color on dword string if winner
	movzx edi, byte ptr[edx][0]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][4]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][8]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	pop ecx 
	pop eax
	jmp onewin
	;// checking for 3,5,7
wincheck8:
	movzx edi,byte ptr [edx][2]					;//find the index for dword string
	mov al, byte ptr[ebx][type dword*edi]		;// move that to al
	movzx edi,byte ptr [edx][4]
	mov ah, byte ptr[ebx][type dword*edi]		;// to ah
	movzx edi,byte ptr [edx][6]
	mov cl, byte ptr[ebx][type dword*edi]		;// to cl
	cmp al,ah									;// are they equal?
	jne nooneiswinner								;// if not check another combination
	cmp ah,cl									;// are 2nd and 3rd equal
	jne nooneiswinner							;// if not check another combination
	cmp al,'-'
	je nooneiswinner
	push eax 
	push ecx
	;// setting up the color on dword string if winner
	movzx edi, byte ptr[edx][2]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][4]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	movzx edi, byte ptr[edx][6]
	invoke changeColor, DWString, edi, (black + (yellow * 16))
	pop ecx 
	pop eax
	jmp onewin
nooneiswinner:
	mov eax,totalmove							;// check if grid is full
	cmp eax,9									;// comparing
	jb toearly									;// if count is less than 9 its toearly
	mov eax,3									;// else its a tie without winner
	jmp done
toearly:
	mov eax,4									;// 4 is incomplete game
	jmp done									;// repeat
onewin:
	cmp al,'X'									;// if x winner
	je xwin										;// return 1
	cmp al,'O'
	jne nooneiswinner
	mov eax,2									;// else return 2
done:
	RET
incMovCount:
	inc totalmove
	jmp backtomovecount
xwin:
	mov eax,1
	jmp done
checkwin ENDP
END main