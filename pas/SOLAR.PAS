{Joshua Curtiss}

Program SolarBase ;

Uses CRT, Graph, DOS ; {Must change it to MSGraph at skool}

CONST
	UpArrow   = #72;  DownArrow  = #80;
	LeftArrow = #75;  RightArrow = #77; {Handy-dandy constants.}
	PgUp      = #73;  PgDn       = #81;

Type FigRecType = Record
			Name:String[ 40 ] ;
			Num:Integer ;
			Appearance:String[ 40 ] ;
			SideOfForce:String[ 5 ] ;
			Condition:Integer ;
			Active:Boolean ;
		end ;

Var	FigSize, Max, TotalInt, Rec, I, ProcINT, Howdy, Hi:integer;
		Fig, temp:FigRecType ;
		Pref:Array[ 1..3 ] of byte ;
		TotalChar, tempchar:string[200] ;
		FigFile, tempfile:File of FigRecType ;
		Preffile:file of byte ;
		cursor, sure:boolean ;
		Choice, ProcChar:char ;

Procedure SavePref( by1, by2, by3:byte ) ;

	begin
		Rewrite( preffile ) ;
		Write( preffile, By1 ) ; {Erase prefs and rewrite them}
		Write( preffile, By2 ) ;
		Write( preffile, By3 ) ;
		Close( prefFile ) ;
	end ;

Procedure GetPref( By1, by2, by3:byte ) ;

	begin
		Reset( prefFile ) ;
    If Filesize( PrefFile ) > 0 then
      begin
        Reset( Preffile ) ;
		    Read( prefFile, by1 ) ;  {Load up prefs}
		    Read( prefFile, by2 ) ;
		    Read( prefFile, by3 ) ;
      end ;
		Close( prefFile ) ;
	end ;

Procedure Switch( k, j:integer ; Cardk, cardj:Figrectype ) ;
	begin
		seek( figfile, k ) ;
		Write( figfile, cardj ) ;  {Switch two recs in the file.}
		Seek( figfile, j ) ;
		Write( figfile, cardk ) ;
	end ; {Switch Proc}

Function Comp( Rec1, Rec2:FigRecType; By:Integer ) : Integer ;
	Var A:Integer ;
	Begin
		A:=0 ;
		If by=0 then
			begin
				Comp:=a ;     {Compares to recs}
				exit ;
			end ;
		Case By of
			1:If Rec1.name > Rec2.Name then a:=1 {Comp. by name. A:=1 if switch}
				else If Rec1.name = Rec2.name then a:=2 ; {A:=2 if no switch}
			2:If Rec1.Num > Rec2.num then a:=1 {Compare by number}
				else if Rec1.num = rec2.num then a:=2 ;
			3:If rec1.sideofforce > Rec2.sideofforce then a:=1 {compare by side}
				else if Rec1.sideofforce = rec2.sideofforce then a:=2 ;
			4:If rec1.condition < Rec2.Condition then a:=1 {Compare by condition}
				else If rec1.condition = rec2.condition then a:=2 ;
		end ; {case}
		Comp:=a ; {Output what needs to be done}
	end ; {Comp funct}

Procedure MoveRec( Funct, HowManyTimes:integer; Con:Boolean) ;
	begin    {A VERY important procedure!}
		max:=filesize(figfile)-1;
		For I := 1 to Howmanytimes do {Move forwd or bkwd HowManyTimes?}
			repeat
				If Funct>0 then Inc( Rec ) {If positive, advance rec}
					else Dec( Rec ) ;        {If negative, go backward}
				If Rec>max then Rec:=Max ; {If you max out, go no further!}
				If Rec<0 then Rec:=0 ;     {Don't go negative recs!}
				Reset( FigFile ) ;
				Seek( FigFile, Rec ) ; {Check rec for its active condition, whichever}
				Read( FigFile, Fig ) ; {one you need. If it isn't what you want, it}
			until( Fig.Active=con ) or ( Rec >= max ) or ( Rec <= 0 ) ; {doesn't }
		If Rec>Max then Rec:=max ; {Don't max!}          {Count. Try Again!!!!!}
		Seek( Figfile, rec ) ;
		Read( Figfile, fig ) ;
		If Fig.active <> Con then
			repeat
				If Funct<0 then Inc( Rec ) {If you reach end or beg of file and don't}
				else Dec( Rec ) ;          {find what you want, find the first one}
				Seek( Figfile, rec ) ;     {that's good.}
				Read( Figfile, fig ) ;
		Until( Fig.Active=con ) or ( Rec<=0 ) or ( Rec>=max ) ;
	end ; {MoveRec Proc}

Procedure Menu ;
	begin
		ClrScr ;
		GotoXY( 10, 3 ) ;
		Writeln( 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿' ) ;
		For howdy:=4 to 23 do
			begin
				GotoXY( 10, howdy ) ;     {  Make a box  }
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
		Howdy:=22 ; Hi:=7 ; {Allows one to easilly change position}
		GotoXY( howdy, hi ) ;
		Write( '1. Add an Action Figure' ) ;
		GotoXY( howdy, hi+2 ) ;
		Write( '2. Edit an Action Figure' ) ;
		GotoXY( howdy, hi+4 ) ;
		Write( '3. Delete an Action Figure' ) ;
		GotoXY( howdy, hi+6 ) ;
		Write( '4. Display an Action Figure' ) ;
		GotoXY( howdy, hi+8 ) ;
    Write( '5. Ressurect a Deleted Figure' ) ;
    GotoXY( howdy, hi+10 ) ;
    Write( '6. Sort Action Figures' ) ;
    Gotoxy( howdy, hi+12 ) ;
    Write( '7. Configure Sort Priorities' ) ;
    GotoXY( howdy, hi+14 ) ;
    Write( '8. Purge Deleted Figures' ) ;
    GotoXY( howdy, hi+16 ) ;
		Write( 'Q. Quit ' ) ;
	end  ;

Procedure Readint( x, linenum, lenstr, Prev:integer ) ;
	begin    {SOOOOOO very important procedure!!!}
		Totalint:=prev ; {To Edit a previous value.}
		If Prev<1 then howdy:=0
		else if prev<10 then howdy:=1 {determine how many keys were pressed}
				 else if prev<100 then howdy:=2  {to get the number you have}
							else if prev<1000 then howdy:=3
									 else if prev<10000 then howdy:=4
												else if prev<100000 then howdy:=5
														 else if prev<1000000 then howdy:=6 ;
		GotoXY( x, linenum ) ;
		If Totalint <> 0 then Write( Totalint ) ; {Do not write zero}
		Repeat
			procchar:=readkey ;
			If ORD( ProcChar ) = 8 then   {To Backspace:}
				begin
					dec(howdy); {One less keystroke}
					If Howdy < 0 then howdy := 0 ; {No neg keystrokes!}
					TotalInt:=totalint div 10 ; {Remove the ones digit.}
					GotoXY( x, linenum ) ;
					For I:=1 to lenstr do
						Write( ' ' ) ;      {Rewrite screen}
					GotoXY( x, linenum ) ;
					If Totalint <> 0 then Write( totalint ) ;     {No zeroes}
					If Totalint<0 then Totalint:=0 ;     {No negs!}
				end
			else
			If (ord(procchar)>47) and (ord(procchar)<58) then {To type numbers}
				begin
					procint:=ord(procchar)-48 ;    {Get values of num}
					If howdy < lenstr then
						If (procint=1) or (procint=2) or (procint=3) or
							 (procint=4) or (procint=5) or (procint=6) or
							 (procint=7) or (procint=8) or (procint=9) or
							 (procint=0) then
							Begin
								Inc(howdy) ; {+keystrokes}
								GotoXY( x, linenum ) ;
								For I:=1 to lenstr do
									Write( ' ' ) ;  {Erase old}
								totalint:=10*totalint + procint ; {Add num to end of old num}
								GotoXY( x, linenum ) ;
								If Totalint <> 0 then Write( totalint ) ;{Rewrite. No 0's}
							end ;
				end ;
		Until ord(procchar)=13  ;   {Press return to finish}
	end ; {READINT}

Procedure Readchar( x, linenum, lenstr:integer; entry:string ) ;
	begin                          {Similar to readint}
		Totalchar:=entry ;           {Refer to readint if no comment}
		howdy:=length( entry ) ;
		GotoXY( x, linenum ) ;
		Write( TotalChar ) ;
		Repeat
			procchar:=readkey ;
			If ORD( ProcChar ) = 8 then
				begin
					dec(howdy);
					If Howdy<0 then Howdy:=0 ;
					Tempchar := '' ;
					For I:=1 to ( length( totalchar ) - 1 ) do {Get all chars of string}
						Tempchar := Tempchar + totalchar[I] ;    {Except last one}
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
				 ( (ord(procchar)>47) and (ord(procchar)<58 ) ) or
				 ( ord( procchar ) = 32 ) then
				begin
					If howdy < lenstr then
						Begin
							Inc(howdy) ;
							GotoXY( x, linenum ) ;
							For I:=1 to lenstr do
								Write( ' ' ) ;
							totalchar := totalchar + procchar ; {Add char to string}
							GotoXY( x, linenum ) ;
							Write( totalchar ) ;
						end ;
				end ;
		Until ord(procchar)=13  ;
	end ; {READINT}

Procedure Hilite( x, linenum, Funct, Len:integer ) ;

	Var A:Integer ;

	Begin
		For A:=1 to len do
			if Funct=1 then  {To HIGHLIGHT}
				begin
					Mem[ $B800:( (linenum-1)*80+x+a-2 )*2+1 ] := Blue*16 + White ;
					TextBackground( Blue ) ;   {Alter screen values}
				end
			else
				begin          {To unhighlight}
					Mem[ $B800:( (linenum-1)*80+x+a-2 )*2+1 ] := White ;
					TextBackground( Black ) ;  {Alter screen values}
				end ;
	End ;

Procedure ClearRecWin ;
	Begin
		For Howdy := 6 to 73 do
			For Hi := 11 to 16 do      {Clear out all recwins}
				begin                    {Used by recwin and errorwin}
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
				Write( '³' ) ;    {Draw a big ol' window}
				GotoXY( 74, howdy ) ;
				Write( '³' ) ;
			End ;
		GotoXY( 5, 17 ) ;
		Writeln( 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ' ) ;
		ClearRecWin ;
	end ;

Procedure SureWin ;          {An 'Are You sure?' Window}
	Begin                      {What do you expect? I'm a MacUser.}
		GotoXY( 50, 15 ) ;
		Writeln( 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿' ) ;
		For Howdy:=16 to 21 do
			Begin
				GotoXY( 50, howdy ) ;                        {Draw da Window}
				Write( '³                         ³' ) ;
			End ;
		GotoXY( 50, 22 ) ;
		Writeln( 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ' ) ;
		GotoXY( 54, 17 ) ;
		Writeln( 'Are you sure?' ) ;
		Sure:=false ;                  {Default:='No'}
		GotoXY( 67, 20 ) ;
		Write( 'No' ) ;
		GotoXY( 57, 20 ) ;
		Write( 'Yes' ) ;
		Repeat
			If Sure = FALSE then       {Hilight 'No'}
				Hilite( 66, 20, 1, 5 )
			else
				Hilite( 56, 20, 1, 5 ) ;  {Hilight 'Yes'}
			GotoXY( 1, 1 ) ;
			Choice:=Readkey ;
			Hilite( 56, 20, 2, 16 ) ;   {Erase all hilights}
			If ( Ord( Choice ) = 75 ) or ( Ord( Choice ) = 77 ) then
				Sure := NOT sure ;      {If arrows, switch to other.}
		Until Ord( Choice ) = 13 ;
		TextBackGround( Black ) ;
	end ;

Procedure DisplayRecDim( pos:integer ; con:boolean ) ;
	begin      {Another VITAL Proc}
		If Filesize( Figfile ) = 0 then Fig.active:=NOT Con
		else                  {If File=empty, trick computer into}
			begin               {NOT reading or displaying anything}
				Reset( FigFile ) ;
				FigSize:= filesize( figfile ) - 1 ;
				Seek( Figfile, pos ) ;
				Read( Figfile, fig ) ;
			end ;
		If Fig.Active = Con then
			With Fig do
				begin
					GotoXY( 32, 12 ) ;
					Write( '                                        ' ) ;
					GotoXY( 32, 12 ) ;
					Write( name ) ;       {If the record is in the correct}
					GotoXY( 32, 13 ) ;    {active form, then display its  }
					Write( '   ' ) ;      {dimensions in the proper spots.}
					GotoXY( 32, 13 ) ;
					Write( num ) ;
					GotoXY( 32, 14 ) ;
					Write( '                                        ' ) ;
					GotoXY( 32, 14 ) ;
					Write( Appearance ) ;
					GotoXY( 32, 15 ) ;
					Write( '      ' ) ;
					GotoXY( 32, 15 ) ;
					Write( Condition ) ;
					GotoXY( 32, 16 ) ;
					Write( '       ' ) ;
					GotoXY( 32, 16 ) ;
					Write( SideOfForce ) ;
				end ; {With Fig}
	End ; {DisplayRecDim Proc}

Procedure DisplayRecWin( Title:String ) ;
	Begin
		RecWin;              {Draw RecWin}
		GotoXY( 8, 12 ) ;    {Along with categories.....}
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
		Write( Title ) ;        {....And a centered title.}
	end ;

Procedure ErrorWin( Message, PrevWinTitle:STRING ) ;
	begin
		GotoXY( 11, 12 ) ;
		Write( 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿' ) ;
		For Howdy:=13 to 14 do
			begin
				GotoXY( 11, howdy ) ;   {Draw Box}
				Write( '³                                                ³' ) ;
			end ;
		GotoXY( 11, 15 ) ;
		Write( 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ' ) ;
		GotoXY( 13, 13 ) ;
		Write( Message ) ; {Write whatever message you send the proc}
		Hilite( 44, 14, 1, 6 ) ;
		GotoXY( 45, 14 ) ;
		Write( 'Okay' ) ; {An 'Okay' Button. Long live the Mac!}
		Repeat
			Choice:=Readkey ;
		Until ( Ord( Choice ) = 13 ) ;  {Must push the CR}
		Hilite( 44, 14, 2, 6 ) ;
		If PrevWinTitle <> '' then         {Will erase itself if a RecWin}
			DisplayRecWin( PrevWinTitle ) ;  {was underneath.}
	end ; {ErrorWinProc}

Procedure Sort( By1, By2, By3:Integer ) ;

	Var Rec1, Rec2:FigRecType ;         {With much help from M.K.!}
			a, b, c, d, e:integer ;

	Begin
		For A:=0 to ( Filesize( Figfile ) -1 ) do
			begin
				C:=A ;
				Seek( Figfile, C ) ;
				Read( Figfile, Rec1 ) ;
				D := A + 1 ;
				If D =  Filesize( Figfile ) then exit ;
				Seek( Figfile, d ) ;
				Read( Figfile, Rec2 ) ;
				E:=Comp( Rec1, Rec2, By1 ) ;      {Read two recs and compare}
				While( E=1 ) and ( C>=0 ) do      {them.}
					begin
						Switch( c, d, rec1, rec2 ) ;  {Switch if yer supposed to}
						If C>0 then
							begin
								Dec( c ) ;
								Dec( d ) ;
								Seek( Figfile, C ) ;
								Read( Figfile, Rec1 ) ;
								Seek( Figfile, D ) ;
								Read( Figfile, Rec2 ) ;
								E:=comp( Rec1, Rec2, By1 ) ; {Read and compare next ones down}
							end                                                  
						else E:=0 ;  {Leave it alone}
					end ;
				If Comp( Rec1, Rec2, by1 ) = 2 then
					begin
						E:=comp( Rec1, rec2, by2 ) ;   {Two recs that are same will}
						While( E=1 ) and ( c>=0 ) do   {be compared by second priority}
							begin
								switch( C, d, rec1, rec2 ) ;
								If c>0 then
									begin
										Dec( c ) ;
										Dec( d ) ;
										Seek( Figfile, c ) ;
										Read( Figfile, Rec1 ) ;
										Seek( Figfile, d ) ;
										Read( Figfile, rec2 ) ;
										E:=comp( Rec1, rec2, by2 ) ;
									end {IF}
								else E:=0 ;
							end ; {WHILE}
					End ; {If Comp}
				If Comp( Rec1, Rec2, By1 ) = 2 then
					begin
						E:=comp( Rec1, rec2, by3 ) ;   {Third priority}
						While( E=1 ) and ( C>0 ) do
							begin
								Switch( C, d, rec1, rec2 ) ;
								If C>0 then
									begin
										Dec( c ) ;
										Dec( d ) ;
										Seek( figfile, c ) ;
										Read( Figfile, Rec1 ) ;
										Seek( Figfile, d ) ;
										Read( Figfile, Rec2 ) ;
										E:=comp( Rec1, rec2, by3 ) ;
									end
								else e:=0 ;
							end ; {WHILE}
					end ; {If Comp}
			end ; {For}
	end ; {Sort Proc}

Procedure ViewRecs ;
	Begin
		Max := Filesize( FigFile ) - 1 ;
		Menu ;
		DisplayRecWin( 'View Records' ) ;  {Make window}
		Rec := 0 ;        {Start at first rec}
		Repeat
			Repeat
				Reset( figfile ) ;
				Seek( Figfile, rec ) ;
				Read( Figfile, fig ) ;
				GotoXY( 1,1 ) ; Write( Rec, '  ' ) ; {Debugging help}
				If Fig.Active = TRUE then DisplayRecDim( Rec, TRUE ) {If active,}
				else Inc( Rec ) ; {else try again till you get it right.}    {display}
			Until ( Fig.Active = TRUE ) or ( Rec >= Max ) ; {or till you max out}
			GotoXY( 1, 1 ) ;
			Choice:=Readkey ;
			If Choice = #0 then Choice:=Readkey ;
			Case Choice of
				UpArrow:MoveRec( -1, 1, TRUE ) ;  {Arrow keys move one rec}
				DownArrow:MoveRec( 1, 1, TRUE ) ;
				PgUp:MoveRec( -1, 10, TRUE ) ;    {Page keys move by 10}
				PgDn:MoveRec( 1, 10, TRUE ) ;
			end ; {Case}
		Until ( Ord(choice) = 13 ) or ( Choice = #27 ) ; {CR or esc to exit}
	end ; {ViewRecs Proc}

Procedure Purge ;
	begin
		SureWin ; {Is the user really that drastic?}
		If Sure=True then  {If they didn't wimp out, then...}
			begin
				reset( figfile ) ;
				Assign( Tempfile, 'c:\jctemp.rec' ) ;
				{$I-}
				reset( tempfile ) ;
				if ioresult <> 0 then rewrite( tempfile ) ;
				{$I+}
				reset( Tempfile ) ;
				Max:=filesize( figfile ) - 1 ;
				For I := 0 to max do  {Save good stuff to a tempfile}
					begin
						read( figfile, fig ) ;
						If fig.active then write( tempfile, fig ) ;
					end ; {For do}
				ReWrite( Figfile ) ;
				Reset( Tempfile ) ;
				Max:=filesize( tempfile ) - 1 ;
				For I := 0 to max do {Rewrite tempfile to normal file}
					begin
						Read( tempfile, fig ) ;
						Write( figfile, fig ) ;
					end ; {for do}
				ErrorWin( 'Deleted records have been permenantly removed.', '' ) ;
			end ; {IF}                                {Inform user}
	end ; {Purge Proc}

Procedure Add ;
	Begin
		If Filesize( Figfile ) <> 0 then
			begin
				Reset( Figfile ) ;
				Seek( Figfile, filesize( figfile ) -1 ) ;
				Read( Figfile, Fig ) ;     {Goto last position unless none exists.}
			end ; {IF}
		DisplayRecWin( 'Add Records:' ) ; {Make window}
		With Fig do
			begin
				Hilite( 32, 12, 1, 40 ) ;
				Readchar( 32, 12, 40, '' ) ;
				Name:=totalchar ;
				Hilite( 32, 12, 2, 40 ) ;
				Hilite( 32, 13, 1, 3 ) ;
				Readint( 32, 13, 3, 0 ) ;
				Num:=totalint ;
				Hilite( 32, 13, 2, 3 ) ;
				Hilite( 32, 14, 1, 40 ) ;
				Readchar( 32, 14, 40, '' ) ;  {Input all values,}
				appearance:=totalchar ;       {Hiliting the currect category.}
				Hilite( 32, 14, 2, 40 ) ;
				Hilite( 32, 15, 1, 2 ) ;
				Readint( 32, 15, 2, 0 ) ;
				Condition:=totalint ;
				Hilite( 32, 15, 2, 2 ) ;
				Hilite( 32, 16, 1, 5 ) ;
				Readchar( 32, 16, 5, '' ) ;
				sideofforce:=totalchar ;
				Hilite( 32, 16, 2, 5 ) ;
				Active:=TRUE ;        {Duh. They just made it!}
			end ; {End The Fig Do}
			Write( FigFile, Fig ) ; {Save to disk.}
	End ;

Procedure KillRec ;
	Begin
		Max:=Filesize( figfile ) -1 ;
		Sure:=FALSE ;        {Stealing this var from SureWin out of laziness.}
		For Hi:=0 to max do
			begin
				Seek( Figfile, hi ) ;
				Read( Figfile, fig ) ;   {Check for at least one file to delete}
				If Fig.active=true then Sure:=true ;
			end ;
		If Sure=false then     {If there are none, tell the user he's stupid}
			begin
				ErrorWin( 'There are no records to delete.', '' ) ;
				Exit ;                     {and exit (or else it will crash!)}
			end ;
		Rec := 0 ;
		Repeat
			Menu ;
			DisplayRecWin( 'Delete Records' ) ; {Rewrite all wins}
			Repeat
				DisplayRecDim( Rec, True ) ;      {display categories}
				GotoXY( 1, 1 ) ;
				Choice := Readkey ;
				if choice=#0 then
					begin
						Choice:=readkey ;
						Case Choice of
							UpArrow: MoveRec( -1, 1, TRUE ) ;
							DownArrow: MoveRec( 1, 1, TRUE ) ; {Move around}
							PgUp: MoveRec( -1, 10, TRUE ) ;
							PgDn:	MoveRec( 1, 10, TRUE ) ;
						end ; {CASE}
					end ;
			Until ( Upcase( Choice ) = 'D' ) or ( Choice = #27 );
                   {'D' Deletes, ESC exits}
			If Upcase( Choice ) = 'D' then
				begin
					SureWin ;
					If Sure = TRUE then
						begin
							Fig.Active := FALSE ;     {Make condition false and save.}
							Reset( Figfile ) ;
							Seek( Figfile, rec ) ;
							Write( Figfile, fig ) ;
							ErrorWin( 'The record was deleted.', 'Delete Records' ) ;
						end
					else
					  Dec( Rec ) ;    {Will then go to same rec}
				end ; {IF}
		Until( ( Rec>=0 ) and ( Rec<=max ) ) or ( Ord( Choice ) = 27 ) ;
	end ;

Procedure Ressurect ;
	begin
		Sure:=FALSE ;
		For Hi:=0 to ( Filesize( Figfile ) - 1 ) do
			begin
				Seek( Figfile, hi ) ;     {Check for dead files.}
				Read( Figfile, fig ) ;
				If Fig.active=false then Sure:=true ;
			end ;
		If Sure=false then
			begin
				ErrorWin( 'There are no records to ressurect.', '' ) ;
				Exit ;          {If none, leave}
			end ;
		Rec:=0 ;
		Repeat
  		Menu ;
		  DisplayRecWin( 'Records Available for Ressurection:' ) ; {Make Win}
			repeat
				repeat
					seek( figfile, rec ) ;
					Read( figfile, fig ) ;
					If Fig.Active = false then
						displayrecdim( Rec, False ) {Display inactive files}
					else Inc( Rec ) ;
				Until ( Fig.Active = False ) or ( Rec >= Max ) ;
				GotoXY( 1, 1 ) ;
				Choice:=Readkey ;
				If Choice=#0 then choice:=readkey ;
				Case Choice of
					Uparrow:MoveRec( -1, 1, False ) ;
					DownArrow:MoveRec( 1, 1, False ) ; {and maneuver among them}
					PgUp:MoveRec( -1, 10, False ) ;
					PgDn:MoveRec( 1, 10, False ) ;
				end ; {Case}
			Until ( Choice=#27 ) or ( Upcase( Choice ) = 'R' ) ;
			If Upcase( Choice ) = 'R' then  {Till user decides to ressurect.}
				begin
					SureWin ;
					If Sure=TRUE Then
						begin
							Fig.Active:=TRUE ;      {Make it alive}
							Reset( Figfile ) ;
							Seek( Figfile, rec ) ;
							Write( Figfile, fig ) ; {save it.}
							ErrorWin( 'The record was ressurected.', '' ) ; {say it.}
							Choice:=#27 ;   {Outta here}
						end
					else
						Dec( rec ) ; {Goto ol' same rec if they wimped out.}
				end ; {IF}
		Until ( Choice = #27 ) ;    {ESC to exit}
	end ; {Ressurection Proc}


Procedure Changehilite( pos:integer ) ;  {For edit proc}
	begin
		Case pos of
			1:Hilite( 32, 12, 2, 40 ) ;
			2:Hilite( 32, 13, 2, 3 ) ;   {Un-Hilite perfect part of screen}
			3:hilite( 32, 14, 2, 40 ) ;  {According to position I.D.      }
			4:hilite( 32, 15, 2, 3 ) ;
			5:hilite( 32, 16, 2, 5 ) ;
		end ; {Case}
	end ;

Procedure specialhilite( pos:integer ) ; {Same as ChangeHiLite but Hilites}
	begin
		Case pos of
			1:Hilite( 32, 12, 1, 40 ) ;
			2:Hilite( 32, 13, 1, 3 ) ;
			3:hilite( 32, 14, 1, 40 ) ;
			4:hilite( 32, 15, 1, 3 ) ;
			5:hilite( 32, 16, 1, 5 ) ;
		end ; {Case}
	end ;

Procedure Edit ;          {A TOUGH Proc!}

	var pos, a:integer ;

	begin
		Sure:=false ;
		For Hi:=0 to ( Filesize( Figfile ) - 1 ) do
			begin
				Seek( Figfile, hi ) ;
				Read( Figfile, fig ) ;        {Find active entries}
				If Fig.active=TRUE then Sure:=true ;
			end ;
		If Sure=false then
			begin
				ErrorWin( 'There are no records to edit.', '' ) ;
				Exit ;       {If none, say so and leave.}
			end ;
		Rec:=0 ;
		Repeat
   		Menu ;
		  DisplayRecWin( 'Records Available to Edit:' ) ; {Make Win}
			repeat
				repeat
					seek( figfile, rec ) ;
					Read( figfile, fig ) ;
					If Fig.Active = true then
						displayrecdim( Rec, true ) {display dims of first active rec}
					else Inc( Rec ) ;
				Until ( Fig.Active = true ) or ( Rec >= Max ) ;
				GotoXY( 1, 1 ) ;
				Choice:=Readkey ;
				If Choice=#0 then choice:=readkey ;
				Case Choice of
					Uparrow:MoveRec( -1, 1, true ) ;
					DownArrow:MoveRec( 1, 1, true ) ;
					PgUp:MoveRec( -1, 10, true ) ;    {Maneuver thru recs}
					PgDn:MoveRec( 1, 10, true ) ;
				end ; {Case}
			Until ( Choice=#27 ) or ( Upcase( Choice ) = 'E' ) ; {ESC exits}
			If upcase( Choice ) = 'E' then        {'E' Focuses on that rec}
				begin
					pos:=1 ;
					Repeat
						Choice:=Readkey ;
						If choice=#0 then choice:=readkey ;
						If (choice=downarrow) and (Pos<5) then
							begin
								ChangeHilite( pos ) ;
								Inc( pos ) ;
								SpecialHilite( pos ) ;
							end ;                                {Maneuver thru dims of}
						If (Choice=uparrow) and (pos>1) then   {this rec.}
							begin
								ChangeHilite( pos ) ;
								Dec( pos ) ;
								SpecialHilite( pos ) ;
							end ;
						If Ord( choice ) = 13 then     {Once dim is chosen (CR)...}
							begin
								Case pos of     {Minor difs between each pos...}
									1:begin
                      For a:=1 to 40 do Mem[ $B800:( (10+pos)*80+32+a-2 )*2+1 ]:=Magenta*16+White ;
                      TextBackground( Magenta ) ;   {Hilite red}
											ReadChar( 32, 11+pos, 40, Fig.name ) ;{edit name}
                      Hilite( 32, 11+pos, 1, 40 ) ; {Hilite blue again}
									    Fig.name:=Totalchar ;   {Insert new edited val}
										end ;
									3:begin
                      For a:=1 to 40 do Mem[ $B800:( (10+pos)*80+32+a-2 )*2+1 ]:=Magenta*16+White ;
                      TextBackground( Magenta ) ; {Hilite red}
											readchar( 32, 11+pos, 40, Fig.appearance ) ;{edit name}
                      Hilite( 32, 11+pos, 1, 40 ) ; {Hilite blue again}
											Fig.appearance:=Totalchar ;  {Insert new edited val}
										end ;
									2:begin
                      For a:=1 to 3 do Mem[ $B800:( (12)*80+32+a-2 )*2+1 ]:=Magenta*16+White ;
                      TextBackground( Magenta ) ;
											readint( 32, 13, 3, Fig.num ) ; {Edit number}
											Hilite( 32, 13, 1, 3 ) ;
                      Fig.num:=totalint ;
										end ;
									4:begin
                      For a:=1 to 3 do Mem[ $B800:( (14)*80+32+a-2 )*2+1 ]:=Magenta*16+White ;
                      TextBackground( Magenta ) ;
											readint( 32, 15, 3, Fig.condition ) ; {Edit condition}
                      Hilite( 32, 15, 1, 3 ) ;
											Fig.condition:=totalint ;
										end ;
									5:begin
                      For a:=1 to 5 do Mem[ $B800:( (15)*80+32+a-2 )*2+1 ]:=Magenta*16+White ;
                      TextBackground( Magenta ) ;
											ReadChar( 32, 16, 5, Fig.Sideofforce ) ; {Edit side}
                      Hilite( 32, 16, 1, 5 ) ;
										  Fig.sideofforce:=Totalchar ;
										end ;
								end ; {case}
							end ; {IF}
					until ( Choice = #27 ) ;  {Escape when done with rec}
          Reset( Figfile ) ;
          seek( FigFile, Rec ) ;
          Write( FigFile, Fig ) ;    {save it}
				end ;{IF}
		until (Choice=#27 ) ;
		textbackground( black ) ;    {back to normal}
	end ; {proc}

Procedure Prefs ;    {Pref Changes}

	Var x:Byte ;
			key:char ;

	Begin
		GetPref( Pref[1], Pref[2], Pref[3] ) ; {Load Prefs}
		X:=1 ;
		GotoXY( 13, 2 ) ;
		Write( 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿' ) ;
		For Howdy:=3 to 8 do
			begin
				GotoXY( 13, howdy ) ;          {Write Window}
				Write( '³                               ³' ) ;
			end ;
		GotoXY( 13, 9 ) ;
		Write( 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ' ) ;
		GotoXY( 15, 5 ) ;
		Write( '1st Priority:' ) ;
		GotoXY( 15, 6 ) ;
		Write( '2nd Priority:' ) ;
		Gotoxy( 15, 7 ) ;
		Write( '3rd Priority:' ) ;
		Gotoxy( 21, 3 ) ;
		Write( 'Sort Priorities' ) ;
		For Hi:=1 to 3 do
			begin
				If Pref[hi]>4 then Pref[Hi]:=0 ; {If val is corrupted, set it to 0}
				GotoXY( 30, 5+hi-1 ) ;                                  {(Zero=None)}
				Case Pref[hi] of
					0:Write( 'None          ' ) ;
					1:Write( 'Name          ' ) ;
					2:Write( 'Number        ' ) ;  {Write Right Pref for Right Category}
					3:Write( 'Side of Force ' ) ;
					4:Write( 'Condition     ' ) ;
				end ; {Writing Case}
			end ; {For}

		While Key<>#27 do   {ESC exits}
			begin             {For once, I tried a while do instead of repeat until}

				Hilite( 30, 5+x-1, 1, 14 ) ;
				Key:=Readkey ;
				if key=#0 then
					begin
						Key:=readkey ;
						Hilite( 30, 5+x-1, 2, 14 ) ;     {Hilite Proper area}
						{GotoXY( 5, 20 ) ; Write( 'x:',x,' Pref[1]:',pref[1],' Pref[2]:',pref[2],' Pref[3]:',pref[3],'.' ) ;}
						Case key of                      {Line above this: debugging}
							#72:If x>1 then dec( x ) ;  {Move up and down}
							#80:If x<3 then inc( x ) ;  {Move only if OKAY!}
						end ; {CASE}
						If key = #75 then       {If left arrow, change pref}
							begin
								If Pref[x] >0 then dec( Pref[x] ) ;
								GotoXY( 30, 5+x-1 ) ;
								Case Pref[x] of
									0:Write( 'None          ' ) ;
									1:Write( 'Name          ' ) ;
									2:Write( 'Number        ' ) ;
									3:Write( 'Side of Force ' ) ;
									4:Write( 'Condition     ' ) ;
								end ; {Writing Case}
							end ;{IF}
						If key = #77 then       {If right arrow, change pref}
							begin
								If Pref[x] <4 then inc( Pref[x] ) ;
								GotoXY( 30, 5+x-1 ) ;
								Case Pref[x] of
									0:Write( 'None          ' ) ;
									1:Write( 'Name          ' ) ;
									2:Write( 'Number        ' ) ;
									3:Write( 'Side of Force ' ) ;
									4:Write( 'Condition     ' ) ;
								end ; {Writing Case}
							end ;{IF}
						Hilite( 30, 5+x-1, 1, 14 )
					end ; {IF #0}
			end ; {While}
		SavePref( Pref[1], Pref[2], pref[3] ) ; {Save Prefs}
		TextBackground( Black ) ;      {Back to normal}
	end ; {Proc}

begin
	{Cursor:= _displaycursor( false );} {Can't see cursor}
	textbackground( black ) ;
	TextColor( white ) ;
	Assign( PrefFile, 'c:\Solar.PRF' ) ; {Prefs}
	Assign( FigFile, 'c:\JCFigs.rec' ) ; {Recs}
	{$I-}
	Reset( FigFile ) ;
	If IOResult <> 0 then
		Rewrite( FigFile ) ;                 {Makes files if necessary}
	Reset( PrefFile ) ;
	If IOResult <> 0 then
		Rewrite( PrefFile ) ;
	{$I+}
	repeat ;
		Menu ;   {Draw Menu}
		GotoXY( 1, 1 ) ;
		Choice := ReadKey ;    {Wait for choice}
		Case Choice of
			'1':Add ;       {Add Recs}
			'2':edit ;      {Edit Recs}
			'3':KillRec ;   {Delete Recs}
			'4':ViewRecs ;  {View Recs}
			'8':Purge ;     {Purge deleted files}
			'6':If (Pref[1]=0) and (Pref[2]=0) and (Pref[3]=0) then
						begin     {Sort, but not if all choices are 'NONE'.}
							Prefs ; {If so, request change and THEN sort.}
							Sort( Pref[1], Pref[2], Pref[3] ) ;
							ErrorWin( 'The record sort was successful.', '' ) ; {say it}
						end
					else
						begin
							Sort( Pref[1], Pref[2], Pref[3] ) ; {Otherwise, just do it.}
							ErrorWin( 'The record sort was successful.', '' ) ;
						end ; {Sort MiniRoutine}
			'5': Ressurect ;   {Ressurect recs}
			'7': Prefs ;       {Go to Soring Preferences window}
      '9', '0': ErrorWin( 'Thanks to the Founder of the Oasis of Joy!', '' );
      'Q', 'q':begin                                       {Uh, You're Not }
                 SureWin ; {Do they mean it?}              {Supposed to see}
                 If Sure=False then Choice:='a'            {this Goose-egg }
                 else Choice:='Q' ;   {If truly do, quit.}
               end ; {IF}
		end ; {case}
	Until ( UPCASE( Choice ) = 'Q' ) ; {If the user is suicidal, this}
                                                          {will happen.}
	{Notes:														 	  	}
	{   Seek( Filename, Position ) ;      	}
	{   Seek( CardsFile, 0 ) ;					  	}
	{		Read( CardFile, Card ) ;				  	}
	{		Write( Card.name ) ;              	}
	{			-------------									  	}
	{		NumRecs := Filesize( Cardsfile ) ; 	}
	{		Truncate( Cardsfile ) ; 				  	}

end.
