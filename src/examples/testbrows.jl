include("../Curses.jl")

function my_colors()
Color.init( 
:NORM=>"black on white", 
:BOX=>"blue on white", 
:HL=>"bright red on white", 
:MENU=>"bright yellow on blue ", 
:BAR=>"bright yellow on red",
:GREY=>"yellow on white", 
:MTEXT=>"bright white on blue ", 
:MKEY=>"bright yellow on blue ", 
:BG=>"black on cyan", 
:ABSENT=>"yellow on green", 
:DIFF=>"cyan on white",
:EMPTY=>"yellow on blue ", 
:LDIFF=>"blue on white", 
:TAB=>"white on magenta",
:LEQ=>"red on blue",
:BLACK=>"black on black")
end

function main(ARGS)
initscr2()
#raw
noecho()
keypad(stdscr,true)
my_colors()
for f in ARGS browse_file(f) end
endwin()
end
#def_prog_mode
#close_screen
#rescue Exception => e
#def_prog_mode
#close_screen
#print "<#{e.message}> in\n#{e.backtrace.join("\n")}\n" unless SystemExit===e
