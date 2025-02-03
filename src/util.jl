"""
`@ExtObj struct...`

An  `ExtObj` is a  kind of object  where properties are  computed on demand
when  asked for. So it has fixed  fields but can dynamically have new ones.
Accessing  fixed  fields  is  as  efficient  as  a  field  of any `struct`.
Accessing a dynamic field takes the time of a `Dict` lookup.

```julia_repl
julia> @ExtObj struct Foo
       a::Int
       end

julia> s=Foo(1,Dict{Symbol,Any}())
Foo(1, Dict{Symbol, Any}())

julia> s.a
1

julia> haskey(s,:b)
false

julia> s.b="hello"
"hello"

julia> haskey(s,:b)
true

julia> s.b
"hello"
```
The dynamic fields are stored in the field `.prop` of `G`, which is of type
`Dict{Symbol,  Any}()`.  This  explains  the  extra  argument needed in the
constructor.  The name is because it mimics a GAP record, but perhaps there
could be a better name. The methods the `ExtObj` inherits from its field
`prop` are `haskey`, `getindex`, `delete!` and `get!`.
"""
macro ExtObj(e)
  push!(e.args[3].args,:(prop::Dict{Symbol,Any}))
  if e.args[2] isa Symbol T=e.args[2]
  elseif e.args[2].args[1] isa Symbol T=e.args[2].args[1]
  else T=e.args[2].args[1].args[1]
  end
  esc(Expr(:block,
   e,
   :(Base.getproperty(o::$T,s::Symbol)=hasfield($T,s) ? getfield(o,s) :
         getfield(o,:prop)[s]),
   :(Base.setproperty!(o::$T,s::Symbol,v)=hasfield($T,s) ? setfield!(o,s,v) :
         getfield(o,:prop)[s]=v),
   :(Base.haskey(o::$T,s::Symbol)=haskey(getfield(o,:prop),s)),
   :(Base.getindex(o::$T,s::Symbol)=getindex(getfield(o,:prop),s)),
   :(Base.propertynames(o::$T)=(fieldnames($T)...,Tuple(keys(getfield(o,:prop)))...)),
   :(Base.delete!(o::$T,s::Symbol)=delete!(getfield(o,:prop),s)),
   :(Base.get!(f::Function,o::$T,s::Symbol)=get!(f,getfield(o,:prop),s))))
end

NCurses.wmove(w;y=getcury(w),x=getcurx(w))=wmove(w,y,x)

function wclrtocol(w::Ptr{WINDOW},col)
  cx=getcurx(w)
  waddstr(w," "^max(0,col-cx+1))
  wmove(w;x=cx)
end
clrtocol(col)=wclrtocol(stdscr,col)

# e.bstate is among events in x
among(e::MEVENT,x::Integer)=iszero(e.bstate & ~UInt(x))
  
function Dump(s...)
  x=getcurx(stdscr)
  y=getcury(stdscr)
  mvadd(LINES()-16,1,:NORM,s...)
  refresh()
  wmove(stdscr,y,x)
end

Base.dump(w::Ptr{WINDOW})="win($(getbegy(w)),$(getbegx(w))):($(getmaxy(w)),$(getmaxx(w)))"

function exec(com,dir=".")
  cd(dir)do
    def_prog_mode()
    endwin()
    if com==nothing com=ENV["SHELL"] end
    code=success(run(eval(Meta.parse("`"*com*"`"))))
    reset_prog_mode()
    refresh()
    if !code werror("failed executing command") end
  end
end

"s[1:firstscreen(s,n)] is beginning of s until textwidth exceeds n"
function firstscreen(s::String,n)
  w=0
  res=0
  for c in s
    l=textwidth(c)
    if w+l>n break  end
    w+=l
    res=nextind(s,res,1)
  end
  res
end

"s[lastscreen(s,n):end] is end of s until textwidth exceeds n"
function lastscreen(s::String,n)
  w=0
  res=ncodeunits(s)+1
  for c in reverse(s)
    l=textwidth(c)
    if w+l>n break  end
    w+=l
    res=prevind(s,res,1)
  end
  res
end

function center(w::Ptr{WINDOW},text::String,width=getmaxx(w)-getcurx(w);rtrunc=false)
  x=getcurx(w)
  l=textwidth(text)
  if l>width text=rtrunc ? text[1:firstscreen(text,width-1)] : 
                text[lastscreen(text,width-1):end]
    if rtrunc add(:NORM,text,:BOX,"»")
    else add(:BOX,"«",:NORM,text)
    end
  else wmove(w,x=x+div(width-l,2))
    add(w,:NORM,text)
  end
  wmove(w,x=x+width)
end

function printnormedpath(y,x,name,lg)
  wmove(stdscr,y,x)
  center(stdscr,abspath(name),lg)
end

"""
`cpad(text::String,width;rtrunc=false)`

center `text` on width `width`. When `text` too wide by default keep start
of `text`; if `rtrunc` keep end of `text`.
"""
function cpad(text::String,width;rtrunc=false)
  l=textwidth(text)
  if l>width rtrunc ? text[lastscreen(text,width):end] :
                      text[1:firstscreen(text,width)]
  else " "^div(width-l,2)*text*" "^div(1+width-l,2)
  end
end

function werror(s)
  s=replace(s,r"\n"=>"\\n")
  w=max(length(s),34)
  l=div(w,COLS()-3)
  w=min(w,COLS()-3)
  height=3+l
  yoff=div(LINES(),2)-1
  xoff=div(COLS()-w-2,2)
  save=Shadepop(yoff,xoff,height+1,w+2)
  curs_set(0)
  beep()
  mvadd(yoff,xoff+1,:BOX)
  center(stdscr,"Warning",w)
  mvadd(yoff+height-1,xoff+1,:BAR)
  center(stdscr,"ok",w)
  mvadd(yoff+1,xoff+1,:NORM)
  if l>0
    for i in 0:l
      mvadd(yoff+1+i,xoff+1,s[w*i+1:min(w*(i+1),length(s))])
    end
  else
    addstr(s)
  end
# mousemask(BUTTON1_CLICKED)
  getch()
  restore(save)
end

"""
for each "{ATT x}" in s where `ATT` is one of my color attributes and `x` has
no '}' output to `w` the string `x` with attribute `ATT`.
"""
function printa(w::Ptr{WINDOW},s)
  offset=1
  for m in eachmatch(r"(?!\\)\{([A-Z]*)\s([^}]*)\}"s,s)
    wadd(w,s[offset:prevind(s,m.offset)],Symbol(m[1]),m[2],:NORM)
    offset=m.offset+ncodeunits(m.match)
  end
  if offset<=length(s) wadd(w,s[offset:end]) end
end

" reverse colors in part sx:ex of line y"
function reverse_area(y,sx=0,ex=getmaxx(stdscr)-1)
  cx=getcurx(stdscr)
  cy=getcury(stdscr)
  wmove(stdscr,y,sx)
  for i in sx:ex waddch(stdscr,xor(winch(stdscr),A_REVERSE)) end
  wmove(stdscr,cy,cx)
end

function info(start,fin,msg...)
  x=getcurx(stdscr);y=getcury(stdscr)
  mvadd(LINES()-1,start,msg...)
  clrtocol(fin==COLS()-1 ? fin-1 : fin)
  refresh()
  wmove(stdscr,y,x)
end

infohint=function(s)
  info(5,COLS()-1,:MKEY,"| ",:MTEXT,s[lastscreen(s,COLS()-7):end])
end
