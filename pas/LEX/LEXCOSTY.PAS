Program Steve;
uses dos,crt;
{$M 1024,0,0}

const cachesize=3078;
			wurdsize=20;

type
	wurdtype=string[wurdsize];

Var
	DicFile:file;
	Cache:array[1..cachesize] of wurdtype;
	dicsize,foffset:longint;
	coffset:word;

Procedure ResetCache;
	var
		result:word;
	begin
		reset(dicfile,wurdsize+1);
		blockread(dicfile,cache,cachesize,result);
		close(dicfile);
		foffset:=0;
		coffset:=0;
	end;

Procedure ReadCache(offset:longint);
	var
		result:word;
	begin
		if offset<=(dicsize-cachesize) then
			begin
				reset(dicfile,wurdsize+1);
				seek(dicfile,offset);
				blockread(dicfile,cache,cachesize,result);
				close(dicfile);
				foffset:=offset;
				coffset:=0;
			end
		else
			begin
				foffset:=dicsize-cachesize;
				coffset:=cachesize-(dicsize-offset);
				reset(dicfile,wurdsize+1);
				seek(dicfile,foffset);
				blockread(dicfile,cache,cachesize,result);
				close(dicfile);
			end;
	end;

Function ReadWurd:wurdtype;
	var result:word;
			remainder:word;
	begin
		if coffset<cachesize then
			begin
				inc(coffset);
				ReadWurd:=cache[coffset];
			end {read word from array}
		else
			if foffset+cachesize<>dicsize then
				begin
					if foffset+(2*cachesize)<dicsize then
						begin
							foffset:=foffset+cachesize;
							coffset:=0;
						end
					else
						begin
							coffset:=(foffset+2*cachesize)-dicsize;
							foffset:=dicsize-cachesize;
						end;
					reset(dicfile,wurdsize+1);
					seek(dicfile,foffset);
					blockread(dicfile,cache,cachesize,result);
					close(dicfile);
					inc(coffset);
					ReadWurd:=cache[coffset];
				end
			else ReadWurd:='';
	end;

var
		s:wurdtype;
		len, i:integer ;
		oldcost, cost:integer;
begin
	assign(dicfile,'e:lex20a.rec');
	reset(dicfile,wurdsize+1);
	dicsize:=filesize(dicfile);
	close(dicfile);
	ResetCache;
	Clrscr;
	oldcost:=0;{WHY?}
	repeat
		s:=Readwurd ;
		Len:=length(s) ;
if len=3 then{CHECK ONLY FOR 3 LETTER WURDS}
	begin
		cost:=0;{SET THIS TO NOTHING FOR EACH WURD}
			for I:= 1 to len do {DO WHOLE WURD, CHAR BY CHAR}
				cost:= cost + ord(s[I])-64; {SINCE 'A' IS 65, SUBTRACT 64 TO GET A 1}
			if	cost>=oldcost then {IF THIS WURD'S COST IS GREATER THAN THE OLD}
				begin									{GREATEST COST, THEN MAKE OLDCOST = COST}
					oldcost:=cost;
					writeln(s:7, oldcost:3);
				end;
	end;
until keypressed or (s='');

end.


