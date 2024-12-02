using Vdiff

clihelp="""
usage:  vdiff [options] f1 f2

compare files f1 and f2 or directories f1 and f2, or if f1 is a file and f2
a directory, compare f1 and f2/g1 where g1 is the basename of f1.

options:
-r, --recur       recursively compare the two argument directories.
-h, --help        show this message.
-i, --ignore_case ignore case when comparing files.
-s, --slow        ignore an option 'just_size=true' in the configuration file.
-w, --ignore_w    ignore whitespace when comparing files.
"""

function main(args...)
  names=String[]
  for a in args
    if a in ("-h","--help") println(clihelp)
    elseif a in ("-r","--recur") Vdiff.opt.recur=true
    elseif a in ("-s","--slow") Vdiff.opt.onlylength=false
    elseif a in ("-i","--ignore_case") Vdiff.opt.ignore_case=true
    elseif a in ("-w","--ignore_w") Vdiff.opt.inore_blkseq=true
    else push!(names,a)
    end
  end
  if length(names)!=2 println(clihelp)
  else vdiff(names...;Vdiff.opt...)
  end
end
