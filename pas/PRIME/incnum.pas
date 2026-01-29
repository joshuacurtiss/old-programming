Program Incage ;

Uses CRT, DOS, Joshmohn ;

Type 	JoshNumber 	= String ;
      NumType     = LongInt ;

Var nn, n:JoshNumber ;
    Slow, Quit:Boolean ;
    Key:Char ;
    Hour, Minute, Second, Hr, Min, Sec, Amanda:Word ;


Procedure IncNum( var Who:JoshNumber ) ;

Var a, b, j:Byte ;
    d:String[ 2 ] ;

Begin
  J := Length( Who ) ;
  a := Ord( Who[ j ] ) - 48 ;
  Inc( a ) ;
  If a > 9 then
  	Begin
      Insert( '0', Who, 1 ) ;
      Repeat
        b := Ord( Who[ j ] ) - 48 ;
        Inc( b ) ;
        Str( b, d ) ;
        Who[ j ] := d[ Length( d ) ] ;
        Str( a - 10, d ) ;
        Delete( Who, J+1, 1 ) ;
        Insert( d, Who, J+1 ) ;
				a := b ;
        Dec( j ) ;
      Until a < 10 ;
      If Who[ 1 ] = '0' then Delete( Who, 1, 1 ) ;
    end  {If more than 9}
  else
    n[ j ] := Chr( a + 48 ) ;
end ; {IncNum PROC}

Begin
	ClrScr ;
  Write( 'Start number at what?' ) ;
  Readln( n ) ;
  nn := n ;
  Quit := False ;
  Slow := False ;
  ClrScr ;
  GetTime( Hour, Minute, Second, Amanda ) ;
  Repeat
  	While keypressed do
    	Begin
      	Key := Readkey ;
        Case Upcase( Key ) of
        	' ':Key:=Readkey ;
          'Q', 'X':Quit:=True ;
        	'S', 'D':Slow := Not Slow ;
        end ;
      end ;

    IncNum( n ) ;

   	If Length( n ) < 75 then WriteStr( 1, 12, n )
    else
     	Begin
       	GotoXY( 1, 12 ) ;
        Write( n ) ;
      end ;
  	If Slow then ChillOut( 50 ) ;
  Until ( Length( n ) > 254 ) or Quit ;
	GetTime( Hr, Min, Sec, Amanda ) ;
  ClrScr ;
  Writeln( 'Incremented from ', nn, ' to ', n, '.' ) ;
  Writeln( 'Started at ',Hour,':',minute,':',second,'.' ) ;
  Writeln( 'Finished at ',Hr,':',min,':',sec,'.' ) ;
  Writeln ;
  Key := Readkey ;
end.
