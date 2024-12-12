struct Filedesc
  filename::String
  dir::String
  stat
end

Filedesc(n)=Filedesc(basename(n),dirname(n),stat(n))

Base.cmp(a::Filedesc,b::Filedesc)=cmp(a.filename,b.filename)

Base.isless(a::Filedesc,b::Filedesc)=isless(a.filename,b.filename)

Base.isdir(a::Filedesc)=myisdir(a.stat)

myisdir(s::Base.Filesystem.StatStruct)=!iszero(s.mode&Base.Filesystem.S_IFDIR)

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
