Program DisplayCheck ;

Uses CRT ;

Var SayWhat:String ;
    Left, Right:Byte ;
    Whazzap:Char ;

Function CropToFit( Width:Byte ; Message:String ):String ;

Var I, Cut:Byte ;
    NewMessage:String ;

Begin
  NewMessage:=Message ;
  i := Length( Message ) ;
  If i > Width then
    Begin
      Cut := Width Div 2 ;
      Delete( NewMessage, Cut, i - Width + 3 ) ;
      Insert( '...', NewMessage, Cut ) ;
    end ;
  CropToFit := NewMessage ;
end ;

Begin
  Repeat
    Clrscr ;
    Writeln( 'Okay, say what?' ) ;
    Writeln ;
    Readln( SayWhat ) ;
    Writeln ;
    Write( 'Start where? ' ) ;
    Readln( Left ) ;
    Write( 'End where? ' ) ;
    Readln( Right ) ;
    Writeln ;
    GotoXY( Left, 15 ) ;
    Writeln( CropToFit( Right+1-Left, SayWhat ) ) ;
    Writeln ;
    Write( 'Press a key...' ) ;
    Whazzap := Readkey ;
  Until Upcase( Whazzap ) = 'Q' ;
end.
