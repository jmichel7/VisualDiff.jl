#######################################################################

# Given an element $w$ of the Weyl group $W$, the following function returns
# the set of indices of generators of $W$ which subtract to $w$ on the left
#

LeftRefs:=function(W,w) 
        return Filtered([1..W.dim],i->W.rootIndices[i]^w>W.parentN);end;


# Given $\bw$ an element of $B^+$, the following function tests whether
# the Deligne normal form of $\bw$ is a product
#   $\bw_{J_1}^{n_1}\ldots \bw_{J_k}^{n_k}$
# (if this happens it implies the sequence $I_1\ldots I_k$ is decreasing.
# Conversely, if an element $\bw\in B^+$ is a product 
# $\bw_{J_1}^{n_1}\ldots \bw_{J_k}^{n_k}$ with decreasing $J$'s, then this is
# Deligne normal form).
# If the test succeeds, the function returns the GAP list 
# |[[I_1,n_1],..,[I_k,n_k]]| otherwise it returns |false|

isgood:=function(w)local res,v,I,w;
  res:=[];
  if w.pw0>0 then Add(res,[[1..w.W.dim],w.pw0]);fi;
  for v in w.elm do
   I:=Set(WeylWordPerm(w.W,v));
   if LeftRefs(w.W,v)<>I then return false;fi;
   if Length(res)>0 and res[Length(res)][1]=I then 
                        res[Length(res)][2]:=res[Length(res)][2]+1;
   else	Add(res,[I,1]);
   fi;
  od;
  return res;
  end;

# Given the Hecke algebra $H$ of $W$ with equal parameters $q$, this function
# returns a vector of integers $\{n_\chi\}$ for irreducibles $\chi$ of $H$,
# where $\omega_\chi(\pi)=q^{n_\chi}$. Here $\omega_\chi(\pi)$ is defined
# as being the unique eigenvalue of $\pi=T_{w_0}^2$ in a representation
# affording character $\chi$.
#

omegapi:=function(W)local ct,id,refl;
  ct:=CharTable(W);
  refl:=Filtered([1..Length(ct.classes)],i->Length(ct.classtext[i])=1);
  id:=PositionProperty(ct.classtext,x->Length(x)=0);
  return List(ct.irreducibles,x->((x[id]+x{refl})*ct.classes{refl})/x[id]);
  end;

# The following program computes absolute values of eigenvalues of $T_\bw$ for
# $\bw$ a ``good'' element of the braid monoid, i.e. an element whose normal
# form is a product  $\bw_{J_1}^{n_1}\ldots \bw_{J_k}^{n_k}$.
# The result is a GAP list containing one list for each irreducible $\chi$.
# This last list is a list of pairs |[a,b]| meaning that the absolute value
# $v^{2a} occurs with multiplicity $b$ in a representation affording $\chi$.

eigw:=function(W,w)local WI,WJ,J,eig,d,collect,smul,indeig,wd,digits;

  d:=OrderPerm(PermBraid(w));
  wd:=isgood(w^d);
  if wd=false then Error(w," is not good\n");fi;
  Print(w,"^",d,"=");
  digits:="123456789";
  for J in wd do Print("w_{",digits{J[1]},"}^{",J[2],"}.");od;
  Print("\n");

  collect:=v->List(Set(List(v,x->x[1])),
                   x->[x,Sum(Filtered(v,y->y[1]=x),y->y[2])]);

  # Let $T$ in the hecke algebra of $H$ (a Weyl subgroup of $W$) have
  # eigenvalues in each reprentation given by the list |eig|. The result
  # is a the list representing the eigenvalues of $T$ in representations
  # of $H$.

  indeig:=function(H,W,eig)local resWH;
     resWH:=InductionTable(H,W);
     eig:=List([1..Length(resWH)],
		i->collect(Concatenation(List([1..Length(eig)],
		j->List(eig[j],x->[x[1],resWH[i][j]*x[2]])))));
     return List(eig,e->Filtered(e,y->y[2]<>0));
     end;

  # multiply eigenvalues represented by list |eig| by a constant $s_\chi$
  # for each character $\chi$.
  smul:=function(s,eig)
     return List([1..Length(eig)],i->List(eig[i],y->[y[1]+s[i],y[2]]));
     end;

  if Length(wd)=0 or wd[1][1]<>[1..W.dim] then
         wd:=Concatenation([[[1..W.dim],0]],wd);fi;
  WJ:=WeylSubgroup(W,wd[Length(wd)][1]);
  eig:=smul(omegapi(WJ)*wd[Length(wd)][2]/2,
            List(CharTable(WJ).irreducibles,x->[[0,x[1]]]));
  for J in wd{[Length(wd)-1,Length(wd)-2..1]} do
    WI:=WeylSubgroup(W,J[1]);
    eig:=indeig(WJ,WI,eig);
    eig:=smul(omegapi(WI)*J[2]/2,eig);
    WJ:=WI;
  od;
  return List([1..Length(eig)],i->List(eig[i],y->[y[1]/d,y[2]]));
  end;

# The following function keeps only those eigenvalues which can contribute
# to $\chi(T_w)$, i.e. those $v^a$ such that $a/2$ is integral if $\chi$
# is rational or such that $a$ is integral otherwise. The second argument
# is a list of pairs |[i,j]| such that $\chi_i$ is Galois-conjugate to
# $\chi_j$. The function also discards the multiplicities in |eig|, since
# we don't use them, so from now on |eig| contains for each $\chi$ just
# the list $n_{\chi,1},\ldots,n_{\chi,r}$ such that the eigenvalues are
# $v^{2 n_{\chi,1}},\ldots,v^{2n_{\chi,r}}$

reduce:=function(eig,gal)
  return List([1..Length(eig)],i->Filtered(List(eig[i],x->x[1]),
	      function(x) if i in Concatenation(gal)
	                  then return IsInt(2*x);
			  else return IsInt(x);fi;end));
  end;

# Now is a series of routines giving relations 1--7. The result of all these
# routines is always a list of vectors $[v_1,\ldots,v_r]$ such that each $v_i$
# is of same length $1+A$ where |A=Sum(eig,Length)|
# (the number of variables $a_{\chi,i}$) and represents a relation
#  $v_{A+1} + \sum_{j=1}^{j=A} a_j v_i=0$ (where $a_j$ is the $j$th variable
#  $a_{\chi,i}$).


# The next function returns the relations given by the value
# $\chi_(T_w)_{v\mapsto 1}$. The first argument is the index of the
# class of $w$ in the character table of $W$.
#
relsvalue:=function(index,W,eig)local i,v,res,model,ti;
  Print("using relations coming from character values\n");
  ti:=CharTable(W);
  res:=[];model:=List(eig,x->List(x,y->0));
  for i in [1..Length(eig)] do
    v:=Copy(model);v[i]:=v[i]+1;
    if Length(eig[i])>0 then
       v:=Concatenation(v);
       Add(v,-ti.irreducibles[i][index]);
       Add(res,v);
    fi;
  od;
  return res;
end;

# The next function returns the relations coming from Curtis-Alvis duality.
# The first argument is the length of $w$.

relsdual:=function(len,W,eig)local dual,cd,model,res,i,c,v,ti;
  Print("using relations coming from Curtis-Alvis duality\n");
  ti:=CharTable(W);
  res:=[]; model:=List(eig,x->List(x,y->0));
  dual:=List(ti.irreducibles,x->Position(ti.irreducibles,
    List([1..Length(x)],i->x[i]*ti.irreducibles[2][i])));
  cd:=Filtered([1..Length(ti.classtext)],i->i<=dual[i]); # just do the job once
  for i in cd do
   for c in [1..Length(eig[i])] do
     v:=Copy(model);
     v[i][c]:=v[i][c]-1;
     v[dual[i]][1+Length(eig[i])-c]:=v[dual[i]][1+Length(eig[i])-c]+(-1)^len;
# the addition is to handle correctly a self-dual coefficient
     v:=Concatenation(v);Add(v,0);Add(res,v);
   od;
   od;
   return res;
   end;

# The next function takes an argument |gal| as |reduce| does and returns
# relations expressing that $\chi_i$ and $\chi_j$ are Galois-conjugate

relsgal:=function(eig,gal)local model,c,v,res,x;
   Print("using relations coming from Galois-conjugation\n");
   res:=[]; model:=List(eig,x->List(x,y->0));
   for x in gal do
   for c in [1..Length(eig[x[1]])] do
     v:=Copy(model);
     v[x[1]][c]:=-1; v[x[2]][c]:=(-1)^(2*eig[x[1]][c]);
     v:=Concatenation(v);
     Add(v,0);
     Add(res,v);
   od;
   od;
   return res;
   end;

# The next function (used in the one just after) returns the values on $T_w$
# of the exterior powers of the reflection character of the Hecke
# algebra |HW| of $W$ as polynomials in $v$.
# The first argument is the |WeylWord| representing $w$, the second
# argument is the Hecke algebra of $W$.
#
refchars:=function(w,HW)local HW,l,p,T,q;
 q:=HW.parameter[1];T:=X(q.domain); 
 if Length(w)=0 then l:=IdentityMat(HW.dim);
 else l:=Product(HeckeReflectionRepresentation(HW){w});fi;
 p:=DeterminantMat(IdentityMat(HW.dim)*T-l);
 return List([1..HW.dim+1],i->p.coefficients[i]*
                       q^(Length(w)*(i-HW.dim))*(-1)^(HW.dim+1-i));
 end;

# The next function returns the relations expressing the value on $T_w$ of
# the exterior powers of the reflection character.
# The first argument is the |WeylWord| of $w$, and the second and third are
# the Weyl group and Hecke algebra.
#
relsrefl:=function(w,W,HW,eig)
  local i,j,m,c,v,res,refs,model,degs,pos,refind,refls,ti;
  Print("using the values of the exterior power of reflection character\n");
  ti:=CharTable(W);
  refs:=refchars(w,HW);
  refls:=PositionProperty(ti.irredinfo,x->x.charparam=[W.dim,1]);
  refls:=List([W.dim,W.dim-1..1],
              i->AntiSymmetricParts(ti,ti.irreducibles{[refls]},i)[1]);
  refind:=List(refls,x->Position(ti.irreducibles,x));
  Add(refind,1);
  res:=[]; model:=List(eig,x->List(x,y->0));
  for i in [1..Length(refind)] do
    m:=Copy(refs[i].coefficients);
    degs:=[1..Length(m)]+refs[i].valuation-1;
    if IsBound(HW.sqrtParameter[1]) then degs:=degs/2;fi;
    v:=Copy(model);
    c:=IdentityMat(Length(eig[refind[i]]));
    for j in [1..Length(eig[refind[i]])] do
     v[refind[i]]:=c[j];
     pos:=Position(degs,eig[refind[i]][j]);
     if pos=false then
       Add(res,Concatenation(Concatenation(v),[0]));
     else
       Add(res,Concatenation(Concatenation(v),[-m[pos]]));
       m[pos]:=0;
     fi;
    od;
#   if Number(m,x->x<>0)>0 then 
#    Print(" refs[",i,"]:",refs[i]," eig[",refind[i],"]",eig[refind[i]],"\n");
#    Error("value of refl. chars");fi;
  od;
  return res;
  end;
    
# The next function returns relations expressing
# $\varphi(T_w)_{v\mapsto \exp(\pi/d)}=0$ for virtual characters orthogonal
# to $\Phi_d$-projectives.
#  The third argument is a list of vectors $v_i$ such that $v_i$ is the
# list of coefficients of some $\varphi$ on the irreducibles.

relsd:=function(d,eig,null)local v,i,res,n,model;
  Print("using relations from the Phi_",d,"-decomposition matrix\n");
  res:=[];
  model:=List(eig,k->List(2*k,x->E(2*d)^x));
  for i in null do
     v:=Concatenation(List([1..Length(model)],k->model[k]*i[k]));
     Add(v,0);
     n:=NofCyc(v);
     v:=TransposedMat(List(v,x->CoeffsCyc(x,n)));
     v:=Filtered(v,x->Number(x,y->y<>0)>0);
     Append(res,v);
  od;
  return res;
end;

# The next function returns the relations coming from 
# $\sum_\chi \chi(T_w)d_\chi=0$. The second argument is the Hecke algebra.
#
relsdegg:=function(eig,HW)local offs,v,gendeg,res,i,j,k,degs;
  Print("using relations coming from generic degrees\n");
  offs:=List(eig,Length);
  offs:=Concatenation([0],List([1..Length(offs)],i->Sum(offs{[1..i]})));
  v:=SchurElements(HW);
  gendeg:=List(v,x->v[1]/x);
  Print(gendeg[2],"\n");
  res:=List([1..1+4*HW.N],x->List([1..offs[Length(offs)]],y->0));
  for i in [1..Length(eig)] do
   degs:=Filtered([1..Length(gendeg[i].coefficients)],
                     k->gendeg[i].coefficients[k]<>0)+gendeg[i].valuation-1;
   gendeg[i].coefficients:=Filtered(gendeg[i].coefficients,y->y<>0);
   if IsBound(HW.sqrtParameter[1]) then degs:=degs/2;fi;
   for j in [1..Length(eig[i])] do
     res{eig[i][j]+degs}[j+offs[i]]:=gendeg[i].coefficients;
   od;
  od;
  res:=Filtered(res,x->Number(x,y->y<>0)>0);
  for v in res do Add(v,0);od;
  return res;
  end;

# To save space we apply each new set of relations as soon as possible.
# We current our current knowledge as a record |M| with 3 fields:
# \begin{itemize}
#  \item |M.known| is the indices of the variables $a_j$ that we know already.
#  \item |M.values| is the values of the variables $a_j$ that we know already.
#  \item |M.relations| is a set of vetors representing the relations on
#     the remaining variables.
# \end{itemize}
# The next function takes a bunch of new relations and modifies |M| accordingly.
# It uses the routine  |TriangulizeMat| to find all completely known basis
# vectors resulting from |M.relations|, and then supresses the corresponding
# columns from |M.relations|, adding entries instead to |M.known| and
# |M.values|.
# It returns |true| iff at the end of the process all values are known.

apply:=function(newrels,M)local compl,i,newval,newind;
  if Length(newrels)=0 then return false;fi;
  compl:=Filtered([1..Length(newrels[1])-1],i->not i in M.known);
  if Length(M.known)>0 then
    newrels:=List(newrels,
                x->Concatenation(x{compl},[x[Length(x)]+x{M.known}*M.values]));
  fi;
  Append(M.relations,newrels);
  Print("starting triangulization\n");
  TriangulizeMat(M.relations);
  M.relations:=M.relations{[1..RankMat(M.relations)]};
# if Length(M.relations)>0 and 
#    PositionProperty(M.relations[Length(M.relations)],y->y<>0)=
#             Length(M.relations[1])
# then Error("contradiction");fi;
  newval:=Filtered(M.relations,x->Number(x{[1..Length(x)-1]},y->y<>0)=1);
  M.relations:=Filtered(M.relations,x->Number(x{[1..Length(x)-1]},y->y<>0)<>1);
  newind:=List(newval,x->PositionProperty(x,y->y<>0));
  M.relations:=List(M.relations,x->Concatenation(
	x{Filtered([1..Length(x)-1],y->not y in newind)},[x[Length(x)]]));
  Append(M.known,compl{newind});
  Append(M.values,List(newval,x->-x[Length(x)]));
  SortParallel(M.known,M.values);
  Print("known:",Length(M.known)," unknown:");
  if Length(M.relations)>0 then
     Print(Length(M.relations[1])-1," rank:",RankMat(M.relations),"\n");
     return false;
  else return true;fi;
  end;

# Now we put everything together to get a routine which returns all
# character values on $T_w$. The arguments are:
# \begin{itemize}
#  \item The index of the class of $w$ in the character table of $W$.
#  \item The Hecke algebra of $W$.
#  \item A list |null| which should be such that |null[e]| is bound
#        precisely when $\Phi_e$ divides the Poincar\'e polynomial, and
#        then |null[e]| contains the kernel of the $\Phi_e$-decomposition
#        matrix s explained in |relsd|.
#  \item A list |gal| as explained in |reduce|.
# \end{itemize}
#
# The result is the list of character values on $T_w$ as polynomials in $v$.
#
getchar:=function(ind,HW,null,gal)local eig,M,values,e,w,ti,W,w0;
  Print("trying element ",ind," ...\n");

# The next function returns the polynomial described by |eig| and a record
# |M| such that |M.known| is everybody and |M.relations| is empty.
# Actually we accept that |M.know| is not everybody and then give the
# arbitrary value 999 to unknown entries, which is quite distinctive
# and allows us at a glance to see what is known or not in
# a partially known character value.
#
  values:=function(M,eig)local vals,offs;
    vals:=999+[1..Sum(eig,Length)]*0;
    vals{M.known}:=M.values;
    offs:=List(eig,Length);
    offs:=Concatenation([0],List([1..Length(offs)],i->Sum(offs{[1..i]})));
    vals:=List([1..Length(eig)],i->vals{[offs[i]+1..offs[i+1]]});
    return 
      List([1..Length(vals)],function(i)
	if Length(vals[i])=0 then return 0;
	else return vals[i]*List(eig[i],function(n)
              if IsInt(n) then return HW.parameter[1]^n;
                          else return HW.sqrtParameter[1]^(2*n);
              fi;end);
	fi;end);
    end;


  W:=Weyl(HW.cartan);
  ti:=CharTable(W);
  eig:=eigw(W,Braid(W,ti.classtext[ind]));
  eig:=reduce(eig,gal);
  M:=rec(known:=[],values:=[],relations:=[]);
  if apply(relsvalue(ind,W,eig),M) then return values(M,eig);fi;
  if apply(relsdual(Length(ti.classtext[ind]),W,eig),M)
      then return values(M,eig);fi;
  if apply(relsgal(eig,gal),M) then return values(M,eig);fi;
  if apply(relsrefl(ti.classtext[ind],W,HW,eig),M) then return values(M,eig);fi;
  for e in Filtered([1..Length(null)],j->IsBound(null[j])) do
    if apply(relsd(e,eig,null[e]),M) then return values(M,eig);fi;
  od;
  if apply(relsdegg(eig,HW),M) then return values(M,eig);fi;
  Print("not enough relations");return values(M,eig);
  end;

# The following lines use the above routines to write all the character
# values on cuspidal classes of the Hecke algebra of $E_8$.

# define $v$
v:=X(Rationals); v.name:="v";

# define the hecke algebra (one gives the parameter $v^2$ and its square
# root $v$).
HW:=Weyl(CartanMat("E",8),v^2,v);

# Read in the list |null| which has been obtained from \cite{Mu}, \cite{Ge3}
# and the GAP routine |NullSpaceMat|.
Read("nulle8.g");

# Define now the Weyl group from the Hecke algebra.
W:=Weyl(HW.cartan);

# get its character table
ti:=CharTable(W);

# find cuspidal classes
cuspidal:=Filtered([1..Length(ti.classtext)],
                    i->Set(ti.classtext[i])=[1..HW.dim]);

# Define the galois-relations
gal:=[[62,105],[63,106]];

# And go!
List(cuspidal,i->getchar(i,HW,null,gal));end;

######################################################################
