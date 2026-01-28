Program Steve;
uses dos,crt;
{$M 4096,0,0}

const cachesize=3000;
			wurdsize=20;

type
	wurdtype=string[wurdsize];
	Letarraytype = Array['A' ..'Z'] of longint;
	lexrectype=record
		wurd:wurdtype;
		part:wurdtype;
	end;{record}
	lexfiletype=file of lexrectype;

Var
	x,y:array['A'..'Z'] of integer;
	letters:letarraytype;
	DicFile:file;
	triwurd,guess:wurdtype;
	i, mid, len: integer;
	Cache:array[1..cachesize] of wurdtype;
	size, dicsize, foffset, coffset:longint;
	works:boolean;
	ch:char;
	offset:word;
	multiplier:byte;
	lexfile:lexfiletype;

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


var s,t:wurdtype;
		b:boolean;
begin
	clrscr;
	multiplier:=0;
	assign(dicfile,'e:lex20a.rec');
	reset(dicfile,wurdsize+1);
	dicsize:=filesize(dicfile);
	assign (lexfile,'e:lex20a.rec');
	reset (lexfile);
	size:=filesize(lexfile);
	close(dicfile);
	ResetCache;
	writeln;
	for ch:='A' to 'Z' do
		begin
			if (ord(ch)-65) mod 6 = 0 then multiplier:=0;
			x[ch]:=multiplier*12+1;
			inc(multiplier);
		end;
	multiplier:=1;
		for ch:= 'A' to 'Z' do
			begin
				if (ord(ch)-65) mod 6 = 0 then
					inc(multiplier,2);
				y[ch]:=multiplier;
			end;
	 repeat
		t:=s;
		s:=Readwurd ;
		Len:=length(s) ;
		for I:= 1 to len do
			inc(Letters[s[i]]);
		For ch:='A' to 'Z' do
			if letters[ch] mod 50 = 0 then
			begin
				gotoxy(x[ch],y[ch]);;
				write (ch,letters[ch]:10);
			end;
		if s[1] <> t[1] then
			begin
				gotoxy(1,20);
				write(s[1]);
			end;
{   write (s:40);}
	 until keypressed;
end.
