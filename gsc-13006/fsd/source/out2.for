      SUBROUTINE OUT2(WORD,IN1,IN2,JN1,JN2,RATRIX)
      IMPLICIT REAL*8(A-H,O-Z)
      DIMENSION RATRIX(3,3)
      IW=6
      WRITE(IW,10)WORD,IN1,JN1,((RATRIX(L,LL),L=IN1,IN2),LL=JN1,JN2)
   10 FORMAT(1X,A8,I3,',',I3,')',3D16.8,19X/(17X,3D16.8,16X))
      RETURN
      END