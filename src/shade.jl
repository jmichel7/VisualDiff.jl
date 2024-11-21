export Shadepop, restore, background

function background()
  add(stdscr,:BG)
  for i in 0:getmaxy(stdscr)
    wmove(stdscr,i,0)
    for j in 0:getmaxx(stdscr) add(stdscr,ACS_(:CKBOARD)) end
  end
end

function frame(w,top,left,height,width)
  mvadd(w,top,left,ACS_(:ULCORNER));whline(w,0,width-2);
  mvadd(w,top,left+width-1,ACS_(:URCORNER))
  mvadd(w,top+height-1,left,ACS_(:LLCORNER));whline(w,0,width-2);
  mvadd(w,top+height-1,left+width-1,ACS_(:LRCORNER))
  mvwvline(w,top+1,left+width-1,0,height-2)
  mvwvline(w,top+1,left,0,height-2)
end

function shaded_frame(w,y,x,height,width,att=Color.get_att(:BOX))
  wattron(w,att&A_ATTRIBUTES)
  frame(w,y,x,height,width)
  for i in y+1:y+height-2
    wmove(w,i,x+1);waddstr(w," "^(width-2))
  end
  scrollok(w,false)
  shade_color=Color.get_pair(COLOR_WHITE,COLOR_BLACK)|A_NORMAL
  shade(r,c)=if c<COLS() && r<LINES()
    wmove(w,r,c)
    waddch(w,shade_color|(winch(w)&~(A_COLOR|A_NORMAL|A_BOLD))) 
  end
  for i in x+1:x+width shade(y+height,i) end
  for i in y+1:y+height shade(i,width+x) end
end

function shaded_frame(w;x=0,y=0,height=getmaxy(w),width=getmaxx(w))
  shaded_frame(w,y,x,height,width,Color.get_att(:BOX))
end

struct Shadepop
  save::Ptr{WINDOW}
  x::Int
  y::Int
  aspect::Int
  function Shadepop(y,x,height,width;att=Color.get_att(:BOX))
    cx=getcurx(stdscr);cy=getcury(stdscr);aspect=curs_set(0)
    save=newwin(height+1,width+1,y,x)
    overwrite(stdscr,save)
    shaded_frame(stdscr,y,x,height,width,att)
    new(save,Int(cx),Int(cy),Int(aspect))
  end
end

function restore(w::Shadepop)
  overwrite(w.save,stdscr)
  wmove(stdscr,w.y,w.x);curs_set(w.aspect)
  delwin(w.save)
end

struct Savewin
  save::Ptr{WINDOW}
  win::Ptr{WINDOW}
end

function Savewin(win)
  save=newwin(getmaxy(win),getmaxx(win),getbegy(win),getbegx(win))
  overwrite(win,save)
  Savewin(save,win)
end

function restore(w::Savewin)
  overwrite(w.save,w.win)
  delwin(w.save)
end
