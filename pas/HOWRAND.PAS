Program CheckRandomness ;

Uses CRT, Zakmohn, ScrnSave;

Const backcol = blue ;

Var s:Array[ 1..5 ] of Integer ;
		i, R:Integer ;
    Sit:Char ;

Begin
  Repeat
  	TextBackGround( black ) ;
		ClrScr ;
	  GotoXY( 1, 2 ) ;
    TextBackGround( backcol ) ;
	  WriteStr( 1, 6,  ' 1-20' ) ;
	  WriteStr( 1, 10, '21-40' ) ;
    WriteStr( 59, 4, 'Scale: '+Chr(4)+' = 10 Hits.' ) ;
	  WriteStr( 1, 14, '41-60' ) ;
	  WriteStr( 1, 18, '61-80' ) ;
	 	WriteStr( 1, 22, '81-100') ;
    WriteStr( 10, 24, '         ³         ³         ³         ³         ³         ³' ) ;
    WriteStr( 10, 25, '        100       200       300       400       500       600') ;
		For I:=1 to 5 do
			s[i] := 9 ;
	  WriteCenter( 'How Random is the Randomize Command?' ) ;
    WriteStr( 62, 3, '(3000 Attempts)' ) ;
	  Randomize ;
    For I:=1 to 25 do
			If I > 23 then Hilite( 1, i, backcol, 79 )
			else HiLite( 1, i, backcol, 9 ) ;
	  I:=0 ;
	  Repeat
			Inc( i ) ;
	    R:=Random( 99 ) + 1 ;
	    Case r of
	    	1..20:Inc( s[ 1 ] ) ;
	      21..40:Inc( s[2] ) ;
	      41..60:Inc( s[3] ) ;
	      61..80:Inc( s[4] ) ;
	      81..100:Inc( s[5] ) ;
	    end ;
	    For r:=1 to 5 do
		  	Begin
		    	WriteStr( 1, 3+r*4, '       ' ) ;
		    	gotoxy( 1, 3+ r*4 ) ;
		      Write( ( s[ r ] ) - 9 ) ;
		    	If ((s[ r ]-9) div 10 < 80) and ((s[ r ]-9) div 10 >0) then
						WriteChar_a( (s[ r ]-9) div 10+9, 2+R*4, Chr( 4 ), Red ) ;
		    end ;
	  until ( i >= 3000 ) ;
	  Sit := WaitForKeypress ;
  Until ( Upcase(sit) = 'X' ) or ( Upcase(sit) = 'Q' ) or ( Sit = #27 ) ;
end.