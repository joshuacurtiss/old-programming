Program SubtractNumbahs ;

Uses CRT, Joshmohn ;

Var big, sm, answer:String ;
    Key:Char ;

Function Subtract( First, Sec:String ):String ;

Var i, j:Byte ; {MUST be bytes}
    a, ans:ShortInt ;  {MUST be ShortInts}
    c:Integer ;
    Digit:Array[ 1..255 ] of ShortInt ; {MUST be ShortInts}
    Dif:String ;

Begin
  While Length( First ) > Length( Sec ) do Insert( '0', Sec, 1 ) ;
  I:=Length( First ) ;
  Dif := '' ;
  For J:=1 to i do Val( First[ j ], Digit[ j ], c ) ;
  Repeat
    Val( Sec[ i ], a, c ) ;
    If Digit[ i ] < a then
      Begin
        j := i ;
        Repeat
          Dec( j ) ;
          Inc( Digit[ j+1 ], 10 ) ;
          Dec( Digit[ j ] ) ;
        Until Digit[ j ] >= 0 ;
      end ;
    Ans := Digit[ i ] - a ;
    Insert( Chr( Ans + 48 ), Dif, 1 ) ;
    Dec( i ) ;
  Until ( i<=0 ) ;
  I:=255 ;
  Repeat
    Inc( i ) ;
  Until Dif[ i+1 ] <> '0' ;
  Delete( Dif, 1, i ) ;
  Subtract := Dif ;
end ; {Subtract FUNCTION}

Begin
  InitWins ;
  WinUp( 1, 1, 80, 25 ) ;
  Clrscr ;
  Repeat
    Writeln ;
    Write( 'The first number? ' ) ;
    Readln( Big ) ;
    Write( 'The second number? ' ) ;
    Readln( Sm ) ;
    Answer := Subtract( Big, Sm ) ;
    Writeln ;
    Writeln( 'The answer is ', Answer, '.' ) ;
    Writeln ;
    Write( 'Again? ' ) ;
    Key := Readkey ;
  Until Upcase( Key ) = 'N' ;
  CloseAllWins ;
  GotoXY( 1, 25 ) ;
end.
