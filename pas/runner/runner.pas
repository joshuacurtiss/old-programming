Program RunnerWithFeaturesUpDaButt ; {With Password and Password Encryption}

Uses crt, dos, Zakmohn, MenuTool, ScrnSave ;

Type
	ShortCut = Record
		Key:String ;
		Command:String ;
	end ;

Const NumOfWins = 6   ;		OptMax				= 15  ;
			CutMax		= 4   ;		Nothing				= '(Empty)' ;
			ESC				= #27 ;

			Message : Array[ 1..8 ] of String =
      					(	'Life is juicy.',
                	'"Tastes like chicken."',
               		'On the Waterfront: "It''s this big festival." -Ibe Merchant',
                	'Thanks to Kostmohn for input procedure.',
                	'Markus Bookland: Colored boxes screensaver concept.',
                	'Always remember: Three rights make a left.',
                	'Bill Gates Quote: "640k is enough for anyone."',
                	'Mr. Pozzi: The Man, the Myth, the Legend.'	) ;

Var Key																						:Char ;
		UserType, PassWord, Command, WhereDaUserBe		:String ;
		f																							:File of String ;
    DoCommand																			:Boolean ;
    Delta, LenOfType, y, i, opt										:Byte ;
    MenuOpt													:Array[ 1..OptMax ] of String ;
    WhatToDo												:Array[ OptMax+1 .. OptMax*2 ] of String;
    KeyShort												:Array[ 1..CutMax ] of ShortCut ;


Procedure FYI( Warning:String ) ;{For Your Info window with only Okay button}

Var Key:Char ;                   {Stick in anything! Two Lines! WordWraps!}
		I, J:Integer ;

Begin
	WinUp( 40, 13, 73, 20 ) ;
	If Length( Warning ) > 30 then {Wordwrap message if more than one line}
		Begin
			I:=31 ;
			Repeat
				Dec( i ) ;
			Until ( Warning[ i ] = ' ' ) or ( i = 0 ) ; {Look for start of cut word}
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
		Key:='a' ;
		Key:=WaitForKeyPress ;        {Get to WaitForKeypress later}
		If Key=#0 then Key:=Readkey ;
	Until ( Key = #13 ) or ( Key = #27 ) ;
	WinDown ;
end ; {FYI Proc}


Function Att( Back, t:Byte ):Byte ;
Begin
	Att := Back*16 + t ;
end ;


Function Dilly(LimLeft,LimRight,y:Byte;s:String;BackCol,CursCol:Byte):String;

Const TextCol = White ;

Var Width, a, c, Delta:Byte ;
    Letter:Boolean ;

Begin
  Delta:=0 ;
	Width := LimRight + 1 - LimLeft ;
  If Length( s ) >= Width then C:=Width
  else C:=Length( s ) + 1 ;
  Repeat
    For A:=1 to Width do
     	If A + Delta > Length( s ) then
				WriteChar_a( LimLeft+A-1, y, ' ', Att( BackCol, TextCol ) )
      else
       	WriteChar_a( LimLeft+A-1, y, s[A+Delta], Att( BackCol, TextCol ) ) ;
      If Delta > 0 then
				WriteChar_a( LimLeft, y, Chr(17), Att( BackCol, TextCol ) ) ; {<}
      If Delta + Width < Length( s ) then
      	WriteChar_a( LimRight, y, Chr(16), Att( BackCol, TextCol ) ) ; {>}
   	HiLite( LimLeft + C - 1, y, CursCol, 1 ) ;

  	Key := ' ' ;
    Key := WaitForKeypress ;
    Sound( 5000 ) ; 				      {Beep when push a key}
		Delay( 1 ) ;
		NoSound ;

    If Key = #0 then
    	Begin
      	Letter := False ;
        Key := Readkey ;
        Case Key of
					UpArrow, DownArrow, Chr( TAB ): ;
          #71: {Home}
          	Begin
            	Delta := 0 ;
              C := 1 ;
            end ;
          #79: {End}
          	Begin
            	If Length(s) > Width then
              	Begin
                	Delta := Length(s) + 1 - Width ;
                  C:=Width ;
                end
              else
              	Begin
                	C:=Length( s ) + 1 ;
                  Delta := 0 ;
                end ;
            end ;
  				Del: {Special Delete}
          	Begin
 							If C+Delta <= Length( s ) then Delete( s, C+Delta, 1 ) ;
            end ;
          LeftArrow:Dec( C ) ;
          RightArrow:If C+Delta<=Length( s ) then Inc( c ) ;
      	end ; {Case}
      end {If #0}
    else
			Begin
				Letter := True ;
        Case Key of
        	ESC, Chr(13), Chr(Tab):Letter := False ;
          Chr( 8 ):
          	If ( C > 1 ) or ( Delta > 0 ) then
							Begin
								Delete( s, C+Delta-1, 1 ) ;
      			    Dec( c ) ;
			        end;
        	else
          	If Length( s ) < 255 then
							Begin
								Insert( Key, s, C + Delta ) ;
	  			      Inc( c ) ;
				      end
            else
            	Begin
              	NoSound ;
                Sound( 3000 ) ;
                Delay( 1 ) ;
                NoSound ;
              end ;
        end ;{CASE}
      end ; {NOT #0}

    If C > Width then
    	Begin
      	C:=Width ;
        Inc( Delta ) ;
      end
    else
			If C<1 then
      	Begin
        	C:=1 ;
          If Delta > 0 then Dec( Delta ) ;
				end ;
	Until ( ( Key = #13 ) or ( Key = #27 ) or ( Key = Chr( Tab ) ) or
				( Key = UpArrow ) or ( Key = DownArrow ) ) and ( Letter=False ) ;
  Delta := 0 ;
  For A:=1 to Width do
   	If A + Delta > Length( s ) then
			WriteChar_a( LimLeft+A-1, y, ' ', Att( BackCol, TextCol ) )
    else
     	WriteChar_a( LimLeft+A-1, y, s[A+Delta], Att( BackCol, TextCol ) ) ;
  If Delta + Width < Length( s ) then
   	WriteChar_a( LimRight, y, Chr(16), Att( BackCol, TextCol ) ) ; {>}
  HiLite( LimLeft + c - 1, y, BackCol, 1 ) ; {Erase Cursor}
	HiLite( LimLeft, y, Blue, Width ) ; {Just for Runner}
  Dilly := S ;
end ; {Dilly Function}


Function Readln( LimLeft, y, Len, BackCol, CursCol:Integer ):String ;

Var LimRight, X:Integer ;       {When inputting just one line}
    WhatDeyzSayin:String ;
		Letter:Boolean ;						{Yeah I know it replaces a system command}

Begin
	HiLite( LimLeft, y, BackCol, Len ) ;
  LimRight:=LimLeft+Len-1 ;
  X := LimLeft ;
  Repeat
		Key:=' ' ;
		HiLite( x, y, CursCol, 1 ) ;         {Hilite Cursor}
		While keypressed do
			begin
				Key:=' ' ;
        Sound( 5000 ) ;       {Beep when push a key}
				Delay( 1 ) ;
				NoSound ;
				Key := ReadKey ;
				HiLite( x, y, BackCol, 1 ) ;
        If Key = #0 then
					begin
						Letter := False ;
						Key := Readkey ;
		        Case KEY of
							UpArrow, DownArrow, Chr( TAB ): ;
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
					Begin
						Letter := True ;
						Case Key of
							ESC, Chr(13), Chr(Tab):Letter := False ;
							Chr(8): {Backspace}
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
								If (Key<>#27) or (Ord(Key)<>27) then
									begin
										For I := LimRight downto ( x + 1 ) do
											WriteChar( i, y, GetChar( i-1, y ) ) ;
										WriteChar( x, y, Key ) ;
										Inc( x ) ;
										If x > LimRight then x := LimRight ;
									end ;
						end ; {CASE}
					end ; {IF NOT #0}
			End ; {While KeyPressed}
	Until ( ( Key = #13 ) or ( Key = #27 ) or ( Key = Chr( Tab ) ) or
				( Key = UpArrow ) or ( Key = DownArrow ) ) and ( Letter=False ) ;
	WhatDeyzSayin := '' ;
	For I:=LimLeft to LimRight do
		WhatDeyzSayin := WhatDeyzSayin + GetChar( i, y ) ;
	I:=0 ;
	Repeat
		Inc( I ) ;
	Until ( WhatDeyzSayin[ i ] <> ' ' ) or ( I > Length( WhatDeyzSayin ) ) ;
	If I > Length( WhatDeyzSayin ) then WhatDeyzSayin:='(Empty)' ;
	HiLite( LimLeft, y, Blue, Len ) ;
	Readln := WhatDeyzSayin ;
end ; {Readln Funct}

Procedure Editshorts ;  {Edits ShortCuts}

Const	Left  = True  ;
			Right = False ;

Var 	Side:Boolean ;
			Row:Byte ;

Begin
	WinUp( 10, 10, 70, 13+CutMax ) ;
  BorderMohn( 10, 10, 14, 13+CutMax, Black, White ) ;
	Side := Left ;
  WriteStr( 33, 11, 'Edit Shortcuts' ) ;
  For Row := 1 to CutMax do
  	Begin
      If KeyShort[ Row ].Command <> Nothing then
      	Begin
		    	WriteChar( 12, 12+Row, KeyShort[ Row ].Key[ 1 ] ) ;
    		  If Length( KeyShort[Row].Command ) > 55 then
           	WriteStr( 15, 12+Row, Copy( KeyShort[Row].Command, 1, 54 ) + Chr(16) )
					else
						WriteStr( 15, 12+Row, KeyShort[ Row ].Command ) ;
        end ;
    	HiLite( 11, 12+Row, Blue,  3 ) ;
			HiLite( 15, 12+Row, Blue, 55 ) ;
    end ;
  Row := 1 ;
  Repeat
		If Side = Left then
			Begin
				HiLite( 11, 12+Row, Green, 3 ) ;
        Key := WaitForKeyPress ;
        Sound( 5000 ) ;       {Beep when push a key}
				Delay( 1 ) ;
				NoSound ;
        If Key = #0 then Key := Readkey
        else
					If ((Key>'A') and (Key<'Z')) or ((Key>'a') and (Key<'z')) or ( Key = ' ' ) then
						Begin
							WriteChar_a( 12, 12+Row, Upcase( Key ), Att( Green, White ) ) ;
              KeyShort[ Row ].Key[ 1 ] := UpCase( Key ) ;
            end ;
      end
    else
      If KeyShort[ Row ].Command <> Nothing then
				KeyShort[ Row ].Command := Dilly( 15, 69, Row+12, KeyShort[ Row ].Command, Green, White )
      else
				KeyShort[ Row ].Command := Dilly( 15, 69, Row+12, '', Green, White ) ;
    If Side = Left then Hilite( 11, 12+row, Blue, 3 )
    else HiLite( 15, Row+12, Blue, 55 ) ;
    Case Key of
    	ESC, Chr( 27 ): ;
      Chr( Tab ):Side := Not side ;
      DownArrow:Inc( Row ) ;
      UpArrow:Dec( Row ) ;
    end ;
    If Row < 1 then Row := CutMax
    else If Row > CutMax then Row := 1 ;
  Until ( Key = ESC ) ;
  Key := ' ' ;
  WinDown ;
  {$I-}
  Reset( f ) ;
	For I:=1 to CutMax do
		Begin
			Seek( F, OptMax + OptMax + I ) ; {4th Shortcut Keys}
			Write( F, KeyShort[ I ].Key ) ;
		end ;
	For I:=1 to CutMax do
		Begin
			Seek( f, OptMax + OptMax + CutMax + I ) ;
			Write( f, KeyShort[ i ].Command ) ;  {5th Shortcut Commands}
		end ;
	Close( f ) ;
  {$I+}
end ;

Procedure EditMenu ;    {Edits menu settings}

Var Side:Boolean ;
		Row:Byte ;

Begin
	Row:=3 ;
  Side:=True ;
	WinUp( 6, 4, 75, 22 ) ;
  WriteStr( 35, 5, 'Edit Menu' ) ;
	For I:=7 to OptMax + 6 do
  	Begin
      WriteChar( 38, i, Chr( 179 ) ) ;
    	If MenuOpt[ i-6 ] <> '(Empty)' then  {Don't show the '(Empty)'}
				Begin
					WriteStr( 7, i, MenuOpt[ i-6 ] ) ;
		      If Length( WhatToDo[ i-6+OptMax ] ) > 35 then
						WriteStr( 39, i, Copy(WhatToDo[i-6+OptMax],1,34) + Chr(16) )
          else
          	WriteStr( 39, i, WhatToDo[ i-6+OptMax ] ) ;
        end ;
    	HiLite( 7, i, Blue, 67 ) ;
    end ;
  Repeat                         {Side: True is left, Right is False}
		If Side=True then MenuOpt[ Row ]:=Readln( 7, Row+6, 31, Black, Green )
    else
			If WhatToDo[Row+OptMax] <> Nothing then
				WhatToDo[ Row+OptMax ]:=Dilly( 39, 73, Row+6, WhatToDo[Row+OptMax], Black, Green )  {Len=34}
      else
				WhatToDo[ Row+OptMax ]:=Dilly( 39, 73, Row+6, '', Black, Green ) ;
    If ( Ord(Key)=Tab ) then Side:=Not Side ;
    If Key = DownArrow then Inc( Row )
    else if key = UpArrow then Dec( Row ) ;
    If Row<1 then Row:=1
    else if row > OptMax then Row:=OptMax ;
  Until ( key = #27 ) ;   {Use esc to leave}
	Key := ' ' ;
  {$I-}
		Reset( f ) ;
    ReWrite( f ) ;    {Erase old prefs and prepare to save new}
    Reset( f ) ;
    For I:=1 to OptMax do
    	begin
      	Seek( f, I-1 ) ;                 {1st Menu Display}
	      Write( f, MenuOpt[ i ] ) ;
     	end ;
    For I:=OptMax+1 to Optmax + OptMax do
			Begin
      	Seek( f, I-1 ) ;                 {2nd Menu Instructions}
	      Write( f, WhatToDo[ I ] ) ;
      end ;
    UserType := '' ;
    For I:=1 to Length( PassWord ) do
    	UserType := UserType + Chr( Ord( PassWord[i] ) + 2 ) ;
    Seek( f, OptMax + OptMax ) ;
    Write( f, UserType ) ;               {3rd Password}
		For I:=1 to CutMax do
			Begin
				Seek( F, OptMax + OptMax + I ) ; {4th Shortcut Keys}
				Write( F, KeyShort[ I ].Key ) ;
			end ;
		For I:=1 to CutMax do
			Begin
				Seek( f, OptMax + OptMax + CutMax + I ) ;
				Write( f, KeyShort[ i ].Command ) ;  {5th Shortcut Commands}
			end ;
		Close( f ) ;
	{$I+}
end ;

Procedure GetStuffs ;             {Load all prefs from Datafile}

Var Successful:Boolean ;
		P:String ;

Begin
	Successful := False ;
  {$I-}
	ChDir( 'C:\Batches' ) ;   {Try C: drive}
  If IOResult = 3 then
  	Begin
    	ChDir( 'D:\Batches' ) ;  {If not, try D:}
      If IOResult = 3 then Successful:=False
      else
				Begin
					P:='D:\Batches\' ;
          Successful := True ;
        end ;
    end
  else
		Begin
			P:='C:\Batches\' ;
      Successful := True ;
    end ;
	If Not Successful then
  	Begin
    	MkDir( 'C:\Batches' ) ;  {Still no, try to MAKE the directory}
      If IOResult <> 0 then
      	Begin
					Successful:=False ;
					MkDir( 'D:\Batches' ) ;
        	If IOResult = 0 then Successful := True ;
        end
      else
      	Successful := True ;
    end ;
  If Not Successful then Halt ; {If STILL not successful, then too bad.}
  Assign( f, P{ath} + 'MenuOpts.DAT' ) ;
 	Reset( f ) ;
  If IOResult <> 0 then {If error, then maybe the file isn't there.}
  	Begin								{Runner will automatically install itself. }
    	ReWrite( f ) ;
      Reset( f ) ;
    end ;
  For I:=1 to OptMax do
  	Begin
    	Seek( f, i-1 ) ;            {Read in 1st Stuff}
      Read( f, MenuOpt[ i ] ) ;
      If IOResult <> 0 then
      	Begin
					MenuOpt[ i ] := Nothing ;  {Or Write as you go}
					Seek( f, i-1 ) ;
					Write( f, MenuOpt[ i ] ) ;
				end ;
		end ;
	For I:=OptMax+1 to Optmax + OptMax do
		Begin
			Seek( f, I - 1 ) ;
			Read( f, WhatToDo[ i ] ) ;
			If IOResult <> 0 then             {Read in 2nd stuff}
				Begin
					WhatToDo[ I ] := '!' ;
					Seek( f, I - 1 ) ;
					Write( f, WhatToDo[ I ] ) ;
				end ;
		end ;
	Seek( f, OptMax + OptMax ) ;
	Read( f, PassWord ) ;
	If IOResult <> 0 then                {Read password. (Default is Balance)}
		Begin
			Password := 'BALANCE' ;
			For I:=1 to Length( Password ) do
				Password[ i ] := Chr( Ord( Password[i] ) + 2 ) ;
      Seek( f, OptMax + OptMax ) ;
      Write( f, Password ) ;
		end ;
	For I:=1 to CutMax do
		Begin
			Seek( F, OptMax + OptMax + I ) ;      {Read shortcuts}
			Read( F, KeyShort[ I ].Key ) ;
			If IOResult <> 0 then
				Begin
					Case I of
						1:KeyShort[ i ].Key := 'P' ;    {Default Shortcuts}
						2:KeyShort[ i ].Key := 'T' ;
						3:KeyShort[ i ].Key := 'W' ;
          else
          	KeyShort[ i ].Key := ' ' ;
					end ;
					Seek( f, OptMax + OptMax + I ) ;
					Write( f, KeyShort[ i ].Key ) ;
				end ;
		end ;
	For I:=1 to CutMax do
		Begin
			Seek( f, OptMax + OptMax + CutMax + I ) ;
			Read( f, KeyShort[ i ].Command ) ;
			If IOResult <> 0 then                 {Read shortcut commands}
				Begin
					Case I of
						1:KeyShort[ i ].Command := 'C:\Batches\TP.BAT'   ;  {Defaults}
						2:KeyShort[ i ].Command := 'C:\Batches\TMSS.BAT' ;
						3:KeyShort[ i ].Command := 'C:\Windows\Win.COM' ;
          else
          	KeyShort[ i ].Command := Nothing ;
					end ;
					Seek( f, OptMax + OptMax + CutMax + I ) ;
					Write( f, KeyShort[ i ].Command ) ;
				end ;
		end ;
	Close( f ) ;
	{$I+}
	For I:=1 to Length( PassWord ) do
		PassWord[i] := Chr( Ord( PassWord[i] ) - 2 ) ; {Decrypt Password}
end ; {PROC GetStuffs}

Procedure Execute ;

Var D:Integer ;
		S:PathStr ;
		Batman, Robin:String ;

Begin
	CloseAllWins ;
	If DoCommand then
		Begin
			I:=Length( Command ) + 1 ;
			Repeat
				Dec( i ) ;                     {Look for path minus the file.}
			Until ( Command[ i+1 ] = '\' ) or ( I<0 ) ;
			If I<0 then Command := 'cd'
			else
				Begin
{$I-}
					ChDir( Copy( Command, 1, i ) ) ; {Go to that path}
{$I+}
					d := IOResult ;
					If d <> 0 then
						Case d of      {If can't, say so and get back to Menu}
							  3:FYI( 'Sorry, '+Copy( Command, 1, i )+' is a Bad Path.' ) ;
                5:FYI( 'Access is denied to '+Copy( Command, 1, i )+'.' ) ;
              100:FYI( 'The was a disk read error on '+Copy( Command, 1, Pos( ':', Command ) )+' drive.' ) ;
            	152:FYI( 'The '+Copy( Command, 1, Pos( ':', Command ) )+' drive is not ready!' ) ;
              162:FYI( 'Hardware Failure. ('+Copy( Command, 1, Pos( ':', Command ) )+')' ) ;
						else
							FYI( 'Sorry, some strange error occurred.' ) ;
            end ;
				end ;
			Command := '/C ' + Command;
			DoCommand := False ;
			If ( I > 0 ) and ( d = 0 ) then {Continue only if everything's cooh}
				Begin
					Inc( I, 3 ) ; {Take into account '/C '}
					Batman := Copy( Command, I+1, Length( Command ) - i ) ;
					Robin  := Copy( Command, 1, i ) ;      {Batman: the file}
					Delete( Robin, 1, 3 ) ;                {Robin: the path}
          I:=0 ;
          Repeat
          	Inc( I ) ;
          Until ( Batman[ i+1 ] = ' ' ) or ( I >= Length( Batman ) ) ;
          Batman := Copy( Batman, 1, i ) ;
          S:='' ;
          If Pos( '.', Batman ) = 0 then
            Begin
            	If FSearch( Batman+'.COM', Robin ) <> '' then S:=Batman+'.COM' ;
            	If FSearch( Batman+'.EXE', Robin ) <> '' then S:=Batman+'.EXE' ;
            	If FSearch( Batman+'.BAT', Robin ) <> '' then S:=Batman+'.BAT' ;
            end
          else
						S := FSearch( Batman, Robin ) ; {Continue only if its a real file}
					If S = '' then FYI( Batman+' Can''t be Found at '+Robin+'.' )
					else
						Begin
							SwapVectors;
							Exec(GetEnv('COMSPEC'), Command); {Temporarily exit and go to}
							SwapVectors;                      {the other program}
              If Keypressed then
								Begin
									Key := Readkey ;
                  If Key = #0 then Key := Readkey ;
                end ;
						end ;
				end ;
		end ;
end ; {Execute}

Procedure RequirePass ;

Begin
  WinUp( 45, 8, 77, 14 ) ;
  WriteStr( 47, 10, 'Editting Requires a Password.' ) ;
  Repeat
   	For I:=47 to 47+28 do WriteChar( i, 12, ' ' ) ;
      UserType:=Readln( 47, 12, 28, Black, Green ) ;
  Until ( Key = #13 ) or ( Key = #27 ) ;
	If Key=#27 then
		Begin
      UserType:=' ' ;
	  	Key:=' ' ;
      Command := '' ;
    end ;
	For I:=1 to Length( PassWord ) do
		PassWord[i]:=Upcase( PassWord[i] ) ;
  I:=Length( UserType ) + 1 ;
  Repeat
   	Dec( I ) ;
  Until ( UserType[i] <> ' ' ) or ( I<1 ) ;
  if I<1 then UserType:='   '
  else UserType := Copy( UserType, 1, i ) ;
  For I:=1 to Length( UserType ) do
   	UserType[i]:=Upcase( UserType[i] ) ;
  If UserType = PassWord then
	  Command:='!EDITSETTINGS'    {If password is correct, then}
  else                          {allow it. Will be done in}
  	Begin                       {a few lines later...}
	  	Command:='' ;
      Key:=' ' ;
    end ;
  WinDown ;
end ;


Function Cooh( Howfar:Byte ):Byte ; {Converts menu choice to WhatToDo Number}

Var Counter, Good:Byte ;  {Enables program to function properly when there}
                          {are spaces between options in the menu (Gaps)  }
Begin
	Counter := 0 ;          {Then there can be menu options and the Exit all}
	Good    := HowFar ;			{the way on the bottom. Then just add more options}
	Repeat									{in the gap as necessary.}
  	Inc( Counter ) ;
		If MenuOpt[ Counter ] <> Nothing then Dec( Good )
	Until Good = 0 ;
	Cooh := Counter + OptMax ;  {Returns the # of ALL, not just good, entries}
end ;


Begin {$M 8192, 0, 0}  {Not a typical main section. A little large}
  DoCommand := False ;
  GetDir( 0 {Current Drive}, WhereDaUserBe ) ;
	Initwins ; {Necessary}
	GetStuffs ;{Get Prefs}
	If KeyPressed then
    begin                {If a key was pressed while Runner was starting up,}
      Key:=Readkey ;		 {will check to see if its a Key ShortCut.}
			I:=0 ;
			Repeat
				Inc( I ) ;       {Check thru Shortcut list}
				If ( Upcase( Key ) = Upcase( KeyShort[ i ].Key[ 1 ] ) ) and
					 ( KeyShort[ i ].Key <> Nothing ) then
					Begin
						DoCommand := True ;       {If found it, set COMMAND to do it}
						Command := KeyShort[ i ].Command ;
					end ;
			Until ( DoCommand ) or ( I = CutMax ) ;
    	If DoCommand then Execute ;
		end {If KeyPressed}
	else												{Otherwise, do all this crap:}
		Repeat
      Y:=0 ;                  {See how long the menu must be}
			For I:=1 to OptMax do If MenuOpt[ i ] <> Nothing then Inc( Y ) ;
			If Y=0 then
				Begin
      		MenuOpt[ 1 ]:='Edit Menu Settings'  ;
          MenuOpt[ 2 ]:='Press ESC to EXIT'  ;   {Default settings}
          WhatToDo[ 1+OptMax ]:='!EDITSETTINGS' ;
          WhatToDo[ 2+OptMax ]:='!EXIT' ;
          Inc( y, 2 ) ;
        end ;
			WinUp( 20, 2, 54, y+5 ) ;
      WriteStr( 29, 3, 'Startup Options:' ) ;  {Display it}
      Delta:=4 ;
      For I:=1 to Y do
				If MenuOpt[ Cooh(i)-OptMax ] <> Nothing then
					WriteStr( 22, I+Delta, MenuOpt[ Cooh(i)-OptMax ] ) ;
			Opt := 1 ;
      Repeat
				HiLite( 22, Opt+4, Blue, 32 ) ;
				Key := WaitForKeypress ;         {Sit and wait for user.}
				If Key=#0 then Key:=Readkey ;
        If (Key=UpArrow) or (Key=DownArrow) or (Key=PgUp) or (Key=PgDn) then
        	HiLite( 22, Opt+4, Black, 32 ) ;
        Case Key of
        	UpArrow:Dec( Opt ) ;
          DownArrow:Inc( Opt ) ;
          PgDn:Inc( Opt, 5 ) ;
          PgUp:Dec( Opt, 5 ) ;
					#25 {Alt-P}:              {Password routine: Alt-P}
          	Begin
              WinUp( 45, 8, 77, 14 ) ;
              WriteStr( 47, 10, 'Enter Old Password.' ) ;
              Repeat
              	For I:=47 to 47+28 do WriteChar( i, 12, ' ' ) ;
                UserType:=Readln( 47, 12, 28, Black, Green ) ;
              Until ( Key = #13 ) or ( Key = #27 ) ;
							If Key=#27 then
								Begin
                  UserType:=' ' ;
									Key:=' ' ;
                  Command := '' ;
                end ;
							For I:=1 to Length( PassWord ) do {Capitalize password}
								PassWord[i]:=Upcase( PassWord[i] ) ;
              I:=Length( UserType ) + 1 ;
              Repeat
              	Dec( I ) ;                      {Eliminate spaces at end}
              Until ( UserType[i] <> ' ' ) or ( I<1 ) ;
              If I<1 then UserType:='  '
              else UserType := Copy( UserType, 1, i ) ;
              For I:=1 to Length( UserType ) do
              	UserType[i]:=Upcase( UserType[i] ) ;{Capitalize input}
              If UserType = PassWord then
              	Begin                      {If got it right, enter new}
                	WinDown ;
                  WinUp( 7, 7, 35, 13 ) ;
                  WriteStr( 9, 9, 'Alter Password.' ) ;
                  Repeat
		              	For I:=8 to 8+25 do WriteChar( i, 11, ' ' ) ;
                    WriteStr( 8, 11, Password ) ;
    		            UserType:=Readln( 8, 11, 25, Black, Green ) ;
        		      Until ( Key = #13 ) ;
		              I:=Length( UserType ) + 1 ;
    		          Repeat
        		      	Dec( I ) ;
            		  Until ( UserType[i] <> ' ' ) or ( I<1 ) ;
              		If I<1 then UserType:='Balance'
              		else UserType := Copy( UserType, 1, i ) ;
          		    For I:=1 to Length( UserType ) do
              			UserType[i]:=Upcase( UserType[i] ) ;
                  PassWord:=UserType ;
                  For I:=1 to Length( UserType ) do
                  	UserType[i] := Chr( Ord( UserType[i] ) + 2 ) ;
                  Key:=' ' ;
                  Command:=' ' ;
                  WinDown ;
                  Reset( f ) ;
                  Seek( f, Optmax+Optmax ) ;{Save password}
                  Write( f, UserType ) ;
                	Close( f ) ;
                end
              else
              	Begin
									Key:=' ' ;
                  WinDown ;
                end ;
            end ; {IF Alt-P}
          #67 {F9}:RequirePass ; {Edit Menu Key}
          #60, #62, #64 {F2, F4, F6}:
          	Begin
            	Randomize ;
              If ( I < 1 ) or ( I > 7 ) then
								I := Random( 7 ) ;
              Inc( I ) ;
							FYI( Message[ i ] ) ;
            end ;
          #13:
						Begin
							HiLite( 22, Opt+4, Black, 32 ) ; {They finally made a choice}
              Command:='' ;
            end ;
        end ;
        If Opt > Y then Opt:=1
        else If Opt<1 then Opt:=y ;
      Until ( Key = #13 ) or ( Key = #67 {F9} ) or ( Key = #27 ) ;
      If Key <> #27 then
      	Begin
		      If Command <> '!EDITSETTINGS' then
						Begin
							Command := '' ;
							For I:=1 to Length(WhatToDo[ Cooh(Opt) ]) do
								Command:=Command+UpCase(WhatToDo[ Cooh(Opt) ][i]);
						end ;
					If Copy( Command, 1, 13 ) = '!EDITSETTINGS' then
						Case Menu( 3, 4, 23, 10, 'Edit Menu:', 'Alter Menu\Alter Shortcuts\Exit' ) of
							1:EditMenu ;
              2:EditShorts ;
            end ;
					If Copy( Command, 1, 4 ) = 'RUN ' then
		      	Begin
							Y:=Length( Command ) + 1 ;
		          Repeat
								Dec( y ) ;
							Until ( Command[y] <> ' ' ) ;     {Copy what to Run}
		          Command:=Copy( Command, 5, y-4 ) ;
		          DoCommand:=True ;
		        end ;
				end ;
			Execute ; {Command is now the file to run. Execute runs it.}
		Until ( Copy( Command, 1, 5 ) = '!EXIT' ) or ( Key = ESC ) ;

    					{Beauty of Runner: Keeps doing this (Even after a program was}
							{ran) Over and over. Once you quit a program, up runner comes.}
							{It won't go away until you ASK it to.}
  {$I-}
  	ChDir( WhereDaUserBe ) ;
  {$I+}
	WinUp( 10, 8, 38, 12 ) ;
  WriteStr( 12, 10, 'Thanks for using Runner!' ) ;
	Command := WaitForKeypress ; {Press a key to finally leave. If they don't,}
 	CloseAllWins ;							 {screen saver will come up in so many minutes!}
  For I:=1 to 80 do WriteChar_A( i, 25, ' ', Att( Black, White ) ) ;
 	GotoXY( 1, 24 ) ;
  If IOResult <> 0 then
    Writeln( 'Crap, where were we anyway???' ) ;
end.
