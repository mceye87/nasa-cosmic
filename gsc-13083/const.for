      REAL*8 FUNCTION CONST(INDEX)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C THIS ROUTINE RETURNS VARIOUS CONSTANT VALUES AS INDICATED BY THE
C INDEX INPUT TO IT. IT ALSO HAS AN ENTRY POINT, CONST1, THAT ALLOWS
C CONSTANT VALUES TO BE REDEFINED.
C
C
C USAGE: THIS ROUTINE IS AN ALTERNATE WAY TO DEFINE CONSTANTS IN A
C        LARGE PROGRAM WITHOUT HARD CODING THEM OR USING COMMON BLOCKS.
C        A ROUTINE CAN CALL THIS ONE TO SET INTERNAL VARIABLES WHEN AN 
C        INITIALIZATION FLAG INDICATES THAT THE ROUTINE HAS NOT SET ITS
C        CONSTANTS.
C
C      EXAMPLES:
C
C      1.  IN THE CALLING PROGRAM, WE WANT TO SET THE EARTH GRAVITATION
C          CONSTANT. IN THE CALLING PROGRAM, WE CODE
C
C                  EARTHMU = CONST(56)
C
C      2.  IN THE CALLING PROGRAM WE WANT TO REDEFINE THE EARTH
C          GRAVITATION CONSTANT SO THAT SUBSEQUENT CALLS TO CONST WILL
C          RETURN THE REPLACEMENT VALUE. WE RESET IT BY
C
C                  CALL CONST1(56,398602.D0)
C
C          SUBSEQUENT STATEMENTS  XX=CONST(56) RESULT IN XX BEING SET TO
C          398602.D0
C
C
C VARIABLE DIM TYPE I/O DESCRIPTION
C -------- --- ---- --- -----------
C
C INDEX     1  I*4   I  THE INDEX DESCRIBING THE QUANTITY INVOLVED.
C
C                       ASSIGNMENTS ARE:
C
C                        1 PI
C                        2 PI/2
C                        3 2*PI
C                        4 DEGREES PER RADIAN(=57.29.....)
C                        5 KILOMETERS PER NAUTICAL MILE
C                        6 KILOMETERS PER INTERNATIONAL FOOT
C                        7 KILOMETERS PER LIGHT YEAR
C                        8 NEWTONS PER POUND(FORCE)
C                        9-50 NO USED
C                       51 EARTH RADIUS FOR GRAVITY COMPUTATIONS. IN KM.
C                       52 EARTH RADIUS FOR SCALING LENGTHS FROM 
C                          KM TO EARTH RADII. IN KM.
C                       53 EARTH RADIUS AT THE EQUATOR. IN KM.
C                       54 SUN RADIUS. IN KM.
C                       55 LUNAR RADIUS(MEAN). IN KM.
C                       56 EARTH GRAVITATIONAL PARAMETER. KM**3/SEC**2.
C                       57 SUN GRAVITATIONAL PARAMETER. KM**3/SEC**2.
C                       58 MOON GRAVITATIONAL PARAMETER. KM**3/SEC**2.
C                       59 EARTH FLATTENING COEFFICIENT
C                       60 ASTRONOMICAL UNIT FOR ANALYTIC EPHEMERIS 
C                          COMPUTATIONS. IN KM.
C                       61-63 GSFC LOCATION(APPROX).  LAT, LONG, HGT.
C                          IN RADIANS AND KM.
C                       64 ROTATION RATE OF THE EARTH. NON-PRECESSING
C                          FRAME. IN RADIANS/SEC.
C                       65 ROTATION RATE OF THE EARTH. PRECESSING
C                          FRAME. IN RADIANS/SEC.
C                       66 VELOCITY OF LIGHT IN A VACUUM. IN KM/SEC.
C
C                       67-100 NOT USED.
C
C CONST     1  R*8   O  THE VALUE ASSIGNED TO THIS FUNCTION SUBROUTINE.
C
C VALUE     1  R*8   I  THE VALUE TO BE ASSIGNED TO THE PARAMETER
C                       IDENTIFIED BY INDEX. USED FOR ENTRY POINT CONST1
C
C***********************************************************************
C
C  SOURCES :
C
C     1. SHUTTLE OPERATIONAL DATA BOOK.
C        VOLUME 1, SHUTTLE SYSTEMS PERFORMANCE AND CONSTRAINTS DATA
C        JSC 08934, VOL 1, REVISION C AND UPDATES AS OF 10/3/83.
C     2. EXPLANATORY SUPPLEMENT TO THE EPHEMERIS. 1974 REPRINT OF 1961
C        EDITION. GSFC LIBIRARY NUMBER QB8.U5, E96.
C     3. NASA SP-7012: THE INTERNATIONAL SYSTEM OF UNITS. (1964)
C
C**********************************************************************
C
C  BY C PETRUZZO, 11/83.
C    MODIFIED....  CJP 4/85. ADDED CONSTANT NUMBER 8.
C
C**********************************************************************
C
      PARAMETER NCONSTS = 100
      REAL*8 CONSVAL(NCONSTS)/ NCONSTS*-999.D0 /
C
      INTEGER INIT/1/
C
      KEY = 1
      GO TO 10
C
C
      ENTRY CONST1(INDEX,VALUE)
      KEY = 2
C
   10 CONTINUE
C
      IF(INIT.NE.1) GO TO 500
C
C***********************************************************************
C
C
C ********************
C *                  *
C *  INITIALIZATION  *
C *                  *
C ********************
C
      INIT=0
C
C   PI
C
      PI = DACOS(-1.D0)
      CONSVAL(1) = PI
C
C   PI/2
C
      CONSVAL(2) = PI/2.D0
C
C   2*PI
C
      CONSVAL(3) = PI+PI
C
C   DEGREES PER RADIAN
C
      DEGRAD = 180.D0/PI
      CONSVAL(4) = DEGRAD
C
C   NUMBER OF KM PER NAUTICAL MILE
C
      CONSVAL(5) = 1.852D0  ! JSC 08934, VOL I, P 8.5-1
C
C   NUMBER OF KM PER INTERNATIONAL FOOT
C
      CONSVAL(6) = 0.3048D-3    ! JSC 08934, VOL I, P 8.5-1
C
C   NUMBER OF KM PER LIGHT YEAR
C
      SECCENT = 36525.D0 * 86400.D0
      VLIGHT = 299792.5D0 ! JSC 08934, VOL I, P 8.1-4
      CONSVAL(7) = VLIGHT * SECCENT
C
C   NEWTONS PER POUND(FORCE)
C
      CONSVAL(8) = 4.4482216152605D0  ! NASA SP-7012
C
C
C
C
C   EARTH RADIUS FOR GRAVITATION COMPUTATIONS. IN KM.
C
      CONSVAL(51) = 6378.160D0  ! JSC 08934, VOL I, P 8.1-3
C
C   EARTH RADIUS FOR SCALING LENGTHS FROM KM TO EARTH RADII. IN KM.
C
      CONSVAL(52) = 6378.165D0 ! JSC 08934, VOL I, P 8.5-1
C
C   EARTH RADIUS AT THE EQUATOR. IN KM.
C
      CONSVAL(53) = 6378.166D0  ! JSC 08934, VOL I, P 8.4-1
C
C   SUN RADIUS. IN KM.
C
      CONSVAL(54) = 696000.D0   ! EPHEMERIS SUPPLEMENT, P 489
C
C   LUNAR RADIUS(MEAN). IN KM.
C
      CONSVAL(55) = 1738.090D0   ! JSC 08934, VOL I, P 8.1-3
C
C   EARTH GRAVITATIONAL PARAMETER. IN KM**3/SEC**2.
C
      CONSVAL(56) = 398601.2D0 ! JSC 08934, VOL I, P 8.1-3
C
C   SUN GRAVITATIONAL PARAMETER. IN KM**3/SEC**2.
C
      CONSVAL(57) = 1.32712499D11  ! JSC 08934, VOL I, P 8.1-4
C
C   MOON GRAVITATIONAL PARAMETER. IN KM**3/SEC**2.
C
      CONSVAL(58) = 4902.78D0      ! JSC 08934, VOL I, P 8.1-4
C
C   EARTH FLATTENING COEFFICIENT
C
      CONSVAL(59) = 1.D0 / 298.3D0   ! JSC 08934, VOL I, P 8.4-1
C
C   ASTRONOMICAL UNIT FOR ANALYTIC EPHEMERIS COMPUTATIONS. IN KM.
C
      CONSVAL(60) = 149.6D6  ! EPHEMERIS SUPPLEMENT, P 498
C
C   GSFC LOCATION(APPROX). IN RADIANS AND KM.
C
      CONSVAL(61) =  39.D0/DEGRAD   ! LAT.  FROM APOLLO-ERA STDN DATA.
      CONSVAL(62) = 283.D0/DEGRAD   ! LONG.
      CONSVAL(63) = 0.D0            ! HGT.
C
C   ROTATION RATE OF THE EARTH. IN RADIANS/SEC.
C
      CONSVAL(64) = ERTROT(0.D0,0)   ! RELATIVE TO NON-PRECESSING FRAME
      CONSVAL(65) = ERTROT(0.D0,1)   ! RELATIVE TO PRECESSING FRAME
C
C   VELOCITY OF LIGHT IN A VACUUM. IN KM/SEC.
C
      CONSVAL(66) = VLIGHT
C
C
C***********************************************************************
C
C
  500 CONTINUE
C
C
C ERROR CHECK:
      IF(INDEX.LT.1 .OR. INDEX.GT.NCONSTS) THEN
        STOP ' ERROR END FROM CONST. BAD INDEX VALUE.'
        END IF
C
C
      IF(KEY.EQ.1) THEN
C
C       *************************************
C       *  RETURN A CONSTANT TO THE CALLER  *
C       *************************************
C
        CONST = CONSVAL(INDEX)
        END IF
C
C
      IF(KEY.EQ.2) THEN
C
C       *************************
C       *  REDEFINE A CONSTANT  *
C       *************************
C
        CONSVAL(INDEX) = VALUE
        END IF
C
C
      RETURN
      END
