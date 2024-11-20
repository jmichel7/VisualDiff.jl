module Curses
  include("export.jl")
  export stdscr,initscr2, NCurses
  stdscr::Ptr{WINDOW}=0
  
# actions needed for a fully-functioning curses
function initscr2()
  NCurses.load_ncurses()
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
