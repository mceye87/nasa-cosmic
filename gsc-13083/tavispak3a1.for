      SUBROUTINE TAVISPAK3A1(NLOOP,ANGREQ,UTARG,EA,SHADFCN,ORBDATA,
     *              LUERR,IERR)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C THIS ROUTINE IS PART OF THE TAVISPAK SUBROUTINE SET. IT COMPUTES
C SHADOW FUNCTION VALUES USED BY THE TAVISPAK SUBROUTINE.
C
C VARIABLE DIM TYPE I/O DESCRIPTION
C -------- --- ---- --- -----------
C
C NLOOP     1   I*4  I  ITERATION NUMBER. NEEDED BECAUSE SOME PARAMETERS
C                       ARE CONSTANT THROUGHT THE ITERATION PROCESS AND
C                       ARE COMPUTED JUST ONCE.
C
C ANGREQ    1   R*8  I  SAME DESCRIPTION AS IN TAVISPAK.
C
C UTARG     1   R*8  I  SAME DESCRIPTION AS IN TAVISPAK.
C
C EA        3   R*8  I  ECCENTRIC ANOMALIES AT WHICH THE SHADOW FUNCTION
C                       VALUES ARE WANTED.
C
C SHADFCN   3   R*8  O  SHADOW FUNCTION VALUES.  EI(I) YIELDS SHADFCN(I)
C
C ORBDATA   *   R*8  I  VALUES OF QUANTITES NEEDED TO COMPUTE SHADFCN.
C                       SET IN TAVISPAK.  SEE TAVISPAK FOR DIMENSION.
C
C IERR      1   I*4  O  ERROR RETURN FLAG.
C                        = 0, NO ERRORS.
C                        = 1, BAD ANGREQ VALUE. SEE ERROR CHECK BELOW.
C                        = 2, BAD PERIGEE VALUE. SEE ERROR CHECK BELOW.
C
C***********************************************************************
C
C CODED BY C PETRUZZO GSFC/742 10/85.
C    MODIFIED....
C
C***********************************************************************
C
C
      REAL*8 POS(3),P(3),Q(3),UTARG(3),EA(3),SHADFCN(3),
     *       ORBDATA(1),ANGOLD/1.D10/
      REAL*8 PI     / 3.141592653589793D0 /
      REAL*8 DEGRAD / 57.29577951308232D0 /
C
      IERR = 0
      IF(NLOOP.EQ.1) THEN
        SMA =   ORBDATA( 1)
        ECC =   ORBDATA( 2)
        P(1) =  ORBDATA( 3)
        P(2) =  ORBDATA( 4)
        P(3) =  ORBDATA( 5)
        Q(1) =  ORBDATA( 6)
        Q(2) =  ORBDATA( 7)
        Q(3) =  ORBDATA( 8)
        TERM1 = ORBDATA(11)
        REARTH = CONST(53)
        REARTH2 = REARTH*REARTH
        IF(ANGREQ.NE.ANGOLD) THEN
          COSREQ = DCOS(ANGREQ)
          SINREQ = DSIN(ANGREQ)
          ANGOLD = ANGREQ
          END IF
        TERM2 = REARTH * SINREQ
        END IF
C
C
C COMPUTE THE SHADOW FUNCTIONS RELATED TO THE ECCENTRIC ANOMALIES
C
      DO IPT=1,3
C
C      COMPUTE THE CARTESIAN POSITION VECTOR OF THE S/C IN ORBIT PLANE
C      COORDINATES.
        ECANOM = EA(IPT)
        TEMP = DCOS(ECANOM)
        X = SMA * (TEMP - ECC)
        Y = TERM1 * DSIN(ECANOM)
        RSQ = ( SMA*(1.D0-ECC*TEMP) )**2
C
C      COMPUTE THE CARTESIAN POSITION VECTOR IN THE SAME COORDINATE
C      SYSTEM AS TARGET LOCATION IS EXPRESSED.
        POS(1) = (X * P(1))  +  (Y * Q(1))
        POS(2) = (X * P(2))  +  (Y * Q(2))
        POS(3) = (X * P(3))  +  (Y * Q(3))
C
C      COMPUTE THE SHADOW FUNCTION
        SHADFCN(IPT) = DOT(UTARG,POS) + DSQRT(RSQ-REARTH2)*COSREQ
     *                      - TERM2
C
        END DO
C
 9999 CONTINUE
      RETURN
      END
