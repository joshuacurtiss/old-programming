Program Word_Processor_Better_Than_Markus ;

Uses ZakMohn, CRT, DOS ;

Const NumOfLines	= 50 ;
			Width       = 40 ;
      Start       = 10 ;
      Top					=  7 ;
      Bottom			= 24 ;

Type	Doc = Record
				Name:String ;
        Path:String ;
        Guts:Array[ 1..NumOfLines ] of String[ Width+1 ] ;
			end ; {Type DOC}

Var CurrentDoc:DOC ;

Procedure DocInfo ;

Var I:Integer ;
    Key:Char ;

Begin
	WinUp( 10, 10, 70, 17 ) ;
  WriteStr( 30, 11, 'Document Information' ) ;
  WriteStr( 12, 13, 'Doc Name:' ) ;
  WriteStr( 12, 14, 'DOS Path:' ) ;
  WriteStr( 45, 16, 'Okay      Cancel' ) ;
  I:=1 ;
  Repeat
  	Case I of
    	1:Begin
					HiLite( 54, 16, Black, 8 ) ;
					CurrentDoc.Name:=Readln( 22, 13, 45, Blue, Green, True ) ;
      	end ;
      2:Begin
					HiLite( 22, 13, Black, 45 ) ;
					CurrentDoc.Path:=Readln( 22, 14, 40, Blue, Green, True ) ;
      	end ;
      3:Begin
					HiLite( 44, 16, Blue, 6 ) ;
          HiLite( 22, 14, Black, 40 ) ;
      	end ;
      4:Begin
      		HiLite( 44, 16, Black, 6 ) ;
          HiLite( 54, 16, Blue, 8 ) ;
      	end ;
    end ; {CASE}
    If ( I = 1 ) or ( I = 2 ) then Inc( i )
    else
    	Begin
		    Key:=Readkey ;
		    If Key=#0 then Key:=Readkey ;
		    If Key = Chr( Tab ) then
					Begin
						Inc( i ) ;
            If (I=4) or (I=5) then
            	Begin
              	Sound( 5000 ) ;
                Delay( 1 ) ;
                NoSound ;
              end ;
          end ;
      end ;
    If I>4 then I:=1 ;
  Until ( Key = CR ) and ( (I=3) or (I=4) ) ;
	If I=4 then
   	CurrentDoc.Path := '!CANCEL'
  else
   	With CurrentDoc do
     	Begin
      	I:=Length( Path ) + 1 ;
        Repeat
        	Dec( I ) ;
        Until ( Path[i] <> ' ' ) or ( I < 1 ) ;
        If I<1 then Path:='!IMPROPER'
        else Path:=Copy( Path, 1, i ) ;
				I:=Length( Name ) + 1 ;
        Repeat
        	Dec( I ) ;
        Until ( Name[i] <> ' ' ) or ( I < 1 ) ;
        If I<1 then Name:='(Untitled)'
        else Name:=Copy( Name, 1, i ) ;
      end ;
  Windown ;
end ; {Proc DOCINFO}

Procedure InitDocGuts ;

Var I:Integer ;

Begin
	For I:=1 to NumOfLines do CurrentDoc.Guts[i]:=CR ;
end ; {Proc InitDocGuts}

Procedure TesterProc ;
Begin
	With CurrentDoc do
  	Begin
    	Guts[ 1]:='This is line one (1).' + CR ;
    	Guts[ 2]:='    Hello. How be you? I be fine.' + CR ;
      Guts[ 4]:='This is line four (4).' + CR ;
      Guts[ 8]:='I be doing good over on Line 8.' + CR ;
      Guts[15]:='Numbah 15!' + CR ;
      Guts[22]:=' Whatcha gonna do... HEY!' + CR ;
      Guts[30]:='     It is line 30.' + CR ;
      Guts[35]:='I am going to begin typing as if this' ;
      Guts[36]:='was a normal word processor. I wish.' + CR ;
      Guts[40]:='Over the HILL.' + CR ;
      Guts[50]:='The Last line (#50).' + CR ;
    end ;
end ; {TesterProc PROC}

Procedure InsertLine( FromWhere:Integer ) ;

Var I:Integer ;

Begin
	If FromWhere < NumOfLines then
	  For I:=Numoflines downto FromWhere+1 do
  		CurrentDoc.Guts[ i ] := CurrentDoc.Guts[ i - 1 ] ;
  CurrentDoc.Guts[ FromWhere ] := CR ;
end ; {INSERTLINE Proc}

Procedure InsertChar( WhereX:Byte ; Line:Integer ; What:Char ) ;

Var i, j:Byte ;

Begin
 	Insert( What, CurrentDoc.Guts[ Line ], WhereX );
  If Length( CurrentDoc.Guts[ Line ] ) > Width then
  	Begin
			J:=Line ;
      Repeat
      	Inc( J ) ;
      Until(Pos(CR,CurrentDoc.Guts[j])>0) or (J=NumOfLines) or (Length(CurrentDoc.Guts[j])<Width);
      For I:=Line+1 to J do
				Begin
					Insert( CurrentDoc.Guts[i-1][Width+1], CurrentDoc.Guts[i], 1 ) ;
        	Delete( CurrentDoc.Guts[i-1], Width+1, 1 ) ;
        end ;
    end ;
end ; {INSERTCHAR Proc}







Procedure WordProcessor ;

Var I, J, K, CursLine, TopLine:Integer ;
		Key, CursMaskChar:Char ;
    Temp:String ;
    x, CursMaskAttrib:Byte ;

Begin
	WinUp( Start, Top-1, Start+Width+1, Bottom+1 ) ;
  WinUp( Start+Width+1, Top-1, 79, Bottom+1 ) ;
	TopLine:=1 ;
  CursLine:=TopLine ;
  x:=1 ;
  Repeat
		For I:=Top to Bottom do
    	If CurrentDoc.Guts[I-Top+TOPLINE]=CR then
				For J:=Start+1 to Start+Width do WriteChar( j, i, ' ' )
      else
				Begin
					J:=0 ;
					Repeat
						Inc( J ) ;
						If CurrentDoc.Guts[I-Top+TOPLINE][j] <> CR then
							WriteChar( Start+j, I, CurrentDoc.Guts[I-Top+TOPLINE][j] )
    			Until ( CurrentDoc.Guts[I-Top+TOPLINE][j]=CR ) or ( j = Width ) ;
          If J < Width then
          	For K := (Start+J) to (Start+Width) do
            	WriteChar( k, i, ' ' ) ;
        end ;
		{}		    WriteChar( Start+Width+2, CursLine+Top-1, Esc ) ;
		{}		    For I:=Bottom Downto Top do
		{}		    	Begin
		{}		       	GotoXY( Start+Width+4, i ) ;
		{}	  	      Write( 'Length: ' ) ;
		{DEBUG}				If Length( CurrentDoc.Guts[i-Top+Topline] ) < 10 then Write( ' ' ) ;
		{}						Write( Length( CurrentDoc.Guts[ i-Top+TopLine ] ),'.' ) ;
		{}		        Write( ' Line ' ) ;
		{}		        If i-Top+TopLine<10 then Write( ' ' ) ;
		{}		        Write( I-Top+TopLine, '.' ) ;
    {}						Case I of
    {}             	Top+2:
		{}								Begin
    {}               		GotoXY( 75, i ) ;
    {}                  Write( 'X=' ) ;
    {}                  If X<10 then Write(' ') ;
    {}                  Write( x ) ;
    {}  	           	end ;
    {}            end ;
		{}		     	end ;
    CursMaskChar:=GetChar( Start+x, Top+CursLine ) ;
    CursMaskAttrib:=GetCharAttrib( Start+x, Top+CursLine ) ;
    HiLite( Start+x, Top+CursLine-1, Blue, 1 ) ;
    Key:=Readkey ;
   	WriteChar( Start+Width+2, Top+CursLine-1, ' ' ) ;
    WriteChar_A( Start+x, Top+CursLine-1, CursMaskChar, CursMaskAttrib ) ;
    If Key=#0 then
    	Begin
      	Key:=Readkey ;
        Case Key of
          #71 {Home}:
          	Begin
              x:=0 ;
              Repeat
              	Inc( x ) ;
              Until (x>Width-1) or (CurrentDoc.Guts[TopLine-1+CursLine][x]<>' ');
              If x>Width-1 then x:=1 ;
            end ; {Of Home}
          #79 {End}:X:=Length( CurrentDoc.Guts[TopLine-1+CursLine] ) ;
        	UpArrow:Dec( CursLine ) ;
          DownArrow:Inc( CursLine ) ;
          PgUp:Dec( TopLine, Bottom-Top ) ;
          PgDn:Inc( TopLine, Bottom-Top ) ;
          LeftArrow:
						Begin
            	Dec( x ) ;
					    If x < 1 then
					      If ( TopLine=1 ) and ( CursLine=TopLine ) then x:=1
					      else
					    		Begin
						        Dec( CursLine ) ;
					          X:=Length( CurrentDoc.Guts[ CursLine+TopLine-1 ] ) ;
						      end ;
          	End ;
          RightArrow:
						Begin
							Inc( x ) ;
              If x > Length( CurrentDoc.Guts[ CursLine+TopLine-1 ] ) then
              	Begin
                	Inc( CursLine ) ;
                  x:=1 ;
                end ;
            end ;
        end ;
      end
    else
			Case ORD( Key ) of
        13:
					Begin
						X:=1 ;
						InsertLine( CursLine+TopLine-1 ) ;
            Inc( CursLine ) ;
          end
        else
        	Begin
	        	InsertChar( x, CursLine+TopLine-1, Key ) ;
            Inc( x ) ;
          end ;
      end ; {CASE}
    If x>Length( CurrentDoc.Guts[ CursLine+TopLine-1 ] ) then
    	x:=Length( CurrentDoc.Guts[ CursLine+TopLine-1 ] ) ;
    If CursLine > Bottom-Top+1 then
			Begin
				Inc( TopLine ) ;
        CursLine:=Bottom-Top+1 ;
      end
    else
    	If CursLine < 1 then
      	Begin
        	Dec( topline ) ;
          CursLine:=1 ;
        end ;
    If TopLine > NumOfLines - Bottom+Top then
			Begin
				TopLine:=NumOfLines-Bottom+Top ;
        If CursLine = Bottom-Top+1 then
					X:=Length( CurrentDoc.Guts[ CursLine+TopLine-1 ] ) ;
      end
    else
			If TopLine < 1 then
				Begin
					TopLine:= 1 ;
          If CursLine = 1 then x:=1 ;
        end ;
	Until Key = ESC ;
end ; {PROC WordProcessor}

Begin
  InitWins ;
  Repeat
{		DocInfo ;}
  Until CurrentDoc.Path <> '!IMPROPER' ;
  If CurrentDoc.Path <> '!CANCEL' then
		Begin
			InitDocGuts ;
			TesterProc ;
			WordProcessor ;
    end ;
	CloseAllWins ;
end. {An Attempt....}
