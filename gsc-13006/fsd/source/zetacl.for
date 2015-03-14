      SUBROUTINE ZETACL(CKMAT,XID,XXD,ZBZK,XVEC)
C
C     'ZETACL' DETERMINES THE MOMENT OF RELATIVE LINEAR MOMENTUM OF AN
C     ELEMENT IN THE BODY FRAME.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      DIMENSION ZFZ(3),RODB(3),RFDB(3),CKMAT(3,3),XID(3),XXD(3,3),
     .          ZBZK(3),XVEC(3)
C
C
      CALL MULTM(CKMAT,XID,ZFZ,3,1,3)
      RODB(1)=ZBZK(2)*ZFZ(3) - ZBZK(3)*ZFZ(2)
      RODB(2)=ZBZK(3)*ZFZ(1) - ZBZK(1)*ZFZ(3)
      RODB(3)=ZBZK(1)*ZFZ(2) - ZBZK(2)*ZFZ(1)
C
      XVEC(1)=XXD(2,3) - XXD(3,2)
      XVEC(2)=XXD(3,1) - XXD(1,3)
      XVEC(3)=XXD(1,2) - XXD(2,1)
C
      CALL MULTM(CKMAT,XVEC,RFDB,3,1,3)
C
      CALL MSUM(RODB,RFDB,RSUM,3)
C
      RETURN
      END
