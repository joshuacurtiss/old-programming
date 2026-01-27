Program MorseCodeage ;               {With cooperative multitasking to allow}
                                     {entry of chars while morse code is}
Uses CRT, DOS, Joshmohn ;            {sounding and displaying}

Const dah = '-' ;
			di  = #249 ; {Little Dot.}
      dit = #249 ;
      DahDelay = 18 ;
      DitDelay = 10 ;
      EndWordDelay = 40 ;
      EndWord = ' ' ;
      EndSentence = ' / ' ;
      ValidList = [ 'A'..'Z', '.', ' ' ] ;

Var key, mk:Char ;
		s, c:Boolean ;
		i, WinPos:Byte ;
    Message, MorseChunk:String ;


Procedure CheckKB ;         {Part that works the keyboard}
Begin
	If Keypressed then
   	Begin
     	Key := Readkey ;                   {If you push a key,}
      If Key = #0 then Key := Readkey ;
      If Upcase( Key ) in ValidList then  {and it's a good key (in validlist)}
       	Begin
          Write( Key ) ;      {Write it to screen and,}
					Insert( Key, Message, Length( Message ) + 1 ) ; {Put it in a}
        end ;                                    {>>TEMP<< message string}
    end ;
end ;                                            {Will explain later}


Procedure Chill( hun:Word ) ; {Revised delay procedure to work more precisely}
                              {and allow multitasking}

Var Hour, Min, Sec, h, Hour2, M2, S2, h2:word ;

Begin
	GetTime( Hour, Min, Sec, H ) ;
	Repeat
    CheckKB ;   {Will read ONE keystroke-if there is one-and put in temp str.}
		GetTime( Hour2, m2, s2, h2 ) ;
		If (Hour=23) and (Hour2<23) then Inc( Hour2, 24 ) ;
    Inc( h2, 100*( (s2 - Sec) + 60*( m2 - Min + 60*(Hour2-Hour) ) ) ) ;
	Until ( H2 - H ) >= hun ;        {Wait till the specified time}
end ; {ChillOut Proc}


Procedure MakeTone( t:Char ) ;    {The sound effects}

Var l:Byte ;

Begin
	Case t of
  	di, dit : l:=DitDelay  ;   {Define how many tenths the sound should go}
    dah     : l:=DahDelay ;
    EndWord : l:=EndWordDelay ;
    '/'     : l:=1 ;
  end ;
	If ( t=di ) or ( t=dah ) then Sound( 200 ) ;
  Chill( l ) ;         {You want to delay for 'EndWord', but don't want sound}
  NoSound ;
	Chill( 10 ) ; {Small delay to separate btwn each di and dah that plays}
end ;

Function Morse( c:char ):String ; {Convert one letter into morse code segment}
Var M:String ;
Begin                           {Done simply so that its easy to understand}
	Case Upcase( c ) of
		' ':m:=EndWord ;
		'.':m:=EndSentence ;
    'A':m:=di+dah ;									'B':m:=dah+di+di+dit ;
    'C':m:=dah+di+dah+dit ;					'D':m:=dah+di+dit ;
    'E':m:=dit ;										'F':m:=di+di+dah+dit ;
    'G':m:=dah+dah+dit ;						'H':m:=di+di+di+dit ;
    'I':m:=di+dit ;									'J':m:=di+dah+dah+dah ;
    'K':m:=dah+di+dah ;							'L':m:=di+dah+di+dit ;
    'M':m:=dah+dah ;								'N':m:=dah+dit ;
    'O':m:=dah+dah+dah ;						'P':m:=di+dah+dah+dit ;
    'Q':m:=dah+dah+di+dah ;					'R':m:=di+dah+dit ;
    'S':m:=di+di+dit ;							'T':m:=dah ;
    'U':m:=di+di+dah ;							'V':m:=di+di+di+dah ;
    'W':m:=di+dah+dah ;							'X':m:=dah+di+di+dah ;
    'Y':m:=dah+di+dah+dah ;					'Z':m:=dah+dah+di+dit ;
  end ;
	Morse := m ;
end ;

Procedure Display( c:Char ) ; {Displays one char at a time, not one morse}
															{Sequence at a time...}
Var x:Byte ;
Begin
	If WinPos >= 80 then {If my code window is full, then scroll it}
  	Begin
    	For x := 2 to 78 do
      	WriteChar( x, 10, GetChar( x+1, 10 ) ) ;
    	While WinPos >= 80 do Dec( WinPos ) ; {Bring that WinPos DOWN!}
    end ;
  WriteChar( WinPos, 10, c ) ;
	Inc( WinPos ) ;
end ;

Procedure Init ;  {Your basic startup crap}
Begin
  Writeln ;
  Write( 'Sound? (Y/N) ' ) ;
  Key := Readkey ;
	If Upcase( Key ) = 'N' then s := False
  else s := True ;
  Writeln ;
  Write( 'Display the morse code? (Y/N) ' ) ;
  Key := Readkey ;
	ClrScr ;
  If Upcase( Key ) = 'N' then c := False
  else c := True ;
  InitWins ; {This MUST be called to use windows!!!!!!!! My Windows!!!}
  WinUp( 9, 15, 71, 23 ) ;
  Window( 10, 16, 70, 22 ) ; {Shrinks the cursor boundaries to the confines}
  													 {of my one small window. It's a CRT command.}
  WinUp( 1, 9, 80, 11 ) ;
  WinPos := 2 ;
  GotoXY( 10, 16 ) ;
  WriteStr( XCenterPos( 'Morse Code Action!' ), 5, 'Morse Code Action!' ) ;
end ;


Begin
  Init ;
  Message := 'Yeahmohn.' ;  {A start-off message, just for kicks.}
	Repeat
    CheckKB ;                      {Check the kb once for typing. Then,}
    If Length( Message ) > 0 then  {Check your string 'buffer' for words that}
    	Begin                        {Haven't yet been converted to morse code.}
        mk := Message[ 1 ] ; {Take the next letter}
        Delete( Message, 1, 1 ) ; {Subtract it from the temp 'buffer' file}
        MorseChunk := Morse( mk ) ; {Convert it to morse code into MorseChunk}
        For i := 1 to Length( MorseChunk ) do
        	Begin                                   {Display code, char by char}
          	If c then Display( MorseChunk[ i ] ) ;
            If s then MakeTone( MorseChunk[ i ] ) ; {Play sound too.}
          end ;
        Display( ' ' ) ; {After display one letter, put space to sep. letters}
        DisplayTime( 65, 1, True, False, True ) ;
      end
    else
    	DisplayTime( 65, 1, True, False, True ) ;
  Until Key = #27 ; {Stop as SOON as they push escape!!!}
  GotoXY( 1, 2 ) ;
	CloseAllWins ;
end. {Very easy.}

{The multitasking:}

{The repeat/until in the main loop alternates between nothing but CHECKING
the keyboard for a key, then displaying the next char in the string buffer.
Thats why its cooperative. Switches between the two. But ALSO, while it is
doing the morse code, its STILL check the keyboard, becuz during the delay
procedure that is used when the sound is playing, it continually checks the
keyboard WHILE the sound is playing. Sweet}