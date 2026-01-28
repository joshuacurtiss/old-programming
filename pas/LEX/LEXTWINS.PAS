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
		works:=FALSE;
		len:=length(s);
		For i:=1 to len - 1 do {CHECK WURD}
			begin
				if (s[i]=s[i+1]) and (works=FALSE) then{CHECK FOR DOUBLE LETTERS }
					works:=TRUE;
				end;
				if works then writeln (s);{WRITE THE DOUBLE LETTER WURD}
	until keypressed or (s='');
end.
