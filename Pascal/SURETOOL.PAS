Unit SureTool ;

Interface

Uses CRT, Joshmohn ;

Function AreYouSure( Warning:String ):Boolean ;

Implementation

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
	Choice:=False ;
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

end.