## clide - version 0.9

clide is a program for color formating text in files for display mostly in
terminals using ANSI escape sequences.


# Installation

To install clide, simply run

  make
  make install (as root)

There is also an rpm spec build file included so that you can make
your own RPM if you want, or you can download the premade RPM
from the clide website at http://suso.suso.org/xulu/clide

# Usage

You can use it in a command pipeline or by running it against a file or
multiple files that are passed as arguments. In order to colorize or
add attributes to the text like bold or underline, you need to do one
of two things. The first way is to use the -e option and pass a search
expression along with the colors and attributes you want to set for
search matches. For example, this is done like so:

  clide -e /search/,fg=red fileinput.txt

 The second method is to create an expression file that has saved
search patterns, one per line. The syntax is exactly the same as
what is passed to the -e option.  To specify an expression file, use
the -f option.  For example, if you had a expression config file
called lsfilter.conf with the following contents:

```
# This is a comment
# Make directory entries show in blue
/^d.*/,fg=blue,bold
# Use a strong color and make blink world writable file entries.
/^.rw.rw.rw./,fg=yellow,bold,blink 
# Show files with a .conf or .cnf at the ne of their name in magenta
/\b.*\.co?nf$/,fg=magenta
```


You could use that expression file like this:
  
 ls -l | clide -f ~/.clide/lsfilter.conf

Its strongly recommended that you read the man page.  If you didn't
install clide yet, then you can view the man page by running

  perldoc /path/to/clide


