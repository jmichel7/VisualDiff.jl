function expand_tabs(s;TABSIZE=8)
  res="";j=0
  for c in s
    if c=='\t'
      s=" "^mod1(TABSIZE-j,TABSIZE)
      res*=s
      j+=length(s)
    else res*=c; j+=1
    end
   end
  res
end

"""
function par(s,len,sep="<p>",pref=true)
 s    -- string to reformat
 len  -- line length
 sep  -- Paragraph separator to output
 pref -- if true find common prefix
"""
function par(s,len;sep="<p>",pref=true,tabsize=8)
  w=map(y->expand_tabs(y,TABSIZE=tabsize),split(s,r"\n"))
  if isempty(w) return "" end
  prefix=""
  if pref && length(w)>1
    while !isempty(first(w)) && all(l->(!isempty(l) && first(l)==first(first(w))
      && !isletter(l[1])) || (isempty(l) && isspace(first(first(w)))),w)
      prefix*=first(first(w))
      w=map(s->s[2:end],w)
    end
  end
  len-=length(prefix)
  w=split(join(w,"\n"),r"\s+")
  if isempty(w) return "" end
  if isempty(first(w)) popfirst!(w) end
  if isnothing(match(r"\A\n\z"im,sep)) && isnothing(match(r"\A\n\s*\n\z"im,sep)) sep="<p>" end
# res=sep
  res=""
  ll=0
  lasti=1
  ini=length(sep)
  for (i,v) in enumerate(w)
   ll+=length(v)
   if ll>len-ini && i>lasti
     res*=prefix*pad(w[lasti:i-1],len-ini)*"\n"
     ini=0
     lasti=i
     ll=length(v)
   end
   ll+=1
  end
  res*prefix*join(w[lasti:end]," ")*"\n"
end

TOO_MUCH_PADDING=1.25
function pad(s,len) # pad with withespace words s until len reached
 # print "len=#{len} s=",s.inspect,"\n"
  if isempty(s) return "" end
  if length(s)==1 return only(s) end
  total=sum(length.(s))
  if len>(total+length(s)-1)*TOO_MUCH_PADDING return join(s," ") end # give up
  len-=total
  while len>length(s)-1
    s=map(x->x*" ",s)
    s[end]=chop(s[end])
    len-=length(s)-1
  end
  freq=div(length(s)-1,len)
  i=1
  while len>0 && i<=length(s)
    s[i]*=" "
    i=mod1(i+freq,length(s)-1)
    len-=1
  end
  join(s,"")
end
