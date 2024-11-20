" returns string description as list of ranges of list of integers"
function as_ranges(l::AbstractVector{<:Integer})
  if isempty(l) return "[]" end
  res=[]
  br=l[1]
  er=br
  for i in 2:length(l)
    if l[i]!=er+1 push!(res,br:er);br=l[i];er=br
    else er+=1
    end
  end
  push!(res,br:er)
  join(map(x->x.start<x.stop ? string(x) : string(x.start),res),",")
end

# if exists returns p such that l[p]==l1 otherwise returns nothing
function Perm(l::AbstractVector,l1::AbstractVector)
  p=sortperm(l)
  p1=sortperm(l1)
  @inbounds if view(l,p)==view(l1,p1) 
    r=similar(p1)
@inbounds for (i,v) in enumerate(p1) r[v]=p[i] end
    r
  end
end

# compares lists a and b (whose descriptions are strings na and nb)
function cmpvec(a,b;na="a",nb="b",pr=print)
  if a==b return end
  if length(a)!=length(b)
    pr("length($na)=",length(a)," while length($nb)=",length(b),"\n")
  end
  if -a==b pr("$na=-$nb\n");return end
  pa=Perm(a,b)
  if pa!==nothing pr("$nb=$na[$pa]\n");return end
  pa=Perm(a,-b)
  if pa!==nothing pr("$nb=-$na[$pa]\n");return end
  for j in eachindex(a)
    if a[j]==b[j] continue end
    if a[j]==-b[j] pr("$na[$j]=-$nb[$j]\n");continue end
    t=findall(==(a[j]),b)
    if length(t)>0 pr(a[j]," found at ",t,"\n");continue end
    t=findall(==(-a[j]),b)
    if length(t)>0 pr("-",a[j]," found at ",t,"\n");continue end
    pr(na,"[$j]=",a[j]," not found\n")
  end
end

# for a sorted vector l add val to end if greater than all elems
# else replace with val element just larger than it
# return position where val put (nil if val already there)
function thresh_insert!(l,val)
  r=searchsorted(l,val)
  if !isempty(r) return nothing end
  pos=r.start
  if pos>length(l) push!(l,val)
  else l[pos]=val
  end
  pos
end

## Dynamic programming (slow) method to compute the longest common subsequence
## use to test next method
function diff_lcs(a,b)
  if isempty(a) return [] end
  tab=[]
  for i in eachindex(a)
    push!(tab,[])
    for j in eachindex(b)
      if a[i]==b[j]
        push!(tab[i],(i==1 || j==1)  ?  [[i,j]] : vcat(tab[i-1][j-1],[[i,j]]))
      else
	aa=(i==1 ? [] : tab[i-1][j])
	bb=(j==1 ? [] : tab[i][j-1])
        push!(tab[i],length(aa)>length(bb) ?  aa : bb)
      end
    end
  end
  res=fill(0,length(a))
  for p in tab[length(a)][length(b)]
    res[p[1]]=p[2]
  end
  res
end

# Hunt/Szymanski algorithm following Perl implementation
# Computes the longest common subsequence Seq between enumerables a and b
# a[i] matches b[Seq[i]]
#  Options:
#    if ignored(o)==true then element o does not take part in match
#    by(o) replaces object o for equality/hash comparison
#    kw could include sampling::Int and info: show info
function diff_hs(a,b;ignored=x->false,by=x->x,kw...)
  beg=1;aend=length(a);bend=length(b)

  matchVector=fill(0,length(a))
  # First we prune off any common elements at the beginning
  while aend>=beg && bend>=beg && a[beg]==b[beg] && !ignored(a[beg])
    beg+=1
  end
  matchVector[1:beg-1]=1:beg-1

  # then at the end
  while aend>=beg && bend>=beg && a[aend]==b[bend] && !ignored(a[aend])
    matchVector[aend]=bend;aend-=1;bend-=1;
  end

  # bcoll[h] is the decreasing list of indices of elements in b equal to h
  bcoll=Dict{eltype(a),Vector{Int}}()
  for i in beg:bend
    l=b[i]
    l=by(l)
    if ignored(l) continue end
    get!(()->Int[],bcoll,l)
    pushfirst!(bcoll[l],i)
  end

  t=Int[]
  links=Dict{Int,Vector{Any}}()
  for ai in beg:aend
    l=a[ai]
    if haskey(kw,:sampling) && ai%kw[:sampling]==0 kw[:info](ai) end
    l=by(l)
#   log("a[#{ai}]:<#{a[ai].inspect}>\n")
    if ignored(l) continue end
    for bi in get(bcoll,l,Int[])
      k=thresh_insert!(t,bi)
      if !isnothing(k)
        links[k]=[k>1 ? get(links,k-1,nothing) : nothing,ai,bi]
      end
    end
  end
# @show links
  if isempty(links) return matchVector end
  l=links[maximum(keys(links))]
  while !isnothing(l)
    matchVector[l[2]]=l[3]
    l=l[1]
  end
  if false
    seq=diff_lcs(a,b)
    if seq!=matchVector
      cmp(matchVector,seq)
      if !issorted(filter(!iszero,matchVector)) error("NOT INCREASING") end
    else println("OK!")
    end
  end
  return matchVector
end
       
function show_report(r)
  short(r)=r.start==r.stop ? string(r.start) : "$(r.start):$(r.stop)"
  prod(t->short(t[2])*(t[1]==:match ? "=" : "#")*short(t[3])*" ",r)
end

# returns a list of triples (:match or :differ,range in a,range in b)
#options: function ignored of an item + options of diff_hs
function diff_report(a, b;options...)
  matchVector=diff_hs(a, b;options...)
  push!(matchVector,length(b)+1) # usual trick to simplify test
  res=Tuple{Symbol,UnitRange{Int},UnitRange{Int}}[]
  r=[1,1]
  lastb=0
  for (ai,bi) in enumerate(matchVector)
    if bi==0
      if lastb==0 continue end
      push!(res,(:match,r[1]:ai-1,r[2]:lastb))
      r.=[ai,lastb+1]
    elseif lastb==0
      if haskey(options,:ignored) # see if ignored items are equal
        l=min(ai-r[1],bi-r[2])
	matches=map(0:l-1)do i
          options[:ignored](a[r[1]+i]) && options[:ignored](b[r[2]+i]) &&
            a[r[1]+i]==b[r[2]+i]
        end
	sr=0
	for i in 2:l
	  if matches[i]!=matches[i-1]
            push!(res,(matches[i-1] ? :match : :differ,r[1].+(sr:i-1),r[2].+(sr:i-1)))
	    sr=i
	  end
	end
	if l>0 && matches[l]
          push!(res,(:match,r[1].+(sr:l-1),r[2].+(sr:l-1))) 
	  r[1]+=l;r[2]+=l
	else r[1]+=sr;r[2]+=sr
	end
      end
      if r!=[ai,bi] push!(res,(:differ, r[1]:ai-1,r[2]:bi-1)) end
      r.=[ai,bi]
    elseif bi>lastb+1 || ai==length(a)+1
      push!(res,(:match, r[1]:ai-1,r[2]:lastb))
      push!(res,(:differ, ai:ai-1,lastb+1:bi-1))
      r.=[ai,bi]
    end
    lastb=bi
  end
  weed_diffs(res)
end

# d:: vector of diffs
function weed_diffs(dd;merge=true)
  j=0
  for d in dd
    if isempty(d[2]) && isempty(d[3]) continue end
    if merge && j>0 && dd[j][1]==d[1] && dd[j][2].stop+1>=d[2].start &&
                                dd[j][3].stop+1>=d[3].start
      dd[j]=(d[1],dd[j][2].start:d[2].stop,dd[j][3].start:d[3].stop)
    else
      j+=1;dd[j]=d
    end
  end
  dd[1:j]
end

function line_diff(a,b;ignored=c->c in " \t") 
  t=(a,b)
 # produce two vectors of decors
  r=[Decor[],Decor[]]
  for (type,range...) in diff_report(collect(a),collect(b);ignored)
    for i in 1:2
     n=Decor(nextind(t[i],0,range[i].start),type==:match ? :LEQ : :LDIFF)
      if !isempty(r[i]) && r[i][end].offset==n.offset r[i][end]=n
      elseif isempty(r[i]) || r[i][end].att!=n.att push!(r[i],n)
      end
    end
  end
# log(r[0].inspect+r[1].inspect+"\n")
  r
end

# compute best list of diffs from result of align
function match_to_align(matches,arange,brange)
# log("#{match.inspect} #{arange.inspect} #{brange.inspect}\n")
  if isempty(matches) return [(:differ,arange,brange)] end
  l=argmax(x->x[3],matches)
  vcat(match_to_align(filter(x->x[1]<l[1] && x[2]<l[2],matches),
	      arange.start:l[1]-1, brange.start:l[2]-1),
      [(:differ,l[1]:l[1],l[2]:l[2])],
      match_to_align(filter(x->x[1]>l[1] && x[2]>l[2],matches),
                    l[1]+1:arange.stop, l[2]+1:brange.stop))
end

function splitinlines(f)
  pat=opt.by_par ? r"\n\n|\r\n\r\n" : r"\r\n|\n|\r"
  res=String[]
  offset=noffset=1
  for m in eachmatch(pat,f)
    noffset=m.offset+length(m.match)
    push!(res,f[offset:noffset-1])
    offset=noffset
  end
  if noffset<=length(f) push!(res,f[noffset:end]) end
  res
end

# transforms diff dd between strings sa and sb to list of tuples
#  (line1,line2, nb chars matching)
function align(sa,sb,dd)
  lines=(1,1) 
# log("$dd\n")
# pat=opt.by_par ? r"\n\n|\r\n\r\n" : r"\r\n|\n|\r"
  pat=opt.by_par ? r"\n\n" : r"\n"
  matches=Tuple{Int,Int,Int}[]
  for (type, range...) in dd
#   du(i)="<$i[$(range[i])]=$(f[i][range[i]])>" 
#   log "$type$(du(1))$(du(2))lines=$lines\n"
    if type==:match
      pieces=splitinlines(sa[range[1]])
#     log "$(du(1))->$pieces\n"
      for p in pieces
        if !isempty(matches) && matches[end][1:2]==lines
          matches[end]=(matches[end][1:2]...,matches[end][3]+length(p))
        elseif !isempty(p) 
           push!(matches,(lines...,length(p)))
        end
        lines=lines.+count(pat,p)
      end
#     log(" matches=#{matches.map{|a,b,n| "#{a}-#{b}:#{n}"}.join(",")}\n")
    else
#     log("$(range[1])=$(du(1))\#\\n=$(count('\n'),sa[range[1]])")
#     log("$(range[2])=$(du(2))\#\\n=$(count('\n'),sb[range[2]])\n")
      lines=(lines[1]+count(pat,sa[range[1]]),
             lines[2]+count(pat,sb[range[2]]))
    end
  end
  matches
end

# dd is a char-diff of strings a,b. return a codeunits-diff
function diffchar2code(a,b,dd)
  olda=oldb=astart=bstart=0
  map(dd)do (type,ar,br)
    astart=nextind(a,astart,ar.start-olda)
    aend=ar.stop<ar.start ? astart-1 : nextind(a,astart,ar.stop-ar.start)
    bstart=nextind(b,bstart,br.start-oldb)
    bend=br.stop<br.start ? bstart-1 : nextind(b,bstart,br.stop-br.start)
    olda=ar.start
    oldb=br.start
    (type,astart:aend,bstart:bend)
  end
end
  
# refines :differ area to a list of (:differ,arange,brange) better synchronizing
function area_diff(t,arange,brange;h_treshold=2000,info=println,options...)
  sa=prod(t[1][arange]);sb=prod(t[2][brange])
  if length(arange)<=1 && length(brange)<=1 return [(:differ,arange,brange)] end
##  log("arange=#{arange.inspect}=#{sa.inspect}\n")
##  log("brange=#{brange.inspect}=#{sb.inspect}\n")
  if max(length(sa),length(sb))<h_treshold
    dd=diff_report(collect(sa),collect(sb);options...,
    info=l->info("cmp $(arange.start)+$l"),
    sampling=100)
  else dd=diffh(collect(sa),collect(sb);options...,
    info=l->info("cmph $(arange.start)+$l"),
    sampling=10000)
  end
  dd=diffchar2code(sa,sb,dd)
  matches=align(sa,sb,dd)
##  log "match=#{match.inspect}\n"
  for i in eachindex(matches)
    matches[i]=(matches[i][1]+arange.start-1,
                matches[i][2]+brange.start-1,matches[i][3])
  end
##  log("matches=#{match.map{|a,b,n| "#{a}-#{b}:#{n}"}.join(",")}\n")
  res=filter(match_to_align(matches,arange,brange))do x
    length(string(x[2]))+length(string(x[3]))>0
  end
  res=weed_diffs(res;merge=false)
# werror("(:diff,$arange,$brange) refined to $res")
  res
## log(res.inspect+"\n");res
end

# variant  using less memory but less  precise. It find differences smaller
# than options.h_range and resynchronizes on options.sync_size equal items.
# a,b are strings
function diffh(a,b;info=print,sampling=100,sync_size=6,h_range=250,fuzzy=identity,options...)
  eq(x,y)=fuzzy(a[x+l[1]])==fuzzy(b[y+l[2]])
  exceed(i,side)=i+l[side]>length((a,b)[side])
  l=[0,0]; res=Tuple{Symbol,UnitRange,UnitRange}[]
  while true
    l[1]+=1;l[2]+=1
    if l[1]%sampling==0 info(l[1]) end
    if any(side->exceed(0,side),1:2) break end
    if eq(0,0) continue end
    for i in 1:h_range
      for side in 1:2
        other=3-side
        for k in sync_size-1:i
          if exceed(k,other) || exceed(i,side) continue end
          if !all(m->side==2 ? eq(k-m,i-m) : eq(i-m,k-m),0:sync_size-1)
            continue end
          if side==1 delta=[i-sync_size,k-sync_size]
          else delta=[k-sync_size,i-sync_size]
          end
          delta=max.(delta.+1,0)
          push!(res,(:differ,l[1]:l[1]+delta[1]-1,l[2]:l[2]+delta[2]-1))
          for side in 1:2 l[side]+=delta[side]+1 end
          @goto suite
        end
      end
      if all(side->exceed(i,side),1:2) @goto fin end
    end
    info("'h' lost sync at $(l[1]),$(l[2])\n")#if exceed h_range
    break
    @label suite
  end
  @label fin 
  delta=map(side->length((a,b)[side])-l[side],1:2)
  if delta[1]>=0 || delta[2]>=0 push!(res,(:differ,l[1]:l[1]+delta[1],l[2]:l[2]+delta[2])) end
  res1=Tuple{Symbol,UnitRange,UnitRange}[]
  for d in res 
    if !isempty(res1) 
      push!(res1,(:match,res1[end][2].stop+1:d[2].start-1,
                         res1[end][3].stop+1:d[3].start-1)) 
    elseif (d[2].start>1 || d[3].start>1)
      push!(res1,(:match,1:d[2].start-1,1:d[3].start-1))
    end
    push!(res1,d)
  end
  d=res1[end]
  if d[2].stop<length(a) || d[3].stop<length(b) 
    push!(res1,(:match,d[2].stop+1:length(a),d[3].stop+1:length(b)))
  end
  res1
end
