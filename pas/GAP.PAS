
Program GappaBabe ;

uses crt, graph;

Var	a, b, c, d, x, y, mx, my, md, omd, q, r, t, z, score, lives:INTEGER ;
	play, LastKey, Key, OldKey:CHAR ;
	level:string[10];
	CanYouPush, CursToggle, Win, Die, GapOn:Boolean ;
	Board:array[ 10..70, 2..22 ] of Char ;
	BoardCon:array[ 10..70, 2..22 ] of Boolean ;
	BoxDone:array[ 1..16 ] of Boolean ;

Procedure TempHiLiteBox( a, b, c, d, points:integer) ;
	Begin
		GotoXY( ( (a+b) div 2 ), ( (c+d) div 2 ) ) ;
		Write( points ) ;
	end ; {Da Temp Proc}


Procedure ScoreManager( Funct, Differential:integer ) ;
	Begin
		Case Funct of
			1:score:=score+differential; {Adder}
			2:score:=score-differential; {Stealer}
			3:
				Begin
					GotoXY( 45, 24 ) ;
					Write(level, '  Score: ', Score,'  Lives: ',lives-1 ) ;
				end; {Function 3}
		end ; {Case}
	end; {Proc}


Procedure CheckLine( BoxNum, a, b, c, d:INTEGER ) ;
	Begin
		BoxDone[ BoxNum ]:=TRUE ;
		For Q:= a to b do
			Begin
				If BoardCon[ Q, c ] = False then
					BoxDone[ BoxNum ]:=False ;
				If BoardCon[ Q, d ] = False then
					BoxDone[ BoxNum ]:=False ;
			End ; {FOR}
		If BoxDone[ BoxNum ] = TRUE then
			Begin
				For Q:= (C+1) to (d-1) do
					Begin
						If BoardCon[ a, Q ]=False then
							BoxDone[ BoxNum ]:=False ;
						If BoardCon[ b, Q ]=False then
							BoxDone[ BoxNum ]:=False ;
					End ; {FOR}
			End ; {IF}
		If BoxDone[ BoxNum ] = TRUE then
			Begin
				TempHiLiteBox( a, b, c, d, 50 ) ;
				ScoreManager( 1, 50 ) ;
			End ; {IF}
	End ; {Proc}


Procedure FindKey ;
	Begin
		If keypressed = true then
			begin
				OldKey:=lastKey ;
				Key:=readkey;
				lastkey:=key ;
			end  {if}
		else
			key:=lastkey ;
		If key = '0' then
			Begin
				Gapon:=true ;
				Key:=oldkey ;
			end ; {if gap}
		If (Key<>'4') and (Key<>'5') and (Key<>'6') and (Key<>'8') and
			 (Key<>'2') then Key:=OldKey ;
	End ; {Proc}

Procedure Init ;
	Begin
		{CursToggle:=_displayCursor( false ) ;}
		For Q:=10 to 70 do
			Begin
				For R:=2 to 22 do
					Begin
						Board[ Q, R ] := ' ' ;
						BoardCon[ q, r ]:=false ;
					end;  {for r}
			end ; {For q}
		For Q:=2 to 22 do
			Begin
				Board[ 10, q ]:= '³' ;
				Board[ 25, q ]:= '³' ;
				Board[ 40, q ]:= '³' ;
				Board[ 55, q ]:= '³' ;
				Board[ 70, q ]:= '³' ;
			end ; {For Q}
		For Q:=10 to 70 do
			Begin
				Board[ q, 2 ] := 'Ä' ;
				Board[ q, 7 ] := 'Ä' ;
				Board[ q, 12 ] := 'Ä' ;
				Board[ q, 17 ] := 'Ä' ;
				Board[ q, 22 ] := 'Ä' ;
			End ; {For Q}
		For Q:=1 to 16 do
			Begin
				BoxDone[ Q ]:=False ;
			End ;
		Board[ 70, 7]:= '´' ;
		Board[ 70,12 ]:= '´' ;
		Board[ 70,17 ]:= '´' ;
		Board[ 25,22 ]:= 'Á' ;
		Board[ 40,22 ]:= 'Á' ;
		Board[ 55,22 ]:= 'Á' ;
		Board[ 10,7 ]:= 'Ã' ;
		Board[ 10,12 ]:= 'Ã' ;
		Board[ 10,17 ]:= 'Ã' ;
		Board[ 25,2 ]:= 'Â' ;
		Board[ 40,2 ]:= 'Â' ;
		Board[ 55,2 ]:= 'Â' ;
		Board[ 25,7 ]:=  'Å' ;
		Board[ 25,12 ]:= 'Å' ;
		Board[ 25,17 ]:= 'Å' ;
		Board[ 40,7 ]:=  'Å' ;
		Board[ 40,12 ]:= 'Å' ;
		Board[ 40,17 ]:= 'Å' ;
		Board[ 55,7 ]:=  'Å' ;
		Board[ 55,12 ]:= 'Å' ;
		Board[ 55,17 ]:= 'Å' ;
		Board[ 10,2 ]:=  'Ú' ;
		Board[ 70,2 ]:=  '¿' ;
		Board[ 10,22 ]:= 'À' ;
		Board[ 70,22 ]:= 'Ù' ;
		T:=0;
		X:=15;
		y:=7;
		OldKey:= '4' ;
		Key:='4';
		GapOn:=False ;
		Win:=False;
		Die:=False ;
		Mx:=70;
		my:=20;
		md:=8;
		omd:=8;
		For q:=10 to 70 do
			Begin
				For r:=2 to 22 do
					Begin
						GotoXY( q, r ) ;
						Write( Board[q, r] ) ;
					end; {For R}
			end; {For Q}
	End; {Proc}


Procedure EraseOld( a, b:INTEGER ) ;
	Begin
		GotoXY( a, b ) ;
		If BoardCon[ a, b ] = TRUE then
			TextColor( RED )
		Else
			TextColor( WHITE ) ;
		Writeln( Board[ a, b ] ) ;
		TextColor( WHITE ) ;
	End ; {Proc}

Procedure CheckDir ;
	Begin
		If ( (Key='5') or (Key='8') or (Key='2') ) and ( (X<>10) and
				 (X<>25) and (X<>40) and (X<>55) and (X<>70) ) then
					Key:=OldKey;
		If ( (Key='4') or (Key='6') ) and ( (y<>2) and (y<>7) and
				 (y<>12) and (y<>17) and (y<>22) ) then
					Key:=OldKey;
	End ; {Proc}

Procedure MoveDir ;
	Begin
		Case Key of
			'4':Dec( x ) ;
			'6':Inc( x ) ;
			'8':Dec( y ) ;
			'0':GapOn:=TRUE ;
			'5','2':Inc( y ) ;
		End ; {CASE}
		If x<10 then
			x:=10
		Else
			If x>70 then x:=70 ;
		If y<2 then
			y:=2
		Else
			If y>22 then y:=22 ;
	End ; {Proc}

Procedure WriteNew( Color, a, b:INTEGER ;
										WhatToWrite:CHAR ) ;
	Begin
		TextColor( Color ) ;
		GotoXY( a, b ) ;
		Write( WhatToWrite ) ;
		TextColor( WHITE ) ;
	End ; {Proc}

Procedure HiLite ;
	Begin
		BoardCon[ x, y ]:=TRUE ;
	End ; {Proc}

Procedure MonstaBrains ;
	Begin
		OMD:=MD ;
		If ( (mx=10) or (mx=25) or (mx=40) or (mx=55) or (mx=70) )
			and ( y<my ) then MD:=8 ;
		If ( (mx=10) or (mx=25) or (mx=40) or (mx=55) or (mx=70) )
			and ( y>my ) then MD:=5 ;
		If x<mx then
			MD:=4
		Else
			If x>mx then MD:=6 ;
		If ( (md=8) or (md=5) ) and ( (MX<>10) and (MX<>25) and
				 (MX<>40) and (MX<>55) and (MX<>70) ) then MD:=OMD ;
		If ( (md=4) or (md=6) ) and ( (MY<>2) and (MY<>7) and
				 (MY<>12) and (MY<>17) and (MY<>22) ) then MD:=OMD ;
		Case MD of
			4:Dec( mx ) ;
			5:Inc( my ) ;
			6:Inc( mx ) ;
			8:Dec( my ) ;
		End ; {CASE}
		If mx<10 then
			mx:=10
		Else
			If mx>70 then mx:=70 ;
		If my<2 then
			my:=2
		Else
			If my>22 then my:=22 ;
	End ; {Proc}

Procedure CheckBox ;
	Begin
		If BoxDone[1]=False then	CheckLine( 1, 10, 25, 2, 7 ) ;
		If BoxDone[2]=False then	CheckLine( 2, 25, 40, 2, 7 ) ;
		If BoxDone[3]=False then	CheckLine( 3, 40, 55, 2, 7 ) ;
		If BoxDone[4]=False then	CheckLine( 4, 55, 70, 2, 7 ) ;
		If BoxDone[5]=False then	CheckLine( 5, 10, 25, 7, 12 ) ;
		If BoxDone[6]=False then	CheckLine( 6, 25, 40, 7, 12 ) ;
		If BoxDone[7]=False then	CheckLine( 7, 40, 55, 7, 12 ) ;
		If BoxDone[8]=False then	CheckLine( 8, 55, 70, 7, 12 ) ;
		If BoxDone[9]=False then	CheckLine( 9, 10, 25, 12, 17 ) ;
		If BoxDone[10]=False then	CheckLine( 10, 25, 40, 12, 17 ) ;
		If BoxDone[11]=False then	CheckLine( 11, 40, 55, 12, 17 ) ;
		If BoxDone[12]=False then	CheckLine( 12, 55, 70, 12, 17 ) ;
		If BoxDone[13]=False then	CheckLine( 13, 10, 25, 17, 22 ) ;
		If BoxDone[14]=False then	CheckLine( 14, 25, 40, 17, 22 ) ;
		If BoxDone[15]=False then	CheckLine( 15, 40, 55, 17, 22 ) ;
		If BoxDone[16]=False then	CheckLine( 16, 55, 70, 17, 22 ) ;
	End ; {Proc}

Procedure CheckDead ;
	Begin
		If (Win=TRUE) then
			Die:=FALSE
		Else
			If (y=my) and (x=mx) then
				Die:=TRUE
			Else Die:=False ;
	End ; {Proc}

Procedure CheckWin ;
	Begin
		Win:=True ;
		For q:= 1 to 16 do
			Begin
				If BoxDone[ q ] = FALSE then
					Win:=False ;
			End ; {FOR}
	End ; {Proc}


Begin
	TextBackground( BLACK ) ;
	TextColor( WHITE ) ;
	Z:=5;
	lives:=4;
	Repeat
		ClrScr ;
		Init ;
		case z of
			5:level:='Level 1';
			4:level:='Level 2';
			3:level:='Level 3';
			2:level:='Level 4';
			1:level:='Level 5';
		end; {case}
		Repeat
			FindKey ;
			EraseOld( x, y ) ;
			CheckDir ;
			MoveDir ;
			WriteNew( 4, x, y,'' ) ;
			HiLite ;
			If z<>0 then
				If (t mod z) = 0 then
					Begin
						EraseOld( mx, my ) ;
						MonstaBrains ;
						WriteNew( 2, mx, my, '' ) ;
						If t>3000 then t:= 0 ;
					End ; {IF}
			If z=0 then
				Begin
					EraseOld( mx, my ) ;
					MonstaBrains ;
					WriteNew( 2, mx, my, '' ) ;
					If t>3000 then t:= 0 ;
				End ; {IF}
			Inc( t ) ;
			CheckBox ;
			CheckWin ;
			CheckDead ;
			ScoreManager( 3, 0 ) ; {Displays Score}
		Until (Win=TRUE) or (Die=TRUE) ;
		If Die=TRUE then dec(lives);
		if lives=0 then play:='N';
		if Win=TRUE then
			Begin
				repeat
				writeln;
				writeln ('Do you want to play the next level?');
				play:=readkey;
				if z>0 then dec(z);
				until (upcase(play)='N') or (upcase(play)='Y');
			End; {if}
	until upcase(play)='N';
End.
