# the following are global variables deliberately to persist between Vdir_pick
global gside::Int=1 # which side is the cursor in
global show_filter::String="=lr<>?" # what items to show

const vdhelp="""
  This  screen displays two  directories being compared,  lined up by name.
  The size and the date of each entry are shown in the panels.
  The  central  column shows: 
    {HL =} if the entries are equal (subject to the current options), 
    {HL >} if they differ and the left entry is more recent,
    {HL <} if they differ and the right entry is more recent,
    {HL l} if the entry is present only in the left  directory,  
    {HL r} if the entry is present only in the right directory,
    {HL ?} if the entries have not yet been recursively compared.
  If a name is too wide to be entirely displayed in the central column, the
  keys {HL →} and {HL ←} will scroll right and left that name.

             {BOX  Moving around: }

  {HL Tab}           Move selection bar to the other directory.
  {HL ↑},{HL k}           Move selection bar one line up.
  {HL ↓},{HL j}           Move selection bar one line down.
  {HL PgUp}          Move selection bar one screen up.
  {HL PgDn},{HL ^F},{HL Space} Move selection bar one screen down.
  {HL ^U}/{HL ^D}         Move selection bar one half-screen up/down.
  {HL ^PgUp},{HL Home}    Go to top of directory display.
  {HL ^PgDn},{HL \$},{HL End}   Go to bottom of directory display.
  {HL +}             Go to the next entries which differ.
  {HL -}             Go to the previous entries which differ.

             {BOX  Changing the display: }

  {HL F4}            Toggle between: show a full comparison of the directories/
                 show only entries present in both and unequal.
  {HL =}             Toggle between: show/don't show equal entries.
  {HL l}             Toggle between: show/don't show entries only on left.
  {HL r}             Toggle between: show/don't show entries only on right.
  {HL >}             Toggle between: show/don't show entries newer on left.
  {HL <}             Toggle between: show/don't show entries newer on right.
  {HL AltN}          Sort entries alphabetically. Sorting again reverses order.
  {HL AltE}          Sort entries by extension.
  {HL AltS}          Sort entries by size in current column.
  {HL AltT}          Sort entries by time in current column.

             {BOX  Acting on the files in the display: }

  {HL Enter}         Compare the current entries, or, if the other entry is
                 absent, browse the current entry.
  {HL R}             Recursively compare the current directory entries.
  {HL F3}            Browse the current entry.
  {HL Del},{HL d}         Delete the current entry.
  {HL c}             Copy the current entry to the other directory. 
  {HL C}             Copy non-recursively the current entry to the other 
                 directory, that is copy directories but not their contents.
  {HL e},{HL F5}          Call editor on current file.
               (the command to do that can be specified in the option menu).
  {HL v}             Call editor on both files in 2 windows.
               (the command to do that can be specified in the option menu)

             {BOX  Miscellaneous: }

  {HL h},{HL F1}          Display this message
  {HL x},{HL F9}          Escape to the Shell.
  {HL Esc},{HL q}         Exit this screen.

             {BOX  Mouse actions: }

   You can click on any menu item, and on the arrows in the scroll bars.
   Clicking on an entry sets the cursor there. Double-clicking on an entry
   does the same as Enter.  
   You can click on {HL name}, {HL ext}, {HL size} or {HL date} to sort accordingly.
   The menus are also accessible by {HL Alt}+highlighted letter.
"""

push!(opt.h,
:onlylength=>Dict(:name=>"just_size",
  :shortdesc=>"files are assumed identical if they have same size.",
  :longdesc=>"This  leads  to  the  fastest  possible  directory  comparison  in
   exchange  for  uncertainty  in  the  correctness of the comparison.",
  :value=>false,
  :level=>OK),
:length_and_timestamp=>Dict(:name=>"just_size_and_timestamp",
:shortdesc=>"files are assumed identical if they have same size and timestamp.",
:longdesc=>"This  leads  to  a  fast  directory  comparison  in exchange  for
some small uncertainty in the  correctness of the comparison. This option  can
 be very useful when comparing directory trees across slow networks or drives.",
:value=>true,
:level=>OK)
)

# can be added son if recursively examining
@ExtObj mutable struct PathPair  
  filename::String
  cmp::Char
  f::NTuple{2,Union{Base.Filesystem.StatStruct,Nothing}}
  PathPair(filename,cmp,f)=new(filename,cmp,f,Dict{Symbol,Any}())
end

function PathPair(d0::String,f0::Union{String,Nothing},
                  d1::String,f1::Union{String,Nothing})
  hasf0=!isnothing(f0)
  hasf1=!isnothing(f1)
  if hasf0
    filename=f0
    stat0=stat(joinpath(d0,f0))
  end
  if hasf1
    filename=f1
    stat1=stat(joinpath(d1,f1))
  end
  if hasf0 && hasf1
    if myisdir(stat0)!=myisdir(stat1) cmp=stat0.mtime>stat1.mtime ? '>' : '<'
    else cmp='?'
    end
  else cmp=hasf0 ? 'l' : 'r'
  end
  PathPair(filename,cmp,(hasf0 ? stat0 : nothing,hasf1 ? stat1 : nothing))
end

# sorted arrays -- return 2-tuples (entry|nothing,entry|nothing)
function merge_sorted(a::AbstractVector,b::AbstractVector;by=identity)
  i=1;j=1
  res=Tuple{Union{eltype(a),Nothing},Union{eltype(b),Nothing}}[]
  while i<=length(a) && j<=length(b)
    if by(a[i])<by(b[j]) push!(res,(a[i],nothing));i+=1
    elseif by(a[i])>by(b[j]) push!(res,(nothing,b[j]));j+=1
    else push!(res,(a[i],b[j]));i+=1;j+=1
    end
  end
  while i<=length(a) push!(res,(a[i],nothing));i+=1 end
  while j<=length(b) push!(res,(nothing,b[j]));j+=1 end
  res
end

" returns a Vector{PathPair} from two dirs and use old info"
function pairs_from_dirs(dir1::String,dir2::String,old)
  left=sort!(readdir(dir1))
  right=sort!(readdir(dir2))
  pairs=map(x->PathPair(dir1,x[1],dir2,x[2]),merge_sorted(left,right))
  if isnothing(old) return pairs end
  sort!(old;by=x->x.filename)
  # copy still-valid comparison info from old pairs
  for (n,o) in merge_sorted(pairs,old;by=x->x.filename)
    if !isnothing(o) && n.cmp=='?' && o[1]==n[1] && o[2]==n[2]
      n.cmp=o.cmp
      if haskey(o,:son) n.son=o.son end
    end
  end
  pairs
end

Base.getindex(p::PathPair,i)=p.f[i]

Base.setindex!(p::PathPair,s,i)=p.f=i==1 ? (s,p.f[2]) : p.f=(p.f[1],s)

function printsz(s::Union{Base.Filesystem.StatStruct,Nothing},width::Integer)
  if isnothing(s) return " "^width  end
  res=""
  if iszero(s.mode&Base.Filesystem.S_IRUSR)
    width-=1
    res*="r"
  end
# int i=0;if(flg&S_IFSYS)i++;if(flg&S_IFHID)i+=2;
# if(i){lg--;pos+=sprintf(pos,"%c",(unsigned char)"\0\xb0\xb1\xb2"[i]);}
  if myisdir(s) res*=lpad("< DIR >",width)
  else res*=lpad(nbK(s.size),width)
  end
  res
end

function printtm(s::Union{Base.Filesystem.StatStruct,Nothing},width::Integer)
  if isnothing(s) return " "^width  end
  d=DateTime(Libc.TmStruct(s.mtime))
  if width>=18 Dates.format(d,"dd u yy HH:MM:SS")
  elseif width>=15 Dates.format(d,"dd u yy HH:MM")
  else Dates.format(d,"dd u yy")
  end
end

# suppress initial and final spaces; reduce sequences of spaces to 1
function stripspace(s::String)
  res=Char[]
  inspace=true
  for c in s
    if isvalid(c) && isspace(c) if !inspace push!(res,' '); inspace=true; end
    else push!(res,c); inspace=false
    end
  end
  if inspace && !isempty(res) String(res[1:end-1])
  else String(res)
  end
end

function higher_compare(n0::String,n1::String;show=false,options...)
  eqsize=
  try
    filesize(n0)==filesize(n1)
  catch e
    werror("$e")
    return false
  end
  peq=if opt.onlylength || !eqsize eqsize
  else
    t=abs(round(Int,mtime(n0))-round(Int,mtime(n1)))
    eqtime=(t<=3600*9 && t%3600 in [-1,0,1])
    opt.length_and_timestamp && eqtime
  end
  if !show && peq newcmp=true
  else newcmp=compare_files(n0,n1;probably_equal=peq,info=infohint)
  end
  if show
    if newcmp werror("files are identical")
    else newcmp=vdifff(n0,n1;options...)
    end
  end
  newcmp
end

# compare files using options in opt
# ignore_endings => ignore different endings mac/linux/windows
# ignore_blkseq => ignore differences in whitespace in same line
# ignore_blklin => ignore blank lines
# ignore_case => ignore case differences
function compare_files(n0::String,n1::String;info::Function=println,
                                             probably_equal=false)
  hint(m)=info("$(basename(n0)):$(nbK(m)) compared")
  newcmp=true
  sz=0
  try
    a=open(n0);b=open(n1)
    if !any(o->getproperty(opt,o),(:ignore_endings,:ignore_blkseq,:ignore_blklin,:ignore_case))
      if opt.length_and_timestamp && probably_equal newcmp=true
      else
      while !eof(a) && !eof(b)
        l1=read(a,BLOCKSIZE)
        l2=read(b,BLOCKSIZE)
        if l1!=l2 newcmp=false;break end
        sz+=BLOCKSIZE
        hint(sz)
      end
      newcmp=eof(a)==eof(b) && newcmp
      end
    else
      low(s)=all(isvalid,s) ? lowercase(s) : s
      prev=0
      while !eof(a) && !eof(b)
        l1=readline(a)
        l2=readline(b)
        if opt.ignore_endings l1=chomp(l1);l2=chomp(l2) end
        if opt.ignore_blkseq l1=stripspace(l1);l2=stripspace(l2) end 
        if opt.ignore_case l1=low(l1);l2=low(l2) end
        if l1!=l2 newcmp=false;break end
        sz+=length(l1)
        if sz-prev>BLOCKSIZE hint(sz);prev=sz;end
      end
      newcmp=eof(a)==eof(b) && newcmp
    end
    close(a);close(b)
  catch e
    werror("$e doing compare")
    return false
  end
  newcmp
end
 
function Base.show(io::IO,f::PathPair)
  print(io,"(",join(map(x->isnothing(x) ? "-" : myisdir(x) ? 'D' : 'F',f.f),""),f.cmp,")",f.filename)
end

function extension(p::PathPair)
  m=match(r"\.([a-zA-Z_]*)$",p.filename)
  isnothing(m) ? "" : m[1]
end

global vdmenu::Menu
function initvdmenu() #setup menu
  if !isdefined(Main,:dmenu) 
  wmove(stdscr,0,0)
  cm=Menu(infohint)
  add(cm," &File ",
    ["&Compare\tEnter",KEY_ENTER,"Compare the files/directories at cursor"],
    ["&Recursively compare\tR",'R',"Recursively compare the directories at cursor"],
    ["&Edit\te,F5",'e',"Call editor on current file"],
    ["Edit &both\tv",'v',"Call editor on both current files"],
    ["&Delete\tDel,d",'d',"Delete current file"],
    ["C&opy\tc",'c',"Copy current file to other side"],
    ["Bro&wse\tF3",KEY_F(3),"Browse current file"],
     "-",
    ["E&xit screen\tEsc",0x1b,"Exit current screen"])
  add(cm," &View ",
    [show_filter=="<>?" ? "&Full compare\tF4" : "&Common unequal\tF4",KEY_F(4),
     show_filter=="<>?" ?
	    "Show a full comparison of the directories" :
            "Show only files common to both sides and different"],
    ["&Equal\t=",'=',"Show/do not show files equal on both sides"],
    ["Only on &left\tl",'l',"Show/do not show files present only on left"],
    ["Only on &right\tr",'r',"Show/do not show files present only on right"],
    ["&Newer on left\t>",'>',"Show/do not show files more recent on left"],
    ["Ne&wer on right\t<",'<',"Show/do not show files more recent on right"])
  add(cm," &Options ",OPTMENU,COLORMENU,EDITMENU,EDITBOTHMENU,SAVEOPTMENU)
  add(cm,HELPMENU...,ABOUTMENU)
  # position of next items is adjusted in redraw_panes
  wmove(stdscr,LINES()-3,33)
  add(cm,"&Name",KEY_ALT('N')) 
  add(cm,".&Ext",KEY_ALT('E'))
  for i in 0:1
    wmove(stdscr,LINES()-3,i*(COLS()-29)+4) 
    add(cm,"&Size",KEY_ALT('S')+512*(i+1))
    wmove(stdscr,LINES()-3,i*(COLS()-29)+19)
    add(cm,"&Time",KEY_ALT('T')+512*(i+1))
  end
  global vdmenu=cm
  end
end

@ExtObj mutable struct Vdir_pick
  name::Tuple{String,String}
  p::Pick_list
  ppairs::Vector{PathPair}
  namewidth::Int
  pane_width::Int
  name_column::Int
  panes::Vector{Int}
  cmp_column::Int
  sz_width::Int
  tm_width::Int
  offset::Int
  height::Int
  sort_up::Bool
  sort::Char
end

function Base.dump(vd::Vdir_pick)
 "#$(length(vd.ppairs)) maxw:$(vd.namewidth) o:$(vd.offset)"
end
 
Base.pairs(vd::Vdir_pick)=vd.p.s.list

function current(vd)
  if length(vd.p.s)>0 return vd.ppairs[pairs(vd)[vd.p.sel_bar]] end
end

function current(vd,side)
  p=current(vd)
  if !isnothing(p) p[side] end
end

function curname(vd,s=gside)
  joinpath(vd.name[s],current(vd).filename)
end

function Vdir_pick(n0,n1;old=nothing,recur=false)
  initvdmenu()
  ppairs=pairs_from_dirs(n0,n1,old)
  s=Scroll_list(stdscr,collect(eachindex(ppairs));rows=LINES()-5,cols=COLS()-2,
                begy=2,begx=1)
  shaded_frame(stdscr,s.begx-1,s.begy-1,2+s.rows,s.cols+1)
  namewidth=max(12,maximum(map(x->textwidth(x.filename),ppairs);init=0))
  pane_width=32 # width of a panel including shade
  if namewidth+4>COLS()-2*pane_width pane_width=29 end
  namewidth=min(namewidth,COLS()-2*pane_width-4)
  name_column=min(1+pane_width+div(COLS()-2*pane_width-4-namewidth,2),
                  COLS()-namewidth-pane_width-3)
  # name, p, ppairs, namewidth, pane_width, name_column, panes,
  # cmp_column, sz_width, tm_width, offset, height, sort_up, sort
  vd=Vdir_pick((n0,n1),Pick_list(s),ppairs,namewidth,pane_width,name_column,
               [1,1+COLS()-pane_width], # starts of panes
               name_column+namewidth,10,pane_width-14,0,LINES()-3,true,'N',
               Dict{Symbol,Any}())
  add_scrollbar(s,vd.name_column-1)
  s.showentry=function(s,pos)
    d=pos<=length(s.list) ? vd.ppairs[s.list[pos]] : nothing
    hl=(pos==vd.p.sel_bar)
    wmove(s.win,x=vd.name_column);add(hl ? :BAR : :NORM)
    add(printfname(d,vd.namewidth,vd.offset;norm=hl ? :BAR : :NORM)...)
    wmove(s.win,x=vd.cmp_column);add(:HL,Int(isnothing(d) ? ' ' : d.cmp))
    for n in 1:2
      hls=(hl && n==gside)
      t=(hl ? "▶" : ACS_(:VLINE))
      wmove(s.win,x=vd.panes[n]-1);add(:BOX,t)
      if hls add(:BAR)  end
      if isnothing(d) add(" "^vd.sz_width)
      elseif !isnothing(d[n])
        if !hls add(:NORM) end
	add(printsz(d[n],vd.sz_width))
      else
        if !hls add(:GREY) end
        add(cpad("-absent-",vd.sz_width))
      end
      if !hls add(:BOX) end
      add(ACS_(:VLINE))
      if isnothing(d) add(" "^vd.tm_width)
      elseif !isnothing(d[n])
        if !hls add(:NORM) end
	add(printtm(d[n],vd.tm_width))
      else
        if !hls add(:GREY) end
        add(cpad("--",vd.tm_width))
      end
      add(:BOX,t)
    end
  end
  preserve_sel_bar(vd)do vd
    for (i,p) in enumerate(vd.ppairs)
  #   werror("$i:$p")
      if p.cmp!='?' continue end
      j=findfirst(==(i),pairs(vd))
      move_bar_to(vd.p,j)
#     try 
      check_current(vd;do_not_stat=true,recur)
#     catch ex
#       if ex isa InterruptException && 'y'==ok("comparison of $(current.filename) interrupted. Interrupt also directory comparison")
#         return
#       end
#     end
    end
    sort!(pairs(vd),by=i->by(vd.sort,vd.ppairs[i]),rev=!vd.sort_up)
  end
  redraw_panes(vd)
  vd
end

function next_such(f,vd;advance=true) # next with property f
  l=length(pairs(vd))
  i=min(vd.p.sel_bar,l)
  if i<l && advance i+=1 end
  while i<l && !f(vd.ppairs[pairs(vd)[i]]) i+=1 end
  move_bar_to(vd.p,i)
end

function prev_such(f,vd;retreat=true) # prev with property f
  l=length(pairs(vd))
  i=min(vd.p.sel_bar,l)
  if retreat && i>1 i-=1 end
  while i>0 && (i>length(vd.p.s) || !f(vd.ppairs[pairs(vd)[i]])) i-=1 end
  move_bar_to(vd.p,i)
end

function preserve_sel_bar(f,vd)
  cur=0<vd.p.sel_bar<=length(pairs(vd)) ? pairs(vd)[vd.p.sel_bar] : nothing
# werror("cur=$(vd.ppairs[cur].filename)")
  f(vd)
  if cur!=nothing
    rng=searchsorted(pairs(vd),cur;
                     by=i->by(vd.sort,vd.ppairs[i]),rev=!vd.sort_up)
    move_bar_to(vd.p,min(rng.start,length(pairs(vd))))
  else move_bar_to(vd.p,1)
  end
# werror("rng=$rng")
# werror("cur=$(vd.ppairs[pairs(vd)[vd.p.sel_bar]].filename)")
  show(vd.p)
  vd.p.s.on_scroll(vd.p.s)
end
  
function by(sortp::Char,d::PathPair)
 (isnothing(d[gside]) ? !myisdir(d[3-gside]) : !myisdir(d[gside]),
  if sortp=='N' d.filename
  elseif sortp=='E' 
    (extension(d),d.filename)
  elseif sortp=='S' 
    isnothing(d[gside]) ? (0,d[3-gside].size,d.filename) : (d[gside].size,0,d.filename)
  elseif sortp=='T' 
    isnothing(d[gside]) ? (0,d[3-gside].mtime,d.filename) : (d[gside].mtime,0,d.filename)
  end)
end

function update_sort(vd::Vdir_pick,c::Char)
  sdecor(s)=add(:HL,s ? ACS_(:DARROW) : ACS_(:UARROW))
  sdecor()=add(:BOX,ACS_(:HLINE))
  if vd.sort==c vd.sort_up=!vd.sort_up else vd.sort_up=true end
  vd.sort=c
  wmove(stdscr,vd.height,vd.name_column)
  if vd.sort=='N' sdecor(vd.sort_up) else sdecor() end
  wmove(stdscr,vd.height,vd.name_column+11)
  if vd.sort=='E' sdecor(vd.sort_up) else sdecor() end
  for i in 1:2
    wmove(stdscr,vd.height,vd.panes[i]+2)
    if vd.sort=='S' && gside==i sdecor(vd.sort_up) else sdecor() end
    wmove(stdscr,vd.height,vd.panes[i]+17)
    if vd.sort=='T' && gside==i sdecor(vd.sort_up) else sdecor() end
  end
  preserve_sel_bar(vd)do vd
    sort!(pairs(vd),by=i->by(vd.sort,vd.ppairs[i]),rev=!vd.sort_up)
  end
end

function check_showfilter(vd::Vdir_pick)
  preserve_sel_bar(vd)do vd
    vd.p.s.list=filter(i->vd.ppairs[i].cmp in show_filter,eachindex(vd.ppairs))
    sort!(pairs(vd),by=i->by(vd.sort,vd.ppairs[i]),rev=!vd.sort_up)
  end
  redraw_panes(vd) # namewidth may have changed
end
   
function browse(n0,n1,old=nothing;toplevel=false,flg...)
  save=Savewin(stdscr)
  vd=Vdir_pick(n0,n1;old,recur=haskey(flg,:recur) ? flg[:recur] : false)
  check_showfilter(vd)
  if haskey(flg,:quit) endwin();return end
  p=vd.p
  c=getch()
  while true
    if c==KEY_MOUSE
      c=process_event(vd,getmouse())
      if c!=-1 && c!==nothing continue end
    elseif c in (Int('q'),Int('Q'),0x1b) 
      if !toplevel || 'y'==ok("leave vdiff") break end
    elseif c in (Int('h'),KEY_F(1)) whelp(vdhelp,"directory comparison screen")
    elseif c==KEY_CTRL('I')
      global gside=3-gside
      move_bar_to(p,p.sel_bar)
    elseif c==KEY_RIGHT vd.offset+=1;show(p)
    elseif c==KEY_LEFT if vd.offset>0 vd.offset-=1;show(p) end
    elseif c in (KEY_ALT('E'),KEY_ALT('N'),KEY_ALT('T'),KEY_ALT('S'))
            update_sort(vd,'A'+c-KEY_ALT('A'))
    elseif c in (KEY_ALT('S')+512,KEY_ALT('S')+1024) 
            gside=div(c,512);update_sort(vd,'S')
    elseif c in (KEY_ALT('T')+512,KEY_ALT('T')+1024) 
            gside=div(c,512);update_sort(vd,'T')
    elseif c in Int.(('l','r','=','<','>'))
      global show_filter
      if Char(c) in show_filter 
        show_filter=replace(show_filter,string(Char(c))=>"")
      else show_filter*=Char(c)
      end
#      @@cm.heads[1].items[CMP.index(c.chr)+1].toggle
      check_showfilter(vd)
    elseif c==KEY_F(4)
      if '=' in show_filter show_filter="<>?" else show_filter="=lr<>?" end
      check_showfilter(vd)
    elseif c==KEY_F(3)
      if isnothing(current(vd,gside)) beep();c=getch();continue end
      if myisdir(current(vd,gside)) dirbrowse(curname(vd))
      else browse_file(curname(vd))
      end
    elseif c in (KEY_ENTER , KEY_CTRL('J'))
      if isnothing(current(vd,gside)) beep();c=getch();continue end
      if !isnothing(current(vd,3-gside)) check_current(vd;show=true)
      else c=KEY_F(3); continue
      end
    elseif c==Int('R')
      if isnothing(current(vd,gside)) || isnothing(current(vd,3-gside))
        beep();c=getch();continue
      end
      try
        check_current(vd;recur=true)
      catch ex
       werror("$ex when comparing recursively $(current(vd))")
      end
    elseif c in (Int('c'), KEY_IC)
      if isnothing(current(vd,gside)) beep;c=getch();continue end 
      dest=curname(vd,3-gside)
      if !(cpmv(curname(vd),dest) in (false,nothing))
        current(vd).cmp='='
        current(vd)[3-gside]=stat(dest)
        check_showfilter(vd)
      end
    elseif c==Int('C')
      if isnothing(current(vd,gside)) || !isdir(current(vd,gside))
       beep;c=getch();continue 
      end 
      if cpmv(curname(vd),curname(vd,3-gside);recursive=false)
        current(vd)[3-gside]=stat(curname(vd,3-gside))
        move_bar_to(p,p.sel_bar)
        next_such(p->p[gside]!==nothing,vd)
        prev_such(p->p[gside]!==nothing,vd;retreat=false)
      end
    elseif c in (Int('d'), KEY_DC)
      if isnothing(current(vd,gside)) beep
      elseif myrm(curname(vd);rmopts...)
        v=PathPair(curname(vd),'=',current(vd).f)
        current(vd)[gside]=nothing
        if !isnothing(current(vd,3-gside))
          current(vd).cmp="rl"[gside]
          move_bar_to(p,p.sel_bar)
          next_such(p->p[gside]!==nothing,vd)
 	else
          del=pairs(vd)[p.sel_bar]
          deleteat!(vd.ppairs,del)
          deleteat!(pairs(vd),p.sel_bar) # recompute list instead?
          for i in eachindex(pairs(vd))
            if pairs(vd)[i]>del pairs(vd)[i]-=1 end
          end
          next_such(p->p[gside]!==nothing,vd;advance=false)
 	end
        prev_such(p->p[gside]!==nothing,vd;retreat=false)
        show(vd.p)
      end
    elseif c in (Int('e'),KEY_F(5))
      if isnothing(current(vd,gside)) beep()
      else exec(make_edit_command(curname(vd),0)) 
           check_current(vd)
      end
    elseif c in (KEY_F(9), Int('x'))
      exec(nothing,vd.name[gside])
#     reagain()
    elseif c==Int('v')
      exec(make_edit_both_command(curname(vd,1),curname(vd,2),0,0))
      check_current(vd)
    elseif c==Int('+') next_such(p->p.cmp!='=',vd)
    elseif c==Int('-') prev_such(p->p.cmp!='=',vd)
    elseif c in (KEY_F(6),Int('o'))
      res=optionmenu()
      if RECOMPUTE==res #reagain()
      elseif RECOMPUTE_DIFFS==res  && 'y'==
        ok("recompute differences (changes in options may have affected them)")
      #  reagain()
      else redraw_panes(vd)
      end
    elseif !do_key(p,c)
      c=Menus.do_key(vdmenu,c)
      if !isnothing(c)
        if c isa Function c()
        else continue
        end
      end
    end
    c=getch()
  end
  restore(save)
  vd
end

# redraw panes and dependent menu items
function redraw_panes(vd::Vdir_pick)#;refresh=true) 
  background()
  vd.pane_width=32 # width of a panel including shade
  vd.namewidth=max(12,maximum(map(i->textwidth(vd.ppairs[i].filename),pairs(vd));init=0))
  if vd.namewidth+4>COLS()-2*vd.pane_width vd.pane_width=29 end
  vd.panes=[1,1+COLS()-vd.pane_width] # starts of panes
  vd.namewidth=min(vd.namewidth,COLS()-2*vd.pane_width-4)
  vd.name_column=min(1+vd.pane_width+div(COLS()-2*vd.pane_width-4-vd.namewidth,2),
                     COLS()-vd.namewidth-vd.pane_width-3)
  vd.cmp_column=vd.name_column+vd.namewidth
  vd.sz_width=10
  vd.tm_width=vd.pane_width-vd.sz_width-4
  if vd.height==0 vd.height=LINES()-3 end
  shaded_frame(stdscr,1,vd.name_column-1,vd.height,3+vd.namewidth)
  vd.p.s.sb.x=vd.name_column-1
  mvadd(1,vd.name_column+4,:BOX,"entry")
#   if refresh then on_scroll else init_scroll(@name_column-1) end
# init_scroll(vd.name_column-1) # necessary if pane_width changed
  for i in 1:2
    shaded_frame(stdscr,1,vd.panes[i]-1,vd.height,vd.pane_width-1)
    mvadd(1,vd.panes[i]+vd.sz_width,:BOX,ACS_(:TTEE))
    wmove(stdscr,2,vd.panes[i]+vd.sz_width);vline(0,vd.height-2)
    mvadd(vd.height,vd.panes[i]+vd.sz_width,ACS_(:BTEE))
    printnormedpath(1,vd.panes[i],vd.name[i],vd.pane_width-3)
  end
  cm=vdmenu
# set the Size, Time, Name Ext indicators in their proper column
  Menus.setx(cm.heads.v[5],vd.name_column+1)
  Menus.setx(cm.heads.v[6],vd.name_column+6)
  Menus.setx(cm.heads.v[9],3+vd.panes[2])
  Menus.setx(cm.heads.v[10],18+vd.panes[2])
# show in View the cmp viewed
  for i in cm.heads.v[2].items.v[2:6]
    i.checked=Char(i.action) in show_filter
  end
# show in View signification of F4
  Menus.install(cm.heads.v[2].items.v[1],
   show_filter=="<>?" ? "&Full compare\tF4" : "&Common unequal\tF4",
   show_filter=="<>?" ?  "Show a full comparison of the directories" :
          "Show only files common to both sides and different")
  Curses.refresh(cm)
  show(vd.p)
  vd.p.s.on_scroll(vd.p.s)
end

function check_current(vd;do_not_stat=false,show=false,recur=false)
  v=current(vd)
  if !do_not_stat
    for i in 1:2
      n=joinpath(vd.name[i],v.filename)
      if ispath(n) v[i]=stat(n)
      else v[i]=nothing;v.cmp="lr"[i] 
      end
    end
  end
  if isnothing(v[1]) || isnothing(v[2]) return end
  if myisdir(v[1])!=myisdir(v[2])
    typ(f)=myisdir(f) ? "directory" : "file"
    werror("$(curname(vd,1)) is a $(typ(v[1])) but $(curname(vd,2)) is a $(typ(v[2]))")
    return
  end
  if myisdir(v[1])
    if !show && !recur return end
    infohint(v.filename)
    old=haskey(v,:son) ? v.son : nothing
    if show 
      son=browse(curname(vd,1),curname(vd,2), old;show)
    elseif recur
      save=Savewin(stdscr)
      try
        son=Vdir_pick(curname(vd,1),curname(vd,2);old,recur)
      catch ex
        if ex isa InterruptException && 
          'y'==ok("comparison of $v interrupted. Interrupt also directory comparison")
          restore(save)
          rethrow(ex)
        end
   #    werror("$ex when filling")
      end
      restore(save)
    end
    became_equal=all(p->p.cmp=='=',son.ppairs)
    v.son=son.ppairs
  else became_equal=higher_compare(curname(vd,1),curname(vd,2);show)
# when "link" then  
#   if File.readlink(curname(vd,1))==File.readlink(curname(vd,2)) then v.cmp=?= 
#   else v.cmp=v[0].mtime>v[1].mtime ? ?> : ?<
#   end
# else werror("#{v[0].ftype} not implemented")
  end
  if became_equal v.cmp='='
  else v.cmp=v[1].mtime>v[2].mtime ? '>' : '<'
  end
  if !(v.cmp in show_filter)
    j=findfirst(==(current(vd)),vd.ppairs)
    j=findfirst(==(j),pairs(vd))
    if isnothing(j) werror("$(current(vd)) $j") end
    deleteat!(pairs(vd),j)
    Base.show(vd.p.s)
  end
  move_bar_to(vd.p,vd.p.sel_bar)
end

# nothing did nothing
# -1 processed event
# else key to return
function process_event(d::Vdir_pick,e)
  c=process_event(vdmenu,e)
  if !isnothing(c)
    if c isa Function c(); return -1
    else return c 
    end
  end
  if !(d.p.s.begy<=e.y<=d.p.s.begy+d.p.s.rows-1 &&
       among(e,BUTTON1_PRESSED|BUTTON1_CLICKED|BUTTON1_DOUBLE_CLICKED))
    return nothing
  end
  global gside
  if d.panes[1]-1<=e.x<=d.panes[1]+d.pane_width gside=1
  elseif d.panes[2]-1<=e.x<=d.panes[2]+d.pane_width gside=2
  end
  c=process_event(d.p,e)
  if c==-1 
    if e.bstate==BUTTON1_DOUBLE_CLICKED return KEY_ENTER
    else return -1 
    end
  end
end
