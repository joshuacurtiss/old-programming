Program Steve;
uses dos,crt;
{$M 4096,0,0}

const cachesize=3000;
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
		s,t,match:wurdtype;
		len,len2, i:integer ;


begin
	assign(dicfile,'e:lex20a.rec');
	reset(dicfile,wurdsize+1);
	dicsize:=filesize(dicfile);
	close(dicfile);
	ResetCache;

	ClrScr ;

	writeln('Please enter a string(it must be in all caps!) ' );
	readln(match);{FIND IN DICTIONARY}
	Len2:=length(match) + 1;

	repeat
		s:=Readwurd ;
		t:=s;{ FIND WURDS THAT CONTAIN MATCH}
		Len:=length(s) - 3 ;

		if Len >= Len2 then {ONLY CHECK MATCH WITH WURDS THAT ARE GREATER THAN}
			begin
				I:=1;
				while(I < Len2) and (Pos(match[I], s) <> 0) do
					begin
						delete(s, pos(match[I], s ), 1);
						inc(I);
					end;
				if I = Len2 then
					write(T:20);
			end;

	until keypressed or (t= ' ')  ;

end.
