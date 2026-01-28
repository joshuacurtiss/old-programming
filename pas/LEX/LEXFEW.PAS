Program Steve;
uses dos,crt;
{$M 1024,0,0}

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

var	s, tempwurd:wurdtype;
		I, J, counter, len:integer;
		ratio:real;
begin
	assign(dicfile,'e:lex20a.rec');
	reset(dicfile,wurdsize+1);
	dicsize:=filesize(dicfile);
	close(dicfile);
	ResetCache;

	ClrScr;
	ratio:=1;
	 repeat
		s:=ReadWurd;
		tempwurd:=s;
		Len:=length(s);
		counter:=0;{SET TO NOTHING}
		for i:=1 to len-1 do  {CHECK WHOLE WURD}
			for j:=i+1 to len do {START A SECOND CHECKER}
			if s[i]=s[j] then {IF ANY TWO LETTERS ARE THE SAME THEN MARK}
						s[j]:='-';  {WITH A DASH }
		for i:=1 to len do
			if s[i]<>'-' then inc(counter);{WHATEVER LETTERS ARE NOT DASHES}
		if (counter/len<ratio) and (len>0) then {THEN COUNT IT}
					begin
						ratio:=counter/len; {DIVIDE THE NUMBER OF DIFFERENT LETTERS }
						writeln (tempwurd:20,'    ',ratio:0:10); {TO THE TOTAL}
					end;{if}
	 until keypressed or (S='');
end.


