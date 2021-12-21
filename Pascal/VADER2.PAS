Program vaders2;
{this is Version 1.5 b}

uses zakmohn, crt, dos;

CONST

  Left      = False ;
  DAction   = 10000 ;
  Right     = True ;
  ColMax    = 10 ;
  RowMax    = 10 ;
  Empty     = 0  ;
  UpArrow   = #72;  DownArrow  = #80;
  LeftArrow = #75;  RightArrow = #77;
  PgUp      = #73;  PgDn       = #81;
  HomeKey   = #71;  EndKey     = #79;
  Ins       = #82;  Del        = #83;
  Null      = '' ;  Space      = #32;
  tri       = #30;  bul        = #46;
  bot1a     =#236;  bot1b      = #232;

var

  Level : integer;
  Lives : integer;
  Score : integer;
  keypress : char;
  xpos, Time : integer;
  Dir : Boolean ;
  impact, i, j, DeltaX, DeltaY : byte;
  Army : Array[ 1..ColMax, 1..RowMax ] of Byte ;


Function WhichDude( C:Byte ):Char ;
Begin
  If C mod 2 = 0 then WhichDude := Bot1a
  else WhichDude := Bot1b ;
end ;


Function CheckCol( c,r:Byte ):Boolean ; {True if peoples are in deah}

Var ItBeTrue:Boolean ;

Begin
  ItBeTrue := True ;
  {For r := 1 to Rowmax do}
  If Army[ c, r ] <> Empty then ItBeTrue := False ;
  CheckCol := Not ItBeTrue ;
end ;


procedure ship(xpos, col :integer);

begin
  textcolor(col);
  gotoxy(xpos, 25);
  write(tri);
end;  {ship}

procedure redraw(xpos : integer; keypress : char);

var xposs : integer;

begin
  if keypress=#75 then {left}
    begin
      xposs:=xpos+1;
      ship(xposs, black);
      ship(xpos, white);
    end;
  if keypress=#77 then {right}
    begin
      xposs:=xpos-1;
      ship(xposs, black);
      ship(xpos, white);
    end;
end;  {redraw}

procedure moveship(keypress : char; var xpos : integer);

begin
  if keypress=#75 then  {left}
    begin
      dec(xpos);
      redraw(xpos, keypress);
    end;
  if keypress=#77 then   {right}
    begin
      inc(xpos);
      redraw(xpos, keypress);
    end;
end; {moveship}


Procedure boom(c,r : byte); {boom da bot}
begin
  Army[c,r]:=0;
end;


procedure robots;  {WriteChar( x, y, 'What to say' )         }
                        {WriteChar is ignorant of TextColor calls}
Var Hi, Bye:Byte ;
    waiter : integer;

Begin
  inc(waiter);
  if waiter >32000 then waiter :=0;
  if waiter mod Daction=0 then
    begin
      For Hi := 1 to ColMax do
        For Bye := 1 to RowMax do
          Begin
            Gotoxy( Hi*2+DeltaX, Bye+DeltaY ) ;
            Write( ' ' ) ;
          end;
        Textcolor( White ) ;
        If Dir = Right then Inc( DeltaX )
        else Dec( DeltaX ) ;
        If ( DeltaX < 0 ) or ( DeltaX+ColMax*2 > 80 ) then
          Begin
            Dir := Not Dir ;
            Inc( DeltaY ) ;
            If DeltaY + RowMax > 25 then Halt ;
          end;
        For Hi := 1 to ColMax do
          For Bye := 1 to RowMax do
            Begin
              GotoXY( Hi*2+DeltaX, Bye+DeltaY ) ;
              Write(WhichDude( hi*2+DeltaX ) ) ;
            end ;
    end;
end ;


procedure fireshot(var xpos : integer);

var xposse, ypos : integer;
    clearage : char;

begin
  ypos:=24;
  xposse:=xpos;
  textcolor(red);
  gotoxy(xposse,ypos);
  write(bul);
  repeat
    begin
      if keypressed then
        begin
          keypress:=readkey;
          if (keypress=#75) or (keypress=#77) then
          moveship(Keypress, xpos);
        end;
      chillout(10);
      dec(ypos);
      textcolor(black);
      gotoxy(xposse,ypos+1);
      robots;
      If checkcol(xposse, ypos)=True then Boom(xposse,ypos);
      write(bul);
      textcolor(white);
      gotoxy(xposse,ypos);
      write(bul);
      if keypressed then
        begin
          keypress:=readkey;
          if (keypress=#75) or (keypress=#77) then
            moveship(Keypress, xpos);
        end;
    end;
  until (ypos=1) or (impact>0);
  gotoxy(xposse,ypos);
  textcolor(black);
  write(bul);
  while keypressed do
    clearage:=readkey;

end; {fireshot}

procedure Controlproc;
begin
    xpos:=40;
    repeat
      If Keypressed then
        Keypress:=Readkey;
      If Keypress=#0 then
      begin
        Keypress:=Readkey;
        if (keypress=#75) or (keypress=#77) then
          moveship(Keypress, xpos);
        if keypress=#83 then
          fireshot(xpos);
      end;{keypress}
      robots;
    until (lives=0) or (keypress='q');
end;

begin
  lives:=3;
  Level:=1;
  Score:=0;
  repeat
    Controlproc;
  until (lives=0) or (keypress='q');
end.{main}
