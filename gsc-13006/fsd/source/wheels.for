      SUBROUTINE WHEELS(ITEST,RWHEEL)
C
      IMPLICIT REAL*8(A-H,O-Z)
C
      COMMON/CONSTS/PI,TWOPI,RADIAN
C
      COMMON/OUTTHR/SMAGB(3),XMB(3),RWHEL(3)
C
      COMMON/PWHEEL/XMOMIN(3),DVMOM(3),VINIT(3),VMOM(3)
C
      COMMON/CWHEEL/VW(3),VSUR(3),VSDR(3)
C
      COMMON/HWHEEL/HWM(3)
C
      COMMON/CNOISE/VNS2(10),VNS1(10),VNSN(10),T1,T2
      COMMON/CSTAT /X(20),XDOT(20),CPARM(43)
      COMMON/ICSADM/LDUM,IRAND,NCHAN
      EQUIVALENCE(CPARM(1),TAUS),(CPARM(2),TAU1),(CPARM(3),TAU2)
      EQUIVALENCE(CPARM(4),TAUF),(CPARM(5),AKS),(CPARM(6),AKC)
      EQUIVALENCE(CPARM(7),AKA),(CPARM(8),AKF),(CPARM(9),AKB)
      EQUIVALENCE(CPARM(10),AKT),(CPARM(11),TAURAT),(CPARM(12),VOPLIM)
      EQUIVALENCE(CPARM(13),AKM1),(CPARM(14),TAUM1),(CPARM(15),VBIAS)
      EQUIVALENCE(CPARM(16),TCOUL),(CPARM(17),OMMIN)
      EQUIVALENCE(CPARM(18),ZETAS)
      EQUIVALENCE(CPARM(41),PBIAS),(CPARM(42),RBIAS)
      DIMENSION SSN(5),TCOR(5)
      EQUIVALENCE(CPARM(31),SSN(1)),(CPARM(36),TCOR(1))
      EQUIVALENCE(CPARM(19),AKM2),(CPARM(20),TAUM2),(CPARM(21),SIGND)
      EQUIVALENCE(CPARM(22),RLIM),(CPARM(23),TMOTUP),(CPARM(24),TMOTDN)
C
      COMMON/CFILTW/TSTART,DVWP(3),DVWM(3),TREF1,TREF2
C
C
      COMMON /ICNTRL/KNTRL(10)
      COMMON /JCNTRL/NCNTRL,MCNTRL,MAPCNT(20)
C
      COMMON/RPOOL1/ RHOK(10),TIME,SA(3,3),FM1(3,3),ZLK(10),OMEG(3),
     .               ZLKP(10),ZLKDP(10),CMAT(3,3),GBAR(3,3),YBCM(3),
     .               ZBZK(3,10),FCM(3,3),DTO,PHID,PHI
C
      COMMON /VARBLS/DEPEND(150),DERIV(150)
C
      DIMENSION RWHEEL(3),HM(3),WB(3)
C
      DIMENSION DV(3)
C
C
      IF(ITEST.EQ.2) GO TO 100
      IF(KNTRL(1) .NE. 0) GO TO 50
C
C     WHEEL SPEED GIVEN BY OPEN-LOOP INITIAL-RATE,CONSTANT ACCEL, LIMIT
      TST=TIME-TSTART
      DO 10 I=1,3
      VW(I)=VMOM(I)+DVMOM(I)*TST
      DV(I)=DVMOM(I)
      IF(VW(I).GT.VSUR(I)) VW(I)=VSUR(I)
      IF(VW(I).LT.VSDR(I)) VW(I)=VSDR(I)
      IF(VW(I).EQ.VSUR(I).AND.DV(I).GT.0.0D0) DV(I)=0.0D0
      IF(VW(I).EQ.VSDR(I).AND.DV(I).LT.0.0D0) DV(I)=0.0D0
   10 CONTINUE
      GO TO 190
C
C     ACTIVE CONTROL OF WHEEL SPEED   ( RCA DYNAMICS EXPLORER-B)
C
C     PICK UP STATE VARIABLES OF CONTROL SYSTEM
50     DO 55 I=1,NCNTRL
      J=MAPCNT(I)
55    X(J)=DEPEND(I+MCNTRL)
C
      OMREL=X(15)-OMEG(2)
C     GENERATE NOISE
      IF(NCHAN.NE.0) CALL EXPN(TIME,T2,T1,VNS2,VNS1,SSN,TCOR,VNSN)
C
C     SPACECRAFT ATTITUDE
      CALL DEBANG(YAW,ROLL,PITCH)
      PITCH=PITCH+PBIAS+VNSN(1)
      ROLL=ROLL+RBIAS+VNSN(2)
C
C     PITCH SENSOR
      EPITCH=PITCH
      X(17)=EPITCH
      IF(KNTRL(1) .EQ. 1) GO TO 75
C
C    4TH ORDER SENSOR MODEL
      XDOT(4)=(EPITCH-X(3)-2.0D0*ZETAS*X(4))/TAUS
      XDOT(3)=X(4)/TAUS
      XDOT(2)=(AKS*X(3)-X(1)-2.0D0*ZETAS*X(2))/TAUS
      XDOT(1)=X(2)/TAUS
      GO TO 76
C
C     2ND ORDER SENSOR MODEL
75    CONTINUE
      XDOT(2)=(EPITCH-X(2))/TAUS
      XDOT(1)=(AKS*X(2)-X(1))/TAUS
76    CONTINUE
C
C     TEST FOR NUTATION DAMPER
      IF(KNTRL(2) .EQ. 0) GO TO 80
C     CLIP ROLL SENSOR OUTPUT
      X6=X(6)
      WS=DABS(X6)
      IF(WS.GT.RLIM) X6=RLIM*X6/WS
C
C     NUTATION DAMPER--PHASE SHIFT CIRCUIT
      AKM=AKM1
      TAUM=TAUM1
      IF(KNTRL(2).EQ.1) GO TO 78
      AKM=AKM2
      TAUM=TAUM2
C
78    CONTINUE
C
      AKMT=AKM/TAUM
      XDOT(19)=-(AKMT*X6+X(19))/TAUM
      XDOT(20)=(AKMT*X6+X(19)-X(20))/TAUM
      VNUDAM=SIGND*X(20)
C
C     ROLL SENSOR
      EROLL=ROLL
      X(18)=EROLL
C     TEST SENSOR ORDER
      IF(KNTRL(1) .EQ. 1) GO TO 85
C
C     4TH ORDER MODEL
      XDOT(9)=(EROLL-X(8)-2.0D0*ZETAS*X(9))/TAUS
      XDOT(8)=X(9)/TAUS
      XDOT(7)=(AKS*X(8)-X(6)-2.0D0*ZETAS*X(7))/TAUS
      XDOT(6)=X(7)/TAUS
      GO TO 86
C
C     2ND ORDER MODEL
85    CONTINUE
      XDOT(7)=(EROLL-X(7))/TAUS
      XDOT(6)=(AKS*X(7)-X(6))/TAUS
86    CONTINUE
      GO TO 90
C
C     NO NUTATION DAMPER
80    VNUDAM=0.
C
C     PITCH COMPENSATION AMPLIFIER
90    SVIPCA=(X(1)+VNUDAM)*AKC
C     COMPUTE OUTPUT, ASSUMING NO SATURATION
      TAURAT=TAU1/TAU2
      VOPCA=X(11)+SVIPCA*TAURAT
      WWW1=DABS(VOPCA)
C     SATURATION
      IF(WWW1.GT.VOPLIM) VOPCA=VOPLIM*VOPCA/WWW1
      XDOT(11)=(SVIPCA-VOPCA)/TAU2
      X(16)=VOPCA
C
C     TACHOMETER
54    IF(KNTRL(3) .EQ. 0) GO TO 56
C        1ST ORDER TACHOMETER MODEL
      XDOT(13)=(AKF*OMREL-X(13))/TAUF
         GO TO 57
C
C          NO DYNAMICS IN TACHOMETER
56    X(13)=AKF*OMREL
C
C     SUMMING AND POWER AMP
57    VOPA=AKA*(VOPCA+VBIAS+VNSN(3)-X(13))
C
C     MOTOR TORQUE
      TMOTOR=AKT*(VOPA-AKB*OMREL)
      IF(TMOTOR.GT.TMOTUP) TMOTOR=TMOTUP
      IF(TMOTOR.LT.TMOTDN) TMOTOR=TMOTDN
      TMOTOR=TMOTOR-OMREL*TCOUL/(OMMIN+DABS(OMREL))
      X(14)=TMOTOR
C     WHEEL DYNAMICS
      XDOT(15)=TMOTOR/XMOMIN(2)
C
C     COLLECT CONTROL DERIVATIVES INTO STATE DERIVATIVE VECTOR
      DO 60 I=1,NCNTRL
      J=MAPCNT(I)
60    DERIV(I+MCNTRL)=XDOT(J)
C
C      WIRE THINGS FOR THE REST OF THE PROGRAM
      VW(1)=0.
      VW(2)=X(15)/RADIAN
      VW(3)=0.
      DV(1)=0.
      DV(2)=XDOT(15)/RADIAN
      DV(3)=0.
C
C
C     INTERACTION WITH VEHICLE
190   DO 30 I=1,3
      WB(I)=OMEG(I)
      HM(I)=VW(I)*XMOMIN(I)
30    HWM(I)=HM(I)*RADIAN
      RWHEEL(1)=(-XMOMIN(1)*DV(1)+HM(2)*WB(3)-HM(3)*WB(2))*RADIAN
      RWHEEL(2)=(-XMOMIN(2)*DV(2)+HM(3)*WB(1)-HM(1)*WB(3))*RADIAN
      RWHEEL(3)=(-XMOMIN(3)*DV(3)+HM(1)*WB(2)-HM(2)*WB(1))*RADIAN
      RWHEL(1)=RWHEEL(1)
      RWHEL(2)=RWHEEL(2)
      RWHEL(3)=RWHEEL(3)
      GO TO 150
C
C     UPDATE INITIAL VALUES FOR CONTINUING TRAJECTORY
100   DO 120 I=1,3
120   VMOM(I)=VW(I)
C
150   RETURN
      END