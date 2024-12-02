using VisualDiff
using VisualDiff.Curses

function main()
  initscr2()
  Color.init(
   :NORM=>"black on white",
   :BAR=>"black on yellow",
   :BOX=>"blue on white",
   :BG=>"black on blue") 
  cbreak()
  background()
  res=ok("testok")
  endwin()
  @show res
end
