rem prompt $e[0;34;45m$p$g$e[34m
prompt $p$g
set VATTR=30;47-30;46-30;42-40;31;1-40;32-41;37;1-30;46
path d:\UNIX\BINew;d:\UNIX\BIN;c:\BAT;C:\dos6;d:\util;c:\WIN;d:\cpav;d:\borlandc\bin;E:\nu;d:\slip2
PATH=E:\IBLOCAL\BIN;E:\IDAPI;%PATH%
set home=d:\etc
set glob=d:\etc\glob.exe
set graph=d:\borlandc\bgi
verify ON
set TEMP=d:\TEMP
set tmp=d:\tmp
goto %config%

:virus
SET CPAV=d:\CPAV\CPAV.INI
numlkoff
verify ON
NDD C:/C
NDD D:/C
NDD E:/C
c:\CPAV\VSAFE C: /1+/2-/3-/4+/5+/6+/7-/8-
c:\CPAV\VSAFE D: /1+/2-/3-/4+/5+/6+/7-/8-
c:\CPAV\VSAFE E: /1+/2-/3-/4+/5+/6+/7-/8-
c:\CPAV\VSAFE E: /1+/2-/3-/4+/5+/6+/7-/8-
SPEEDISK C: /FF /SD /V 
SPEEDISK D: /FF /SD /V 
SPEEDISK E: /FF /SD /V /B
goto :end

:nolan
@set comspec=c:\dos6\command.com
rem LH /L:1,56928 c:\dos6\mouse
d:
rem LH /L:1,52080 undelete /sd
c:
goto :end

:lan
@set comspec=c:\dos6\command.com
d:
cd \lantasti
@call   startnet
@goto :end

:clean
@goto :end

:backup
d:
cd \lantasti
@call   startnet
@d:
@cd \
@call saved
@E:
@cd \
@call savee
reboot1

:end
@c:
@call timedate
@df
@PROMPT $P$G
@echo Drivers for SCSI Syquest for OS/2 in telix dir.
