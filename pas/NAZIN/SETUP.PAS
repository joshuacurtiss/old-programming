Program SetUp ;

Uses CRT, DOS, Zaktools ;

Const Numofwins = 5 ;

Var DatFile:File of String ;
		Path, RealPath:String ;
    Yes:Boolean ;
    i, j:integer ;

Function Readln( LimLeft, y, Len, BackCol, CursCol:Integer; DoTab:Boolean ):String ;

Var LimRight, X, i:Integer ;
		Key:Char ;
    WhatDeyzSayin:String ;

Begin
	HiLite( LimLeft, y, BackCol, Len ) ;
  LimRight:=LimLeft+Len-1 ;
  X := LimLeft ;
  Repeat
		Key:=' ' ;
		HiLite( x, y, CursCol, 1 ) ;         {Hilite Cursor}
		While keypressed do
			begin
				Key := ReadKey ;
				HiLite( x, y, BackCol, 1 ) ;
        If Key = #0 then
					begin
						Key := Readkey ;
		        Case KEY of
		          UpArrow, DownArrow, #27: ;
							Del: {Special Delete}
								begin
									If X = LimRight then
										WriteChar( LimRight, y, ' ' )
									else
										Begin
											For I:= x to ( LimRight-1 ) do
												WriteChar( i, y, GetChar( i+1, y ) ) ;
											WriteChar( LimRight, y, ' ' ) ;
										end ;
								end ; {Spec. Del}
							#75: {LeftArrow}
								Begin
									Dec( x ) ;
									If X < LimLeft then X := LimLeft ;
								end ;
							#77: {RightArrow}
								Begin
									Inc( x ) ;
									If X > LimRight then X := LimRight
								end ;
            end ; {#Case}
          end {IF #0}
        else {IF NOT #0}
          Case Ord( Key ) of
          	13: ;
            Tab: If DoTab then Key := #27 ;
						8: {Backspace}
							Begin
								If ( x = LimLeft ) then X := LimLeft
								else
									Begin
										Dec( x ) ;
										For I := x to ( LimRight - 1 ) do
											WriteChar( i, y, GetChar( i+1, y ) ) ;
										WriteChar( LimRight, y, ' ' ) ; {If anywhere else}
									end ;
							end  {BackSpace}
						else
							Begin
								For I := LimRight downto ( x + 1 ) do
									WriteChar( i, y, GetChar( i-1, y ) ) ;
								WriteChar( x, y, Key ) ;
								Inc( x ) ;
								If x > LimRight then x := LimRight ;
							End ; {ELSE: If you TYPE}
    	    end ; {CASE}
      End ; {While KeyPressed}
  Until ( Key = #13 ) or ( Key = #27 ) ;
  WhatDeyzSayin := '' ;
  For I:=LimLeft to LimRight do
    WhatDeyzSayin := WhatDeyzSayin + GetChar( i, y ) ;
  Readln := WhatDeyzSayin ;
end ; {Readln Funct}

Function AreYouSure( Warning:String ):Boolean ;

Var Choice:Boolean ;
		Key:Char ;
		I, J:Integer ;

Begin
	For I:= 17 downto 8 do HiLite( 17, i, Black, 36 ) ;
	WinUp( 17, 8, 52, 17 ) ;
	GotoXY( 22, 10 ) ;
	TextColor( Red ) ;
	Write( 'Are You Sure?' ) ;
	TextColor( Yellow ) ;
	If Length( Warning ) > 31 then
		Begin
			I:=32 ;
			Repeat
				Dec( i ) ;
			Until ( Warning[ i ] = ' ' ) or ( i = 0 ) ;
			If i=0 then
				begin
					For J:= 1 to 31 do WriteChar( j+18, 12, Warning[j] ) ;
					For J:= 32 to Length(Warning) do WriteChar( j-13, 13, Warning[j] ) ;
				end
			else
				begin
					For J:= i downto 1 do WriteChar( j+18, 12, Warning[ j ] ) ;
					For J:= i+1 to Length(Warning) do WriteChar(j-i+18,13,Warning[j] ) ;
				end ;
		end {If more than one line}
	else
		For I:= 1 to Length( Warning ) do WriteChar( i+18, 12, Warning[ i ] ) ;
	GotoXY( 27, 15 ) ;
	TextColor( White ) ;
	Write( 'Yeahmohn     No! No!' ) ;
	Choice:=False ;
	Key:=' ' ;
	Repeat
		If Choice = False then Hilite( 39, 15, Blue, 9 )
		else HiLite( 26, 15, Blue, 10 ) ;
		If KeyPressed then
			begin
				HiLite( 26, 15, Black, 23 ) ;
				Key:=Readkey ;
				Case key of
					Chr( Tab ):Choice:=Not Choice ;
					#0:
						begin
							Key:=Readkey ;
							Case Key of
								LeftArrow, RightArrow:Choice:=Not Choice ;
								#27:
									Begin
										Choice:=False ;
										Key:=#13
									end ;
							end ;{#0 Case}
						end ; {If #0}
				end ; {Main Case}
			end ;
	Until Key = #13 ;
	GotoXY( 22, 10 ) ;
	TextColor( White ) ;
	Write( '             ' ) ;
	WinDown ;
	AreYouSure:=Choice ;
end ; {Are You Sure? Funct}

Begin
  InitWins;
  TextBackground( Black ) ;
  TextColor( White ) ;
  WinUp( 1, 1, 80, 25 ) ;
  ClrScr ;
  WinDown ;
  {$I-}
  	Assign( DatFile, 'DataPNTR.nzn' ) ;
    Reset( DatFile ) ;
    If IOResult <> 0 then ReWrite( DatFile ) ;
    Reset( DatFile ) ;
    Read( DatFile, Path ) ;
    If IOResult <> 0 then Path := 'C:' ;
  {$I+}
	WinUP( 10, 5, 62, 9 ) ;
  GotoXY( 15, 6 ) ;
  Write( 'Type Path of User and Message Data:' ) ;
  GotoXY( 15, 8 ) ;
  Write( 'Path: ', path ) ;
  repeat
  	Path:=Readln( 21, 8, 32, Green, Blue, False ) ;
	  HiLite( 1, 8, 79, black ) ;
    Yes:=AreYouSure( 'Is this the desired path for storing data?' ) ;
  Until Yes ;
  I:=0 ;
  Repeat
    Inc( i ) ;
  Until ( Path[ i ] = ' ' ) or ( I > Length( Path ) ) ;
  RealPath := '' ;
  For J:=1 to i-1 do RealPath := RealPath + Path[ j ] ;
  {$I-}
  	Repeat
			ReWrite( DatFile ) ;
			Reset( DatFile ) ;
	  Until ( IOResult = 0 ) ;
  {$I+}
	Write( Datfile, RealPath ) ;
  CloseAllWins ;
  GotoXY( 1, 25 ) ;
end .