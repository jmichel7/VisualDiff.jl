export whelp

"""
`whelp(msg,title)`

Show the help file `msg` (using `printa`) with title `title`.
"""
function whelp(msg,title)
  save=Shadepop(0,0,LINES()-2,COLS()-2)
  mvadd(stdscr,0,2,:BOX,"Help for the "*title)
  mvadd(stdscr,LINES()-3,2,"Esc to exit")
  p=Scroll_list(stdscr,split(msg,"\n");rows=LINES()-4,cols=COLS()-4,begx=1,begy=1,
    showentry=function(s,i)
      add(s.win,:NORM)
      if i<=length(s) printa(s.win,s.list[i]) end
      clrtocol(s.win,s.begx+s.cols-1)
    end,
    on_scroll=function(s)
      add(s.win,:BOX)
      mvwhline(s.win,s.begy+s.rows,s.begx+14,0,14)
      mvwhline(s.win,s.begy-1,s.begx+s.cols-9,0,9)
      if s.first>1
        mvadd(s.win,s.begy+s.rows,s.begx+14,"PgUp",ACS_(:HLINE),ACS_(:UARROW))
        mvadd(s.win,s.begy-1,s.begx+s.cols-9,"Line $(s.first)")
      end
      if s.first+s.rows<=length(s)
        mvadd(s.win,s.begy+s.rows,s.begx+22,"PgDn",ACS_(:HLINE),ACS_(:DARROW))
      end
    end)

  show(p)
  p.on_scroll(p)
  c=getch()
  while true
    if c==KEY_MOUSE
      e=getmouse()
      if !among(e,BUTTON1_PRESSED|BUTTON1_RELEASED|BUTTON1_CLICKED) c=nothing
      elseif e.y!=p.begy+p.rows c=nothing 
      else x=e.x-p.begx
        c=if x in 1:11 e.bstate==BUTTON1_CLICKED ? 0x1b : nothing
          elseif x in 14:17 KEY_PPAGE
          elseif x in 19:19 KEY_UP
          elseif x in 22:25 KEY_NPAGE
          elseif x in 27:27 KEY_DOWN
          else nothing
          end
      end
      if !isnothing(c) continue end
    elseif c in (0x1b, Int('q'), Int('Q'), KEY_F(10)) break
    elseif !do_key(p,c) beep()
    end
    c=getch()
  end
  restore(save)
  refresh()
end

HELPMENU=(" &Help ",["&Help\tF1",KEY_F(1),"Get help on current screen"])
