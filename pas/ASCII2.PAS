Program ASCIIShow ;

Uses CRT, ZakMohn ;

Var Key:Char ;
		num, x, y:Integer ;
		Funct, SpecKey:Boolean ;

Procedure DoMoveWin ;

Var Bottom:Array[ 24..25 ] of String[ 80 ] ;
		Bottoma:Array[ 24..25 ] of Array[ 1..80 ] of Byte ;
    I:Integer ;
    Prevk:Char ;

Begin
	Prevk:=Key ;
	For I:=1 to 80 do
  	Begin
    	Bottom[24][i] := GetChar( i, 24 ) ;
      Bottoma[24][i] := GetChar_a( i, 24 ) ;
      Bottom[25][i] := GetChar( i, 25 ) ;
      Bottoma[25][i] := GetChar_a( i, 25 ) ;
      WriteChar_a( i, 24, ' ', BW ) ;
      WriteChar_a( i, 25, ' ', BW ) ;
    end ;
  WriteStr( 9, 25, 'Use arrows to move window. Return to exit.' ) ;
  Repeat
	  Key:=Readkey ;
		If Key=#0 then Key:=Readkey ;						{WinUp( x-5, y-1, x+15, y+1 )}
		If ( Key=LeftArrow ) and ( x<7 ) then Key:=' ' ;
    If ( Key=RightArrow ) and ( X>64 ) then Key:=' ' ;
    If ( Key=UpArrow ) and ( Y<3 ) then Key:=' ' ;
    If ( Key=DownArrow ) and ( Y>21 ) then Key:=' ' ;
	  Case Key of
	  	LeftArrow:
				Begin
					MoveWin( -1, 0 ) ;
          Dec( x ) ;
        end ;
	    RightArrow:
				Begin
					MoveWin( 1, 0 ) ;
          Inc( x ) ;
        end ;
	    UpArrow:
				Begin
					MoveWin( 0, -1 ) ;
          Dec( y ) ;
        end ;
	    DownArrow:
				Begin
					MoveWin( 0, 1 ) ;
          Inc( y ) ;
        end ;
	  end ;
  Until ( Key = #13 ) or ( Key = #27 ) ;
	For I:=1 to 80 do
		Begin
    	WriteChar_a( i, 24, Bottom[24][i], Bottoma[24][i] ) ;
    	WriteChar_a( i, 25, Bottom[25][i], Bottoma[25][i] ) ;
    end ;
  Key:=Prevk ;
end ; {DoMoveWin Proc}


Begin
	InitWins ;
  Funct:=True ;
	x:=60 ;
  y:=4 ;
  WinUp( x-5, y-1, x+15, y+1 ) ;
	Key:='A' ;
  Repeat
		GotoXY( x, y ) ;
    If Funct then
     	begin
		    Write( Key ) ;
		    GotoXY( x+7, y ) ;
		    If SpecKey then Write( '#' ) ;
				Num:=Ord( Key ) ;
				Write( Num, '   ' ) ;
      end
    else
     	begin
       	Write( Chr( Num ), ' ' ) ;
        GotoXY( x+7, y ) ;
        Write( Num, '   ' ) ;
      end ;
    GotoXY( x, y ) ;
    If ( Key = #98 ) and ( SpecKey ) then DoMoveWin ;
    If ( Ord(KEY) < 15 ) or ( Num < 15 ) or ( Num > 200 ) then
			BorderMohn( x-5, y-1, x+15, y+1, Black, White ) ;
    Key:=Readkey ;
    If Key=#0 then
			begin
				Key:=Readkey ;
        SpecKey:=True ;
      end
    else SpecKey:=False ;
		If Key=#13 then Funct:=not funct ;
    If Not Funct then
     	Case key of
       	UpArrow:If Num < 260 then Inc( num ) ;
        DownArrow:If Num > 1 then Dec( num ) ;
        PgUp:If Num < 260 then Inc( num, 10 ) ;
        PgDn:If Num > 10 then Dec( num, 10 ) ;
      end ; {CASE}
  Until ( Key = #27 ) ;
  WinDown ;
  GotoXY( 1, 25 ) ;
end .
