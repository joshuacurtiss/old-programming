Program PlayWithGrafix ;

Uses crt, dos, Graph, ZakMohn ;

Var I, x, y:Integer ;
    Key:Char ;
    Xs, Ys:String ;
    Box:Array[ 0..15 ] of Pointer ;

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


Procedure MakeShapes ;

Var Size:Word ;

Begin
	ClearDevice ;
  For I:=0 to 15 do
  	Begin
		  SetColor( White ) ;
		  Rectangle( 50, 50, 100, 100 ) ;
			SetFillStyle(SolidFill, I) ;
		  FloodFill( 60, 60, White ) ;
		  SetColor( White ) ;
		  Rectangle( 50, 50, 100, 100 ) ;
		  Size := ImageSize( 50, 50, 100, 100 ) ;
		  GetMem( Box[i], Size ) ; { Get memory from heap }
		  GetImage( 50, 50, 100, 100, Box[i]^ ) ;
		  ClearDevice ;
    end ; {For to do}
  SetColor( White ) ;
end ;

Begin
	InitGraphics ;
  MakeShapes ;
  x:=getmaxx ;
  y:=getmaxy ;
  Key := ' ' ;
  MoveTo( 10, 10 ) ;
  Inc( x ) ;
  Inc( y ) ;
  Str( x, xs ) ;
  Str( y, ys ) ;
 	OutText( 'Max. Res: '+xs+ ' x '+ ys + '. ' ) ;
  x:=75 ;
  y:=30 ;
  I:=-1 ;
  While ( x < 630 ) and ( I <= 16 ) do
  	Begin
    	Inc( i ) ;
    	PutImage( x, y, Box[ i ]^, NormalPut ) ;
      Inc( x, 25 ) ;
      Inc( y, 25 ) ;
    end ;
  Readln ;
  CloseGraph ;
end.
