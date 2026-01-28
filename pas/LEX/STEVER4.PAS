{Put your name here}
Program lex;
uses dos,crt;
{$M 4096,0,0}

const cachesize=3000;
			wurdsize=20;

type
		wurdtype=string[wurdsize];
		lexrectype=record
			wurd:Wurdtype;
		end;
		lexfiletype=file of lexrectype;

var lex:lexrectype;
		lexfile:lexfiletype;
		DicFile:file;
		Cache:array[1..cachesize] of wurdtype;
		dicsize,foffset:longint;
		coffset:word;

Procedure LexSearch (s:wurdtype;size:longint);
	var target,start,last:longint;
			Lex:LexRecType;
	begin
		last:=size-1;
		start:=0;
		Repeat
			target:=(start+last)div 2;
			seek(Lexfile,target);
			read(Lexfile,Lex);
			If Lex.wurd < s then
				start:=target+1
			else if Lex.wurd > s then
				last:= target-1
				else write(s:20);
		Until	(Lex.wurd=s) or (start>last);
	end; {procedure lexsearch}


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

var s:wurdtype;
		booly:boolean;
		len,i:integer ;
		size:longint;
begin
	assign(dicfile,'e:lex20.rec');
	reset(dicfile,wurdsize+1);
	dicsize:=filesize(dicfile);
	assign(lexfile,'e:lex20A.rec');
	reset(lexfile);
	size:=filesize(lexfile);
	close(dicfile);
	ResetCache;
	repeat
		s:=Readwurd;
		Len:=length(s);
	until (s='') or keypressed ;
end.
