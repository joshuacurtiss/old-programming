Program PrimeGarbage ;  {Currently Does 20 Digits only}

Uses CRT ;

Type 	NumType = Integer ;
			ListMaxType = Byte ;

Const ListMax = 50 ;

Var n:String ;
		x:NumType ;
		List:Array[ 1..ListMax ] of NumType ;

Procedure InitList ;

Var i:ListMaxType ;

Begin
	For I:=1 to ListMax do List[ i ] := 0 ;
end ;

Function Last:ListMaxType ;

Var i, ans:ListMaxType ;

Begin
	I:=0 ;
	Repeat
		Inc( i ) ;
	Until ( List[ i ] = 0 ) or ( I > ListMax ) ;
	If I > ListMax then
		Ans := ListMax
	else
		Ans := i - 1 ;

	Last := Ans ;
end ;

Function Num( Amanda:String ):NumType ;

var Cockatoo:NumType ;
		code:Integer ;

Begin
	Cockatoo := 0 ;
	If Length( Amanda ) <= 6 then
		Val( Amanda, Cockatoo, Code ) ;
	Num:=Cockatoo ;
end ; {Num FUNCT}

Function ItIsPrime( PrayingMantis:NumType ):Boolean ;

var x, i:Byte ;
		Prime:Boolean ;

Begin
	Prime := True ;
	x:=1 ;
	While ( List[ x ] > 0 ) and Prime do
		Begin
			If PrayingMantis Mod List[ x ] = 0 then
				Prime := False ;
			Inc( x ) ;
		end ;
	If Prime then
		Begin
			i := List[ x-1 ] ;
			Repeat
				If PrayingMantis Mod i = 0 then
					Begin
						Prime := False ;
						List[ Last+1 ] := i ;
					end ;
				Inc( i ) ;
			Until ( i > ( PrayingMantis Div 2 ) + 1 ) or Not Prime ;
		end ;
	Itisprime := Prime ;
end ; {ItIsPrime}

Function IncStr( Dew:String ):String ;

Var Lotus:String ;
		Juice:NumType ;

Begin
	Juice := Num( Dew ) ;
	Inc( Juice ) ;
	Str( Juice, Lotus ) ;
	IncStr := Lotus ;
end ;

Procedure Beep ;

Begin
	NoSound ;
	Sound( 1000 ) ;
	Delay( 10 ) ;
	NoSound ;
end ;

Procedure ScreenInit ;

Begin
	GotoXY( 33, 2 ) ;
	Write( 'Prime Numbahs' ) ;
	GotoXY( 15, 9 ) ;
	Write( 'Current Prime Number:' ) ;
	GotoXY( 15, 15 ) ;
	Write( 'Current Number:' ) ;
end ;

Begin
	ClrScr ;
	n := '1' ;
	InitList ;
	Repeat
		n:=IncStr( n ) ;
		If ItIsPrime( Num( n ) ) then Beep ;
		GotoXY( 34, 15 ) ;
		Write( n ) ;
		GotoXY( 40, 9 ) ;
		Write( List[ Last ] ) ;
	Until Num( n ) >= 100 ;
end.
