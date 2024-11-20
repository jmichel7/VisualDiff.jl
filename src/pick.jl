#def dump(s)
#  x,y=stdscr.curx,stdscr.cury
#  stdscr.mvaddstr(lines-5,1,s)
#  stdscr.setpos(y,x)
#  stdscr.refresh
#end

# Adds a selection bar to a scroll_list, at @sel_bar

mutable struct Pick_list 
  s::Scroll_list # s.showentry(i) when i=@sel_bar should mark the selection bar.
  sel_bar::Int # the logical position in the list (where is the selection bar)
  on_move_bar::Function
end

Pick_list(s::Scroll_list)=Pick_list(s,1,function()end)

# take care that sel_bar is in view.
function Base.show(p::Pick_list)
  s=p.s
  s.first=max(min(s.first,p.sel_bar,length(s)-s.nbshown),p.sel_bar+1-s.nbshown,1)
  p.on_move_bar()
  show(s)
end
  
  # move sel_bar by amount and scroll if needed
function scroll(p::Pick_list,amount;sync=true) 
  oldptr=p.sel_bar
  s=p.s
  p.sel_bar=max(min(p.sel_bar+amount,length(s)),1)
  if p.sel_bar==oldptr
    if p.sel_bar+amount!=oldptr disp_entry(s,oldptr);beep end
    return
  end
  p.on_move_bar()
  # @sync decides where is sel_bar in window if scrolling needed:
  # true: relative position unchanged 
  # false: put at first 1/4
  if sync new_first=s.first+(p.sel_bar-oldptr) 
  elseif p.sel_bar in s.first:s.first+s.nbshown-1 new_first=s.first
  else new_first=p.sel_bar-div(s.nbshown,4)
  end
  new_first=max(min(new_first,length(s)-s.nbshown+1),1)
# Dump("sb$(oldptr)=>$(p.sel_bar) first$(s.first)=>$new_first sync=$sync")
  if new_first!=s.first scroll(s,new_first-s.first) end
  if oldptr in s.first:s.first+s.nbshown-1 disp_entry(s,oldptr) end
  disp_entry(s,p.sel_bar)
end

# def on_move_bar # action to do when logical position of bar is moved
# end

function move_bar_to(p::Pick_list,newpos) # move sel_bar to newpos
#   log "move_bar_to(#{newpos}) @sel_bar=#{@sel_bar}\n"
  if newpos==p.sel_bar disp_entry(p.s,p.sel_bar)
  else scroll(p,newpos-p.sel_bar,sync=false)
  end
end

# return true if did something else false
function do_key(p::Pick_list,key,factor=1) 
  s=p.s
  if key in (KEY_DOWN, KEY_ENTER, KEY_CTRL('J'), 'j') move_bar_to(p,p.sel_bar+factor)
  elseif key== KEY_RIGHT move_bar_to(p,p.sel_bar+factor*s.rows)
  elseif key==KEY_LEFT  move_bar_to(p,p.sel_bar-factor*s.rows)
  elseif key in (KEY_UP, 'k') move_bar_to(p,p.sel_bar-factor)
  elseif key==KEY_HOME  move_bar_to(p,1)
  elseif key in (KEY_END, '$') move_bar_to(p,length(s))
  elseif key in (KEY_PPAGE, KEY_CTRL('B')) old=s.first;do_key(s,key,factor)
    move_bar_to(p,s.first+p.sel_bar-old)
  elseif key in (KEY_NPAGE,32,KEY_CTRL('F')) old=s.first;do_key(s,key,factor)
    move_bar_to(p,s.first+p.sel_bar-old)
  else return do_key(s,key,factor)
  end
  true
end

# if e in list moves there and returns -1, else nil
function process_event(p::Pick_list,e::MEVENT) 
  if haskey(p.s,:sb)
    c=process_event(p.s.sb,e)
    if c!=nothing do_key(p,c); return -1 end
  end
  x=e.x-getbegx(p.s.win)-p.s.begx
  y=e.y-getbegy(p.s.win)-p.s.begy
  if !(0<=x<p.s.cols && 0<=y<p.s.rows) return nothing end 
  move_bar_to(p,p.s.first+y+p.s.rows*div(x,p.s.width))
  -1
end
