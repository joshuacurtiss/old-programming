Program ASCIIShow ;

Uses CRT, ZakMohn ;

Var Key:Char ;
		num:Integer ;
		Funct, SpecKey:Boolean ;

Begin
	InitWins ;
  WinUp( 30, 10, 50, 12 ) ;
	Key:='A' ;
  Repeat
		GotoXY( 35, 11 ) ;
    If Funct then
     	begin
		    Write( Key ) ;
		    GotoXY( 42, 11 ) ;
		    If SpecKey then Write( '#' ) ;
				Num:=Ord( Key ) ;
				Write( Num, '   ' ) ;
      end
    else
     	begin
       	Write( Chr( Num ), ' ' ) ;
        GotoXY( 42, 11 ) ;
        Write( Num, '   ' ) ;
      end ;
    GotoXY( 35, 11 ) ;
    Key:=Readkey ;
    If Key=#0 then
			begin
				Key:=Readkey ;
        SpecKey:=True ;
      end
    else SpecKey:=False ;
		If Key=#13 then Funct:=not funct ;
    If Not Funct then
     	Case key of
       	UpArrow:Inc( num ) ;
        DownArrow:Dec( num ) ;
      end ; {CASE}
  Until ( Key = #27 ) ;
  WinDown ;
  GotoXY( 1, 25 ) ;
end .
