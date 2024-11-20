includet("../Curses.jl")

#def exit_msg(m=nil)
#  echo
#  nocbreak
#  nl
#  close_screen
#  print "testall: "+m+"\n" if m
#  exit
#end

function main(dir=".")
  initscr2()
# raw
  noecho()
  keypad(stdscr,true)
  Color.init(:NORM=>"black on white", 
             :HL=>"red on white", 
             :BOX=>"blue on white", 
             :C1=>"yellow on white", 
             :C2=>"green on white", 
             :C3=>"bright yellow on blue", 
             :C4=>"blue on red", 
             :C5=>"yellow on red", 
             :C6=>"green on white", 
             :C7=>"bright yellow on blue", 
             :C8=>"blue on red", 
             :C9=>"yellow on red")
  for n in filter(contains(".ha"),readdir(dir))
    whelp(read(n,String),n)
  end
  endwin()
end

#main(ARGS)
#exit_msg
#rescue Exception => e
#exit_msg("<#{e.message}> in\n#{e.backtrace.join("\n")}")
