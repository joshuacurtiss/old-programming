Program NetNazin ;

Uses CRT, DOS, GRAPH, NZNTools ; {Consts: Tab, Arrows, Pg's, Del, USERMAX}

Const NumOfWins = 8  ;  {Max wins}
			UserMax   = 30  ; {Max Num of Users allowed}
			TimePosX  = 65 ;  {Clock Pos}
			TimePosY  = 5  ;  {Clock Pos}
      WhiteOnBlack = ( Black*16 ) + White ; {Standard Attrib}

Var Temp:Win ;
		CurrentMessage:Message ;
		Choice, i, j, ID, Num, Response, Where, Who:Integer ;
		NazinDir:String ;
		Key:Char ;
		What:String[ 54 ] ;
		SearchAll, Searched:Boolean ;
		BigHeap:File of Message ;    { }
		UserHeap:File of Character ; { Files }
    DatFile:file of String ;     { }
		Date:Array[ 1..3 ] of Integer ;
		User:Array[ 1..UserMax ] of Character ;

Procedure DOSCommand( Command:String ) ;
                                                     {I'm not using it}
Begin
 	Command := '/C ' + Command;
  SwapVectors;
 	Exec(GetEnv('COMSPEC'), Command);
 	SwapVectors;
end ; {DOSCommand PROC}

Procedure IdentifyUser ;			{Get user logon ID}

Var LogName:String[ 9 ] ;

Begin
	LogName := GetEnv( 'ID' );
  While Length( LogName ) < 9 do LogName := LogName + ' ' ;
	ID := 0 ;
	Repeat                      {Run it against a user check (List of users)}
		Inc( ID ) ;
	Until (LogName=User[ID].NetID) or (ID>UserMax) ;
	If ( ID > UserMax ) or ( User[ ID ].Status = False ) then ID := 0 ;
end ;

Procedure Filter ;					{No cursing allowed on public areas!!!}

Var l, j, k, i:Integer ;
		temp, lkfr:String[5] ;

begin
	l:=0 ;
  repeat
    Inc( l ) ;
    Case l of
    	1:lkfr:='SHIT' ;
      2:lkfr:='DAMN' ;
      3:lkfr:='FUCK' ; 			{All words to be filtered out}
      4:lkfr:='BITCH' ;     {HELL filters out Hello      }
    end ;
	  For K:= 7 to 24 do
			For i:= 2 to 78 - Length( lkfr ) do
				begin
					Temp:='' ;                              {Look for them one by one}
					For J:= i to Length( lkfr ) + i - 1 do
						Temp:= Temp + Upcase( CurrentMessage.Message[ j, k ] ) ;
					If Temp = lkfr then
            For J:=I to length( lkfr ) + i - 1 do
              CurrentMessage.message[ j, k ] := '*' ; {When found, replace}
				end ; {Checking one line}                            {with *'s}
	Until l>4 ;
END ; {filter PROC}

Procedure FYI( Warning:String ) ;{For Your Info window with only Okay button}

Var Key:Char ;
		I, J:Integer ;

Begin
	WinUp( 40, 13, 73, 20 ) ;
	If Length( Warning ) > 30 then {Wordwrap message if more than one line}
		Begin
			I:=31 ;
			Repeat
				Dec( i ) ;
			Until ( Warning[ i ] = ' ' ) or ( i = 0 ) ;
			If i=0 then
				begin
					For J:= 1 to 30 do WriteChar( j+41, 15, Warning[j] ) ;
					For J:= 31 to Length(Warning) do WriteChar( j+11, 16, Warning[j] ) ;
				end
			else
				begin
					For J:= i downto 1 do WriteChar( j+41, 15, Warning[ j ] ) ;
					For J:= i+1 to Length(Warning) do WriteChar(j-i+41,16,Warning[j] ) ;
				end ;
		end {If more than one line}
	else
		For I:= 1 to Length( Warning ) do WriteChar( i+41, 15, Warning[ i ] ) ;
	WriteStr( 58, 18, 'Okay' ) ;
	HiLite( 57, 18, Blue, 6 ) ;
	Repeat
		DisplayTime( TimePosX, TimePosY, True, False, True ) ;
		Key:='a' ;
		If KeyPressed then
			begin
				Key:=Readkey ;
				If Key=#0 then Key:=Readkey ;
			end ;
	Until ( Key = #13 ) or ( Key = #27 ) ;
	WinDown ;
end ; {FYI Proc}

Function AreYouSure( Warning:String ):Boolean ;

Var Choice:Boolean ;						{Like FYI except with Yes/No choice}
		Key:Char ;
		I, J:Integer ;

Begin
	WinUp( 17, 8, 52, 17 ) ;
	TextColor( Red ) ;
	WriteStr( 22, 10, 'Are You Sure?' ) ;
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
	TextColor( White ) ;
	WriteStr( 27, 15, 'Yeahmohn     No! No!' ) ;
	Choice:=False ;
	Key:=' ' ;
	Repeat
		DisplayTime( TimePosX, TimePosY, True, False, True ) ;
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
	TextColor( White ) ;
	WinDown ;
	AreYouSure:=Choice ;
end ; {Are You Sure? Funct}

Function Readln( LimLeft, y, Len, BackCol, CursCol:Integer; DoTab:Boolean ):String ;

Var LimRight, X:Integer ;       {When inputting just one line}
		Key:Char ;
    WhatDeyzSayin:String ;

Begin
	HiLite( LimLeft, y, BackCol, Len ) ;
  LimRight:=LimLeft+Len-1 ;
  X := LimLeft ;
  Repeat
		Key:=' ' ;
		DisplayTime( TimePosX, TimePosY, True, False, True ) ;
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

Procedure TypeToWin( Lim:Win ) ;  {'Word Processor in a box.'}

Var Key, a:Char ;
		i, x, y:Integer ;

Begin
	With Lim do
		Begin
			Inc( Top ) ;
			Dec( Bottom ) ;                   {Don't Write on border!}
			Dec( Right ) ;
			Inc( Left ) ;
		end ;
	Y:=Lim.Top ;                         {Start at Upperleft.}
	X:=Lim.Left ;
	Repeat
		If Y <= Lim.Bottom then
			begin
				Key:=' ' ;
				DisplayTime( TimePosX, TimePosY, True, False, True ) ;
				HiLite( x, y, Blue, 1 ) ;         {Hilite Cursor}
				While keypressed do
					begin {FIX INDENTATION!}
						Key := ReadKey ;
						HiLite( x, y, Black, 1 ) ;
						If Key = #0 then
							begin
								Key := Readkey ;
								Case Key of
									#72: {UpArrow}
										Begin
											Dec( y ) ;
											If Y < Lim.top then
												Begin
													Y := Lim.top ;
													X := Lim.left ;
												end ;
										end ;
									Del: {Special Delete}
										begin
											If X = Lim.Right then
												WriteChar( Lim.Right, y, ' ' )
											else
												Begin
													For I:= x to ( Lim.Right-1 ) do
														begin
															A:=GetChar( i+1, Y ) ;
															WriteChar( i, y, a ) ;
														end ;
													WriteChar( Lim.Right, y, ' ' ) ;
												end ;
										end ; {Spec. Del}
									#80: {DownArrow}
										Begin
											Inc( y ) ;
											If Y > Lim.Bottom then
												Begin
													Y := Lim.Bottom ;
													X := Lim.Right ;
												end ;
										end ;
									#75: {LeftArrow}
										Begin
											Dec( x ) ;
											If X < Lim.Left then
												Begin
													X := Lim.Right ;
													Dec( y ) ;
													If Y < Lim.Top then
														Begin
															Y:=Lim.Top ;
															X:=Lim.Left ;
														end ;
												end ;
										end ;
									#77: {RightArrow}
										Begin
											Inc( x ) ;
											If X > Lim.Right then
												begin
													X:=Lim.Left ;
													Inc( y ) ;
													If Y > Lim.Bottom then
														Begin
															X:=Lim.Right ;
															Y:=Lim.Bottom ;
														end ;
												end ;
										end
								end ; {CASE}
							End  {IF}
						else
							Case Ord( Key ) of
								8: {Backspace}
									Begin
										If ( x = Lim.Left ) and ( y > Lim.Top ) then
											begin
												X := Lim.Right ;
												Dec( y ) ;          {If at left margin}
												WriteChar( x, y, ' ' ) ;
											end
										else
											If ( X = Lim.Left ) and ( y = Lim.Top ) then
												begin
													X:=Lim.Left ;      {If at upperleft corner}
													Y:=Lim.Top ;
												end
											else
												Begin
													Dec( x ) ;
													For I := x to ( Lim.Right - 1 ) do
														begin
															A:=GetChar( i+1, y ) ;
															WriteChar( i, y, a ) ;
														end ;
													WriteChar( Lim.Right, y, ' ' ) ; {If anywhere else}
												end ;
									end ; {BackSpace}
								27: Exit ;                   {Escape to stop typing}
								Tab:
									begin
										Inc( x, 5 ) ;
										If x > Lim.Right then x:=Lim.Right ;
									end ;
								13: {CR}
									If Lim.Top <> Lim.Bottom then
										begin
											X:=Lim.Left ;
											Inc( y ) ;
											If Y > Lim.Bottom then Y:=Lim.Bottom ;
										end
									else
										Exit {If Win is just one line, then exit.}
							else
								Begin
									For I := Lim.Right downto ( x + 1 ) do
										begin
											A := GetChar( i - 1, y ) ;
											WriteChar( i, y, a ) ;
										end ;
									WriteChar( x, y, Key ) ;
									Inc( x ) ;
									If x > Lim.Right then
										begin
											x := Lim.Left ;
											Inc( y ) ;
										end ;
									If Y > Lim.Bottom then
										Begin
											X := Lim.Right ;
											Y := Lim.Bottom ;
										end ;
							End ; {Case Numeral Dos}
					End ; {IF?}
			End ; {WHILE!}
		end ;
	Until ( Key = #27 ) ;     {Escape exits earlier in prog also}
end ; {TypeToWin Proc}

Function TypeID( y:integer ):Integer ;  {Used by ChooseUser Proc}

Var Name, TempStr:String[ 9 ] ;
		I:Integer ;
		a:Char ;

Begin
	For I:= 70 to 78 do
		WriteChar( i, y, ' ' ) ;
  TempStr:=Readln( 70, y, 9, Black, Blue, True ) ;
	Name:='' ;
	For I:= 70 to 78 do
		Name := Name + UpCase( Tempstr[ i-69 ] ) ; {Make ID all caps}
	I:=0 ;
	Repeat
		Inc( i ) ;
	Until ( User[ I ].NetID = Name ) or ( I > UserMax ) ;
	If I<= UserMax then Key := #13             {Match up person Num with ID}
	else I:=2 ;
	TypeID := I ;
end ; {Funct TypeID}

Function GetDateString:String ;

Var Year, Month, Day, OfWeek:Word ;
		Datestr:String ;
    I:Integer ;

Begin
	GetDate( Year, Month, Day, OfWeek ) ;
	WriteStr( TimePosX, TimePosY, '            ' ) ;
	GotoXY( TimePosx, Timeposy ) ;          {Get all info of date, to who}
	Write( Month, '-', Day, '-', Year ) ;                          {ETC}
	DateStr:='' ;
	For I:= TimePosx to TimePosX+9 do
		If GetChar(i,TimePosY) <> ' ' then
			DateStr:=DateStr + GetChar( i, TimePosY ) ;
	GetDateString:=DateStr ;
end ; {GetDateString FUNCT}

Procedure GetUsers( FileName:String ) ; {Reads User directory off of file}

Var i:Integer ;

Begin
	Assign( UserHeap, FileName ) ;
	{$I-}
		Reset( UserHeap ) ;
		If IOResult <> 0 then
			Rewrite( UserHeap ) ;
		Close( UserHeap ) ;
		Reset( UserHeap ) ;
		For I:= 1 to UserMax do
			begin
				Seek( UserHeap, i-1 )  ;
				Read( UserHeap, User[ i ] ) ;
			end ;
		Close( UserHeap ) ;
		If IOResult <> 0 then ;
	{$I+}
  For I:=1 to UserMax do
		If User[ i ].Status = False then      {For empty slots}
      begin
        User[ i ].NetID := '---->DEAD' ;
        User[ i ].Name  := '   ' ;
        User[ i ].ExtendedPrivileges := False ;
      end ;
  If (User[1].NetID<>'0ALL     ') or (User[2].NetID<>'0NOBODY  ') then
  	begin
		  With User[ 1 ] do
    		If NetID <> '0ALL     ' then       {Pos 1 & 2 must ALWAYS be}
		      begin                            {all and nobody.					}
    		    NetID := '0ALL     ' ;
        		Name := 'All' ;
		        ExtendedPrivileges := False ;
            Status := True ;
    		  end ;
		  With User[ 2 ] do
  			If NetID <> '0NOBODY  ' then
      		begin
		        NetID := '0NOBODY  ' ;
    		    Name := 'Nobody                   ' ;
        		ExtendedPrivileges := False ;
            Status:=True ;
		      end ;
      Reset( UserHeap ) ;
		  For I:=1 to 2 do
  			Begin
		    	Seek( UserHeap, i-1 ) ;
    		  Write( UserHeap, User[ i ] ) ;
		    end ;
      Close( UserHeap ) ;
		end ; {Make sure 'ALL' and 'Nobody' is always there}
end ; {GetUsers Proc}


Function MaxPerson:Integer ; {returns person with highest User number.}

Var I:Integer ;

Begin
	I := UserMax + 1 ;
	Repeat
		Dec( I ) ;
	Until User[ i ].Status = True ;
	MaxPerson := I ;
end;

Procedure IntroNewUser( HisLogonID:String ) ;

Var ChosenName:String ;     {Each user will only see this once.}
		Sure:Boolean ;
    K:Integer ;

Begin
	ID:=0 ;
  Repeat
  	Inc( ID ) ;        {Find a User spot to slip in new user}
  Until ( User[ id ].Status = False ) or ( ID > UserMax ) ;
  If ID > UserMax then
    Begin
		  ID:=0 ;  {If no room,}
			Repeat      {User is allowed in but is given the 'NOBODY' identity}
      	Inc( ID ) ;
      Until ( User[ ID ].NetID = '0NOBODY  ' ) ;
    end
  else {If there IS a free space...}
    begin
      WinUp( 10, 10, 70, 20 ) ;
      WriteStr(12,12,'Welcome to Nazin, city of mystery, of enchantment....');
      WriteStr(12,14,'Your logon ID is '''+HisLogonID+'''. But what would' );
      WriteStr(12,15,'you like to be called in Nazin?  Zone out, mohn. But' );
      WriteStr(12,16,'remember your name must point to you in some way.' ) ;
      Repeat
				For I:=12 to 69 do WriteChar( i, 18, ' ' ) ;
    	  WriteStr( 12, 18, 'Name: ' ) ;
  	    ChosenName := Readln( 18, 18, 47, Green, Blue, false ) ;
	      Sure:=AreYouSure( 'Do you want this as your chosen name?' ) ;
      Until Sure ;
			While Length( HisLogonID ) < 9 do HisLogOnID := HisLogonID + ' ' ;
      With User[ ID ] do
			  begin
					Name := ChosenName ;
      		Status := True ;
          NetID := HisLogonID ;
          ExtendedPrivileges := False ;
        end ; {WITH}
			Rewrite( UserHeap ) ;
			Reset( UserHeap ) ;
			For K:=1 to UserMax do
				begin
					Write( UserHeap, User[k] ) ;    {Save changes}
				end ;
			Close( UserHeap ) ;
      WinDown ;
    end ;
end ; {IntroNewUser Proc}


Procedure NazinStart ; {First and foremost to be done}

Var Tempstr:String ;

Begin
	{$M 8192, 0, 0}
	InitWins ; {Necessary ZakTools Init, otherwise windows act funky}
   {$I-}
  	Assign( DatFile, 'DataPNTR.nzn' ) ;
    Reset( DatFile ) ;
    If IOResult <> 0 then ReWrite( DatFile ) ;
    Reset( DatFile ) ;
    Read( DatFile, NazinDir ) ;
    If IOResult <> 0 then            {Gives path of data}
			begin
				NazinDir := 'C:\NetNAZIN' ;
			  ReWrite( DatFile ) ;          {If no path file, choose default}
				Reset( DatFile ) ;            {and put it into the path file}
  			Write( Datfile, NazinDir ) ;
      end ;
    Close( DatFile ) ;
		Assign( BigHeap, NazinDir + '\Messages.NZN' ) ;
    Reset( BigHeap ) ;
		If IOResult = 3 then
    	Begin
				MkDir( NazinDir ) ;
       	Assign( BigHeap, NazinDir + '\Messages.NZN' ) ;
      end ; {IF NO DIR}
		Reset( BigHeap ) ;
		If IOResult = 2 then
			Rewrite( BigHeap ) ;
		Close( BigHeap ) ;
	{$I+}
	Reset( BigHeap ) ;
  NazinDir:=NazinDir + '\' ;
	TextBackground( Black ) ;
	WinUp( 3, 3, 39, 5 ) ;
	WriteStr( 5, 4, 'You are feeling very dizzy... ' ) ;
	ChillOut( 140 ) ;
	WinDown ;
	WinUp( 50, 14, 79, 16 ) ;
	WriteStr( 52, 15, 'Your head is spinning...' ) ;
	ChillOut( 200 ) ;
	WinDown ;
	WinUp( 10, 12, 62, 14 ) ;
	WriteStr( 12, 13, 'And you find yourself in the land of Nazin.' ) ;
	ChillOut( 275 ) ;
	WinDown ;
	TextColor( White ) ;
	InitWins ;
	WinUp( 1, 1, 80, 25 ) ; {Saves screen condition before prog ran}
	ClrScr ;
	For I:=1 to UserMax do User[ i ].Status := False ;
	GetUsers( NazinDir + 'Users.NZN' ) ;         {Reads user file}
	For I:=1 to UserMax do If User[ i ].Status = False then
		User[ i ].ExtendedPrivileges := False ;           {Safety Precaution}
	WinUp( 63, 1, 79, 6 ) ;
	WriteStr( 65, 2, 'NetNAZIN v0.8' ) ;
	IdentifyUser ;
	If ID = 0 then                     {If user is unknown to list, introduce}
		IntroNewUser( GetEnv( 'ID' ) ) ;
	WriteStr( 65, 3, 'ID: '+User[ ID ].NetID ) ;
	Searched:=False ;  {If searched once (successfully), do same search}
  SearchAll:=True ;  {Scope of a search}
  What:=GetDateString ;	{Num Ascii (0-9): 48-57}
  I:=1 ;
  TempStr:='' ;
  While What[i] <> '-' do Inc( i ) ;
  Date[ 1 ] := ( Ord(What[i-1])-48 ) ;
	If I=3 then Inc( Date[ 1 ], ( Ord( What[i-2] ) - 48 ) * 10 ) ;
  J:=I ;
  Repeat
  	Inc( I ) ;
  Until What[i] = '-' ;
  Date[ 2 ] := ( Ord( What[i-1] )-48 ) ;
  If I-J=3 then Inc( Date[ 2 ], ( Ord( What[i-2] ) - 48 ) * 10 ) ;
  Inc( I ) ;
  Date[ 3 ] := (Ord(What[i])-48)*1000+(Ord(What[i+1])-48)*100+
  						 (Ord(What[i+2])-48)*10+(Ord(What[i+3])-48) ;
	Response := 0 ;
	Where:=4 ; Who:=2 ; What:=' ';   {Search Vars}
end ; {NazinStart}


Function WriteMenu:Integer ;

Var I, J, Ymax, opt:Integer ;

Begin
	Ymax:=18 ;
	If Response > 0 then Inc( Ymax ) ;
	If User[ ID ].ExtendedPrivileges then ;
	For J:=14 to Ymax do
		For I:=1 to 20 do
    	begin
				Scrn[ CurrentWin + 1 ].CharMask[i,j] := GetChar( i, j ) ;
        Scrn[ CurrentWin + 1 ].Attribmask[i,j] := GetCharAttrib( i, j ) ;
      end ;
	Scrn[ CurrentWin + 1 ].Status := True ;
	With Scrn[ CurrentWin ] do
		begin
			Top:=14 ;
			Bottom:=ymax ;                   {Save stuff underneath menu}
			Left:=1 ;
			Right:=20 ;
		end ;
	For I:=1 to 20 do
		begin
			WriteChar_A( i, 14, '¿', Whiteonblack ) ;
			WriteChar_A( i, ymax, 'Ù', Whiteonblack ) ;       {The sliding door opens:}
			For J:=15 to ymax -1 do
				WriteChar_A( I, J, '³', Whiteonblack ) ;
			If I>1 then ChillOut( 1 ) ;
			Case i of
				1:
					begin
						WriteChar_A( 1, 14, 'À', Whiteonblack ) ;
						WriteChar_A( 1, ymax, 'Ú', Whiteonblack );
						For J:=15 to ymax - 1 do
							WriteChar_A( i, j, ' ', Whiteonblack ) ;
					end ;
				20:
					Begin
						WriteChar_A( 20, 14, '¿', Whiteonblack ) ;
						WriteChar_A( 20, ymax, 'Ù', Whiteonblack ) ;
						For J:=15 to ymax-1 do
							WriteChar_A( 20, j, '³', Whiteonblack ) ;
					end ;
				else
					begin
						WriteChar_A( i, 14, 'Ä', Whiteonblack ) ;
						WriteChar_A( i, ymax, 'Ä', Whiteonblack ) ;
						For J:=15 to ymax - 1 do
							WriteChar_A( i, j, ' ', Whiteonblack ) ;
					end ;
			end ; {Da CASE}
		end ; {Da For}
	WriteStr( 1, 15, 'Post Message' ) ;
	WriteStr( 1, 16, 'Abort' ) ;
	WriteStr( 1, 17, 'Continue' ) ;
	If Response > 0 then
		WriteStr( 1, 18, 'View Original' ) ; {This menu option only if responding}
	Opt := 1 ;
	Repeat
		HiLite( 1, OPT+14, Blue, 19 ) ;
		DisplayTime( Timeposx, timeposy, true, false, true ) ;
		Key:=' ' ;
		While Keypressed do
			begin
				Key:=readkey ;
				If Key=#0 then key:=readkey ;
				Case Key of
					Uparrow:
						begin
							Hilite( 1, OPT+14, black, 19 ) ;
							Dec( opt ) ;
						end ;
					DownArrow:
						begin
							Hilite( 1, OPT+14, Black, 19 ) ;
							Inc( OPT ) ;
						end ;
					#13:HiLite( 1, opt+14, Black, 19 ) ;
				end ; {CASE}
				If opt < 1 then opt:=ymax - 15 ;
				If opt > ymax - 15 then OPT:=1 ;
			end ; {While}
	Until Ord( Key ) = 13 ;
	WinDown ;
	WriteMenu:=OPT ;
end ; {Funct WriteMenu}  {Post, Abort, Continue, (View Original)}

Function ChooseUser( Y:Integer ; Title, Pointer:String ):Integer ;

Var CursPosY, CurrentID, PrintID, endID:Integer ;
		CurrentPerson:Character ;
		Year, Month, Day, OfWeek:Word ;
		a:Char ;

Begin
	WinUp( 3, y, 70, y+11 ) ;
	WriteStr( 36 - ( Length(Title) Div 2 ), y+1, Title ) ;
	WriteStr( 5, y+6, Pointer ) ;
	WinUp( 60, y-1, 80, y+1 ) ;
	WriteStr( 61, y, 'LogName:' ) ;

	EndID := MaxPerson ;
	CursPosY:=y+6 ;
	CurrentID:=1 ;

	For I := y+3 to y+9 do
		begin
			GotoXY( 14, i ) ;
			If I <> y+6 then TextBackground( Blue )  {Y+6 is middle}
				else TextBackground( Red ) ;
			Write( '                                                       ' ) ;
		end ;
	PrintID:=CurrentID ;
	Repeat
		If CursPosY = y+6 then TextBackground( Red )
			else TextBackground( Blue ) ;
		If User[ PrintID ].Status then
      begin
        GotoXY( 14, CursPosY ) ;
		    Write( User[ PrintID ].Name ) ;
    		Dec( CursPosY ) ;
      end ;
		Dec( PrintID ) ;
	Until ( PrintID < 1 ) or ( CursPosY < y+3 ) ;
	If CurrentID < EndID then
		begin
			PrintID := CurrentID + 1 ;
			CursPosY := y+7 ;
			TextBackground( Blue ) ;
			Repeat
    		If User[ PrintID ].Status then
          begin
            GotoXY( 14, CursPosY ) ;
		        Write( User[ PrintID ].Name ) ;
    		    Inc( CursPosY ) ;
          end ;
		    Inc( PrintID ) ;
			Until ( PrintID > EndID ) or ( CursPosy > y+9 )
		end ; {IF} {Initial write! ^^^^   }
	Repeat
		TextBackground( Black ) ;
		DisplayTime( TimePosX, TimePosY, True, False, True ) ;
		Key := ' ' ;
		While Keypressed do
			begin
				Key:=Readkey ;
				If Key = #0 then
					Begin
						Key:=Readkey ;
						Case Key of
							UpArrow: Dec( CurrentID ) ;
							DownArrow: Inc( CurrentID ) ;
						end ; {Case Statement}
					end
				else If Ord( Key ) = Tab then CurrentID:=TypeID( y ) ;
				If CurrentID > EndID then CurrentID := EndID ;
				If CurrentID < 1 then CurrentID := 1 ;
				CursPosY := y+6 ;
				For I := y+3 to y+9 do
					begin
						GotoXY( 14, i ) ;
						If I <> y+6 then TextBackground( Blue )
							else TextBackground( Red ) ;
						Write( '                                                       ' ) ;
					end ;
				PrintID:=CurrentID ;
				Repeat
					If CursPosY = y+6 then TextBackground( Red )
						else TextBackground( Blue ) ;
       		If User[ PrintID ].Status then
            begin
              GotoXY( 14, CursPosY ) ;
		          Write( User[ PrintID ].Name ) ;
    		      Dec( CursPosY ) ;
            end ;
      		Dec( PrintID ) ;
				Until ( PrintID < 1 ) or ( CursPosY < y+3 ) ;
				If CurrentID < EndID then
					begin
						PrintID := CurrentID + 1 ;
						CursPosY := y+7 ;
						TextBackground( Blue ) ;
						Repeat
          		If User[ PrintID ].Status then
                begin
                  GotoXY( 14, CursPosY ) ;
		              Write( User[ PrintID ].Name ) ;
    		          Inc( CursPosY ) ;
                end ;
      		    Inc( PrintID ) ;
						Until ( PrintID > EndID ) or ( CursPosy > y+9 )
					end ; {IF For Rewrite}
				GotoXY( 70, y ) ;
				TextBackground( Black ) ;
				Write( '          ' ) ;
				GotoXY( 70, y ) ;
				Write( User[ CurrentID ].NetID ) ;
			end ; {While Keypressed}
	Until ( Key = #13 ) and ( User[ CurrentID ].Status = True ) ;
	If Pointer <> 'Send To:' then
		begin
			WinDown ;
			TextBackground( Black ) ;
			WinDown ;
		end ;
	ChooseUser := CurrentID ;
end ; {ChooseUser Function}

Procedure StartMessage ;

Var CurrentID:Integer ;
		Year, Month, Day, OfWeek:Word ;

Begin
	CurrentID := ChooseUser( 9, 'Send a Message', 'Send To:' ) ;
	With CurrentMessage do
		begin
			Sender := ID ;
			Receiver := CurrentID ;
      Date := GetDateString ;
		end ;
	WinUp( 3, 20, 70, 22 ) ;
	WriteStr( 5, 21, 'Subj:' ) ;
	CurrentMessage.Title := Readln( 11, 21, 55, Black, Blue, false ) ;
	For I:= 1 to 3 do
		WinDown ;
	TextBackground( Black ) ;
end ; {StartMessage} {Just for now.}


Procedure KillFile( FileName:String ) ;

Begin
	{$I-}
		Close( BigHeap ) ;
	{$I+}
	Assign( BigHeap, FileName ) ;
	{$I-}
		Reset( BigHeap ) ;                        {Dangerous}
		If IOResult <> 0 then
			Rewrite( BigHeap ) ;
		Close( BigHeap ) ;
	{$I+}
	Reset( BigHeap ) ;
	Rewrite( BigHeap ) ;
	Close( BigHeap ) ;
end ; {KillFile}


Procedure SaveToFile( DaMess:Message ) ;  {Adds a message to list}

Begin
	Reset( BigHeap ) ;
	Seek( BigHeap, Filesize( BigHeap ) ) ;
	Write( BigHeap, DaMess ) ;
  Close( BigHeap ) ;
end ; {SaveToFile Proc}


Procedure ReadMessage( Numbah:Integer ) ;

Begin
	Reset( BigHeap ) ;
	{$I-}
		Seek( BigHeap, Numbah - 1 ) ;
		Read( BigHeap, CurrentMessage ) ;
		If IOResult <> 0 then CurrentMessage.Date := 'Empty' ;
	{$I+}                            {If no messages, 'Empty' is in Date spot}
	Close( BigHeap ) ;
end ; {ReadMessage Proc}


Procedure PrintInfoBox ;

Var I, J:Integer ;

Begin
	For J:= 5 downto 2 do
		For I:= 9 to 62 do
			If GetChar( I, J ) <> ' ' then    {Prints message info}
				WriteChar( i, j, ' ' ) ;
	WriteStr( 3, 2, 'To:   ' ) ;
  If User[ CurrentMessage.Receiver ].Status = False then
    WriteStr( 9, 2, 'Nobody (User has been Deleted)' )
  else                                                    {to/from who}
    WriteStr( 9, 2, User[ CurrentMessage.Receiver ].Name ) ;
	WriteStr( 3, 3, 'From: ' ) ;
  If User[ CurrentMessage.Sender ].Status = False then
  	WriteStr( 9, 3, 'Nobody (User has been Deleted)' )
  else
  	WriteStr( 9, 3, User[ CurrentMessage.Sender ].Name ) ;
	WriteStr( 3, 4, 'Date: '+CurrentMessage.Date ) ;             {Print date}
	WriteStr( 3, 5, 'Subj: '+CurrentMessage.Title ) ;						 {TITLE}
end ; {PrintInfoBox Proc}

Procedure OverView ;   {A future functionality}
Begin
  Num := 1 ;
end ; {OverView Proc}

Function ViewMenu:Char ; {Works like writemenu with variations}

Var I, J, YMax, Opt:Integer ;

Begin
	Ymax := 20 ;
	If User[ ID ].ExtendedPrivileges then Inc( YMax, 2 ) ;
	For J:= 14 to ymax do
		For I:= 1 to 12 do
    	Begin
				Scrn[ CurrentWin + 1 ].CharMask[ i, j ] := GetChar( i, j ) ;
        Scrn[ CurrentWin + 1 ].AttribMask[i, j] := GetCharAttrib( i, j ) ;
      end ;
	Scrn[ CurrentWin + 1 ].Status := True ;
	With Scrn[ CurrentWin ] do
		begin
			Top:=14 ; Bottom:=YMax ;
			Left:=1 ; Right:=12 ;
		end ;
	For I:= 1 to 12 do
		Begin
			WriteChar_a( i, 14, '¿', Whiteonblack ) ;
			WriteChar_a( i, ymax, 'Ù', whiteonblack ) ;
			For J:=15 to ymax -1 do
				WriteChar_a( I, J, '³', Whiteonblack ) ;
			If I>1 then ChillOut( 1 ) ;
			Case i of
				1:
					begin
						WriteChar_A( 1, 14, 'À', Whiteonblack ) ;
						WriteChar_A( 1, ymax, 'Ú', Whiteonblack );
						For J:=15 to ymax - 1 do
							WriteChar_A( i, j, ' ', Whiteonblack ) ;
					end ;
				12:
					Begin
						WriteChar_A( i, 14, '¿', Whiteonblack ) ;
						WriteChar_A( i, ymax, 'Ù', Whiteonblack ) ;
						For J:=15 to ymax-1 do
							WriteChar_A( i, j, '³', Whiteonblack ) ;
					end ;
				else
					begin
						WriteChar_A( i, 14, 'Ä', Whiteonblack ) ;
						WriteChar_A( i, ymax, 'Ä', Whiteonblack ) ;
						For J:=15 to ymax - 1 do
							WriteChar_A( i, j, ' ', Whiteonblack ) ;
					end ;
			end ; {Da CASE}
		end ; {Da For}
	WriteStr( 1, 15, 'Respond' ) ;
	WriteStr( 1, 16, 'Continue' ) ;
	WriteStr( 1, 17, 'Search' ) ;     {Standard choices}
	WriteStr( 1, 18, 'Search More' ) ;
	WriteStr( 1, 19, 'Exit' ) ;
	If User[ ID ].ExtendedPrivileges then
		begin
			WriteStr( 1, 20, 'Delete' ) ;    {Additional Ext. Access Choices}
      WriteStr( 1, 21, 'Filter' ) ;
		end ;
	Opt := 1;
	Repeat
		HiLite( 1, OPT+14, Blue, 11 ) ;
		DisplayTime( timeposx, timeposy, true, false, true ) ;
		Key:= ' ' ;
		While Keypressed do
			begin
				Key:=readkey ;
				If Key=#0 then Key:=Readkey ;
				If (Key=UpArrow) or (Key=DownArrow) or (Key=#13) then
					Hilite( 1, Opt+14, Black, 11 ) ;
				Case Key of
					UpArrow:Dec( opt ) ;
					DownArrow:Inc( Opt ) ;
				end ; {CASE}
				If Opt < 1 then opt := ymax - 15 ;
				If Opt > ymax - 15 then OPT:=1 ;
			end ; {While}
	Until Ord( Key ) = 13 ;
	WinDown ;
	Case Opt of
		1:ViewMenu:='r' ;
		3:ViewMenu:='s' ;
		5:ViewMenu:='x' ;
		4:ViewMenu:='g' ;      {These are undocumented key shortcuts!!!}
		6:ViewMenu:=Del ;
    7:ViewMenu:='f'
		else ViewMenu:= ' ' ;
	end ;
end ; {Function ViewMenu}

Procedure RemoveMessage( Which:Integer ) ;

Var I:Integer ;          {Deletes a certain message out of the list}
		Swap:Message ;
		Sure:Boolean ;

Begin
	Sure := AreYouSure( 'Remove Message? This is NOT Undoable.' ) ;
	If Sure then
		begin
    	Reset( BigHeap ) ;
			I:=FileSize( BigHeap ) - 1 ;
			If Which < I then
				For I:= Which-1 to FileSize( BigHeap ) - 2 do
					begin
						Seek( BigHeap, I+1 ) ;
						Read( BigHeap, Swap ) ;
						Seek( BigHeap, I ) ;
						Write( BigHeap, Swap ) ;
					end ;
			Seek( BigHeap, FileSize( BigHeap ) - 1 ) ;
			Truncate( BigHeap ) ;
			Dec( Num ) ;
      Close( BigHeap ) ;
		end ; {If user sayz OKAY}
end ; {Remove Message}

Function SearchMessages( Scope:boolean; What:String; Where, Who:integer ):Integer ;

Var Found:Boolean ;            {The Search Engine C1995 Josh Curtiss}
		Temp:String[ 54 ] ;
		MaxNumAllowed, Orig, I, J, K:Integer ;

Begin
	Reset( BigHeap ) ;
  MaxNumAllowed:=Filesize( BigHeap ) ;
  Close( BigHeap ) ;
	Found:=False ; Orig:=Num ;
	If Scope = True then Num:=0 ;
	Repeat
		DisplayTime( TimePosX, TimePosY, True, False, True ) ;
		Inc( Num ) ;
		ReadMessage( Num ) ;
		Case Where of
			1:If CurrentMessage.Receiver = Who then Found:=True ;
			2:If CurrentMessage.Sender = Who then Found:=True ;
			3:If CurrentMessage.Date = What then Found := True ;
			5:For I:=1 to 54 - Length( What ) do
					Begin
						Temp:='' ;
						For J:= i to i + Length( What ) - 1 do
							Temp := Temp + CurrentMessage.Title[ J ] ;
						If Temp = What then Found := True ;
					end ; {Check all SUBJ line}
			4:For K:= 7 to 24 do
					If not found then
						For i:= 2 to 78 - Length( What ) do
							begin
								Temp:='' ;
								For J:= i to Length( What ) + i - 1 do
									Temp:= Temp + CurrentMessage.Message[ j, k ] ;
								If Temp = What then Found := True ;
							end ; {Checking one line}
		end ; {CASE}
	Until Found or ( Num > MaxNumAllowed ) ;
	If Num > MaxNumAllowed then
		begin
			If Searched or not Scope then
				FYI( 'You Moron! There are no more entries with that!' )
			else
				FYI( 'You Moron! There are no entries with that!' ) ;
			Num:=Orig ;
		end ;
	If Num = Orig then Searched:=False
	else Searched:=True ;
	SearchMessages:=Num ;
end ; {SearchMessages Function}

Procedure Search ;

Var Key:Char ;
		Opt, i, j:Integer ;
    TempStr:String ;
		Place:Array[ 1..5 ] of String[ 18 ] ;

Begin
  Place[ 1 ] := 'Receiver Logon IDs' ;
	Place[ 2 ] := 'Sender Logon IDs  ' ;
	Place[ 3 ] := 'Dates             ' ;
	Place[ 4 ] := 'Messages          ' ;
	Place[ 5 ] := 'Titles            ' ;
	Opt := 2 ;
	WinUp( 1, 8, 80, 18 ) ;
	For I:=8 to 18 do Hilite( 1, i, Black, 79 ) ;
	WriteStr ( 32, 9, 'Search Messages' ) ;
	WriteStr( 3, 16, 'Tab: Switch Through Entries.' ) ;
	WriteStr( 55, 16, 'Search    Cancel' ) ;
	BorderMohn( 3, 11, 26, 14, Black, White ) ;
	BorderMohn( 28, 11, 78, 14, Black, White ) ;
	WriteStr( 38, 12, Place[ Where ] ) ;
	WriteStr( 8, 11, Chr(180)+'Scope'+Chr(195) ) ;
	WriteStr( 33, 11, Chr(180)+'Search'+Chr(195) ) ;
	WriteStr( 7, 12, 'All Messages' ) ;
	WriteStr( 7, 13, 'This Message to End' ) ;
	WriteStr( 30, 12, 'Search:' ) ;
	WriteStr( 30, 13, 'for:' ) ;
	WriteStr( 35, 13, What ) ;
	I:= 1 ;
	Repeat
		DisplayTime( TimePosX, TimePosY, True, False, True ) ;
		Case Opt of
			1:HiLite( 9, 11, Red, 5 ) ;
			2:HiLite( 34, 11, Red, 6 ) ;
      3:
        Begin
          HiLite( 34, 11, Red, 6 ) ;
          If Where = 3 then
            Begin
              If I<1 then I:=3
              else If I>3 then I:=1 ;
              Case I of
                1:Hilite( 35, 13, blue, 2 ) ;
                2:Hilite( 38, 13, blue, 2 ) ;
                3:HiLite( 41, 13, blue, 4 ) ;
              end ; {CASE}
            end {IF}
          else
          	If Where > 3 then
              HiLite( 35, 13, Blue, 43 )
            else
            	HiLite( 35, 13, Blue, 9 ) ;
        end ; {CASE #3}
			4:HiLite( 54, 16, Blue, 8 ) ;
			5:HiLite( 64, 16, Blue, 8 ) ;
		end ;
		If SearchAll then
		  begin
			  WriteChar( 5, 12, '' ) ;
        WriteChar( 5, 13, ' ' ) ;
      end
		else
		  begin
			  WriteChar( 5, 13, '' ) ;
        WriteChar( 5, 12, ' ' ) ;
      end ;
		Key:=' ' ;
		Case Opt of
			1:If KeyPressed then
					Begin
						Key:=Readkey ;
						If Key=#0 then Key:=Readkey ;
						If ( Key = UpArrow ) or ( Key = DownArrow ) then
							SearchAll := NOT SearchAll ;
					end ;
			2:
				Begin
					HiLite( 38, 12, Blue, 18 ) ;
					If KeyPressed then
						begin
            	Key:=Readkey ;
							If Key = #0 then Key:=Readkey ;
							Case key of
								LeftArrow:Dec( Where ) ;
								RightArrow:Inc( Where ) ;
								Chr( Tab ):
                  begin
                    HiLite( 38, 12, Black, 18 ) ;
                    For J:= 35 to 77 do WriteChar( J, 13, ' ' ) ;
                  end ;
							end ;
							If Where<1 then Where:=1
							else If Where>5 then Where := 5 ;
							WriteStr( 38, 12, Place[ Where ] ) ;
						end ; {If Keypressed}
				end ;
			3:
				Begin
					If Where <> 3 then
						begin
							If Where>2 then
								Temp.Right := 78
							else
								Temp.Right := 45 ;
							TempStr:=Readln( 35, 13, Temp.Right-36, Blue, Green, true ) ;
              Key := Chr( Tab ) ;
							J:=78 ;
							What:='' ;
							Repeat
								Dec( j ) ;
							Until (GetChar( j, 13 ) <> ' ') or (j=35) ;
							For I:=35 to j do What:=What+TempStr[ i-34 ] ;
							If Where < 3 then
								begin
                  What:='' ;
                	For I:=35 to 43 do what:=what+Upcase( tempstr[ i-34 ] ) ;
									Who:=0 ;
									Repeat
										Inc( Who ) ;
									Until (User[Who].NetID=What) or (Who>UserMax);
									If Who>UserMax then
										Who:=ChooseUser( 8, 'Choose a Person to Search For', 'Search:' ) ;
									WriteStr( 35, 13, User[ Who ].NetID ) ;
									For I:=44 to 77 do WriteChar( i, 13, ' ' ) ;
									What := User[Who].NetID ;
								end ; {If for Logon ID's}
						end {As long as its not Date}
          else
					If KeyPressed then
					begin {FIX INDENTATION!}
						Key:=Readkey ;
						If Key = #0 then Key:=Readkey ;
						Case key of
							#27:Opt:=5 ;
							Chr( Tab ):HiLite( 35, 13, Black, 43 ) ;
							DownArrow:If Where=3 then Dec( Date[ i ] ) ;
							UpArrow:If Where=3 then Inc( Date[ i ] ) ;
							LeftArrow:If Where=3 then Dec( i ) ;
							RightArrow:If Where=3 then Inc( i ) ;
						end ; {Case}
  					If ( Where=3 ) then
	  					begin
		  					If (Key=LeftArrow) or (Key=RightArrow) or
			  					 (Ord(Key)=Tab) or (Key=#13) then
                   begin
  	  		  	      HiLite( 35, 13, Black, 10 ) ;
                     For J:= 35 to 77 do WriteChar( J, 13, ' ' ) ;
                   end ;
      					If I>3 then I:=1
			      		else If I<1 then I:=3 ;
       					If Date[ 3 ] < 1994 then Date[ 3 ] := 1994
  		      		else If Date[ 3 ] > 2100 then Date[ 3 ] := 2100 ;
      	  			If Date[ 1 ] < 1 then Date[ 1 ] := 12
	  	      		else If Date[ 1 ] > 12 then Date[ 1 ] := 1 ;
        				If Date[ 2 ] < 1 then Date[ 2 ] := 1
 			      		else If Date[ 2 ] > 31 then Date[ 2 ] := 31 ;
      					If Where>3 then HiLite( 35, 13, Blue, 43 )
			      		else if Where < 3 then HiLite( 35, 13, Blue, 9 ) ;
	  						GotoXY( 35, 13 ) ;
  							If Date[ 1 ] < 10 then Write( ' ' ) ;
   							Write( Date[ 1 ], '-' ) ;
							  If Date[ 2 ] < 10 then Write( ' ' ) ;
						  	Write( Date[ 2 ], '-', Date[ 3 ] ) ;
					  		If (Key=Uparrow) or (Key=downarrow) then
				  				begin
		  							WriteStr( timeposx, timeposy, '          ' ) ;
	  								GotoXY( timeposx, timeposy ) ;
  									What := '' ;
									  Write( Date[1],'-',Date[2],'-',Date[3] ) ;
								  	For j:=timeposx to timeposx+9 do
							  			What:=What+GetChar( j, Timeposy ) ;
						  		end ;
					  		Case i of
				  				1:HiLite( 35, 13, Blue, 2 ) ;
			  					2:Hilite( 38, 13, Blue, 2 ) ;
		  						3:Hilite( 41, 13, Blue, 4 ) ;
	  						end ; {cAse}
  						end ; {IF TIME}
					end ; {If Keypressed}
          HiLite( 35, 13, Black, 43 ) ;
				end ; {Case #3}
			4, 5:
				begin
					HiLite( 35, 13, Black, 15 ) ;
					If Keypressed then
						begin
							Key:=readkey ;
							If Key=#0 then key:=readkey ;
						end ;
				end ; {If SEARCH or CANCEL}
		end ; {CASE}
		If Ord( Key ) = Tab then
			begin
				Case Opt of
					1:HiLite( 9, 11, Black, 5 ) ;
					2,3:HiLite( 34, 11, Black, 6 ) ;
					4:HiLite( 54, 16, Black, 8 ) ;
					5:HiLite( 64, 16, Black, 8 ) ;
				end ;
				Inc( Opt ) ;
				If Opt > 5 then Opt := 1 ;
        Hilite( 35, 12, black, 43 ) ;
        For J:= 35 to 77 do WriteChar( J, 13, ' ' ) ;
        GotoXY( 35, 13 ) ;
        Case Where of
          1, 2:Write( User[ Who ].NetID ) ;
          4, 5:Write( What ) ;
          3:
            begin
      			  If Date[ 1 ] < 10 then Write( ' ' ) ;
							Write( Date[ 1 ], '-' ) ;
							If Date[ 2 ] < 10 then Write( ' ' ) ;
							Write( Date[ 2 ], '-', Date[ 3 ] ) ;
            end ;
        end ; {CASE}
			end ;
	Until (Key = #13) and ( (Opt=4) or (Opt=5) ) ;
	If Opt=4 then Num:=SearchMessages( SearchAll, What, Where, Who ) ;
	WinDown ;
end ;

Procedure WriteMessage( Response:Integer ) ;

Var I, J, Option:Integer ;
		Sure:Boolean ;
		a:String[ 54 ] ;
		Year, Month, Day, OfWeek:Word ;

Begin
	If Response <= 0 then
		StartMessage
	else
		Begin
			a:='   ' ;
			For I:=1 to 3 do A[i] := CurrentMessage.Title[i] ;
			If a <> 'Re:' then
				begin
					a := 'Re: ' ;
					For I:= 5 to 54 do A := a + CurrentMessage.Title[ i-4 ] ;
					CurrentMessage.Title := a ;
				end ;
			CurrentMessage.Receiver := CurrentMessage.Sender ;
			CurrentMessage.Sender := ID ;
      CurrentMessage.Date:=GetDateString ;
		end ; {IF RESPONDING!}
	WinUp (1, 1, 63, 6 ) ;
	WinUp( 1, 6, 79, 25 ) ;
	PrintInfoBox ;
	Repeat
		I := CurrentWin ;
		TypeToWin( Scrn[ i ] ) ;
		Option:=WriteMenu ;
		Case Option of
			1: {Post Message}
				begin
					Sure := AreYouSure( 'Post This Message?' ) ;
					If Not Sure then Option:=3
					else
						begin
							For J:= 7 to 24 do
								For I:= 2 to 78 do
									CurrentMessage.Message[ I, J ] := GetChar( I, J ) ;
              Filter ; {CurrentMessage}
							SaveToFile( CurrentMessage ) ;
						end ; {IF SURE}
				end ;
			2: {Abort}
				begin
					Sure := AreYouSure( 'Your message will be lost!' ) ;
					If Not Sure then Option:=3 ;
				end ;
			4: {View Original}
				begin
					For J:= 1 to 25 do
						For I:= 1 to 80 do
							Temp.CharMask[ I, J ] := GetChar( I, J ) ;
					WinDown ;
					WinDown ;
					Repeat
						DisplayTime( TimePosX, TimePosY, True, False, True ) ;
					Until Keypressed ;
					WinUp (1, 1, 63, 6 ) ;
					WinUp( 1, 6, 79, 25 ) ;
					For J:= 25 downto 1 do
						For I:= 1 to 80 do
							If GetChar( I, J ) <> Temp.CharMask[ I, J ] then
								WriteChar( I, J, Temp.CharMask[ I, J ] ) ;
				end ; {Viewing Original}
		end ;{Case}
	Until ( Option = 1 ) or ( Option = 2 ) ;
	WinDown ;
	WinDown ;
end ; {WriteMessage Proc}


Procedure ViewMessage( Starter:Integer ) ;

Var I, J, PrevNum:Integer ;
		Key:Char ;

Begin
	ReadMessage( 1 ) ;
	If CurrentMessage.Date <> 'Empty' then
		begin
			PrevNum := 0 ;
			Num := Starter ;
			WinUp( 1, 1, 63, 6 ) ;
			WinUp( 1, 6, 79, 25 ) ;
			Repeat
				DisplayTime( TimePosx, TimePosy, True, False, True ) ;
				If PrevNum <> Num then
					begin
						ReadMessage( Num ) ;
						PrintInfoBox ;
						For J:= 7 to 24 do
							For I:= 2 to 78 do
								begin
									Key := GetChar( I, J ) ;
									If CurrentMessage.Message[ I, J ] <> Key then
										WriteChar( i, j, CurrentMessage.Message[ I, J ] ) ;
								end ;
					end ;
				GotoXY( 1, 1 ) ;
				Key := ' ' ;
				While KeyPressed do Key:=Readkey ;
				If Key = #0 then Key:=ReadKey ;
				PrevNum := Num ;
				If Key = #27 then Key:=ViewMenu ;  {If Escape}
				Case Key of
					UpArrow:Dec( Num ) ;
					DownArrow:Inc( Num )  ;
					PgUp:Dec( Num, 10 ) ;
					PgDn:Inc( Num, 10 ) ;
					Del:
						Begin
							If User[ ID ].ExtendedPrivileges then
								RemoveMessage( Num ) ;
              ReadMessage( 1 ) ;
              If CurrentMessage.Date = 'Empty' then Key:='x' ;
            end ;
          'f', 'F':
						begin
							Filter ;
              Reset( BigHeap ) ;
              Seek( BigHeap, Num-1 ) ;
              Write( BigHeap, CurrentMessage ) ;
              Close( BigHeap ) ;
              PrevNum:=Num-1 ;
            end ;
					's', 'S': Search ;
					'g', 'G':
						If Searched then Num:=SearchMessages( False, What, Where, who )
						else Search ;
					'r', 'R':
						begin
							Response:=Num ;
							WriteMessage( Response ) ;
							Response:=0 ;
						end ;
				end ; {Case}
				Reset( BigHeap ) ;
				If Num > FileSize( BigHeap ) then Num:=FileSize( BigHeap ) ;
				If Num < 1 then Num := 1 ;
        Close( BigHeap ) ;
			Until ( Key = 'x' ) or ( Key = 'X' ) ;
      WinDown ;
      WinDown ;
		end  {IF there are messages.}
	else
		FYI( 'There are no messages to read!' ) ;  {If empty}
end ; {ViewMessage Proc}

Procedure EditUsers( FileName:String ) ; {Requires extended access}

Var Sizeoffile, K, i, j, PrevTop, UserTop, Selector:Integer ;
		Key:Char ;
		Change, Sure:Boolean ;

Begin
	WinUp( 1, 7, 79, 25 ) ;
	WriteStr( 34, 9, 'Edit Users' ) ;
	WriteStr( 2, 11, 'Num' ) ;
	WriteStr( 6, 11, 'Logon' ) ;
	WriteStr( 16, 11, 'Name' ) ;
	WriteStr( 72, 11, 'Access' ) ;
	WriteStr( 7, 22, 'Total Users:' ) ;
	GotoXY( 7, 23) ; Write( 'Max Allowed: ', UserMax ) ;
	WriteStr( 55, 22, 'Return: Edit User' ) ;
	WriteStr( 55, 23, 'Delete: Remove User' ) ;
  WriteStr( 58, 24, '''S'': Switch Users' ) ;
	For K:= 12 to 20 do
		begin
			WriteChar( 5, k, '³' ) ;
			WriteChar( 15, k, '³' ) ;
			WriteChar( 70, k, '³' ) ;
			HiLite( 2, k, Blue, 76 ) ;
		end ;
	PrevTop := 1 ;
	UserTop := 1 ;
	Selector := 12 ;
	Change:=True ;
	Repeat
		If ( PrevTop <> UserTop ) or ( Change ) then
			begin
				J:=0 ;
				For I:= 1 to UserMax do
					If User[ i ].Status = True then Inc( j ) ;
				GotoXY( 20, 22 ) ;
				Write( j, '  ' ) ;
				Change := False ;
				PrevTop := UserTop ;
				TextBackground( Blue ) ;
				For K:= UserTop to UserTop + 8 do
					begin
						I := 12 + k - UserTop ;
						GotoXY( 2, i ) ;
						If K <= UserMax then
							begin
								If k>99 then Write( k )
								else If K>9 then Write( '0', k )
										 else Write( '00', k ) ;
								GotoXY( 6, i ) ;
								If User[k].Status = True then Write( User[ k ].NetID )
								else Write( '         ' ) ;
								GotoXY( 16, i ) ;
								If User[k].Status = True then
									begin
										Write( User[ k ].Name ) ;
										For j:= Length( User[k].Name )+16 to 69 do
											If GetChar( j, i ) <> ' ' then WriteChar( j, i, ' ' ) ;
									end
								else
									For J:=16 to 69 do WriteChar( j, i, ' ' ) ;
								GotoXY( 71, i ) ;
								If User[k].Status = TRUE then
									If User[ k ].ExtendedPrivileges then
										Write( 'Extended' )
									else
										Write( ' Normal ' )
								else
									Write( '        ' ) ;
							end ; {If within usermax}
					end ; {Writes all of 'em}
				TextBackground( Black ) ;
			end ; {Rewrite Names}
		HiLite( 2, Selector, Red, 77 ) ;
		DisplayTime( TimePosX, TimePosY, True, False, True ) ;
		If Keypressed then
			begin
				PrevTop := UserTop ;
				Key:=ReadKey ;
				If Key=#0 then Key:=Readkey ;
				Hilite( 2, Selector, Blue, 77 ) ;
				Case key of
					UpArrow:Dec( Selector ) ;
					DownArrow:Inc( Selector ) ;
					Del:
						begin
							User[ Selector-12+UserTop ].Status :=
																		Not User[ Selector-12+UserTop ].Status ;
							Change:=True ;
						end ;
					#13:
						begin
							J:=2 ;
							HiLite( 2, Selector, Green, 77 ) ;
							Case J of
								1:Hilite( 6, Selector, Red, 9 ) ;
								2:Hilite( 16, Selector, Red, 54 ) ;
								3:Hilite( 71, Selector, Red, 8 ) ;
							end ; {case}
							Repeat
								DisplayTime( timeposx, timeposy, true, false, true ) ;
								K := Selector-12+UserTop ;
								If KeyPressed then
									begin
										Key:=Readkey ;
										If Key=#0 then Key:=Readkey ;
										Case Key of
											#13:
												Case J of
													1:
														begin
															Hilite( 6, Selector, Black, 9 ) ;
															With Temp do
																begin
																	Left:=5 ; Right:=15 ;
																	Top:=Selector-1 ;
																	Bottom:=Selector+1 ;
																end ; {WITH TEMP}
															If User[k].NetID <> '2CURTISSJ' THEN
																Begin
																	TypeToWin( Temp ) ;
																	Change:=True ;
																	User[k].NetID := '' ;
																	For i:= 6 to 14 do
																		User[k].NetID:=User[k].NetID+UpCase( GetChar( i, Selector ) ) ;
																end ; {If Not Creator}
														end ; {Pos 1}
													2:
														begin
															Hilite( 16, Selector, Black, 54 ) ;
															With Temp do
																begin
																	Left:=15 ; Right:=70 ;
																	Top:=Selector-1 ;
																	Bottom:=Selector+1 ;
																end ; {WITH TEMP}
															TypeToWin( Temp ) ;
															Change:=True ;
															User[k].Name := '' ;
															For i:= 16 to 69 do
																User[k].Name:=User[k].Name+GetChar(i,selector) ;
														end ; {Pos 2}
												end ; {Case}
											LeftArrow:Dec( j ) ;
											RightArrow:Inc( j ) ;
											UpArrow, DownArrow:
												begin
													If J=3 then
														begin
															User[k].ExtendedPrivileges :=
																NOT User[k].ExtendedPrivileges ;
															Change:=True ;
															GotoXY( 71, Selector ) ;
															If User[k].ExtendedPrivileges then
																Write( 'Extended' )
															else Write ( ' Normal ' ) ;
														end
													else Key := #27 ;
													If (J=3) and (User[k].NetID = '2CURTISSJ') then
														begin
															WriteStr( 3, 3, 'You Moron. The Creator always has access!' ) ;
															ChillOut( 180 ) ;
															WriteStr( 3, 3, '                                         ' ) ;
															User[k].ExtendedPrivileges := TRUE ;
														end ;
												end ; {UP/Down arrow}
										end ; {InnerMost Case}
										If J > 3 then J:=1 ;
										If J < 1 then J:=3 ;
										Hilite( 2, Selector, Green, 77 ) ;
										Case J of
											1:Hilite( 6, Selector, Red, 9 ) ;
											2:Hilite( 16, Selector, Red, 54 ) ;
											3:Hilite( 71, Selector, Red, 8 ) ;
										end ; {case}
									end ; {If keypressed}
								User[K].Status:=true
							Until Key = #27 ;
							Key:=' ' ;
						end ; {If Push Return }
				end ; {Case}
				If Selector < 12 then
					Begin
						Dec( UserTop ) ;
						Selector:=12 ;
					end ;
				If Selector > 20 then
					Begin
						Inc( UserTop ) ;
						Selector:=20 ;
					end ;
				If UserTop < 1 then UserTop:=1 ;
				If UserTop > UserMax-8 then UserTop:=UserMax-8 ;
			end ; {If Keypressed}
		If Key = #27 then
			Begin
				Sure:=False ;
				Sure:=AreYouSure( 'All changes must be finalized. If not, you may cause errors.' ) ;
				If Not Sure then Key:=' ' ;
				Change:=True ;
			end ;
	Until Key = #27 ;
	For I:= 20 downto 12 do Hilite( 2, i, Black, 77 ) ;
  WinDown ;
  Change:=false ;
	WinUp( 20, 9, 55, 13 ) ;
  WriteStr( 26, 11, 'Making Changes...' ) ;
	Rewrite( UserHeap ) ;
	Reset( UserHeap ) ;
	For K:=1 to UserMax do
		begin
			Write( UserHeap, User[k] ) ;
		end ;
	Close( UserHeap ) ;
  Reset( BigHeap ) ;
  Sizeoffile:=FileSize( BigHeap ) ;
  K:=0 ;
  Repeat
  	Inc( k ) ;
    DisplayTime( TimePosX, TimePosY, True, False, True ) ;
    If User[ k ].Status = False then
			For I:=1 to sizeoffile do
        begin
          Change:=false ;
          Readmessage( i ) ;
          If CurrentMessage.Receiver = k then
						begin
							CurrentMessage.Receiver:=2 ;
              Change:=true ;
            end ;
          If CurrentMessage.Sender = k then
						begin
							CurrentMessage.Sender:=2 ;
              Change:=true ;
            end ;
          If Change then
						begin
							Reset( BigHeap ) ;
							Seek( BigHeap, i-1 ) ;
          		Write( BigHeap, CurrentMessage ) ;
            end ;
        end ; {for to do to every message}
  Until k = UserMax ;
  WinDown ;
end ; {Edit Users Proc}

Function MainMenu:Integer ;	{I got this procedure ALL right on first try}

Var Key:Char ;
    i, opt, y:Integer ;

Begin
	Y:= 18 ;
  With User[ ID ] do If ExtendedPrivileges then Inc( y, 2 ) ;
  WinUp( 40, 12, 63, y ) ;
  WriteStr( 44, 13, 'Main Menu' ) ;
  WriteStr( 42, 15, 'Write Messages' ) ;
  WriteStr( 42, 16, 'View Messages' ) ;
  If User[ ID ].ExtendedPrivileges then
  	begin
    	WriteStr( 42, 17, 'Edit/View Users' ) ;
      WriteStr( 42, 18, 'Wipe Messages' ) ;
    end ;
  WriteStr( 42, y-1, 'Quit (No!)' ) ;
  Opt:=1 ;
  Repeat
		DisplayTime( TimePosx, TimePosy, True, False, True ) ;
    HiLite( 42, Opt+14, Blue, 21 ) ;
    If Keypressed then
    	begin
      	For I:=15 to y-1 do HiLite( 42, i, Black, 21 ) ;
        Key:=Readkey ;
        If Key=#0 then Key:=Readkey ;
        If Key = UpArrow then Dec( Opt )
        else if Key = DownArrow then Inc( Opt )
        		 else if Key = #27 then Opt:=y-15 ;
        If Opt>y-15 then Opt:=1
        else If Opt<1 then Opt:=y-15 ;
      end ;
  Until ( Key = #13 ) ;
  If ( User[ ID ].ExtendedPrivileges ) and ( Opt = 5 ) then Opt := 0 ;
  If ( Not User[ID].ExtendedPrivileges ) and ( Opt=3 ) then Opt := 0 ;
	For I:=15 to y-1 do HiLite( 42, i, Black, 21 ) ;
  WinDown ;
	MainMenu := Opt ;
end ; {MainMenu FUNCT}

{                           Main:                                            }

Begin
	NazinStart ;
  Repeat
  	Choice:=99 ;
  	Choice:=MainMenu ; {Put up main menu, wait for choice}
    Case Choice of
    	1:WriteMessage( -1 ) ; {-1 means its not a response to prev message}
      2:begin
					OverView ;
					ViewMessage( Num ) ;
      	end ;
      3:EditUsers( NazinDir + 'Users.NZN' ) ;
      4:If AreYouSure('You don''t really want to destroy all messages.') then
        	begin
          	KillFile( NazinDir + 'Messages.NZN' ) ;
            FYI( 'Your wish is my command. Done. Poof. Happy?' ) ;
          end
      	else FYI( 'Good Decision. Erasure has been Cancelled.' ) ;
    end ; {CASE}
  Until ( Choice = 0 ) ; {Or, if Exit was selected}
	CloseAllWins ;     {Close up, leave screen how it was in the beginning.}
	WinUp( 4, 10, 75, 14 ) ;
	WriteStr(8,12,'Thanks for visiting Nazin. Come back and visit the Emperor!');
	ChillOut( 199 ) ;
	WinDown ;
	GotoXY( 1, 25 ) ;
end .

{
			Plans for immediate future:

1. Allow separate "Areas," with a set of messages in each area.

2. Overview of messages in an area (View by Subj & Sender)

3. Integrate Markus Bookland's word-wrap and scrolling functionalities.

			Definite Provisions to be added down the road:

*  Include a PERSONAL mailbox also. (When mailing, allow multiple receivers)
*  Provision to make an overview window of messages that are JUST sent to
   the Current User or that are in Response to one of HIS letters.

}