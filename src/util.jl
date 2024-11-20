function center(w::Ptr{WINDOW},text::String,width=getmaxx(w)-getcurx(w);rtrunc=false)
  x=getcurx(w)
  l=length(text)
  if l>width text=rtrunc ? text[1:width-1] : text[l-width+1:l]
    if rtrunc add(stdscr,:NORM,text,:BOX,"»")
    else add(stdscr,:BOX,"«",:NORM,text)
    end
  else wmove(w,x=x+div(width-l,2))
    waddstr(w,text)
  end
  wmove(w,x=x+width)
end

function printnormedpath(y,x,name,lg)
  wmove(stdscr,y,x)
  center(stdscr,abspath(name),lg)
end

function cpad(text::String,width,rtrunc=false)
  l=length(text)
  if l>width rtrunc ? text[1:width] : text[l-width:l]
  else " "^div(width-l,2)*text*" "^div(1+width-l,2)
  end
end

function werror(s)
  w=max(length(s),34)
  l=div(w,COLS()-3)
  w=min(w,COLS()-3)
  height=3+l
  yoff=div(LINES(),2)-1
  xoff=div(COLS()-w-2,2)
  save=Shadepop(yoff,xoff,height+1,w+2,Color.get_att(:BOX))
  curs_set(0)
  beep()
  mvadd(stdscr,yoff,xoff+1,:BOX)
  center(stdscr,"Warning",w)
  mvadd(stdscr,yoff+height-1,xoff+1,:BAR)
  center(stdscr,"ok",w)
  mvadd(stdscr,yoff+1,xoff+1,:NORM)
  if l>0
    for i in 0:l
      mvadd(stdscr,yoff+1+i,xoff+1,s[w*i+1:min(w*(i+1),length(s))])
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
  for m in eachmatch(r"(?!\\)\{([A-Z]*) ([^}]*)\}",s)
    add(w,s[offset:prevind(s,m.offset)],Symbol(m[1]),m[2],:NORM)
    offset=m.offset+ncodeunits(m.match)
  end
  if offset<=length(s) add(w,s[offset:end]) end
end

# reverse part sx:ex of line y
function reverse_area(y,sx=0,ex=getmaxx(stdscr)-1)
  cx=getcurx(stdscr)
  cy=getcury(stdscr)
  wmove(stdscr,y,sx)
  for i in sx:ex waddch(stdscr,xor(winch(stdscr),A_REVERSE)) end
  wmove(stdscr,cy,cx)
end

module Indexeds
export Indexed, prev, next, current, change
mutable struct Indexed{T}
  v::Vector{T}
  pos::Int
end

Base.iterate(v::Indexed,a...)=iterate(v.v,a...)
Base.length(v::Indexed)=length(v.v)

Indexed(v::AbstractVector)=Indexed(v,0)

function change(v::Indexed,i)
  if i==v.pos return end
  if v.pos!=0 Main.leave(current(v)) end
  v.pos=i
  if v.pos!=0 Main.Menus.enter(current(v)) end
end

next(v::Indexed)=change(v,v.pos<length(v) ? v.pos+1 : 1)
prev(v::Indexed)=change(v,v.pos>1 ? v.pos-1 : length(v))
current(v::Indexed)=v.v[v.pos]
end #----------------- of Indexed --------------------

function info(start,fin,msg...)
  x=getcurx(stdscr);y=getcury(stdscr)
  mvadd(stdscr,LINES()-1,start,msg...)
  clrtocol(stdscr,fin==COLS()-1 ? fin-1 : fin)
  refresh()
  wmove(stdscr,y,x)
end

infohint=function(s)
  info(5,COLS()-1,:MKEY,"| ",:MTEXT,s[max(length(s)-COLS()+7,1):end])
end
