Program ScrollDaCreditz ;

Uses CRT, Joshmohn ;

Const Deactivated = 432 ;
			Started = 229 ;

      Message:Array[ 1..5 ] of String =

			 ( '****   *       *    *   *  *     ',
			   '*  **  *      * *   *   *  *     ',
			   '****   *     *   *  *****  *     ',
			   '*  **  *     *****  *   *        ',
			   '****   ****  *   *  *   *  *     ' ) ;

Var Creditz:Integer ;
    Condition, ScrollPos:Byte ;

Procedure NoCredits ;
Begin
	Creditz := Deactivated ;
end ; {NoCredits PROC}



Procedure CreditScroll ;

Var x, y:Byte ;

Begin
	If ( Condition <> Started ) or ( ScrollPos > Length( Message[1] ) ) then
    Begin
    	Condition := Started ;
			ScrollPos := 1 ;
    end ;
  For y := 10 to 14 do
  	For x := 1 to 79 do
    	WriteChar_A( x, y, GetChar( x, y ), GetChar_A( x+1, y ) ) ;
  For y := 10 to 14 do
  	If Message[ y-9 ][ ScrollPos ] = '*' then HiLite( 80, y, Red, 1 )
    else HiLite( 80, y, Black, 1 ) ;
	Inc( ScrollPos ) ;
end ; {CreditScroll PROC}



Begin
  Repeat
		If Creditz <> Deactivated then CreditScroll ;
  Until Keypressed ;
end.