export Color, add, wadd

# Color representations
# Symbolic: [bright] fg on bg: black white green blue cyan red magenta yellow
# Dos:      blink-fg-bold-bg
# Curses:   COLOR_PAIR(8*fg+bg)|A_BOLD|A_NORMAL
# Ansi:     esc(bold?1:0)(blink?";5");4fg;3bg
module Color
using ..Curses
using OrderedCollections: OrderedDict
export add, mvadd, wadd, mvwadd

const COLORS=[COLOR_BLACK,COLOR_BLUE,COLOR_GREEN,COLOR_CYAN,
    COLOR_RED,COLOR_MAGENTA,COLOR_YELLOW,COLOR_WHITE]
atts::OrderedDict{Symbol,Int}=OrderedDict{Symbol,Int}()

function init(a::Pair{Symbol,String}...)
  for f in 0:7, b in 0:7
    if b+f!=0 init_pair(b*8+f,COLORS[f+1],COLORS[b+1]) end
  end
  for (n,c) in a
    att=lit_to_att(c)
    atts[n]=att
  end
end

function init(a::String...)
  for f in 0:7, b in 0:7
    if b+f!=0 init_pair(b*8+f,COLORS[f+1],COLORS[b+1]) end
  end
  cnt=0
  for c in a
    att=lit_to_att(c)
    atts[Symbol(cnt)]=att
    cnt+=1
  end
end

function lit_to_att(c)
  r=r"(bright)?\s*([a-z]*)\s*on\s*([a-z]*)"
  m=match(r,c)
  if isnothing(m) error("malformed color $c") end
  trad=Dict("black"=>COLOR_BLACK, "blue"=>COLOR_BLUE, "green"=>COLOR_GREEN,
	   "cyan"=>COLOR_CYAN, "red"=>COLOR_RED, "magenta"=>COLOR_MAGENTA,
	   "yellow"=>COLOR_YELLOW, "white"=>COLOR_WHITE)
  if !haskey(trad,m[2]) || !haskey(trad,m[3]) error("malformed color $c") end
  att=get_pair(trad[m[2]],trad[m[3]])
  if !isnothing(m[1]) att|=A_BOLD else att|=A_NORMAL end
  att
end

# foreground, background
get_pair(col1,col2)=COLOR_PAIR(get_dos(col1,col2))

# foreground, background
get_dos(col1,col2)=(findfirst(==(col2),COLORS)-1)*8+findfirst(==(col1),COLORS)-1

#  def Color.set_printa(*a) # needed in 1.8 hashes not ordered
#    @@printa=a
#  end
#
#  def Color.attributes
#    @@printa
#  end
#
#  def Color.method_missing(a)
#    res=@@atts[a]
#    raise "color attribute #{a} undefined " unless res
#    res
#  end
#

function get_att(s::Symbol)
  if !haskey(atts,s) error("$(atts) missing attribute $s") end
  atts[s]
end

function get_att(s::Integer)
  if !(s in 0:length(atts)-1) error("missing attribute no. $s") end
  atts[collect(keys(atts))[s+1]]
end

function dos_to_att(dos)
  res=COLOR_PAIR((dos&0x7)+div(dos&0x70,2))
  if (dos&0x08)!=0 res|=A_BOLD end
  if (dos&0x80)!=0 res|=A_BLINK end
  res
end

function dos_to_lit(dos)
  trad=["black","blue","green","cyan","red","magenta","yellow","white"]
  if (dos&0x08)!=0 res="bright " else res="" end
  res*trad[1+dos&0x7]*" on "*trad[1+(dos&0x70)>>4]
end

function dos_to_ansi(n)
  p=(0!=n&0x08 ? "1" : "0")
  if 0!=n&0x80 p*=";5" end
  p*";4"*string([0,4,2,6,1,5,3,7][1+n&0x7])*
    ";3"*string([0,4,2,6,1,5,3,7][1+(n&0x70)>>4])
end

#  def Color.ansi_to_dos(n)
#    v=n.split(";").map{|s| s.to_i}
#    a=0
#    v.each do |i|
#     case i
#       when 1,5 then a|=0x80
#       when 0 then a&=0x7f
#       when 30..37 then a|=[0,4,2,6,1,5,3,7][i-30]*16
#       when 40..47 then a|=[0,4,2,6,1,5,3,7][i-40]
#       else raise "unexpected case"
#     end
#    end
#    a
#  end
#
function att_to_dos(c)
  for i in 0:255
    if c==dos_to_att(i) return i end
  end
  error("rate")
end

#  def Color.dump
#    res=[]
#    @@atts.each{|k,v|
#     res<<[k,Color.dos_to_lit(Color.att_to_dos(@@atts[k]))]}
#    res
#  end

function inspect(w::Ptr{WINDOW})
 "#<Window:$(getmaxy(w)),$(getmaxx(w)),$(getbegy(w)),$(getbegx(w))>"
end

# wadd String, Int/char, Symbol, 
function wadd(w::Ptr{WINDOW},a...)
#   log "add[#{curx},#{cury}](#{a.inspect})#{self.inspect}\n"
  for s in a
    if s isa AbstractString waddstr(w,filter(!=('\0'),s))
    elseif s isa Integer waddch(w,s)
    elseif s isa Vector 
#     wattron(w,Color.get_att(s[1]))
      wattron(w,s[1])
      for u in s[2:end] wadd(w,u) end
#     wattroff(w,Color.get_att(s[1]))
      wattroff(w,s[1])
    elseif s isa Symbol wattron(w,Color.get_att(s))
    end
  end
end
   
add(a...)=wadd(stdscr,a...)
mvwadd(w::Ptr{WINDOW},y::Integer,x::Integer,a...)=(wmove(w,y,x);wadd(w,a...))
mvadd(y::Integer,x::Integer,a...)=(wmove(stdscr,y,x);add(a...))
end

using .Color
