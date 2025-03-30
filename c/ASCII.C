// ASCII Return Values

#include <stdio.h>
#include <conio.h>                // Need this for the clrscr()
#include <ctype.h>                // Need this for the getche
#include "ascii.h"

void main( void )
{
	int charval, special, StillHappy = 1 ;
	char key ;

	clrscr() ;
	printf( "ASCII Values:\nPress Alt-X to Quit.\n\n" ) ;
	while( StillHappy )
	{
		key = getch() ;
		charval = key ;
		if( charval != 0 )
			special = 0 ;
		else
		{
			special = 1 ;
			key = getch() ;
			charval = key ;
		}
		if( key == ALTX )
			StillHappy = 0 ;
		printf( "Char: %c\t\tASCII: ", key ) ;
		if( special )
			printf( "#%d.\n", charval ) ;
		else
			printf( "%d.\n", charval ) ;
	}
}