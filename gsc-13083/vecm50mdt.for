      SUBROUTINE VECM50MDT(TSEC50,KEY,VECIN,VECOUT)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C PURPOSE: THIS ROUTINE CONVERTS A VECTOR FROM/TO MEAN OF 1950.0
C          COORDINATES TO/FROM MEAN OF DATE COORDINATES.
C
C VARIABLE DIM TYPE I/O DESCRIPTION
C -------- --- ---- --- -----------
C
C TSEC50    1  R*8   I  TIME IN SECONDS SINCE 1/1/50, 0.0 HR FOR THE
C                       'OF DATE' VECTOR.
C
C KEY       1  I*4   I  INDICATES THE ROTATION TO BE DONE.
C                       = NEGATIVE, FROM MEAN OF DATE TO MEAN OF 1950.0
C                       = OTHERWISE, MEAN OF 1950.0 TO MEAN OF DATE
C
C VECIN     3  R*8   I  THE CARTESIAN VECTOR TO BE ROTATED. ANY UNITS.
C
C VECOUT    3  R*8   O  THE CARTESIAN VECTOR RESULTING FROM THE 
C                       ROTATION. SAME UNITS AS VECIN.
C
C                       THE CALLING ROUTINE MAY USE THE SAME ARRAY NAME
C                       FOR VECIN AND VECOUT. THAT IS, 
C                       CALL VEC50MDT(TSEC50,KEY,VEC,VEC) IS VALID.
C
C***********************************************************************
C
C BY C PETRUZZO, 4/84.
C     MODIFIED....
C
C***********************************************************************
C
      REAL*8 VECIN(3),VECOUT(3),TEMP3(3),ROTM50MDT(3,3)
      REAL*8 TLAST/-1.D30/
C
      IF(TSEC50.NE.TLAST) CALL M50MDT(TSEC50,1,ROTM50MDT)
C
      IF(KEY.LT.0) THEN
        CALL MTXMUL2(ROTM50MDT,VECIN,TEMP3,3,3,1)   ! TO M50
      ELSE
        CALL MTXMUL1(ROTM50MDT,VECIN,TEMP3,3,3,1)   ! TO MDT
        END IF
C
      VECOUT(1) = TEMP3(1)
      VECOUT(2) = TEMP3(2)
      VECOUT(3) = TEMP3(3)
C
      TLAST = TSEC50
      RETURN
      END
