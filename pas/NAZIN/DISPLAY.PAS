Program JoshesTest ;

Uses crt, Joshmohn ;

var k:integer ;

Begin
	WinUp( 1, 7, 79, 25 ) ;
	WriteStr( 34, 9, 'Edit Users' ) ;
	WriteStr( 2, 11, 'Num' ) ;
	WriteStr( 6, 11, 'Logon' ) ;
	WriteStr( 16, 11, 'Name' ) ;
	WriteStr( 72, 11, 'Access' ) ;
	WriteStr( 7, 22, 'Total Users:' ) ;
	GotoXY( 7, 23) ; Write( 'Max Allowed: ', 50 ) ;
	WriteStr( 55, 22, 'Return: Edit User' ) ;
	WriteStr( 55, 23, 'Delete: Remove User' ) ;
  WriteStr( 58, 24, '''S'': Switch Users' ) ;
	For K:= 12 to 20 do
		begin
			WriteChar( 5, k, '³' ) ;
			WriteChar( 15, k, '³' ) ;
			WriteChar( 70, k, '³' ) ;
			HiLite( 2, k, Blue, 76 ) ;
		end ;
	Repeat until keypressed ;
  WinDown ;
end.