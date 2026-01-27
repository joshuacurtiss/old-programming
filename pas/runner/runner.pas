Program RunStuff ; {With Password and Password Encryption}

Uses crt, Dos ;

Type
	Win = Record
		Top:Byte ;
		Bottom:Byte ;
		Right:Byte ;
		Left:Byte ;
		CharMask:Array[ 1..80, 1..25 ] of Char ;
    AttribMask:Array[ 1..80, 1..25 ] of Byte ;
		Status:Boolean ;
	end ;

	ShortCut = Record
		Key:String ;
		Command:String ;
	end ;

Const NumOfWins = 6   ;  OptMax		 = 15  ;
			UpArrow   = #72 ;  DownArrow  = #80 ;
			LeftArrow = #75 ;  RightArrow = #77 ; {Handy-dandy constants.}
			PgUp      = #73 ;  PgDn       = #81 ;
			Del       = #83 ;  Tab        = 9   ;
			CutMax		= 3   ;  Nothing		= '(Empty)' ;
			ESC				= #27 ;  AfterDarkTime = 1 {Minutes} ;

Var Scrn:Array[ 1..NumOfWins ] of Win ;
		KeyShort:Array[ 1..CutMax ] of ShortCut ;
		Key:Char ;
		UserType, PassWord, Command:String ;
    MenuOpt:Array[ 1..OptMax ] of String ;
    WhatToDo:Array[ OptMax+1 .. OptMax*2 ] of String ;
    f:File of String ;
    DoCommand:Boolean ;
    Delta, LenOfType, CursPos, y, i, opt:Byte ;

Function GetCharAttrib (x, y:Byte):Byte;  {Not used yet}

Begin
	GetCharAttrib:=( memw[$B800:2* ((x-1) + (y - 1) * 80)] ) Div 256 ;
End;

Procedure WriteChar_a( x, y:Byte ; C:Char ; attr:Byte ); {Not used yet}

Begin
	memw[$B800:2* ((x-1) + (y - 1) * 80)] := Ord(C) + attr * 256
End;

{ Chr(GetCharAttr(x,y) Mod 256) = Character                               }
{ GetCharAttr(X, Y) Div 256 = Attribute        Background*16 + Textcolor  }

Procedure WriteChar( x, y:Byte ; a:Char ) ;

begin
	mem[ $b800:2 * ( (x-1)+(y-1)*80 ) ] := Ord( a ) ;
end ;

Function GetChar( x, y:Byte ):Char ;

Begin
	GetChar:=Char( mem[ $b800:2 * ( (x-1)+(y-1)*80 ) ] ) ;
end ; {GetChar Function}

Procedure WriteStr( x, y:Byte ; text:string ) ;

Var I:Byte ;

Begin
	For I := x to Length( text )+x-1 do
  	WriteChar( i, y, Text[ I-X+1 ] ) ;
end ; {WriteStr PROC}

Function CurrentWin:Integer ; {Actually outputs the num of windows onscreen.}
															{Effectively outputs the current window.}
Var a:Integer ;

Begin
	A:=NumOfWins + 1 ;
	Repeat
		Dec( a ) ;
	Until ( a=0 ) or ( Scrn[ a ].Status = True ) ; {Check thru wins until 1st}
	CurrentWin := a ;                              {good one is found.}
end ; {CurrentWin Function}

Procedure InitWins ;

Var i:Integer ;

Begin
	For i := 1 to NumOfWins do     {Sets all Win conditions to Closed/False}
		Scrn[ i ].Status := False ;
end ; {InitWins}

Procedure Hilite( x, linenum, Col, Len:Byte ) ;

Var A:Byte ;

Begin
	For A:=1 to len do
		Mem[ $B800:( (linenum-1)*80+x+a-2 )*2+1 ] := Col*16 + White
End ; {HiLite Proc}


Procedure BorderMohn( Left, Top, Right, Bottom:Byte ; Back, txt:byte ) ;

Var i:Byte ;
		Edge:Char ;
		Side:Boolean ;
    att:Byte ;

Begin
  Att:=Back*16+txt ;
	If Left>1 then
		begin
			Edge:=GetChar( Left-1, Top ) ;
			If Edge='Ä' then Side:=TRUE
				else Side:=False ;
		end ;                                          {Upperleft corner}
	If Top>1 then Edge:=GetChar( Left, Top-1 ) ;
	If Edge='³' then
		If Side=TRUE then Edge:=Chr( 197 )
			else Edge:=Chr( 195 )
		else
			If Side=true then Edge:=chr( 194 )
				else Edge:='Ú' ;
	WriteChar_A( Left, Top, Edge, att ) ;
	If Left>1 then
		begin
			Edge:=GetChar( Left-1, Bottom ) ;
			If Edge='Ä' then Side:=TRUE
				else Side:=False ;
		end ;
	If Bottom<25 then Edge:=GetChar( Left, Bottom+1 ) ;
	If Edge='³' then
		If Side=TRUE then Edge:=Chr( 197 )                  {Lowerleft corner}
			else Edge:=Chr( 195 )
		else
			If Side=true then Edge:=chr( 193 )
				else Edge:='À' ;
	WriteChar_A( Left, Bottom, edge, att ) ;
	If Right<80 then
		begin
			Edge:=GetChar(  Right+1, top) ;
			If Edge='Ä' then Side:=TRUE                {Upper Right corner}
				else Side:=False ;
		end ;
	If Top>1 then Edge:=GetChar( Right, Top-1 ) ;
	If Edge='³' then
		If Side=TRUE then Edge:=Chr( 197 )
			else Edge:=Chr( 180 )
		else
			If Side=true then Edge:=chr( 194 )
				else Edge:='¿' ;
	WriteChar_A( Right, Top, Edge, att ) ;
	If Right<80 then
		begin
			Edge:=GetChar( Right+1, bottom ) ;
			If Edge='Ä' then Side:=TRUE                   {Lower Right Corner}
				else Side:=False ;
		end ;
	If Bottom<25 then Edge:=GetChar( Right, Bottom+1 ) ;
	If Edge='³' then
		If Side=TRUE then Edge:=Chr( 197 )
			else Edge:=Chr( 180 )
		else
			If Side=true then Edge:=chr( 193 )
				else Edge:='Ù' ;
	WriteChar_A( Right, Bottom, edge, att ) ;
	For i := left+1 to Right-1 do
		Begin
			edge:='Ä' ;
			If top-1 > 0 then
				begin
					Edge:=GetChar( i, Top-1 ) ;              {Top}
					If Edge = '³' then Edge:=Chr( 193 )
						else Edge:='Ä' ;
				end ;
			WriteChar_A( i, Top, edge, att ) ;
			edge:='Ä' ;
			If Bottom+1 < 26 then
				begin
					Edge:=GetChar( i, Bottom+1 ) ;
					If Edge = '³' then Edge:=Chr( 194 )      {Bottom}
						else Edge:='Ä' ;
				end ;
			WriteChar_A( i, bottom, edge, att ) ;
		end ;
	For i := Top+1 to Bottom-1 do
		Begin
			Edge:='³' ;
			If Left-1 > 0 then
				begin
					Edge:=GetChar( Left-1, i ) ;              {Left}
					If Edge = 'Ä' then Edge:=Chr( 180 )
						else Edge:='³' ;
				end ;
			WriteChar_A( Left, i, Edge, att ) ;
			Edge:='³' ;
			If Right+1 < 81 then
				begin
					Edge:=GetChar( Right+1, i ) ;              {Right}
					If Edge = 'Ä' then Edge:=Chr( 195 )
						else Edge:='³' ;
				end ;
			WriteChar_A( Right, i, Edge, att ) ;
		end ;
end ; {BorderMohn Proc}   {Not Perfect}

Procedure SitAround ;

Var Bert, Ernie:Integer ;

Begin
	Bert := 23 ;
	Ernie := Bert ;
	Inc( Bert, 10 ) ;
end ;

Procedure WinUp( Left, Top, Right, Bottom:Byte ) ;   {Draw & Make a win}

Var i, j, WinNum:INTEGER ;
		Attempt:Boolean ;

Begin
	WinNum := 0 ;
	Repeat               {Finds first inactive Win Spot}
		Inc( WinNum ) ;                                     {In this form, it can}
		Attempt:=Scrn[ WinNum ].Status ;                    {fill any gaps with a}
		If Attempt=False then Scrn[ WinNum ].Status:=TRUE ; {win. (Gaps in Scrn) }
	Until ( Attempt = False ) or ( WinNum = NumOfWins ) ;
	Scrn[ WinNum ].Top    := Top ;
	Scrn[ WinNum ].Bottom := Bottom ;
	Scrn[ WinNum ].Left   := Left ;
	Scrn[ WinNum ].Right  := Right ;
	For J:=top to bottom do
		For I:=Left to Right do
			Begin                          {Make CharMask}
				Scrn[WinNum].CharMask[ i, j ] := GetChar( i, j ) ;
        Scrn[WinNum].AttribMask[ i, j ] := GetCharAttrib( i, j ) ;
      end ;
	BorderMohn( Left, Top, right, bottom, black, white ) ;    {Border}
	For j:=top+1 to bottom-1 do
		For i:=left+1 to right-1 do
			If (Scrn[WinNum].CharMask[I,J] <> ' ')
				or (Scrn[WinNum].AttribMask[I,J] <> Black*16+White) then 
				WriteChar_a( i, j, ' ', Black*16+White ) ; {Skip unnecessary spaces}
end ; {Proc WinUp}

Procedure WinDown ; {Simplified: Closes only front window}

Var i, j, WinNum:INTEGER ;

Begin
	WinNum := CurrentWin ;   {Find which Win to Close}
	If WinNum>0 then         {If none open, just exit}
		With Scrn[ WinNum ] do
			begin
				Status:=False ;       {Kill the Win}
				For J:=Top to Bottom do
					For I:=Left to Right do
						If ( CharMask[I,J] <> GetChar( i, j ) ) or
							( AttribMask[I,J] <> GetCharAttrib( i, j ) ) then
								Writechar_a( i, j, CharMask[i,j], AttribMask[i,j] ) ;{Erase}
    	end ;
end ; {WinDown Proc}

Function WaitForKeypress:Char ; Forward ;

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
		Key:='a' ;
		Key:=WaitForKeyPress ;
		If Key=#0 then Key:=Readkey ;
	Until ( Key = #13 ) or ( Key = #27 ) ;
	WinDown ;
end ; {FYI Proc}

Procedure CloseAllWins ; {Guess what it does?}

Var I:Integer ;

Begin
	For I:= CurrentWin downto 1 do
		WinDown ;
end ; {closeAllWins Proc}

Function Readln( LimLeft, y, Len, BackCol, CursCol:Integer ):String ;

Var LimRight, X:Integer ;       {When inputting just one line}
    WhatDeyzSayin:String ;
		Letter:Boolean ;

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
        Sound( 5000 ) ;
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

Procedure EditMenu ;

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
    	If MenuOpt[ i-6 ] <> '(Empty)' then
				Begin
					WriteStr( 7, i, MenuOpt[ i-6 ] ) ;
		      WriteStr( 39, i, WhatToDo[ i-6+OptMax ] ) ;
        end ;
    	HiLite( 7, i, Blue, 67 ) ;
    end ;
  Repeat
		If Side=True then MenuOpt[ Row ]:=Readln( 7, Row+6, 31, Black, Green )
    else WhatToDo[ Row+OptMax ]:=Readln( 39, Row+6, 34, Black, Green ) ;
    If ( Ord(Key)=Tab ) then Side:=Not Side ;
    If Key = DownArrow then Inc( Row )
    else if key = UpArrow then Dec( Row ) ;
    If Row<1 then Row:=1
    else if row > OptMax then Row:=OptMax ;
  Until ( key = #27 ) ;
  {$I-}
		Reset( f ) ;
    ReWrite( f ) ;
    Reset( f ) ;
    For I:=1 to OptMax do
    	begin
      	Seek( f, I-1 ) ;
	      Write( f, MenuOpt[ i ] ) ;
     	end ;
    For I:=OptMax+1 to Optmax + OptMax do
			Begin
      	Seek( f, I-1 ) ;
	      Write( f, WhatToDo[ I ] ) ;
      end ;
    UserType := '' ;
    For I:=1 to Length( PassWord ) do
    	UserType := UserType + Chr( Ord( PassWord[i] ) + 2 ) ;
    Seek( f, OptMax + OptMax ) ;
    Write( f, UserType ) ;
		For I:=1 to CutMax do
			Begin
				Seek( F, OptMax + OptMax + I ) ;
				Write( F, KeyShort[ I ].Key ) ;
			end ;
		For I:=1 to CutMax do
			Begin
				Seek( f, OptMax + OptMax + CutMax + I ) ;
				Write( f, KeyShort[ i ].Command ) ;
			end ;
		Close( f ) ;
	{$I+}
end ;

Procedure GetStuffs ;

Var Successful:Boolean ;
		P:String ;

Begin
	Successful := False ;
  {$I-}
	ChDir( 'C:\Batches' ) ;
  If IOResult = 3 then
  	Begin
    	ChDir( 'D:\Batches' ) ;
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
    	MkDir( 'C:\Batches' ) ;
      If IOResult <> 0 then
      	Begin
					Successful:=False ;
					MkDir( 'D:\Batches' ) ;
        	If IOResult = 0 then Successful := True ;
        end
      else
      	Successful := True ;
    end ;
  If Not Successful then Halt ;
  Assign( f, P{ath} + 'MenuOpts.DAT' ) ;
 	Reset( f ) ;
  If IOResult <> 0 then
  	Begin
    	ReWrite( f ) ;
      Reset( f ) ;
    end ;
  For I:=1 to OptMax do
  	Begin
    	Seek( f, i-1 ) ;
      Read( f, MenuOpt[ i ] ) ;
      If IOResult <> 0 then
      	Begin
					MenuOpt[ i ] := Nothing ;
					Seek( f, i-1 ) ;
					Write( f, MenuOpt[ i ] ) ;
				end ;
		end ;
	For I:=OptMax+1 to Optmax + OptMax do
		Begin
			Seek( f, I - 1 ) ;
			Read( f, WhatToDo[ i ] ) ;
			If IOResult <> 0 then
				Begin
					WhatToDo[ I ] := '!' ;
					Seek( f, I - 1 ) ;
					Write( f, WhatToDo[ I ] ) ;
				end ;
		end ;
	Seek( f, OptMax + OptMax ) ;
	Read( f, PassWord ) ;
	If IOResult <> 0 then
		Begin
			Password := 'BALANCE' ;
			For I:=1 to Length( Password ) do
				Password[ i ] := Chr( Ord( Password[i] ) + 2 ) ;
      Seek( f, OptMax + OptMax ) ;
      Write( f, Password ) ;
		end ;
	For I:=1 to CutMax do
		Begin
			Seek( F, OptMax + OptMax + I ) ;
			Read( F, KeyShort[ I ].Key ) ;
			If IOResult <> 0 then
				Begin
					Case I of
						1:KeyShort[ i ].Key := 'P' ;
						2:KeyShort[ i ].Key := 'T' ;
						3:KeyShort[ i ].Key := Nothing ;
					end ;
					Seek( f, OptMax + OptMax + I ) ;
					Write( f, KeyShort[ i ].Key ) ;
				end ;
		end ;
	For I:=1 to CutMax do
		Begin
			Seek( f, OptMax + OptMax + CutMax + I ) ;
			Read( f, KeyShort[ i ].Command ) ;
			If IOResult <> 0 then
				Begin
					Case I of
						1:KeyShort[ i ].Command := 'C:\Batches\TP.BAT'   ;
						2:KeyShort[ i ].Command := 'C:\Batches\TMSS.BAT' ;
						3:KeyShort[ i ].Command := Nothing ;
					end ;
					Seek( f, OptMax + OptMax + CutMax + I ) ;
					Write( f, KeyShort[ i ].Command ) ;
				end ;
		end ;
	Close( f ) ;
	{$I+}
	For I:=1 to Length( PassWord ) do
		PassWord[i] := Chr( Ord( PassWord[i] ) - 2 ) ;
end ; {PROC}

Function AfterDark:Char ;

Var Bob:Char ;
		TimeToGo:Boolean ;
		l, r, u, d:Byte ;

Begin
	TimeToGo := False ;
	Randomize ;
	WinUp( 1, 1, 80, 25 ) ;
	For r:=1 to 80 do
		For u:=1 to 25 do
			With Scrn[ CurrentWin ] do
				WriteChar_a( r, u, CharMask[ r, u ], AttribMask[ r, u ] ) ;
	Repeat
		L:=Random( 37 ) +1 ;
		Repeat
			R:=Random( 80 ) ;
			If Keypressed then
				Begin
					Bob:=Readkey ;
					TimeToGo:=True ;
				end ;
		Until ( r > l ) or TimeToGo ;
		U:=Random( 11 ) +1 ;
		Repeat
			D:=Random( 25 ) ;
			If Keypressed then
				Begin
					Bob:=Readkey ;
					TimeToGo:=True ;
				end ;
		Until ( d > u ) or TimeToGo ;
		If NOT TimeToGo then
			Begin
				WinUp( l, u, r, d ) ;
				Scrn[ Currentwin ].Status := False ;
				Delay( 1 ) ;
			end ;
		If Keypressed then
			Begin
				Bob:=Readkey ;
				TimeToGo:=True ;
			end ;
	Until TimeToGo ;
	WinDown ;
	AfterDark := Bob ;
end ;

																{Allows key input and management for a}
Function WaitForKeypress:Char ;	{screen saver both at same time.      }

Var h1, h2, m1, m2, s1, s2, Hundredths:Word ;
		ItsTime, SchoolsOut:Boolean ;
		Hooji:Char ;

Begin
	ItsTime := False ;
	SchoolsOut := False ;
	Repeat
		GetTime( h1, m1, s1, hundredths ) ;
		Repeat
			GetTime( h2, m2, s2, hundredths ) ;
			If ( (h2=1) and (h1=12) ) or ( h2 > h1 ) then Inc( m2, 60 ) ;
			Inc( s2, ( m2 - m1 ) * 60 ) ;
			If Keypressed then
				Begin
					ItsTime := True ;
					SchoolsOut := True ;
				end ;
		Until ( s2 - s1 > AfterDarkTime * 60 ) or ItsTime ;
		If ( Not ItsTime ) and ( Not SchoolsOut ) then Hooji := AfterDark ;
	Until SchoolsOut ;
	WaitForKeypress := Readkey ;
end ;


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
				Dec( i ) ;
			Until ( Command[ i+1 ] = '\' ) or ( I<0 ) ;
			If I<0 then Command := 'cd'
			else
				Begin
{$I-}
					ChDir( Copy( Command, 1, i ) ) ;
{$I+}
					d := IOResult ;
					If d <> 0 then
						If d = 3 then
							FYI( 'Sorry, '+Copy( Command, 1, i )+' is a Bad Path.' )
						else
							FYI( 'Sorry, some strange error occurred.' ) ;
				end ;
			Command := '/C ' + Command;
			DoCommand := False ;
			If ( I > 0 ) and ( d = 0 ) then
				Begin
					Inc( I, 3 ) ;
					Batman := Copy( Command, I+2, Length( Command ) - i - 1 ) ;
					Robin  := Copy( Command, 1, i ) ;
					Delete( Robin, 1, 3 ) ;
					S := FSearch( Batman, Robin ) ;
					If S = '' then FYI( Batman+' Can''t be Found at '+Robin+'.' )
					else
						Begin
							SwapVectors;
							Exec(GetEnv('COMSPEC'), Command);
							SwapVectors;
						end ;
				end ;
		end ;
end ; {Execute}


Begin {$M 8192, 0, 0}
	CursPos := WhereY + 2 ;
  If CursPos > 25 then CursPos:=25 ;
  DoCommand := False ;
	Initwins ;
	GetStuffs ;
	If KeyPressed then
    begin
      Key:=Readkey ;
			I:=0 ;
			Repeat
				Inc( I ) ;
				If ( Upcase( Key ) = Upcase( KeyShort[ i ].Key[ 1 ] ) ) and
					 ( KeyShort[ i ].Key <> Nothing ) then
					Begin
						DoCommand := True ;
						Command := KeyShort[ i ].Command ;
					end ;
			Until ( DoCommand ) or ( I = CutMax ) ;
		end {If KeyPressed}
	else
		Repeat
      Y:=0 ;
      For I:=1 to OptMax do If MenuOpt[ i ] <> '(Empty)' then Inc( Y ) ;
      If Y=0 then
				Begin
      		MenuOpt[ 1 ]:='Edit Menu Settings'  ;
          MenuOpt[ 2 ]:='Press ESC to EXIT'  ;
          WhatToDo[ 1+OptMax ]:='!EDITSETTINGS' ;
          WhatToDo[ 2+OptMax ]:='!EXIT' ;
          Inc( y, 2 ) ;
        end ;
			WinUp( 20, 2, 54, y+5 ) ;
      WriteStr( 29, 3, 'Startup Options:' ) ;
      Delta:=4 ;
      For I:=1 to Y do
				If MenuOpt[i] <> Nothing then WriteStr( 22,I+Delta,MenuOpt[i] ) ;
			Opt := 1 ;
      Repeat
				HiLite( 22, Opt+4, Blue, 32 ) ;
				Key := WaitForKeypress ;
				If Key=#0 then Key:=Readkey ;
        If (Key=UpArrow) or (Key=DownArrow) or (Key=PgUp) or (Key=PgDn) then
        	HiLite( 22, Opt+4, Black, 32 ) ;
        Case Key of
        	UpArrow:Dec( Opt ) ;
          DownArrow:Inc( Opt ) ;
          PgDn:Inc( Opt, 5 ) ;
          PgUp:Dec( Opt, 5 ) ;
					{#98:MovinWindoze ;}
					#25 {Alt-P}:
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
							For I:=1 to Length( PassWord ) do
								PassWord[i]:=Upcase( PassWord[i] ) ;
              I:=Length( UserType ) + 1 ;
              Repeat
              	Dec( I ) ;
              Until ( UserType[i] <> ' ' ) or ( I<1 ) ;
              If I<1 then UserType:='  '
              else UserType := Copy( UserType, 1, i ) ;
              For I:=1 to Length( UserType ) do
              	UserType[i]:=Upcase( UserType[i] ) ;
              If UserType = PassWord then
              	Begin
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
                  Seek( f, Optmax+Optmax ) ;
                  Write( f, UserType ) ;
                	Close( f ) ;
                end
              else
              	Begin
									Key:=' ' ;
                  WinDown ;
                end ;
            end ; {IF Alt-P}
          #67 {F9}:
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
              If I<1 then UserType:='   '
              else UserType := Copy( UserType, 1, i ) ;
              For I:=1 to Length( UserType ) do
              	UserType[i]:=Upcase( UserType[i] ) ;
              If UserType = PassWord then
								Command:='!EDITSETTINGS'
              else
              	Begin
									Command:='' ;
                  Key:=' ' ;
                end ;
            	WinDown ;
            end ;
          #13:
						Begin
							HiLite( 22, Opt+4, Black, 32 ) ;
              Command:='' ;
            end ;
        end ;
        If Opt > Y then Opt:=y
        else If Opt<1 then Opt:=1 ;
      Until ( Key = #13 ) or ( Key = #67 {F9} ) or ( Key = #27 ) ;
      If Key <> #27 then
      	Begin
		      If Command <> '!EDITSETTINGS' then
						Begin
							Command := '' ;
		      		For I:=1 to Length(WhatToDo[Opt+OptMax]) do
								Command:=Command+UpCase(WhatToDo[Opt+OptMax][i]);
		        end ;
		      If Copy( Command, 1, 13 ) = '!EDITSETTINGS' then EditMenu ;
					If Copy( Command, 1, 4 ) = 'RUN ' then
		      	Begin
							Y:=Length( Command ) + 1 ;
		          Repeat
								Dec( y ) ;
							Until ( Command[y] <> ' ' ) ;
		          Command:=Copy( Command, 5, y-4 ) ;
		          DoCommand:=True ;
		        end ;
				end ;
			Execute ;
		Until ( Copy( Command, 1, 5 ) = '!EXIT' ) or ( Key = ESC ) ; {If no key if pressed}
	WinUp( 10, 8, 38, 12 ) ;
  WriteStr( 12, 10, 'Thanks for using Runner!' ) ;
	While NOT Keypressed do SitAround ;
 	CloseAllWins ;
{ GotoXY( 1, CursPos ) ;}
end.
