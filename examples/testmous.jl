using VisualDiff
using VisualDiff.Curses

#initial_im=Ncurses::WINDOW.instance_methods(false)
#initial_m=Ncurses.methods-Ncurses::WINDOW.methods
#initial_const=Ncurses.constants
#my_im=Window.instance_methods(false)-initial_im
#
#function CursesValue(k)
#  begin
#    Curses.module_eval(k.to_s)
#  rescue
#    Ncurses.module_eval(k.to_s)
#  end
#end
#
#function analyse_mask(m)
#  return "0" unless m
#  Curses.constants.grep(/BUTTON/).sort.
#    select{|k| (CursesValue(k)&m)!=0}.map{|x| x[6..-1]}
#end

# align nicely strings in l starting at cols divisible by n
function wrap(l,n,cols=80) 
  res=""
  col=0
  for s in l
   rab=n-col%n
   if rab==n && col==0 rab=0 end
   if rab==0 && col>0 rab=n end
   if col+rab>=cols res*=" "^(cols-col);col=0
   else res*=" "^rab;col+=rab
   end
   if col+length(s)>=cols res*=" "^(cols-col);col=0 end
   res*=s;col+=length(s)
  end
  res*"\n"
end
  
#mask=mousemask(ALL_MOUSE_EVENTS|REPORT_MOUSE_POSITION) unless WINDOWS or SOLARIS

#function show_csts(c,p,msg)
#  s=c.grep(p)
#  if s.length>0
#    stdscr.add(:BOX," ",msg,":\n",:NORM)
#    stdscr.add(wrap(s.sort.map{ |k| "#{k}=#{"x%x"%CursesValue(k)}"},8))
#  end
#  return c-s
#end

function show_meths(stdscr,c,msg)
  if length(c)>0
    add(:BOX," ",msg,":\n",:NORM,wrap(rpad.(c,10),10))
  end
end

#function show_const(c,msg)
#  c=c-c.grep(/^KEY_|^ACS/)
#  stdscr.add(:BOX,msg," constants (not ACS_, KEY_):\n",:NORM)
#  c=show_csts(c,/^BUTTON|MOUSE_/,"mouse")
#  c=show_csts(c,/^A_/,"attributes")
#  c=show_csts(c,/^WA_/,"Wattributes")
#  c=show_csts(c,/^COLOR_/,"colors")
#  c=show_csts(c,/^TRACE_/,"trace")
#  c=show_csts(c,/^LC_/,"collate")
#  stdscr.add(:BOX," other:\n",:NORM)
#  stdscr.add(wrap(c.sort.map{ |k|
#    v=CursesValue(k)
#    res="#{k}="
#    if v.class == Fixnum then 
#       v="x%x" % v if v>=0
#    else res<< "[#{v.class}]"
#    end
#    res+"#{v} "},8))
#end
#
#function show_keys(c,msg)
#  c=c.grep(/^KEY_/)
#  stdscr.add(:BOX,msg," KEY_ constants:\n",:NORM); i=0
#  stdscr.addstr(wrap(c.sort.map{ |k|
#    v=CursesValue(k)
#    if v==nil then "nil" else "#{k[4..-1]}=#{'%x' % v}" end
#  },8))
#end
#
#function show_methods(c,msg)
#  stdscr.add(:BOX,msg," methods:\n",:NORM); i=0
#  c=show_meths(c,/^w/,"window")
#  c=show_meths(c,/^slk_/,"slk")
#  c=show_meths(c,/^mv/,"mv")
#  c=show_meths(c,//,"other")
#end
#
#function show_events(m)
#  stdscr.addstr "Events registered:\n"
#  stdscr.add(wrap(MouseEvent.showmask(m).split("+"),8))
#end

function show_ACS(stdscr)
  add(:BOX," ACS constants:\n",:NORM)
  col=0
if Curses.TUI
  d=NCurses.acs_map_dict
else
  d=Curses.acs_map_dict
end
  for k in sort(collect(keys(d)))
    if col+12>COLS()
      add("\n")
      col=0 
    end
    add(lpad(k,9),"=",ACS_(k)," ")
    col+=12
  end
  add("\n")
end

function show_chars(stdscr)
  function doit()
    addstr(join(map(i->repr(UInt8(i%16))[end],0:31)," ")*"\n")
    for i in vcat(32:127,128+32:255)
     if i&31==0 addstr(repr(UInt8(i>>4))[end:end]) end
      addstr(" "*Char(i))
      if i&31==31 addstr("\n") end
    end
  end
  addstr("normal characters:\n  ")
  doit()
  addstr("ALTCHARSET characters:\n  ")
  attron(A_ALTCHARSET)
  doit()
  attroff(A_ALTCHARSET)
end

function show_const(names)
  n=map(x->"$x=$(repr(UInt16(eval(x))))\t",names)
  addstr(join(n))
end

function show_colors(stdscr)
  addstr("colors:\n")
  for i in 0:255
    add([Color.dos_to_att(0x70)," "],[Color.dos_to_att(i),"XX"])
    if i&15==15 addstr("\n") end
  end
  attroff(A_BLINK)
end

function menu(stdscr)
  curx=getcurx(stdscr)
  cury=getcury(stdscr)
  wmove(stdscr,0,0)
  add(:NORM,"maj=my[")
  add(:BOX,"c",:NORM,"onst ",:BOX,"m",:NORM,"eth ",:BOX,"a",:NORM,"CS")
  add(" ",:BOX,"k",:NORM,"EY]")
  add(" c",:BOX,"h",:NORM,"ars")
  add(" c",:BOX,"o",:NORM,"lors")
  add(" ",:BOX,"e",:NORM,"vents") 
  add(" ",:BOX,"q",:NORM,"uit")
  add(" ",:BOX,"O",:NORM,"k")
  add(" a",:BOX,"b",:NORM,"out")
  clrtoeol()
  wmove(stdscr,cury,curx)
  add(:NORM)
end

Base.string(m::MEVENT)="$id:$x,$y,$z:$bstate"

function main()
  initscr2()
  scrollok(stdscr,true)
  Color.init(:NORM=>"black on white",:BOX=>"red on white",
             :BAR=>"black on yellow",:BG=>"black on blue",
             :BLACK=>"white on black",:MTEXT=>"bright white on blue",
             :MKEY=>"bright yellow on blue")
  add(:NORM)
  clear()
  wmove(stdscr,1,0)
  curses_keys=filter(x->startswith("KEY")(string(x)) && !(eval(x) isa Function),names(Curses))
  while  true
    menu(stdscr)
    c=Char(getch())
    if c==Char(KEY_MOUSE) addstr("$(getmouse())\n")
    elseif c=='q' break
    elseif c=='h' show_chars(stdscr)
  #  when "e".ord then show_events(mask)
    elseif c=='o' show_colors(stdscr)
    elseif c=='c' show_meths(stdscr,names(NCurses),"NCurses names")
 #  elseif c=='C' show_const(my_const,"my")
    elseif c=='k' show_const(curses_keys)
 #  elseif c=='K'  show_keys(my_const,"my")
    elseif c=='a' show_ACS(stdscr)
    elseif c=='b' VisualDiff.about()
    elseif c=='S' dump(stdscr);addstr(" cols=$(COLS()) lines=$(LINES())")
    elseif c=='U' add(:MTEXT,"Bro",:MKEY,"w",:MTEXT,"se","   ","F3")
    elseif c=='O' 
       background()
       res=ok("testok");addstr(repr(Char(res)))
  #  when "A".ord then show_ACS(Curses.constants,"my")
  #  when "M".ord then show_methods(my_im,"my Curses::Window instance")
  #             show_methods(Curses.instance_methods(false),"my Curses instance")
  #  when "m".ord then show_methods(initial_m-initial_im,"Curses")
  #     show_methods(initial_im-initial_m,"Curses::Window instance")
  #     show_methods(initial_im&initial_m,"Both")
  else addstr("key=$(repr(UInt16(c)))=0o"*
              String('0'.+reverse(digits(Int(c);base=8)))*"=$c")
      if Int(c) in 417:442 addstr("=KEY_ALT_('$('A'+Int(c)-417)')\n")
      elseif Int(c) in 0:25 addstr("=KEY_CTRL_('$('A'+Int(c)-1)')\n")
      elseif Int(c) in 265:274 addstr("=KEY_F($(Int(c)-264))\n")
      else p=findfirst(x->Int(c)==eval(x),curses_keys)
        if !isnothing(p) addstr("=$(curses_keys[p])\n")
        else addstr("\n")
        end
      end
  #    if k=Curses.constants.grep(/^KEY_/).detect{|k| Curses.module_eval(k.to_s)==c}
  #         addstr "#{k}"
  #    elsif k=Curses.constants.grep(/k/).detect{|k| Curses.module_eval(k.to_s)==c}
  #         addstr "#{k}"
  #    else 
  #      begin
  #      addstr "<#{c.chr}>"
  #      rescue
  #      addstr "???"
  #      end
  #    end
  #    addstr " keyname=#{keyname(c)}" unless c>0xfffffff0 or (c>0x1a0 and c<0x1bb)
  #    addstr"\n"
    end
  end
  endwin()
end

#rescue  Interrupt =>exc 
#  stdscr.add("interrupt rescued")
#  refresh 
#rescue => e
#  def_prog_mode
#  close_screen
#  print "<#{e.message}> in\n#{e.backtrace.join("\n")}\n" unless SystemExit===e
#ensure
#  def_prog_mode
#  close_screen
#end
#end
