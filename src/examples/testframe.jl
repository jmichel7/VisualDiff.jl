include("../Curses.jl")

#function exit_msg(m=nil)
#  echo
#  nocbreak
#  nl
#  close_screen
#  print "testframe: "+m+"\n" if m
#  exit
#end

function main()
initscr2()
Color.init(
 :NORM=>"black on white",
 :BAR=>"black on yellow",
 :BOX=>"blue on white",
 :BG=>"black on blue") 
cbreak()
keypad(stdscr,true)
#mousemask(BUTTON1_PRESSED|BUTTON1_RELEASED|BUTTON1_CLICKED)
background()
res=ok("testok")
endwin()
@show res
#rescue Exception => e
#exit_msg("<#{e.message}> in\n#{e.backtrace.join("\n")}")
end
