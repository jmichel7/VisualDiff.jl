module Curses
  using Reexport
  @reexport using TextUserInterfaces.NCurses
  using TextUserInterfaces:TextUserInterfaces
  export stdscr,initscr2, NCurses
  include("export.jl")
  stdscr::Ptr{WINDOW}=0
  
# actions needed for a fully-functioning curses
function initscr2()
  load_ncurses()
  global stdscr=initscr()
  start_color()
  mousemask(ALL_MOUSE_EVENTS|REPORT_MOUSE_POSITION)
  noecho()
  halfdelay(1)
  keypad(stdscr,true)
  stdscr
end

leftchar::Int=0
function getch()
  if !iszero(Curses.leftchar)
    c=Curses.leftchar
    Curses.leftchar=0
    return c
  end
  while true
    c=NCurses.getch()
    if c>0 break end
  end
  if c!=0x1b return c end
  n=NCurses.getch()
  if n<0 return c end
  if Char(n) in 'a':'z' return KEY_ALT(Char(n)-'a'+'A') end
  Curses.leftchar=n
  return 0x1b
end
export getch

end
using .Curses

NCurses.wmove(w,i::T1,j::T2) where{T1,T2}=wmove(w,Int(i),Int(j))
NCurses.wmove(w;y=getcury(w),x=getcurx(w))=wmove(w,y,x)

function clrtocol(w::Ptr{WINDOW},col)
  cx=getcurx(w)
  waddstr(w," "^max(0,col-cx+1))
  wmove(w;x=cx)
end

# e.bstate is among events in x
among(e::MEVENT,x::Integer)=iszero(e.bstate & ~UInt(x))
  
function Dump(s...)
  x=getcurx(stdscr)
  y=getcury(stdscr)
  mvadd(stdscr,LINES()-16,1,:NORM,s...)
  refresh()
  wmove(stdscr,y,x)
end

Base.dump(w::Ptr{WINDOW})=addstr("<$(getbegy(w)),$(getbegx(w)):$(getmaxy(w)),$(getmaxx(w))>")
includet("Color.jl")
includet("button.jl")
includet("shade.jl")

function exec(com,dir=".")
  cd(dir)do
#   delete the_screen if com==nothing
    def_prog_mode()
    endwin()
    if com==nothing com=ENV["SHELL"] end
    code=success(run(eval(Meta.parse("`"*com*"`"))))
  # the_screen=new save_screen if com==nothing
    reset_prog_mode()
  # efns(WARNING_,diag) if(diag)
    refresh()
    if !code werror("failed executing command") end
  end
end

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
include("ok.jl")
include("about.jl")
include("scrolist.jl")
include("util.jl")
include("whelp.jl")
include("scrolbar.jl")
include("filedesc.jl")
include("pick.jl")
include("option.jl")
include("attprint.jl")
include("colormenu.jl")
include("par.jl")
include("bufregex.jl")
include("field.jl")
include("editbox.jl")
include("Menus.jl")
include("browse.jl")
include("cputil.jl")
include("optmenu.jl")
include("dirpick.jl")
include("diffhs.jl")
include("vdirdiff.jl")
include("vdiff.jl")
