      SUBROUTINE MATCHI4(KTEST,NTEST,I4ARRAY,INDEX)
C
C THIS ROUTINE TESTS AN INTEGER*4 ARRAY FOR THE PRESENSE OF A SPECIFIED
C VALUE AND RETURNS THE INDEX OF THE ARRAY ELEMENT WHERE THAT VALUE WAS
C FOUND.
C
C VARIABLE DIM TYPE I/O DESCRIPTION
C -------- --- ---- --- -----------
C
C KTEST     1   I*4  I  THE VALUE OF INTEREST.
C
C NTEST     1   I*4  I  THE NUMBER OF ELEMENTS OF I4ARRAY TO BE TESTED
C                       FOR A MATCH WITH KTEST. IF ZERO OR NEGATIVE,
C                       NO TEST IS DONE AND INDEX IS SET TO ZERO.
C
C I4ARRAY   -   I*4  I  THE ARRAY OF VALUES TO BE TESTED. THE DIMENSION
C                       IS UNIMPORTANT, BUT NTEST MUST NOT EXCEED THE
C                       DIMENSION DEFINED IN THE CALLER.
C
C INDEX    1    I*4  O  THE INDEX NUMBER WHERE THE MATCH OCCURRED IN
C                       I4ARRAY. IF NO MATCH OR NTEST WAS ZERO OR
C                       NEGATIVE, INDEX=0 IS RETURNED.
C
C***********************************************************************
C
C BY C PETRUZZO, GSFC/742 1/86
C    MODIFIED....
C
C***********************************************************************
C
      INTEGER*4 I4ARRAY(1)
C
      INDEX = 0
      IEL = 0
      DO WHILE (IEL.LT.NTEST .AND. INDEX.EQ.0)
        IEL = IEL + 1
        IF(I4ARRAY(IEL).EQ.KTEST) INDEX = IEL
        END DO
C
      RETURN
      END
