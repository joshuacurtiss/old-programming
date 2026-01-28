Program TimeDifferenceFunct ;

Uses DOS, CRT, Joshmohn ;

Type 	Time = Record
      	H, M, S, Hun:Word ;
			end ;

Var TimeIn, TimeOut:Time ;
    Key:Char ;

Function TimeDisp( h:Word ):String ;
Var Right:String ;
Begin
	Str( h, Right ) ;
	If h<10 then Right:='0'+Right ;
  TimeDisp := Right ;
end ;



Procedure PunchClock( Var TimeCard:Time ) ;
Begin
	With TimeCard do GetTime( h, m, s, hun ) ;
end ;

Function TimeDif( Start, Finish:Time ):String ; {Spits it out in minutes}
Var T, Sec, Min:Word ;
    i:Byte ;
    S, temp:String ;
{
		If (Hour=23) and (Hour2<23) then Inc( Hour2, 24 ) ;
    Inc( h2, 100*( (s2 - Sec) + 60*( m2 - Min + 60*(Hour2-Hour) ) ) ) ;
}
Begin
  Sec := 0 ;
  If ( Start.H=23 ) and ( Finish.H<23 ) then Inc( Finish.H, 24 ) ;
	Inc( Sec, (Finish.S-Start.S)+
				60*(Finish.M-Start.M+60*(Finish.H-Start.H)) ) ;
	T := Sec mod 60 ;
  Min := ( Sec - t ) div 60 ;
  Sec := t ;
  Str( min, temp ) ;
  s := Temp+':' ;
  Str( Sec, Temp ) ;
  If sec < 10 then Temp := '0'+Temp ;
  S := S + Temp ;
  TimeDif := s ;
end ;

Begin
	ClrScr ;
  WriteStr( 5, 5, 'Press a key to start clock.' ) ;
  Key := Readkey ;
	PunchClock( TimeIn ) ;
  With TimeIn do
  	WriteStr( 5, 6, TimeDisp(h)+':'+TimeDisp(m)+':'+TimeDisp(s) ) ;
  WriteStr( 8, 9, 'Now press a key to stop clock.' ) ;
  Key := Readkey ;
  PunchClock( TimeOut ) ;
  With TimeOut do
  	WriteStr( 8, 10, TimeDisp(h)+':'+TimeDisp(m)+':'+TimeDisp(s) ) ;
	WriteStr( 1, 15, 'The difference was '+TimeDif( TimeIn, TimeOut )+'.' ) ;
  Key := Readkey ;
end.