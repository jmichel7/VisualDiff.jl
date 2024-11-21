using Vdiff
using Vdiff.Curses
using Dates

function nbK(n)
  k=1024
  if n<=9k lpad(n,5)*" "
  elseif n<9k^2 lpad(div(n,k),5)*"K"
  elseif n<9k^3 lpad(div(n,k^2),5)*"M"
  else lpad(div(n,k^3),5)*"G"
  end
end

function ltrunc(w,s::String,l)
  if length(s)<=l wprintw(w,rpad(s,l))
  else add(w,first(s,l-1));add(w,:HL,"…")
  end
end

function rls(dir)
  initscr2()
  cbreak()
  noecho() 
  keypad(stdscr,true)
# mousemask(BUTTON1_PRESSED|BUTTON1_RELEASED|BUTTON1_CLICKED)
  Color.init(:NORM=>"black on white",:HL=>"bright red on white", 
             :BAR=>"bright yellow on red",:BOX=> "blue on white")
  s=Scroll_list(stdscr,map(f->(f,stat(joinpath(dir,f))),readdir(dir));
    rows=div(LINES(),2),cols=COLS()-2-iseven(COLS()),begx=1,begy=1,nbcols=2)
  add_scrollbar(s)
  save=Shadepop(s.begx-1,s.begy-1,2+s.rows,2+s.cols)
  p=Pick_list(s)
  s.showentry=function(s,i)
    att=i==p.sel_bar ? :BAR : :NORM
    add(s.win,att)
    if 0<div(i-s.first,s.rows) add(s.win,ACS_(:VLINE)) end
    if i<=length(s)
      name,ss=s.list[i]
      ltrunc(s.win,name,s.width-23)
      add(s.win,:BOX,ACS_(:VLINE),att,nbK(ss.size),:BOX,ACS_(:VLINE))
      add(s.win,att,Dates.format(unix2datetime(ss.mtime),"dd u yy HH:mm"))
    else wprintw(s.win," "^s.width)
    end
    wmove(s.win;x=getcurx(s.win)-1) # unneeded if cursor invisible
  end
  show(p)
  s.on_scroll(s)
help="""
zrertyt zdrt zytdyd zrtd zrtd z deytzd ytredzytredzyt
dhdgjhhhqdskjhcvlkjqds vlkqjh lkjdsqhvlkqhd vlkjqshd lvkh
"""
  c=getch()
  while true
#   dump(c.to_s)
#   when KEY_MOUSE
#     next if c=l.process_event(getmouse) and c!=-1
    if c in (Int('q'),Int('Q')) break
    elseif c==Int('h') whelp(help,"about nothing")
    elseif !do_key(p,c) beep() 
    end
    c=getch()
  end
  restore(save)
  endwin()
end
