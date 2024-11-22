# defines input fields
struct Save_cursor
  win::Ptr{WINDOW}
  aspect::Int32
  curx::Int
  cury::Int
end

function Save_cursor(win::Ptr{WINDOW})
  aspect=curs_set(0)
  curs_set(aspect)
  Save_cursor(win,aspect,getcurx(win),getcury(win))
end

function delete(s::Save_cursor)
  curs_set(s.aspect)
  wmove(s.win,s.cury,s.curx)
  wrefresh(s.win)
end

@ExtObj mutable struct Input_field
  win::Ptr{WINDOW}
  firstx::Int
  firsty::Int
  length::Int
  overflow::Bool
  decor::Bool
  dbeg::Int
  dend::Int
  buf::String
  bufpos::Int # number of chars of buf hidden on left
  insert_mode::Bool
  ss::Save_cursor
  function Input_field(w,len;overflow=false,decor=false)
    firstx=getcurx(w)
    firsty=getcury(w)
    if decor
      wmove(w,x=firstx-1);dbeg=winch(w)
      wmove(w,x=firstx+len);dend=winch(w)
    else dbeg=dend=0
    end
    s=Save_cursor(w)
    curs_set(2)
    new(w,firstx,firsty,len,overflow,decor,dbeg,dend,"",0,true,s,Dict{Symbol,Any}())
  #   @ss=nil # an object of class Save_cursor; to maintain cursor's aspect.
  #           # Is also a way to test if field has focus..
    #dump "<Field:#{@firsty},#{@firstx}...#{@firstx+@length}>"
  end
end

function fclear(f::Input_field,initial_string=nothing) 
  wmove(f.win,f.firsty,f.firstx)
  clrtocol(f.win,f.firstx+f.length-1)
  f.insert_mode=true
  if initial_string!=nothing
    for c in initial_string faddch(f,c) end
    f.buf=initial_string
  end
end

DEBUG=false
function debug(f::Input_field)
  if !DEBUG return end
  werror(
         "pos=$(getcurx(f.win)-f.firstx) bufpos=$(f.bufpos) $(f.insert_mode ? "I" : "")buf<$(f.buf)>")
end

function faddch(f::Input_field,ch)
  #dump "faddch(#{ch}=#{ch.chr})pos=#{pos}."
  debug(f)
  if f.insert_mode f.buf=insertat(f.buf,f.bufpos+pos(f),Char(ch))
  elseif f.bufpos+pos(f)<=length(f.buf) f.buf[f.bufpos+pos(f)]=Char(ch)
  else f.buf*=Char(ch)
  end
  if pos(f)==f.length-1 incr(f)
  else waddch(f.win,ch)
  end
  showbuf(f)
  debug(f)
end

function chmode(f::Input_field,imode)
  f.insert_mode=imode
  curs_set(f.insert_mode ? 2 : 1)
end

function showbuf(f::Input_field)
  #dump "showbuf[#{@bufpos+pos}..]."
  save=getcurx(f.win)
  waddstr(f.win, f.buf[f.bufpos+pos(f):min(length(f.buf),f.bufpos+f.length-1)-1])
  clrtocol(f.win,f.firstx+f.length)
  if f.decor
    wmove(f.win.mv,x=f.firstx-1)
    waddch(f.win,f.bufpos>0 ? "\U00AB" : f.dbeg)
    wmove(f.win,x=f.firstx+f.length)
    waddch(f.win,f.buf.length>f.bufpos+f.length ? "\U00BB" : f.dend)
  end
  wmove(f.win,x=save)
end

# position in field
pos(f::Input_field)=getcurx(f.win)+1-f.firstx
    #dump "pos."

function incr(f::Input_field)
  #dump "incr."
  if pos(f)<f.length setpos(f,pos(f)+1)
  elseif f.overflow && length(f.buf)-f.bufpos>=f.length
    f.bufpos+=1
    wmove(f.win,x=f.firstx)
    showbuf(f)
    wmove(f.win,x=f.firstx+f.length-1)
  else beep()
  end
  debug(f)
end

function decr(f::Input_field)
  #dump "decr."
  if pos(f)>0 setpos(f,pos(f)-1)
  elseif f.overflow && f.bufpos>0 f.bufpos-=1;showbuf(f)
  else beep()
  end
  debug(f)
end

function setpos(f::Input_field,newpos)
  #dump "setpos(#{newpos})"
  if newpos>length(f.buf)-f.bufpos beep()
  else wmove(f.win,x=f.firstx+newpos-1)
  end
  debug
end

function process_event(f::Input_field,e)
  ex=e.x-getbegx(f.win)-f.firstx
  ey=e.y-getbegy(f.win)-f.firsty 
  #dump "event #{e.inspect}xy=#{ex},#{ey}"
  if !(ey==0 && 0<=ex<f.length) 
    leave(f);return nothing
  elseif !among(e,BUTTON1_PRESSED|BUTTON1_CLICKED)
    return -1
  else
    if !isdefined(f,:ss) enter(f) end
    setpos(f,ex+1)
    return -1
  end
end

deleteat(s::String,i)=s[1:i-1]*s[nextind(s,i):end] # delete ith char
insertat(s::String,i,c::Char)=s[1:i-1]*c*s[i:end] # insert before ith char
 
  # returns <-1>:event processed <key>:processed, do key now nil: not processed
function do_key(f::Input_field,c)
  if c==KEY_MOUSE
    e=getmouse()
    c=process_event(f,e)
    if isnothing(c) return false end
  elseif c==KEY_IC chmode(f,!f.insert_mode)
  elseif c== KEY_DC f.buf=deleteat(f.buf,f.bufpos+pos(f));showbuf(f)
  elseif c== KEY_LEFT decr(f)
  elseif c== KEY_RIGHT incr(f)
  elseif c== KEY_HOME f.bufpos=0;setpos(f,0);showbuf(f)
  elseif c== KEY_END f.bufpos=[f.buf.length-f.length,0].max;
   setpos(f,0);showbuf(f);setpos(f,f.length-1)
  elseif c in (KEY_BACKSPACE, 127) decr(f);do_key(f,KEY_DC)
  elseif c in  0:0x1b return false
  else
    if c>0xff return false end
    faddch(f,c)
  end
  true
end

function enter(f::Input_field)
  if !isdefined(f,:ss) f.ss=Save_cursor(f.win) end
  chmode(f,f.insert_mode)
end

function leave(f::Input_field)
  delete(f.ss)
end

# The next function  is an exemple of a  general field-editing function
# defined with the help of the above functions.
# returns fields content on enter, or nothing on esc
function input(f::Input_field)
# wrefresh(f.win);werror("before $(getcurx(f.win)) $(getcury(f.win))")
  while true
    c=0
    while true
      c=wgetch(f.win)
#     infohint("c=$c")
      if !do_key(f,c) break end
    end
    leave(f)
    if haskey(f,:act) c=f.act(c) end #act has first pick on input chars.
    if c==false continue end
    if c in (0x1b, KEY_MOUSE) return f.buf # should be nothing
    elseif c in (KEY_ENTER, KEY_CTRL('J')) return f.buf
    else beep()
    end
  end
end
