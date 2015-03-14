      SUBROUTINE KEPLER(SL,E,SINE,COSE)
      DOUBLE PRECISION SL,TPI,E,SINE,COSE,XL,XL0,E0,E1,DIFF
      DATA TPI /6.283185307179586D0/
      XL=DMOD(SL,TPI)
      E0=XL
      I = 1
   10 SINE=DSIN(E0)
      COSE=DCOS(E0)
      XL0=E0-E*SINE
      E1=E0+(XL-XL0)/(1.D0-E*COSE)
      DIFF=E1-E0
      IF(DABS(DIFF).LT.1.D-12) GO TO 30
      IF(I.GT.49) GO TO 20
      E0=E1
      I=I+1
      GO TO 10
   20 WRITE(6,25) DIFF
   25 FORMAT(44H0ERROR IN ECC. ANOMALY AFTER 50 ITERATIONS =,D13.5)
   30 CONTINUE
      RETURN
      END
