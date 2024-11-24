struct Button
  win::Ptr{WINDOW}
  key::Int
  x::Int  # coordinates used just for
  y::Int  # mouse action
  ex::Int #
end

# returns <key>:  event in button
#     <nothing>:  not in button
function process_event(b::Button,e)
  if (e.bstate & BUTTON1_CLICKED|BUTTON1_RELEASED)!=0 && e.y==b.y && b.x<=e.x<=b.ex
    b.key 
  end
end

function Button(key::NCurses.jlchtype,text,win=stdscr)
  # printa text at win.curx and associates key
  x=getcurx(win)+getbegx(win)
  y=getcury(win)+getbegy(win)
  if text isa String printa(win,text)
  elseif text isa Array wadd(win,text...)
  end
  ex=getbegx(win)+getcurx(win)-1
  Button(win,key,x,y,ex)
end

#function inspect(b::Button)
#  "<%c>"%@key+"#{@y}:#{@x}..#{@ex}"
#end
