      SUBROUTINE ACTFLT(ITEST,T,ETA)
C
      IMPLICIT REAL*8(A-H,O-Z)
C
      COMMON/ACFILT/ACPARM(20),IACFLT(20)
C
      COMMON/ACTOUT/SOUT,VOUT,WOUT
C
      COMMON/CONSTS/PI,TWOPI,RAD
C
      COMMON/CSTVAL/TST
C
      COMMON/CFILTW/TSTART,DVWP(3),DVWM(3),TREF1,TREF2
C
      COMMON/CWHEEL/WSP(3),VWUP(3),VWDN(3)
C
      COMMON/DEBUG2/IOUT,JOUT,KLUGE
C
      COMMON/ITCNTL/IPULSE,ISPLSE,KPULSE,IDV1(3)
C
      COMMON/MOMENT/IDV2(4),IWHEEL,IDV3
C
      COMMON/OUTTHR/SMAGB(3),XMB1(3),RWHEEL(3)
C
      COMMON/PWHEEL/XMOMIN(3),DVW(3),VMOM(3),VW(3)
C
      COMMON/RMGNTC/SMAGI(3)
C
      COMMON/RPOOL1/DUM1(11),SA(3,3),DUM2(19),OMEG(3),DUM3(83)
C
      COMMON/SENVTR/DIY(3),DL2
C
      COMMON/SUNVTR/SLB(3)
C
      COMMON/VARBLS/DEP(150),DER(150)
C
C
      DIMENSION ETA(7),UVEC(3),SPOS(3),ACC(3)
      DIMENSION VWDOT(3)
C
C
      EQUIVALENCE (GAIN,ACPARM(1)),(TAU,ACPARM(2)),(UVEC(1),ACPARM(3))
      EQUIVALENCE (SPOS(1),ACPARM(6))
      EQUIVALENCE (WTAU,ACPARM(9))
      EQUIVALENCE (ACTTD,ACPARM(10))
      EQUIVALENCE (IFLT,IACFLT(1)),(ITYPE,IACFLT(2)),(ISEN,IACFLT(3))
      EQUIVALENCE (IIC,IACFLT(4)),(IFLAG,IACFLT(5)),(NDEP,IACFLT(6))
C
C
C     ITYPE 1 ACTUATES PULSED THRUSTING
C     ITYPE 2 ACTUATES MOMENTUM WHEEL CYCLING
C
C
      IF(ITEST.EQ.1) GO TO 4
      IF(IFLT.EQ.0) RETURN
      GO TO 100
    4 CONTINUE
C
      IF(T.EQ.TST) TSTART=TST
      DO 5 I=1,3
      DIY(I)=SLB(I)
    5 CONTINUE
C
      IF(ISPLSE.NE.2.AND.ISEN.NE.1) GO TO 8
      CALL HAG
      SUM=0.0D0
      DO 6 I=1,3
      SMAGB(I)=SA(1,I)*SMAGI(1)+SA(2,I)*SMAGI(2)+SA(3,I)*SMAGI(3)
      SUM=SUM+SMAGB(I)*SMAGB(I)
    6 CONTINUE
      SUM=DSQRT(SUM)
      DO 7 I=1,3
      DIY(I)=SMAGB(I)/SUM
    7 CONTINUE
C
    8 CONTINUE
C
      IF(IFLT.EQ.0) RETURN
      IF(T.GT.TST) GO TO 10
C
C
      VLP=DEP(NDEP)
      VLAST=VLP
      TLP=T
      TLAST=T
      ISW=0
C
C
       IF(ITYPE.EQ.1) GO TO 90
      IF(WTAU.NE.0.0D0) GO TO 1
      WS=OMEG(3)
      WS=DABS(WS)
      IF(WS.EQ.0.0D0) WS=1.0D0
      WTAU=TWOPI/WS
    1 CONTINUE
C
      DO 2 I=1,3
      DVWP(I)=(VWUP(I)-VWDN(I))/WTAU
      DVWM(I)=-DVWP(I)
    2 CONTINUE
      TREF1=-1.0D0
      DO 3 I=1,3
      IF(DVWP(I).EQ.0.0D0) GO TO 3
      TD=WTAU*(VWUP(I)-VW(I))/(VWUP(I)-VWDN(I))
      IF(TD.GT.TREF1) TREF1=TD
    3 CONTINUE
C
C
      GO TO 90
C
   10 CONTINUE
C
      VNOW=DEP(NDEP)
      TNOW=T
      IF(TNOW.LE.TLAST) GO TO 12
      VLP=VLAST
      TLP=TLAST
C
   12 CONTINUE
C
      VLAST=VNOW
      TLAST=TNOW
      IF(ITYPE.EQ.1) GO TO 90
      IF(ISW.EQ.1) GO TO 20
      IF(VLAST.LE.0.0D0) GO TO 90
      IF(VLP.GT.0.0D0) GO TO 90
      TDIF=TLAST-TLP
      TCROSS=TLP-TDIF*VLP/(VLAST-VLP)
      ISW=1
      TREF2=TCROSS+TREF1+ACTTD
      TREF1=TCROSS+ACTTD
      TSTART=TREF1
      ISIGN=1
      DO 14 I=1,3
      VW(I)=WSP(I)
      VWDOT(I)=DVWP(I)
   14 CONTINUE
C
   20 CONTINUE
C
      IF(TLAST.LT.TREF1) GO TO 95
      DO 22 I=1,3
      DVW(I)=VWDOT(I)
   22 CONTINUE
      IF(TLAST.LT.TREF2) GO TO 95
C
C     SWITCH MOMENTUM WHEEL ACC
C
      IF(ISIGN.LT.0) GO TO 30
C
      DO 25 I=1,3
      VWDOT(I)=DVWM(I)
      VW(I)=WSP(I)
   25 CONTINUE
      TSTART=TREF2
      TREF1=TREF2
      TREF2=TREF2+WTAU
      ISIGN=-1
C
      GO TO 20
C
   30 CONTINUE
C
      DO 35 I=1,3
      VWDOT(I)=DVWP(I)
      VW(I)=WSP(I)
   35 CONTINUE
      TSTART=TREF2
      TREF1=TREF2
      TREF2=TREF2+WTAU
      ISIGN=1
C
      GO TO 20
C
   90 CONTINUE
C
      IF(ITYPE.EQ.2) GO TO 95
C
      WS=DABS(VLAST)
      IF(WS.LT.0.1D0) DIY(1)=0.1D0
      DIY(2)=VLAST
C
   95 CONTINUE
C
C
      RETURN
C
C
  100 CONTINUE
C
      IF(ISEN.GT.1) GO TO 110
C
C     SENSOR MEASURES MAGNETIC FIELD
C
      SOUT=UVEC(1)*SMAGB(1)+UVEC(2)*SMAGB(2)+UVEC(3)*SMAGB(3)
      GO TO 150
C
  110 CONTINUE
C
      IF(ISEN.GT.2) GO TO 120
C
C     SENSOR IS AN ACCELEROMETER
C
      O11=OMEG(1)*OMEG(1)
      O22=OMEG(2)*OMEG(2)
      O33=OMEG(3)*OMEG(3)
      O12=OMEG(1)*OMEG(2)
      O13=OMEG(1)*OMEG(3)
      O23=OMEG(2)*OMEG(3)
      ACC(1)=ETA(1)+ETA(5)*SPOS(3)-ETA(6)*SPOS(2)
     1       -(O22+O33)*SPOS(1)+O12*SPOS(2)+O13*SPOS(3)
      ACC(2)=ETA(2)+ETA(6)*SPOS(1)-ETA(4)*SPOS(3)
     1       +O12*SPOS(1)-(O33+O11)*SPOS(2)+O23*SPOS(3)
      ACC(3)=ETA(3)+ETA(4)*SPOS(2)-ETA(5)*SPOS(1)
     1       +O13*SPOS(1)+O23*SPOS(2)-(O11+O22)*SPOS(3)
      SOUT=ACC(1)*UVEC(1)+ACC(2)*UVEC(2)+ACC(3)*UVEC(3)
      GO TO 150
C
  120 CONTINUE
C
      IF(ISEN.GT.3) GO TO 130
C
C     SENSOR IS A BODY RATE SENSOR ?
C
      SOUT=UVEC(1)*OMEG(1)+UVEC(2)*OMEG(2)+UVEC(3)*OMEG(3)
      GO TO 150
C
  130 CONTINUE
C
C     SENSOR IS A SUN SENSOR
C
      SOUT=UVEC(1)*SLB(1)+UVEC(2)*SLB(2)+UVEC(3)*SLB(3)
C
  150 CONTINUE
C
      IF(IIC.NE.0) GO TO 160
C     PUT IN INITIAL CONDITIONS FOR FILTER
C
C
      DEP(NDEP+1)=0.0D0
      DEP(NDEP)=SOUT*GAIN
      VLAST=DEP(NDEP)
      VLP=VLAST
      TLAST=T
      TLP=T
      IIC=1
      IF(ITYPE.EQ.2) GO TO 160
      DL2=DEP(NDEP)
C
  160 CONTINUE
C
      I2=NDEP+1
      DER(NDEP)=(GAIN*SOUT-DEP(NDEP)-DEP(I2))/TAU
      DER(I2)=DER(NDEP)+DEP(NDEP)/TAU
      VOUT=DEP(NDEP)
      WOUT=DEP(I2)
C
C
      RETURN
C
      END
