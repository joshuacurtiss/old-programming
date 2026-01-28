Program DeathToTheOppressor ;

Uses CRT, DOS, Joshmohn ;

Var f, cf:File of Byte ;
		wtf, wcf:File of Word ; {For Method #4}
    List:Array[ 1..4 ] of Byte ;
    TA:Array[ 1..40000 ] of Byte ;
    Name:String[ 80 ] ;

    Size:Array[ 1..4 ] of Word ;
    Choose, code:Integer ;

Function NumToStr( i:LongInt ):String ;
Var s:String[ 11 ] ;
Begin
	Str( i, s ) ;
  NumToStr := s ;
end ; {NumToStr}

Procedure BlankSlate( y:Byte ) ;

Var x:Byte ;

Begin
	For x := 20 to 70 do WriteChar_A( x, y, #176, Red ) ;
end ;


Procedure ObtainFilenames ;

Begin
	If ParamStr( 1 ) <> '' then Name := ParamStr( 1 )
  else
		Repeat
    	Writeln ;
    	Write( 'Enter name of file to compress: ' ) ;
      Readln( Name ) ;
      If Pos( '.', Name ) = 0 then Writeln( 'You must include a suffix.' ) ;
    Until Pos( '.', Name ) > 0 ;
  Assign( f, Name ) ;
  If ParamStr( 2 ) <> '' then Name := ParamStr( 2 )
  else
  	Begin
    	Writeln ;
    	Write( 'Enter compressed filename: ' ) ;
      Readln( Name ) ;
  	end ;
  If Pos( '.', Name ) = 0 then Name := Name + '.JPG' ;
  Assign( cf, Name ) ;
	Rewrite( cf ) ;
  {$I-}
  	Reset( f ) ;
    If IOResult <> 0 then
    	Begin
      	Writeln ;
        Writeln( 'Your desired file does not exist. Too bad.' ) ;
        Exit ;
      end ;
  {$I+}
end ;


Procedure ScanFile ;

Var Found:Boolean ;
		Count, Temp, i:Byte ;

Begin
  Reset( f ) ;
	Count := 0 ;
  For i := 1 to 4 do List[ i ] := 0 ;
  Repeat
		Read( f, Temp ) ;
    Found := False ;
    For i := 1 to Count do
    	If Temp = List[ i ] then Found := True ;
    If Not Found then
    	Begin
      	Inc( Count ) ;
        List[ Count ] := Temp ;
      end ;
  Until ( Count >= 4 ) or EOF( f ) ;
end ;


Procedure NextVal( Var Juice:Byte ) ;

Var q, i:Byte ;

Begin
	Read( f, q ) ;
  i := 0 ;
  Repeat
  	Inc( i ) ;
  Until ( q = List[ i ] ) or ( i > 4 ) ;
  Juice := i ;
end ;


Procedure DisplayStatus( y:Byte ; a, b, i, j:Real ) ;
Begin
	WriteStr( 14, y, NumToStr( Trunc( a/b ) ) + '%' ) ;
  WriteChar_A( 20+Trunc( a/b ) div 2, y, #178, Red ) ;
  WriteChar_A( 20+Trunc( i/j ) div 2, y, #219, Red ) ;
end ;


Procedure FactorCompression( Factor:Byte ) ;  {Stores into TA}
                                              {Factor is either a 3 or 4}
Var Chunk:Array[ 1..4 ] of Byte ;
		FSize, i:Integer ;
    Enigma, DSize, Amanda:Byte ;

Begin
  Reset( f ) ;
	Case Factor of
  	3:Begin
    		DSize := 133 ;
        FSize := 13333 ;
    	end ;
    4:Begin
    		DSize := 100 ;
        FSize := 10000 ;
    	end ;
  end ;
	For i := 1 to FSize do
  	Begin
    	DisplayStatus( WhereY, i, DSize, i, 400 ) ;
      Chunk[ 1 ] := 1 ;
      For Amanda := (5-Factor) to 4 do NextVal( Chunk[ Amanda ] ) ;
      Enigma := ( Chunk[ 1 ]-1 ) * 64 +
      					( Chunk[ 2 ]-1 ) * 16 +   {If Factor=3, will still work.}
                ( Chunk[ 3 ]-1 ) * 4  +
                ( Chunk[ 4 ]-1 ) * 1 ;       {0..63} {0..255}
      TA[ i ] := Enigma ;
    end ;
  If Factor = 3 then
  	Begin
    	NextVal( Enigma ) ;
      TA[ FSize+1 ] := Enigma ;
    end ;
end ; {FactorCompression PROC}


Procedure SeedCompression( FreqLimit, NumLimit, Ceiling:Byte ; FS:Word ) ;

Var Mem, MemFreq, Current:Byte ;
		Size, i:LongInt ;

Procedure SpitOutSeeds ;

Var Amanda:Byte ;

Begin
	If MemFreq < FreqLimit then
  	Begin
    	Amanda := Mem + ( ( MemFreq-1 ) * NumLimit ) ;
      Write( cf, Amanda ) ;
      Inc( Size ) ;
    end
  else
  	Begin
    	Amanda := Mem + Ceiling ;
      Write( cf, Amanda ) ;
      Write( cf, memFreq ) ;
      Inc( Size, 2 ) ;
    end ;
end ;

Begin
	Reset( cf ) ;
  Seek( cf, FileSize( cf ) ) ;
  Mem := TA[ 1 ] ;
  MemFreq := 1 ;
  Size := 0 ;
  For i := 2 to FS do
  	Begin
    	DisplayStatus( WhereY, i, FS div 100, Size, FS div 100 ) ;
    	Current := TA[ i ] ;
      If ( Current = Mem ) and ( MemFreq < 255 ) then Inc( MemFreq )
      else
      	Begin
        	SpitOutSeeds ;
          Mem := Current ;
          MemFreq := 1 ;
        end ;
    end ;
  SpitOutSeeds ;
end ;



Procedure WordConversion ;

Var i:Integer ;
		One, Two, Final:Word ;

Begin
  Assign( WTF, 'Temp.JMC' ) ;
	Rewrite( wtf ) ;
  For i := 1 to 13334 do
  	Begin
    	If i mod 2 = 1 then
      	One := TA[ i ]
      else
      	Two := TA[ i ] ;
      If i mod 2 = 0 then
      	Begin
        	Final := One * 100 + Two ;
          Write( wtf, Final ) ;
        end ;
      DisplayStatus( WhereY, i, 133, i, 133 ) ;
    end ;
end ; {WordConversion PROC}


Procedure WordsForSeeds ;

Var Mem, MemFreq, Current:Word ;
		i, s:Integer ;

Procedure SpitOutSeeds ;

Var Amanda:Word ;

Begin
	If MemFreq < 10 then
  	Begin
    	Amanda := Mem + ( (MemFreq-1) * 6364 ) ;
      Write( wcf, Amanda ) ;
      Inc( s ) ;
    end
  else
  	Begin
    	Amanda := mem + 57276 ;
    	Write( wcf, Amanda ) ;
      Write( wcf, memFreq ) ;
      Inc( s, 2 ) ;
    end ;
end ; {SpitOutSeeds}


Begin
	Reset( wtf ) ;
  Reset( wcf ) ;
  Seek( wcf, FileSize( wcf ) ) ;
  Read( wtf, Mem ) ;
  MemFreq := 1 ;
  s := 0 ;
  For i := 2 to 6667 do
  	begin
    	DisplayStatus( WhereY, i, 66.5, s, 66.5 ) ;
      Read( wtf, Current ) ;
      If ( Current = Mem ) then Inc( MemFreq )
      else
     		Begin
					SpitOutSeeds ;
          Mem := Current ;
          MemFreq := 1 ;
       	end ;
    end ;
  SpitOutSeeds ;
end ;


Procedure Compress( Method:Byte ) ;

Var I, q:Word ;

Begin
	Case Method of
  	1:Begin
    		Rewrite( cf ) ;
        Write( cf, Method ) ;
        For i := 1 to 4 do
        	Write( cf, List[ i ] ) ;
        WriteStr( 1, WhereY, 'Compressing:' ) ;
        BlankSlate( wherey ) ;
				FactorCompression( 4 ) ;
        For i := 1 to 10000 do
        	Write( cf, TA[ i ] ) ;
    	end ;
    2:Begin
    		Rewrite( cf ) ;
        Write( cf, Method ) ;
        For i := 1 to 4 do
        	Write( cf, List[ i ] ) ;
        BlankSlate( wherey ) ;
    		FactorCompression( 3 ) ;
        Writeln ; Writeln ;
        BlankSlate( WhereY ) ;
        SeedCompression( 4, 64, 192, 13333 ) ;
    	end ;
    3:Begin
    		Reset( f ) ;
        Rewrite( cf ) ;
        Write( cf, Method ) ;
        For i := 1 to 4 do
        	Write( cf, List[ i ] ) ;
        For i := 1 to 40000 do
					NextVal( TA[ i ] ) ;
        WriteStr( 1, WhereY, 'Compressing:' ) ;
        BlankSlate( WhereY ) ;
        SeedCompression( 64, 4, 252, 40000 ) ;
    	end ;
    4:Begin
    		Assign( wcf, name ) ;
        Rewrite( wcf ) ;
        i := Method ;
        Write( wcf, i ) ;
        For i:=1 to 4 do
        	Begin
          	q := List[ i ] ;
						Write( wcf, q ) ;
          end ;
        BlankSlate( WhereY ) ;
    		FactorCompression( 3 ) ;
        Writeln ; Writeln ;
        BlankSlate( WhereY ) ;
        WordConversion ;
        Writeln ; Writeln ;
        BlankSlate( WhereY ) ;
        WordsForSeeds ;
    	end ;
  end ;
end ;


Function Smallest:Byte ;

Var s:Word ;
		i, w:Byte ;

Begin
  s:=40000 ;
  i := 5 ;
  Repeat
  	Dec( i ) ;
    If Size[ i ] < s then
			Begin
      	s := Size[ i ] ;
				w := i ;
      end ;
  Until i<=1 ;
  Smallest := w ;
end ;















Begin
	ObtainFilenames ;
	ScanFile ;
{  If ParamStr(3) <> '' then Val( ParamStr( 3 ), Choose, Code ) }
  Size[ 1 ] := 10005 ;
  For Choose := 2 to 4 do
  	Begin
    	Writeln ;
      Writeln( 'Trying method #', Choose, '...' ) ;
      Writeln ;
      Compress( Choose ) ;
      If Choose = 4 then Size[ Choose ] := FileSize( WCF ) * 2
      else Size[ Choose ] := FileSize( CF ) ;
    end ;
  Choose := Smallest ;
  If Choose < 4 then
  	Begin
    	Writeln ;
      Writeln( 'Method #', Choose, ' is best. Let''s do it again.' ) ;
      Writeln ;
      Compress( Choose ) ;
    end ;
  Writeln ;
  Writeln ;
  If Choose = 4 then Writeln( 'Compressed size: ', FileSize( wcf ) * 2 )
  else Writeln( 'Compressed size: ', FileSize( cf ) ) ;
end.