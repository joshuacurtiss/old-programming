Program LaSpiral ;

Uses MSGraph, CRT ;

Var col, col2:integer ;
		A:INTEGER ;
		count, x, y:Integer ;

procedure SetCol(cnum,r,g,b:byte); {Zero to 63}
begin
 port[$3c8]:=cnum;
 port[$3c9]:=r;
 port[$3c9]:=g;
 port[$3c9]:=b;
end;

Begin
	Count:=0 ;
	A:=_SetVideoMode( 19 ) ;
	_SetColor( Black ) ;
	_FloodFill( 0, 0, 15 ) ;
	Repeat
		Randomize ;
		Col:=Random( 16 ) + 1 ;
	Until ( Col <> Black ) ;
	_MoveTo( 40, 20 ) ;
	_SetColor( 1 ) ;
	_LineTo( 40, 180 ) ;
	_LineTo( 120, 20 ) ;
	_LineTo( 40, 20 ) ;
	_FloodFill( 41, 21, 1 ) ;
	_MoveTo( 170, 20 ) ;
	_LineTo( 250, 20 ) ;
	_LineTo( 250, 180 ) ;
	_LineTo( 170, 20 ) ;
	_FloodFill( 180, 22, 1 ) ;
	_MoveTo( 120, 140 ) ;
	_LineTo( 145, 80 ) ;
	_LineTo( 190, 180 ) ;
	_LineTo( 160, 180 ) ;
	_LineTo( 145, 140 ) ;
	_LineTo( 120, 140 ) ;
	_FloodFill( 122, 139, 1 ) ;
	repeat
		Inc( Count ) ;
		setcol(1, random(63), random(63), random(63));
		If ( Count<40 ) or ( Count > 10000 ) then delay(900);
		If Count >10020 then Count:=0 ;
	until keypressed;
	A:=_SetVideoMode( 3 ) ;
end .

