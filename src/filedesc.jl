struct Filedesc
  filename::String
  dir::String
  stat
end

function Filedesc(n)
  if VERSION.minor>11 s=Base.StatStruct("",0,0,0,0,0,0,0,0,0,0,0.0,0.0,0)
  else s=Base.StatStruct("",0,0,0,0,0,0,0,0,0,0,0.0,0.0)
  end
  try
    s=stat(n)
  catch e
    werror("$e doing stat($n)")
  end
  Filedesc(basename(n),dirname(n),s)
end

Base.cmp(a::Filedesc,b::Filedesc)=cmp(a.filename,b.filename)

Base.isless(a::Filedesc,b::Filedesc)=cmp(a,b)==-1

Base.isdir(a::Filedesc)=isdir(a.stat)

using Dates 
function Base.show(io::IO,f::Filedesc)
  print(io,Base.Filesystem.filemode_string(f.stat.mode)," ",f.stat.size," ",
        Dates.format(DateTime(Libc.TmStruct(f.stat.mtime)),"dd u yy HH:MM")," ",
        joinpath(f.dir,f.filename))
end

# curses-write Filedesc f on width namewidth starting at offset
function printfname(f,namewidth,offset;norm=:NORM)
  if isnothing(f) return [" "^namewidth] end
  n=f.filename
  l=textwidth(n)
  if l<=namewidth return [lpad(n,namewidth)] end
  offset=min(offset,l-namewidth+1)
  n=n[max(1,firstscreen(n,offset+1)):end]
  l-=offset+1
  lo=offset>0
  ro=l>=namewidth-lo
  if lo res=[:BOX,"«",norm] else res=[] end
  push!(res,n[1:firstscreen(n,namewidth-lo-ro)])
  if ro push!(res,:BOX,"»",norm) end
  res
end
