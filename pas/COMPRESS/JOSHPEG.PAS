Program CompessDaStuphOnYourOwnAndNotWithTheHelpOfKostMan ;

Uses CRT, DOS, Joshmohn ;

Var f:File of Byte ;
		tf, cf:File of Word ;
    i, x:Byte ;
    Name:String ;
    ta:Array[ 1..13334 ] of Byte ;


function NumToStr(i: Longint):string;
var s: string[11];
begin
  Str(i, s);
  NumToStr := s;
end;


Procedure CompressionLevelOne ;

Var i, Amanda:Integer ;
		JuicyNum:Byte ;
    Chunk:Array[ 1..4 ] of Byte ;

Begin
	Reset( f ) ;
  For i := 1 to 13333 do
  	begin
    	WriteStr( 12, 6, NumToStr( Trunc( i/133 ) )+'%' ) ;
      WriteChar_A( 20+Trunc( i/133 ) div 2, 6, #178, Red ) ;
      WriteChar_A( 20+Trunc( i/400 ) div 2, 6, #219, Red ) ;
    	For Amanda := 1 to 3 do Read( f, Chunk[ Amanda ] ) ;
      JuicyNum := ( Chunk[ 1 ] - 1 ) * 16 + ( Chunk[ 2 ] - 1 ) * 4
					         + Chunk[ 3 ] - 1 ;   {The Minus One to make it 0..63}
      TA[ i ] := JuicyNum ;
    end ;
  Read( f, JuicyNum ) ;
  TA[ 13334 ] := JuicyNum ;
end ; {CompressionLevelOne}


Procedure CompressionLevelTwo ;

Var i:Integer ;
    JuiceOne, JuiceTwo, Final:Word ;

Begin
	ReWrite( tf ) ;
	For i := 1 to 13334 do
  	Begin
			If I mod 2 = 1 then
      	JuiceOne := TA[ i ]
      else
      	JuiceTwo := TA[ i ] ;
      If I mod 2 = 0 then
      	Begin
        	Final := JuiceOne * 100  +  JuiceTwo ;
          Write( tf, Final ) ;
        end ;
    	WriteStr( 12, 8, NumToStr( Trunc( i/133 ) )+'%' ) ;
      WriteChar_A( 20+Trunc( i/133 ) div 2, 8, #178, Red ) ;
      WriteChar_A( 20+Trunc( i/266 ) div 2, 8, #219, Red ) ;
    end ;
end ; {CompressionLevelTwo}  {Actually, 0% Savings}


Procedure CompressionLevelThree ;

Var Mem, MemFreq, Current:Word ;
		i, s:Integer ;

Procedure SpitOutSeeds ;

Var Amanda:Word ;

Begin
	If MemFreq < 10 then
  	Begin
    	Amanda := Mem + ( (MemFreq-1) * 6364 ) ;
      Write( cf, Amanda ) ;
      Inc( s ) ;
    end
  else
  	Begin
    	Amanda := mem + 57276 ;
    	Write( cf, Amanda ) ;
      Write( cf, memFreq ) ;
      Inc( s, 2 ) ;
    end ;
end ; {SpitOutSeeds}


Begin
	Reset( tf ) ;
  Rewrite( cf ) ;
  Read( tf, Mem ) ;
  MemFreq := 1 ;
  s := 0 ;
  For i := 2 to 6667 do
  	begin
    	WriteStr( 14, 10, NumToStr( Trunc( i/66.5 ) )+'%' ) ;
      WriteChar_A( 20+Trunc( i/66.5 ) div 2, 10, #178, Red ) ;
      WriteChar_A( 20+Trunc( s/66.5 ) div 2, 10, #219, Red ) ;
      Read( tf, Current ) ;
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





Begin
	ClrScr ;
  If ParamStr( 1 ) <> '' then
 		Name := ParamStr( 1 )
  else
  	Begin
		  Writeln( 'Include suffixes in your filenames..' ) ;
		  Writeln ;
		  Write( 'Enter the name of file: ' ) ;
		  Readln( Name ) ;
   	end ;
  Assign( f, name ) ;
  If ParamStr( 2 ) <> '' then
 		Name := ParamStr( 2 )
  else
  	Begin
		  Write( 'Compressed Filename: ' ) ;
		  Readln( Name ) ;
    end ;
  Assign( cf, name ) ;
  Assign( tf, 'Temp.JMC' ) ;
  Rewrite( tf ) ;
  Rewrite( cf ) ;
  {$I-}
  	Reset( f ) ;
    If IOResult <> 0 then
    	Begin
      	Writeln( 'Your desired file does not exist. Too bad.' ) ;
        Exit ;
      end ;
  {$I+}
  WriteStr( 1, 6, 'Wave One:' ) ;
  For x := 20 to 70 do WriteChar_A( x, 6, #176, Red ) ;
  i := 8 ;
	CompressionLevelOne ;
  WriteStr( 1, i, 'Wave Two:' ) ;
  For x := 20 to 70 do WriteChar_A( x, 8, #176, Red ) ;
  CompressionLevelTwo ;
  Inc( i, 2 ) ;
  WriteStr( 1, i, 'Wave Three:' ) ;
  For x := 20 to 70 do WriteChar_A( x, 10, #176, Red ) ;
  CompressionLevelThree ;
  Inc( i, 2 ) ;
  WriteStr( 1, i, 'Compression complete.' )  ;
	WriteStr( 1, i+2, 'Original Filesize: '+NumToStr( FileSize( f ) )+'.' ) ;
  WriteStr( 1, i+3, 'Compressed Size: '+NumToStr( FileSize( cf ) ) + '.' ) ;
  GotoXY( 1, i + 5 ) ;
  Repeat Until Keypressed ;
	Close( f ) ;
  Close( cf ) ;
end.