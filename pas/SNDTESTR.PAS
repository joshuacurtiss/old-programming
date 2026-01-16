Program Sndr ;

Uses CRT, ZakMohn;

Var T:Integer ;
		Key:Char ;

Begin
  ClrScr ;
	T:=5000 ;
	Repeat
    GotoXY( 10, 7 ) ;
    Write( 'Tone Level: ', t div 100, '.     ' ) ;
		Sound( t ) ;
		Delay( 1 ) ;
		NoSound ;
		Key:=Readkey ;
    If Key=#0 then Key:=Readkey ;
    Case Key of
    	#72:Inc( t, 100 ) ;
      #80:Dec( t, 100 ) ;
      PgUp:Inc( t, 1000 ) ;
      PgDn:Dec( t, 1000 ) ;
    end ;
    If t<0 then t:=0
    else if t>15000 then t:=15000 ;
	Until ( Key = #13 ) or ( Key = #27 ) ;
end .
