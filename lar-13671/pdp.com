$ SET TERMINAL/ESCAPE
$ INQUIRE TERM "ENTER PDP TERMINAL SPECIFIER"
$ OPEN/WRITE OUTFILE FOR001
$ WRITE OUTFILE TERM 
$ CLOSE OUTFILE
$ ALLOCATE 'TERM'
$ INQUIRE SPEED "ENTER PDP TERMINAL SPEED"
$ SET TERMINAL 'TERM'/SPEED='SPEED'/PASSALL/EIGHTBIT/NOECHO/TYPE_AHEAD
$ RUN SYSSERV
$ EXIT
