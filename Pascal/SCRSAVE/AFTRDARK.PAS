Program AfterDarkTest ;

Uses CRT, DOS, Joshmohn, ScrSave2, DillTool ;

Var Check:Char ;
    i, j:Integer ;
    Juice:String ;

Begin       {$M 8192, 0, 0}
  InitWins ;
  SetScreenSaverTime( 0.2 ) ;
  DillyMax := 150 ;
  DillyTextCol := Black ;
  DillyBackCol := Red   ;
  DillyCursCol := White ;
  WinUp( 20, 5, 40, 7 ) ;
  Repeat
  	DisplayTime( 22, 6, True, True, True ) ;
  Until Keypressed ;
  WinDown ;
  repeat
  	Juice := dilly( 10, 70, 12, 'Juice is contained in here.' ) ;
	Until Juice = 'X' ;
	SwapVectors;
	Exec(GetEnv('COMSPEC'), '/C C:\Batches\Sysinfo' );
	SwapVectors;

end.