Program GraphProgs ;

Uses CRT, Graph ;

Var k:Char ;
    gd, gm:Integer ;

Procedure CheckGraph ;

{ Example for GraphResult }

var
  ErrorCode : Integer;
  GrDriver, GrMode : Integer;
begin
  GrDriver:=Detect ;
  InitGraph(GrDriver, GrMode, 'C:\TP\BGI');
  ErrorCode := GraphResult;
  if ErrorCode <> grOK then
  begin
    WriteLn('Graphics error:');
    WriteLn(GraphErrorMsg(ErrorCode));
    WriteLn('Program aborted...');
    Halt(1);
  end;
  { Do some graphics... }
  ClearDevice;
  Rectangle(5, 5, 20, 20 );
  ReadLn;
  CloseGraph;
end;


Procedure GetAndPutImage ;

{ Example for GetImage, ImageSize, and PutImage }

var
  Gd, Gm : Integer;
  P      : pointer;
  Size   : Word;
begin
  Gd := Detect; InitGraph(Gd, Gm, 'c:\tp\bgi');
  if GraphResult <> grOk then Halt(1);
  Bar( 5, 33, GetMaxX, GetMaxY);
  Bar( 0, 0, 0, 25 ) ;
  Size := ImageSize(10,20,30,40);
  GetMem(P, Size); { Get memory from heap }
  GetImage(10,20,30,40,P^);
  ReadLn;
  ClearDevice;
  PutImage(100, 100, P^, NormalPut);
  ReadLn;
  CloseGraph;
end;

Procedure TextThing ;

{ Example for OutTextXY }

var
  Gd, Gm : Integer;
begin
  Gd := Detect; InitGraph(Gd, Gm, 'C:\tp\bgi');
  if GraphResult <> grOk then Halt(1);
  MoveTo(0, 0);
  OutText('Inefficient');
  ReadLn;
  OutTextXY(GetX, GetY, 'Also inefficient');
  ReadLn;
  ClearDevice;
  OutTextXY(0, 0, 'Perfect!');
  ReadLn;
  CloseGraph;
end;


Begin
  Gd := Detect; InitGraph(Gd, Gm, 'C:\tp\bgi');
  if GraphResult <> grOk then Halt(1);
  ClearDevice ;
  Moveto( 1, 15 ) ;
  OutText( 'Which?' ) ;
  OutTextXY( 1, 45, '1. CheckGraph' ) ;
  OutTextXY( 1, 55, '2. Get and Move Grafix' ) ;
  OutTExtXY( 1, 65, '3. Text' ) ;
  OutTextXY( 4, 75, 'Yeah? ' ) ;
  k:=Readkey ;
  Case K of
  	'1':CheckGraph ;
    '2':GetAndPutImage ;
    '3':TextThing ;
  end ; {Case}
  CloseGraph ;
end. {Da Prog}