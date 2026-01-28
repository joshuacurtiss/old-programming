Program CopyToHardDrive ; {Specific}

Uses CRT, DOS, Zakmohn ;

Var Temp:String ;

Procedure WriteCenter( C, y:Byte ; Text:String ) ;

Begin
	If C - ( Length( Text ) Div 2 ) > 0 then
  	WriteStr( ( C - (Length(Text) Div 2) ), y, Text )
  else
  	WriteStr( 1, Y, Text ) ;
end ; {WriteCenter Proc}


Procedure Message( Jenny:String ) ;
Begin
  If Length( Jenny ) < 40 then
  	Begin
			WinUp( 19, 10, 61, 12 ) ;
      WriteCenter( 40, 11, Jenny ) ;
    end ;
end ;

Procedure Ex( C:String ) ;
Begin
  C:='/C ' + C ;
	SwapVectors ;
	Exec(GetEnv('COMSPEC'), C); {Temporarily exit and go to}
	SwapVectors;                {the other program}
end ;

Begin {$M 8192, 0, 0}
	InitWins ;
  Message( 'Finding Source File...' ) ;
  Temp := FSearch( 'Runner.EXE', 'a:\' ) ;
  WinDown ;
  If Temp = '' then
  	Begin
    	Message( 'Couldn''t locate Source File in A:' ) ;
      Halt( 1 ) ;
    end ;
  Message( 'Checking Destination...' ) ;
  {$I-}
  	ChDir( 'C:\Batches' ) ;
    If IOResult = 3 then
    	Begin
      	MkDir( 'C:\Batches' ) ;
        ChDir( 'C:\Batches' ) ;
        If IOResult <> 0 then
        	Begin
          	Message( 'Couldn''t Verify Destination.' ) ;
            Halt( 1 ) ;
          end ;
      end ;
  {$I+}
  WinDown ;
  Message( 'Updating Files...' ) ;
  If FSearch( 'Runner.EXE', 'C:\Batches' ) <> '' then
	  Ex( 'Del c:\Batches\Runner.EXE' ) ;
  Ex( 'Copy a:\Runner.EXE c:\Batches\Runner.EXE' ) ;
  CloseAllWins ;
  GotoXY( 1, WhereY ) ;
  Writeln( 'Installation Completed.' ) ;
end.