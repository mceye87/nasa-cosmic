      SUBROUTINE QUIKVIS5A2C3(ITARG,ID,T50,SEGCIRC,NOLAPREQ,OVLAPREQ)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C THIS ROUTINE IS PART OF THE QUIKVIS PROGRAM.  IT WRITES TARGET
C AVAILABILITY INFO, CONTAINED IN THE INPUT ARRAY, SEGCIRC, ON THE
C DETAIL DATA FILE.  THIS ROUTINE WRITES THE RECORD CONTAINING THE
C GUARANTEED TARGET AVAILABILITY INFO WHEN ALL RAAN'S HAVE BEEN
C CONSIDERED.
C
C THE SEGCIRC ARRAY IS AN ARRAY OF TRUE/FALSE FLAGS WHERE EACH ARRAY
C ELEMENT REPRESENTS A SMALL SEGMENT OF A CIRCLE.  THE CIRCLE REPRESENTS
C THE 360 DEGREES OF MEAN ANOMALY.  IF THE FLAG IS TRUE, ALL
C REQUIREMENTS ARE SATISFIED FOR ALL RAANS AT THAT SEGMENT.  THIS
C ROUTINE CONVERTS THE T/F FLAGS TO NUMERICAL VALUES INDICATING WHERE
C REQUIREMENTS ARE SATISFIED.  THE NUMERICAL VALUES ARE WRITTEN ON THE
C DETAIL DATA FILE.
C
C
C VARIABLE DIM TYPE I/O DESCRIPTION
C -------- --- ---- --- -----------
C
C ITARG     1   I*4  I  FOR THE TARGET WHOSE AVAILABILITY INFO IS TO
C                       BE WRITTEN ON THIS CALL, ITARG IS THE TARGET
C                       NUMBER WITHIN THIS QUIKVIS RUN. IE, AN INTERNAL
C                       COUNTER.
C
C ID        1   I*4  I  THE TARGET ID AS READ FROM THE TARGET CATALOGUE.
C
C T50       1   R*8  I  THE TIME WITH WHICH THE TARGET AVAIALBILITY
C                       INFO IS ASSOCIATED.  IN SECONDS SINCE 1/1/50
C
C SEGCIRC       L*1  I  DESCRIBED IN THE INTRODUCTORY COMMENTS ABOVE.
C      MAXSEGCIRC
C
C NOLAPREQ      I*4  I  NOLAPREQ(I) IS THE NUMBER OF PERIODS WITHIN ONE
C       MAXREQMT        ORBIT WHEN THE I'TH OBSERVATION REQUIREMENT IS
C                       SATISFIED FOR THE ITARG'TH TARGET AND ALL RAAN'S
C                       PROCESSED AT TIME T50.
C
C OVLAPREQ      R*8  I  THE MEAN ANOMALYS, RELATIVE TO THE REFERENCE
C     2,10,MAXREQMT     ORBIT EVENT, WHERE THE REQUIREMENTS ARE
C                       SATISFIED.  IN RADIANS.  SEE ARRAY SIZE COMMENTS
C                       IN QUIKVIS5A2C WHERE OVLAPREQ SIZE IS DEFINED.
C
C                       OVLAPREQ(1,J,I) IS THE BEGINNING OF THE J'TH
C                       PERIOD FOR THE I'TH REQUIREMENT.
C                       OVLAPREQ(2,J,I) IS THE END.
C
C***********************************************************************
C
C BY C PETRUZZO/GFSC/742.   9/86.
C       MODIFIED.... 3/87.  CJP.  CHANGED ANG1 TO 0.0 WHEN AVAILABILITY
C                                 BEGINS WITH SEGMENT 1.  WAS GETTING
C                                 0.1 AS START MEAN ANOMALY WHEN 0.0
C                                 WAS WHAT WAS WANTED.  CHANGED DETAIL
C                                 DATA FILE FORMAT AND MADE MODS TO
C                                 ACCOMMODATE MORE DETAIL LEVELS AS
C                                 SPECIFIED IN LEVDETFILE.
C
C***********************************************************************
C
      INCLUDE 'QUIKVIS.INC'
C
      LOGICAL*1 SEGCIRC(MAXSEGCIRC),XTWOPI,OPEN,WRITIT,COUNTIT
      REAL*8 DELSEG/0.D0/
      CHARACTER*1 CH1
      INTEGER NOLAPREQ(MAXREQMT)
      PARAMETER MAXOLAPREQ=10    ! ARRAY IS DEFINED IN QUIKVIS5A2C
      REAL*8 OVLAPREQ(2,MAXOLAPREQ,MAXREQMT)
C
C
      IBUG = 0
      LUBUG = 19
C
C INTIALIZE.
C
      NSEGCIRC = MAXSEGCIRC
      DELCIRC = TWOPI/NSEGCIRC  ! ONE SEGMENT'S ANGULAR COVERAGE
C
C
C
C DETERMINE WHETHER A SEGMENT CROSSES TWOPI.  IF SO, WE START THE
C PROCESS AT THE SEGCIRC ELEMENT WHERE THAT SEGMENT BEGINS.
C
      XTWOPI = SEGCIRC(1) .AND. SEGCIRC(NSEGCIRC)
      IF(.NOT.XTWOPI) THEN
        INDEX1 = 1
      ELSE
        DO I=1,NSEGCIRC
          INDTEMP = NSEGCIRC+1-I
          IF( .NOT.SEGCIRC(INDTEMP) ) GO TO 1001
          INDEX1 = INDTEMP
          END DO
        END IF
C
 1001 CONTINUE
C
      IF(IBUG.NE.0) WRITE(LUBUG,9001) NSEGCIRC,DELCIRC*DEGRAD,INDEX1
C
C
C STEP ALONG THE ELEMENTS OF SEGCIRC SEARCHING FOR START AND END
C PERIODS WHERE TARGET AVAILABILITY OCCURS FOR A SINGLE ORBIT ABOUT THE
C EARTH.  WHEN SUCH PERIODS HAVE BEEN DETERMINED, WRITE THE APPROPRIATE
C INFO ON THE DETAIL DATA FILE.
C
C
C    COUNT THE NUMBER OF AVAILABILITY PERIODS THAT WILL BE OUTPUT.  THE
C    NUMBER, NFOUND, IS NEEDED IN THE DATA RECORD(FORMAT 6901).
C
      OPEN = .FALSE.
      NFOUND = 0
      TAVAIL = 0.D0
      IND1 = 0.D0
      IND2 = 0.D0
      DO ISEG=1,NSEGCIRC
        COUNTIT = .FALSE.
        INDEX = INDEX1 + ISEG - 1
        IF(INDEX.GT.NSEGCIRC) INDEX = INDEX - NSEGCIRC
        IF(SEGCIRC(INDEX) .AND. .NOT.OPEN) THEN   ! OPEN AN AVAIL PERIOD
          OPEN = .TRUE.
          ANG1 = INDEX*DELCIRC
          IF(INDEX.EQ.1) ANG1 = 0.D0
          END IF
        IF(.NOT.SEGCIRC(INDEX) .AND. OPEN) THEN  ! CLOSE AN AVAIL PERIOD
          OPEN = .FALSE.
          ANG2 = (INDEX-1)*DELCIRC
          COUNTIT = .TRUE.
          END IF
        IF(OPEN.AND.ISEG.EQ.NSEGCIRC) THEN  ! CAN OCCUR IF ALWAYS AVAIL
          OPEN = .FALSE.
          ANG2 = INDEX*DELCIRC
          COUNTIT = .TRUE.
          END IF
        IF(COUNTIT) THEN
          NFOUND = NFOUND + 1
          TAVAIL = TAVAIL + EQVANG(ANG2-ANG1)/TWOPI*PERIOD
          END IF
        END DO
C
C
C    HAVING COUNTED THE NUMBER, NFOUND, OF AVAILABILITY PERIODS THAT
C    WILL BE OUTPUT, WRITE THE FIRST PART OF THE DATA RECORD FOR THIS
C    TARGET/TIME/NODE COMBINATION
C
      IF(LEVDETFILE.EQ.1) THEN
        KTEMP = 1
      ELSE
        KTEMP = MAXREQMT+1
        END IF
C
      WRITE(LUDETAIL,6901)
     *      ITARG,
     *      ID,
     *      PAKTIM50(T50),
     *      999.D0,
     *      TAVAIL/60.D0,
     *      999.D0,
     *      999.D0,
     *      KTEMP
C
C
C    SCAN THE SEGCIRC ARRAY AGAIN AND OUTPUT THE ANGLES INFO THIS TIME.
C
      OPEN = .FALSE.
      IF(NFOUND.GT.0) THEN
        KFOUND = 0
        DO ISEG=1,NSEGCIRC
          WRITIT = .FALSE.
          INDEX = INDEX1 + ISEG - 1
          IF(INDEX.GT.NSEGCIRC) INDEX = INDEX - NSEGCIRC
          IF(SEGCIRC(INDEX) .AND. .NOT.OPEN) THEN   ! OPEN AVAIL PERIOD
            OPEN = .TRUE.
            ANG1 = INDEX*DELCIRC
            IF(INDEX.EQ.1) ANG1 = 0.D0
            END IF
          IF(.NOT.SEGCIRC(INDEX) .AND. OPEN) THEN  ! CLOSE AVAIL PERIOD
            OPEN = .FALSE.
            ANG2 = (INDEX-1)*DELCIRC
            WRITIT = .TRUE.
            END IF
          IF(OPEN.AND.ISEG.EQ.NSEGCIRC) THEN  !CAN OCCUR IF ALWAYS AVAIL
            OPEN = .FALSE.
            ANG2 = INDEX*DELCIRC
            WRITIT = .TRUE.
            END IF
          IF(WRITIT) THEN
            KFOUND = KFOUND + 1
            IF(ANG2.LT.ANG1) ANG1 = ANG1 - TWOPI
            IF(KFOUND.EQ.1) THEN
               WRITE(LUDETAIL,6902) NFOUND,ANG1*DEGRAD,ANG2*DEGRAD
            ELSE
               WRITE(LUDETAIL,6905) ANG1*DEGRAD,ANG2*DEGRAD
               END IF
            END IF
          END DO
      ELSE          ! IE, NFOUND = 0
        WRITE(LUDETAIL,6902) 1,0.D0,0.D0
        END IF
C
C
      IF(LEVDETFILE.GT.1) THEN
        DO IREQ=1,MAXREQMT
          WRITE(LUDETAIL,6904)  MAX(1,NOLAPREQ(IREQ)),
     *        ( OVLAPREQ(1,I,IREQ)*DEGRAD, OVLAPREQ(2,I,IREQ)*DEGRAD,
     *             I=1,MAX(1,NOLAPREQ(IREQ)) )
          END DO
        END IF
C
      WRITE(LUDETAIL,6906)
C
C
 9999 CONTINUE
      RETURN
C
C***********************************************************************
C
C
C**** INITIALIZATION CALL. PUT GLOBAL PARAMETER VALUES INTO THIS
C     ROUTINE'S LOCAL VARIABLES.
C
      ENTRY QVINIT5A2C3
C
      CALL QUIKVIS999(-1,R8DATA,I4DATA,L4DATA)
      RETURN
C
C***********************************************************************
C
 6901 FORMAT(1X,I4,',',I5,',',F14.6,',',F8.3,',',F7.3,',',F8.3,',',
     *      F8.3,', ',I2,',')
 6902 FORMAT(T6,I2,',',F7.2,',',F7.2,',')
 6905 FORMAT(T9,       F7.2,',',F7.2,',')
 6904 FORMAT(T6,I2,',',
     *      (T9,       F7.2,',',F7.2,',', F7.2,',',F7.2,',',
     *                     F7.2,',',F7.2,',') )
 6906 FORMAT('  /')
 9001 FORMAT(' QUIKVIS5A2C3 START DEBUG. NSEGCIRC,DELCIRC=',I5,F8.2,
     *   '  INDEX1=',I5)
 9003 FORMAT(' QUIKVIS5A2C3.  ',A,I5)
      END
