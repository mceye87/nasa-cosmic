      REAL*8 FUNCTION PERIOD(GRAVMU,SCPOS,SCVEL)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C THIS ROUTINE COMPUTES THE ORBITAL PERIOD OF A SATELLITE GIVEN THE
C POSITION AND VELOCITY VECTOR. 
C
C VARIABLE DIM TYPE I/O DESCRIPTION
C -------- --- ---- --- -----------
C
C GRAVMU    1  R*8   I  GRAVITATIONAL COEFFICIENT IN KM**3/SEC**2.
C
C                       IF ZERO OR NEGATIVE, THE EARTH CENTRAL BODY TERM
C                       IS USED. THE VALUE IS OBTAINED FROM THE CONST
C                       ROUTINE.
C
C SCPOS     3  R*8   I  THE S/C POSITION VECTOR. IN KM.
C
C                       NOTE ON SCPOS AND SCVEL:
C
C                         MOTION IS ASSUMED TO BE CIRCULAR OR ELLIPTICAL
C                         ABOUT THE BODY FOR WHICH GRAVMU IS GIVEN. THE
C                         FUNDAMENTAL PLANE AND PRINCIPAL DIRECTION MAY
C                         BE ANY CONVENIENT SYSTEM. THE ORIGIN IS THE 
C                         BODY ABOUT WHICH MOTION OCCURS.
C
C SCVEL     3  R*8   I  THE S/C VELOCITY VECTOR. IN KM/SEC.
C
C PERIOD    1  R*8   O  THE FUNCTION VALUE RETURNED. THIS IS THE ORBITAL
C                       PERIOD IN SECONDS.
C
C***********************************************************************
C
C BY C PETRUZZO, 11/83
C    MODIFIED.......
C
C***********************************************************************
C 
      REAL*8 GRAVMU,SCPOS(3),SCVEL(3),ELEMS(6)
      REAL*8 TWOPI/ 6.283185307179586D0 /
C
C SOURCE OF EQUATIONS: ORBITAL FLIGHT HANDBOOK, PART 1, PAGE III-24, 
C     EQN 4-1.  THE HANDBOOK WAS DONE BY THE MARTIN COMPANY FOR MSFC. 
C
      VMU = GRAVMU
      IF(GRAVMU.LE.0.D0) VMU = CONST(56)
C
      R = DSQRT( SCPOS(1)**2 + SCPOS(2)**2 + SCPOS(3)**2 )
      VSQ =      SCVEL(1)**2 + SCVEL(2)**2 + SCVEL(3)**2
C
      SMA = R / (2.D0 - (R*VSQ/VMU) )
C
      PERIOD = TWOPI * SMA * DSQRT(SMA/VMU)
C
      RETURN
      END
