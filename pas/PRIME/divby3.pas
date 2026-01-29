Program DivByThree ;

Uses CRT, Joshmohn ;

Var n:String[ 10 ] ;
		List, SumList:Array[ 1..20 ] of String[ 10 ] ;
    ListPos:Byte ;
    Key:Char ;
    TimeToQuit:Boolean ;


Procedure Beep ;

Begin
	NoSound ;
  Sound( 700 ) ;
  Delay( 100 ) ;
  NoSound ;
end ; {Beep PROC}


Function Value( Joos:String ):Integer ;

Var Dirt, c:Integer ;

Begin
	Val( Joos, Dirt, c ) ;
  If c <> 0 then Beep ;
  Value := Dirt ;
end ; {Value FUNCTION}

Function Sum:Integer ;

Var q:Integer ;
    i:Byte ;

Begin
  q := 0 ;
	For i:=1 to Length( n ) do
		Inc( q, Value( n[ i ] ) ) ;
  Sum := q ;
end ; {Sum FUNCT}


Function Quote:String ;

Var Amanda:String ;

Begin
	Str( Sum, Amanda ) ;
  Quote := Amanda ;
end ;


Procedure DisplayList ;

Var i:Byte ;

Begin
	If ListPos < 24 then
  	Begin
			WriteStr( 47, ListPos, n ) ;
      WriteStr( 57, ListPos, Quote ) ;
    end
  else
    For i:=5 to 24 do
    	Begin
      	WriteStr( 57, i, '     ' ) ;
        WriteStr( 57, i, SumList[ i-4 ] ) ;
	     	WriteStr( 47, i, List[ i-4 ] ) ;
      end ;
end ; {DisplayList PROC}

Procedure AddToList ;

var x:Byte ;

Begin
	Inc( ListPos ) ;
  If ListPos > 24 then
  	Begin
      For x := 1 to 19 do
      	Begin
          SumList[ x ] := SumList[ x + 1 ] ;
	      	List[ x ] := List[ x + 1 ] ;
      	end ;
    	ListPos := 24 ;
    end ;
  List[ ListPos-4 ] := n ;
  SumList[ ListPos-4 ] := Quote ;
end ; {AddToList PROC}


Procedure IncNum ;

Var Code, d:Integer ;

Begin
	Val( n, d, code ) ;
  If Code <> 0 then Beep ;
  Inc( d ) ;
  Str( d, n ) ;
end ; {IncNum PROC}


Begin
  InitWins ;
  WinUp( 1, 1, 80, 25 ) ;
	ClrScr ;

  ListPos := 4 ;
  TimeToQuit := False ;
  n := '1' ;
  WriteStr( 29, 1, 'Numbahs Divisable by 3' ) ;
  WriteStr( 47, 3, 'Number     Sum' ) ;
  WinUp( 45, 4, 55, 25 ) ;
	WinUp( 55, 4, 65, 25 ) ;                      {LIST: 5-24}
  WriteStr( 13, 12, 'Current Number:' ) ;
  Beep ;

  Repeat
  	WriteStr( 30, 12, n ) ;
    If Value( n ) mod 3 = 0 then
    	Begin
      	If Sum Mod 3 = 0 then
        	Begin
		      	AddToList ;
		        DisplayList ;
          end
        else
        	Begin
          	Beep ;
            Beep ;
            Key := Readkey ;
            If Key = #0 then Key := Readkey ;
          end ;
      end ;
    IncNum ;
  	If Keypressed then
    	Begin
      	Key := Readkey ;
        If Key = #0 then Key := Readkey ;
        If Key = Esc then TimeToQuit := True ;
        If Key = ' ' then Repeat Until Keypressed ;
      end ;
  Until ( Value( n ) > 32760 ) or TimeToQuit ;
  Beep ;
	CloseAllWins ;
  Beep ;
end.