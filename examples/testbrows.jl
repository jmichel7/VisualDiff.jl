using VisualDiff
using VisualDiff.Curses

function main(ARGS)
  initscr2()
  Color.init( 
  :NORM=>"black on white", 
  :BOX=>"blue on white", 
  :HL=>"bright red on white", 
  :MENU=>"bright yellow on blue ", 
  :BAR=>"bright yellow on red",
  :GREY=>"yellow on white", 
  :MTEXT=>"bright white on blue ", 
  :MKEY=>"bright yellow on blue ", 
  :BG=>"black on cyan", 
  :ABSENT=>"yellow on green", 
  :DIFF=>"cyan on white",
  :EMPTY=>"yellow on blue ", 
  :LDIFF=>"blue on white", 
  :TAB=>"white on magenta",
  :LEQ=>"red on blue",
  :BLACK=>"black on black")
  for f in ARGS browse_file(f) end
  endwin()
end
