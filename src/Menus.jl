module Menus
using ..Curses
using ..Vdiff
using ..Color
using ..Indexeds
hint::Function=Vdiff.infohint
export Menu, Item, Menu_head

mutable struct Item
  y::Int
  sx::Int
  len
  action::Union{Function, Int, Nothing}
  checked::Bool
  activation_key::Int
  text::Vector{Any}
  hint::String
  Item(y,sx,len,action,checked::Bool)=new(y,sx,len,action,checked)
end

mutable struct Menu_head
  item::Item
  y::Int
  start::Int
  maxlen::Int
  lines::Vector{Int}
  items::Indexed{Item}
  save::Vdiff.Shadepop
  Menu_head(item::Item,y::Integer)=new(item,y)
end

struct Menu
  heads::Indexed{Menu_head}
  function Menu(hint)
    Vdiff.reverse_area(0)
    Menus.hint=hint
    new(Indexed(Menu_head[]))
  end
end

function textlen(text)
  s=split(text,"\t")
  (count(!=('&'),s[1]),length(s)>1 ? length(s[2]) : 0)
end

function Item(y,sx,len,text,action,hint::String="")
  if action isa String action=Int(action[1])  end
  if action isa Integer action=Int(action) end
  if action isa Char action=Int(action) end
  res=Item(y,sx,len,action,false)::Item
  install(res,text,hint)
  res
end

function install(I::Item,text::AbstractString,hint="")
  I.hint=hint
  s=split(text,"\t")
  if length(s)==2 text,expl=s else text=s[1];expl="" end
  s=split(text,"&")
  if length(s)==2 (prekey,postkey)=s else prekey=s[1];postkey="" end
  I.text=[:MTEXT,prekey]
  if !isempty(postkey)
    I.activation_key=uppercase(postkey[1])+KEY_ALT('A')-'A'
    append!(I.text,[:MKEY,postkey[1:1],:MTEXT,postkey[2:end]])
  end
  if isempty(expl) push!(I.text," "^max(0,I.len-length(text)))
  else push!(I.text,lpad(expl,I.len-length(text)))
  end
end

function match_key(I::Item,c::Integer)
  if c==I.activation_key || I.activation_key==c+KEY_ALT('A')-Int('A')
    I.action
  else
    nothing
  end 
end

function draw(I::Item)
  wmove(stdscr,I.y,I.sx)
  if I.checked add(:MKEY,"√") else add(" ") end
# add(stdscr,:MTEXT,I.text...)
  add(I.text...)
end

function enter(I::Item)
  Menus.hint(I.hint)
  Vdiff.reverse_area(I.y,I.sx,I.sx+I.len)
end

function toggle(I::Item)
  I.checked=!I.checked
end

function Vdiff.leave(I::Item)
  Menus.hint("")
  Vdiff.reverse_area(I.y,I.sx,I.sx+I.len)
end

owns(I::Item,e)=e.x in I.sx:I.sx+I.len && e.y==I.y

#  args: y,x,text[,action] or
#        y,x,text[,item*]
#   item="-" or  [text,action[,hint]]
function Menu_head(text::String,args...)
  y=getcury(stdscr)
  sx=getcurx(stdscr)
  if args[1] isa Number action=args[1];args=args[2:end]
  else action=nothing
  end
  item=Item(y,sx,textlen(text)[1],text,action)::Item
  draw(item)
  m=Menu_head(item,y)
# if !isnothing(action) return m end
  if isempty(args) return m end
  lengths=map(a->a=="-" ? (0,0) : textlen(a[1]),args)
  m.maxlen=2+maximum(first.(lengths))+maximum(last.(lengths))
  m.start=min(max(sx,1),COLS()-m.maxlen-4)
  y+=1
  m.lines=Int[]
  m.items=Indexed(Item[])
  for a in args
    y+=1
    if a=="-" push!(m.lines,y)
    else push!(m.items.v,Item(y,m.start,m.maxlen,a...))
    end
  end
  m
end

function setx(m::Menu_head,sx)
  m.item.sx=sx
end

function enter(m::Menu_head)
  #leaveok(stdscr,true);
  curs_set(0)
  enter(m.item)
  if isdefined(m,:items)
    m.save=Vdiff.Shadepop(m.y+1,m.start-1,
                    m.y+length(m.items)+length(m.lines)+2,
                    m.maxlen+3;att=Color.get_att(:MTEXT))
    for i in m.items draw(i) end
    for y in m.lines
      mvadd(y,m.start-1,ACS_(:LTEE))
      hline(0,m.maxlen+1)
      mvadd(y,m.start+m.maxlen+1,ACS_(:RTEE))
    end
    change(m.items,0)
  end
end

function Vdiff.leave(m::Menu_head)
  if isdefined(m,:items)
    change(m.items,0) 
    Vdiff.restore(m.save)
  end
  Vdiff.leave(m.item)
end

function which_item_event(m::Menu_head,e)
  for (i,o) in enumerate(m.items) if owns(o,e) return i end end
  nothing
end

function item_key(m::Menu_head,c)
  for i in m.items
    k=match_key(i,c) 
    if !isnothing(k) return k end
  end
  nothing
end

function get_key(m::Menu_head)
  if !isdefined(m,:items) return m.item.action
  elseif m.items.pos!=0 return current(m.items).action
  else return nothing
  end
end

function Vdiff.leave(m::Menu)
  res=get_key(current(m.heads))
  change(m.heads,0)
# Vdiff.werror("res=$res")
  if res isa Function res()
  elseif !isnothing(res) return res end
  getch()
end

function debugc(c::Integer)
  x=getcurx(stdscr)
  y=getcury(stdscr)
  mvadd(LINES()-16,1,"c=$(c)  ")
  refresh()
  wmove(stdscr,y,x)
end

function mainloop(m::Menu,event=nothing)
  while true
    if event!=nothing c=KEY_MOUSE else c=getch() end
    if c==KEY_MOUSE
      if event!=nothing e=event; event=nothing else e=getmouse() end
      t=whichhead(m,e) 
      if !isnothing(t)
        if Vdiff.among(e,BUTTON1_PRESSED|BUTTON1_RELEASED|BUTTON1_CLICKED)
          change(m.heads,t)
          if !isdefined(current(m.heads),:items) && 
            Vdiff.among(e,BUTTON1_RELEASED|BUTTON1_CLICKED)
            return Vdiff.leave(m)
          end
        end
      elseif isdefined(current(m.heads),:items) && !isnothing(which_item_event(current(m.heads),e))
        i=which_item_event(current(m.heads),e)
        if Vdiff.among(e,BUTTON1_PRESSED|BUTTON1_RELEASED|BUTTON1_CLICKED)
          change(current(m.heads).items,i)
          if Vdiff.among(e,BUTTON1_RELEASED|BUTTON1_CLICKED)
           return Vdiff.leave(m)
          end
        end
      else 
        change(m.heads,0)
        return nothing
      end
    elseif c in (KEY_LEFT,Int('h')) prev(m.heads)
    elseif c in (KEY_RIGHT,Int('l')) next(m.heads)
    elseif c in (KEY_DOWN,Int('j'))
      if isdefined(current(m.heads),:items) next(current(m.heads).items) end
    elseif c in (KEY_UP,Int('k'))
      if isdefined(current(m.heads),:items) prev(current(m.heads).items) end
    elseif c in (KEY_CTRL('J'), KEY_ENTER) 
      return Vdiff.leave(m)
    elseif c==0x1b
      change(m.heads,0)
      return nothing
    else 
      if isdefined(current(m.heads),:items) && item_key(current(m.heads),c)!==nothing
        res=item_key(current(m.heads),c)
        change(m.heads,0)
        return res
      end
    end
  end
end

function do_key(m::Menu,c::Integer)
  for (i,h) in enumerate(m.heads.v)
    if h.item.activation_key==c
      m.heads.pos=i
      if isdefined(current(m.heads),:items)
        enter(current(m.heads))
        res=mainloop(m)
        if res isa Function res() end
        return res
      else return current(m.heads).item.action
      end
    end
  end
  nothing
end

function whichhead(m::Menu,e)
  for (i,h) in enumerate(m.heads) if owns(h.item,e) return i end end
  nothing
end

# returns an action (which could be mouse key) if the event e was in menu 
# (the action represents next action to be done), nil otherwise
function Vdiff.process_event(m::Menu,e)
  if !(Vdiff.among(e,BUTTON1_PRESSED|BUTTON1_RELEASED|BUTTON1_CLICKED) && 
    !isnothing(whichhead(m,e))) return nothing end
  mainloop(m,e)
end

function Color.add(m::Menu,args...)
  push!(m.heads.v,Menu_head(args...))
end

NCurses.refresh(m::Menu)=for h in m.heads draw(h.item) end
end

using .Menus
