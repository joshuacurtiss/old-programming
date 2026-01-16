Program ShowTime ;

Uses dos, crt ;

Var Hour, Min, Sec, Hun:Word ;
		pm:Boolean ;
		Colon:Char ;
    x, y:byte ;

Begin
  pm:=false ;
	y:=wherey ;
  x:=1 ;
  If y<24 then Inc( y )
  else x:=Wherex + 5 ;
  If x>70 then x:=1 ;
	GetTime( Hour, Min, Sec, Hun ) ;
	Colon := ':' ;
  If hour=0 then hour:=12 ;
  If hour>12 then
  	Begin
			Hour:=Hour - 12 ;
			pm:=TRUE ;
    end;
	GotoXY( x, y ) ;
	Write( Hour, colon ) ;
	If Min<10 then Write( '0', Min )
		else Write( min ) ;
	If sec<10 then Write( colon, '0', sec )
		else Write( colon, sec ) ;
	If pm=True then Write( ' pm.' )
		else Write( ' am.' )
end.