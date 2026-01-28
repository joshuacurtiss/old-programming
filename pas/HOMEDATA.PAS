{Joshua Curtiss}

Program MyDataBase ;

Uses CRT, Graph, DOS ;

Type FigRecType = Record
			Name:String[ 40 ] ;
			Num:Integer ;
			Appearance:String[ 40 ] ;
			SideOfForce:String[ 5 ] ;
			Condition:Integer ;
			Active:Boolean ;
		end ;

Var	FigSize, Max, TotalInt, Rec, I, ProcINT, Howdy, Hi:integer;
		Fig:FigRecType ;
		TotalChar, tempchar:string[200] ;
		FigFile:File of FigRecType ;
		cursor, sure:boolean ;
		Choice, ProcChar:char ;

Procedure Menu ;
	begin
		ClrScr ;
		GotoXY( 10, 3 ) ;
		Writeln( 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿' ) ;
		For howdy:=4 to 23 do
			begin
				GotoXY( 10, howdy ) ;
				Writeln( '³                                                          ³' ) ;
			end ;
		Inc( howdy ) ;
		GotoXY( 10, howdy ) ;
		Writeln( 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ' ) ;
		GotoXY( 10, 5 ) ;
		Writeln( 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´' ) ;
		GotoXY( 28, 4 ) ;
		TextColor( magenta ) ;
		Writeln( 'Star Wars Action Figures' )  ;
		TextColor( white ) ;
		Howdy:=22 ;
		GotoXY( howdy, 9 ) ;
		Write( '1. Add an Action Figure' ) ;
		GotoXY( howdy, 12 ) ;
		Write( '2. Edit an Action Figure' ) ;
		GotoXY( howdy, 15 ) ;
		Write( '3. Delete an Action Figure' ) ;
		GotoXY( howdy, 18 ) ;
		Write( '4. Display an Action Figure' ) ;
		GotoXY( howdy, 21 ) ;
		Write( '5. Quit ' ) ;
	end  ;

Procedure Readint( x, linenum, lenstr:integer ) ;
	begin
		Totalint:=0 ;
		howdy:=0 ;             {Put in Backspace: Char  008}
		Repeat
			procchar:=readkey ;
			If ORD( ProcChar ) = 8 then
				begin
					dec(howdy);
					If Howdy < 0 then howdy := 0 ;
					TotalInt:=totalint div 10 ;
					GotoXY( x, linenum ) ;
					For I:=1 to lenstr do
						Write( ' ' ) ;
					GotoXY( x, linenum ) ;
					Write( totalint ) ;
					If Totalint<0 then Totalint:=0 ;
				end
			else
			If (ord(procchar)>47) and (ord(procchar)<58) then
				begin
					procint:=ord(procchar)-48 ;
					If howdy < lenstr then
						If (procint=1) or (procint=2) or (procint=3) or
							 (procint=4) or (procint=5) or (procint=6) or
							 (procint=7) or (procint=8) or (procint=9) or
							 (procint=0) then
							Begin
								Inc(howdy) ;
								GotoXY( x, linenum ) ;
								For I:=1 to lenstr do
									Write( ' ' ) ;
								totalint:=10*totalint + procint ;
								GotoXY( x, linenum ) ;
								Write( totalint ) ;
							end ;
				end ;
		Until ord(procchar)=13  ;
	end ; {READINT}

Procedure Readchar( x, linenum, lenstr:integer ) ;
	begin
		Totalchar:='' ;
		howdy:=0 ;             {Put in Backspace: Char  008}
		Repeat
			procchar:=readkey ;
			If ORD( ProcChar ) = 8 then
				begin
					dec(howdy);
					If Howdy<0 then Howdy:=0 ;
					Tempchar := '' ;
					For I:=1 to ( length( totalchar ) - 1 ) do
						Tempchar := Tempchar + totalchar[I] ;
					Totalchar:=tempchar ;
					GotoXY( x, linenum ) ;
					For I:=1 to lenstr do
						Write( ' ' ) ;
					GotoXY( x, linenum ) ;
					Write( totalchar ) ;
				end
			else
			If ( (ord(procchar)>96) and (ord(procchar)<123) ) or
				 ( (ord(procchar)>64) and (ord(procchar)<91 ) ) or
				 ( ord( procchar ) = 32 ) then
				begin
					If howdy < lenstr then
						Begin
							Inc(howdy) ;
							GotoXY( x, linenum ) ;
							For I:=1 to lenstr do
								Write( ' ' ) ;
							totalchar := totalchar + procchar ;
							GotoXY( x, linenum ) ;
							Write( totalchar ) ;
						end ;
				end ;
		Until ord(procchar)=13  ;
	end ; {READINT}

Procedure Hilite( x, linenum, Funct, Len:integer ) ;
	Begin
		Gotoxy( x, linenum ) ;
		If Funct=1
			then
				Textbackground( blue )
			else
				Textbackground( black ) ;
		For Hi:=1 to len do
			Write( ' ' ) ;
		Gotoxy( x, linenum ) ;
	End ;

Procedure ClearRecWin ;
	Begin
		For Howdy := 6 to 73 do
			For Hi := 11 to 16 do
				begin
					GotoXY( Howdy, Hi ) ;
					Write( ' ' ) ;
				end ;
	end ;

Procedure RecWin ;
	Begin
		GotoXY( 5, 10 ) ;
		Writeln( 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿' ) ;
		For Howdy:=11 to 16 do
			Begin
				GotoXY( 5, howdy ) ;
				Write( '³' ) ;
				GotoXY( 74, howdy ) ;
				Write( '³' ) ;
			End ;
		GotoXY( 5, 17 ) ;
		Writeln( 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ' ) ;
		ClearRecWin ;
	end ;

Procedure SureWin ;
	Begin
		GotoXY( 50, 15 ) ;
		Writeln( 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿' ) ;
		For Howdy:=16 to 21 do
			Begin
				GotoXY( 50, howdy ) ;
				Write( '³                         ³' ) ;
			End ;
		GotoXY( 50, 22 ) ;
		Writeln( 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ' ) ;
		GotoXY( 54, 17 ) ;
		Writeln( 'Are you sure?' ) ;
		Sure:=True ;
		GotoXY( 67, 20 ) ;
		Write( 'No' ) ;
		GotoXY( 57, 20 ) ;
		Write( 'Yes' ) ;
		Repeat
			If Sure = FALSE then
				begin
					Hilite( 66, 20, 1, 5 ) ;
					GotoXY( 67, 20 ) ;
					Write( 'No' ) ;
				end
			else
				begin
					Hilite( 56, 20, 1, 5 ) ;
					Gotoxy( 57, 20 ) ;
					Write( 'Yes' ) ;
				end ;
			GotoXY( 1, 1 ) ;
			Choice:=Readkey ;
			If ( Ord( Choice ) = 75 ) or ( Ord( Choice ) = 77 ) then
				begin
					If Sure = FALSE then
						begin
							Hilite( 66, 20, 2, 5 ) ;
							GotoXY( 67, 20 ) ;
							Write( 'No' ) ;
						end
					else
						begin
							Hilite( 56, 20, 2, 5 ) ;
							Gotoxy( 57, 20 ) ;
							Write( 'Yes' ) ;
						end ;
					Sure := NOT sure ;
				end ;
		Until Ord( Choice ) = 13 ;
		TextBackGround( Black ) ;
	end ;

Procedure DisplayRecDim( pos:integer ) ;
	begin
		Reset( FigFile ) ;
		FigSize:= filesize( figfile ) - 1 ;
		Seek( Figfile, pos ) ;
		Read( Figfile, fig ) ;
		With Fig do
			begin
				GotoXY( 32, 12 ) ;
				Write( name ) ;
				GotoXY( 32, 13 ) ;
				Write( num ) ;
				GotoXY( 32, 14 ) ;
				Write( Appearance ) ;
				GotoXY( 32, 15 ) ;
				Write( Condition ) ;
				GotoXY( 32, 16 ) ;
				Write( SideOfForce ) ;
			end ; {With Fig}
	End ; {DisplayRecDim Proc}

Procedure DisplayRecWin( Title:String ) ;
	Begin
		RecWin;
		GotoXY( 8, 12 ) ;
		Write( 'Name' ) ;
		GotoXY( 8, 13 ) ;
		Write( 'Number' ) ;
		GotoXY( 8, 14 ) ;
		Write( 'Appearances' ) ;
		GotoXY( 8, 15 ) ;
		Write( 'Condition (1-10)' ) ;
		GotoXY( 8, 16 ) ;
		Write( 'Side of Force' ) ;
		For howdy:=12 to 16 do
			begin
				GotoXY( 30, howdy ) ;
				Write( ':' ) ;
			end ;
		GotoXY( 40 - ( length( Title ) div 2 ), 11 ) ;
		Write( Title ) ;
	end ;

Procedure Add ;
	Begin
		DisplayRecWin( 'Add Records:' ) ;
		With Fig do
			begin
				Hilite( 32, 12, 1, 40 ) ;
				Readchar( 32, 12, 40 ) ;
				Name:=totalchar ;
				Hilite( 32, 12, 2, 40 ) ;
				Write( name ) ;
				Hilite( 32, 13, 1, 3 ) ;
				Readint( 32, 13, 3 ) ;
				Num:=totalint ;
				Hilite( 32, 13, 2, 3 ) ;
				Write( num ) ;
				Hilite( 32, 14, 1, 40 ) ;
				Readchar( 32, 14, 40 ) ;
				appearance:=totalchar ;
				Hilite( 32, 14, 2, 40 ) ;
				Write( appearance ) ;
				Hilite( 32, 15, 1, 2 ) ;
				Readint( 32, 15, 2 ) ;
				Condition:=totalint ;
				Hilite( 32, 15, 2, 2 ) ;
				Write( condition ) ;
				Hilite( 32, 16, 1, 5 ) ;
				Readchar( 32, 16, 5 ) ;
				sideofforce:=totalchar ;
				Hilite( 32, 16, 2, 5 ) ;
				Write( SideOfForce ) ;
			end ; {End The Fig Do}
			Write( FigFile, Fig ) ;
	End ;

Procedure MoveRec( Funct, HowManyTimes:integer ) ;
	begin
		For I := 1 to Howmanytimes do
			repeat
				If Funct>0 then Inc( Rec )
					else Dec( Rec ) ;
				If Rec>max then Rec:=Max ;
				If Rec<0 then Rec:=0 ;
				Reset( FigFile ) ;
				Seek( FigFile, Rec ) ;
				Read( FigFile, Fig ) ;
			until( Fig.Active=TRUE ) ;
	end ; {AdvanceRec Proc}

Procedure KillRec ;
	Begin
		Max:=Filesize( figfile ) -1 ;
		Repeat
			Menu ;
			RecWin ;
			DisplayRecWin( 'Delete Records' ) ;
			Rec := 0 ;
			Repeat
				DisplayRecDim( Rec ) ;
				GotoXY( 1, 1 ) ;
				Choice := Readkey ;
				Case Ord( Choice ) of
					72: MoveRec( -1, 1 ) ;
					80: MoveRec( 1, 1 ) ;
					73: MoveRec( -1, 10 ) ;
					81:	MoveRec( 1, 10 ) ;
				end ; {CASE}
			Until ( Upcase( Choice ) = 'D' ) or ( Ord( Choice ) = 27 );

			If Upcase( Choice ) = 'D' then
				begin
					SureWin ;
					If Sure = TRUE then
						Fig.Active := FALSE
					else
						Rec:=max+1 ;
				end ; {IF}
		Until( ( Rec>=0 ) and ( Rec<=max ) ) or ( Ord( Choice ) = 27 ) ;
	end ;

Procedure Edit ;

var n:integer ;

begin
	reset( figfile ) ;
	Repeat
		ClrScr ;
		Writeln( 'What number record would you like to edit?' ) ;
		Write( '(-1 for all, ',filesize(figfile)-1,' max.) ' ) ;
		Readln( n ) ;
		If (n<-1) or (N>=filesize(figfile)) then write( chr(7) ) ;
	until( N>=-1 ) and (n<filesize( figfile )) ;
	repeat
		if n<>-1 then
			begin
				seek( figfile, n ) ;
				Read( figfile, fig ) ;
			end
			else if filepos( figfile ) < filesize( figfile )
						 then read( figfile, fig ) ;
		ClrScr ;
		Writeln( 'Record Number ', filepos( figfile ) -1 ) ;
		Writeln( '1: ',fig.name ) ;
		Writeln( '2: ',fig.num ) ;

		{ETC...}

		Writeln( 'Which item do you want to change? ' ) ;
		Readln( choice ) ;

		Case choice of
			'1': Readln( fig.name ) ;
			'2': Readln( fig.num ) ;

			{ETC...}

		end ; {case}

		Seek( figfile, filepos( figfile ) - 1 ) ;
		Write( Figfile, fig ) ;

		If n = -1 then
			begin
				Writeln( 'Would you like to edit another record? ' ) ;
				Repeat
					choice:=readkey ;
					If ( upcase(choice) <> 'N' ) and ( upcase(choice) <> 'Y' ) then
						Write( CHR(7) ) ;
				Until( Upcase(choice) = 'N' ) or ( Upcase(choice) = 'Y' ) ;
			end ;

	Until( Upcase(choice)='N' ) or ( N<>-1 ) ;
end ; {Edit Proc}

begin
	textbackground( black ) ;
	TextColor( white ) ;
	Assign( FigFile, 'c:\JCFigs.rec' ) ;
	{$I-}
	Reset( FigFile ) ;
	If IOResult <> 0 then
		Rewrite( FigFile ) ;
	{$I+}
	repeat ;
		Menu ;
		GotoXY( 1, 1 ) ;
		Choice := ReadKey ;
		Case Choice of
			'1': Add ;
			'2': ;
			'3': KillRec ;
			'4': {ViewRecs} ;
		end ; {case}
	Until ( Choice = '5' ) or ( UPCASE( Choice ) = 'Q' ) ;

	{Notes:														 	  	}
	{   Seek( Filename, Position ) ;      	}
	{   Seek( CardsFile, 0 ) ;					  	}
	{		Read( CardFile, Card ) ;				  	}
	{		Write( Card.name ) ;              	}
	{			-------------									  	}
	{		NumRecs := Filesize( Cardsfile ) ; 	}
	{		Truncate( Cardsfile ) ; 				  	}

end.
