Unit ZakMohn ;    {Ver. for Class or General Use}

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

	Procedure InitWins ;
	Function  CurrentWin:Integer ;
	Procedure BorderMohn( Left, Top, Right, Bottom:Byte ; Back, Txt:Byte ) ;
	Procedure WinUp( Left, Top, Right, Bottom:Byte ) ;
	Procedure Windown ;
	Procedure MoveWin( DeltaX, DeltaY:Integer ) ;
	Procedure CloseAllWins ;

  Procedure WriteCenter( Text:String ) ;
	Procedure DisplayTime( x, y:Byte ; ShowSec, ShowHun, Twelve:Boolean ) ;
	Procedure HiLite( x, linenum, Col, Len:Byte ) ;
	Procedure ChillOut( Hun:Word ) ;

Implementation

Function GetChar_A (x, y:Byte):Byte;

Begin
	GetChar_A:=( memw[$B800:2* ((x-1) + (y - 1) * 80)] ) Div 256 ;
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

Procedure WriteCenter( Text:String ) ; {Writes in center of current line}

Begin
	If 40 - ( Length( Text ) Div 2 ) > 0 then
  	WriteStr( ( 40 - (Length(Text) Div 2) ), WhereY, Text )
  else
  	WriteStr( 1, WhereY, Text ) ;
  If WhereY < 25 then
  	GotoXY( 1, WhereY+1 ) ;
end ; {WriteCenter Proc}

Function CurrentWin:Integer ; {Actually outputs the num of windows onscreen.}
															{Effectively outputs the current window.}
Var a:Integer ;

Begin
	A:=NumOfWins + 1 ;
	Repeat
		Dec( a ) ;
	Until ( a=0 ) or ( Scrn[ a ].Status = True ) ; {Check thru wins until 1st}
	CurrentWin := a ;                              {good one is found.}
end ; {CurrentWin Function} {If no Wins, CurrentWin = 0}

Procedure DisplayTime( x, y:Byte ; ShowSec, ShowHun, Twelve:Boolean ) ;

Var Hour, Min, Sec, Hun:Word ;
		pm:Boolean ;
		Colon:Char ;

Begin
	GetTime( Hour, Min, Sec, Hun ) ;
	If Sec mod 2 = 0 then Colon:=' '
		else Colon := ':' ;
	If Twelve = true then
		If Hour > 12 then
			Begin
				Hour:=Hour - 12 ;
				pm:=TRUE ;
			end
		else pm:=false ;
	GotoXY( x, y ) ;
	If Hour<10 then Write( ' ', Hour, colon )
		else Write( Hour, colon ) ;
	If Min<10 then Write( '0', Min )
		else Write( min ) ;
	If ShowSec then
		If sec<10 then Write( colon, '0', sec )
			else Write( colon, sec ) ;
	If ShowHun then
		If hun<10 then Write( colon, '0', hun )
			else Write( colon, hun ) ;
	If Twelve=true then
		If pm=True then Write( ' pm.' )
			else Write( ' am.' )
		else Write( '.   ' ) ;
end; {DisplayTime Proc}

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
							( AttribMask[I,J] <> GetChar_A( i, j ) ) then
								Writechar_a( i, j, CharMask[i,j], AttribMask[i,j] ) ;{Erase}
    	end ;
end ; {WinDown Proc}

Procedure MoveWin( DeltaX, DeltaY:Integer ) ; {Relative to current loc.}
																							{Effective on Current Win.}
Var Inside:Win ;
		I, J:Integer ;

Begin
	With Scrn[ CurrentWin ] do
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

Var I:Integer ;

Begin
	For I:= CurrentWin downto 1 do
		WinDown ;
end ; {closeAllWins Proc}


Procedure ChillOut( hun:Word ) ; {Not Suggested for use over one hour.   }
																 {      Who would want to?               }
{Do not feed this guy Neg Nums!} {May puke out at the stroke of midnight.}

Var Hour, Min, Sec, h, Hour2, M2, S2, h2:word ;

Begin
	GetTime( Hour, Min, Sec, H ) ;    {Get Original Time}
	Repeat
		GetTime( Hour2, m2, s2, h2 ) ;
		If (Hour=23) and (Hour2<23) then Hour2:=24 + Hour2 ;
		m2:=m2 + 60 * (Hour2 - Hour) ;
		s2:=s2 + 60 * (m2 - min) ;     {Find the Change in Time in Hundredths}
		h2:=h2 + 100 * (s2 - sec) ;
	Until ( H2 - H ) >= hun ;        {Wait till the specified time}
end ; {ChillOut Proc}

end.