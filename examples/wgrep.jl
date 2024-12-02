using VisualDiff
using VisualDiff.Curses

function wgrep(ARGS)
initscr2()
WIN_WIDTH::Int=COLS()-10
WIN_HEIGHT::Int=div(LINES(),2)
init_pair(1,COLOR_BLACK,COLOR_WHITE); bw=COLOR_PAIR(1)
init_pair(2,COLOR_YELLOW,COLOR_BLUE); yb=COLOR_PAIR(2)|A_BOLD
grepbox=newwin(WIN_HEIGHT, WIN_WIDTH, 0, 0)
keypad(grepbox,true)
init_pair(3,COLOR_BLUE,COLOR_WHITE)
wattron(grepbox,COLOR_PAIR(3)) #wattrset(grepbox,COLOR_PAIR(3))
wborder(grepbox,0,0,0,0,0,0,0,0)
grep=derwin(grepbox,WIN_HEIGHT-2, WIN_WIDTH-2, 1, 1)
wbkgd(grep,bw)
pattern=ARGS[1]
for fname in ARGS[2:end]
  line=0
  matched=false
  open(fname)do f
    while !eof(f)
      l=readline(f)
      line+=1
      l=chomp(l)
      wattron(grep,bw) # wattrset(grep,bw)
      if !isnothing(match(pattern,l))
        if !matched
          matched=true
          mvwhline(grepbox,0,2,ACS_(:HLINE),getmaxx(grepbox)-3)
          mvwaddstr(grepbox,0,2,fname)
          wmove(grepbox,x=getcurx(grepbox)+5);waddstr(grepbox," éàμρ $line")
          wclear(grep)
          wmove(grep,0,0)
        end
        pos=1
        for m in eachmatch(pattern,l)
          waddstr(grep,l[pos:m.offset-1])
          wattron(grep,yb) # wattrset(grep,yb)
          waddstr(grep,m.match)
          wattroff(grep,yb) # wattrset(grep,bw)
          pos=m.offset+ncodeunits(m.match)
        end
        l=l[pos:end]
      elseif !matched continue
      end
      waddstr(grep,l)#waddstr(grep," "^(getmaxx(grep)-getcurx(grep)-1))
      if getcury(grep)>=getmaxy(grep)-1
        matched=false
        wrefresh(grep)
        wmove(grep,0,0)
        mvwaddstr(grepbox,0, WIN_WIDTH-16,"Continue?(y/n)")
        c=Char(wgetch(grepbox))
        if c in "yY" continue
        elseif c in "nN" break
        elseif c in "qQ" return 
        else mvwaddstr(grepbox,0,1,string(c));wrefresh(grepbox)
        end
      end 
      wmove(grep,getcury(grep)+1,0)
    end
  end
end
endwin()
end
