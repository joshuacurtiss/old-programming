Program TestSpeed;

Uses DOS, Crt, Zakmohn ;

Const a = 20 ;
      Letters = 1612 ;

Var Hour, Min1, Min2, Sec1, Sec2, hun1, hun2:Word ;
		MyTime, Systime:real ;
		I, J:Integer ;
    q:char ;
		YorN, NoMore:Boolean ;

Procedure Beep( Tone, Len:Integer ) ;

Begin
	Sound( Tone ) ;
  Delay( Len ) ;
  NoSound ;
end ;

Procedure FYI( Warning:String ) ;

Const Wid = 47 ;
			WinL= 20 ;

Begin
	WinUp( WinL, 9, 70, 12 ) ;
	If Length( Warning ) > Wid then
		Begin
			I:=Wid+1 ;
			Repeat
				Dec( i ) ;
			Until ( Warning[ i ] = ' ' ) or ( i = 0 ) ;
			If i=0 then
				begin
					For J:= 1 to Wid do WriteChar( WinL+1+j, 10, Warning[j] ) ;
					For J:= Wid+1 to Length(Warning) do WriteChar( WinL+1+j-Wid, 11, Warning[j] ) ;
				end
			else
				begin
					For J:= i downto 1 do WriteChar( WinL+1+j, 10, Warning[ j ] ) ;
					For J:= i+1 to Length(Warning) do WriteChar(WinL+1+j-i,11,Warning[j] ) ;
				end ;
		end {If more than one line}
	else
		For I:= 1 to Length( Warning ) do WriteChar( WinL+1+I, 10, Warning[ i ] ) ;
end ; {FYI PROCEDURE}


Function AreYouSure( Warning:String ):Boolean ;

Var Choice:Boolean ;						{Like FYI except with Yes/No choice}
		Key:Char ;
		I, J:Integer ;

Begin
	WinUp( 17, 8, 52, 17 ) ;
	TextColor( Red ) ;
	WriteStr( 22, 10, 'Are You Sure?' ) ;
	TextColor( Yellow ) ;
	If Length( Warning ) > 31 then
		Begin
			I:=32 ;
			Repeat
				Dec( i ) ;
			Until ( Warning[ i ] = ' ' ) or ( i = 0 ) ;
			If i=0 then
				begin
					For J:= 1 to 31 do WriteChar( j+18, 12, Warning[j] ) ;
					For J:= 32 to Length(Warning) do WriteChar( j-13, 13, Warning[j] ) ;
				end
			else
				begin
					For J:= i downto 1 do WriteChar( j+18, 12, Warning[ j ] ) ;
					For J:= i+1 to Length(Warning) do WriteChar(j-i+18,13,Warning[j] ) ;
				end ;
		end {If more than one line}
	else
		For I:= 1 to Length( Warning ) do WriteChar( i+18, 12, Warning[ i ] ) ;
	TextColor( White ) ;
	WriteStr( 27, 15, 'Yeahmohn     No! No!' ) ;
	Choice:=True ;
	Key:=' ' ;
	Repeat
		If Choice = False then Hilite( 39, 15, Blue, 9 )
		else HiLite( 26, 15, Blue, 10 ) ;
		If KeyPressed then
			begin
				HiLite( 26, 15, Black, 23 ) ;
				Key:=Readkey ;
				Case key of
					Chr( Tab ):Choice:=Not Choice ;
					#0:
						begin
							Key:=Readkey ;
							Case Key of
								LeftArrow, RightArrow:Choice:=Not Choice ;
								#27:
									Begin
										Choice:=False ;
										Key:=#13
									end ;
							end ;{#0 Case}
						end ; {If #0}
				end ; {Main Case}
			end ;
	Until Key = #13 ;
	TextColor( White ) ;
	WinDown ;
	AreYouSure:=Choice ;
end ; {Are You Sure? Funct}

Function RealToStr( I:Real ):String ;

Var S:String[ 11 ] ;

Begin
	Str( i, s ) ;
  RealToStr := s ;
end ;

Function IntToStr(i: Longint):String;

var s: string[ 11 ];

begin
  Str(i, s);
  IntToStr := s;
end ;


Procedure TestMine ;

Var ta:Word ;
		T:Array[ 1..a ] of Word ;
		Try:Byte ;
    Good:Boolean ;

Begin
  FYI( 'Now Testing my own ''WriteChar''...' ) ;
  ChillOut( 250 ) ;
  WinDown ;
  For Try:=1 to a do
  	Begin
      FYI( 'My own ''WriteChar'' Try #' + IntToStr( Try ) ) ;
			Repeat
	      T[ Try ]:=0 ;
	    	GetTime( Hour, Min1, Sec1, Hun1 ) ;
				For I:=1 to Letters do
        	Begin
		  	  	WriteChar( 40, 20, Char( try+64+ (i Div 500) ) ) ;
          end ;
	      GetTime( Hour, Min2, Sec2, Hun2 ) ;
	      If (Min2=Min1) and (Sec2=Sec1) then
	        Begin
	      		Inc( T[ Try ], Hun2-Hun1 ) ;
	          Good:=True ;
	        end
	      else
	        Good := False ;
	    Until Good ;
    	WinDown ;
  	end ;
	MyTime:=0 ;
  For I:=1 to a do MyTime:= MyTime+ T[ i ]  ;
  MyTime:=MyTime/a ;
end ;

Procedure TestSys ;

Var ta:Word ;
		T:Array[ 1..a ] of Word ;
		Try:Byte ;
    Good:Boolean ;

Begin
	FYI( 'Now Testing System Standard ''Write''.' ) ;
  ChillOut( 250 ) ;
	WinDown;
  For Try:=1 to a do
  	Begin
    	FYI( 'Standard System ''Write'' Try #' + IntToStr( Try ) ) ;
	  	Repeat
	      T[ Try ]:=0 ;
	    	GetTime( Hour, Min1, Sec1, Hun1 ) ;
				For I:=1 to Letters do
        	Begin
          	GotoXY( 40, 20 ) ;
		  	  	Write( Char( try+64+ (i Div 500) ) ) ;
          end ;
	      GetTime( Hour, Min2, Sec2, Hun2 ) ;
	      If (Min2=Min1) and (Sec2=Sec1) then
	        Begin
	      		Inc( T[ Try ], Hun2-Hun1 ) ;
	          Good:=True ;
	        end
	      else
	        Good := False ;
	    Until Good ;
		  WinDown ;
  	end ;
	SysTime:=0 ;
  For I:=1 to a do SysTime:= SysTime+ T[ i ]  ;
  SysTime:=SysTime/a ;
end ;

Begin
	InitWins ;
  WinUp( 1, 1, 80, 25 ) ;
	ClrScr ;
  NoMore:=False ;
  For I:=1 to 3 do
		Begin
			Beep( 5000, 50 ) ;
      Delay( 50 ) ;
    end ;
  Yorn:=AreYouSure( 'Do you want to proceed with the test?' ) ;
	While ( YorN = True ) and ( Not NoMore ) do
    Begin
			NoMore:=False ;
      ClrScr ;
		  TestSys ;
		  TestMine ;
	    MyTime:=MyTime/Letters ;
	    Systime:=Systime/Letters ;
		  ClrScr ;
	    WriteStr( 2, 2, 'Speed of WriteChar vs. System''s Write:' ) ;
		  WriteStr( 10, 5, 'My Time:                   Millionths of a second per Char.' ) ;
		  WriteStr( 10, 7, 'System Time:               Millionths of a second per Char.' ) ;
		  GotoXY( 24, 5 ) ;
			Write( (MyTime*10000):4:7 ) ;
      WriteStr( 23, 16, '*** Press any Key to Continue ***' ) ;
		  GotoXY( 23, 7 ) ;
			Write( (Systime*10000):4:7 ) ;
	    WriteStr( 13, 10, 'Ratio (Time) Mine:System = ' ) ;
	    GotoXY( 40, 10 ) ;
			Write( '1:', Systime/MyTime:4:2 ) ;
      Q:=Readkey ;
      Beep( 3000, 70 ) ;
    	NoMore := NOT AreYouSure( 'Perform Test Again?' ) ;
	  End {WHILE} ;
  CloseAllWins ;
	GotoXY( 1, 25 ) ;
end .