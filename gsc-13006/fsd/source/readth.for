      SUBROUTINE READTH
C
      IMPLICIT REAL*8(A-H,O-Z)
C
C    *****************************************************************
C    *                                                               *
C    *   READTH HAS BEEN MODIFIED TO CONTAIN THE ARRAY TABLE FOR     *
C    *   OVERLAYING PURPOSES. THE DIMENSION OF TABLE MUST BE AT      *
C    *   LEAST SEVEN TIMES THE NUMBER OF INPUT SYMBOLS DEFINED       *
C    *   BY SETUP CALLS.                                             *
C    *   THE PRESENT NUMBERS ARE; RD478  -  42, RD481  -  45         *
C    *                            READER - 136, READTH -  88         *
C    *                            READZ  - 129, READGP -   0         *
C    *                            TOTAL  - 440                       *
C    *                                                               *
C    *   MODIFICATION AS OF APRIL, 1981.                             *
C    *                                                               *
C    *****************************************************************
C
      REAL*8 I3,I2OVI3
      REAL*4 TABLE(4200)
C
      COMMON/THRUST/TV(3,2),TLOC(3,2),TTIM(4,2),TPAR(4,2),REF(2)
C
      COMMON/ITCNTL/IPULSE,ISPLSE,KPULSE,ITSW,IOTSW,IPLPRP
C
C   INSERT KEPLER ORBITAL PARAMETER INPUT OPTION
      COMMON/IKPLER/IKPLR
C
      COMMON/XKPLER/AS,E,F,EI,BW,W,BWDOT,WDOT
C
      COMMON/INUMP/ ISPNP
C
      COMMON/HOUTPT/ IHCALC,IHREF,IHFLAG
C
C   MOD. OF NEW WHEELS IN READTH
C
      COMMON/CWHEEL/VW(3),VSUR(3),VSDR(3)
C
C   MOD IN READTH
C
      COMMON/DEBUG1/ IAFM(5)
C
      COMMON/IACC/ IACOMP,IHUBAC,ITIPAC,IAFLAG
C
      COMMON/NUMACC/NUMHUB
C
      COMMON/ACCHUB/ YHUB(3,6),HUBACC(3,6),ACCRED(6),ALFAEA(6),
     *BETAEA(6),GAMAEA(6),DKAT(3,3,6)
C
      COMMON/SHAPES/ZXI(10,3),ZXIP(10,3),ZXIPP(10,3),ZZNP(10,3,3)
C
      COMMON/INPFFT/ICSD
C
      COMMON/GRNTST/ALFAEG,DELTAG,PHASEG,ALTUDE,OMGY(3),
     *              GACC(3),GLOCAT(3),IGRUND,IALTUD,IGASBR
C
      COMMON/IPRYRT/IPRY,IGGANG
C
      COMMON/PRYRAT/PRAT,RRAT,YRAT
C
      COMMON/PUNCH / IPUN,IPUNCH
C
      COMMON/TMSINR/ TIPINR(3,10),RTSQ(3,10),XIPL(6),BETL(6)
C
      COMMON/INTTRP/ITPROT,NUMTIP(10),IRDBUG
C
      COMMON/ITW/ITWIST,ITWST1
C
      COMMON/RNEWR / ZA(10),I3(10),I2OVI3(10),
     *             ZDQ(10),ZJ(10),D2(10),D3(10)
C
      COMMON/INEWR/NKT(10),ICP,ICPS
C
      COMMON/RNEWV/CW(10,3),CDW(10,3)
C
      COMMON/TWIBND/TWIUP,TWIDN,TWDUP,TWDDN
C
C
      COMMON/COMSL1/ ZS101(2),ZS102(2),ZS111(6),ZS112(6),ZS113(6)
     *              ,ZS121(18),ZS122(18),ZS123(18),ZS124(18),ZS131(54)
     *              ,ZS132(54),ZS141(162),Z2S101(2),Z2S112(6)
     *              ,Z2S123(18),XLTEST
C
      COMMON/TWIDMP/ CDTW(3,10)
C   CALL SETUP FOR LABELLED COMMON XKPLER
      CALL WHERE(TABLE)
C
      CALL SETUP(8HIKPLR   ,4,IKPLR)
      CALL SETUP(8HAS      ,8,AS)
      CALL SETUP(8HE       ,8,E)
      CALL SETUP(8HF       ,8,F)
      CALL SETUP(8HEI      ,8,EI)
      CALL SETUP(8HBW      ,8,BW)
      CALL SETUP(8HW       ,8,W)
      CALL SETUP(8HBWDOT   ,8,BWDOT)
      CALL SETUP(8HWDOT    ,8,WDOT)
C    SETUP CALLS FOR LABELED COMMON/THRUST
C
      CALL SETUP(8HTVECTR  ,8,TV,3,2)
      CALL SETUP(8HTLOCAT  ,8,TLOC,3,2)
      CALL SETUP(8HTTIMES  ,8,TTIM,4,2)
      CALL SETUP(8HTPARAM  ,8,TPAR,4,2)
      CALL SETUP(8HREFANG  ,8,REF,2)
C
C     SETUP CALLS FOR LABELED COMMON/ITCNTL
C
      CALL SETUP(8HIPULSE  ,4,IPULSE)
      CALL SETUP(8HISPLSE  ,4,ISPLSE)
      CALL SETUP(8HIPLPRP  ,4,IPLPRP)
C
      CALL SETUP(8HISPNP   ,4,ISPNP)
      CALL SETUP(8HIHCALC  ,4,IHCALC)
      CALL SETUP(8HIHREF   ,4,IHREF)
C   ADD FOR ACCELERATION COMPUTATION
C
      CALL SETUP(8HIACOMP  ,4,IACOMP)
      CALL SETUP(8HIHUBAC  ,4,IHUBAC)
      CALL SETUP(8HITIPAC  ,4,ITIPAC)
      CALL SETUP(8HNUMHUB  ,4,NUMHUB)
      CALL SETUP(8HALFAEA  ,8,ALFAEA,6)
      CALL SETUP(8HBETAEA  ,8,BETAEA,6)
      CALL SETUP(8HGAMAEA  ,8,GAMAEA,6)
C
      CALL SETUP(8HYHUB    ,8,YHUB,3,6)
C
      CALL SETUP(8HZXI     ,8,ZXI,10,3)
      CALL SETUP(8HZXIP    ,8,ZXIP,10,3)
      CALL SETUP(8HZXIPP   ,8,ZXIPP,10,3)
      CALL SETUP(8HZZNP    ,8,ZZNP,10,3,3)
C
      CALL SETUP(8HVSUR    ,8,VSUR,3)
      CALL SETUP(8HVSDR    ,8,VSDR,3)
C
      CALL SETUP(8HICSD    ,4,ICSD)
C
C
C     INPUT FOR PITCH ROLL YAW RATE FOR G.G. OPTION
C
      CALL SETUP('IPRY    ',4,IPRY)
      CALL SETUP(8HPRAT    ,8,PRAT)
      CALL SETUP(8HRRAT    ,8,RRAT)
      CALL SETUP(8HYRAT    ,8,YRAT)
C
C     INPUT FOR TIP MASS INFORMATIONS
C
      CALL SETUP(8HITPROT  ,4,ITPROT)
      CALL SETUP(8HNUMTIP  ,4,NUMTIP,10)
      CALL SETUP(8HIRDBUG  ,4,IRDBUG)
      CALL SETUP(8HTIPINR  ,8,TIPINR,3,10)
      CALL SETUP(8HXIPL    ,8,XIPL,6)
      CALL SETUP(8HBETL    ,8,BETL,6)
C
C     CALL SETUP FOR LABELLED COMMON  GRNTST
C
      CALL SETUP(8HIGRUND  ,4,IGRUND)
      CALL SETUP(8HIALTUD  ,4,IALTUD)
      CALL SETUP(8HIGASBR  ,4,IGASBR)
      CALL SETUP(8HALFAEG  ,8,ALFAEG)
      CALL SETUP(8HDELTAG  ,8,DELTAG)
      CALL SETUP(8HPHASEG  ,8,PHASEG)
      CALL SETUP(8HALTUDE  ,8,ALTUDE)
      CALL SETUP(8HOMGY    ,8,OMGY,3)
      CALL SETUP(8HGACC    ,8,GACC,3)
      CALL SETUP(8HGLOCAT  ,8,GLOCAT,3)
C
C     CALL SETUP FOR COUPLED TWISTING AND BENDING COMPUTATION
C
      CALL SETUP(8HI2OVI3  ,8,I2OVI3,10)
      CALL SETUP(8HZA      ,8,ZA,10)
      CALL SETUP(8HZDQ     ,8,ZDQ,10)
      CALL SETUP(8HZJ      ,8,ZJ,10)
      CALL SETUP(8HNKT     ,4,NKT,10)
      CALL SETUP(8HITWIST  ,4,ITWIST)
      CALL SETUP(8HITWST1  ,4,ITWST1)
      CALL SETUP(8HCW      ,8,CW,10,3)
      CALL SETUP(8HCDW     ,8,CDW,10,3)
      CALL SETUP(8HD2      ,8,D2,10)
      CALL SETUP(8HD3      ,8,D3,10)
C
C     CALL SETUP FOR COMMON BLOCK CDATA
C
      CALL SETUP(8HTWIUP   ,8,TWIUP)
      CALL SETUP(8HTWIDN   ,8,TWIDN)
      CALL SETUP(8HTWDUP   ,8,TWDUP)
      CALL SETUP(8HTWDDN   ,8,TWDDN)
C
C
C
      CALL SETUP(8HZS101   ,8,ZS101,2)
      CALL SETUP(8HZS102   ,8,ZS102,2)
      CALL SETUP(8HZS111   ,8,ZS111,6)
      CALL SETUP(8HZS112   ,8,ZS112,6)
      CALL SETUP(8HZS113   ,8,ZS113,6)
      CALL SETUP(8HZS121   ,8,ZS121,18)
      CALL SETUP(8HZS122   ,8,ZS122,18)
      CALL SETUP(8HZS123   ,8,ZS123,18)
      CALL SETUP(8HZS124   ,8,ZS124,18)
      CALL SETUP(8HZS131   ,8,ZS131,54)
      CALL SETUP(8HZS132   ,8,ZS132,54)
      CALL SETUP(8HZS141   ,8,ZS141,162)
      CALL SETUP(8HZ2S101  ,8,Z2S101,2)
      CALL SETUP(8HZ2S112  ,8,Z2S112,6)
      CALL SETUP(8HZ2S123  ,8,Z2S123,18)
      CALL SETUP(8HXLTEST  ,8,XLTEST)
C
      CALL SETUP(8HIPUNCH  ,4,IPUNCH)
C
      CALL SETUP(8HCDTW    ,8,CDTW,3,10)
C
      CALL RD478
C
      CALL RD481
C
      CALL READGP
C
      RETURN
      END