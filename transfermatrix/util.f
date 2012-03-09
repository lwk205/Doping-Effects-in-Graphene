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

      SUBROUTINE ZPRINTM(M, LIMX, MNAME)

      INTEGER LIMX, J, K
      DOUBLE COMPLEX M(2*LIMX, 2*LIMX)
      CHARACTER*3 MNAME
      DO J=1, 2*LIMX
         WRITE (*,600) MNAME,(REAL(M(J, K)), '+', DIMAG(M(J, K)),  
     +       'I | ', K=1,2*LIMX)
      END DO
C      WRITE (*,400) MNAME, REAL(T(2,1)), REAL(T(2, 2))
C      WRITE (*,401) MNAME, 'I', AIMAG(T(1, 1)), AIMAG(T(1, 2))
C      WRITE (*,401) MNAME, 'I', AIMAG(T(2,1)), AIMAG(T(2, 2))

 600  FORMAT (A, 100(F8.4, A, F7.4, A))

      RETURN
      END

      SUBROUTINE ZPOLAR(ARG, ZCOMPLEX)
c$$$  Subroutine to change e^i*arg in to a complex number in sin and cos, stored in zcomplex
      
      DOUBLE PRECISION ARG
      DOUBLE COMPLEX ZCOMPLEX
      
      ZCOMPLEX = DCMPLX(COS(ARG), SIN(ARG))
      RETURN
      END

      DOUBLE PRECISION FUNCTION CONDUCTANCE (TVALS, LIMX)
      INTEGER LIMX
      DOUBLE PRECISION TVALS(LIMX)
      DOUBLE PRECISION DDOT      
      CONDUCTANCE = DDOT (LIMX, TVALS, 1, TVALS, 1)
      RETURN
      END
