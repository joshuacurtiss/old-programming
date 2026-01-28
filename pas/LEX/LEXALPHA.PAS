Program Steve;
uses dos,crt;
{$M 4096,0,0}
const cachesize=3000;
			wurdsize=20;

type
	wurdtype=string[wurdsize];

Var
	works:boolean;
	match, tempwurd:wurdtype;
	len, i:integer;
	DicFile:file;
	Cache:array[1..cachesize] of wurdtype;
	dicsize,foffset,coffset:longint;

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
			end;
	end;

Function ReadWurd:wurdtype;
	var result:word;
			remainder:word;
	begin
		if coffset<cachesize then
			begin
				ReadWurd:=cache[coffset+1];
				inc(coffset);
			end
		else
			begin
				if foffset<dicsize-cachesize then
					begin
						if dicsize<=foffset+cachesize then
							begin
								coffset:=foffset+cachesize-dicsize;
								foffset:=dicsize-cachesize;
							end
							else foffset:=foffset+cachesize;
						reset(dicfile,wurdsize+1);
						seek(dicfile,foffset);
						blockread(dicfile,cache,cachesize,result);
						close(dicfile);
						coffset:=1;
						Readwurd:=cache[1];
					end
				else ReadWurd:='';
			end;
	end;

var b:boolean;
		s:wurdtype;

begin
	assign(dicfile,'e:lex20.rec');
	reset(dicfile,wurdsize+1);
	dicsize:=filesize(dicfile);
	close(dicfile);
	ResetCache;
	writeln;
	repeat
		s:=ReadWurd;
		works:=TRUE; {WHY?}
		len:=length(s);{NUMBER OF CHARS IN WURD}
		For i:=1 to len - 1 do {CHECK WHOLE WURD}
			begin
				if (s[i]>s[i+1]) and (works=TRUE) then {COMPARE CURRENT LETTER}
					works:=FALSE;                        {WITH NEXT LETTER}
				end;
				if works then writeln (s); {WHAT?}
	 until keypressed or (s='');{KEEP GOING UNTIL THEY HIT KEY OR WE RUN}
															{OUT OF WURDS}
end.
