Program PlayWithGrafix ;

Uses crt, dos, Graph, ZakMohn ;

Var I, x, y:Integer ;
    Key:Char ;
    p, c:Pointer ;

Const Path = 'C:\TP\BGI' ;


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
		If KeyPressed then
			begin
				Key:=Readkey ;
				If Key=#0 then Key:=Readkey ;
			end ;
	Until ( Key = #13 ) or ( Key = #27 ) ;
	WinDown ;
end ; {FYI Proc}


Procedure MakeArrowPtr ;

Var Size:Word ;

Begin
	ClearDevice ;
  SetColor( White ) ;
  MoveTo( 1, 1 ) ;
  Lineto( 1, 11 ) ;
  Lineto( 7, 7 ) ;
  Lineto( 1, 1 ) ;
  FloodFill( 2, 9, White ) ;
  Size := ImageSize(0,0,8,12);
  GetMem(P, Size); { Get memory from heap }
  GetMem(C, Size);
  GetImage( 20, 0, 28, 12, C^ ) ;
  GetImage(0,0,8,12,P^);
  ClearDevice ;
end ;


Procedure InitGraphics ;

Var Gd, Gm, ErrorCode:Integer ;

Begin
  Gd := Detect;
	InitGraph( Gd, Gm, Path );
  ErrorCode := GraphResult ;
  If ErrorCode <> grOk then
		Begin
			FYI( GraphErrorMsg(ErrorCode) ) ;
			Halt(1);
    end ;
  ClearDevice ;
end ; {InitGraphics PROC}


Procedure MoveArrow ;

Begin
	PutImage( x, y, p^, NormalPut ) ;
	Key:=Readkey ;
  If Key=#0 then Key:=Readkey ;
  PutImage( x, y, c^, NormalPut ) ;
  Case Key of
  	UpArrow:Dec( y,5 ) ;
    DownArrow:Inc( y,5 ) ;
    RightArrow:Inc( x, 10 ) ;
    LeftArrow:Dec( x, 10 ) ;
  end ;
  If x<0 then x:=0
  else If x>630 then x:=630 ;
  If y<0 then y:=0
  else If y>468 then y:=468 ;

end ;



Begin
	InitGraphics ;
  MakeArrowPtr ;
  X:=30 ;
  Y:=40 ;
  Key := ' ' ;
	While Key <> #13 do
  	MoveArrow ;
  CloseGraph ;
end.