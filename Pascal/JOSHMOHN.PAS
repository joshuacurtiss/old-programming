Unit Joshmohn ;    {Version of Juice!}

Interface

Uses CRT, DOS ;

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

Const NumOfWins = 4  ;  Esc        = #27;
			UpArrow   = #72;  DownArrow  = #80;
			LeftArrow = #75;  RightArrow = #77; {Handy-dandy constants.}
			PgUp      = #73;  PgDn       = #81;
			Del       = #83;  Tab        = 9 ;
      CR        = #13;
      BW = ( Black*16 ) + White ; {Standard Attrib}

Var Scrn:Array[ 1..NumOfWins ] of Win ;

  Procedure WriteStr( x, y:Byte ; Text:String ) ;

	Procedure WriteChar  ( x, y:Byte ; a:Char ) ;
	Procedure WriteChar_A( x, y:Byte ; C:Char ; Attr:Byte ) ;

	Function GetChar     ( x, y:Byte ):Char ;
  Function GetChar_A   ( x, y:Byte ):Byte ;

  Procedure FixWins ;
	Procedure InitWins ;
	Function  CurrentWin:Byte ;
	Procedure BorderMohn( Left, Top, Right, Bottom:Byte ; Back, Txt:Byte ) ;
	Procedure WinUp( Left, Top, Right, Bottom:Byte ) ;
	Procedure WinDown ;
	Procedure MoveWin( DeltaX, DeltaY:Integer ) ;
	Procedure CloseAllWins ;

	Function  XCenterPos( Text:String ):Byte ;
	Procedure DisplayTime( x, y:Byte ; ShowSec, ShowHun, Twelve:Boolean ) ;
	Procedure HiLite( x, linenum, Col, Len:Byte ) ;
	Procedure ChillOut( Hun:Word ) ;

Implementation

Function GetChar_A (x, y:Byte):Byte;

Begin
	GetChar_A:=( memw[$B800:2* ((x-1) + (y - 1) * 80)] ) Div 256 ;
End;

Procedure WriteChar_a( x, y:Byte ; C:Char ; attr:Byte ); 

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

Function XCenterPos( Text:String ):Byte ; {Spits Out X pos to make}
																					{text centered.}
Var OneNumbah:Byte ;

Begin
  If Length( Text ) > 78 then OneNumbah := 1
  else
  	OneNumbah := 40 - ( Length( Text ) Div 2 ) ;
  XCenterPos := OneNumbah ;
end ; {WriteCenter Proc}

Function CurrentWin:Byte ; {Actually outputs the last window made,}
													 {Effectively outputs the current window.}
Var a:Byte ;

Begin
	A:=NumOfWins + 1 ;
	Repeat
		Dec( a ) ;
	Until ( a=0 ) or ( Scrn[ a ].Status = True ) ; {Check thru wins until 1st}
	CurrentWin := a ;                              {good one is found.}
end ; {CurrentWin Function} {If no Wins, CurrentWin = 0}

Procedure FixWins ; {Checks for gaps in Win Memory and fills them}

Var Good:Boolean ;
    Goat, WinNum, Slug:Byte ;

Begin
	Good := True ;
  Slug := 1 ;
	WinNum := CurrentWin+1 ;
  If WinNum > 1 then {Watching out for if there are NO windows...}
	  Repeat
	  	Dec( WinNum ) ;
	    If Scrn[ WinNum ].Status = False then Good := False ;
	  Until ( WinNum <= 1 ) ;
  If Not Good then                             {Only filter in necessary}
    Repeat
     	If Scrn[ Slug ].Status = False then
       	Begin
         	For Goat := Slug to CurrentWin-1 do   {Pushes out all mem bubbles}
           	Scrn[ Goat ] := Scrn[ Goat + 1 ] ;
         	Scrn[ CurrentWin ].Status := False ;       {GOOD STUPH!}
        end
      else
      	Inc( Slug ) ;
    Until Slug > CurrentWin ;
end ; {FixWins PROC}

Procedure DisplayTime( x, y:Byte ; ShowSec, ShowHun, Twelve:Boolean ) ;

Var Hour, Min, Sec, Hun:Word ;
		pm:Boolean ;
		Colon:Char ;
    Bird:String[ 20 ] ;
    Amanda:String[ 5 ] ;

Begin
	GetTime( Hour, Min, Sec, Hun ) ;
	If Sec mod 2 = 0 then Colon:=' '
		else Colon := ':' ;
	If Twelve then
		If Hour > 12 then
			Begin
				Dec( Hour, 12 ) ;
				pm:=TRUE ;
			end
		else pm:=false ;
  Bird := '' ;
  Str( Hour, Amanda ) ;
	If Hour<10 then Bird := ' ' ;
	Bird := Bird + Amanda + colon ;
  Str( Min, Amanda ) ;
	If Min<10 then Bird := Bird + '0' ;
	Bird := Bird + Amanda ;
	If ShowSec then
  	Begin
    	Bird := Bird + Colon ;
      Str( sec, Amanda ) ;
			If sec<10 then Bird := Bird + '0' ;
			Bird := Bird + Amanda ;
    end ;
	If ShowHun then
  	Begin
    	Bird := Bird + Colon ;
      Str( hun, Amanda ) ;
			If hun<10 then Bird := Bird + '0' ;
			Bird := Bird + Amanda ;
  	end ;
	If Twelve then
		If pm=True then Bird := Bird + ' pm.'
			else Bird := Bird + ' am.'
	else Bird := Bird + '.   ' ;
  WriteStr( x, y, Bird ) ;
end; {DisplayTime Proc}

Procedure InitWins ;

Var i:Byte ;

Begin
	For i := 1 to NumOfWins do     {Sets all Win conditions to Closed/False}
		Scrn[ i ].Status := False ;
end ; {InitWins PROC}

Procedure Hilite( x, linenum, Col, Len:Byte ) ;

Var A:Byte ;

Begin
	For A:=1 to len do
		Mem[ $B800:( (linenum-1)*80+x+a-2 )*2+1 ] := Col*16 + White ;
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

Procedure WinUp( Left, Top, Right, Bottom:Byte ) ;   {Draw & Make a win}

Var i, j, WinNum:Byte ;

Begin
	FixWins ;
	WinNum := CurrentWin + 1 ;
  Scrn[ WinNum ].Status := True ;
	Scrn[ WinNum ].Top    := Top ;
	Scrn[ WinNum ].Bottom := Bottom ;
	Scrn[ WinNum ].Left   := Left ;
	Scrn[ WinNum ].Right  := Right ;
	For J:=top to bottom do
		For I:=Left to Right do
			Begin                          {Make CharMask}
				Scrn[WinNum].CharMask[ i, j ] := GetChar( i, j ) ;
        Scrn[WinNum].AttribMask[ i, j ] := GetChar_A( i, j ) ;
      end ;
	BorderMohn( Left, Top, right, bottom, black, white ) ;    {Border}
	For j:=top+1 to bottom-1 do
		For i:=left+1 to right-1 do
			If (Scrn[WinNum].CharMask[I,J] <> ' ')
				or (Scrn[WinNum].AttribMask[I,J] <> Black*16+White) then 
					WriteChar_a( i, j, ' ', Black*16+White ) ; {Skip unnecessary spaces}
end ; {Proc WinUp}

Procedure WinDown ; {Simplified: Closes only front window}

Var i, j, WinNum:Byte ; {Originally were Integers. Why??? STUPID!!!}

Begin
	WinNum := CurrentWin ;   {Find which Win to Close}
	If WinNum>0 then         {If none open, just exit}
		With Scrn[ WinNum ] do
			begin
				Status:=False ;       {Kill the Win}
				For J:=Top to Bottom do
					For I:=Left to Right do
						If ( CharMask[I,J] <> GetChar( i, j ) ) or
							( AttribMask[I,J] <> GetChar_A( i, j ) ) then
								Writechar_a( i, j, CharMask[i,j], AttribMask[i,j] ) ;{Erase}
    	end ;
end ; {WinDown Proc}

Procedure MoveWin( DeltaX, DeltaY:Integer ) ; {Relative to current loc.}
																							{Effective on Current Win.}
Var Inside:Win ;
		I, J:Integer ;
                              {I never use this crap.}
Begin          										{However, it >>DOES<< work...}
	With Scrn[ CurrentWin ] do         {Maintains the window's inside juice}
	  Begin
			For J := ( Top + 1 ) to ( Bottom - 1 ) do
	    	For I := ( Left + 1 ) to ( Right - 1 ) do
	      	Begin
	        	Inside.CharMask[ i+DeltaX, j+DeltaY ] := GetChar( i, j ) ;
	          Inside.AttribMask[ i+DeltaX, j+DeltaY ] := GetChar_a( i, j ) ;
	        end ;
      Inside.Top:=Top+DeltaY ;
      Inside.Bottom:=Bottom+DeltaY ;
      Inside.Right:=Right+DeltaX ;
      Inside.Left:=Left+DeltaX ;
    end ; {With Scrn[ CurrentWin ]}
  WinDown ;
  With Inside do
  	Begin
			WinUp( Left, Top, Right, Bottom ) ;
      For J:=Top+1 to Bottom-1 do
      	For I:=Left+1 to Right-1 do
         	WriteChar_a( i, j, CharMask[i,j], AttribMask[i,j] ) ;
		end ; {With inside}
end ; {MoveWin Proc}


Procedure CloseAllWins ; {Guess what it does?}

Begin
	{For I:= CurrentWin downto 1 do}      {Revised with While..Do}
  While CurrentWin > 0 do								{Safer than For/to/do}
		WinDown ;
end ; {CloseAllWins Proc}


Procedure ChillOut( hun:Word ) ; {Revised with faster formula for time calc}

{No Negative Numbahs, please...} {Just insert the huns of a sec to wait....}

Var Hour, Min, Sec, h, Hour2, M2, S2, h2:word ;

Begin
	GetTime( Hour, Min, Sec, H ) ;    {Get Original Time}
	Repeat
		GetTime( Hour2, m2, s2, h2 ) ;
		If (Hour=23) and (Hour2<23) then Inc( Hour2, 24 ) ;
    Inc( h2, 100*( (s2 - Sec) + 60*( m2 - Min + 60*(Hour2-Hour) ) ) ) ;
	Until ( H2 - H ) >= hun ;        {Wait till the specified time}
end ; {ChillOut Proc}

end.