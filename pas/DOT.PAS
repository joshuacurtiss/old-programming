Program DotMohn ;

Uses CRT, ZakMohn ;

Var Key:Char ;
		Stage, x, y:Byte ;
    Count:Integer ;

Procedure Dot ;

Begin
	Case Stage of
  	1:WriteChar( x, y, Chr( 250 ) ) ;
    2:WriteChar( x, y, Chr( 249 ) ) ;
    3:WriteChar( x, y, Chr( 254 ) ) ;
    4:WriteChar( x, y, Chr( 249 ) ) ;
  end ;
  Inc( Count ) ;
  If Count > 2000 then
		Begin
		  Inc( Stage ) ;
      Count:=0 ;
    end ;
  If Stage > 4 then Stage:=1 ;
end ;

Begin
  InitWins ;
	WinUp( 1, 1, 80, 25 ) ;
  ClrScr ;
  x:=35 ;
  y:=12 ;
  Stage:=1 ;
  Count:=0 ;
	Repeat
    While NOT KeyPressed do Dot ;
    Key:=ReadKey ;
    WriteChar( x, y, ' ' ) ;
    If Key=#0 then Key:=Readkey ;
    Case key of
    	UpArrow:
      	Begin
        	Dec( y ) ;
          If y<1 then Y:=1 ;
        end ;
      DownArrow:
      	Begin
        	Inc( Y ) ;
          If Y>25 then y:=25 ;
        end ;
      LeftArrow:
      	Begin
        	Dec( x ) ;
          If x<1 then x:=1 ;
        end ;
      RightArrow:
      	Begin
        	Inc( x ) ;
          If x>80 then x:=80 ;
        end;
    end ; {CASE}
  Until ( Key = CR ) or ( Key = ESC ) ;
  CloseAllWins ;
  GotoXY( 1, 25 ) ;
end.