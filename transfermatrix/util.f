      SUBROUTINE SQCOPY (A, B, LIMX)
      IMPLICIT NONE
      INTEGER LIMX
      DOUBLE COMPLEX A(LIMX, LIMX), B(LIMX, LIMX)
      CALL ZCOPY (LIMX*LIMX, A, 1, B, 1)
      RETURN
      END

      SUBROUTINE SQZERO (M, LIMX)
      IMPLICIT NONE
      INTEGER LIMX
      DOUBLE COMPLEX M(LIMX, LIMX)
      DOUBLE COMPLEX ZERO/0.0/

      CALL ZLASET ('ALL', LIMX, LIMX, ZERO, ZERO, M, LIMX)
      RETURN
      END
      
      SUBROUTINE SQUNIT (M, LIMX)
      IMPLICIT NONE
      INTEGER LIMX
      DOUBLE COMPLEX M(LIMX, LIMX)
      DOUBLE COMPLEX ZERO/0.0/, ONE/1.0/

      CALL ZLASET ('ALL', LIMX, LIMX, ZERO, ONE, M, LIMX)
      RETURN
      END
c$$$  CREATES UNIT MATRIX
      
      SUBROUTINE SQUNITZ (M, ALPHA, LIMX)
      IMPLICIT NONE
      INTEGER LIMX
      DOUBLE COMPLEX M(LIMX, LIMX)
      DOUBLE COMPLEX ALPHA
      DOUBLE COMPLEX ZERO/0.0/, ONE/1.0/

      CALL ZLASET ('ALL', LIMX, LIMX, ZERO, ALPHA, M, LIMX)
      RETURN
      END

C$$$ ROUTINE TO PRINT VECTOR OUTPUT TO THE SCREEN
      SUBROUTINE PRINTVECTOR(INPUT, LIMX, MNAME)
      IMPLICIT NONE
      INTEGER LIMX, I
      DOUBLE PRECISION INPUT(LIMX)
      CHARACTER*2 MNAME
      WRITE (*,200) MNAME, (INPUT(I)*INPUT(I), I = 1, LIMX)
 200  FORMAT (A, ' =', ES15.5E2, ES15.5E2)
      RETURN
      END
      SUBROUTINE PRINTT(T, LIMX, MNAME)
      IMPLICIT NONE
      INTEGER LIMX, J, K
      DOUBLE COMPLEX T(LIMX, LIMX)
      CHARACTER*3 MNAME
      DO J=1, LIMX
        WRITE (*,400) MNAME, (REAL(T(J, K)), K=1, LIMX)
        WRITE (*,401) MNAME, 'I', (AIMAG(T(J, K)), K=1, LIMX)
      END DO

 400  FORMAT (A, 100ES15.5E3, ES15.5E3)
 401  FORMAT (A, A, 100ES15.5E3, ES15.5E3)

      RETURN
      END
c$$$ PRINTS REAL PART OF MATRIX TO THE SCREEN
      SUBROUTINE PRINTM(M, LIMX, MNAME)
      IMPLICIT NONE
      INTEGER LIMX, J, K
      DOUBLE COMPLEX M(2*LIMX, 2*LIMX)
      CHARACTER*3 MNAME
      DO J=1, 2*LIMX
        WRITE (*,500) MNAME, (REAL(M(J, K)), K=1, 2*LIMX)
      END DO

 500  FORMAT (A, 100F6.2)

      RETURN
      END
c$$$ PRINTS REAL AND COMPLEX MATRIX 
      SUBROUTINE ZPRINTM(M, LIMX, MNAME)
      IMPLICIT NONE
      INTEGER LIMX, J, K
      DOUBLE COMPLEX M(LIMX, LIMX)
      CHARACTER*3 MNAME
      DO J=1, LIMX
         WRITE (*,600) MNAME,(REAL(M(J, K)), '+', DIMAG(M(J, K)),
     +       'I | ', K=1,LIMX)
      END DO

 600  FORMAT (A, 100(ES15.5E4, A, ES15.5E4, A))

      RETURN
      END

      SUBROUTINE ZPOLAR(ARG, ZCOMPLEX)
      IMPLICIT NONE
c$$$  Subroutine to change e^i*arg in to a complex number in sin and cos, stored in zcomplex
      DOUBLE PRECISION ARG
      DOUBLE COMPLEX ZCOMPLEX
      ZCOMPLEX = DCMPLX(DCOS(ARG), DSIN(ARG))
      RETURN
      END
c$$$ 
      DOUBLE PRECISION FUNCTION CONDUCTANCE (TVALS, LIMX)
      IMPLICIT NONE
      INTEGER LIMX
      DOUBLE PRECISION TVALS(LIMX)
      DOUBLE PRECISION DDOT
      CONDUCTANCE = DDOT (LIMX, TVALS, 1, TVALS, 1)
      RETURN
      END
