$ !
$ !  EIGHTY - SQUEEZE A FILE INTO RECORDS OF EIGHTY COLUMNS
$ !
$ IF P1 .NES. "" THEN GOTO POK
$NOP:
$ INQUIRE P1 "Filename"
$ IF P1 .EQS. "" THEN GOTO NOP
$POK:
$ DOT = F$LOCATE(".",''P1')
$ IF DOT .EQ. F$LENGTH(''P1') THEN GOTO NOTYPE
$ P2 = "''F$EXTRACT(0,DOT,P1)'"
$ GOTO TYPEOK
$NOTYPE:
$ P2 = P1
$ P1 = P1 + ".LIS"
$TYPEOK:
$ ASSIGN 'P1' FOR007
$ ASSIGN 'P2'.80 FOR008
$ RUN MERLIN:EIGHTY
