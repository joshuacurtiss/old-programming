Program Good_Traction ;

Uses DOS, CRT ;

Var Poem:Array[ 1..20 ] of String[ 80 ] ;
    I, J, C:Byte ;

Procedure WriteChar_a( x, y:Byte ; C:Char ; attr:Byte );

Begin
  memw[$B800:2* ((x-1) + (y - 1) * 80)] := Ord(C) + attr * 256
End;

{ Chr(GetCharAttr(x,y) Mod 256) = Character                               }
{ GetCharAttr(X, Y) Div 256 = Attribute        Background*16 + Textcolor  }

Procedure WriteChar( x, y:Byte ; a:Char ) ;

begin
  mem[ $b800:2 * ( (x-1)+(y-1)*80 ) ] := Ord( a ) ;
end ;

Procedure WriteStr_a( x, y:Byte ; text:String ; Attr:Byte ) ;

Var I:Byte ;

Begin
  For I:=x to Length( text ) + x - 1 do
    WriteChar_a( i, y, Text[i-x+1], Attr ) ;
end ;

Procedure WriteStr( x, y:Byte ; text:string ) ;

Var I:Byte ;

Begin
  For I := x to Length( text )+x-1 do
    WriteChar( i, y, Text[ I-X+1 ] ) ;
end ; {WriteStr PROC}

Procedure WriteCenter( Text:String ) ; {Writes in center of current line}

Begin
  If 40 - ( Length( Text ) Div 2 ) > 0 then
    WriteStr( ( 40 - (Length(Text) Div 2) ), WhereY, Text )
  else
    WriteStr( 1, WhereY, Text ) ;
  If WhereY < 25 then
    GotoXY( 1, WhereY+1 ) ;
end ; {WriteCenter Proc}

Procedure ChillOut( hun:Word ) ; {Not Suggested for use over one hour.   }
                                 {      Who would want to?               }
{Do not feed this guy Neg Nums!} {May puke out at the stroke of midnight.}

Var Hour, Min, Sec, h, Hour2, M2, S2, h2:word ;

Begin
  GetTime( Hour, Min, Sec, H ) ;    {Get Original Time}
  Repeat
    GetTime( Hour2, m2, s2, h2 ) ;
    If (Hour=23) and (Hour2<23) then Hour2:=24 + Hour2 ;
    m2:=m2 + 60 * (Hour2 - Hour) ;
    s2:=s2 + 60 * (m2 - min) ;     {Find the Change in Time in Hundredths}
    h2:=h2 + 100 * (s2 - sec) ;
  Until ( H2 - H ) >= hun ;        {Wait till the specified time}
end ; {ChillOut Proc}

Begin
  ClrScr ;
  GotoXY( 2, 2 ) ;
  WriteCenter( '* *  Good Traction  * *' ) ;

  Poem[ 1 ]  := '(A True Story, Fortunately Not My Own)' ;
  Poem[ 2 ]  := '  ' ;
  Poem[ 3 ]  := 'The woods, the River, my Wheels---' ;
  Poem[ 4 ]  := 'More importantly: The Hill.' ;
  Poem[ 5 ]  := 'Why? It''s there. It must be conquered.' ;
  Poem[ 6 ]  := 'After all, it''s only thirty feet down.' ;
  Poem[ 7 ]  := 'As I begin my attack, my faith is strong' ;
  Poem[ 8 ]  := 'The stones do not frighten me; the roots are minute' ;
  Poem[ 9 ]  := 'The speed increases, the concentration grows...' ;
  Poem[ 10 ] := '  ' ;
  Poem[ 11 ] := 'I have no fear.' ;
  Poem[ 12 ] := '  ' ;
  Poem[ 13 ] := 'But then gravity turns against me' ;
  Poem[ 14 ] := 'The wheels lose their grasp, the stones strike them' ;
  Poem[ 15 ] := 'My bike is behind me, Mr. Boyer has my free-body diagram' ;
  Poem[ 16 ] := 'As I strike the ground a stone finds my chest, ' ;
  Poem[ 17 ] := 'the bike finds me again.' ;
  Poem[ 18 ] := 'The hill beat me for now, but it better beware:' ;
  Poem[ 19 ] := '  ' ;
  Poem[ 20 ] := 'Next time, I''ll get better traction.' ;
  C := 0 ;
  While NOT Keypressed do
    Begin
      For i := 1 to 20 do
        WriteStr_a( 4, i+3, Poem[ i ], ( C + i ) mod 15 ) ;
      If KeyPressed then Exit
      else ChillOut( 20 ) ;
      GotoXY( 68, 25 ) ;
      Write( 'Color: ', C, '. ' ) ;
      Inc( c ) ;
      If C>14 then c := 0 ;
    end ; {WHILE/DO}
end.
