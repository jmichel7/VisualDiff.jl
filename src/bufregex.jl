# find and decorate regular expression in file
struct Decor
  offset::Int
  att::Symbol
end

Base.dump(d::Decor)="#$offset#$(att==:LEQ ? '=' : '#')"

function shift(l::Vector{Decor},n)
  if n==0 return l end
  i=1
  while i<=length(l) && l[i].offset<n i+=1 end
  if i>1 && (i>length(l) || l[i].offset>n) res=[Decor(1,l[i-1].att)] 
  else res=Decor[] end
  vcat(res,map(d->Decor(d.offset-n,d.att),l[i:end]))
end

# usage: new(buf) buf=array of strings
#        find_re(forward,l) find starting from l and forward
#        get(lnum) decors on lnum 
mutable struct Regex_in_buf
  forward::Bool
  matchline::Int
  cur_match::Int
  re::Regex
  matches::Vector{RegexMatch}
  Regex_in_buf()=new(true,-1)
end

RE_COLORS=[:NORM,:BAR,:HL,:MENU,:MTEXT,:LDIFF]

function Base.get(r::Regex_in_buf,lnum)
  if lnum!=r.matchline return Decor[] end
  if isempty(r.matches) || !(r.cur_match in eachindex(r.matches)) 
    return Decor[]
  end
  mm=r.matches[r.cur_match]
  marks=[(mm.offset,1),(mm.offset+length(mm.match),-1)]
  for i in eachindex(mm.captures)
    push!(marks,(mm.offsets[i], 1))
    push!(marks,(mm.offsets[i]+length(mm.captures[i]), -1))
  end
  att=1
  map(((p,t),)->(att+=t;Decor(p, RE_COLORS[att])),sort(marks))
end

Base.dump(r::Regex_in_buf)=
"<$(r.re)$(r.forward ? "f" : "b") $(r.matchline):$(isdefined(r,:matches) ? length(r.matches) : 0)>"

function find_re(r,b,forward,l)
  direction=(forward==r.forward) ? 1 : -1
  if l==r.matchline
    r.cur_match+=direction
    if r.cur_match in 1:length(r.matches) return true end
    empty!(r.matches)
    l+=direction
  end
  while l in 1:length(b)
    ln=b[l]
    r.matches=collect(eachmatch(r.re,ln))
    if !isempty(r.matches)
      if direction==1 r.cur_match=1
      else r.cur_match=length(r.matches)
      end
      r.matchline=l
      return true
    end
    l+=direction
  end
  werror("pattern $(r.re) not found")
  false
end
