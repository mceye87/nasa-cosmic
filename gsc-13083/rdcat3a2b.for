      SUBROUTINE RDCAT3A2B(TARGDATA,MAXPARM,TARGPARM,KTARGID,TARGNAME,
     *     KTARGTYP,NLOADED,LUERR,IERR)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C THIS IS A SERVICE ROUTINE FOR THE TARGET CATALOGUE READER. IT
C LOADS THE ARRAY TARGPARM FROM THE INPUT ARRAY TARGDATA. THIS ROUTINE
C IS FOR TARGET TYPE 7 ONLY.
C
C***********************************************************************
C
C BY C PETRUZZO, GSFC/742, 7/85.
C    MODIFIED.....
C
C***********************************************************************
C
      INCLUDE 'RDCAT.INC'
C
      REAL*8 TARGPARM(MAXPARM),TARGDATA(MAXDATA)
      CHARACTER*16 TARGNAME
      REAL*8 DEGRAD / 57.29577951308232D0 /
      LOGICAL HAVEALL
C
C INITIALIZE
C
      IERR = 0
      NLOADED = 0
C
C ERROR CHECK
C
      IF(KTARGTYP.NE.7)
     *   STOP 'STOPED IN RDCAT3A2B. PROGRAMMER ERROR. SEE CODE.'
C
C CHECK VALIDITY OF TARGDATA(1). WE DO THE DABS CHECK BECAUSE VERY LARGE
C VALUES OF TARGDATA(1) MAY GIVE OVERFLOW ERROR WHEN JIDNNT IS USED.
C SINCE THE ONLY VALID VALUES ARE 0, 1, AND 2, THE CHECK AGAINST 4 IS
C AS GOOD AS AGAINST ANYTHING LARGER.
C
      IF(DABS(TARGDATA(1)).LT.4.D0) THEN
        KLOC1 = JIDNNT(TARGDATA(1))
      ELSE
        KLOC1 = 999   ! INVALID TARGDATA(1) VALUE. 999 FORCES AN ERROR.
        END IF
C
      IF(KLOC1.NE.0 .AND. KLOC1.NE.1 .AND. KLOC1.NE.2) THEN
C      INVALID VALUE IN TARGDATA(1)
        IERR = 1
        IF(LUERR.GT.0) WRITE(LUERR,1001) KTARGID,TARGNAME,TARGDATA(1)
 1001   FORMAT(/,' RDCAT3A2B. TARGET CATALOGUE CONTENT ERROR.'/,
     *           '    ERROR IN TARGDATA(1) VALUE'/,
     *           '    ID=',I5,'  NAME=',A,'  VALUE=',G13.5/,
     *           '    TARGET DATA NOT LOADED.')
        NLOADED = 0
        GO TO 9900
        END IF
C
C SET THE THE NUMBER OF DATA ELEMENTS THAT MUST BE SUPPLIED IN
C TARGDATA.
C
      IF(KLOC1.EQ.0) THEN
        NEEDLOC = 1
      ELSE IF(KLOC1.EQ.1) THEN
        NEEDLOC = 10
      ELSE 
        NEEDLOC = 2
        END IF
C
C VERIFY THAT ALL DATA THAT IS REQUIRED TO BE PRESENT HAS BEEN SUPPLIED.
C IF NOT ALL PRESENT, SET ERROR FLAG AND RETURN.
C
      HAVEALL = .TRUE.
      IF(NEEDLOC.GT.0) THEN
        DO I=1,NEEDLOC
          HAVEALL = HAVEALL .AND. TARGDATA(I).NE.DEFALT
          END DO
        END IF
C
      IF(.NOT.HAVEALL) THEN
        IERR = KERRFLG1
        NLOADED = 0
        GO TO 9900
        END IF
C
C BE SURE THERE ARE ENOUGH PARAMETER ELEMENTS IN TARGPARM FOR THE
C REQUIRED AMOUNT OF DATA. IF NOT, SET ERROR FLAG AND RETURN.
C
      IF(NEEDLOC.GT.MAXPARM) THEN
        IERR = KERRFLG2
        NLOADED = 0
        GO TO 9900
        END IF
C
C OK SITUATION, SO LOAD TARGPARM. NO ORBIT INFO WAS SUPPLIED.
C
      IF(KLOC1.EQ.0) THEN
        TARGPARM(1) = KLOC1
        NLOADED = 1
        GO TO 9900
        END IF
C
C OK SITUATION, SO LOAD TARGPARM. INITIAL CONDS ARE IN TARGDATA
C
      IF(KLOC1.EQ.1) THEN
        TARGPARM(1) = KLOC1
        TARGPARM(2) = JIDNNT(TARGDATA(2))  ! = COORD SYS FLAG
        TARGPARM(3) = SINCE50(TARGDATA(3)) ! = EPOCH
        TARGPARM(4) = JIDNNT(TARGDATA(4))  ! = CART OR KEPL ELEMS
        IF(JIDNNT(TARGDATA(4)).EQ.1) THEN  ! KEPLERIAN WAS SUPPLIED
          TARGPARM( 5) = TARGDATA( 5)         ! = SMA
          TARGPARM( 6) = TARGDATA( 6)         ! = ECC
          TARGPARM( 7) = TARGDATA( 7)/DEGRAD  ! = INCL
          TARGPARM( 8) = TARGDATA( 8)/DEGRAD  ! = NODE
          TARGPARM( 9) = TARGDATA( 9)/DEGRAD  ! = ARGP
          TARGPARM(10) = TARGDATA(10)/DEGRAD  ! = MEAN ANOM
        ELSE                               ! CARTESIAN WAS SUPPLIED
          DO I = 5,10                         ! = X,Y,Z, XD,YD,ZD
            TARGPARM(I) = TARGDATA(I)
            END DO
          END IF
        NLOADED = 10
        GO TO 9900
        END IF
C
C OK SITUATION, SO LOAD TARGPARM. AN EPHEM FILE IS TO BE USED.
C
      IF(KLOC1.EQ.2) THEN
        TARGPARM(1) = KLOC1
        TARGPARM(2) = DNINT(TARGDATA(2)) ! EHEM FILE UNIT NUMBER
        NLOADED = 2
        GO TO 9900
        END IF
C
C
 9900 CONTINUE
      RETURN
      END
