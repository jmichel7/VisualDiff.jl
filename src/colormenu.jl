# show color picker window
function pickcolor(ypos,color=0)
  r=2+16; ypos=min(ypos,LINES()-r-1)
  c=2+8*6; xpos=min(10,COLS()-c-1)
  save=Shadepop(ypos,xpos,r,c)
  curs_set(0)
  mvadd(stdscr,ypos+r-1,xpos+1,"Select: ")
  buttons=[Button(KEY_ENTER,"{HL Enter}")]
  addstr(" or double-click, ")
  push!(buttons,Button(0x1b,"{HL Esc} to quit"))
  s=Scroll_list(stdscr,collect(1:128);rows=r-2,cols=c-1,begy=ypos+1,begx=xpos+1,nbcols=8)
  p=Pick_list(s)
  s.showentry=function(s,i)
    add(s.win,:BOX,(i==p.sel_bar ? "▶" : " "),[Color.dos_to_att(i-1),"XX"])
    wattroff(s.win,Color.dos_to_att(i-1))
    add(s.win,:BOX,(i==p.sel_bar ? "◀" : " "))
  end
  p.on_move_bar=function()
    mvadd(stdscr,s.begy-1,s.begx+1,rpad(Color.dos_to_lit(p.sel_bar-1),25),
          repr(UInt8(p.sel_bar-1),context=:limit=>true))
  end
  move_bar_to(p,Color.att_to_dos(color)+1)
  show(p)
  c=getch()
  color=nothing
  while true 
    if c in (0x1b, Int('q')) break
    elseif c in (KEY_ENTER, KEY_CTRL('J'))
      color=Color.dos_to_att(p.sel_bar-1);break
    elseif c==KEY_MOUSE
      e=getmouse()
      if any(buttons) do b
          c=process_event(b,e)
          !isnothing(c)
        end
        continue
      end
      c=process_event(p,e)
      if !isnothing(c) && e.bstate==BUTTON1_DOUBLE_CLICKED
        c=KEY_ENTER
        continue
      end
    elseif !do_key(p,c) beep()
    end
    c=getch()
  end
  restore(save)
  color
end

using OrderedCollections: OrderedDict
#---------------------------------------------------------------------
const colors=OrderedDict(
 :NORM=>
 Dict( :name=>"normal_text",
   :desc=>"Normal text",
   :example=>["This is normal text"],
  ),
 :BOX=>
 Dict( :name=>"lines_boxes",
   :desc=>"Lines and frames",
   :example=>["         ",:BOX,"\U2514"*"\U2500"^7,:NORM]
  ),
 :HL=>
 Dict( :name=>"highlighted_text",
   :desc=>"Highlighted text: some titles, comparison mark, warning text, etc...",
   :example=>[:HL,  "Warning: Low on memory           " ,:NORM]
  ),
 :LDIFF=>
 Dict( :name=>"differring_areas",
   :desc=>"Differing areas in matched lines",
   :example=>[:LEQ," lines equal excepted ",:LDIFF,"here",:LEQ," they  " ,:NORM]
  ),
 :MTEXT=>
 Dict( :name=>"menu_text",
   :desc=>"Key explanations in menu lines",
   :example=>[:MENU, "F1" ,:MTEXT, "Help " ,:MENU, "Grey +" ,:MTEXT,
   " next diff " ,:MENU, "Grey -" ,:MTEXT, " pr" ,:NORM]
  ),
 :BAR=>
 Dict( :name=>"selection_bar",
   :desc=>"Selection bar in the directory and file displays and in menus",
   :example=>[:BAR, "14:56:50",:HL," # ",:BOX," - absent ",:BAR,"          ",:NORM]
  ),
 :EMPTY=>
 Dict( :name=>"empty_space",
   :desc=>"Empty space after end of lines when option 'E' active",
   :example=>["end of line." ,:EMPTY, "                     " ,:NORM]
  ),
 :TAB=>
 Dict( :name=>"tabs",
   :desc=>"Tabs in the browser when option 'T' is active",
   :example=>[:TAB,"   ",:NORM,"34",:TAB,"   ",:NORM,"243",:TAB,"  " ,:NORM, "2312"]
  ),
 :DIFF=>
 Dict( :name=>"unmatched_text",
   :desc=>"Unmatched lines in file display",
   :example=>[:DIFF, " this line differs from the other" ,:NORM],
  ),
 :LEQ=>
 Dict( :name=>"equal_areas",
   :desc=>"Equal areas in matched lines",
   :example=>[:LEQ, " lines equal excepted " ,:LDIFF, "here" ,:LEQ," they " ,:NORM],
  ),
 :MENU=>
 Dict( :name=>"menu_keys",
   :desc=>"Menu keys",
   :example=>[:MENU, "F1" ,:MTEXT, "Help " ,:MENU, "Grey +" ,:MTEXT,
   " next diff " ,:MENU, "Grey -" ,:MTEXT, " pr" ,:NORM],
  ),
 :ABSENT=>
 Dict( :name=>"absent_lines",
   :desc=>"Absent lines in the file comparison menu",
   :example=>[:ABSENT, "                                 " ,:NORM],
  ),
 :GREY=>
 Dict( :name=>"greyedout_items",
   :desc=>"Greyed out items, absent lines in directory menu",
   :example=>[:GREY,   " -- absent --                    " ,:NORM],
  ),
 :MKEY=>
 Dict( :name=>"menu_bar_info_text",
   :desc=>"info text in menu bars",
   :example=>[:MKEY, " Microsoft compatible mouse found" ,:NORM],
  ))

const schemes=[
  Dict( :name=>"Default theme",
    :desc=>"Default color theme",
    :value=>OrderedDict( :NORM=>"black on white",
	       :BOX=>"blue on white",
	        :HL=>"bright red on white",
	      :MENU=>"bright yellow on blue",
	       :BAR=>"bright white on red",
	      :GREY=>"yellow on white",
	     :MTEXT=>"bright white on blue",
	    :MTEXT1=>"bright white on cyan",
	      :MKEY=>"bright yellow on blue", 
	        :BG=>"black on cyan",
	    :ABSENT=>"yellow on green",
	      :DIFF=>"red on white",
	     :EMPTY=>"yellow on blue",
	     :LDIFF=>"red on white",
	       :LEQ=>"bright black on white",
	       :TAB=>"white on magenta",
               :BLACK=>"white on black")),
 Dict( :name=>"\"Visible\" theme",
   :desc=>"Default color theme modified to make visible empty space and differences in whitespace.",
   :value=>OrderedDict( :NORM=>"black on white",
	     :BOX=>"blue on white",
	     :HL=>"bright red on white",
	     :MENU=>"bright yellow on blue",
	     :BAR=>"bright yellow on red",
	     :GREY=>"yellow on white",
	     :MTEXT=>"bright white on blue",
	     :MTEXT1=>"bright white on cyan",
	     :MKEY=>"bright yellow on blue", 
	     :BG=>"black on cyan",
	     :ABSENT=>"yellow on green",
	     :DIFF=>"bright red on white",
	     :EMPTY=>"yellow on yellow",
	     :LDIFF=>"red on yellow",
	     :LEQ=>"black on yellow",
             :TAB=>"yellow on black")),
 Dict( :name=>"Dark theme",
   :desc=>"A dark theme for vdiff.",
   :value=>OrderedDict(:NORM=>"white on black",
    :BOX=>"bright cyan on black",
    :HL=>"red on black",
    :MENU=>"yellow on black",
    :BAR=>"blue on white", 
   :GREY=>"red on white",
   :MTEXT=>"black on yellow",
   :MTEXT1=>"blue on black",
   :MKEY=>"black on cyan", 
   :BG=>"black on cyan",
   :ABSENT=> "black on yellow",
   :DIFF=> "white on blue",
   :EMPTY=> "black on blue", 
   :LDIFF=>"black on black",
   :LEQ=>"blue on cyan",
   :TAB=>"white on magenta"))
]

colorkey(i)=collect(keys(colors))[i]
mypar(s,l)=replace(par(s,l;sep=""),"\n"=>"")

function colormenu()
  bkgd(Color.get_att(:NORM))
  ypos=0
  ls=length(schemes)
  lg=length(colors)+ls+1
  swin=Shadepop(ypos,1,lg+2,57,Color.get_att(:BOX))
  curs_set(0) # C_INVIS
  width=max(maximum(s->length(s[:name]),schemes),
            maximum(s->length(s[2][:name]),colors))
  s=Scroll_list(stdscr,collect(1:lg);rows=lg,cols=width,begy=ypos+1,begx=2)
  p=Pick_list(s)
  s.showentry=function(s,i)
    if i<=ls text=schemes[i][:name]
    elseif i==ls+1 text=""
    else text=colors[colorkey(i-ls-1)][:name]
    end
    add(s.win,i==p.sel_bar ? :BAR : :BOX,text," "^(width-length(text)))
    if i>ls+1 add(s.win,colorkey(i-ls-1),"x",:NORM) end
  end
  explwin=derwin(stdscr,lg,35,ypos+1,22)
  p.on_move_bar=function()
    wmove(explwin,6,0);wclrtobot(explwin)
    if p.sel_bar<=ls waddstr(explwin,mypar(schemes[p.sel_bar][:desc],35))
      mvadd(explwin,1,16,"select scheme")
    elseif p.sel_bar>ls+1
      color=colors[colorkey(p.sel_bar-ls-1)]
      waddstr(explwin,mypar(color[:desc],35))
      mvadd(explwin,11,0,:HL)
      center(explwin,"Example")
      mvadd(explwin,12,0,:NORM,color[:example]...)
      mvadd(explwin,1,16,"change color ")
    end
    refresh()
    wrefresh(explwin)
  end
  buttons=[]
  function init()
    show(p)
    buttons=[]
    add(explwin,:NORM)
    mvadd(stdscr,ypos,5,:BOX,"press ")
    push!(buttons,Button(0x1b,"{HL Esc}"))
    add(stdscr," or ");push!(buttons,Button(KEY_F(10),"{HL F10}"))
    add(stdscr," to return")
    mvadd(explwin,0,0,:NORM,"Select with ")
    push!(buttons,Button(KEY_UP,"{HL ↑}",explwin))
    add(explwin,"/")
    push!(buttons,Button(KEY_DOWN,"{HL ↓}",explwin))
    add(explwin,". Press ")
    push!(buttons,Button(KEY_CTRL('J'),"{HL Enter}",explwin))
    add(explwin," or\nDouble Click to select scheme")
    mvadd(explwin,5,0,:HL)
    center(explwin,"Description")
    add(explwin,:NORM)
  end
  init()
  while true
    show(p)
 #  mousemask(BUTTON1_CLICKED|BUTTON1_DOUBLE_CLICKED)
    c=getch()
    while true
      @label continuing
      if c==KEY_MOUSE
        e=getmouse()
        for b in buttons
          c=process_event(b,e)
          if !isnothing(c) @goto continuing end
        end
        c=process_event(p,e)
        if !isnothing(c) && e.bstate==BUTTON1_DOUBLE_CLICKED
          c=KEY_ENTER; continue
        end
      elseif c in (0x1b, Int('q'), KEY_F(10)) 
        restore(swin);delwin(explwin); return
      elseif c in (KEY_ENTER, KEY_CTRL('J'))
	if p.sel_bar>ls+1
          color=colorkey(p.sel_bar-ls-1)
          c=pickcolor(lg+1,Color.get_att(color))
          if !isnothing(c)
            Color.atts[color]=c;p.on_move_bar();show(s)
          end
        elseif p.sel_bar<=ls
	  Color.init(schemes[p.sel_bar][:value]...)
          init() #return
	end
      elseif !do_key(p,c) beep()
      end
      c=getch()
    end
  end
end

COLORMENU=["&Colors",colormenu,"Edit colors and color schemes used in vdiff"]
