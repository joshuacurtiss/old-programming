Unit TimeUnit ;

Interface

Uses DOS, Joshmohn ;

Type	Time = Record
				H, M, S, Hun:Word ;
			end ;

      Date = Record
      	Y, M, D, DOY:Word ;
      end ;


Procedure PunchClock( Var TimeCard:Time ) ;
Procedure PunchDate( Var DateCard:Date ) ;
Function zCheck( Amanda:Word ):String ;
Function MinDifStr( Start, Finish:Time ):String ; {Spits it out in minutes}
Function SecDif( Start, Finish:Time ):Word ;


Implementation

Procedure PunchDate( Var DateCard:Date ) ;
Begin
	With DateCard do
  	GetDate( y, m, d, doy ) ;
end ;

Function zCheck( Amanda:Word ):String ;
Var Right:String ;
Begin
	Str( Amanda, Right ) ;
  If Amanda<10 then Right := '0'+Right ;
  zCheck := Right;
end ;

Procedure PunchClock( Var TimeCard:Time ) ;
Begin
	With TimeCard do GetTime( h, m, s, hun ) ;
end ;

Function SecDif( Start, Finish:Time ):Word ; {Spits out second difference}
Var Sec:Word ;
Begin
  Sec := 0 ;
  If ( Start.H=23 ) and ( Finish.H<23 ) then Inc( Finish.H, 24 ) ;
	Inc( Sec, (Finish.S-Start.S)+
				60*(Finish.M-Start.M+60*(Finish.H-Start.H)) ) ;
	SecDif := Sec ;
end ; {SecDif FUNCTION}

Function MinDifStr( Start, Finish:Time ):String ; {Spits it out in minutes}
Var T, Sec, Min:Word ;
    i:Byte ;
    S, temp:String ;
Begin
  Sec := SecDif( Start, Finish ) ;
	T := Sec mod 60 ;
  Min := ( Sec - t ) div 60 ;
  Sec := t ;
  Str( min, temp ) ;
  s := Temp+':' ;
  S := S + zCheck( Sec ) ;
  MinDifStr := s ;
end ;

end.