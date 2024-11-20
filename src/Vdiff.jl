module Vdiff
export vdiff

include("Curses.jl")

function vdiff(n0,n1;flg...)
  n0=expanduser(n0); n1=expanduser(n1)
  for n in (n0,n1) if !ispath(n) error("no such file or directory:$n") end end
  initscr2()
  if LINES()<24 || COLS() <80 
    endwin()
    error("vdiff needs at least 24 lines and 80 columns: detected $(LINES())x$(COLS())") 
  end
  Color.init(schemes[1][:value]...) # in case no option file
  read_options(cfgname)
  if isfile(n0) && isfile(n1) higher_compare(n0,n1;show=true)
  elseif isdir(n0) && isdir(n1) 
    vd=Vdir_pick(n0,n1)
    browse(vd::Vdir_pick;toplevel=true,flg...)
  elseif isdir(n1) p=joinpath(n1,basename(n0))
    if !(ispath(p)) error("no such file or directory:$p") end
    higher_compare(n0,p;show=true)
  else p=joinpath(n0,basename(n1))
    if !(ispath(p)) error("no such file or directory:$p") end
    higher_compare(p,n1;show=true)
  end
  endwin()
end
end
