Program StizzNUFF_It ;

Uses CRT, Joshmohn ;

Const a=1  ; b=2  ; c=3  ; d=4  ;
			ra=5 ; rb=6 ; rc=7 ; rd=8 ;
      Default = True ;
      Top = True ; Bottom = False ;

Var	Fp, cfp, Size:Word ;
    f, cf:File of Byte ;

Function NextVal:Byte ;

Var q:Byte ;

Begin
	If fp < FileSize( f ) then
  	Begin
			Seek( f, FP ) ;
		  Read( f, q ) ;
		  Inc( FP ) ;
    end
  else q := 99 ;
	NextVal := q ;
end ; {NextVal FUNCTION}

Procedure Pause ;
Begin
	Repeat Until Keypressed ;
end ;

Procedure Init ;
Begin
	InitWins ;
	Assign( f, 'C:\Image.JMC' ) ;
	Assign( cf, 'C:\Image.sit' ) ;
  {$I-}
  	Reset( f ) ;
    If IOResult <> 0 then
    	Begin
      	WinUp( 17, 10, 43, 14 ) ;
      	WriteStr( 19, 12, 'No Picture to compress.' ) ;
        Pause ;
        CloseAllWins ;
        Exit ;
      end ;
    Reset( cf ) ;
    If IOResult <> 0 then Rewrite( cf ) ;
  {$I+}
  FP := 0 ;
	CFP := 0 ;
end ; {INIT PROC}

Procedure Scroll( Which:Boolean ) ;

Var i, y:Byte ;

Begin
	If Which = Top then y := 9
  else y := 15 ;
	For I := 3 to 79 do
  	WriteChar( i-1, y, GetChar( i, y ) ) ;
  WriteChar( 79, y, ' ' ) ;
end ;


Procedure RepeatValueSweepCompress ;

Var i, TheVal, Reps, Dumz:Byte ;
    Key:Char ;

Begin
  Rewrite( cf ) ;
  TheVal := 0 ;
  Reps := 0 ;
  Repeat
		i := NextVal ;
    GotoXY( 32, 2 ) ;
    Write( fp, ' of 65536. ', ( fp/65536 )*100:2:0, '%' ) ;
    Inc( Reps ) ;
    If i <> TheVal then
  	 	Begin
      	If Reps > 1 then
        	Begin
          	Dumz := TheVal+4 ;
            Seek( cf, cfp ) ;
            Write( cf, Dumz ) ;
            Write( cf, Reps ) ;
            Inc( cfp, 2 ) ;
          end ;
        If NextVal <> i then
      		Begin
		        Seek( cf, cfp ) ;
		        Write( cf, i ) ;
		        Inc( cfp ) ;
          end ;
        Dec( fp ) ;
        TheVal := i ;
        Reps := 0 ;
	    end ;
  Until i = 99 ;
end ; {RepeatValueSweepCompress PROC}   {Until fs >= Size}


Procedure CreateImage ;
Var i:Word ;
		q, Amanda:Byte ;
Begin
	ReWrite( f ) ;
  Randomize ;
	For I:= 0 to 65535 do
		Begin
      GotoXY( 30, 1 ) ;
      Write( i, ' of 65535.' ) ;
    	q := Random( 249 ) + 1 ;
      Case q of
      	1..60:Amanda := 1 ;
        61..120:Amanda := 2 ;
        121..180:Amanda := 3 ;
        181..250:Amanda := 4 ;
      end ;
      Write( f, amanda ) ;
    end ;
end ;


Begin
	Init ;
  WinUp( 1, 1, 80, 25 ) ;
  ClrScr ;
  WriteStr( 1, 1, 'Creating random image....' ) ;
{  CreateImage ;
}  WriteStr( 1, 2, 'Compressing Image (Sweep 1)' ) ;
	RepeatValueSweepCompress ;
  GotoXY( 1, 4 ) ;
  writeln( 'Size of full image: ', FileSize( f ),'.' ) ;
  Writeln( 'Size of compressed: ', FileSize( cf ),'.' ) ;
  Pause ;
  CloseAllWins ;
end.