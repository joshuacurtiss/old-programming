Program CompessDaStuphOnYourOwnAndNotWithTheHelpOfKostMan ;

Uses CRT, DOS, Joshmohn ;

Var f, cf, tf:File of Byte ;
    i, x:Byte ;
    Name:String ;

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
  Reset( tf ) ;
  For i := 1 to 13333 do
  	begin
    	WriteStr( 12, 6, NumToStr( Trunc( i/133 ) )+'%' ) ;
      WriteChar_A( 20+Trunc( i/133 ) div 2, 6, #178, Red ) ;
      WriteChar_A( 20+Trunc( i/400 ) div 2, 6, #219, Red ) ;
    	For Amanda := 1 to 3 do Read( f, Chunk[ Amanda ] ) ;
      JuicyNum := ( Chunk[ 1 ] - 1 ) * 16 + ( Chunk[ 2 ] - 1 ) * 4
					         + Chunk[ 3 ] - 1 ;   {The Minus One to make it 0..63}
      Write( tf, JuicyNum ) ;
    end ;
end ; {Compress}

Procedure CompressionLevelTwo ;

Var Mem, MemFreq, Current:Byte ;
		Size, i:Integer ;


Procedure SpitOutSeeds ;

Var Amanda:Byte ;

Begin
	If MemFreq < 4 then
  	Begin
    	Amanda := Mem + ( (MemFreq-1) * 64 ) ;
      Write( cf, Amanda ) ;
      Inc( Size ) ;
    end
  else
  	Begin
    	Amanda := mem + 192 ;
    	Write( cf, Amanda ) ;
      Write( cf, memFreq ) ;
      Inc( Size, 2 ) ;
    end ;
end ; {SpitOutSeeds}


Begin
	Reset( tf ) ;
  Rewrite( cf ) ;
  Read( tf, Mem ) ;
  MemFreq := 1 ;
  Size := 0 ;
  For i := 2 to 13333 do
  	begin
    	WriteStr( 12, 8, NumToStr( Trunc( i/133 ) )+'%' ) ;
      WriteChar_A( 20+Trunc( i/133 ) div 2, 8, #178, Red ) ;
      WriteChar_A( 20+Trunc( Size/133 ) div 2, 8, #219, Red ) ;
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
  WriteStr( 1, i, 'Compression complete.' )  ;
	WriteStr( 1, i+2, 'Original Filesize: '+NumToStr( FileSize( f ) )+'.' ) ;
  WriteStr( 1, i+3, 'Compressed Size: '+NumToStr( FileSize( cf ) ) + '.' ) ;
  GotoXY( 1, i + 5 ) ;
	Close( f ) ;
  Close( cf ) ;
end.