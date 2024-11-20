rem set blaster=A220 D1 I5 T3
rem c:\dos6\mscdex.exe /d:mvcd001 /m:10 /v
PROMPT $P$G
set comspec=c:\dos6\command.com
rem set editor=c:\bin\vi.exe %%d
path C:\UNIX\BIN;C:\BAT;C:\dos6;C:\util;c:\WINDOWS;C:\emtex;C:\cpav;C:\borlandc\bin;D:\nu;
numlkoff
set home=c:\etc
set glob=c:\etc\glob.exe
set graph=c:\borlandc\bgi
verify ON
i am the kingset TEMP=c:\TEMP
set tmp=c:\tmp
goto %config%

:virus
set CPAV=C:\CPAV\CPAV.INI
speedisk C: /FF /SD /V
speedisk D: /FF /SD /V
c:\cpav\VSAFE /1+/2-/3-/4+/5+/6+/7-/8-
c:\cpav\CPAV.EXE /S
C:\cpav\BOOTSAFE
numlkoff
verify ON
set TEMP=C:\TEMP
set tmp=c:\tmp
\nu\speedisk c: /FF /SD /V /B
speedisk D: /FF /SD /V /B
goto :end

:nolan
LH /L:1,56928 mouse
subst p: c:\
subst q: d:\
goto :end

:lan
cd \lantasti
@call   startnet
@goto :end

:clean
mouse
subst p: c:\
pause speedisk ?
\nu\speedisk c: /FF /SD /V /B

:end
@call timedate
df
PROMPT $P$G
