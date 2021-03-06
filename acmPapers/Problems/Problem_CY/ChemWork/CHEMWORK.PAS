(*
  Arbain's Chemical Magic
*)
{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}

const fnIn ='ChemWork.in';
      fnOut='ChemWork.out';
      TaskLim=1000;

var task:array[1..2,1..TaskLim]of byte;
    odr:array[1..TaskLim]of integer;{optimized order}
    n,totTime:longint;

procedure init;
var i,j,k:integer;
begin
  assign(input,fnIn);reset(input);
  readln(n);
  for i:=1 to n do readln(task[1,i],task[2,i]);
  close(input);
end;

procedure Order;
{calculate the optimized order
 by perform a greedy programing}
var i,j,k,
    min,bestj,bestk,
    pfront,ptail:integer;
    tick:array[1..TaskLim]of 0..1;
begin
  fillchar(tick,sizeof(tick),0);
  pfront:=0;ptail:=n+1;
  for i:=1 to n do
    begin
      {get the minimal element}
      min:=30000;
      for j:=1 to n do if (tick[j]=0)then
        for k:=1 to 2 do if task[k,j]<min then
          begin min:=task[k,j];bestj:=j;bestk:=k;end;
      tick[bestj]:=1;
      case bestk of
        1:begin inc(pfront);odr[pfront]:=bestj;end;{put it ahead}
        2:begin dec(ptail); odr[ptail] :=bestj;end;{put it back}
      end;
    end;
end;

procedure CalcTime;
{calculate the total time
 according to the optimized order}
var i,j:longint;
    Tm:array[0..TaskLim]of longint;{Task2 start time}
begin
  tm[0]:=0;for i:=1 to n do tm[i]:=tm[i-1]+task[1,odr[i]];
  tottime:=0;
  for i:=1 to n do
    begin
      j:=odr[i];
      if tottime>tm[i]
        then inc(tottime,task[2,j])
        else tottime:=tm[i]+task[2,j];
    end;
end;

procedure done;
begin
  assign(output,fnOut);rewrite(output);
  writeln(tottime);
  close(output);
end;

Begin
  init;
  order;
  calctime;
  done;
End.
