using Vdiff
using Vdiff.Curses

function main(dir=".")
  initscr2()
# raw
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
