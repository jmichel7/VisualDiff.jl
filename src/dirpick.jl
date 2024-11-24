# browse a directory
mutable struct Dir_pick
  p::Pick_list
  curdir::String
  tabskip::Int
  tmwidth::Int
  szwidth::Int
  namewidth::Int
  maxwidth::Int
  offset::Int
  sort::Char
  sort_up::Bool
end

Base.getindex(d::Dir_pick,pos)=d.p.s.list[pos]

current(d::Dir_pick)=d.p.s.list[d.p.sel_bar]

curname(d::Dir_pick)=joinpath(d.curdir,current(d).filename)

function Dir_pick(curdir)
  list=sort!(map(f->Filedesc(joinpath(curdir,f)),readdir(curdir)))
  maxwidth=maximum(map(s->length(s.filename),list),init=0)
  cols=min(COLS()-4,37+max(12,maxwidth))
  s=Scroll_list(stdscr,list;rows=LINES()-5,cols,begy=2,begx=div(COLS()-cols,2))
  p=Pick_list(s)
  d=Dir_pick(p,curdir,1,18,9,cols-35,maxwidth,0,'N',true)
  d.p.s.showentry=function(s,pos)
    f=pos>length(s.list) ? nothing : s.list[pos]
    add(pos==p.sel_bar ? :BAR : :NORM," "^d.tabskip)
    add(printfname(f,d.namewidth,d.offset)...)
    add(:BOX," "^d.tabskip,ACS_(:VLINE)," "^d.tabskip)
    add(pos==p.sel_bar ? :BAR : :NORM)
    add(isnothing(f) ? " "^d.szwidth : printsz(f.stat,d.szwidth))
    add(:BOX," "^d.tabskip,ACS_(:VLINE)," "^d.tabskip)
    add(pos==p.sel_bar ? :BAR : :NORM)
    add(isnothing(f) ? " "^d.tmwidth : printtm(f.stat,d.tmwidth))
  end
  d
end

global dmenu::Menu

function initdmenu(d::Dir_pick)
  global dmenu
  a=d.p.s.begx+2*d.tabskip+1
  b=a+d.namewidth+d.szwidth+4*d.tabskip+6
  if !isdefined(Main,:dmenu) 
    dmenu=Menu(infohint)
    wmove(stdscr,0,0)
    add(dmenu," &File ",
      ["&Delete\tDel,d",'d',"Delete current file"],
      ["Bro&wse\tF3",KEY_F(3),"Browse current file"],
      "-",
      #SHELLMENU,
      ["E&xit screen\tEsc",0x1b,"Exit current screen"])
    add(dmenu," &Options ",COLORMENU,SAVEOPTMENU)
    add(dmenu,HELPMENU...,ABOUTMENU)
    wmove(stdscr,d.p.s.begy+d.p.s.rows,a)
    add(dmenu,"&Name",KEY_ALT('N'))
    add(dmenu,".&Ext",KEY_ALT('E'))
    wmove(stdscr,x=a+d.namewidth+4)
    add(dmenu,"&Size",KEY_ALT('S'))
    wmove(stdscr,x=b);add(dmenu,"&Time",KEY_ALT('T'))
  else
# set the Size, Time, Name Ext indicators in their proper column
    Menus.setx(dmenu.heads.v[4],a)
    Menus.setx(dmenu.heads.v[5],a+5)
    Menus.setx(dmenu.heads.v[6],a+d.namewidth+4)
    Menus.setx(dmenu.heads.v[7],b+1)
  end
  Curses.refresh(dmenu)
end

function update_sort(d::Dir_pick,c::Char)
  if d.sort==c d.sort_up=!d.sort_up else d.sort_up=true end
  d.sort=c
  if isempty(d.p.s.list) return end
  cf=d.p.s.list[d.p.sel_bar].filename
  function by(sortp,f::Filedesc)
   (isdir(f.filename),
    if sortp=='N' f.filename
    elseif sortp=='E' _,e=splitext(f.filename); e
    elseif sortp=='S' f.stat.size
    elseif sortp=='T' f.stat.mtime
    end)
  end
  sort!(d.p.s.list,by=f->by(d.sort,f),rev=!d.sort_up)
  d.p.sel_bar=findfirst(i->d.p.s.list[i].filename==cf,eachindex(d.p.s.list))
  sdecor(s)=add(:HL,s ? ACS_(:DARROW) : ACS_(:UARROW))
  sdecor()=add(:BOX,ACS_(:HLINE))
  s=d.p.s
  a=s.begx+2*d.tabskip
  b=a+d.namewidth+d.szwidth+2*d.tabskip
  add(:BOX)
  wmove(stdscr,s.begy+s.rows,a)
  if d.sort=='N' sdecor(d.sort_up) else sdecor() end
  wmove(stdscr,s.begy+s.rows,a+11)
  if d.sort=='E' sdecor(d.sort_up) else sdecor() end
  wmove(stdscr,x=a+d.namewidth+4)
  if d.sort=='S' sdecor(d.sort_up) else sdecor() end
  wmove(stdscr,x=a+d.namewidth+5);
  if d.tabskip>0 b+=2 end
  wmove(stdscr,x=b+7)
  if d.sort=='T' sdecor(d.sort_up) else sdecor() end
  wmove(stdscr,x=b+8)
  show(d.p)
end

dhelp="""
 The size (in bytes) and the date of each entry are shown.
 If a name is too wide to display completely in the name column, the
 keys {HL →} and {HL ←} will scroll right and left that column.

               {BOX  Moving in the display }

 {HL ↑},{HL k}           Move selection bar one line up
 {HL ↓},{HL j}           Move selection bar one line down
 {HL PgUp}          Move selection bar one screen up
 {HL PgDn},{HL ^F},{HL Space} Move selection bar one screen down
 {HL ^U}/{HL ^D}         Move selection bar one half-screen up/down
 {HL ^PgUp},{HL Home}    Go to top of directory 
 {HL ^PgDn},{HL \$},{HL End}   Go to end of directory 

               {BOX  Changing the display }

 {HL AltN}          Sort entries alphabetically.
 {HL AltE}          Sort entries by extension.
 {HL AltS}          Sort entries by size.
 {HL AltT}          Sort entries by time.
 {HL F3},{HL Enter}      Browse file, change to directory.
 {HL Del},{HL d}         Delete the current entry.

               {BOX  Miscellaneous }

 {HL h}.{HL F1}          Display this message
 {HL Esc},{HL q}         Goto previous menu.
 {HL F9}            Shell escape.

               {BOX  Mouse actions: }

  You can click on any menu item, and on the arrows in the  scroll  bars.
  Clicking  on  an entry sets the cursor there.  Double-clicking does the
  same as Enter.
"""

function dirbrowse(name)
  save=Savewin(stdscr)
  d=Dir_pick(name)
  background()
  p=d.p
  s=p.s
  shaded_frame(stdscr,1,s.begx-1,s.rows+s.begy,s.cols+2,Color.get_att(:BOX))
  initdmenu(d)
  a=s.begx+2*d.tabskip
  b=a+d.namewidth+d.szwidth+2*d.tabskip
  add(:BOX)
  mvadd(s.begy-1,a+d.namewidth,ACS_(:TTEE))
  wmove(stdscr,x=b+1);add(ACS_(:TTEE))
  mvadd(s.begy+s.rows,a+d.namewidth,ACS_(:BTEE))
  wmove(stdscr,x=b+1);add(ACS_(:BTEE))
  mvadd(1,s.begx,:BOX)
  printnormedpath(1,s.begx,d.curdir,s.cols-1)
  show(p)
  c=getch()
  while true
    if c==KEY_MOUSE
      e=getmouse()
      c=process_event(dmenu,e)
      if !isnothing(c) continue end
      c=process_event(p,e)
      if !isnothing(c) && e.bstate==BUTTON1_DOUBLE_CLICKED
        c=KEY_ENTER
        continue
      end
    elseif c in (KEY_ALT('E'),KEY_ALT('N'),KEY_ALT('T'),KEY_ALT('S'))
      ch='A'+c-KEY_ALT('A')
      update_sort(d,ch)
    elseif c==KEY_RIGHT
      if d.offset+d.namewidth<d.maxwidth d.offset+=1;show(d.p) end
    elseif c==KEY_LEFT
      if d.offset!=0 d.offset-=1;show(d.p) end
    elseif c in (KEY_F(1),Int('h'))
      whelp(dhelp,"directory browser")
    elseif c==KEY_F(9) exec(nothing,d.curdir)
    elseif c in (KEY_DC, Int('d'))
      if length(p.s)==0 beep()
      else names=curname(d)
        statbuf=stat(names)
        if myrm(names;rmopts) deleteat!(p.s.list,p.sel_bar) end
        show(p)
      end
    elseif c in (KEY_CTRL('J'), KEY_ENTER, KEY_F(10), KEY_IC, KEY_F(3))
      if c in (KEY_F(10),KEY_IC) && isdir(current(d))
        name=curname(d)
        break
      else 
        bname=curname(d)
        if isdir(bname) dirbrowse(bname)
        else browse_file(bname)
        end
      end
    elseif c in (Int('q'),0x1b) break
    elseif !do_key(p,c)
      n=Menus.do_key(dmenu,c)
      if !isnothing(n)
        c=n
        if c isa Function c();c=-1;end
        continue
      end
    end
    c=getch()
  end
  restore(save)
end
