Program Color ;

Uses CRT ;

Var Col:Byte ;
    Key:Char ;

Begin
  Col:=0 ;
  Repeat
    TextBackground( col ) ;
    ClrScr ;
    GotoXY( 39, 12 ) ;
    TextBackground( Black ) ;
    Write( '  ', Col, '  ' ) ;
    Inc( Col ) ;
    Key := Readkey ;
  Until Upcase( key ) = 'X' ;
end.