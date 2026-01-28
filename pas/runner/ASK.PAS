Program AskAboutCD ;

Uses CRT, DOS, ZakMohn ;

Var Key:Char ;
		TheySaidYes:Boolean ;
    y:Byte ;

{$M 8192,0,0}

Begin
	Y:=WhereY ;
	InitWins ;
	WinUp( 25, 10, 60, 15 ) ;
	WriteStr( 28, 11, 'Will you use the CD today?' ) ;
  Gotoxy( 1, 13 ) ;
	WriteCenter( 'Sure, I''ll use it.' ) ;
  Gotoxy( 1, 14 ) ;
	WriteCenter( 'No, Not Today.' ) ;
	TheySaidYes:=True ;
	Repeat
		Hilite( 25, 13, Black, 35 ) ;
		Hilite( 25, 14, Black, 35 ) ;
		If TheySaidYes then Hilite( 26, 13, Blue, 34 )
		else Hilite( 26, 14, Blue, 34 ) ;
		Key:=Readkey ;
		If Key=#0 then Key:=Readkey ;
		If ( Key = UpArrow ) or ( Key = DownArrow )
			then TheySaidYes := NOT TheySaidYes
		else
			Begin
				NoSound ;
				Sound( 5000 ) ;
				Delay( 15 ) ;
				NoSound ;
			end ;
	Until ( Key = #13 ) or ( Key = #27 ) ;
	WinDown ;
  GotoXY( 1, y ) ;
  If Key = #27 then TheySaidYes := False ;
	If TheySaidYes then
		Begin
			SwapVectors;
			Exec(GetEnv('COMSPEC'), '/C mscdex /d:cdrom$$$ /l:f' );
			SwapVectors;
		end ;
end.