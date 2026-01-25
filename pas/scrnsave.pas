Unit ScrnSave ;

Interface

Uses CRT, DOS, Zakmohn ;

Type Direction = Byte ;

Const
	AfterDarkTime = 4 ;			Up		= 23 {Michael Jordan} ;
     {Time in Minutes}    Down	= 33 {Scottie Pippen} ;  {Used for Direction}
                          Left	= 97 {A Great Number} ;
                          Right = 17 {A Great Age 2B} ;

{What Enables Screen Saver Activation after 'AfterDarkTime' Minutes:}
Function WaitForKeypress:Char ;

{AfterDark Modules}
Function PhaseOut:Char ;
Function Fade:Char ;
Function Pieces:Char ;
Function OpenAndClose:Char ;
Function ScreenShift( Ver:Byte ):Char ;
Function Boxes:Char ;

{Procedures used by Modules:}
Procedure ColorBox( l, u, r, d, GermsAreBadForYou {Color}:Byte ) ;
Procedure MovePiece( v:Byte ) ; {Moves a Window w/o Replacing Mask}
Procedure CaptureScreen ; {Just Captures 1..80,1..25 into next Win Spot}


Implementation

Procedure CaptureScreen ; {Captures to next win}
                          {Reinstate Screen with WinDown call.}
Var r, u:Byte ;

Begin
  With Scrn[ CurrentWin + 1 ] do {Capture Screen (The Hacker's Way)}
   	Begin
    	Status := True ;
      Top:=1 ; Bottom:=25 ; Right:=80 ; Left:=1 ;
			For r:=1 to 80 do
				For u:=1 to 25 do
					Begin
          	CharMask[ r, u ] := GetChar( r, u ) ;
            AttribMask[ r, u ] := GetChar_a( r, u ) ;
          end ;
    end ;
end ; {CaptureScreen PROC}

Function PhaseOut : Char ;

Const D = 7 ;

Var TimeToGo:Boolean ;
		Juicy:Char ;
    I:Integer ;
    a, b:Byte ;

Begin
  CaptureScreen ;
  TimeToGo := False ;
  Repeat
		I:=0 ;
    Repeat
      Inc( I ) ;
      If Keypressed then
      	Begin
        	TimeToGo := True ;
          Juicy := Readkey ;
          If Juicy = #0 then Juicy := Readkey ;
        end ;
	    If Not TimeToGo then
				For b:=1 to 25 do
      		For a:=1 to 80 do
        		If GetChar( a, b ) = Chr( i ) then
          		WriteChar_A( a, b, ' ', White ) ;
      If ( Not TimeToGo ) and ( I <= 225 ) and ( I >= 65 ) then Delay( D ) ;
    Until I > 255 ;
    I:=0 ;
    If Not TimeToGo then
			Repeat
	      Inc( I ) ;
	      If Keypressed then
	      	Begin
	        	TimeToGo := True ;
	          Juicy := Readkey ;
	          If Juicy = #0 then Juicy := Readkey ;
	        end ;
		    If Not TimeToGo then
					For b:=1 to 25 do
	      		For a:=1 to 80 do
	        		With Scrn[ CurrentWin ] do
								If CharMask[ a, b ] = Chr( i ) then
	          			WriteChar_A( a, b, CharMask[a,b], AttribMask[a,b] ) ;
	      If ( Not TimeToGo ) and ( I <= 225 ) and ( I >= 65 ) then Delay( D ) ;
	    Until I > 255 ;
  Until TimeToGo ;
  WinDown ;
  PhaseOut := Juicy ;
end ; {PhaseOut Function}

{
Function Yank:Char ;

Var C, x, y, Force:Byte ;
    TimeToGo, SchoolsOut:Boolean ;
    Moose:Char ;

begin
 	CaptureScreen ;
	C := CurrentWin ;
  TimeToGo := False ;
  For x:=1 to 25 do HiLite( 1, x, Black, 80 ) ;
 	X:=Random( 100 ) ;
  Case x of
   	1..25:
			Force:=Up ;
    26..50:
			Force:=Down ;
    51..75:
			Force:=Left ;
   	else
			Force := Right ;
  end ;
  Repeat
 		Repeat
    	X:=Random( 80 ) + 1 ;
      Y:=Random( 25 ) + 1 ;
      If x>80 then x:=80
      else If x<1 then x:=1 ;
      If y>25 then y:=25
      else If y<1 then y:=1 ;
      If KeyPressed then
      	Begin
        	TimeToGo:=true ;
          Moose := Readkey ;
          If Moose = #0 then Moose := Readkey ;
        end ;
    Until ( GetChar( x, y ) <> ' ' ) or TimeToGo ;
		Case Force of
			Right:
      	Begin
    	  	If x < 80 then
						WriteChar_A( x+1, y, GetChar( x, y ), GetChar_A( x, y ) ) ;
	        WriteChar_A( x, y, ' ', White ) ;
      	end ;
			Left:
      	Begin
    	  	If x > 1 then
						WriteChar_A( x-1, y, GetChar( x, y ), GetChar_A( x, y ) ) ;
	        WriteChar_A( x, y, ' ', White ) ;
      	end ;
			Up:
      	Begin
    	  	If Y > 1 then
						WriteChar_A( x, y-1, GetChar( x, y ), GetChar_A( x, y ) ) ;
	        WriteChar_A( x, y, ' ', White ) ;
      	end ;
			Down:
      	Begin
    	  	If y < 25 then
						WriteChar_A( x, y+1, GetChar( x, y ), GetChar_A( x, y ) ) ;
	        WriteChar_A( x, y, ' ', White ) ;
      	end ;
    end ;
  Until TimeToGo ;
  WinDown ;
  Yank := Moose ;
end ; } {Yank Function}

Function Fade:Char ;

Const On  = True  ;
      Off = False ;
      EraseSpeed = 6 ;

Var ScreenCon:Array[ 1..80, 1..25 ] of Boolean ;
    a, b, x, y:Byte ;
    SchoolsOut, TimeToGo:Boolean ;
    Moof:Char ;

Begin
  CaptureScreen ;
  Randomize ;
  TimeToGo := False ;
  Repeat
	  For x:=1 to 80 do
	  	For Y:=1 to 25 do
	    	ScreenCon[ x, y ] := on ;
		Repeat
    	SchoolsOut := False ;
  		Repeat
	    	X:=Random( 80 ) + 1 ;
	      Y:=Random( 25 ) + 1 ;
        If x>80 then x:=80
        else If x<1 then x:=1 ;
        If y>25 then y:=25
        else If y<1 then y:=1 ;
	      If KeyPressed then
	      	Begin
	        	TimeToGo:=true ;
	          Moof := Readkey ;
	          If Moof = #0 then Moof := Readkey ;
	        end ;
	    Until ( ScreenCon[ x, y ] = On ) or TimeToGo ;
      WriteChar_A( x, y, ' ', Red*16 + White ) ;
      Delay( EraseSpeed ) ;
	    WriteChar_A( x, y, ' ', Black*16 + White ) ;
	    ScreenCon[ x, y ] := Off ;
      If Not TimeToGo then
	     	Begin
         	SchoolsOut := True ;
	       	For a:=1 to 80 do
	         	For b:=1 to 25 do
             	If ScreenCon[ a, b ] = On then SchoolsOut := False ;
     		end ;
		Until SchoolsOut or TimeToGo ;
    If Not TimeToGo then
			Repeat
	    	SchoolsOut := False ;
	  		Repeat
		    	X:=Random( 80 ) + 1 ;
		      Y:=Random( 25 ) + 1 ;
	        If x>80 then x:=80
	        else If x<1 then x:=1 ;
	        If y>25 then y:=25
	        else If y<1 then y:=1 ;
		      If KeyPressed then
		      	Begin
		        	TimeToGo:=true ;
		          Moof := Readkey ;
		          If Moof = #0 then Moof := Readkey ;
		        end ;
		    Until ( ScreenCon[ x, y ] = Off ) or TimeToGo ;
        WriteChar_A( x, y, ' ', Blue*16 + White ) ;
        Delay( EraseSpeed Div 2 ) ;
        With Scrn[ CurrentWin ] do
			    WriteChar_A( x, y, CharMask[ x, y ], AttribMask[ x, y ] ) ;
		    ScreenCon[ x, y ] := On ;
	      If Not TimeToGo then
		     	Begin
	         	SchoolsOut := True ;
		       	For a:=1 to 80 do
		         	For b:=1 to 25 do
	             	If ScreenCon[ a, b ] = Off then SchoolsOut := False ;
	     		end ;
			Until SchoolsOut or TimeToGo ;
  Until TimeToGo ;
  WinDown ;
  Fade := Moof ;
end ; {Fade Function}

Procedure MovePiece( v:Direction {Byte} ) ;

Const BackColor = Blue ;

Var i, movem:Byte ;

Begin
  With Scrn[ Currentwin ] do
		Case v of
  		97:
				Begin
          For Movem:=Left to Right do
          	For I:=Top to Bottom do
            	WriteChar_A( Movem-1, i, GetChar( Movem, i ), GetChar_A( Movem, i ) ) ;
					For I:=Top to Bottom do WriteChar_A( Right, I, ' ', BackColor*16+White ) ;
          Dec( Left ) ; Dec( Right ) ;
      	end ;
			17:
				Begin
          For Movem:=Right downto Left do
          	For I:=Top to Bottom do
            	WriteChar_A( Movem+1, i, GetChar( Movem, i ), GetChar_A( Movem, i ) ) ;
					For I:=Top to Bottom do WriteChar_A( Left, I, ' ', BackColor*16+White ) ;
          Inc( Left ) ; Inc( Right ) ;
      	end ;
      23:
				Begin
      		For Movem:=Top to Bottom do
          	For I:=Left to Right do
            	WriteChar_A( i, Movem-1, GetChar( i, Movem ), GetChar_A( i, Movem ) ) ;
					For I:=Left to Right do WriteChar_A( i, Bottom, ' ', BackColor*16+White ) ;
          Dec( Top ) ; Dec( Bottom ) ;
      	end ;
      33:
				Begin
      		For Movem:=Bottom downto top do
          	For I:=Left to Right do
            	WriteChar_A( i, Movem+1, GetChar( i, Movem ), GetChar_A( i, Movem ) ) ;
					For I:=Left to Right do WriteChar_A( i, Top, ' ', BackColor*16+White ) ;
          Inc( Top ) ; Inc( Bottom ) ;
      	end ;
    end ;
end ;

Function Pieces:Char ;

Const Vert=True ; Horiz=False ; PieceSpeed = 20 ; {High Nums are slower}
      BackColor  = blue ;       MoveMax = 40 ;

Var TimeToGo, d:Boolean ;
		Cow:Char ;
    Last, i, j, Joey, b, MoveNum:Byte ;
    PieceMap:Array[ 1..MoveMax ] of Direction ;

Begin
	Randomize ;
  CaptureScreen ;
  TimeToGo := False ;
  Joey := 16 ;
  MoveNum := 0 ;
  Last := Joey ;
  For I:=1 to 80 do WriteChar_A( i, 25, ' ', Black*16 + White ) ;
  For I:=61 to 80 do
  	For j:=19 to 24 do WriteChar_A( i, j, ' ', BackColor*16+White ) ;
  ChillOut( 130 ) ;
  Repeat
    Repeat
	  	I := Random( 99 ) + 1 ;
	  	Case Joey of
      	6, 7, 10, 11:
        	Case I of
          	 1..25 : B:=Joey-4 ;
            26..50 : B:=Joey+4 ;
            51..75 : B:=Joey-1 ;
            76..100: B:=Joey+1 ;
          end ;
        14, 15:
        	Case I of
          	 1..33 : B:=Joey-1 ;
          	34..67 : B:=Joey+1 ;
						68..100: B:=Joey-4 ;
        	end ;
        2, 3:
        	Case I of
          	 1..33 : B:=Joey-1 ;
          	34..67 : B:=Joey+1 ;
						68..100: B:=Joey+4 ;
        	end ;
        5, 9:
        	Case I of
          	 1..33 : B:=Joey+4 ;
          	34..67 : B:=Joey+1 ;
						68..100: B:=Joey-4 ;
        	end ;
        8, 12:
        	Case I of
          	 1..33 : B:=Joey-1 ;
          	34..67 : B:=Joey+4 ;
						68..100: B:=Joey-4 ;
        	end ;
        1:If I > 50 then B:=Joey + 1
        	else B:=Joey + 4 ;
        4:If I > 50 then B:=Joey - 1
        	else B:=Joey + 4 ;
        13:If I > 50 then B:=Joey + 1
        	else B:=Joey - 4 ;
        16:If I > 50 then B:=Joey - 1
        	else B:=Joey - 4 ;
	    end ;
	    If Keypressed then
	     	Begin
	        TimeToGo:=True ;
	        Cow:=Readkey ;
	        If Cow = #0 then Cow:=Readkey ;
	      end ;
    Until ( Last <> B ) or TimeToGo ;
    Last := Joey ;
    With Scrn[ CurrentWin + 1 ] do
    	Begin
				Case ( b Mod 4 ) of
		    	1:Begin
		        	Left := 1  ;
		          Right:= 20 ;
		       	end;
		      2:Begin
		      		Left := 21 ;
		          Right:= 40 ;
		      	end;
		      3:Begin
		      		Left := 41 ;
		          Right:= 60 ;
		      	end ;
		      0:Begin
		      		Left :=61 ;
		          Right:=80 ;
		      	end ;
		    end ; {Case}
		  	Case b of
		    	1..4:
		      	Begin
		        	Top:=1 ;
		          Bottom:=6 ;
		        end ;
		      5..8:
		      	Begin
		        	Top:=7 ;
		          Bottom:=12 ;
		        end ;
		      9..12:
		      	Begin
		        	Top:=13 ;
		          Bottom:=18 ;
		        end ;
		      13..16:
		      	Begin
		        	Top:=19 ;
		          Bottom:=24 ;
		        end ;
		    end ; {Case}
    	end ;
    If ( Joey Mod 4 ) = ( b Mod 4 ) then d := vert
    else d := Horiz ;
	  With Scrn[ CurrentWin + 1 ] do {Capture Piece (The Hacker's Way)}
	   	Begin
	    	Status := True ;
				For i:=Left to Right do
					For j:=Top to Bottom do
						Begin
	          	CharMask[ i, j ] := GetChar( i, j ) ;
	            AttribMask[ i, j ] := GetChar_a( i, j ) ;
	          end ;
	    end ;
		If ( D = Horiz ) then
    	If b > Joey then i:=Left
      else i:=Right
    else {If D=Vert...}
    	If b = Joey+4 then i:=Up
      else i:=Down ;
    j:=0 ;
    Repeat
    	Inc( j ) ;
      MovePiece( i ) ;
      If Keypressed then
      	Begin
          TimeToGo:=True ;
          Cow:=Readkey ;
          If Cow = #0 then Cow:=Readkey ;
        end ;
			If Not Timetogo then
				Begin
					Delay( PieceSpeed ) ;
          If d=Vert then Delay( ( 3*PieceSpeed ) Div 2 ); {Addtnl 3/2 Spd}
        end ;
    Until ( (D=Horiz) and (j=20) ) or ( (D=Vert) and (j=6) ) or TimeToGo ;

{		Sound( 1000 ) ;	 }
{		Delay( 2 ) ;    	}
{		NoSound ;          }
{		ChillOut( 40 ) ;    }

		Joey := b ;
    Scrn[ CurrentWin ].Status := False ;
  Until TimeToGo ;
  WinDown ;
  Pieces := Cow ;
end ; {Pieces Function}


Function OpenAndClose:Char ;

Var TimeToGo:Boolean ;
		PushinButtons:Char ;
    T, BlackOut, w, y, i:Byte ;

Begin
  Randomize ;
  TimeToGo := False ;
  CaptureScreen ;
  Repeat
  	BlackOut:=Random( 700 ) ;
  	T:=Random( 12 ) ;
    w:=CurrentWin ;
    i:=1 ;
    While I <= 40 do {For I:=1 to 40 do}
			Begin
	      For Y:=1 to 25 do
					Begin
						WriteChar_a( i, y, ' ', Black*16+White ) ;
	          WriteChar_a( 81-i, y, ' ', Black*16+White ) ;
	        end ;
        If KeyPressed then
        	Begin
          	TimeToGo := True ;
            PushinButtons := Readkey ;
            If PushinButtons = #0 then PushinButtons := Readkey ;
            I:=100 ; {Leave Loop}
          end ;
        If Not TimeToGo then ChillOut( t ) ;
        Inc( I ) ;
      end ;
		If Not TimeToGo then ChillOut( BlackOut ) ;
    I:=40 ;
    While ( I >= 1 ) and ( Not TimeToGo ) do {For I:=40 downto 1 do}
			Begin
	      For Y:=1 to 25 do
        	With Scrn[ W ] do
						Begin
							WriteChar_a( i, y, CharMask[ i, y ], AttribMask[ i, y ] ) ;
		          WriteChar_a( 81-i, y, CharMask[81-i,y], AttribMask[81-i,y] ) ;
		        end ;
        If KeyPressed then
        	Begin
          	TimeToGo := True ;
            PushinButtons := Readkey ;
            If PushinButtons = #0 then PushinButtons := Readkey ;
            I := 1 ; {Leave Loop}
          end ;
        If Not TimeToGo then ChillOut( t ) ;
        Dec( I ) ;
      end ;
  Until TimeToGo ;
  WinDown ;
  OpenAndClose := PushinButtons ;
end ; {OpenAndClose Function}


Function ScreenShift( Ver:Byte ):Char ;  {#1: Shifting}
                                           {#2: Earthquakes}
Var Bob:Char ;						{Once WaitForKeypress decides its been long enough}
		TimeToGo:Boolean ;		{since nothing happened, it will start this screen}
													{saver. Shifts da screen. Will go until keypressed}
    D:Direction ;
    Strip		:String[ 80 ] ;
    Strip_a	:Array[ 1..80 ] of Byte ;
		r, u, LoisLane, Lex, StupidCopyCat:Byte;

Begin
	TimeToGo := False ;
  Lex:= 15 ;
  d:=Right ;
  If Ver > 1 then LoisLane := 1
	else LoisLane := 15 ;
	Randomize ;
  CaptureScreen ;
  Repeat
		Dec( LoisLane ) ;
    If LoisLane < 1 then
			Begin
      	StupidCopyCat := Lex ;
				LoisLane := Random( 24 ) ;
        If LoisLane < 2 then Inc( LoisLane, 4 ) ;
        If Ver > 1 then LoisLane := 1 ; {To Cause Earthshaking Consequences}
        Repeat
					Lex:=Random( 199 ) ;
          If Ver > 1 then TimeToGo := True ; {To Guarantee 'Shakage'}
      	Until (Lex+50>StupidCopyCat) or (Lex-50<StupidCopyCat) or TimeToGo ;
        If Ver > 1 then TimeToGo := False ; {Compensation/Complication}
      end ;
    Case Lex of
    	  0..49 : d:=Left ;
			 50..99 : d:=Up ;
      100..149: d:=Right ;
      150..199: d:=Down ;
    end ;
    If Keypressed then
    	Begin
      	TimeToGo := True ;
        Bob:=Readkey ;
        If Bob=#0 then Bob := Readkey ;
      end ;
    Case d of
    	Left, Right:
        Begin
          If d = Left then U := 1
          else U := 80 ;
      		For r := 1 to 25 do
        		Begin
              Strip[ r ] := GetChar( u, r ) ;
              Strip_a[ r ] := GetChar_a( u, r ) ;
            end ;
				end ;
      Up, Down:
      	Begin
        	If d = Up then U := 1
          else U:=25 ;
          For r := 1 to 80 do
          	Begin
            	Strip[ r ] := GetChar( r, u ) ;
              Strip_a[ r ] := GetChar_a( r, u ) ;
            end ;
        end ;
    end ; {Case}
    Case d of
    	Up:
      	Begin
        	For u := 2 to 25 do
          	For r := 1 to 80 do
							WriteChar_a( r, u-1, GetChar( r, u ), GetChar_a( r, u ) ) ;
          For u := 1 to 80 do
          	WriteChar_a( u, 25, Strip[ u ], Strip_a[ u ] ) ;
        end ;
      Down:
      	Begin
        	For u := 24 downto 1 do
          	For r := 1 to 80 do
							WriteChar_a( r, u+1, GetChar( r, u ), GetChar_a( r, u ) ) ;
          For u := 1 to 80 do
          	WriteChar_a( u, 1, Strip[ u ], Strip_a[ u ] ) ;
        end ;
      Right:
      	Begin
        	For u := 79 downto 1 do
          	For r := 1 to 25 do
							WriteChar_a( u+1, r, GetChar( u, r ), GetChar_a( u, r ) ) ;
          For u := 1 to 25 do
          	WriteChar_a( 1, u, Strip[ u ], Strip_a[ u ] ) ;
        end ;
      Left:
      	Begin
        	For u := 2 to 80 do
          	For r := 1 to 25 do
							WriteChar_a( u-1, r, GetChar( u, r ), GetChar_a( u, r ) ) ;
          For u := 1 to 25 do
          	WriteChar_a( 80, u, Strip[ u ], Strip_a[ u ] ) ;
        end ;
    end ; {Case}
  	If Not TimeToGo then ChillOut( 1 ) ;
  Until TimeToGo ;
  WinDown ;
	ScreenShift := Bob ;
end ; {ScreenShift Function}

Procedure ColorBox( l, u, r, d, GermsAreBadForYou:Byte ) ;

Var Bert, Ernie:Byte ;

Begin
	For Bert := l to r do
  	For Ernie := d downto u do
    	WriteChar_A( Bert, Ernie, ' ', GermsAreBadForYou*16 + White ) ;
end ; {ColorBox PROC}

Function Boxes:Char ;

Var Bob:Char ;          {Once WaitForKeypress decides its been long enough}
		TimeToGo:Boolean ;  {since nothing happened, it will start this screen}
		l, r, u, d:Byte ;		{saver. Displays boxes. Will go until a keypressed}
    Bulls, Sox, Cubs, Bears:Byte ;

Begin
	Sox  := 0 ;
  Cubs := 0 ;
	TimeToGo := False ;
	Randomize ;
  CaptureScreen ;
	Repeat
		L:=Random( 37 ) +1 ; {Left border MUST be on Left side of screen}
		Repeat
			R:=Random( 80 ) ;
			If Keypressed then
				Begin
					Bob:=Readkey ;   {Checking for keypress...}
          If Bob=#0 then Bob := Readkey ;
					TimeToGo:=True ;
				end ;
		Until ( r > l ) or TimeToGo ; {Must be right of left side}
		U:=Random( 11 ) +1 ;
    Repeat
    	Bulls := Random( 6 ) + 1 ;
			If Keypressed then
				Begin
					Bob:=Readkey ;   {Checking for keypress...}
					TimeToGo:=True ;
          If Bob = #0 then Bob:=Readkey ;
				end ;
    Until ( (Bulls<>Sox) and (Bulls<>Cubs) and (Bulls<>Bears) ) OR TimeToGo;
    Bears := Cubs ;
    Cubs := Sox ;
    Sox := Bulls ;
		Repeat
			D:=Random( 25 ) ;
			If Keypressed then             {Same with up and down}
				Begin
					Bob:=Readkey ;
					TimeToGo:=True ;
          If Bob = #0 then Bob:=Readkey ;
				end ;
		Until ( d > u ) or TimeToGo ;
		If NOT TimeToGo then {If no keypress, then...}
			Begin
				ColorBox( l, u, r, d, Bulls ) ;			 {Display the box}
				ChillOut( 20 ) ;
			end ;
		If Keypressed then
			Begin
				Bob:=Readkey ;
				TimeToGo:=True ;
        If Bob = #0 then Bob:=Readkey ;
			end ;
	Until TimeToGo ; {Once time to go, restore screen.}
	WinDown ;
	Boxes := Bob ;
end ; {Boxes Function}

																{Allows key input and management for a}
Function WaitForKeypress:Char ;	{screen saver both at same time.      }

Var h1, h2, m1, m2, s1, s2, Hundredths:Word ;
		ItsTime, SchoolsOut:Boolean ;
		Hooji:Char ;
    Decide:Byte ;

Begin
	ItsTime := False ;
	SchoolsOut := False ;
	Repeat
		GetTime( h1, m1, s1, hundredths ) ; {Get start time}
		Repeat
			GetTime( h2, m2, s2, hundredths ) ; {Get time now}
			If ( (h2=1) and (h1=12) ) or ( h2 > h1 ) then Inc( m2, 60 ) ;
			Inc( s2, ( m2 - m1 ) * 60 ) ; {Put time in terms of secs}
			If Keypressed then
				Begin
					ItsTime := True ;			{Check for keypress}
					SchoolsOut := True ;
				end ;
		Until ( s2 - s1 > AfterDarkTime * 60 ) or ItsTime ;
		If ( Not ItsTime ) and ( Not SchoolsOut ) then
    	Begin
        Decide := Random( 250 ) + 1 ;
        Case Decide of
        	1..75:
						Hooji:=Pieces ;

          76..110:
						Hooji:=ScreenShift( 1 {Long Slides} ) ;

          111..180:
						Hooji:=ScreenShift( 2 {Earthquake} ) ;

          181..210:
          	Hooji:=OpenAndClose ; {Shutters}

          211..225:
          	Hooji:=Boxes ;

          226..240:
          	Hooji:=PhaseOut ;

          241..255:
          	Hooji:=Fade ; {Fade}
				end ; {Case}
      end ;
	Until SchoolsOut ;
	WaitForKeypress := Readkey ;
end ;

end.