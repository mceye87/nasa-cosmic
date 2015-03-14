      SUBROUTINE DUMP(R,ISOLV,ILAB)
      DOUBLE PRECISION R(1),OUT(12)
      INTEGER ILAB(1)
C
      ICOUNT=0
      IFLAG=0
      JMIN=1
      JMAX=12
      IF(ISOLV.LT.JMAX) JMAX=ISOLV
      IC=1
      L=ISOLV
      IF(ISOLV.GT.12) L=12
      M=12
    3 IK=0
      WRITE(6,200)
      WRITE(6,210) (ILAB(MX),MX=IC,L)
      DO 4 J=JMIN,JMAX
      IF(IFLAG.EQ.0) KK= J - (ICOUNT*12)
      IF(IFLAG.EQ.1) KK= 12
      IF(IC.GT.1) KK= KK + (12*ICOUNT)
      DO 1 I=IC,KK
      K=((J*(J-1))/2)+I
      IK=IK+1
      OUT(IK)=R(K)
C     IF((DABS(OUT(IK))).LT..4D0) OUT(IK)=1000.0D0
    1 CONTINUE
      WRITE(6,220) ILAB(J),(OUT(MX),MX=1,IK)
      IK=0
    4 CONTINUE
      IF(ISOLV.LE.JMAX.AND.ISOLV.LE.L) GO TO 6
      IF(ISOLV.LE.JMAX) GO TO 5
      JMIN=JMIN+12
      IF(ISOLV.GT.JMAX) IFLAG=1
      IF(ISOLV.GT.JMAX) JMAX=JMAX+12
      IF(ISOLV.LT.JMAX) JMAX=ISOLV
      GO TO 3
    5 CONTINUE
      ICOUNT=ICOUNT+1
      IFLAG=0
      JMIN=1+ICOUNT*12
      JMAX=12+ICOUNT*12
      IF(ISOLV.LE.JMAX) JMAX=ISOLV
      L=L+12
      IC=IC+12
      IF(L.GT.ISOLV) L=ISOLV
      IF(IC.GT.ISOLV) GO TO 6
      GO TO 3
    6 RETURN
  200 FORMAT(1H1)
  210 FORMAT(1H0,6X,12I5)
  220 FORMAT(1H0,I6,12F5.3)
      END