      SUBROUTINE WHREAD
C
      IMPLICIT REAL*8(A-H,O-Z)
C
      COMMON/ADDMOM/ HAWH(3),HWL(3),HELGM(3)
C
      COMMON/ADSTAT/ DER(150),DEP(150)
C
      COMMON/CONSTS/ PI,TWOPI,RADIAN
C
      COMMON/CSTVAL/ TSTART
C
      COMMON/DATOUT/ IDATA,MLAST
C
      COMMON/DEBUG2/ IOUT,JOUT,KLUGE
C
      COMMON/IMAIN1/ IDATE,LSAVE,IDUM1(6)
C
      COMMON/ROTORS/ AMWHPR(200),IAMWH(10)
C
      COMMON/RPOOL1/ RHOK(10),TIME,SA(3,3),FM1(3,3),ZLK(10),OMEG(3),
     1 DUM01(83)
C
      COMMON/TRQOUT/ OUTTRQ(150)
C
      COMMON/VARBLS/ DEPEND(150),DERIV(150)
C
      COMMON/XIN4  / UP(150),DN(150),BNDS(22)
C
C
      DIMENSION HEDPC(5),ETA(7)
      DIMENSION HDPID(5),HDMOT(5)
      DIMENSION ANOISE(3),PNOISE(3),FNOISE(3)
      DIMENSION FREQNS(3),PHASNS(3)
      DIMENSION HDOT(3),RWHEEL(3),VWH(3),FOPT(3),OUTP(6)
      REAL*4 BUFF(450)
C
      DATA I8/',A8,'/
      DATA HEDPC/'AXIS MOM','ENTUM WH','EEL CONT','ROL SYST','EM      '/
      DATA HDPID/'WHEEL CO','NTROLLER',' PARAMET','ERS     ','        '/
      DATA HDMOT/'WHEEL  D','RIVE MOT','OR PARAM','ETERS   ','        '/
C
      EQUIVALENCE (IAMWH(1),IPCONT),(IAMWH(2),IROLL)
      EQUIVALENCE (IAMWH(3),IPITCH),(IAMWH(4),IYAW)
C
      EQUIVALENCE (AMWHPR(5),EXK)
      EQUIVALENCE (AMWHPR(11),RLQNT),(AMWHPR(21),PTQNT)
      EQUIVALENCE (AMWHPR(12),RLXIUP),(AMWHPR(22),PTXIUP)
      EQUIVALENCE (AMWHPR(13),RLXIDN),(AMWHPR(23),PTXIDN)
      EQUIVALENCE (AMWHPR(14),RLKP),(AMWHPR(24),PTKP)
      EQUIVALENCE (AMWHPR(15),RLKI),(AMWHPR(25),PTKI)
      EQUIVALENCE (AMWHPR(16),RLKD),(AMWHPR(26),PTKD)
      EQUIVALENCE (AMWHPR(17),ROLLG),(AMWHPR(27),PITCHG)
      EQUIVALENCE (AMWHPR(18),RBW),(AMWHPR(28),PBW)
      EQUIVALENCE (AMWHPR(41),RLKA),(AMWHPR(51),PTKA)
      EQUIVALENCE (AMWHPR(42),RLKT),(AMWHPR(52),PTKT)
      EQUIVALENCE (AMWHPR(43),RLKB),(AMWHPR(53),PTKB)
      EQUIVALENCE (AMWHPR(44),RLMTUP),(AMWHPR(54),PTMTUP)
      EQUIVALENCE (AMWHPR(45),RLMTDN),(AMWHPR(55),PTMTDN)
      EQUIVALENCE (AMWHPR(46),RLTCUL),(AMWHPR(56),PTTCUL)
      EQUIVALENCE (AMWHPR(47),RLDMIN),(AMWHPR(57),PTDMIN)
      EQUIVALENCE (AMWHPR(48),RLWMOI),(AMWHPR(58),PTWMOI)
      EQUIVALENCE (AMWHPR(31),YWQNT)
      EQUIVALENCE (AMWHPR(32),YWXIUP)
      EQUIVALENCE (AMWHPR(33),YWXIDN)
      EQUIVALENCE (AMWHPR(34),YWKP)
      EQUIVALENCE (AMWHPR(35),YWKI)
      EQUIVALENCE (AMWHPR(36),YWKD)
      EQUIVALENCE (AMWHPR(37),YAWG)
      EQUIVALENCE (AMWHPR(38),YBW)
      EQUIVALENCE (AMWHPR(61),YWKA)
      EQUIVALENCE (AMWHPR(62),YWKT)
      EQUIVALENCE (AMWHPR(63),YWKB)
      EQUIVALENCE (AMWHPR(64),YWMTUP)
      EQUIVALENCE (AMWHPR(65),YWMTDN)
      EQUIVALENCE (AMWHPR(66),YWTCUL)
      EQUIVALENCE (AMWHPR(67),YWDMIN)
      EQUIVALENCE (AMWHPR(68),YWWMOI)
      EQUIVALENCE (AMWHPR(80),ANOISE(1)),(AMWHPR(83),PNOISE(1))
      EQUIVALENCE (AMWHPR(86),FNOISE(1))
      EQUIVALENCE (AMWHPR(90),FREQNS(1)),(AMWHPR(93),PHASNS(1))
      EQUIVALENCE (HDOT(1),RLHD),(HWL(1),RLH)
      EQUIVALENCE (HDOT(2),PTHD),(HWL(2),PTH)
      EQUIVALENCE (HDOT(3),YWHD),(HWL(3),YWH)
C
C     CALLED FROM GMBDRD
C
      CALL SETUP(8HAMWHPR  ,8,AMWHPR,100)
      CALL SETUP(8HIAMWH   ,4,IAMWH,20)
C
      RETURN
C
C   ****************************************************************
      ENTRY NUMWHS(NUMEQS)
C   ****************************************************************
C
C     CALLED FROM NUMGPE
C
      IF(IPCONT.EQ.0) RETURN
      NROLL=NUMEQS+1
      IF(IROLL.NE.0) NUMEQS=NUMEQS+3
      NPITCH=NUMEQS+1
      IF(IPITCH.NE.0) NUMEQS=NUMEQS+3
      NYAW=NUMEQS+1
      IF(IYAW.NE.0) NUMEQS=NUMEQS+3
C
      RETURN
C
C   ****************************************************************
      ENTRY WHECHO
C   ****************************************************************
C
C     CALLED FROM ECHOGP
C
      IF(IPCONT.EQ.0) RETURN
C
      CALL HVAL(HEDPC)
C
      CALL HVAL(HDPID)
C
      IF(IROLL.NE.0) CALL FVAL('ROLL    ',4,AMWHPR(11),6,0,1)
      IF(IPITCH.NE.0) CALL FVAL('PITCH   ',4,AMWHPR(21),6,0,1)
      IF(IYAW.NE.0) CALL FVAL('YAW     ',4,AMWHPR(31),6,0,1)
C
      CALL HVAL(HDMOT)
C
      IF(IROLL.NE.0) CALL FVAL('ROLL    ',4,AMWHPR(41),7,0,1)
      IF(IPITCH.NE.0) CALL FVAL('PITCH   ',4,AMWHPR(51),7,0,1)
      IF(IYAW.NE.0) CALL FVAL('YAW     ',4,AMWHPR(61),7,0,1)
C
      RETURN
C
C   ****************************************************************
      ENTRY WHINIT
C   ****************************************************************
C
C     CALLED FROM MAIN FOR INITIAL CONDITIONS AND INTEGRATION BOUNDS
C     CALLED AFTER CALL TO SETVAL(1)
C
      IF(IPCONT.EQ.0) RETURN
C
      CALL DEBANG(YAW,ROLL,PITCH)
      IF(IROLL.EQ.0) GO TO 2
      I1=NROLL+1
      I2=I1+1
      UP(NROLL)=AMWHPR(101)
      UP(I1)=AMWHPR(101)
      DN(NROLL)=AMWHPR(102)
      DN(I1)=AMWHPR(102)
      DEP(NROLL)=ROLL
      DEP(I1)=0.0D0
      UP(I2)=AMWHPR(103)
      DN(I2)=AMWHPR(104)
      DEP(I2)=AMWHPR(111)
    2 CONTINUE
      IF(IPITCH.EQ.0) GO TO 4
      I1=NPITCH+1
      I2=I1+1
      UP(NPITCH)=AMWHPR(101)
      UP(I1)=AMWHPR(101)
      DN(NPITCH)=AMWHPR(102)
      DN(I1)=AMWHPR(102)
      DEP(NPITCH)=PITCH
      DEP(I1)=0.0D0
      UP(I2)=AMWHPR(103)
      DN(I2)=AMWHPR(104)
      DEP(I2)=AMWHPR(121)
    4 CONTINUE
      IF(IYAW.EQ.0) GO TO 6
      I1=NYAW+1
      I2=I1+1
      UP(NYAW)=AMWHPR(101)
      UP(I1)=AMWHPR(101)
      DN(NYAW)=AMWHPR(102)
      DN(I1)=AMWHPR(102)
      DEP(NYAW)=YAW
      DEP(I1)=0.0D0
      UP(I2)=AMWHPR(103)
      DN(I2)=AMWHPR(104)
      DEP(I2)=AMWHPR(131)
    6 CONTINUE
C
      RETURN
C
C   ****************************************************************
      ENTRY WHREAC(ETA)
C   ****************************************************************
C
C     CALLED FROM DEREQ TO LOAD DERIVATIVES FOR SENSOR
C
      IF(IPCONT.EQ.0) RETURN
      DO 10 I=1,3
      HDOT(I)=0.0D0
      HWL(I)=0.0D0
      VWH(I)=0.0D0
      FOPT(I)=0.0D0
   10 CONTINUE
      CALL DEBANG(YAW,ROLL,PITCH)
      IF(IROLL.EQ.0) GO TO 20
      DERIV(NROLL)=ROLLG*ROLL-RBW*DEPEND(NROLL)
      I1=NROLL+1
      I2=I1+1
      TEST=DEPEND(NROLL)
      FOPT(1)=TEST
      IF(DEPEND(NROLL).GE.0.0D0) GO TO 12
C
C     LESS THAN ZERO
C
      IF(DEPEND(I1).GE.0.0D0) GO TO 14
      ARG=(RLXIDN-DEPEND(I1))/RLXIDN
      ARG=EXK*ARG
      IF(ARG.GT.0.0D0) ARG=-ARG
      TEST=0.0D0
      IF(DEPEND(I1).LT.RLXIDN) GO TO 14
      TEST=DEPEND(NROLL)*(1.0D0-DEXP(ARG))
      GO TO 14
C
   12 CONTINUE
C
C     GREATER THAN ZERO
C
      IF(DEPEND(I1).LE.0.0D0) GO TO 14
      ARG=(RLXIUP-DEPEND(I1))/RLXIUP
      ARG=EXK*ARG
      IF(ARG.GT.0.0D0) ARG=-ARG
      TEST=0.0D0
      IF(DEPEND(I1).GT.RLXIUP) GO TO 14
      TEST=DEPEND(NROLL)*(1.0D0-DEXP(ARG))
C
   14 CONTINUE
      DERIV(I1)=TEST
      RLOUT=RLKP*DEPEND(NROLL)+RLKI*DEPEND(I1)+RLKD*DERIV(NROLL)
      VOPRL=RLKA*RLOUT
      RLMOTT=RLKT*(VOPRL-RLKB*DEPEND(I2))
      IF(RLMOTT.GT.RLMTUP) RLMOTT=RLMTUP
      IF(RLMOTT.LT.RLMTDN) RLMOTT=RLMTDN
      RLMOTT=RLMOTT-DEPEND(I2)*RLTCUL/(RLDMIN+DABS(DEPEND(I2)))
      DERIV(I2)=RLMOTT/RLWMOI
      OUTTRQ(17)=RLMOTT
      VWH(1)=DEPEND(I2)
      RLHD=RLMOTT
      RLH=RLWMOI*DEPEND(I2)
   20 CONTINUE
      IF(IPITCH.EQ.0) GO TO 30
      DERIV(NPITCH)=PITCHG*PITCH-PBW*DEPEND(NPITCH)
      I1=NPITCH+1
      I2=I1+1
      TEST=DEPEND(NPITCH)
      FOPT(2)=TEST
      IF(DEPEND(NPITCH).GE.0.0D0) GO TO 22
C
C     LESS THAN ZERO
C
      IF(DEPEND(I1).GE.0.0D0) GO TO 24
      ARG=(PTXIDN-DEPEND(I1))/PTXIDN
      ARG=EXK*ARG
      IF(ARG.GT.0.0D0) ARG=-ARG
      TEST=0.0D0
      IF(DEPEND(I1).LT.PTXIDN) GO TO 24
      TEST=DEPEND(NPITCH)*(1.0D0-DEXP(ARG))
      GO TO 24
C
   22 CONTINUE
C
C     GREATER THAN ZERO
C
      IF(DEPEND(I1).LE.0.0D0) GO TO 24
      ARG=(PTXIUP-DEPEND(I1))/PTXIUP
      ARG=EXK*ARG
      IF(ARG.GT.0.0D0) ARG=-ARG
      TEST=0.0D0
      IF(DEPEND(I1).GT.PTXIUP) GO TO 24
      TEST=DEPEND(NPITCH)*(1.0D0-DEXP(ARG))
C
   24 CONTINUE
      DERIV(I1)=TEST
      PTOUT=PTKP*DEPEND(NPITCH)+PTKI*DEPEND(I1)+PTKD*DERIV(NPITCH)
      VOPPT=PTKA*PTOUT
      PTMOTT=PTKT*(VOPPT-PTKB*DEPEND(I2))
      IF(PTMOTT.GT.PTMTUP) PTMOTT=PTMTUP
      IF(PTMOTT.LT.PTMTDN) PTMOTT=PTMTDN
      PTMOTT=PTMOTT-DEPEND(I2)*PTTCUL/(PTDMIN+DABS(DEPEND(I2)))
      DERIV(I2)=PTMOTT/PTWMOI
      OUTTRQ(18)=PTMOTT
      VWH(2)=DEPEND(I2)
      PTHD=PTMOTT
      PTH=PTWMOI*DEPEND(I2)
   30 CONTINUE
      IF(IYAW.EQ.0) GO TO 40
      DERIV(NYAW)=YAWG*YAW-YBW*DEPEND(NYAW)
      I1=NYAW+1
      I2=I1+1
      TEST=DEPEND(NYAW)
      FOPT(3)=TEST
      IF(DEPEND(NYAW).GE.0.0D0) GO TO 32
C
C     LESS THAN ZERO
C
      IF(DEPEND(I1).GE.0.0D0) GO TO 34
      ARG=(YWXIDN-DEPEND(I1))/YWXIDN
      ARG=EXK*ARG
      IF(ARG.GT.0.0D0) ARG=-ARG
      TEST=0.0D0
      IF(DEPEND(I1).LT.YWXIDN) GO TO 34
      TEST=DEPEND(NYAW)*(1.0D0-DEXP(ARG))
      GO TO 34
C
   32 CONTINUE
C
C     GREATER THAN ZERO
C
      IF(DEPEND(I1).LE.0.0D0) GO TO 34
      ARG=(YWXIUP-DEPEND(I1))/YWXIUP
      ARG=EXK*ARG
      IF(ARG.GT.0.0D0) ARG=-ARG
      TEST=0.0D0
      IF(DEPEND(I1).GT.YWXIUP) GO TO 34
      TEST=DEPEND(NYAW)*(1.0D0-DEXP(ARG))
C
   34 CONTINUE
      DERIV(I1)=TEST
      YWOUT=YWKP*DEPEND(NYAW)+YWKI*DEPEND(I1)+YWKD*DERIV(NYAW)
      VOPYW=YWKA*YWOUT
      YWMOTT=YWKT*(VOPYW-YWKB*DEPEND(I2))
      IF(YWMOTT.GT.YWMTUP) YWMOTT=YWMTUP
      IF(YWMOTT.LT.YWMTDN) YWMOTT=YWMTDN
      YWMOTT=YWMOTT-DEPEND(I2)*YWTCUL/(YWDMIN+DABS(DEPEND(I2)))
      DERIV(I2)=YWMOTT/YWWMOI
      OUTTRQ(19)=YWMOTT
      VWH(3)=DEPEND(I2)
      YWHD=YWMOTT
      YWH=YWWMOI*DEPEND(I2)
   40 CONTINUE
      RWHEEL(1)=-HDOT(1)+HWL(2)*OMEG(3)-HWL(3)*OMEG(2)
      RWHEEL(2)=-HDOT(2)+HWL(3)*OMEG(1)-HWL(1)*OMEG(3)
      RWHEEL(3)=-HDOT(3)+HWL(1)*OMEG(2)-HWL(2)*OMEG(1)
      OUTTRQ(7)=RWHEEL(1)
      OUTTRQ(8)=RWHEEL(2)
      OUTTRQ(9)=RWHEEL(3)
      ETA(4)=ETA(4)+RWHEEL(1)
      ETA(5)=ETA(5)+RWHEEL(2)
      ETA(6)=ETA(6)+RWHEEL(3)
C
      RETURN
C
C   ****************************************************************
      ENTRY WHPLOT(BUFF,INDEX)
C   ****************************************************************
C
C     CALLED FROM GPPLOT TO LOAD PLOT RECORD
C
      I1=INDEX-1
      INDEX=INDEX+6
      IF(IPCONT.EQ.0) RETURN
      DO 64 I=1,3
      I2=I+3
      OUTP(I)=FOPT(I)/RADIAN
      OUTP(I2)=VWH(I)/RADIAN
      BUFF(I1+I)=OUTP(I)
      BUFF(I1+I2)=OUTP(I2)
   64 CONTINUE
C
C
      RETURN
C
C   ****************************************************************
      ENTRY WHPRNT
C   ****************************************************************
C
C     CALLED FROM GPSOUT FOR PRINTED OUTPUT
C
      IF(IPCONT.EQ.0) RETURN
C
      CALL SET('FTR ROLL',0,0,OUTP(1),I8)
      CALL SET('FTR PTCH',0,0,OUTP(2),I8)
      CALL SET('FTR YAW ',0,0,OUTP(3),I8)
      CALL SET('1 AX MWS',0,0,OUTP(4),I8)
      CALL SET('2 AX MWS',0,0,OUTP(5),I8)
      CALL SET('3 AX MWS',0,0,OUTP(6),I8)
C
C
      RETURN
C
C
      END
