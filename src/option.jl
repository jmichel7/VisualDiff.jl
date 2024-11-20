# This class behaves like a hash. Can use like opt.recur
# In addition each field is decorated by a description and possibly a 'level'
# which is an indicator of what is affected by this option.
struct Options<: AbstractDict{Symbol,Any}
  h::Dict{Symbol,Dict{Symbol}}
end

Base.getproperty(o::Options,s::Symbol)=s==:h ? getfield(o,:h) : o.h[s][:value]
Base.haskey(o::Options,s::Symbol)=haskey(o.h,s)

function Base.setproperty!(o::Options,k::Symbol,v)
  if haskey(o.h,k) o.h[k][:value]=v
  else o.h[k]=Dict(:value=>v)
  end
  o
end

function Base.iterate(o::Options)
  s=iterate(o.h)
  if !isnothing(s)
    v,state=s
    v[1]=>v[2][:value],state
  end
end

function Base.iterate(o::Options,state)
  s=iterate(o.h,state)
  if !isnothing(s)
    v,state=s
    v[1]=>v[2][:value],state
  end
end

Base.length(o::Options)=length(o.h)

function Base.copy(o::Options)
  h=copy(o.h)
  for (k,v) in h h[k]=copy(h[k]) end
  Options(h)
end

function Base.:(==)(o1::Options,o2::Options)
  o1.h==o2.h
end

#changes between o and other
function max_level_changed(o::Options,other::Options)
  level=0
  for k in keys(o.h)
    if o.h[k]==other.h[k] continue end
    level=max(level,haskey(o.h[k],:level) ? o.h[k][:level] : 0)
  end
  level
end

#  def initialize(h)
#    super
#    merge!(h)
#  end
#
#  def to_h
#    h=Hash.new
#    keys.each{|k| h[k]=self[k][:value]}
#    h
#  end
#
#  def method_missing(n,b=nil)
#    if b!=nil then self[n.to_s.chop.intern][:value]=b end
#    self[n][:value]
#  end

function toggle(opt,n)
  opt.h[n][:value]=!opt.h[n][:value]
end

function save(o::Options,name)
  p=""
  for (k,v) in colors
    p*="color_$(colors[k][:name])="
    p*="$(Color.dos_to_lit(Color.att_to_dos(Color.get_att(k))))\n"
    p*="#  color of $(colors[k][:desc])\n"
  end
  for k in [:ignore_endings,:ignore_blkseq,:ignore_blklin,:ignore_case,
   :align,:onlylength,:length_and_timestamp,:editor,:edit2,:tabsize,
   :side_by_side,:by_par]
   p*="$(opt.h[k][:name])=$(opt.h[k][:value])\n#  "
   if opt.h[k][:value] isa Bool p*="If true, " end
   p*="$(opt.h[k][:shortdesc])\n"
  end
  open(expanduser(name),"w")do  f 
    print(f,p)
  end
  werror("options succesfully saved to $name")
end
#end

function read_options(n)
  f=nothing
  try
    f=open(expanduser(n),"r")
  catch e 
    return
  end
  for l in eachline(f)
    if l[1]=='#' continue end
    m=match(r"color_(.*)=(.*)",l)
    if !isnothing(m)
      for (k,v) in colors
        if v[:name]==m[1] Color.atts[k]=Color.lit_to_att(m[2]) end
      end
      continue
    end
    m=match(r"(.*)=(.*)",l)
    if !isnothing(m)
      for (k,v) in opt.h
       if haskey(v,:name) && v[:name]==m[1]
          if v[:value] isa String v[:value]=m[2]
          elseif v[:value] isa Bool
            if m[2]=="false" v[:value]=false
            elseif m[2]=="true" v[:value]=true
            else error("$n: could not parse1 $l")
            end
          elseif v[:value] isa Integer 
            v[:value]=parse(Int,m[2])
          else error("$n: could not parse2 $l")
 	  end
        end
      end
      continue
    end
    error("$n: could not parse3 $l")
  end
  close(f)
end

OK=0
#RECOMPUTE_SCREEN=1
RECOMPUTE_DIFFS=2
RECOMPUTE=3

opt=Options(Dict{Symbol,Dict{Symbol,Any}}())
