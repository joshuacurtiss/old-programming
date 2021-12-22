Program Funny ;

Uses CRT, DOS ;

Var P, C:String ;
    y, i:Byte ;
    Okay:Boolean ;

Begin {$M 8192, 0, 0}
  ClrScr ;
  Y:=0 ;
  Repeat
    Inc( y ) ;
    GetDir( 0, p ) ;
    GotoXY( 1, y ) ;
    Write( p, '>' ) ;
    C := 'Blah' ;
    Okay:=True ;
    Readln( C ) ;
    For I:=1 to Length( c ) do C[i] := Upcase( C[i] ) ;
    If ( C = 'STOP' ) or ( C = 'BLAH' ) then Okay:=False ;
    If Copy( C, 1, 6 ) = 'SAY HI' then
      Begin
        Writeln ;
        Writeln( 'Well, Hi!' ) ;
        Inc( y ) ;
        Okay := False ;
      end ;
    If Length( C ) = 0 then Okay := false ;
    If Okay then
      Begin
        C := '/C ' + C ;
        SwapVectors;
        Exec(GetEnv('COMSPEC'), C ); {Temporarily exit and go to}
        SwapVectors;                      {the other program}
      end ;
    Y:=WhereY ;
    If Y>24 then Dec( y ) ;
  Until ( C = 'STOP' ) ;
end.