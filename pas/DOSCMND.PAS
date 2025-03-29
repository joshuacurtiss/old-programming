Program DOScommander ;

{ Example for GetEnv and SwapVectors }

{$M 8192, 0, 0}

Uses Dos;

Var Command: string[79];

Function Left( TheString:String ; ToWhatChar:Integer ):String ;

Var Segment:String ;
    I:Integer ;

Begin
  Segment:='' ;
  For I:=1 to ToWhatChar do
    Segment := Segment + TheString[ i ] ;
  Left := Segment ;
end ; {Left Proc}


begin
  Writeln('Enter DOS command: ');
  Repeat
    Write( 'JoshDOS: ' ) ;
    ReadLn(Command);
    If Command = 'quit' then Command := '' ;
    if Command <> '' then
      Command := '/C ' + Command;
    SwapVectors;
    Exec(GetEnv('COMSPEC'), Command);
    SwapVectors;
    if DosError <> 0 then
      WriteLn('Could not execute COMMAND.COM');
  Until Command = 'quit' ;
end.
