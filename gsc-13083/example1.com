$! /////  THIS IS THE FIRST LINE OF EXAMPLE1.COM
$!
$!
$!                 FILE NAME = EXAMPLE1.COM
$!
$!           *****************************************
$!           *   THIS PROCEDURE EXECUTES EXAMPLE 1   *
$!           *  FOUND ON THE QUIKVIS SUBMITTAL TAPE  *
$!           *     USING THE TAPE'S PROGRAM IMAGE    *
$!           *             QUIKVIS.EXE               *
$!           *        OR A NEWLY CREATED IMAGE       *
$!           *             QUIKVIS.LDM               *
$!           *****************************************
$!
$!
$!  PARAMETER P1 IDENTIFIES THE IMAGE TO BE USED:
$!
$!    P1 = ""(IE, NULL) MEANS QUIKVIS.EXE, THE TAPE'S VERSION, IS USED
$!    P1 = "LDM" MEANS QUIKVIS.LDM IS USED(SEE PROCEDURE BIGTEST.COM)
$!    P1 = OTHERWISE, ERROR END.
$!
$!
$!  OUTPUT CREATED BY EXECUTING THIS PROCEDURE SHOULD BE THE SAME
$!  AS THAT FOUND ON THE SUBMITTAL TAPE, EXCEPT FOR RUN DATE AND
$!  TIME.
$!
$!
$!  NOTE: TO PREVENT A QUIKVIS RUN FROM CREATING DATA FILES WITH
$!        THE SAME NAMES AS ARE FOUND ON THE SUBMITTAL TAPE, THE
$!        OUTPUT FILES CREATED IN THIS RUN ARE NAMED EX1.U06, ETC.  
$!
$!
$ DIREC = "[NQCJP.COSMIC.TEST]"
$!
$ SET DEFAULT 'DIREC'
$!
$!
$ SUFFIX = "?"
$ IF("''P1'".EQS."")    THEN SUFFIX = "EXE"
$ IF("''P1'".EQS."LDM") THEN SUFFIX = "LDM"
$ IF("''SUFFIX'".EQS."?") THEN GOTO ERREND
$!
$!
$ DELETE SCRATCH.DAT;*
$!
$ ASSIGN SCRATCH.DAT     FOR001
$ ASSIGN EXAMPLE1.U05    FOR005
$ ASSIGN EX1.U06         FOR006
$ ASSIGN EXAMPLE1.U08    FOR008
$ ASSIGN EX1.U19         FOR019
$ ASSIGN EX1.U25         FOR025
$ ASSIGN EX1.U26         FOR026
$ ASSIGN EX1.U27         FOR027
$ ASSIGN EXAMPLE1.U30    FOR030
$!
$ RUN/NODEBUG QUIKVIS.'SUFFIX'
$!
$ DELETE SCRATCH.DAT;*
$ DEASSIGN FOR001
$ DEASSIGN FOR005
$ DEASSIGN FOR006
$ DEASSIGN FOR008
$ DEASSIGN FOR019
$ DEASSIGN FOR025
$ DEASSIGN FOR026
$ DEASSIGN FOR027
$ DEASSIGN FOR030
$!
$ EXIT
$!
$ ERREND:
$  WRITE SYS$OUTPUT " "
$  WRITE SYS$OUTPUT "ERROR END......'
$  WRITE SYS$OUTPUT " "
$  WRITE SYS$OUTPUT "  PARAMETER P1 MUST BE NULL OR ""LDM""."
$  WRITE SYS$OUTPUT "  P1= ''P1'"
$  EXIT
$!
$! /////  THIS IS THE LAST LINE OF EXAMPLE1.COM
