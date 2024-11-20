function  about()
  width=53;height=14
  left=div(COLS()-width,2)
  top=div(LINES()-height,2)
  s=Shadepop(top-1,left-1,height+2,width)
  mvadd(stdscr,top-1,left-1,:BOX);center(stdscr," About ",width)
  mvadd(stdscr,top+height,left-1,:BOX);
  center(stdscr," hit any key or click to continue... ",width)
  i=top+1
  for l in eachsplit("""
┬      ┬ ─┬─────┐    ┬    ┌──────┐   ┌──────┐ 
│▒     │▒ │▒▒▒▒▒│▒   │▒   │▒▒▒▒▒▒┴▒  │▒▒▒▒▒▒┴▒
│▒     │▒ │▒    │▒   │▒   ├───    ▒  ├───    ▒
│▒     │▒ │▒    │▒   │▒   │▒▒▒▒      │▒▒▒▒    
 \\    /   │▒    │▒   │▒   │▒         │▒       
   ───   ─┴─────┘▒   ┴▒   ┴▒         ┴▒       
   ▒▒▒    ▒▒▒▒▒▒▒▒    ▒    ▒          ▒        
""","\n")
    wmove(stdscr,i,left+1)
    for t in l
     add(stdscr,(Int(t) in 0x2500:0x2580 || t in ('\\','/')) ? :BOX : :NORM,string(t))
    end
    i+=1
  end
  mvadd(stdscr,i,left+1,:BOX);center(stdscr,"The Comparison Tool",width)
  add(stdscr,:NORM)
  i+=2
  for t in eachsplit("""
  github.com/jmichel7/vdiff     © Jean Michel  
  Julia $VERSION, NCurses, Version 0.1α october 2024
  ""","\n")
    mvadd(stdscr,i,left+1,t)
    i+=1
  end
  getch()
  restore(s)
end

ABOUTMENU=["&About",about,"About vdiff"]
