rmopts::Dict=Dict(
   :error=>werror,
   :info=>infohint,
   :interactive=>ok,
   :recursive=>true,
   :verbose=>true)

#require 'find'
#require 'platform'
#
## opts:
## :interactive[questions,string] => a proc to ask OK questions
##  n:no y:yes q:stop g:no more questions this run s:no more for current dir
## :recursive => true or false
## :info[string] => A proc for verbose reporting (of string)
## :error[string] => a proc to report error conditions
## return: nil=>stop false=>not everything removed
function myrm(src;opts...)
  opts=merge(rmopts,opts)
  ok=true
  fsrc=Filedesc(src)
  if opts[:interactive]!=nothing
    msg="delete "
    if isdir(fsrc) && opts[:recursive] msg*="recursively directory " end
    msg*="$fsrc"
    ans=opts[:interactive](msg,isdir(fsrc) ? "ynsgq" : "yngq")
    if ans=='n' return false
    elseif ans=='g' opts[:interactive]=rmopts[:interactive]=nothing
    elseif ans=='q' return nothing
    end
  else ans='s'
  end
  if src=="."
    opts[:error]("cannot remove $src")
    return false
  end
  if isdir(fsrc)
    if opts[:recursive]
      if ans=='s' inter=opts[:interactive];opts[:interactive]=nothing end
      try
        chmod(src,0o0744) # make writable to delete entries
      catch exc
        if opts[:verbose] opts[:error]("chmod744: $(exc)") end
      end
      for s in readdir(src)
#	next if [".",".."].include? s
	ok=ok && myrm(joinpath(src,s);opts...)
        if isnothing(ok) return nothing end
      end
      if ans=='s' opts[:interactive]=inter end
    end
    rm(src)
  else
    if iszero(uperm(src)&0x02) # !writable
     if !isnothing(opts[:interactive]) && (!haskey(opts,:force) || !opts[:force])
	msg= "delete $fsrc: it is read-only"
        c=opts[:interactive](msg,"yngq")
        if c in ('n', 'q') return false
        elseif c=='g' opts[:force]=true
        end
      end
      try
      chmod(src,0o0644)
      catch exc
        if opts[:verbose] opts[:error]("chmod644: $(exc)") end
      end
    end
    rm(src)
  end
  if !isnothing(opts[:info]) opts[:info]("$fsrc deleted") end
  return ok 
# rescue SystemCallError => exc
#   opts[:error]("rm(#{src}): #{exc}")
#   return false
end

using Printf 

function nbK(n)
  k=1024.0
  if n<10k @sprintf("%5d",n)
  elseif n<10k*k @sprintf("%5.1fK",n/k)
  elseif n<10k*k*k @sprintf("%5.1fM",n/k/k)
  else @sprintf("%5.1fG",n/k/k/k)
  end
end

function dirsize(f)
  size=0
  for (dir,dirs,files) in walkdir(f)
    for f in files size+=filesize(joinpath(dir,f)) end
  end
  size
end

cpopts::Dict=Dict(
   :error=>werror, # :error[string] => a proc to report error conditions
#  :error=>println,
   :info=>infohint, # :info[string] => A proc for verbose reporting (of string)
#  :info=>println,
   :interactive=>ok, # a proc to ask OK questions or nothing
#  n:no y:yes q:stop g:no more questions s:no more for current dir
#  :interactive=>(t,msg)->(println(msg,"?[",t,"]");readline()[1]),
   :infocopy=>(n,m)->infohint("$n:$(nbK(m)) copied"),
# :infocopy[name,size] => A proc to follow progress of individual files copy
#  :infocopy=>(n,m)->println("$n:$(nbK(m)) copied"),
   :merge=>false, # :merge => if true do not delete target dirs 
   :recursive=>true)

# opts: one of cpopts or move => true or false
# return: nil=>stop false=>not everything copied/moved
function cpmv(src,target;move=false,opts...)
  opts=merge(cpopts,opts)
  ok=true
  what= move ? "move" : "copy"
  fsrc=Filedesc(src)
## move/copy fullname to target
  silent=false
  if !isnothing(opts[:interactive])
    msg=what
    if isdir(fsrc) && opts[:recursive] msg*= " recursively" end
    msg*=" $fsrc to $target"
    c=opts[:interactive](msg,isdir(fsrc) ? "ynsgq" : "yngq")
    if c=='n' return false
    elseif c=='q' return nothing
    elseif c=='g' opts[:interactive]=cpopts[:interactive]=nothing
    elseif c=='s' silent=true
    end
  end
## if(fsrc.isroot())
## { efns(WARNING_,
##          "cannot %s root directory '%s'; use %s%s*.* to %s its contents",
##   msg,src,src.prefix,fsrc.filename,msg);
##   return 1;
## }
  if !opts[:recursive] && isdir(fsrc)
    nb=length(readdir(src))
    if nb>0
      opts[:info]("directory $src non empty;"*
                  " use recursive option to $what its contents")
    end
  end
  tgtsize=0
  if ispath(target)
    tgtsize+=isdir(target) ? dirsize(target) : filesize(target)
    esrc=isabspath(src) ? src : joinpath(pwd(),src)
    etg=isabspath(target) ? target : joinpath(pwd(),target)
    if esrc==etg
      opts[:error]("cannot $what $esrc to itself")
      return false
    elseif endswith(esrc,etg)
      opts[:error]("cannot $what $esrc within itself($etg)")
      return false
    elseif endswith(etg,esrc)
      opts[:error]("cannot $what $esrc to its father($etg)")
      return false
    end
  end
  srcsize=isdir(src) ? dirsize(src) : filesize(src)
## log "size of src: #{srcsize}\n"
  msg=if move 
    try
      mv(src,target)
      "moved "
    catch exc
      nothing
    end
  end
  if msg!="moved "
    if !(opts[:merge] && isdir(fsrc))
      free=0
      try
        targetdir=dirname(target)
        free=diskstat(ispath(targetdir) ? targetdir : ".").available
      catch exc
        opts[:error]("freespace: $(exc.msg)")
        free=0
      end
      try
        tgdev=stat(target).device
      catch exc
        opts[:error]("stat($target): $(exc.msg)")
        tgdev=0
      end
# #   log "free=#{nbK(free)} tgtsize=#{nbK(tgtsize)} srcsize=#{nbK(srcsize)}\n"
      if free+tgtsize<srcsize && !(move && tgdev==stat(fsrc).device)
        opts[:error]("$(nbK(free+tgtsize))=not enough free space on device "*
                     "$(stat(target).device): to $what $src ($(nbK(srcsize)))")
	return false
      end
      if ispath(target) && !(ok=myrm(target;opts...)&& ok) return ok end
      if isdir(fsrc) mkdir(target) # do not copy perms yet (RO!!)
#     elseif islink(fsrc) File.symlink(File.readlink(src),target)
      elseif !(ok=copyfile(src,target;opts...)&& ok) return ok 
      end
    end
    if isdir(fsrc)
      if silent
        save=opts[:interactive]
        opts[:interactive]=nothing 
      end;
      if opts[:recursive]
        for s in readdir(src)
#         if s in (".","..") continue end
	  res=cpmv(joinpath(src,s),joinpath(target,s);opts...)
          if res==nothing return nothing end
          ok=ok && res
	end
      end
      try
        chmod(target,filemode(src)) # now set perms
      catch exc
        if haskey(opts,:verbose) && opts[:verbose] 
          opts[:error]("setting perms: $(exc.msg)")
        end
      end
      if silent opts[:interactive]=save end
    end
    msg="copied"
    if move && (ok=rm(src,opts) && ok) msg="moved " end
    if ok==nothing return nothing end
  end
  if !isnothing(opts[:info]) opts[:info]("$fsrc $msg to $target") end
  return ok
# rescue SystemCallError => exc
#   opts[:error]("#{what} #{src}=>#{target}: #{exc}")
#   return false
end

BLOCKSIZE::Int=1024*1024*10 #  to go fast

function copyfile(src,dest;opts...)
  open(src,"r")do r
    st=stat(r)
    try
      open(dest,"w")do w
        sz=0
        while !eof(r)
          s=read(r,BLOCKSIZE)
          sz+=write(w,s)
          opts[:infocopy](src,sz)
        end
      end
    catch exc
      opts[:error]("opening $dest: $exc")
      return false
    end
    try
      chmod(dest,st.mode)
    catch exc
      opts[:error]("changing mode: $exc")
    end
    try
      setmtime(dest,st.mtime, st.ctime)
    catch exc
      opts[:error]("setting time: $exc")
    end
    try 
      chown(dest,st.uid, st.gid)
    catch exc
      if haskey(opts,:verbose) && opts[:verbose] 
        opts[:error]("could not set owner of $dest") end
      try
        chmod(dest,st.mode&0o01777) # clear setuid/setgid
      catch
      end
      try
        chmod(dest,st.mode)
      catch
        opts[:error]("could not set perms on #{dest}")
      end
    end
  end
  true
end

import Dates
import Base: _sizeof_uv_fs, uv_error

function setmtime(path::AbstractString, 
  mtime::Real, ctime::Real=mtime; follow_symlinks::Bool=true)
  req = Libc.malloc(_sizeof_uv_fs)
  try
    if follow_symlinks
      ret = ccall(:uv_fs_utime, Cint,
        (Ptr{Cvoid}, Ptr{Cvoid}, Cstring, Cdouble, Cdouble, Ptr{Cvoid}),
        C_NULL, req, path, ctime, mtime, C_NULL)
    else
      ret = ccall(:uv_fs_lutime, Cint,
        (Ptr{Cvoid}, Ptr{Cvoid}, Cstring, Cdouble, Cdouble, Ptr{Cvoid}),
        C_NULL, req, path, ctime, mtime, C_NULL)
    end
    ccall(:uv_fs_req_cleanup, Cvoid, (Ptr{Cvoid},), req)
    ret < 0 && uv_error("utime($(repr(path)))", ret)
  finally
    Libc.free(req)
  end
end

#setmtime(path::AbstractString, mtime::Dates.AbstractDateTime, ctime::Dates.AbstractDateTime=mtime; follow_symlinks::Bool=true) =
#    setmtime(path, Dates.datetime2unix(mtime), Dates.datetime2unix(ctime); follow_symlinks=follow_symlinks)
