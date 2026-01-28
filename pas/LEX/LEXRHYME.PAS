Program Steve;
uses dos,crt;
{$M 4096,0,0}
const cachesize=3000;
			wurdsize=20;

type
	wurdtype=string[wurdsize];

Var
	match, tempwurd:wurdtype;
	len1, len2:integer;
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
	assign(dicfile,'e:lex20a.rec');
	reset(dicfile,wurdsize+1);
	dicsize:=filesize(dicfile);
	close(dicfile);
	ResetCache;
	write ('Please enter a match (IN ALL CAPS PLEASE): ');
	read (match);
	writeln;
	len1:=length(match);
	repeat
		s:=ReadWurd;
		len2:=length(s);
		if len2>=len1 then
			begin
				tempwurd:=copy (s,len2-len1+1,len1);
				if match=tempwurd then write (s:20);
			end; {if-then}
	until keypressed or (s='');
end.
