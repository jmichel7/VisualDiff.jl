 Most commands may be preceded by a repetition factor.  Those marked (mode) are toggles.  The state of toggles is shown on the top line.

                   {1 Moving around: }

{2↑}.{2k}             Scroll one line up
{2↓}.{2<CR>}.{2j}        Scroll one line down
{2PgUp}.{2^B}         Scroll one screen up
{2PgDn}.{2^F}.{2Space}   Scroll one screen down
{2Ctrl-U}/{2Ctrl-D}   Scroll one half screen up/down
{2Ctrl-PgUp}       Go to top of file
{2Ctrl-PgDn}.{2$}     Go to bottom of file
{1n}{2G}              Go to line {1n} (to end of file if no {1n} given)
{2←}/{2→}             Scroll one column left/right   (only if no folding)
{2Ctrl-←}/{2Ctrl-→}   Scroll ten columns left/right  (only if no folding)
{2Home}/{2End}        Scroll all the way left/right  (only if no folding)
{2/}/{2?}             Search/search backward for pattern.
{2n}               Search again for pattern
{2N}               Search again for pattern in reverse direction

                    {1 Changing the display: }

{2f}               (mode) fold lines
{2E}               (mode) make empty space visible
{2T}               (mode) make tabs visible
{2a}               (mode) interpret ANSI video attribute escape sequences
{2B}               (mode) interpret BackSpaces
{1n}{2t}              Set tab value to {1n} (no {1n} means display tabs as '	')

                    {1 Miscellaneous: }

{2h}.{2F1}            Display this message
{2F9}              Shell escape.
{2Esc}.{2Q}.{2q}.{2F10}     Leave the browser

                    {1 Mouse actions: }

  You can click on any menu item and on the arrows in the scroll bars.


