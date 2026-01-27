Unit MenuTool ;

Interface

Uses CRT, ZakMohn, ScrSave2 ;

Const	Null = '' ;

Var M:Array[ 1..20 ] of String[ 80 ] ;

Function MenuCooh( HowFar:Byte ):Byte ;
Function Menu( l, u, r, d:Byte ; Title, Crud:String ):Byte ;

Implementation

Function MenuCooh( Howfar:Byte ):Byte ;

Var Counter, Good:Byte ;  {Enables program to function properly when there}
                          {are spaces between options in the menu (Gaps)  }
Begin
	Counter := 0 ;          {Then there can be menu options and the Exit all}
	Good    := HowFar ;			{the way on the bottom. Then just add more options}
	Repeat									{in the gap as necessary.}
  	Inc( Counter ) ;
		If m[ Counter ] <> Null then Dec( Good )
	Until Good = 0 ;
	MenuCooh := Counter ;  {Returns the # of ALL, not just good, entries}
end ;

Function Menu( l, u, r, d:Byte ; Title, Crud:String ):Byte ;
              																										{No more than 20 Opts}
Var i, k, Opt, NumOfItems, Width, ReturnVal:Byte ;
    key:Char ;
    Okay:Boolean ;

Begin
	SetScreenSaverTime( 0.5 {Minutes} ) ;
	ReturnVal := 0 ;
	Width := r - l - 1 ;
  For I:=1 to 20 do M[ i ] := Null ;
  I:=1 ;
  K:=0 ;
  Repeat
  	Inc( K ) ;
    If ( Crud[k] = '/' ) or ( Crud[k] = '\' ) then
    	Begin
 				Inc( i ) ;
        If I>20 then I:=20 ;
      end
    else
    	Begin
				m[ i ] := m[ i ] + Crud[ k ]
      end ;
  Until ( K = Length( Crud ) ) ;
  K:=Length( Title ) ;
  Okay := True ;
	For I:=1 to 20 do
		If Length( m[ i ] ) > k then K:=Length( m[ i ] ) ;
  If K+1 > Width then
  	Begin
    	ReturnVal := 101 {Not Wide Enough} ;
 			Okay := False ;
    end ;
  NumOfItems := 0 ;
  For K:=1 to 20 do If m[ k ] <> Null then Inc( NumOfItems ) ;
  If d-u < NumOfItems + 3 then
  	Begin
    	ReturnVal := 102 {Not Long Enough} ;
      Okay := False ;
    end ;
  If Okay then
    Begin
			WinUp( l, u, r, d ) ;
      If Length( Title ) + 3 > Width then WriteStr( L+1, U+1, Title )
      else
        WriteStr( (L+Width Div 2 ) - Length( Title ) Div 2, U+1, Title ) ;
      For K:=1 to NumOfItems do
      	WriteStr( l+2, U+2+K, m[ MenuCooh( k ) ] ) ;
      Opt := 1 ;
      Repeat
      	HiLite( L+1, U+2+Opt, Blue, R-L-1 ) ;
        Key := WaitForKeypress ;
        If Key = #0 then Key := Readkey ;
        HiLite( L+1, U+2+Opt, Black, R-L-1 ) ;
        Case key of
        	UpArrow:Dec( Opt ) ;
          DownArrow:Inc( Opt ) ;
        end ;
        If Opt < 1 then Opt := NumOfItems
        else if Opt > NumOfItems then Opt:=1 ;
      Until ( Key = #13 ) or ( Key = #27 ) ;
      WinDown ;
      ReturnVal := MenuCooh( Opt ) ;
      If Key = #27 then ReturnVal := 0 ;
		end ; {If Okay}
  Menu:=ReturnVal ;
end ; {Menu Function}

end.