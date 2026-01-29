Program FindDaPrime ;

Uses CRT, DOS, Joshmohn ;

Const ListMax = 3720 ;
			StartingNumber = '2' ;
      HowLong = 50 ;
      BadList:Set of Char = [ '2', '4', '5', '6', '8', '0' ] ;

Type 	JoshNumber 	= String[ 10 ] ;
      NumType     = LongInt ;

Var n, Largest:JoshNumber ;
		List:Array[ 1..20 ] of JoshNumber ;
    ListPos:Byte ;
    PrimeList:Array[ 1..ListMax ] of JoshNumber ;
    Key:Char ;
    ShowGreen, WantsToggle, UseDatabase, TimeToQuit, d, s:Boolean ;
    Hour, Min, Sec, Bullz:Word ;
    PrimeFile:File of LongInt ;


Function Half( Something:NumType ):NumType ;

Begin
	Half := Something Div 2 ;
end ;

Procedure Beep ;

Begin
	NoSound ;
  Sound( 700 ) ;
  Delay( 30 ) ;
  NoSound ;
end ; {Beep PROC}


Procedure ScrollWinContents( wn:Byte ) ;

Var i, j:Byte ;

Begin
	For J:=Scrn[ wn ].Top+1 to Scrn[ wn ].Bottom-2 do
  	For I:=Scrn[ wn ].Left+1 to Scrn[ wn ].Right-1 do
    	WriteChar_A( i, j, GetChar( i, j+1 ), GetChar_A( i, j+1 ) ) ;
  For I:=Scrn[ wn ].Left+1 to Scrn[ wn ].Right-1 do
  	WriteChar_A( i, Scrn[ wn ].Bottom-1, ' ', BW ) ;
end ;


Function Value( Joos:String ):NumType ;

Var Dirt:NumType ;
		c:Integer ;

Begin
	Val( Joos, Dirt, c ) ;
  If c <> 0 then Beep ;
  Value := Dirt ;
end ; {Value FUNCTION}


Function Last:Integer ;

Var i:Integer ;

Begin
	I:=ListMax + 1 ;
	Repeat
		Dec( i ) ;
	Until ( I < 1 ) or ( PrimeList[ i ] <> '0' ) ;
	Last := i ;
end ;


Procedure InitList ;

Var i:Integer ;

Begin
	For I:=1 to ListMax do PrimeList[ i ] := '0' ;
	For I:=1 to 20 do List[ i ] := '0' ;
  PrimeList[ 1 ] := '2' ;
  PrimeList[ 2 ] := '3' ;
  PrimeList[ 3 ] := '5' ;
  For I:=1 to 3 do List[ i ] := PrimeList[ i ] ;
  Inc( ListPos, 3 ) ;
end ;


Function StrEquiv( N:NumType ):JoshNumber ;

Var Hooj:JoshNumber ;

Begin
	Str( n, Hooj ) ;
  StrEquiv := Hooj ;
end ; {NumToStr FUNCTION}


Procedure DisplayList ;

Var i:Byte ;

Begin
	If ListPos < 24 then
  	Begin
			WriteStr( 47, ListPos, n ) ;
    end
  else
    For i:=5 to 24 do
    	Begin
	     	WriteStr( 47, i, List[ i-4 ] ) ;
      end ;
  WriteStr( 28, 3, PrimeList[ Last ]+', #'+StrEquiv(Last)+'. Largest Prime Overall: '+Largest ) ;
end ; {DisplayList PROC}

Procedure AddToList ;

var x:Byte ;

Begin
	Inc( ListPos ) ;
  If ListPos > 24 then
  	Begin
      For x := 1 to 19 do List[ x ] := List[ x + 1 ] ;
    	ListPos := 24 ;
    end ;
  List[ ListPos-4 ] := n ;
  If Last < ListMax then PrimeList[ Last + 1 ] := n ;
  Largest := n ;
end ; {AddToList PROC}


Procedure IncNum( var Who:JoshNumber ); {Not the right way, but good for now}

Var Code:Integer ;
		d:NumType ;

Begin
	Val( Who, d, code ) ;
  If Code <> 0 then Beep ;
  Inc( d ) ;
  Str( d, Who ) ;
end ; {IncNum PROC}

Procedure CheckKeyboard ;

Begin
 	If Keypressed then
   	Begin
     	Key := Readkey ;
      If Key = #0 then
				Begin
					Key := Readkey ;
		      If Key = Esc then TimeToQuit := True ;
        end ;
      Case Upcase( Key ) of
      	'X': TimeToQuit := True ;
	      ' ': Repeat Until Keypressed ;
	      'D': D:=Not D ;
	    	'S': WantsToggle:=True ;
	    	'P': ShowGreen := Not ShowGreen ;
    	end ;{CASE}
    end ;
end ;

Procedure InitProgram ;

Begin
  InitWins ;
  Assign( PrimeFile, 'C:\PRIME\Primes.LST' ) ;
  {$I-}
  	Reset( PrimeFile ) ;
    Close( PrimeFile ) ;
  {$I+}
  UseDatabase := ( IOResult = 0 ) ;
  WinUp( 1, 1, 80, 25 ) ;
	ClrScr ;
  WriteStr( 1, 1, 'Use Prime Number Database?' ) ;
  Key := Readkey ;
  If Upcase( Key ) = 'Y' then UseDatabase := True
  else UseDatabase := False ;
  WriteStr( 1, 3, 'Long Delays?' ) ;
  Key := Readkey ;
  If Upcase( Key ) = 'Y' then D:=True
  else D:=False ;
  ClrScr ;
  ListPos := 4 ;
  S:=True ;
  ShowGreen := True ;
  WantsToggle:=False ;
  TimeToQuit := False ;
  n := StartingNumber ;
  InitList ;
  WriteStr( 33, 1, 'Prime Numbahs' ) ;
  WinUp( 45, 4, 78, 25 ) ;                      {LIST: 5-24}
  WriteStr( 1, 4, 'Current Number:' ) ;
  WriteStr( 1, 3, 'Largest Prime In Database:' ) ;
end ; {InitProgram PROC}

Function Remainder( Num, Divider:JoshNumber ):JoshNumber ;
																												{Not done properly}
Var Kirk, Spock:NumType ;                                     {.......yet!!!}

Begin
	Kirk:=Value( Num ) ;
  Spock:=Value( Divider ) ;
  Remainder := StrEquiv( Kirk Mod Spock ) ;
end ; {Remainder FUNCTION}

Function ItPassedTheFitnessTest:Boolean ;

Var Failed:Boolean ;
		Single:Char ;
    q:NumType ;
    Lama:Byte ;

Begin
	Failed := False ;
  Single := n[ Length( n ) ] ;
  If Single in BadList then Failed := True ;
  Q := 0 ;
	For Lama := 1 to Length( n ) do
	 	Inc( q, Value( n[ Lama ] ) ) ;
	If q mod 3 = 0 then Failed := True ;
  ItPassedTheFitnessTest := Not Failed ;
end ; {ItPassedTheFitnessTest FUNCT}

Procedure MakePass ;

Var i:JoshNumber ;
    q:Integer ;
    Amanda:JoshNumber ;
    StillPrime:Boolean ;

Begin
 	WriteStr( 17, 4, n ) ;
	If ItPassedTheFitnessTest then
  	Begin
      StillPrime := True ;
    	Q:=1 ;
      If UseDatabase then
      	Begin
		      If S then
		      	Begin
				      WinUp( 1, 6, 40, 13 ) ;
				      WriteStr( 6, 6, Chr(180)+' Checking Against Primes '+Chr(195) ) ;
				      HiLite( 8, 6, Red, 23 ) ;
		        end ; {Screen Info}
		      While ( Q <= ListMax ) and ( PrimeList[ q ] <> '0' ) and StillPrime
					and Not TimeToQuit and ( Value(PrimeList[q])<Half(Value(n))) do
		      	Begin
		          CheckKeyboard ;
		          Amanda := Remainder( n, PrimeList[ q ] ) ;
		          If S then
		          	Begin
				          ScrollWinContents( CurrentWin ) ;
				          WriteStr( 3, 12, n+' / '+PrimeList[q]+' has rem. of '+Amanda );
		            end ;
							If Amanda = '0' then
              	Begin
			          	StillPrime := False ;
                  If S and ShowGreen then
                  	Begin
                      HiLite( 2, 12, Green, 38 ) ;
                      ChillOut( HowLong*3 ) ;
                    end ;
                end ;
		          Inc( q ) ;
		          If D then ChillOut( HowLong ) ;
		        end ;
      	end ; {Using Prime Database}
      If StillPrime then
      	Begin
        	If S then
          	Begin
		    		  WinUp( 1, 15, 40, 25 ) ;
				      WriteStr( 4, 15, Chr(180)+' Checking Against All Numbers '+Chr(195) ) ;
		          HiLite( 6, 15, Red, 28 ) ;
            end ; {Screen INFO}
          If q > 1 then
						i := PrimeList[ q-1 ]
          else
          	I := '1' ;
          Repeat
            CheckKeyboard ;
          	IncNum( i ) ;
            If Value( i ) > 15 then
	            While i[ Length(i) ] in Badlist do IncNum( i ) ;
            Amanda := Remainder( n, i ) ;
            If S then
            	Begin
		            ScrollWinContents( CurrentWin ) ;
    		        WriteStr( 3, 24, n+' / '+i+' has rem. of '+Amanda ) ;
            	end ;
            If Amanda = '0' then
              Begin
	            	If S and ShowGreen then
									Begin
										HiLite( 2, 24, Green, 38 ) ;
                 	 	Chillout( HowLong*3 ) ;
                  end ;
  	          	StillPrime := False ;
              end ;
            If D then ChillOut( HowLong ) ;
          Until ( Value(i)>( Value(n) Div 2 ) ) or Not StillPrime or TimeToQuit;
        end ;
      If StillPrime then
				Begin
	  	    AddToList ;
  	  	  DisplayList ;
        end ;
      While CurrentWin > 2 do WinDown ;
    end ; {It Passed The Easy Part...}
end ;

Begin
	InitProgram ;
  GetTime( Hour, Min, Sec, Bullz ) ;
  Repeat
  	MakePass ;
  	CheckKeyboard ;
    If WantsToggle then
    	Begin
      	WantsToggle := False ;
        S := Not S ;
      end ;
    IncNum( n ) ;
  	If D then ChillOut( HowLong ) ;
  Until ( Value( n ) > 2147483640 ) or TimeToQuit ;
	CloseAllWins ;
	ClrScr ;
  Writeln( 'Started at ',Hour,':',min,':',sec,'.' ) ;
  GetTime( Hour, min, sec, bullz ) ;
  Writeln( 'Finished at ',Hour,':',min,':',sec,'.' ) ;
  Writeln ;
  Writeln( 'Largest Prime Found: ', Largest, '.' ) ;
  Writeln ;
end.