      SUBROUTINE XICAL(XI,ZLK,Z11,Z24,Z1,M,K)
C
C     'XICAL' CALCULATES THE CENTER OF MASS OF AN ELEMENT IN THE
C     ELEMENT FRAME.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      COMMON/DEBUG3/ISWTCH
C
      COMMON/IPOOL1/ IGRAV,IDAMP,IK,K1,ITIM,IAB,IAPS,IBB,IBPS,NK(10),
     .               LK(10),LLK(10)
C
      DIMENSION XI(3),ZLK(10),Z11(3,10),Z24(9,10),Z1(10)
C
C
      IF(ISWTCH.EQ.0) WRITE(6,20002) K,M
      SUM3=0.0D0
      SUM4=0.0D0
      SUM5=0.0D0
      SUM6=0.0D0
C
      DO 20 I=1,M
      SUM1=0.0D0
      SUM2=0.0D0
C
      DO 10 J=1,M
      A1=FUNA(K,K1,J)
      B1=FUNB(K,K1,J)
      IJ=3*(I-1)+J
      SUM1=SUM1+B1*Z24(IJ,K)
   10 SUM2=SUM2+A1*Z24(IJ,K)
C
      A1=FUNA(K,K1,I)
      B1=FUNB(K,K1,I)
      SUM3=SUM3+SUM1*B1
      SUM4=SUM4+SUM2*A1
      SUM5=SUM5+A1*Z11(I,K)
      SUM6=SUM6+B1*Z11(I,K)
   20 CONTINUE
C
      XI(1)=ZLK(K)*Z1(K)  - ((SUM4 + SUM3)/(2.D0*ZLK(K)))
      XI(2)=SUM5
      XI(3)=SUM6
C
      IF(ISWTCH.EQ.0) WRITE(6,10000) (XI(J),J=1,3)
C
      RETURN
C
10000 FORMAT('0XI(K,J)',//3G15.5)
20002 FORMAT('0',5X,'XICAL  ',2I4)
C
      END
