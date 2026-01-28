Program Puyo ;

Uses CRT, DOS, Joshmohn ;

Const Horiz = True ;        LeftKey   = 1 ;       	NoAction 				= 0 ;
			Vert = False ;        RightKey  = 2 ;         DroppingBlob  	= 1 ;
      Space = 0 ;           RotateKey = 3 ;         CheckingForPuyo = 2 ;
      Rock = 5 ;            DropKey   = 4 ;         KillingPuyo			= 3 ;
      MaxColumns = 20 ;															DroppingColumn  = 4 ;
      TickTime = 1 ;																Quit						= 9 ;

			KeyDefaults:Array[ 1..4 ] of Char = ( '4', '6', '5', '0' ) ;

Type 	Color = Byte ;

		 	Blob = Record
      	Status:Boolean ;
		  	Orientation:Boolean ;
      	Col:Array[ 1..2 ] of Color ;
      	x, y:Array[ 1..2 ] of Byte ;
			end ;

			Game = Record
      	Board:Array[ 1..6, 1..MaxColumns ] of Color ;
        Current:Blob ;
        Next:Blob ;
      	Keys:Array[ 1..4 ] of Char ;
        Event:Byte ;
      end ;

Var Player:Array[ 1..2 ] of Game ;
		CurrentTick, CurrentTime:Word ;
    LastRandom, CurrentPlayer, NumOfPlayers:Byte ;


Function RandomQuad:Byte ; {Spits out 1..4}
Var Amanda, Final:Byte ;
Begin
	Randomize ;
  Amanda := Random( 200 ) + 1 ;
  Case Amanda of
  	 1..25,  101..125:Final := 1 ;
    26..50,  126..150:Final := 2 ;
    51..75,  151..175:Final := 3 ;
    76..100, 176..200:Final := 4 ;
  end ;
  If Final = LastRandom then Inc( Final ) ;
  If Final > 4 then Final := 1 ;
  LastRandom := Final ;
  RandomQuad := Final ;
end ;

Procedure NewBlob( var Who:Game ) ;
Var Amanda, Spam:Byte ;
Begin
  With Who do
  	Begin
		  Current := Next ;
  		Current.Status := True ;
    end ;
  With Who.Next do
  	Begin
      Status := False ;
      Col[ 1 ] := RandomQuad ;
      Orientation := Horiz ;
      y[ 1 ] := MaxColumns ;
      y[ 2 ] := MaxColumns ;
      x[ 1 ] := 3 ;
      x[ 2 ] := 4 ;
      Col[ 2 ] := RandomQuad ;
    end ;
end ; {NewBlob PROC}

Procedure InitPlayer( var Who:Game ) ;
Var i, j:Byte ;
Begin
	With Who do
  	Begin
      For i:=1 to 6 do
      	For j:=1 to MaxColumns do
        	Board[ i, j ] := Space ;
      For i := 1 to 4 do
				Keys[ i ] := KeyDefaults[ i ] ;
      Event := NoAction ;
      NewBlob( Who ) ;
      NewBlob( Who ) ;  {Do twice, once for current, once for next}
    end ;
end ;


Procedure Rotate( var Piece:Blob ) ;

Var t:Color ;
		Change:ShortInt ;

Begin
  With Piece do
    Begin
			If Orientation = Vert then
	    	Begin
	      	t := Col[ 1 ] ;
	        Col[ 1 ] := Col[ 2 ] ;
	        Col[ 2 ] := t ;
	      end ;
			If Orientation = Horiz then Change := ( -1 )
      else Change := 1 ;		           { Toggle Between:             *     }
      x[2] := x[2] + Change ;          {                  * *  and   *     }
      y[2] := y[2] - Change ;
	  	Orientation := Not Orientation ;
    end ;
end ; {Rotate PROC}


Function ColumnHeight( Which:Game ; c:Byte ):Byte ;
Var h:Byte ;
Begin
	h:=1 ;
 	While ( h<=20 ) and ( Which.Board[ c, h ] <> Space ) do Inc( h ) ;
  Dec( h ) ;
  ColumnHeight := h ;
end ;


Function TouchDown:Boolean ;

Var Touch:Boolean ;
		i:Byte ;

Begin
	Touch := False ;
  For i := 1 to 2 do
    With Player[ CurrentPlayer ].Current do
	  	If y[ i ] <= ColumnHeight( Player[ CurrentPlayer ], x[ i ] ) +1 then
	    	Touch := True ;
	TouchDown := Touch ;
end ;


Procedure DropBlob( var Who:Game ) ;
Var i:Byte ;
Begin
	With Who do
		For i:=1 to 2 do
     	If Current.y[i]>ColumnHeight(Player[CurrentPlayer],Current.x[i])+1 then
       	Dec( Current.y[ i ] )
      else
        Board[ Current.x[ i ], Current.y[ i ] ] := Current.Col[ i ] ;
end ;


Procedure HandleTouchDown ;
Var Done, i:Byte ;
Begin
	DropBlob( Player[ CurrentPlayer ] ) ;
	Done := 0 ;
  For i := 1 to 2 do
  	If Player[CurrentPlayer].Current.y[i] <=
    	ColumnHeight( Player[CurrentPlayer],
				Player[CurrentPlayer].Current.x[i] ) then Inc( Done ) ;
	If Done = 2 then
		Begin
    	Player[ CurrentPlayer ].Current.Status := False ;
			Player[ CurrentPlayer ].Event := CheckingForPuyo ;
		end ;
end ; {HandleTouchDown PROC}


Procedure HandleKeyboard ;
Var Key:Char ;
		q, i:Byte ;
Begin
	Key := Readkey ;
  If Key = #0 then Key := Readkey ;
  q := 1 ;
	While ( q<5 ) and ( Player[ CurrentPlayer ].Keys[ q ] <> Key ) do Inc( q ) ;
  If q<5 then
    With Player[ CurrentPlayer ] do
    	Begin
				Case q of
  	  		LeftKey:   For i:=1 to 2 do Dec( Current.x[ i ] ) ;
    	   	RightKey:  For i:=1 to 2 do Inc( Current.x[ i ] ) ;
      		DropKey:   Event := DroppingBlob ;
	      	RotateKey: Rotate( Current ) ;
  	  	end ;
  		end
  else
  	If Key = #27 then Player[ CurrentPlayer ].Event := Quit ;
end ; {HandleKeyboard PROC}

Procedure ErasePuyo ;
Var i:Byte ;
Begin
	For i := 1 to 2 do
		With Player[ CurrentPlayer ].Current do
			WriteChar_A(19+x[i],23-y[i], ' ', Black ) ;
end ;

Procedure WritePuyo ;
Var i:Byte ;
Begin
	For i := 1 to 2 do
  	With Player[ CurrentPlayer ].Current do
			WriteChar_A(19+x[i],23-y[i], '*', Col[i] ) ;
end ;


Procedure Engine ; {Does One Cycle}

Var Time, Tick, Blah:Word ;
    i:Byte ;

Begin
	GetTime( Blah, Blah, Time, Tick ) ;
  If Tick < CurrentTick then Inc( Tick, 100 ) ;
  If Tick > CurrentTick + TickTime then
    Begin
      If Tick > 99 then Dec( Tick, 100 ) ;
    	CurrentTick := Tick ;
			Case Player[ CurrentPlayer ].Event of
		    KillingPuyo:
		    	Begin
		      	Player[ CurrentPlayer ].Event := NoAction ;
		        NewBlob( Player[ CurrentPlayer ] ) ;
		      end ;
		    CheckingForPuyo:
		    	Begin
		      	Player[ CurrentPlayer ].Event := KillingPuyo ;
		      end ; {End CheckingForPuyo Event}
		  	DroppingBlob:
		    	Begin
		      	ErasePuyo ;
		        HandleTouchDown ;
		        WritePuyo ;
		      end ; {End DroppingBlob Event}
		    NoAction:
		    	Begin
					  If Time <> CurrentTime then
		          Begin
		          	ErasePuyo ;
						   	With Player[ CurrentPlayer ].Current do
						    	Begin
						      	CurrentTime := Time ;
						        For i := 1 to 2 do Dec( y[ i ] ) ;
			  			    end ;
		            WritePuyo ;
		        	end ;
		  			If Keypressed then
							Begin
		          	ErasePuyo ;
								HandleKeyboard ;
		            WritePuyo ;
		          end ;
		  			If TouchDown then Player[ CurrentPlayer ].Event := DroppingBlob ;
		      end ; {End NoAction Event}
		  end ; {End Case}
    end ;
end ; {Engine PROC}

Begin
	ClrScr ;
	InitWins ; {Text}
  WinUp( 19, 2, 26, 23 ) ;
  CurrentTick := 1 ;
	NumOfPlayers := 1 ;
  CurrentPlayer := 1 ;
  InitPlayer( Player[ 1 ] ) ;
  InitPlayer( Player[ 2 ] ) ;
  Repeat
  	Engine ;
    Inc( CurrentPlayer ) ;
    If CurrentPlayer > NumOfPlayers then
    	CurrentPlayer := 1 ;
  Until Player[ CurrentPlayer ].Event = Quit ;
end.


{Create Preventive Checks BEFORE allowing you to move piece}

{When Checking Puyo, make a recursive function that follows a puyo trail.
 Ya know, it like incs by one every time it finds one more, and does same
 for accompanying pieces. Make some way so that it doesn't count pieces more
 than once!}

{Create Column-Dropping Procedure. Basic. Remember tho, to do it just once at
 a time and maintain the multitasking event based interface!}



