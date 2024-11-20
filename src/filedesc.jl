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
      Dates.format(unix2datetime(f.stat.mtime),"dd u yy HH:mm")," ",
        joinpath(f.dir,f.filename))
end

# curses-write Filedesc f on width namewidth starting at offset
function printfname(f,namewidth,offset;norm=:NORM)
  if isnothing(f) return [" "^namewidth] end
  n=f.filename
  l=length(n)
  offset=max(0,min(offset,l-namewidth))
  lo=offset>0
  ro=l>offset+namewidth
  res=lpad(n[nextind(n,1,offset):prevind(n,min(ncodeunits(n)+1,offset+namewidth+1))],namewidth)
  lo ? [:BOX,"«",norm,res[nextind(res,1):end]] : ro ? [res[1:prevind(res,lastindex(res))],:BOX,"»",norm] : [res]
end
