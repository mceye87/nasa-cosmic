      SUBROUTINE CTPAK1(INDEX,KSPEC,LUERR,IERR)
C
C  THIS ROUTINE IS PART OF THE COORDINATE TRANSFORMATION PACKAGE, CTPAK.
C  IT CHECKS FOR VALID ORIENTATION, ORIGIN, AND LENGTH UNIT FLAGS.
C
      INTEGER KSPEC(3)
      CHARACTER*6 INOUT
      CHARACTER*11 INFO
C
      IERR = 0
C
      KPLANE  = KSPEC(1)
      KORIGIN = KSPEC(2)
      KUNITS  = KSPEC(3)
C
      IF(INDEX.EQ.1) THEN
        INOUT='INPUT'
      ELSE
        INOUT='OUTPUT'
        END IF
C
C  ERROR CHECKS:
C
      IF(KPLANE.LT.1 .OR. KPLANE.GT.14) THEN
        IERR=1
        INFO='ORIENTATION'
        IF(LUERR.GT.0) WRITE(LUERR,100) INOUT,INFO(1:11),KPLANE
        END IF
C
      IF(KORIGIN.LT.1 .OR. KORIGIN.GT.4) THEN
        IERR=1
        INFO='ORIGIN'
        IF(LUERR.GT.0) WRITE(LUERR,100) INOUT,INFO(1:6),KORIGIN
        END IF
C
      IF(KUNITS.LT.1 .OR. KUNITS.GT.4) THEN
        IERR=1
        INFO='LENGTH UNIT'
        IF(LUERR.GT.0) WRITE(LUERR,100) INOUT,INFO(1:11),KUNITS
        END IF
C
C
  100 FORMAT(/,
     *  ' CTPAK1(CTPACK).  ',A,' SYSTEM ',A,' FLAG IS INVALID.'/,
     *  '    VALUE ENTERED=',I3,'.  NO TRANSFORMATION.')
C
      RETURN
      END
