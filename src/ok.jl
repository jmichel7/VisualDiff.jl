function ok(msg,q="yn")
  title="do you want to"
  msg*="?"
  text=Dict('y'=>"yes",'n'=>"no",'g'=>"yes and don't ask again",
            's'=>"skip questions",'q'=>"stop")
  q=collect(q)
  w=max(map(i->length(text[i])+3,q)...,length(msg),length(title))
  height=4+div(w,COLS()-3)
  w=min(w,COLS()-3)
  yoff=div(LINES(),2)-1
  xoff=div(COLS()-w-2,2)
  sav=Shadepop(yoff,xoff,height,w+2)
  curs_set(0)
  wmove(stdscr,yoff,xoff);add(stdscr,:BOX)
  center(stdscr,title,w+2)
  msgwin=derwin(stdscr,height-3,w,yoff+1,xoff+1)
  add(msgwin,:NORM,rpad(msg,w))
  pos=1
  while true
    wmove(stdscr,yoff+height-2,xoff+height-3)
    buttons=map(1:length(q))do i
      if i>1 add(stdscr,:NORM,"  ") end
      Button(q[i],[pos==i ? :BAR : :BOX,text[q[i]]])
    end
    c=getch()
#   dump "c=<#{'%x' %c}=#{c.chr}>"
    res=
    if c==KEY_MOUSE
      e=getmouse()
      for b in buttons
        c=process_event(b,e)
        if !isnothing(c) break end
      end
      c
      # the dialog is modal so we don't quit for an external event
    elseif c in (Int('y'),Int('Y')) 'y'
    elseif c in (Int('n'),Int('N'),0x1b) 'n'
    elseif c in (Int('g'),Int('G')) 'g'
    elseif c in (Int('q'),Int('Q')) 'Q'
    elseif c in (KEY_ENTER, KEY_CTRL('J')) q[pos]
    elseif c==KEY_LEFT || c==Int('h') pos=mod1(pos-1,length(q));continue
    elseif c==KEY_RIGHT || c==Int('l') pos=mod1(pos+1,length(q));continue
    else c
    end
    if Char(res) in q
      restore(sav)
      delwin(msgwin)
      return Char(res)
    else beep()
    end
  end
end
