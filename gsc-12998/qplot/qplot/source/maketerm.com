$ IF F$MODE() .EQS. "BATCH" THEN SET PROCESS/NAME= "A New QPLOT"
$ SET DEFAULT [QPLOT.QPLOT.SOURCE]
$ PAS/NOLIST  MAKETERM
$ LINK/NOMAP  MAKETERM,QPLOT/L
$ RUN MAKETERM
$ DELETE MAKETERM.OBJ;*
$ DELETE MAKETERM.EXE;*
$ @PAS TERMIO     QQTERM 'P1'
$ PURGE
