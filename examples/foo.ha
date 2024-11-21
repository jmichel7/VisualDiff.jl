 Most commands may be preceded by a repetition factor.
 Those marked (mode) are toggles. 
 The state of toggles is shown on the top line.

                   {BOX  Moving around: }

{HL ↑}.{HL k}             Scroll one line up
{HL ↓}.{HL <CR>}.{HL j}        Scroll one line down
{HL PgUp}.{HL ^B}         Scroll one screen up
{HL PgDn}.{HL ^F}.{HL Space}   Scroll one screen down
{HL Ctrl-U}/{HL Ctrl-D}   Scroll one half screen up/down
{HL Ctrl-PgUp}       Go to top of file
{HL Ctrl-PgDn}.{HL \$}     Go to bottom of file
{BOX n}{HL G}              Go to line {BOX n} (to end of file if no {BOX n} given)
{HL ←}/{HL →}             Scroll one column left/right   (only if no folding)
{HL Ctrl-←}/{HL Ctrl-→}   Scroll ten columns left/right  (only if no folding)
{HL Home}/{HL End}        Scroll all the way left/right  (only if no folding)
{HL /}/{HL ?}             Search/search backward for pattern.
{HL n}               Search again for pattern
{HL N}               Search again for pattern in reverse direction

                    {BOX  Changing the display: }

{HL f}               (mode) fold lines
{HL E}               (mode) make empty space visible
{HL T}               (mode) make tabs visible
{BOX n}{HL t}              Set tab value to {BOX n} (no {BOX n} means display tabs as '\x09')

                    {BOX  Miscellaneous: }

{HL h}.{HL F1}            Display this message
{HL F9}              Shell escape.
{HL Esc}.{HL Q}.{HL q}.{HL F10}     Leave the browser

                    {BOX  Mouse actions: }

  You can click on any menu item and on the arrows in the scroll bars.
