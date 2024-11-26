module Curses
  const TUI=false
  if TUI
    using TextUserInterfaces:TextUserInterfaces
    const NCurses=TextUserInterfaces.NCurses
  else
    using Ncurses:Ncurses
    const NCurses=Ncurses
    KEY_ALT(c::Char)=0o641+c-'A'; export KEY_ALT
    KEY_CTRL(c::Char)=UInt8(c-'A'+1); export KEY_CTRL
    KEY_F(i)=0o410+i; export KEY_F
    const acs_map_dict = Dict{Symbol, Int}(
    :ULCORNER => Int('l'),
    :LLCORNER => Int('m'),
    :URCORNER => Int('k'),
    :LRCORNER => Int('j'),
    :LTEE     => Int('t'),
    :RTEE     => Int('u'),
    :BTEE     => Int('v'),
    :TTEE     => Int('w'),
    :HLINE    => Int('q'),
    :VLINE    => Int('x'),
    :PLUS     => Int('n'),
    :S1       => Int('o'),
    :S9       => Int('s'),
    :DIAMOND  => Int('`'),
    :CKBOARD  => Int('a'),
    :DEGREE   => Int('f'),
    :PLMINUS  => Int('g'),
    :BULLET   => Int('~'),
    :LARROW   => Int(','),
    :RARROW   => Int('+'),
    :DARROW   => Int('.'),
    :UARROW   => Int('-'),
    :BOARD    => Int('h'),
    :LANTERN  => Int('i'),
    :BLOCK    => Int('0'),
    :S3       => Int('p'),
    :S7       => Int('r'),
    :LEQUAL   => Int('y'),
    :GEQUAL   => Int('z'),
    :PI       => Int('{'),
    :NEQUAL   => Int('|'),
    :STERLING => Int('}'),
)
#   ACS_(s::Symbol)=NCurses.NCURSES_ACS(UInt8(acs_map_dict[s]))
    function ACS_(s::Symbol)
        acs_map = cglobal((:acs_map,Ncurses.libncurses), Cuint)
        acs_map_arr = unsafe_wrap(Array, acs_map, 128)
        acs_map_arr[acs_map_dict[s]+1]
    end

    COLS()=getmaxx(stdscr)
    LINES()=getmaxy(stdscr)
    refresh()=wrefresh(stdscr)
    mutable struct MEVENT
      id::Cshort
      x::Cint
      y::Cint
      z::Cint
      bstate::Culong
    end
    NCurses.mousemask(x::Integer)=mousemask(UInt(x),Ptr{UInt}(C_NULL))
    function NCurses.getmouse() 
      me=MEVENT(1,0,0,0,0)
      getmouse(Ptr{MEVENT}(pointer_from_objref(me)))
      me
    end
    wattroff(w,a)=NCurses.wattr_off(w,a,Ptr{UInt}(C_NULL))
    wattron(w,a)=NCurses.wattr_on(w,a,Ptr{UInt}(C_NULL))
    attron(a)=wattron(stdscr,a)
    attroff(a)=wattroff(stdscr,a)
    mvwvline(w,y,x,ch,n)=(wmove(w,y,x);wvline(w,ch,n))
    mvwhline(w,y,x,ch,n)=(wmove(w,y,x);whline(w,ch,n))
    mvhline(y,x,ch,n)=(wmove(stdscr,y,x);whline(stdscr,ch,n))
    vline(ch,n)=wvline(stdscr,ch,n)
    hline(ch,n)=whline(stdscr,ch,n)
    addstr(s)=waddstr(stdscr,s)
    mvwaddstr(w,y,x,s)=(wmove(w,y,x),waddstr(w,s))
    clear()=wclear(stdscr)
    clrtoeol()=wclrtoeol(stdscr)
    bkgd(a)=wbkgd(stdscr,a)
    const KEY_CTRL_PPAGE=0o1064
    const KEY_CTRL_NPAGE=0o1057
    const KEY_CTRL_RIGHT=0o1071
    const KEY_CTRL_LEFT=0o1052
  end
  include("export.jl")
  export stdscr,initscr2, NCurses
  stdscr::Ptr{WINDOW}=0
  
# actions needed for a fully-functioning curses
function initscr2()
if TUI
  NCurses.load_ncurses()
end
  global stdscr=initscr()
  start_color()
  mousemask(ALL_MOUSE_EVENTS|REPORT_MOUSE_POSITION)
  noecho()
  halfdelay(1)
  keypad(stdscr,true)
end

leftchar::Int=0
function wgetch(w::Ptr{WINDOW})
  if !iszero(Curses.leftchar)
    c=Curses.leftchar
    Curses.leftchar=0
    return c
  end
  while true
    c=NCurses.wgetch(w)
    if c>0 break end
  end
  if c!=0x1b return c end
  n=NCurses.wgetch(w)
  if n<0 return c end
  if Char(n) in 'a':'z' return KEY_ALT(Char(n)-'a'+'A') end
  Curses.leftchar=n
  return 0x1b
end
getch()=wgetch(stdscr)
export getch, wgetch

end
using .Curses

if Curses.TUI
NCurses.wmove(w,i::T1,j::T2) where{T1,T2}=wmove(w,Int(i),Int(j))
end
NCurses.wmove(w;y=getcury(w),x=getcurx(w))=wmove(w,y,x)
