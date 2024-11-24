function inputbox(title,description,initstr="")
  description=par(description,COLS()-8;sep="")
  nblines=count('\n',description)+1
  beg=10
  s=Shadepop(beg,1,nblines+7,COLS()-3)
  wmove(stdscr,beg,1)
  center(stdscr,title,COLS()-4)
  add(:NORM)
  inner=derwin(stdscr,nblines,COLS()-7,beg+2,3)
  wmove(inner,0,0);
  printa(inner,description)
  last=beg+nblines+5
  mvadd(last-1,3,:NORM)
  printa(stdscr,
   "Use keys {HL ←}, {HL →}, {HL Ins} and {HL Del} to edit. When finished,")
  mvadd(last,3,:NORM)
  printa(stdscr,"press {HL Enter} to accept the new value or {HL Esc} to abort")
  mvadd(last-3,COLS()-8,:NORM,"]")
  mvadd(last-3,3,"[",:BOX)
  f=Input_field(stdscr,COLS()-11;overflow=true)
  fclear(f,initstr)
  val=input(f)
  restore(s)
  add(:NORM)
  val
end

push!(opt.h,:editor=>Dict(:name=>"edit_command",
:shortdesc=>"command executed for the {HL Edit} item in the file menu.",
:longdesc=>"For instance if you set the editor to {BOX vi +%d %f} then {HL Edit}
will call {BOX vi +line name} where {BOX line} is set to the current line
number in the current file if you are in the file comparison screen 
(to 0 otherwise) and {BOX name} is the name of the current file.
If {BOX %f} is omitted it is added at the end of the command.",
:value=> "vim +%d" ),
:edit2=>Dict(:name=>"edit_both_command",
:shortdesc=>"command executed for the {HL Edit both} item in the file menu.",
:longdesc=>"This command
serves to edit both files at once. In the string given, {BOX %d1} is replaced
by the line number of the left file, {BOX %d2} by the line number of the
right file, {BOX %f1} by the name of the left file and {BOX %f2} by the name
of the right file. For instance a suitable command for vim is: 
{BOX vim -c\"+:e +%d2 %f2| new +%d1 %f1\"}",
:value=>"vim -c\":e +%d2 %f2 | new +%d1 %f1\"")
)

function make_edit_command(file,line)
  command=replace(opt.editor,r"%d"=>string(line))
  file=replace(file,r" "=>"\\ ")
  m=match(r"%f",command)
  if isnothing(m) command*=" "*file 
  else command=replace(command,"%f"=>file)
  end
  command
end

EDITMENU=["&Edit command",function()
   opt.editor=inputbox("Specify editor",
   opt.h[:editor][:shortdesc]*"\n\n"*opt.h[:editor][:longdesc],
   opt.editor) end,
    "Specify external editor to use in file menu Edit action"]

function make_edit_both_command(file0,file1,line0,line1)
  file0=replace(file0,r" "=>"\\ ")
  file1=replace(file1,r" "=>"\\ ")
  replace(opt.edit2,r"%d1"=>string(line0),r"%d2"=>string(line1),
            r"%f1"=>file0,r"%f2"=>file1)
end

EDITBOTHMENU=["Edit &both command",function()
  opt.edit2=inputbox("Specify command to edit both files",
  opt.h[:edit2][:shortdesc]*"\n\n"*opt.h[:edit2][:longdesc],
  opt.edit2) end,
     "Specify command to use for file menu Edit both action"]

PROGNAME="vdiff"
cfgname="~/.vdiff"
push!(opt.h,:savefile=>Dict(:name=>"save_file",
:longdesc=>
"Specify in which file you want to save current options permanently.
By default, when starting, {BOX $PROGNAME} looks for {BOX $cfgname}.
In addition to the options in this menu, we save also the browser modes, 
the tab size, the side-by-side flag, etc...",
:value=>cfgname))

SAVEOPTMENU=["&Save options",function()
    val=inputbox("Specify where to save options",opt.h[:savefile][:longdesc],
		cfgname)
    if !isempty(val) save(opt,val) end
   end,
   "Save options for reuse in future vdiff sessions"]
