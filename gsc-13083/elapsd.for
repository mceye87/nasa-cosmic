      SUBROUTINE ELAPSD(DT,IDAYS,IHOURS,IMINIT,SEC)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C  CONVERT DT(SEC) TO DAYS,HOURS,MIN,SEC.  ELAPSED TIME CONVERSION.
C   EXAMPLES:  DT=93784.5 IS 1 DAY, 2 HOURS, 3 MINUTES, 4.5 SECONDS.
C              DT=86399.9 IS 0 DAYS, 23 HOURS, 59 MINUTES, 59.9 SEC.
C
C   USAGE IDEA: GIVEN TWO JULIAN DATES(INCL FRACTIONS), CAN BE USED AS-
C               CALL EPAPSD( (DATE2-DATE1)*86400.D0 ,ND,NH,NM,SEC)
C
C  VAR    DIM  TYPE  I/O DESCRIPTION
C  ---    ---  ----  --- -----------
C
C  DT     1    R*8   I   NUMBER OF SECONDS TO BE CONVERTED.
C
C  IDAYS  1    I*4   O   NUMBER OF DAYS.
C
C  IHOURS 1    I*4   O   NUMBER OF HOURS.
C
C  IMINIT 1    I*4   O   NUMBER OF MINUTES.
C
C  SEC    1    R*8   O   NUMBER OF FULL AND FRACTIONAL SECONDS.
C
C********************************************************************
C
C  TAKEN FROM 580'S MAESTRO PROGRAM. C PETRUZZO 5/81.
C
C********************************************************************
C
      REAL*8 DAYSEC/86400.D0/
C
      ABSDT=DABS(DT)
      IDAYS=ABSDT/DAYSEC
      DUM=ABSDT-IDAYS*DAYSEC
      IHOURS=DUM/3600.D0
      DUM=DUM-IHOURS*3600.D0
      IMINIT=DUM/60.D0
      DUM=DUM-IMINIT*60.D0
      SEC=DUM
      IF(DT.GT.0.D0) GO TO 999
      IDAYS=-IDAYS
      IHOURS=-IHOURS
      IMINIT=-IMINIT
      SEC=-SEC
  999 CONTINUE
      RETURN
      END
