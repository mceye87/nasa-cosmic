      SUBROUTINE RDCAT3A2A(TARGDATA,MAXPARM,TARGPARM,KTARGID,TARGNAME,
     *        KTARGTYP,NLOADED,LUERR,IERR)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C THIS IS A SERVICE ROUTINE FOR THE TARGET CATALOGUE READER. IT
C LOADS THE ARRAY TARGPARM FROM THE INPUT ARRAY TARGDATA. THIS
C ROUTINE IS FOR TARGET TYPE 3 ONLY.
C 
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
      REAL*8 TARGPARM(MAXPARM),TARGDATA(MAXDATA),TEMP3(3),DUM3(3)
      CHARACTER*16 TARGNAME
      REAL*8 DEGRAD / 57.29577951308232D0 /
      LOGICAL HAVEALL
C
C
C INITIALIZE
C
      IERR = 0
      IF(KTARGTYP.NE.3) STOP ' RDCAT3A2A. PROGRAMMER ERROR. SEE CODE.'
      NEEDLOC = NUMPARM(3)
C
C IF NEEDLOC IS GT MAXPARM, THERE IS NOT ENOUGH SPACE IN TARGPARM TO
C HOLD THE DATA, SO DO NOT LOAD ANY.
C
      IF(NEEDLOC.GT.MAXPARM) THEN
        NLOADED = 0
        IERR = KERRFLG2
        GO TO 9900
        END IF
C
C VERIFY THAT NECESSARY DATA IS PRESENT
C
      HAVEALL = .TRUE.
      DO I=1,NEEDLOC
        HAVEALL = HAVEALL .AND. TARGDATA(I).NE.DEFALT
        END DO
C
C IF SOME NECESSARY DATA IS MISSING, SET ERROR FLAG AND DO NOT LOAD
C TARGPARM.
C
      IF(.NOT.HAVEALL) THEN
        NLOADED = 0
        IERR = KERRFLG1
        GO TO 9900
        END IF
C
C ALL OK. LOAD TARGPARM.
C
      IF(DABS(TARGDATA(3)).LT.2.D0) THEN
        KFLAG = JIDNNT(TARGDATA(3))
      ELSE
        KFLAG = 2
        END IF
C
      IF(KFLAG.EQ.0) THEN             ! IN RADIANS
        TARGPARM(1) = TARGDATA(1)
        TARGPARM(2) = TARGDATA(2)
C
      ELSE IF(KFLAG.EQ.1) THEN        ! IN DEGREES
        TARGPARM(1) = TARGDATA(1)/DEGRAD
        TARGPARM(2) = TARGDATA(2)/DEGRAD
C
      ELSE                            ! IN HHMMSS.SSS AND DDMMSS.SSS
C      CONVERT RIGHT ASCENSION TO DEGREES
        HHMMSS = TARGDATA(1)
        TPACK = 500101.D0 + DABS(HHMMSS/1.D6)
        CALL UNPACK(TPACK,DUM3,TEMP3) !TEMP3=HH,MM,SS.SSS
        TEMP = TEMP3(1) + TEMP3(2)/60.D0 + TEMP3(3)/3600.D0 ! HOURS
        RACNDEG = TEMP * 15.D0
        IF(HHMMSS.LT.0.D0) RACNDEG = - RACNDEG
C      CONVERT DECLINATION TO DEGREES
        DDMMSS = TARGDATA(2)
        TPACK = 500101.D0 + DABS(DDMMSS/1.D6)
        CALL UNPACK(TPACK,DUM3,TEMP3) !TEMP3=DD,MM,SS.SSS
        TEMP = TEMP3(1) + TEMP3(2)/60.D0 + TEMP3(3)/3600.D0 ! DEG
        DECLDEG = TEMP
        IF(DDMMSS.LT.0.D0) DECLDEG = - DECLDEG
C      PUT THEM IN TARGPARM
        TARGPARM(1) = RACNDEG/DEGRAD
        TARGPARM(2) = DECLDEG/DEGRAD
        END IF
C
      TARGPARM(3) = 0.D0  ! SINCE NOW IN RADIANS
      NLOADED = 3
C
C
 9900 CONTINUE
      RETURN
      END
