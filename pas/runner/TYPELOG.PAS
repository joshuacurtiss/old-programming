Program TypeLog ;

Uses CRT, DOS, Zakmohn, ScrnSave ;

Const Max = 19 ; Nuthin = '(EMPTY)' ;

Var F:File of String ;
		S:Array[ 0..Max ] of String ;
    I:Integer ;
    Key:Char ;
    Mickey:Byte ;

Procedure LoadPage( Top:Integer ) ;

Var bilbo:Integer ;

Begin
	Reset( F ) ;
  Bilbo := Top ;
  Repeat
    Seek( f, Bilbo ) ;
    Read( f, s[ Bilbo - Top ] ) ;
    Inc( Bilbo ) ;
  Until ( Bilbo >= FileSize( f ) ) or ( Bilbo > Top + 19 )  ;
end ;

function IntToStr(i: Longint): string;
{ Convert any Integer type to a string }
var
  q: string[11];
begin
  Str(i, q);
  IntToStr := q;
end;

Begin
	For I:=0 to Max do S[ i ] := Nuthin ;
	Clrscr ;
  Assign( f, 'C:\Batches\MenuActs.LOG' ) ;
	{$I-}
  I := 0 ;
	ClrScr ;
  WinUp( 1, 4, 80, 25 ) ;
  WriteStr( 5, 2, 'Runner Log' ) ;
  WriteChar( 1, 4, Chr( 218 ) ) ;
  WriteChar( 80, 4, Chr( 191 ) ) ;
  WriteChar( 1, 25, Chr( 192 ) ) ;
  WriteChar( 80, 25, Chr( 217 ) ) ;
  WriteStr( 63, 2, 'Page:  1' ) ;    {X=70}
  Repeat
	  LoadPage( i ) ;
	  For Mickey := 24 downto 5 do
	  	Begin
	    	WriteStr( 3, Mickey, '                                                                             ' ) ;
	      If S[ Mickey - 5 + i ] <> Nuthin then
					WriteStr( 3, Mickey, Copy( s[ Mickey-5 ], 1, 77 ) ) ;
			end ;
    WriteStr( 70, 2, IntToStr( ( I Div 19 ) + 1 ) ) ;
	  Key := WaitForKeypress ;
	  If Key = #0 then Key := Readkey ;
	  Case Key of
	  	UpArrow : Dec( i ) ;
	    DownArrow : Inc( i ) ;
	    PgUp : Dec( i, 19 ) ;
	    PgDn : Inc( i, 19 ) ;
	  end ; {Case}
    If I < 0 then I:=0
    else If I + 18 > FileSize( f ) then I := FileSize( f )-18 ;
  Until ( Key = #13 ) or ( Key = #27 ) ;
  ClrScr ;
end.