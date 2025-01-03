function getinput(win,initstr;getinput=true)
  height=getmaxy(win)
  if getinput
    mvwadd(win,height-3,0,:NORM)
    printa(win,
      "Use keys {HL ←}, {HL →}, {HL Ins} and {HL Del} to edit. When finished,")
    wmove(win,height-2,0)
    printa(win,"press {HL Enter} to accept the new value or {HL Esc} to abort")
  end
  mvwadd(win,height-1,0,:NORM,"[")
  mvwadd(win,height-1,getmaxx(win)-1,:NORM,"]")
  wmove(win,height-1,1)
  f=Input_field(win,getmaxx(win)-3;overflow=true)
  f.act=c->c!=0 ? c : 0x1b
  wadd(win,:BOX)
  fclear(f,initstr)
  val=nothing
  if getinput val=input(f) 
   mvwadd(win,height-3,0,:NORM);wclrtoeol(win)
   mvwadd(win,height-2,0,:NORM);wclrtoeol(win)
   wrefresh(win)
  else enter(f); leave(f) end
  wadd(win,:NORM)
  val
end

# level: 1 change may affect display
#        2 change may affect vdiff and vdirdiff
#        3 recur changed

function optionmenu()
data=[:by_par,:ignore_endings,:ignore_blkseq,:ignore_blklin,:ignore_case,
      :align,:sync_size,
#:recur_dirs,
      :onlylength,:length_and_timestamp,:h_treshold,:h_range]
  height=max(length(data)+3,13)
  curs_set(0)
  savedopts=copy(opt)
# oldaspect=curs_get
  swin=Shadepop(0,0,height,COLS()-1)
  s=Scroll_list(stdscr,data;rows=length(data),cols=
       maximum(map(d->length(opt.h[d][:name]),data)),begx=1,begy=1)
  p=Pick_list(s)
  s.showentry=function(s,i)
    if opt.h[data[i]][:value]==true add(:HL,"√",:NORM) 
    else add(:NORM," ")
    end
    text=opt.h[data[i]][:name]
    add(i==p.sel_bar ? :BAR : :BOX,text," "^(s.cols-length(text)))
  end
  pwidth=2+s.cols
  explwin=derwin(stdscr,height-2,COLS()-pwidth-3,1,pwidth+1)
  p.on_move_bar=function()
    wbkgd(explwin,Color.get_att(:NORM))
    d=opt.h[data[p.sel_bar]]
    sep="\n\n"
    mvwadd(explwin,2,0,par(
      (d[:value] isa Bool ? "When this option is checked, " : "")*sep*
      d[:shortdesc]*sep*d[:longdesc],COLS()-pwidth-4;sep))
    wclrtobot(explwin)
    if d[:value] isa Bool
      wmove(explwin,height-4,3)
      printa(explwin,"Press {HL Enter} or Double Click to toggle.")
    else 
      getinput(explwin,string(d[:value]);getinput=false)
      wmove(explwin,height-4,3)
      printa(explwin,"Press {HL Enter} to change the value given below.")
    end
    wrefresh(explwin)
  end
  acts=Button[]
  mvadd(0,pwidth,:BOX,ACS_(:TTEE))
  mvadd(height-1,pwidth,ACS_(:BTEE))
  for i in 0:height-3 mvadd(i+1,pwidth,ACS_(:VLINE)) end
  mvwadd(explwin,0,0,:HL)
  center(explwin,"Explanation of highlighted item")
  wadd(explwin,:NORM)
  mvadd(0,6,:BOX,"select option with ")
  push!(acts,Button(KEY_UP,"{HL ↑}"))
  push!(acts,Button(KEY_DOWN,"{HL ↓}"))
  add("/click")
  mvadd(height-1,6,"type ")
  push!(acts,Button(KEY_F(10),"{HL F10}"))
  add(" to accept new options or ")
  push!(acts,Button(0x1b,"{HL Esc}"))
  add(" to abort")
  show(p)
# mousemask(BUTTON1_CLICKED|BUTTON1_DOUBLE_CLICKED)
  c=nothing
  while true
    @label continuing
    if isnothing(c) c=getch() end
    if c==KEY_MOUSE
      e=getmouse()
      for b in acts 
        c=process_event(b,e)
        if !isnothing(c) @goto continuing end
      end
      c=process_event(p,e)
      if !isnothing(c) && e.bstate==BUTTON1_DOUBLE_CLICKED
        c=KEY_ENTER
        continue
      end
    elseif c in (0x1b, Int('q'))
      global opt
      if savedopts!=opt && 'y'==ok("abandon changes to options","ny")
	opt=savedopts
        restore(swin)
        delwin(explwin)
	return 0
      end
      break
    elseif c==KEY_F(10) break
    elseif c in (KEY_CTRL('J'), KEY_ENTER)
      d=opt.h[data[p.sel_bar]]
      val=d[:value]
      if val isa Bool d[:value]=!val
        show(p)
      elseif  val isa Integer
        val=getinput(explwin,string(val))
        if !isnothing(val) && !isempty(val) d[:value]=parse(Int,val) end
#     elseif val isa String 
#       val=getinput(explwin,val)
#       if !isnothing(val) && !isempty(val) d[:value]=val end
      end
    elseif !do_key(p,c) beep()
    end
    c=nothing
  end
  restore(swin)
  delwin(explwin)
  max_level_changed(opt,savedopts)
end

OPTMENU=["Comparison &Options\tF6",'o',"Options which control file comparisons"]
