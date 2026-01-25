Program TestDilly ;

Uses CRT, DOS, Joshmohn, ScrSave2 ;

Var TheString, TheFile, Result:String ;
		Key:Char ;

    DillyMax, DillyBackCol, DillyCursCol, DillyTextCol:Byte ;

Function Dilly( LimLeft, LimRight, y:Byte ; s:String ):String ;

Var Width, a, c, Delta:Byte ;
    Letter:Boolean ;

Begin
	If Length( s ) > DillyMax then
  	S := Copy( s, 1, DillyMax ) ;
  Delta:=0 ;
	Width := LimRight + 1 - LimLeft ;
  If Length( s ) > Width then C:=Width
  else C:=Length( s ) + 1 ;
  Repeat
    For A:=1 to Width do
     	If A + Delta > Length( s ) then
				WriteChar_a( LimLeft+A-1, y, ' ', DillyBackCol*16+DillyTextCol )
      else
       	WriteChar_a( LimLeft+A-1, y, s[A+Delta], DillyBackCol*16+DillyTextCol ) ;
      If Delta > 0 then
				WriteChar_a( LimLeft, y, Chr(17), DillyBackCol*16+DillyTextCol ) ; {<}
      If Delta + Width < Length( s ) then
      	WriteChar_a( LimRight, y, Chr(16), DillyBackCol*16+DillyTextCol ) ; {>}
   	HiLite( LimLeft + C - 1, y, DillyCursCol, 1 ) ;

  	Key := ' ' ;
    Key := WaitForKeypress ;
    Sound( 5000 ) ; 				      {Beep when push a key}
		Delay( 1 ) ;
		NoSound ;

    If Key = #0 then
    	Begin
      	Letter := False ;
        Key := Readkey ;
        Case Key of
					UpArrow, DownArrow, Chr( TAB ): ;
          #71: {Home}
          	Begin
            	Delta := 0 ;
              C := 1 ;
            end ;
          #79: {End}
          	Begin
            	If Length(s) > Width then
              	Begin
                	Delta := Length(s) + 1 - Width ;
                  C:=Width ;
                end
              else
              	Begin
                	C:=Length( s ) + 1 ;
                  Delta := 0 ;
                end ;
            end ;
  				Del: {Special Delete}
          	Begin
 							If C+Delta <= Length( s ) then Delete( s, C+Delta, 1 ) ;
            end ;
          LeftArrow:Dec( C ) ;
          RightArrow:If C+Delta<=Length( s ) then Inc( c ) ;
      	end ; {Case}
      end {If #0}
    else
			Begin
				Letter := True ;
        Case Key of
        	ESC, Chr(13), Chr(Tab):Letter := False ;
          Chr( 8 ): {Normal Delete}
          	If ( C > 1 ) or ( Delta > 0 ) then
							Begin
								Delete( s, C+Delta-1, 1 ) ;
      			    If Delta > 0 then
                  Dec( Delta )
								else
									Dec( c ) ;
			        end;
        	else
          	If Length( s ) < DillyMax then
							Begin
								Insert( Key, s, C + Delta ) ;
	  			      Inc( c ) ;
				      end ;
        end ;{CASE}
      end ; {NOT #0}

    If C > Width then
    	Begin
      	C:=Width ;
        Inc( Delta ) ;
      end
    else
			If C<1 then
      	Begin
        	C:=1 ;
          If Delta > 0 then Dec( Delta ) ;
				end ;
	Until ( ( Key = #13 ) or ( Key = #27 ) or ( Key = Chr( Tab ) ) or
				( Key = UpArrow ) or ( Key = DownArrow ) ) and ( Letter=False ) ;
  HiLite( LimLeft + c - 1, y, DillyBackCol, 1 ) ;
  Dilly := S ;
end ; {Dilly Function}

Begin
	ClrScr ;

  {Settings:}
  SetScreenSaverTime( 5 ) ;
  DillyBackCol := Blue ;
  DillyTextCol := White ;
  DillyCursCol := Red ;
  DillyMax := 100 ;


  WriteStr( 3, 3, 'This Program uses a nifty input procedure called ''Dilly''' ) ;
  WriteStr( 5, 7, 'Path to search in:' ) ;
	TheString := Dilly( 25, 65, 7, '' ) ;
  WriteStr( 2, 12, 'What file:' ) ;
  WriteStr( 1, 10, 'Path: "' + TheString + '"' ) ;
  GotoXY( 13, 12 ) ;
  DillyBackCol := Black ;
  DillyMax := 12 ;
  TheFile := Dilly( 13, 79, 12, '' ) ;
  Result := FSearch( TheFile, TheString ) ;
  Writeln ;
  Writeln( 'Search result: ', FExpand( Result ), '.' ) ;
  Result := WaitForKeypress ;
end.