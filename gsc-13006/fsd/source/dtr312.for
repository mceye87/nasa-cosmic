      SUBROUTINE DTR312(A1,A2,A3,C)
C
      IMPLICIT REAL*8(A-H,O-Z)
C
      DIMENSION C(3,3)
C
      CGAM=DCOS(A1)
      SGAM=DSIN(A1)
      CALP=DCOS(A2)
      SALP=DSIN(A2)
      CBET=DCOS(A3)
      SBET=DSIN(A3)
C
      SASB=SALP*SBET
      SACB=SALP*CBET
C
      C(1,1)=CBET*CGAM-SASB*SGAM
      C(2,1)=CBET*SGAM+SASB*CGAM
      C(3,1)=-CALP*SBET
      C(1,2)=-CALP*SGAM
      C(2,2)=CALP*CGAM
      C(3,2)=SALP
      C(1,3)=SBET*CGAM+SACB*SGAM
      C(2,3)=SBET*SGAM-SACB*CGAM
      C(3,3)=CALP*CBET
C
      RETURN
C
      END
