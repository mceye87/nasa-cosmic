      SUBROUTINE STDPND(KTEST)
C
C        'STDPND' STORES INITIAL CONDITIONS FOR STACKING CASES
C
C         WRITTEN BY E.A.LAWLOR OF AVCO SYSTEM DIVISION
C         MODIFIED BY K. YONG OF COMPUTER SCIENCES CORP.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER*4 ACNTRL
C
C
      COMMON/CONSTS/ PI,TWOPI,RADIAN
C
      COMMON/IMAIN1/ IDATE,LSAVE,INOPT,IPLOT,NUMEQS,IPLTPE,IORB,ITAPE
C
      COMMON/IPOOL1/ IGRAV,IDAMP,IK,K1,ITIM,IAB,IAPS,IBB,IBPS,NK(10),
     .               LK(10),LLK(10)
C
      COMMON/MOMENT/ ACNTRL,IVISCS,IATTDE,IMGMTS,IWHEEL,NPULSE
C
      COMMON/RATTDE/ DTMXA,PXI,PXO,EIT,REFTIM,TMX1,TMX2,CMX,ISW
C
      COMMON/RMAIN1/ DELTAT,FACTOR,FREQ,TSTOP,DELMIT,
     .               UPBND(150),DNBND(150)
C
      COMMON/RPOOL1/ RHOK(10),TIME,SA(3,3),FM1(3,3),ZLK(10),OMEG(3),
     .               ZLKP(10),ZLKDP(10),CMAT(3,3),GBAR(3,3),YBCM(3),
     .               ZBZK(3,10),FCM(3,3),DTO,PHID,PHI
C
      COMMON/XIN1/ PSI1,THET1,PHI1,ETTA,ZETTA,ITEST1
C
      COMMON/XIN2  / ALFAE,BETAE,GAMAE,OMBC(3),ITEST2
C
C
      COMMON/GRNTST/ALFAEG,DELTAG,PHASEG,ALTUDE,OMGY(3),
     *       GACC(3),GLOCAT(3),IGRUND,IALTUD
C
      DIMENSION SOMBC(3),SOMEG(3)
      DIMENSION SOMGY(3)
C
C
      IF (KTEST.EQ.2) GO TO 40
C
      IF(NPULSE.LT.0) NPULSE=0
      DSAVE=DELTAT
      FASAVE=FACTOR
      FRSAVE=FREQ
      DESAVE=DELMIT
C
C
      SALFAE=ALFAE
      SBETAE=BETAE
      SGAMAE=GAMAE
      SPSI1=PSI1
      STHET1=THET1
      SPHI1=PHI1
      SALFAG=ALFAEG
      SDELTG=DELTAG
      SPHASG=PHASEG
C
      DO 20 I=1,3
      SOMEG(I)=OMEG(I)
      SOMGY(I)=OMGY(I)
   20 SOMBC(I)=OMBC(I)
C
C
C
      RETURN
C
C
   40 DELTAT=DSAVE
      FACTOR=FASAVE
      FREQ=FRSAVE
      DELMIT=DESAVE
      TMX1=0.D0
      TMX2=0.D0
      NPULSE=-4
C
C
C
      ALFAE=SALFAE
      BETAE=SBETAE
      GAMAE=SGAMAE
      PSI1=SPSI1
      THET1=STHET1
      PHI1=SPHI1
      ALFAEG=SALFAG
      DELTAG=SDELTG
      PHASEG=SPHASG
C
C
      DO 70 I=1,3
      OMBC(I)=SOMBC(I)
      OMGY(I)=SOMGY(I)
   70 OMEG(I)=SOMEG(I)/RADIAN
C
      RETURN
      END