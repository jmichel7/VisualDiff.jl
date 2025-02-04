module VisualDiff
include("Curses.jl")
include("util.jl")
include("Color.jl")
include("button.jl")
include("shade.jl")
include("ok.jl")
include("about.jl")
include("scrolist.jl")
include("whelp.jl")
include("scrolbar.jl")
include("filedesc.jl")
include("pick.jl")
include("option.jl")
include("attprint.jl")
include("colormenu.jl")
include("par.jl")
include("bufregex.jl")
include("field.jl")
include("editbox.jl")
include("Menus.jl")
include("browse.jl")
include("cputil.jl")
include("optmenu.jl")
include("dirpick.jl")
include("diffhs.jl")
include("vdirdiff.jl")
include("fdiff.jl")
include("main.jl")

using PrecompileTools: @compile_workload

export vdiff
function vdiff(n0,n1;flg...)
  n0=expanduser(n0); n1=expanduser(n1)
  initscr2()
  if LINES()<24 || COLS() <80 
    endwin()
    println("vdiff needs at least 24 lines and 80 columns: detected $(LINES())x$(COLS())") 
    return
  end
  Color.init(schemes[1][:value]...) # in case no option file
  read_options(cfgname)
  if isdir(n0) && isdir(n1) 
    browse(n0,n1;toplevel=true,flg...)
  else
    if isdir(n1) n1=joinpath(n1,basename(n0))
    elseif isdir(n0) n0=joinpath(n0,basename(n1))
    end
    for n in (n0,n1)
      if !(ispath(n)) 
        endwin()
        println("no such file or directory:$n")
        return
      end
    end
    higher_compare(n0,n1;show=true,flg...)
  end
  endwin()
end

if true
@compile_workload begin
  dir=joinpath(@__DIR__,"..","examples")
  vdiff(joinpath(dir,"old"),joinpath(dir,"new");quit=true)
  vdiff(joinpath(dir,"old","aaa"),joinpath(dir,"new","aaa");quit=true)
end
end

end
