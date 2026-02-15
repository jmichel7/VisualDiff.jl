"""
show t at current pos on win and outputting less than maxout screen positions
returns index in line of last char displayed, nothing if all of line displayed
opt[:decor] = optional decorator= list of <offset, att>
other options: :tabsize   interpret tabs if not 0 
               :showtabs  paint :TAB tabs
               :showempty paint :EMPTY end of line
"""
function attprint(w::Ptr{WINDOW},t::AbstractString,maxout::Integer;
  tabsize=8, showtabs=false, showempty=false, fold=false,opt...)
# log "#{t.length}<#{t.chomp}>"
  max_x=getcurx(w)+maxout-1
  if haskey(opt,:decor)
    mm=opt[:decor]
    offset=opt[:offset]
    mmpos=1
#   log "decor=#{mm.inspect} t=#{t.inspect}\n"
  end
  function checkwrite(c)
    wadd(w,string(c))
    getcurx(w)>max_x
  end
  ptr=1
  while ptr<=ncodeunits(t)
#   log "[#{t[ptr].inspect}:#{curx}]"
    if haskey(opt,:decor) && !isempty(mm)
      if mm[mmpos].offset<ptr+offset && mmpos<length(mm) mmpos+=1 end
      if ptr+offset==mm[mmpos].offset wadd(w,mm[mmpos].att) end
    end
    c=t[ptr]
    if c==0 if checkwrite(c) break end
    elseif c in ('\r','\n') break
    elseif c=='\t'
      tab_att=showtabs ? :TAB : :NORM
      if showtabs wadd(w,tab_att) end
      if tabsize!=0
        x=getcurx(w)
        for x in x:x+tabsize-x%tabsize-1
          if checkwrite(' ') break end
	end
      end
      if checkwrite(' ') break end
      if showtabs wadd(w,:NORM) end
    elseif checkwrite(c) break
    end
    ptr=nextind(t,ptr)
  end
# log "[#{curx}]ptr=#{ptr.inspect} "
#   log "ended\n"
  if showempty wadd(w,:EMPTY);wclrtocol(w,max_x);wadd(w,:NORM) 
  else wadd(w,:NORM);wclrtocol(w,max_x)
  end
  if haskey(opt,:decor) && !fold
    while mmpos<=length(mm)
      wadd(w,mm[mmpos].att)
      mmpos+=1
    end
  end
# raise "t.length=#{t.length} ptr=#{ptr}"
  if ptr<ncodeunits(t)  ptr+1 end
end
