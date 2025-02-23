export add_scrollbar

# A scroll bar widget
mutable struct Scrollbar
  win::Ptr{WINDOW}
  begy::Int # top of scrollbar
  rows::Int # height of scrollbar
  x::Int    # column of scrollbar
end

"""
`Scrollbar(win;x=win.cols,begy=0,rows=win.rows-begy)`

defines a scroll bar widget which occupies column `x` of window `win` starting
at row `y` and occuping `rows` rows.
"""
Scrollbar(win;x=win.cols,begy=0,rows=win.rows-begy)=Scrollbar(win,begy,rows,x)

"""
`show(s::Scrollbar,first,window,barlength)`

Make the scrollbar `s` represent an interval of length `window` starting at
`first` of a list of length `barlength`
"""
function Base.show(s::Scrollbar,first,window,barlength) 
# werror("$first:$(first+window-1)/$barlength col=$(s.x) rows=$(s.begy):$(s.begy+s.rows-1)")
  e=first+window-1
  if barlength==0 || (first==1 && window>=barlength) return end
  begh=div(first*s.rows,barlength)
  endh=div(e*s.rows,barlength) # limits of 'handle'
  if endh==0 && first!=1 endh=1 end
  if begh==s.rows-1 && e<barlength begh=s.rows-2  end
  bar=:BOX # global style: color of scrollbar
  arrow=:HL # global style: color of the arrows
  for i in 0:s.rows-1
    wmove(s.win,i+s.begy,s.x)
    wadd(s.win,bar,begh<=i<=endh ? ACS_(:CKBOARD) : ACS_(:VLINE))
  end
  if first!=1 wmove(s.win,s.begy,s.x);wadd(s.win,arrow,ACS_(:UARROW)) end
  if e<barlength 
    wmove(s.win,s.rows+s.begy-1,s.x)
    wadd(s.win,arrow,ACS_(:DARROW))
  end
end

# if e in scrolbar returns key describing where, otherwise nil
function process_event(s::Scrollbar,e)
  if !among(e,BUTTON1_PRESSED|BUTTON1_CLICKED) || e.x!=s.x return nothing end
  d=e.y-s.begy
  if d==0 return KEY_UP
  elseif d==s.rows-1 return KEY_DOWN
  else return nothing
  end
end

"""
`add_scrollbar(s::Scroll_list,sx=s.begx+s.cols)`

Add to scroll_list `s` a scroll bar at column `sx` which will be
updated at each scroll to reflect the visible part of `s.list`.
"""
function add_scrollbar(s::Scroll_list,sx=s.begx+s.cols)
  s.sb=Scrollbar(s.win,s.begy,s.rows,sx)
  old_scroll=s.on_scroll
  s.on_scroll=function(s)
    old_scroll(s)
    show(s.sb,s.first,s.nbshown,length(s))
  end
  s.on_scroll(s)
end
