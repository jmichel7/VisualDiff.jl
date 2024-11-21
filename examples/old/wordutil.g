# given generators g for a group find relators
genrel:=function(g)local letters,elms,i,j,w,p,last,new;
  letters:="RST";
  elms:=[rec(word:="Id",elm:=())];
  Append(elms,List([1..Length(g)],i->rec(word:=[letters[i]],elm:=g[i])));
  last:=0;
  new:=Length(elms);
  while new>last do
  for i in [last+1..new] do
    for j in [1..Length(g)] do
      w:=rec(word:=Concatenation(elms[i].word,[letters[j]]),
             elm:=elms[i].elm*g[j]);
      p:=PositionProperty(elms,x->x.elm=w.elm);
      if p=false then Add(elms,w);
      else Print(w.word,"=",elms[p].word,"\n");
      fi;
    od;
  od;
  last:=new;
  new:=Length(elms);
  od;
  return elms;
  end;

# given generators gens for group G express as elements all words length<=maxlen
words:=function(G,gens,maxlen,str)local gelms,f,i,l,c,ff;
gelms:=Elements(G);
f:=List(gelms,x->rec(e:=x,rd:=[]));
Add(f[1].rd,"");
for i in [1..maxlen] do
 for l in Cartesian(List([1..i],x->[1,Length(gens)])) do
   Print(l,"\n");
   Add(f[Position(gelms,Product(gens{l}))].rd,String(str{l}));
 od;
od;
SortParallel(List(f,x->Minimum(List(x.rd,Length))),f);
c:=ConjugacyClasses(G);
ff:=List(c,x->[]);
for l in f do Append(ff[PositionProperty(c,cl->l.e in cl)],l.rd);od;
l:=List(ff,x->Minimum(List(x,Length)));
ff:=List([1..Length(ff)],i->Filtered(ff[i],y->Length(y)=l[i]));
return rec(gens:=gens,redec:=ff,all:=List(f,x->x.rd));
end;
