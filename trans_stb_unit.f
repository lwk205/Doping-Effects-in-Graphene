C$$$ WANT TO LOOP OVER DIFFERENT ENERGIES AND PRODUCE T^2 COEFFICIENTS, CHECK THEY MATCH WITH ANALYTICAL RESULTS

      PROGRAM TRANSFERMATIXTWO
      IMPLICIT NONE
      INTEGER, PARAMETER :: LIMX=8, WRAPY=0, WRAPX=1,
     + MSIZE=4*LIMX*LIMX, M2SIZE=LIMX*LIMX
      INTEGER PIVOT(2*LIMX, 2*LIMX), PIVOT2(LIMX, LIMX)
      INTEGER I/1/, J/1/, S/9/, K/1/, F/1/, X/1/, Y/1/,LIMY/10/       
      CHARACTER*3 VALUE
      DOUBLE PRECISION SVALS(LIMX), RWORK(5*LIMX), RVALS(LIMX),
     + TVALS(LIMX), E/-5.0/, TTVALS(LIMX), RTVALS(LIMX),SQUARE,COND/-1/, 
     + CHECKUNI
      DOUBLE PRECISION G
      DOUBLE PRECISION CONDUCTANCE
      DOUBLE COMPLEX ZEROC, ONEC
      
      
      DOUBLE COMPLEX MODD(2*LIMX, 2*LIMX), MEVEN(2*LIMX, 2*LIMX),
     + MULT(2*LIMX, 2*LIMX), OUTM(2*LIMX, 2*LIMX), ALPHA, BETA,
     + O(2*LIMX, 2*LIMX), IO(2*LIMX, 2*LIMX),
     + TEMP(2*LIMX, 2*LIMX), ABCD(2*LIMX, 2*LIMX), A(LIMX, LIMX),
     + B(LIMX, LIMX), C(LIMX, LIMX), D(LIMX, LIMX),
     + WORK(MSIZE), TEMP2(LIMX, LIMX), T(LIMX, LIMX),
     + TTILDE(LIMX, LIMX), R(LIMX, LIMX), RTILDE(LIMX, LIMX),
     + TINC(LIMX, LIMX), TTILDEINC(LIMX, LIMX), RINC(LIMX, LIMX),
     + RTILDEINC(LIMX, LIMX), WORK2(LIMX*LIMX), TEMP3(LIMX, LIMX),
     + SVCPY(LIMX, LIMX)

      DATA MODD/MSIZE*0.0/, MEVEN/MSIZE*0.0/, O/MSIZE*0.0/,
     + IO/MSIZE*0.0/, PIVOT/MSIZE*0/, ALPHA/1.0/,
     + BETA/0.0/, TEMP/MSIZE*0.0/, PIVOT2/M2SIZE*0.0/

C$$$  READS COMMAND LINE ARGUMENT AS LIMY
      CALL GETARG(1, VALUE)
      READ(UNIT=VALUE, FMT=*) LIMY

      DO F = 1, 1001


         CALL CALCMULT(MULT, LIMX, LIMY, WRAPX, MODD, MEVEN, E)

         CALL FILLOANDINVERT(O, IO, LIMX)
         CALL GENABCD(LIMX, MULT, O, IO, ABCD, A, B, C, D)
         CALL GENTANDRINC(LIMX, T, R, TTILDE, RTILDE, A, B, C, D) 
C         CALL PRINTT (T, LIMX, 'T  ')
C         CALL PRINTT (TTILDE, LIMX, 'T~ ')
C         CALL PRINTT (R, LIMX, 'R  ')
C         CALL PRINTT (RTILDE, LIMX, 'R~ ')
C         COND = CHECKUNI (LIMX, T, R, TTILDE, RTILDE)      
C         WRITE (*, *) '1: I=', I, ' ', COND
	

		 
C$$$ ################################################################


         DO I = 1, LIMY-1
            IF (MOD(LIMY,2) .EQ. 1) THEN
               IF (MOD(I,2) .EQ. 1) THEN
                  CALL ZCOPY(4*LIMX*LIMX, MEVEN, 1, MULT, 1)		
               ELSE
                  CALL ZCOPY(4*LIMX*LIMX, MODD, 1, MULT, 1)		
               END IF
            ELSE
               IF (MOD(I,2) .EQ. 1) THEN
                  CALL ZCOPY(4*LIMX*LIMX, MODD, 1, MULT, 1)		
               ELSE
                  CALL ZCOPY(4*LIMX*LIMX, MEVEN, 1, MULT, 1)		
               END IF
            END IF


			
            CALL GENABCD(LIMX, MULT, O, IO, ABCD, A, B, C, D)
            CALL GENTANDRINC(LIMX, TINC, RINC, TTILDEINC, RTILDEINC, 
     +       A, B, C,D)
            CALL UPDATETANDR(TINC, TTILDEINC, R, RTILDEINC, T, TTILDE,
     +       RTILDE, LIMX, RINC)
C           COND = CHECKUNI (LIMX, T, R, TTILDE, RTILDE)      
C           WRITE (*, *) '2: I=', I, ' ', COND
			
         END DO

C$$$ ################################################################



		 
         CALL SV_DECOMP(LIMX, T, TVALS)
         CALL SV_DECOMP(LIMX, R, RVALS)
         CALL SV_DECOMP(LIMX, TTILDE, TTVALS)
         CALL SV_DECOMP(LIMX, RTILDE, RTVALS)

C$$$ OUTPUT OF MAIN FUNCTION-COMMENTED OUT WHILE CHECKING FOR UNITARITY
         		 

C$$$         CALL PRINTVECTOR(TVALS, LIMX, 'T ')
C$$$         CALL PRINTVECTOR(RVALS, LIMX, 'R ')
C$$$         CALL PRINTVECTOR(TTVALS, LIMX, 'T~')
C$$$         CALL PRINTVECTOR(RTVALS, LIMX, 'R~')

	 
C       CALL PRINTT (T, LIMX, 'T  ')
C       CALL PRINTT (TTILDE, LIMX, 'T~ ')
C       CALL PRINTT (R, LIMX, 'R  ')
C       CALL PRINTT (RTILDE, LIMX, 'R~ ')
       ZEROC = 0.0 
       ONEC = 1.0 
C      CALL ZLASET ('ALL', LIMX, LIMX, ZEROC, ONEC, T, LIMX)
C      CALL ZLASET ('ALL', LIMX, LIMX, ZEROC, ONEC, TTILDE, LIMX)
C      CALL ZLASET ('ALL', LIMX, LIMX, ZEROC, ZEROC, R, LIMX)
C      CALL ZLASET ('ALL', LIMX, LIMX, ZEROC, ZEROC, RTILDE, LIMX)
       
    
C$$$  ERROR RETURN TYPE MISMATCH OF FUNCTION CHECKUNI REAL(4)/REAL(8)      
      COND = CHECKUNI(LIMX,T,R,TTILDE,RTILDE)
      G    = CONDUCTANCE (TVALS, LIMX)
      WRITE(*,50) E, G, COND
CCCC  ,(TVALS(I)*TVALS(I), I = 1, LIMX)
      E=E+0.01
      END DO
C$$$ SO T^2 + R^2 =1 FOR SVD VALUES, ALSO VERIFIED WITH R~ AND T~

      
 50   FORMAT (F6.3,15ES15.5E3)      

      

      STOP
      END

      DOUBLE PRECISION FUNCTION CONDUCTANCE (TVALS, LIMX)
      INTEGER LIMX
      DOUBLE PRECISION TVALS(LIMX)
      DOUBLE PRECISION DDOT      
      CONDUCTANCE = DDOT (LIMX, TVALS, 1, TVALS, 1)
      RETURN
      END

C$$$ END OF MAIN PROGRAM ###############################################
C$$$                     ###############################################
 
C$$$ ROUTINE TO GENERATE A,B,C,D. 
      SUBROUTINE GENABCD(LIMX, MULT, O, IO, ABCD, A, B, C, D)
	 
      INTEGER LIMX
      DOUBLE COMPLEX UNITY, ZERO, A(LIMX, LIMX), B(LIMX, LIMX),
     + C(LIMX, LIMX), D(LIMX, LIMX), MULT(2*LIMX, 2*LIMX),
     + O(2*LIMX, 2*LIMX), IO(2*LIMX, 2*LIMX), TEMP(2*LIMX, 2*LIMX),
     + ABCD(2*LIMX, 2*LIMX)
	 
      UNITY = 1.0
      ZERO = 0.0	 
	 
C$$$ ZGEMM MULTIPLIES MATRICES TOGTHER	  

         CALL ZGEMM('N', 'N', 2*LIMX, 2*LIMX, 2*LIMX, UNITY, MULT,
     +         2*LIMX, O, 2*LIMX, ZERO, TEMP, 2*LIMX)
         CALL ZGEMM('N', 'N', 2*LIMX, 2*LIMX, 2*LIMX, UNITY, IO,
     +         2*LIMX, TEMP, 2*LIMX, ZERO, ABCD, 2*LIMX)	  

C$$$ THIS IS FORTRAN 90 SYNTAX, REMOVE IN FUTURE REVISION WHEN BLAS/LAPACK SUBROUTINE IS FOUND
         A=ABCD(1:LIMX, 1:LIMX)
         B=ABCD((LIMX+1):2*LIMX, 1:LIMX)
         C=ABCD(1:LIMX, LIMX+1:2*LIMX)
         D=ABCD((LIMX+1):2*LIMX, (LIMX+1):2*LIMX)

C$$$ I HAVE VERIFIED THAT AD-BC=1 (IDENTITY MATRIX) AS EXPECTED
      RETURN
      END
	  
C$$$ ROUTINE TO GENERATE T AND R F	  
      SUBROUTINE GENTANDRINC(LIMX, TINC,RINC,TTILDEINC,RTILDEINC,A,B,
     + C,D)
	 
      INTEGER LIMX, X, Y
      DOUBLE COMPLEX UNITY, ZERO, A(LIMX, LIMX),
     + C(LIMX, LIMX), D(LIMX, LIMX), TEMP2(LIMX, LIMX),
     + TINC(LIMX, LIMX), TTILDEINC(LIMX, LIMX), RINC(LIMX, LIMX),
     + RTILDEINC(LIMX, LIMX), B(LIMX, LIMX), UNITMATRIX(LIMX, LIMX)

      UNITY = 1.0
      ZERO = 0.0
      DO X = 1, LIMX
         DO Y=1, LIMX
            UNITMATRIX(X, Y) = (0.0, 0.0)
         END DO
         UNITMATRIX(X, X) = 1.0
      END DO
	 
C$$$ T~ = D^-1
      CALL ZCOPY(LIMX*LIMX, D, 1, TTILDEINC, 1)
      CALL INVERTMATRIX(TTILDEINC, LIMX)
C$$$ R~ = BD^-1
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, B,
     +      LIMX, TTILDEINC, LIMX, ZERO, RTILDEINC, LIMX)
C$$$ R = -D^-1 C
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, -1*UNITY, TTILDEINC,
     +      LIMX, C, LIMX, ZERO, RINC, LIMX)
C$$$ R=-R
C$$$      RINC = -1*RINC   PRODUCES NON UNITARY MATRIX ? 
C$$$ T=(A-)? BD^-1 C
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, TTILDEINC,
     +      LIMX, C, LIMX, ZERO, TEMP2, LIMX)
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, B,
     +      LIMX, TEMP2, LIMX, ZERO, TINC, LIMX)
C$$$         TINC=A-TINC
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, A, LIMX,
     +      UNITMATRIX, LIMX, -1*UNITY, TINC, LIMX)

      RETURN
      END
	  
C$$$ WITH INCREASING ENERGY UPDATES T AND R TO NEW VALUES.

      SUBROUTINE UPDATETANDR(TINC, TTILDEINC, R, RTILDEINC, T, TTILDE,
     + RTILDE, LIMX, RINC)
	  
      INTEGER LIMX
      DOUBLE COMPLEX T(LIMX, LIMX), TTILDE(LIMX, LIMX), R(LIMX, LIMX),
     + RTILDE(LIMX, LIMX), TINC(LIMX, LIMX), TTILDEINC(LIMX, LIMX),
     + RINC(LIMX, LIMX), RTILDEINC(LIMX, LIMX)

C$$$ TEMPORARY LOCAL VARIABLES
      DOUBLE COMPLEX T1TEMP(LIMX, LIMX), TTILDE1TEMP(LIMX, LIMX),
     + R1TEMP(LIMX, LIMX), RTILDE1TEMP(LIMX, LIMX), T2TEMP(LIMX, LIMX),
     + TTILDE2TEMP(LIMX, LIMX),R2TEMP(LIMX, LIMX), UNITY, ZERO,
     + RTILDE2TEMP(LIMX, LIMX), BRACKET12(LIMX, LIMX),
     + BRACKET21(LIMX, LIMX), TRTEMP(LIMX, LIMX), TRTEMP2(LIMX, LIMX),
     + UNITMATRIX(LIMX, LIMX), ALLZERO(LIMX, LIMX)
      INTEGER X, Y
	  
      UNITY = 1.0
      ZERO = 0.0
	 
C$$$  IS IT COPY-BY-REFERENCE, OR BY-VALUE? 
C$$$  USE LAPACK FUNCTIONS, SUCH AS ZCOPY --- AVS
      CALL ZCOPY(LIMX*LIMX, T, 1, T1TEMP, 1)
      CALL ZCOPY(LIMX*LIMX, TTILDE, 1, TTILDE1TEMP, 1)
      CALL ZCOPY(LIMX*LIMX, R, 1, R1TEMP, 1)	  
      CALL ZCOPY(LIMX*LIMX, RTILDE, 1, RTILDE1TEMP, 1)	  
      CALL ZCOPY(LIMX*LIMX, TINC, 1, T2TEMP, 1)	  
      CALL ZCOPY(LIMX*LIMX, TTILDEINC, 1, TTILDE2TEMP, 1)	  
      CALL ZCOPY(LIMX*LIMX, RINC, 1, R2TEMP, 1)	  
      CALL ZCOPY(LIMX*LIMX, RTILDEINC, 1, RTILDE2TEMP, 1)
	  
      DO X = 1, LIMX
         DO Y = 1, LIMX
            ALLZERO(X, Y) = (0.0, 0.0)
            UNITMATRIX(X, Y) = (0.0, 0.0)
         END DO
         UNITMATRIX(X, X) = 1.0
      END DO
      CALL ZCOPY(LIMX*LIMX, ALLZERO, 1, TRTEMP, 1)
      CALL ZCOPY(LIMX*LIMX, ALLZERO, 1, TRTEMP2, 1)

C$$$ BRACKET12 = (1 - RTILDE1.R2)^-1
C$$$      CALL PRINTT(RTILDE1TEMP, LIMX, 'RT1')
C$$$      CALL PRINTT(R2TEMP, LIMX, 'R2 ')
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, RTILDE1TEMP, LIMX,
     + R2TEMP, LIMX, ZERO, BRACKET12, LIMX)
C$$$      CALL PRINTT(BRACKET12, LIMX, 'B12')
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, UNITMATRIX, LIMX,
     + UNITMATRIX, LIMX, -1*UNITY, BRACKET12, LIMX)
C$$$      CALL PRINTT(BRACKET12, LIMX, 'B12')
      CALL INVERTMATRIX(BRACKET12, LIMX)
C$$$      CALL PRINTT(BRACKET12, LIMX, 'B12')
      CALL ZCOPY(LIMX*LIMX, ALLZERO, 1, TRTEMP, 1)


C$$$ BRACKET21 = (1 - R2.RTILDE1)^-1
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, R2TEMP, LIMX,
     + RTILDE1TEMP, LIMX, ZERO, BRACKET21, LIMX)
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, UNITMATRIX, LIMX,
     + UNITMATRIX, LIMX, -1*UNITY, BRACKET21, LIMX)
      CALL INVERTMATRIX(BRACKET21, LIMX)
      CALL ZCOPY(LIMX*LIMX, ALLZERO, 1, TRTEMP, 1)


C$$$ T = T2.BRACKET12.T1
C$$$      CALL PRINTT(T1TEMP, LIMX, 'T1T')
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, BRACKET12, LIMX,
     + T1TEMP, LIMX, ZERO, TRTEMP, LIMX)
C$$$      CALL PRINTT(T2TEMP, LIMX, 'T2T')
C$$$      CALL PRINTT(TRTEMP, LIMX, 'TRT')
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, T2TEMP, LIMX,
     + TRTEMP, LIMX, ZERO, T, LIMX)
C$$$      CALL PRINTT(T, LIMX, 'T  ')
      CALL ZCOPY(LIMX*LIMX, ALLZERO, 1, TRTEMP, 1)


C$$$ TTILDE = TTILDE1.BRACKET21.TTILDE2
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, BRACKET21, LIMX,
     + TTILDE2TEMP, LIMX, ZERO, TRTEMP, LIMX)
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, TTILDE1TEMP, LIMX,
     + TRTEMP, LIMX, ZERO, TTILDE, LIMX)
      CALL ZCOPY(LIMX*LIMX, ALLZERO, 1, TRTEMP, 1)


C$$$ R = R1 + TTILDE1.BRACKET21.R2.T1
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, R2TEMP, LIMX,
     + T1TEMP, LIMX, ZERO, TRTEMP, LIMX)
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, BRACKET21, LIMX,
     + TRTEMP, LIMX, ZERO, TRTEMP2, LIMX)
      CALL ZCOPY(LIMX*LIMX, ALLZERO, 1, TRTEMP, 1)
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, TTILDE1TEMP, LIMX,
     + TRTEMP2, LIMX, ZERO, TRTEMP, LIMX)
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, UNITMATRIX, LIMX,
     + R1TEMP, LIMX, UNITY, TRTEMP, LIMX)
      CALL ZCOPY(LIMX*LIMX, TRTEMP, 1, R, 1)
      CALL ZCOPY(LIMX*LIMX, ALLZERO, 1, TRTEMP, 1)
      CALL ZCOPY(LIMX*LIMX, ALLZERO, 1, TRTEMP2, 1)


C$$$ RTILDE = RTILDE2 + T2.BRACKET12.RTILDE1.TTILDE2
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, RTILDE1TEMP, LIMX,
     + TTILDE2TEMP, LIMX, ZERO, TRTEMP, LIMX)
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, BRACKET12, LIMX,
     + TRTEMP, LIMX, ZERO, TRTEMP2, LIMX)
      CALL ZCOPY(LIMX*LIMX, ALLZERO, 1, TRTEMP, 1)
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, T2TEMP, LIMX,
     + TRTEMP2, LIMX, ZERO, TRTEMP, LIMX)
      CALL ZGEMM('N', 'N', LIMX, LIMX, LIMX, UNITY, UNITMATRIX, LIMX,
     + RTILDE2TEMP, LIMX, UNITY, TRTEMP, LIMX)
      CALL ZCOPY(LIMX*LIMX, TRTEMP, 1, RTILDE, 1)
	  
      RETURN
      END
	  
C$$$ CREATE THE 'O' MATRIX AND INVERT IT	  
      SUBROUTINE FILLOANDINVERT(O, IO, LIMX)
	  
      INTEGER LIMX, I
      DOUBLE COMPLEX O(2*LIMX, 2*LIMX), IO(2*LIMX, 2*LIMX)
	  
C$$$ GENERATE O-MATRIX
C$$$ O IS BLOCK MATRIX OF 1/SQRT(2) (1,1;I,-I)
         DO I = 1, LIMX
            O(I, I)=1/SQRT(2.0)
            O(I, LIMX+I)=1/SQRT(2.0)
            O(I+LIMX, I)=DCMPLX(0, 1/SQRT(2.0))
            O(I+LIMX, I+LIMX)=DCMPLX(0 ,-1/SQRT(2.0))
         ENDDO
         CALL ZCOPY(4*LIMX*LIMX, O, 1, IO, 1)
         CALL INVERTMATRIX(IO, 2*LIMX)  
	  
      RETURN
      END
	  
C$$$ ROUTINE TO INVERT A MATRIX USING LAPACK FUNCTIONS WITH A CHECK	  
      SUBROUTINE INVERTMATRIX(MATRIX, LIMX)
	  
      INTEGER S
      INTEGER LIMX, PIVOT(LIMX, LIMX)
      DOUBLE COMPLEX MATRIX(LIMX, LIMX), WORK(LIMX*LIMX)
	  
      CALL ZGETRF(LIMX, LIMX, MATRIX, LIMX, PIVOT, S)
      CALL ZGETRI(LIMX, MATRIX, LIMX, PIVOT, WORK, LIMX*LIMX, S)
      IF (S .NE. 0) THEN
         WRITE (*,*) 'NON-INVERTABLE MATRIX WITH S=', S
         STOP
      END IF
	  
      RETURN
      END
	  
C$$$ FUNCTION THAT CREATES A MATRIX 	  
      SUBROUTINE CALCMULT(MULT, LIMX, LIMY, WRAPX, MODD, MEVEN, E)
	  
      INTEGER LIMX, LIMY, WRAPX, SZ/1/
      INTEGER I/1/, NEIGH/1/
      DOUBLE PRECISION E
      DOUBLE COMPLEX ZEROC / 0.0 / 
      DOUBLE COMPLEX MODD(2*LIMX, 2*LIMX), MEVEN(2*LIMX, 2*LIMX),
     + MULT(2*LIMX, 2*LIMX)

      IF ((MOD(LIMX,2) .NE. 0)) THEN
         WRITE (*,*) 'ERROR: LIMX must be even for physical results'
         STOP 
      ENDIF
c$$$  HAMMERTIME! Program terminates here if LIMX is odd

      SZ = 2 * LIMX
      
      CALL ZLASET ('A', SZ, SZ, ZEROC, ZEROC, MODD, SZ)
      CALL ZLASET ('A', SZ, SZ, ZEROC, ZEROC, MEVEN, SZ)
C$$$ FIRST ROW IS EVEN - WRAPX MAKES NO DIFF, SECOND ROW NOT, ETC.
C$$$ - WHAT MATTERS IS WHICH ROW IT IS CENTRED ON
C$$$ THERE ARE 2 TRANSFER MATRICES TO GENERATE
C$$$ THERE ARE 4 BLOCK SUBMATRICES TO FILL
C$$$ MODD DOESN'T DEPEND ON XWRAPPING, MEVEN DOES.   '
      DO I = 1, LIMX
C$$$ FILL TOP-RIGHT SUBMATRIX
         MODD(I, LIMX+I)=1
         MEVEN(I, LIMX+I)=1
C$$$ FILL BOTTOM-LEFT SUBMATRIX
         MODD(I+LIMX, I)=-1
         MEVEN(I+LIMX, I)=-1
C$$$ FILL BOTTOM-RIGHT SUBMATRIX
         MODD(LIMX+I,LIMX+I)=E
         MEVEN(LIMX+I,LIMX+I)=E

C$$$  THE FOLLOWING CODE WAS MODIFIED --- AVS
C$$$  NEIGHBOURING SITE FOR ODD ROW, ON THE LEFT/RIGHT, DEPENDING ON I
         NEIGH = I + (2*MOD(I,2)-1) 
C$$$     WRITE (*, *) '? I = ', I, ' NEIGH = ', NEIGH
C$$$  NEIGHBOUR CAN BE < 0, OR > LIMX. IF WRAPX IS TRUE, THIS INDICATES
C$$$  A VALID SITE. THE FOLLOWING CODE IS A BIT UGLY, AS I AM NOT SURE
C$$$  WHAT IS MOD(-1, N) IN FORTRAN.
         IF (((NEIGH.LE.LIMX).AND.(NEIGH.GT.0)).OR.(WRAPX.GT.0)) THEN
           IF (NEIGH.LE.0) THEN
               NEIGH = NEIGH + LIMX
             ELSE
               NEIGH = MOD (NEIGH - 1, LIMX) + 1
             ENDIF
C$$$         WRITE (*, *) 'PUT: I = ', I, ' NEIGH = ', NEIGH
             MODD(LIMX + I, LIMX + NEIGH) = -1
         END IF
C$$$     NOW REPEAT THE SAME FOR EVEN ROWS, SWAPPING LEFT AND RIGHT
C$$$     AGAIN, THE CODE IS NOW RATHER UGLY.
         NEIGH = I - (2 * MOD(I, 2)  - 1)
C$$$     WRITE (*, *) '? I = ', I, ' NEIGH = ', NEIGH
         IF (((NEIGH.LE.LIMX).AND.(NEIGH.GT.0)).OR.(WRAPX.GT.0)) THEN
           IF (NEIGH.LE.0) THEN
             NEIGH = LIMX
           ELSE
             NEIGH = MOD (NEIGH - 1, LIMX) + 1
           END IF
C$$$       WRITE (*, *) 'PUT: I = ', I, ' NEIGH = ', NEIGH
           MEVEN(LIMX + I, LIMX + NEIGH) = -1
         END IF
      END DO
      IF (MOD(LIMY,2) .EQ. 1) THEN
C$$$         MULT=MODD
         CALL ZCOPY(4*LIMX*LIMX, MODD, 1, MULT, 1)
      ELSE
C$$$         MULT=MEVEN
         CALL ZCOPY(4*LIMX*LIMX, MEVEN, 1, MULT, 1)
      END IF
c$$$      CALL PRINTM (MODD,  LIMX, 'MO ')	  
c$$$      CALL PRINTM (MEVEN, LIMX, 'ME ')	  
      RETURN
      END
	  
C$$$ SINGLE VALUE DECOMPOSITION OF MATRIX

      SUBROUTINE SV_DECOMP(LIMX, MATRIX, OUTPUTS)
	  
      INTEGER LIMX, MSIZE, S
      DOUBLE PRECISION SVALS(LIMX), OUTPUTS(LIMX), RWORK(5*LIMX)
      DOUBLE COMPLEX MATRIX(LIMX, LIMX), TEMP2(LIMX, LIMX),
     + SVCPY(LIMX, LIMX), WORK(4*LIMX*LIMX)
	  
      MSIZE=4*LIMX*LIMX

C$$$ MAKE COPY OF MATRIX FOR SVD SINCE IT IS DESTROYED
C$$$      SVCPY=MATRIX
      CALL ZCOPY(LIMX*LIMX, MATRIX, 1, SVCPY, 1)
      CALL ZGESVD('N', 'N', LIMX, LIMX, SVCPY, LIMX, SVALS, TEMP2,
     + LIMX, TEMP2, LIMX , WORK, MSIZE, RWORK, S)
      IF (S .NE. 0) THEN
         WRITE (*,*) 'SVD FAILED WITH S=', S
         STOP
      END IF

C$$$      OUTPUTS=SVALS
      CALL ZCOPY(LIMX, SVALS, 1, OUTPUTS, 1)
	  
      RETURN
      END

C$$$ ROUTINE TO PRINT OUTPUT TO THE SCREEN	  
      SUBROUTINE PRINTVECTOR(INPUT, LIMX, MNAME)
	  
      INTEGER LIMX, I
      DOUBLE PRECISION INPUT(LIMX)
      CHARACTER*2 MNAME
	  
      WRITE (*,200) MNAME, (INPUT(I)*INPUT(I), I = 1, LIMX)
 200  FORMAT (A, ' =', ES15.5E2, ES15.5E2)
	  
      RETURN
      END
	  
      SUBROUTINE PRINTT(T, LIMX, MNAME)

      INTEGER LIMX, J, K
      DOUBLE COMPLEX T(LIMX, LIMX)
      CHARACTER*3 MNAME
      DO J=1, LIMX
        WRITE (*,400) MNAME, (REAL(T(J, K)), K=1, LIMX)
        WRITE (*,401) MNAME, 'I', (AIMAG(T(J, K)), K=1, LIMX)
      END DO
C      WRITE (*,400) MNAME, REAL(T(2,1)), REAL(T(2, 2))
C      WRITE (*,401) MNAME, 'I', AIMAG(T(1, 1)), AIMAG(T(1, 2))
C      WRITE (*,401) MNAME, 'I', AIMAG(T(2,1)), AIMAG(T(2, 2))

 400  FORMAT (A, 100ES15.5E3, ES15.5E3)
 401  FORMAT (A, A, 100ES15.5E3, ES15.5E3)

      RETURN
      END
      
      SUBROUTINE PRINTM(M, LIMX, MNAME)

      INTEGER LIMX, J, K
      DOUBLE COMPLEX M(2*LIMX, 2*LIMX)
      CHARACTER*3 MNAME
      DO J=1, 2*LIMX
        WRITE (*,500) MNAME, (REAL(M(J, K)), K=1, 2*LIMX)
      END DO
C      WRITE (*,400) MNAME, REAL(T(2,1)), REAL(T(2, 2))
C      WRITE (*,401) MNAME, 'I', AIMAG(T(1, 1)), AIMAG(T(1, 2))
C      WRITE (*,401) MNAME, 'I', AIMAG(T(2,1)), AIMAG(T(2, 2))

 500  FORMAT (A, 100F6.2)
 501  FORMAT (A, A, 100ES15.5E3, ES15.5E3)

      RETURN
      END

C$$$  ROUTINE TO CHECK FOR UNITARY MATRICES
    
      DOUBLE PRECISION FUNCTION CHECKUNI(LIMX, T,R,TTILDE,RTILDE)
      IMPLICIT NONE

      INTEGER LIMX, X/1/, Y/1/
      DOUBLE PRECISION ZLANGE
      DOUBLE COMPLEX AU/0.0/, BU/1.0/
      DOUBLE COMPLEX T(LIMX,LIMX), BETA/-1/,ALPHA/1/,
     + R(LIMX,LIMX),TTILDE(LIMX,LIMX),RTILDE(LIMX,LIMX),
     + U(LIMX*2,LIMX*2), CHECK(LIMX*2,LIMX*2)
 

C$$$ TEST CASES OF T,R,T~ R~
    
C$$$ FILLS A UNIT MATRIX

C      DO X = 1, 2*LIMX
C         DO Y = 1, 2*LIMX
C            CHECK(X, Y) = (0.0, 0.0)
C         END DO
C       CHECK(X, X) = 1.0
C      END DO
      CALL ZLASET ('ALL', 2*LIMX, 2*LIMX, AU, BU, CHECK, 2*LIMX)
C      CALL PRINTT (CHECK, 2*LIMX, 'C1 ')
      DO X=1, LIMX
       DO Y=1, LIMX
C$$$ TOP LEFT 
       U(X,Y)=T(X,Y)      
C$$$  BOTTOM LEFT
	 U(X+LIMX,Y)=R(X,Y)     
C$$$ TOP RIGHT    
        U(X,Y+LIMX)=RTILDE(X,Y)
C$$$ BOTTOM RIGHT
	  U(X+LIMX,Y+LIMX)=TTILDE(X,Y)
        END DO
      END DO

C$$$ ZGEMM HAS INBUILT FUNCTION TO FIND U**H
C$$   CALL PRINTT (U, 2*LIMX, 'U1 ')
      CALL ZGEMM('N', 'C', 2*LIMX, 2*LIMX, 2*LIMX, ALPHA, U,
     +       2*LIMX, U, 2*LIMX, BETA, CHECK, 2*LIMX)
C$$$ ZLANGE FINDS MATRIX NORM
C$$   CALL PRINTT (CHECK, 2 * LIMX, 'C2 ')
      CHECKUNI = ZLANGE('F', 2*LIMX, 2*LIMX, CHECK, 2*LIMX)	
C$$      WRITE (*, *) 'CHECKUNI:', CHECKUNI   
   
      RETURN       
      END
            













	      

