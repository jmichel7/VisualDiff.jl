export browse_file

# browse a file with a folding or not browser
push!(opt.h,:fold=>Dict(:value=>false), 
          :showempty=>Dict(:value=>false), 
          :showtabs=>Dict(:value=>false), 
          :foo=>Dict(:value=>false), 
 :tabsize=>Dict(:name=>"tab_size",
 :shortdesc=>"tab size to use when rendering text",
 :value=>8))

mutable struct Scrln
  lno # line number in @b
  nth # screen subline number
  firstch  # index in line of first char of screen subline
  lastch   # index in line of last char of screen subline
  Scrln(l,nth,firstch)=new(l,nth,firstch,0)
end

Base.show(io::IO,l::Scrln)=print(io,l.lno,".",l.nth,"=",l.firstch,":",l.lastch)

abstract type AbstractBrowser end

mutable struct Folding_browser<:AbstractBrowser
  s::Scroll_list{<:Scrln}
  offset::Int
  indicator::Function
  do_key::Function
  d::Regex_in_buf
  Folding_browser(s::Scroll_list{<:Scrln},o::Int)=new(s,o)
end

function Folding_browser(b;bopt...)
  lines=Scrln[]
  width=bopt[:cols]
  for (i,ln) in enumerate(b) 
    start=1; nth=0; res=1
    while res!=nothing
      l=Scrln(i,nth,start)
      wmove(stdscr,0,0)
      res=attprint(stdscr,ln[start:end],width;opt...)
      if isnothing(res) l.lastch=ncodeunits(ln)
      else start=l.lastch=res+start-1
      end
      push!(lines,l)
      nth+=1
    end
  end
  s=Scroll_list(stdscr,lines;bopt...)
  add_scrollbar(s,COLS()-2)
  bb=Folding_browser(s,0)
  s.showentry=function(s,i)
    add(:NORM)
    if i in eachindex(s.list) 
      l=s.list[i]
      ln=b[l.lno][l.firstch:l.lastch]
      d=shift(get(bb.d,l.lno),l.firstch)
      attprint(s.win,ln,s.width;decor=d,opt...)
    else attprint(s.win,"",s.width;opt...)
    end
  end
  bb.do_key=function(key,factor=1)do_key(bb.s,key,factor) end
  bb
end

#    init_scroll()
#  end

first_on_screen(b::Folding_browser)=b.s.list[b.s.first].lno

last_on_screen(b::Folding_browser)=b.s.list[min(b.s.first+b.s.nbshown-1,length(b.s))].lno

mutable struct Offset_browser<:AbstractBrowser
  s::Scroll_list{<:AbstractString}
  offset::Int
  indicator::Function
  do_key::Function
  d::Regex_in_buf
  Offset_browser(s::Scroll_list{<:AbstractString},o::Int)=new(s,o)
end

info2(s::String,i=0)=(wmove(stdscr,getmaxy(stdscr)-1,10+i);addstr(s))

function Offset_browser(b;bopt...)
  s=Scroll_list(stdscr,b;bopt...)
  add_scrollbar(s)
  s.showentry=function(s,i)
    add(:NORM)
    if i<=length(s)
     l=s.list[i]
     u=collect(Base.Unicode.graphemes(l))
     l=prod(u[b.offset+1:end])
    else l=""
    end
    attprint(s.win,l,s.width;decor=get(b.d,i),opt...)
  end
  b=Offset_browser(s,0)
  b.do_key=function(key,factor=1)
    if key==KEY_HOME      set_offset(b,0)
    elseif key==KEY_END   set_offset(b,maxlen(b,))
    elseif key==KEY_RIGHT set_offset(b,b.offset+max(factor,1))
    elseif key==KEY_LEFT  set_offset(b,b.offset-max(factor,1))
    elseif key==KEY_CTRL_RIGHT set_offset(b,b.offset+10*max(factor,1))
    elseif key==KEY_CTRL_LEFT set_offset(b,b.offset-10*max(factor,1))
    else do_key(b.s,key,factor)
    end
    return true
  end
  b
end

# find max (linelength-width) for lines on screen
function maxlen(b::Offset_browser)
  max(maximum(ncodeunits.(b.s.list[first_on_screen(b):last_on_screen(b)]))-
       b.s.cols,0)
end

function set_offset(b::Offset_browser,o)
  b.offset=max(0,min(o,maxlen(b)))
  b.indicator()
  show(b.s)
end

first_on_screen(b::Offset_browser)=b.s.first

last_on_screen(b::Offset_browser)=min(b.s.first+b.s.nbshown-1,length(b.s))

function add_info(b::AbstractBrowser)
  b.indicator=function()
    mvadd(0,31,:BOX," lines ",:HL,string(first_on_screen(b)),
          :BOX,"-",:HL,string(last_on_screen(b)))
    if b isa Folding_browser add(" fold") end
    add(:HL)
    for (a,c) in [(:showempty," showempty"),(:showtabs," showtabs")]
      add(getproperty(opt,a) ? c : "")
    end
    add(:BOX," tab=",:HL, string(opt.tabsize),:BOX," ")
    if b isa Offset_browser && b.offset>0
      add(:BOX," +",:HL,string(b.offset))
    end
    add(:BOX); clrtoeol()
    refresh()
  end
  old_scroll=b.s.on_scroll
  b.s.on_scroll=s->(old_scroll(b.s);b.indicator())
end

function settab(b::AbstractBrowser,i)
  opt.tabsize=i
  b.indicator()
  show(b.s)
end

const browserhelp="""
 Most commands may be preceded by a repetition factor.
 Those marked (mode) are toggles. 
 The state of toggles is shown on the top line.

                   {BOX  Moving around: }

{HL ↑}.{HL k}             Scroll one line up
{HL ↓}.{HL <CR>}.{HL j}        Scroll one line down
{HL PgUp}.{HL ^B}         Scroll one screen up
{HL PgDn}.{HL ^F}.{HL Space}   Scroll one screen down
{HL Ctrl-U}/{HL Ctrl-D}   Scroll one half screen up/down
{HL Ctrl-PgUp}       Go to top of file
{HL Ctrl-PgDn}.{HL \$}     Go to bottom of file
{BOX n}{HL G}              Go to line {BOX n} (to end of file if no {BOX n} given)
{HL ←}/{HL →}             Scroll one column left/right   (only if no folding)
{HL Ctrl-←}/{HL Ctrl-→}   Scroll ten columns left/right  (only if no folding)
{HL Home}/{HL End}        Scroll all the way left/right  (only if no folding)
{HL /}/{HL ?}             Search/search backward for pattern.
{HL n}               Search again for pattern
{HL N}               Search again for pattern in reverse direction

                    {BOX  Changing the display: }

{HL f}               (mode) fold lines
{HL E}               (mode) make empty space visible
{HL T}               (mode) make tabs visible
{BOX n}{HL t}              Set tab value to {BOX n} (no {BOX n} means display tabs as '\x09')

                    {BOX  Miscellaneous: }

{HL h}.{HL F1}            Display this message
{HL F9}              Shell escape.
{HL Esc}.{HL Q}.{HL q}.{HL F10}     Leave the browser

                    {BOX  Mouse actions: }

  You can click on any menu item and on the arrows in the scroll bars.
"""

function re_input(b,forward,factor)
  b.d.re=Regex(inputbox("Regular expression to search"*
                        (forward ? "forward" : "backward")*"for",""))
  b.d.forward=forward
  re_search(b,true,factor)
end

function re_search(b,forward=true,factor=1;startline=b.d.matchline)
  if !isdefined(b.d,:re) beep();return end
  if !(startline in first_on_screen(b):last_on_screen(b))
   startline=forward ? first_on_screen(b) : last_on_screen(b)
  end
  while factor>0 && find_re(b.d,b.s.list,forward,startline)
    factor-=1
  end
  if b.d.matchline!=-1 make_visible(b.s,b.d.matchline) end
  show(b.s) # for refreshing sublines
  wrefresh(b.s.win)
end

# n: how many chars shown on a line
function binbrowse(name::String,n=20)
  bs=read(name,String)
  sav=Shadepop(0,0,LINES()-1,COLS()-1)
  wmove(stdscr,LINES()-2,3);button=Button(Int('q'),"{HL 'q'} to quit binary browser")
  printnormedpath(0,1,name,LINES()-2)
  list=collect(Iterators.partition(Vector{UInt8}(bs),n))
  s=Scroll_list(stdscr,list;begx=1,begy=1,rows=LINES()-3,cols=COLS()-3)
  add_scrollbar(s)
  lnowidth=length(string(max(length(bs),n*(LINES()-3))))
  s.showentry=function(s,i)
    add(:NORM,lpad(n*i+1,lnowidth),ACS_(:VLINE))
    if i<=length(s.list)
      for (k,ch) in enumerate(s.list[i])
        wmove(stdscr;x=s.begx+lnowidth-2+3*k)
        if (ch in 0:31) || (ch in 128:159) add(" "*string(ch,base=16,pad=2))
        else addstr(lpad(Char(ch),3))
        end
      end
    end
    clrtocol(COLS()-3)
  end
  show(s)
  while true
    c=getch()
    if c==KEY_MOUSE
      e=getmouse()
      c=process_event(button,e)
      if isnothing(c) c=process_event(s.sb,e) end
      if isnothing(c) continue end
    end
    if false==do_key(s,c)
     if c in (Int('q'),0x1b) restore(sav); return end
    end
  end
end

function browse_file(name)
  b=map(s->filter(!=('\0'),s),split(read(name,String),"\n"))
  if sum(s->count(!isvalid,s),b)>2*length(b)
    werror("$name is a binary file; using binary browser")
    binbrowse(name)
    return
  end
  save=Savewin(stdscr)
  background()
  shaded_frame(stdscr;x=0,y=1,height=LINES()-2,width=COLS()-1)
  br=Folding_browser(b;rows=LINES()-4,cols=COLS()-3,begy=2,begx=1)
  bo=Offset_browser(b;rows=LINES()-4,cols=COLS()-3,begy=2,begx=1)
  for bb in [br,bo]
    add_info(bb)
    old_key=bb.do_key
    bb.do_key=function(key,factor=1)
      if key==Int('t') settab(bb,factor)
      elseif key==Int('/') re_input(bb,true,max(factor,1))
      elseif key==Int('?') re_input(bb,false,max(factor,1))
      elseif key==Int('n') re_search(bb,true,max(factor,1))
      elseif key==Int('N') re_search(bb,false,max(factor,1))
      else old_key(key,factor)
      end
      true
    end
    bb.d=Regex_in_buf()
  end
   
  bb=bo
  wmove(stdscr,0,0)
  cm=Menu(infohint)
  add(cm," &File ",
##   SHELLMENU
    ["E&xit screen\tEsc",0x1b,"Exit current screen"])
  add(cm," &View ",
  ["F&old lines\to",'f',"Fold/do not fold lines"],
 ["&Empty space\tE",'E',"Make/do not make empty space at end of lines visible"],
  ["&Tabs\tT",'T',"Make/do not make tabs visible"])
  add(cm," &Options ",COLORMENU,SAVEOPTMENU)
  add(cm,HELPMENU...,ABOUTMENU)
  printnormedpath(1,1,name,COLS()-3)
  refresh(cm)
  wnoutrefresh(stdscr)
  bb.s.on_scroll(bb.s)
  settab(bb,opt.tabsize)
# mousemask(BUTTON1_PRESSED|BUTTON1_RELEASED|BUTTON1_CLICKED)
  factor=0
  c=getch()
  while true
#   info2("$c=$(Char(c))")
    if c==KEY_MOUSE
      e=getmouse()
      c=process_event(bb.s.sb,e)
      if !isnothing(c) continue end
      c=process_event(cm,e)
      if c isa Function c() 
      elseif !isnothing(c) && c!=-1 continue
      end
    elseif c in Int('0'):Int('9') factor=10*factor+c-Int('0')
    elseif c==Int('f')
      opt.fold=!opt.fold
      old=bb
      if opt.fold bb=br
      else bb=bo
      end
      scroll(bb.s,first_on_screen(old)-first_on_screen(bb))
      show(bb.s)
      bb.s.on_scroll(bb.s)
    elseif c in (Int('E'),Int('T'))
      toggle(opt,c==Int('E') ? :showempty : :showtabs)
      show(bb.s)
      bb.indicator()
    elseif c in (0x1b, Int('q'), Int('Q'), KEY_F(10)) break
    elseif c in (Int('h'), KEY_F(1)) whelp(browserhelp,"browser")
    elseif c==Int('C') colormenu()
    elseif c==KEY_F(9) exec(nil,".")
    else 
      n=Menus.do_key(cm,c)
      if !isnothing(n)
        c=n
        if c isa Function c() else continue end
      end
      if bb.do_key(c,factor) factor=0
      else beep()
      end
    end
    c=getch()
  end
# curs_set(oldaspect)
# bb.props.each{|k,v| $opt[k][:value]=v}
  restore(save)
end
