push!(opt.h,
  :ignore_endings=>Dict(:name=>"ignore_endings",
   :shortdesc=>"lines differing in endline convention are considered  equal",
   :longdesc=>"(if true accept as equal \\n in unix, \\r\\n in Windows, \\r in OSX, etc..)",
   :value=>false, :level=>RECOMPUTE_DIFFS),
  :ignore_blkseq=>Dict(:name=>"ignore_whitespace",
   :shortdesc=>"lines differing in whitespace are considered  equal",
   :longdesc=>"(if true leading  and trailing  blanks are ignored and other sequences
      of blanks compare equal to one blank).",
      :value=>false,:level=>RECOMPUTE_DIFFS),
  :ignore_blklin=>Dict(:name=>"ignore_blank_lines",
   :shortdesc=>"blank lines are ignored in comparisons.",
   :longdesc=>"",:value=>false,:level=>RECOMPUTE_DIFFS),
  :ignore_case=>Dict(:name=>"ignore_case",
   :shortdesc=>"lines  just differing in case are considered  equal",
   :longdesc=>"(if true, ignore upper/lower case differences.)",
   :value=>false,:level=>RECOMPUTE_DIFFS),
  :align=>Dict(:name=>"align",
   :shortdesc=>"find best alignment of lines in differing areas.",
   :longdesc=>"The comparison algorithm is applied character by character to
   lines in differing areas of a file to find the best alignment. This may
   make comparisons quite slow.",
   :value=>false,:level=>RECOMPUTE_DIFFS),
  :sync_size=>Dict(:name=>"h_sync_size",
   :shortdesc=>"nr identical items that 'h' algorithm needs find to resync.",
   :longdesc=>" Contrary to the normal algorithm which finds optimal diffs,
   'h' by default resyncs on 6 equal items. When  'h' gives mediocre output,
   increasing  this value may help.",
   :value=>6,:level=>RECOMPUTE_DIFFS),
  :h_treshold=>Dict(:name=>"h_treshold",
   :shortdesc=>"how many characters in a difference to use 'h' algorithm",
   :longdesc=>"",
   :value=>2000,:level=>RECOMPUTE_DIFFS),
  :h_range=>Dict(:name=>"h_range",
   :shortdesc=>"Length of  the longest  difference after  which 'h' can resync",
   :longdesc=>"The normal  algorithm  has  no  resync  limit. A  larger
     value  makes  'h' slower.",
     :value=>250,:level=>RECOMPUTE_DIFFS),
  :side_by_side=>Dict(:name=>"side_by_side",
   :shortdesc=>"show file comparison side by side",
   :longdesc=>"",
   :value=>true, :level=>RECOMPUTE_DIFFS),
  :showequal=>Dict(:name=>"showequal",
   :shortdesc=>"show equal lines in file comparison",
   :longdesc=>"",
   :value=>true, :level=>RECOMPUTE),
  :by_par=>Dict(:name=>"by_paragraph",
   :shortdesc=>"the comparison unit is paragraphs (instead of lines)",
   :longdesc=>"",
   :value=>false,:level=>RECOMPUTE_DIFFS))

function cleanforatt(s::String)
  s=replace(s,r"\r\n"=>"\n")
  replace(s,r"\r"=>"\n")
end

@ExtObj mutable struct Linepair
  l::Tuple{Pair{Int,Int},Pair{Int,Int}} # two pairs of lno=>1 or 2 telling which file
  match::Bool
  # d::Vector{Vector{Decor}} an optional field
  # scrlns a pair of vectors of scrln an optional field
end

# Linepair for ith line in a equal or differing range
function Linepair(ranges,i::Int,type::Symbol)
  Linepair(Tuple(map((1,2))do j
    if i<=length(ranges[j]) ranges[j].start+i-1=>j else 0=>j end
   end),type==:match, Dict{Symbol,Any}())
end

Linepair()=Linepair((0=>1,0=>2),true, Dict{Symbol,Any}())

abstract type AbstractDpick end

function decor(d::AbstractDpick,p::Linepair)
  if haskey(p,:d) return p.d end
  if p.match return p.d=fill([Decor(1,:NORM)],2) end
  if 0==lno(p,1) || 0==lno(p,2) return p.d=fill([Decor(1,:HL)],2) end
  a=content(d,p,1)
  b=content(d,p,2)
  p.d=line_diff(cleanforatt(a),cleanforatt(b))
#   log showd(a.cleanforatt,p.d[0])+"\n"+showd(b,p.d[1])+"\n"
  p.d
end

function Base.copy(p::Linepair,side)
  p.l=(p.l[side],p.l[side])
  p.match=true
  delete!(p,:d)
  if haskey(p,:scrlns)
    old=maximum(length.(p.scrlns))
    p.scrlns=(p.scrlns[side],p.scrlns[side])
    return maximum(length.(p.scrlns))-old
  end
end

function delete(p::Linepair,side)
  p.l=side==1 ? (0=>0,p.l[3-side]) : (p.l[3-side],0=>0)
  p.match=false
  delete!(p,:d)
  if haskey(p,:scrlns)
    old=maximum(length.(p.scrlns))
    p.scrlns=side==1 ? (empty(p.scrlns[side]),p.scrlns[3-side]) : (p.scrlns[3-side],empty(p.scrlns[side]))
    return maximum(length.(p.scrlns))-old
  end
end

lno(p::Linepair,i)=p.l[i][1]

@ExtObj mutable struct Dpickfold <: AbstractDpick
  names::Vector{String}
  contents::Tuple{Vector{String},Vector{String}}
  p::Pick_list
  lengths::Vector{Int}
  wd::Int
  ll::Int
  function Dpickfold(names::Vector{String},contents::Tuple{Vector{String},Vector{String}})
    d=new(names,contents);d.prop=Dict{Symbol,Any}();d
  end
end

function Dpickfold(v,n,t)
  # n=filenames t pairs of split-in-lines files v Linepairs
  d=Dpickfold(n,t)
  d.pairs=v
  d.lengths=map(i->count(x->!iszero(lno(x,i)),v),1:2)
  # line is the index in d.pairs, subline the index in p.scrlns
  list=@NamedTuple{line::Int64, subline::Int64}[]
  show_screen(d,list)
  for (i,p) in enumerate(v)
    p.scrlns=ntuple(2)do j
      ln=cleanforatt(content(d,p,j))
      lines=Scrln[]
      if !isempty(ln)
        start=1; nth=1; res=1
        while res!=nothing
          l=Scrln(i,nth,start)
          wmove(stdscr,0,0)
          res=attprint(stdscr,ln[start:end],d.textlen;opt...)
          if isnothing(res) l.lastch=ncodeunits(ln)
          else start=l.lastch=nextind(ln,res+start-2)
          end
          push!(lines,l)
          nth+=1
        end
      end
      lines
    end
    m=maximum(length.(p.scrlns))
    for j in 1:m push!(list,(line=i,subline=j)) end
  end
  d.p.s.list=list
# werror(string(list))
  d.p.s.showentry=function(s,i)
    if i>length(s.list) p=Linepair();k=0
    else j,k=s.list[i]; p=d.pairs[j]
    end
    decors=decor(d,p) # compute now since may affect p.t
    for side in 1:2
      if side==2
        if opt.side_by_side wmove(s.win,x=s.begx+d.wd)
        else wmove(s.win,getcury(s.win)+d.wd,s.begx)
        end
      end
      add(s.win,(i==d.p.sel_bar && side==gside) ? :BAR : (p.match ? :NORM : :HL))
      if iszero(lno(p,side)) || k>length(p.scrlns[side]) 
        add(s.win," "^d.lnowidth); 
        add(s.win,:BOX,i==d.p.sel_bar ? "▶" : ACS_(:VLINE))
        attprint(s.win," "^d.textlen,d.textlen;opt...)
      else
        l=p.scrlns[side][k]
        if l.nth==1 add(s.win,string(lno(p,side),pad=d.lnowidth))
        else        add(s.win,cpad("--",d.lnowidth))
        end
        add(s.win,:BOX,i==d.p.sel_bar ? "▶" : ACS_(:VLINE))
        ln=cleanforatt(content(d,p,side))[l.firstch:l.lastch]
        attprint(s.win,ln,d.textlen;:decor=>shift(decors[side],l.firstch-1),opt...)
      end
      add(s.win,:NORM)
    end
  end
  d
end

@ExtObj mutable struct Dpick<:AbstractDpick
  names::Vector{String}
  contents::Tuple{Vector{String},Vector{String}}
  p::Pick_list
  lengths::Vector{Int}
  offset::Int
  wd::Int
  ll::Int
  function Dpick(names::Vector{String},contents::Tuple{Vector{String},Vector{String}})
    d=new(names,contents);d.prop=Dict{Symbol,Any}();d
  end
end

function Dpick(v,n,t)
  d=Dpick(n,t)
  d.offset=0
  d.lengths=map(i->count(x->!iszero(lno(x,i)),v),1:2)
  show_screen(d,v)
# werror("diff computed")
  d.p.s.showentry=function(s,i)
    p=i>length(s) ? Linepair() : s.list[i]
#   log "<#{i}->#{p.inspect}>\n"
    decors=decor(d,p) # compute now since may affect p.t
    for j in 1:2
      if j==2
        if opt.side_by_side wmove(s.win,x=s.begx+d.wd)
        else wmove(s.win,getcury(s.win)+d.wd,s.begx)
        end
      end
      add(s.win,(i==d.p.sel_bar && j==gside) ? :BAR : (p.match ? :NORM : :HL))
      if !iszero(lno(p,j)) add(s.win,string(lno(p,j),pad=d.lnowidth))
      else add(s.win," "^d.lnowidth)
      end
      add(s.win,:BOX,i==d.p.sel_bar ? "▶" : ACS_(:VLINE))
      ln=content(d,p,j)
      ln=ln[nextind(ln,min(d.offset,length(ln))):end]
      cleanforatt(ln)
      attprint(s.win,ln,d.textlen;:offset=>d.offset,:decor=>decors[j],opt...)
      add(s.win,:NORM)
    end
  end
  d
end

function show_screen(d::AbstractDpick,v)
  d.lnowidth=max(2,length(string(maximum(length.(d.contents)))))
  d.changes=[0,0]
  background()
  l=LINES()-5;sy=2;sx=0
  if opt.side_by_side
    d.wd=div(COLS(),2)
    s=Scroll_list(stdscr,v;rows=l,begy=sy,begx=sx+1)
    s.s=map(i->Scrollbar(s.win;x=sx-2+d.wd+i*d.wd,begy=sy,rows=l),0:1)
    d.p=Pick_list(s)
    d.textlen=d.wd-4-d.lnowidth
    for i in 0:1
      shaded_frame(stdscr,sy-1,sx+i*d.wd,l+2,d.wd-1)
      mvadd(stdscr,sy-1,sx+1+d.lnowidth+i*d.wd,ACS_(:TTEE))
      mvadd(stdscr,sy+l,sx+1+d.lnowidth+i*d.wd,ACS_(:BTEE))
      printnormedpath(sy-1,sx+i*d.wd+1,d.names[i+1],d.wd-3)
    end
  else
    d.wd=div(l,2)+2
    s=Scroll_list(stdscr,v;rows=d.wd-3,cols=COLS()-3,begy=sy,begx=sx+1)
    s.s=map(i->Scrollbar(s.win,x=COLS()-2,begy=sy+i*d.wd,rows=div(l,2)-1),0:1)
    d.p=Pick_list(s)
    d.textlen=COLS()-4-d.lnowidth
    for i in 0:1
      shaded_frame(stdscr,sy-1+i*d.wd,sx,d.wd-1,COLS()-1)
      mvadd(stdscr,sy-1+i*d.wd,sx+1+d.lnowidth,ACS_(:TTEE))
      mvadd(stdscr,sy+d.wd-3+i*d.wd,sx+1+d.lnowidth,ACS_(:BTEE))
      printnormedpath(sy-1+i*d.wd,sx+1,d.names[i+1],COLS()-3)
    end
  end
  s.on_scroll=function(s)
    for i in 1:2
      show(s.s[i],nearestline(d,i,s.first),s.nbshown,length(s))
    end
  end
# s.on_scroll(s)
end

Base.pairs(d::Dpickfold)=d.pairs
Base.pairs(d::Dpick)=d.p.s.list
pair_at_scrln(d::Dpick,i)=pairs(d)[i]
pair_at_scrln(d::Dpickfold,i)=pairs(d)[d.p.s.list[i].line]
lno_at_scrln(d::AbstractDpick,i,side)=i>length(d.p.s) ? 0 : lno(pair_at_scrln(d,i),side)
# line of d at linepair p side j (or "" if absent line)
function content(d::AbstractDpick,p::Linepair,j)
  lno(p,j)==0 ? "" : d.contents[p.l[j][2]][lno(p,j)]
end

# nearest non-empty screen line to near
function nearestline(d::AbstractDpick,side,near=d.p.sel_bar)
  i=near
  while i>1 && iszero(lno_at_scrln(d,i,side)) i-=1 end
  while i<length(d.p.s) && iszero(lno_at_scrln(d,i,side)) i+=1 end
  i
end

# at what screenline is line n of gside
function screenline(d::Dpick,n)
  for i in eachindex(pairs(d)) if lno_at_scrln(d,i,gside)==n return i end end
  d.p.sel_bar
end
function screenline(d::Dpickfold,n)
  for i in eachindex(d.p.s.list) if lno_at_scrln(d,i,gside)==n return i end end
  d.p.sel_bar
end

function set_offset(d::Dpick,o)
  d.offset=max(0,o)
  show(d.p.s)
  indicator(d)
end

function do_key(d::Dpick,key,factor=1)
  if key==KEY_HOME set_offset(d,0)
  elseif key==KEY_END  set_offset(d,max(0,
    maximum(map(i->length(content(d,pairs(d)[d.p.sel_bar],i)),1:2))-d.textlen))
  elseif key in (KEY_RIGHT, Int('l')) set_offset(d,d.offset+factor)
  elseif key==KEY_LEFT set_offset(d,d.offset-factor)
  elseif key==KEY_CTRL_RIGHT set_offset(d.offset+10*factor)
  elseif key==KEY_CTRL_LEFT set_offset(d.offset-10*factor)
  else return do_key(d.p,key,factor)
  end
  true
end

do_key(d::Dpickfold,key,factor=1)=do_key(d.p,key,factor)

Base.match(d::AbstractDpick,i)=pair_at_scrln(d,i).match

next_line(d::Dpick,start=d.p.sel_bar)=start<length(d.p.s) ? start+1 : start

function next_line(d::Dpickfold,start=d.p.sel_bar)
  k=d.p.s.list[start].line;i=start
  while i<length(d.p.s) && d.p.s.list[i].line==k i+=1 end
  i
end

function Base.copy(d::AbstractDpick,side)
  p=pair_at_scrln(d,d.p.sel_bar)
  if p.match move_bar_to(d.p,next_line(d))
  else
    if lno(p,side)!=0
      delta=copy(p,side); d.changes[3-side]+=1
      if d isa Dpickfold && delta!=0
        m=maximum(length.(p.scrlns))
        k=d.p.s.list[d.p.sel_bar].line
        i=d.p.sel_bar-d.p.s.list[d.p.sel_bar].subline+1
        splice!(d.p.s.list,i:i+m-1-delta,map(j->(line=k,subline=j),1:m))
      end
      move_bar_to(d.p,next_line(d))
    else delete(d,1-side)
    end
  end
end

function delete(d::AbstractDpick,side)
  p=pair_at_scrln(d,d.p.sel_bar)
  if lno(p,side)!=0
    if lno(p,3-side)!=0 
      delta=delete(p,side);
      move_bar_to(d.p,next_line(d))
      if d isa Dpickfold && delta!=0
        m=maximum(length.(p.scrlns))
        k=d.p.s.list[d.p.sel_bar].line
        i=d.p.sel_bar-d.p.s.list[d.p.sel_bar].subline+1
        splice!(d.p.s.list,i:i+m-1-delta,map(j->(line=k,subline=j),1:m))
      end
      show(d.p)
    else 
      if d isa Dpickfold
        i=d.p.sel_bar-d.p.s.list[d.p.sel_bar].subline+1
        m=maximum(length.(p.scrlns))
        deleteat!(d.p.s.list,i:i+m-1)
        for j in i:length(d.p.s.list) 
          d.p.s.list[j]=(d.p.s.list[j].line-1,d.p.s.list[j].subline)
        end
      end
      deleteat!(pairs(d),d.p.sel_bar);
      show(d.p)
    end
    d.changes[side]+=1
  end
end

const vhelp="""
 The file comparison screen displays with line numbers the two files
 being compared side by side or "one above other" (if you toggle F4).

   Lines missing in one file are marked {HL     },
 differing areas in matched lines are marked {LDIFF this color}
 and equal areas in differing lines are marked {LEQ this color}.

                   {BOX  Moving around: }

 {HL Tab}           Move cursor to other file
 {HL ↑},{HL k}           Move cursor one line up
 {HL ↓},{HL <CR>},{HL j}      Move cursor one line down
 {HL PgUp},{HL ^B}       Move cursor one screen up
 {HL PgDn},{HL ^F},{HL Space} Move cursor one screen down
 {HL ^U}/{HL ^D}         Move cursor one half screen up/down
 {HL ^PgUp}         Goto beginning of files
 {HL ^PgDn},{HL \$}       Goto end of files
 {BOX n}{HL G}            Go to line {BOX n} (to end of files if no {BOX n} given)
 {HL ←}/{HL →}           Scroll one column left/right  (only if no folding)
 {HL ^←}/{HL ^→}         Scroll ten columns left/right (only if no folding)
 {HL Home}/{HL End}      Scroll all the way left/right (only if no folding)
 {HL +}             Goto next difference
 {HL -}             Goto previous difference


                    {BOX  Changing the display: }

 {HL F4}            Toggle between side-by-side/one above other display.
 {HL =}             Toggle between show/do not show equal lines.
 {HL f}             Toggle between fold/ do not fold lines.
 {BOX n}{HL t}            Set tab value to {BOX n} (no {BOX n} means stop tab interpretation)
 {HL E}             Toggle between empty space at end of lines visible/invisible.
 {HL T}             Toggle between tabs visible/invisible.

                    {BOX  Editing: }

   While making changes to the two files being compared, there is no undo,
   save or quit button per se; instead, when you leave the file comparison
   via {HL Esc} or 'Exit screen' on the File menu, you are asked if you want
   to save the changes that you have made to each file.

 {HL d},{HL Del}         Delete line under the cursor
 {HL c}             Copy line under the cursor to other file
 {HL e},{HL F5}          Call editor on current file at current line number.
               (See option menu for how to change the called editor).
 {HL v}             Call editor on both files in 2 windows at current line
               numbers. (See option menu to specify the appropriate command
               to call your editor with the options to do that).

                    {BOX  Miscellaneous: }

 {HL h},{HL F1}   Display this message
 {HL F9}            Shell escape.
 {HL Esc}           Goto previous menu.

                    {BOX  Mouse actions: }

  You can click on any menu item and on the arrows in the scroll bars.
  Clicking on a line sets the cursor there.
"""

global vmenu::Menu

function initvmenu()
  wmove(stdscr,0,0)
  cm=Menu(infohint)
  add(cm," &File ",
  ["&Edit\te,F5",'e',"Call editor on current file"],
  ["Edit &both\tv",'v',"Call editor on both current files"],
  ["&Delete line\tDel,d",'d',"Delete current line"],
  ["C&opy line\tc",'c',"Copy current line to other side"],
  "-",
  ["E&xit screen\tEsc",0x1b,"Exit current screen"])
  add(cm," &View ",
  ["&One above other\tF4",KEY_F(4),"Split screen vertically and show files side by side"],
  ["&Equal\t=",'=',"Show/do not show lines equal on both sides"],
  ["&Next  diff.\t+",'+',"Go to next difference"],
  ["&Prev. diff.\t-",'-',"Go to previous difference"],
  ["E&mpty space\tE",'E',"Make/do not make empty space at end of lines visible"],
  ["&Tabs\tT",'T',"Make/do not make tabs visible"])
  add(cm," &Options ",OPTMENU,COLORMENU,EDITMENU,EDITBOTHMENU,SAVEOPTMENU)
  add(cm,HELPMENU...,ABOUTMENU)
  global vmenu=cm
end

function next_diff(d::AbstractDpick)
  l=length(d.p.s)
  i=d.p.sel_bar
  while i<l && !match(d,i) i=next_line(d,i) end
  while i<l && match(d,i) i=next_line(d,i) end
  if i==l werror("no further difference") else move_bar_to(d.p,i) end
end

function prev_diff(d::AbstractDpick)
  i=d.p.sel_bar
  while i>=0 && !match(d,i) i-=1 end
  while i>=0 && match(d,i) i-=1 end
  if i<0 werror("no previous difference") else move_bar_to(d.p,i) end
end

function check_changes(d::AbstractDpick)
  for i in 1:2
    if d.changes[i]>0 && 'y'==ok("save $(d.changes[i]) changes made to $(d.names[i])?")
      pat,tf=mktemp()
      for p in pairs(d) if lno(p,i)!=0 write(tf,content(d,p,i)) end end
      close(tf)
      mv(pat,d.names[i];force=true)
    end
  end
  all(p->p.match,pairs(d))
end

function indicator(d::AbstractDpick)
  mvadd(stdscr,0,40,:BOX," modes: ",:HL)
  if opt.fold add(stdscr,"fold ") end
  if opt.showempty add(stdscr,"showempty ") end
  if opt.showtabs add(stdscr,"showtabs ") end
  add(stdscr,:BOX,"tab=",:HL,string(opt.tabsize),:BOX," ")
  if d isa Dpick && d.offset>0 add(stdscr,:BOX,"+",:HL,string(d.offset)) end
  add(stdscr,:BOX)
  clrtocol(stdscr,COLS()-2)
  refresh()
end

#  def process_event(e)
#    [0,1].each{|i|
#    if c=@s[i].process_event(e)
#      do_key(c)
#      return -1
#    end}
#    super
#  end

function process_event(d::AbstractDpick,e)
  if !among(e,BUTTON1_PRESSED|BUTTON1_RELEASED|BUTTON1_CLICKED) return nothing end
  c=process_event(vmenu,e)
  if !isnothing(c)
    if c isa Function c(); return -1
    else return c
    end
  end
# if !(d.p.s.begy<=e.y<=d.p.s.begy+d.p.s.rows-1 &&
#      among(e,BUTTON1_PRESSED|BUTTON1_CLICKED|BUTTON1_DOUBLE_CLICKED))
#   return nothing
# end
# global gside
# if d.panes[1]-1<=e.x<=d.panes[1]+d.pane_width gside=1
# elseif d.panes[2]-1<=e.x<=d.panes[2]+d.pane_width gside=2
# end
  c=process_event(d.p,e)
# if c==-1
#   if e.bstate==BUTTON1_DOUBLE_CLICKED return KEY_ENTER
#   else return -1
#   end
# end
end


function vdifff(a,b)
#  dd=nil
  initial_bar=1
#  while true do
  @label recompute_diffs
  try
    t=read.((a,b),String)
  catch e
    werror("$e reading files $a and $b")
    return
  end
  save=Savewin(stdscr)
  t=map(splitinlines,t)
#  Linepair.setfiles(t)
  initvmenu()
#  begin
  diffs=diff_report(t[1],t[2];
    info=l->infohint("comparing $l"),
    sampling=1000,
    ignored=l->opt.ignore_blklin && !isnothing(match(r"\A\s*\Z",l)),
    by=function(l)
      if opt.ignore_endings l=chomp(l) end
      if opt.ignore_blkseq l=stripspace(l) end
      l
    end)
  if opt.align
    diffs=map(diffs)do d
      if d[1]==:differ area_diff(t,d[2],d[3];info=infohint,opt...)
      else [d] end
    end
    diffs=vcat(diffs...)
  end
#  rescue Interrupt
#    error("File comparison interrupted")
#    return unless dd
#  end
  @label recompute_dd
  v=Linepair[]
  for (type,arange,brange) in diffs
    if !opt.showequal && type!=:differ continue end
    for i in 1:max(length(arange),length(brange))
      push!(v,Linepair((arange,brange),i,type))
    end
  end
  @label remake_dpick
  df=Dpickfold(v,[a,b],t)
  ds=Dpick(v,[a,b],t)
  global vmenu; refresh(vmenu)
  dd=(opt.fold || opt.by_par) ? df : ds
  show(dd.p.s)
# getch();werror("diffs=$v");return false
# length(dd)
  move_bar_to(dd.p,screenline(dd,initial_bar))
  indicator(dd)
  factor=0
  global gside
  function use_factor()
    f=iszero(factor) ? 1 : factor
    factor=0
    f
  end
  c=getch()
  while true
    if Int('0')<=c<=Int('9') factor=10*(factor)+c-Int('0')
    elseif c==KEY_MOUSE
      c=process_event(dd,getmouse())
      if c!=-1 && !isnothing(c) continue end
    elseif c in (Int('q'), 0x1b) 
      restore(save)
      return check_changes(dd)
      #    when ?F.ord then ungetch(KEY_ALT('F')); redo
    elseif c==KEY_CTRL('I') gside=3-gside;show(dd.p)
    elseif c==Int('c') copy(dd,gside)
    elseif c==Int('d') delete(dd,gside)
    elseif c in (Int('s'), KEY_F(4))
      opt.side_by_side=!opt.side_by_side
      old=nearestline(dd,gside)
      move_bar_to(dd.p,0)
      initial_bar=old
      show(dd.p)
      if opt.side_by_side
        Menus.install(vmenu.heads.v[2].items.v[1],"&One above other\tF4",
 	 "Split screen horizontally and show files one above the other")
      else
        Menus.install(vmenu.heads.v[2].items.v[1],"&Side by side\tF4",
 	 "Split screen vertically and show files side by side");
      end
      refresh(vmenu)
      @goto remake_dpick
    elseif c in (KEY_F(6), Int('o'))
      c=optionmenu()
      if c==RECOMPUTE @goto recompute_dd
      elseif c==RECOMPUTE_DIFFS
        check_changes(dd)
        if 'y'==ok("recompute differences (changes in options may have affected them)")
            @goto recompute_diffs
        end
      else show(dd.p)
      end
    elseif c==Int('f')
      toggle(opt,:fold)
#      old=dd
      @goto remake_dpick
#      dd.move_bar_to(dd.screenline(old.nearestline($side)))
     elseif c==Int('+') next_diff(dd)
     elseif c==Int('a') about()
     elseif c==Int('-') prev_diff(dd)
     elseif c==Int('=')
       opt.showequal=!opt.showequal
       @goto recompute_dd
     elseif  c in (KEY_F(5), Int('e'))
       initial_bar=nearestline(dd,gside)
       check_changes(dd)
       exec(make_edit_command([a,b][gside],initial_bar))
       @goto recompute_diffs
     elseif  c==Int('v')
       initial_bar=nearestline(dd,gside)
       check_changes(dd)
       exec(make_edit_both_command(a,b,map(i->nearestline(dd,i),1:2)...))
       @goto recompute_diffs
     elseif c in (Int('E'),Int('T'))
       toggle(opt,c==Int('E') ? :showempty : :showtabs)
       show(dd.p)
       indicator(dd)
    elseif c=='G' move_bar_to(dd,dd.screenline(use_factor()))
    elseif c in (KEY_F(1), Int('h'))
      whelp(vhelp,"file comparison screen")
    elseif !do_key(dd,c,use_factor())
      c=Menus.do_key(vmenu,c)
      if !isnothing(c)
        if c isa Function c()
        else continue
        end
      end
    end
    c=getch()
#  rescue Interrupt
#  end
#  end
  end
  restore(save)
end
