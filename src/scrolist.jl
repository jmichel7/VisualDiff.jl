# There can be more items than rows, and the list can occupy nbcols>1 columns.
@ExtObj mutable struct Scroll_list{T}
  win::Ptr{WINDOW}
  rows::Int # rows in area where to show list
  cols::Int # how many cols in area of all nbcols where to show list
  begx::Int # upper left corner of area
  begy::Int
  first::Int # the index of the item currently at top left
  width::Int # width of items
  nbshown::Int # nb. items shown (nbcols×rows) where also nbcols=cols/width
  showentry::Function
  # showentry(s,i) displays at the current window position  the i-th item 
  # in the list. When i is outside the range of items displays an empty line.
  on_scroll::Function
  # on_scroll(s) should gather extra actions to be done in case of scroll 
  # (such as maintaining a scroll bar).
  list::Vector{T}
end

Base.length(s::Scroll_list)=length(s.list)

# :rows, :cols and :nbcols are used to determine where to position 
# when calling showentry
function Scroll_list(w,list;rows=getmaxy(w),cols=getmaxx(w),begx=0,begy=0,
  nbcols=1,
  showentry=(s,i)->error("showentry is pure virtual"),
  on_scroll=s->nothing)
  Scroll_list(w,Int(rows),Int(cols),begx,begy,1,div(cols,nbcols),rows*nbcols,
              showentry,on_scroll,list,Dict{Symbol,Any}())
end

function Base.dump(s::Scroll_list)
"area ($(s.begy),$(s.begx))+$(s.rows)x$(s.cols) width=$(s.width) nbshown=$(s.nbshown) first=$(s.first)"
end

function yx(s::Scroll_list,i) # y and x coordinates of ith screen item
  i%s.rows+s.begy, div(i,s.rows)*s.width+s.begx
end

function disp_entry(s::Scroll_list,index) # calls showentry at right position
  i=index-s.first
  if i<0 || i>=s.nbshown return end
  wmove(s.win,yx(s,i)...)
  s.showentry(s,index)
end

# scrolls the list of amount
function scroll(s::Scroll_list,amount) 
  amount=min(max(amount,1-s.first),max(length(s)-s.nbshown-s.first+1,0))
  s.first+=amount
  if amount>0
    start=0
    direction=1
    endscreen=s.nbshown-amount
  else        
    start=s.nbshown-1
    direction=-1
    endscreen=-amount-1
  end
#   if false and USE_NCURSES then # still buggy!
#     start.step(endscreen-direction,direction){ |i|
#     l=@win.mv(*yx(i+amount)).inchnstr(@width)
#     @win.mv(*yx(i)).addchstr(l)}
#   else
    for i in start:direction:endscreen-direction disp_entry(s,i+s.first) end
#   end
  for i in endscreen:direction:s.nbshown-1-start disp_entry(s,i+s.first) end
  if amount!=0 s.on_scroll(s) end
end

function make_visible(s::Scroll_list,l)  # ensure line l is visible
  if !(l in s.first:s.first+s.nbshown-1)
    new_first=max(min(l-div(s.nbshown,4),length(s)-s.nbshown),0)
    if new_first!=s.first scroll(s,new_first-s.first) end
  end
  disp_entry(s,l)
end

function Base.show(s::Scroll_list) # shows the whole area
  for i in s.first:s.first+s.nbshown-1 disp_entry(s,i) end
end

# return true if did something else false
function do_key(s::Scroll_list,key::Integer,factor=1) 
  if key!=Int('G') factor=max(factor,1) end
  if key==KEY_RIGHT scroll(s,factor*s.rows)
  elseif key==KEY_LEFT scroll(s,-factor*s.rows)
  elseif key in (KEY_DOWN, KEY_CTRL('J'), Int('j')) scroll(s,factor)
  elseif key in (KEY_UP, Int('k')) scroll(s,-factor)
  elseif key in (KEY_PPAGE, KEY_CTRL('B')) scroll(s,-factor*s.rows*div(s.cols,s.width))
  elseif key in (KEY_NPAGE,32,KEY_CTRL('F')) scroll(s,factor*s.rows*div(s.cols,s.width))
  elseif key in (KEY_HOME, KEY_CTRL_PPAGE)  scroll(s,-s.first)
  elseif key in (KEY_END, KEY_CTRL_NPAGE, Int('$')) scroll(s,length(s))
  elseif key==KEY_CTRL('U') scroll(s,-factor*div(s.rows,2))
  elseif key==KEY_CTRL('D') scroll(s,factor*div(s.rows,2))
  elseif key==Int('G') make_visible(s,factor==0 ? length(s) : factor)
  else return false
  end
  true
end
