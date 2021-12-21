Program TestDilly ;

Uses CRT, DOS, Joshmohn, ScrSave2, DillTool ;

Var TheString, TheFile, Result:String ;
    DillyMax:Byte ;

Begin
  ClrScr ;

  {Settings:}
  SetScreenSaverTime( 5 ) ;
  DillyMax := 100 ;

  WriteStr( 3, 3, 'This Program uses a nifty input procedure called ''Dilly''' ) ;
  WriteStr( 5, 7, 'Path to search in:' ) ;
  TheString := Dilly( 25, 65, 7, '' ) ;
  WriteStr( 2, 12, 'What file:' ) ;
  WriteStr( 1, 10, 'Path: "' + TheString + '"' ) ;
  GotoXY( 13, 12 ) ;
  DillyMax := 12 ;
  TheFile := Dilly( 13, 79, 12, '' ) ;
  Result := FSearch( TheFile, TheString ) ;
  Writeln ;
  Writeln( 'Search result: ', FExpand( Result ), '.' ) ;
  Result := WaitForKeypress ;
end.
