Unit IncUnit ;    {Version of Juice!}

Interface

Procedure IncNum( var Who:String ) ;


Implementation

Procedure IncNum( var Who:String ) ;

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
    Who[ j ] := Chr( a + 48 ) ;
end ; {IncNum PROC}

end.