!Problem 21 from Jeff Cash test set:
!Y''=(Y + Y**2 - EXP(-2D0*X/SQRT(Bp)))/Bp,
!Y(0) = 1, y(1) = EXP(-1D0/SQRT(Bp))
!Exact Solution:
!Y(x) = EXP(-X/SQRT(Bp))
!Solved with Bp = 0.01

MODULE DEFINE_FCN

DOUBLE PRECISION :: Bp
INTEGER,PARAMETER :: NODE=2

CONTAINS

!ODEs
SUBROUTINE FSUB(X,Y,F)
	DOUBLE PRECISION :: X,Y(NODE),F(NODE)
	F(1)=Y(2)
	F(2)=(Y(1) + Y(1)**2 - EXP(-2D0*X/SQRT(Bp)))/Bp
END SUBROUTINE FSUB

!Boundary Conditions
SUBROUTINE BCSUB(YA,YB,BCA,BCB)
	DOUBLE PRECISION :: YA(NODE),YB(NODE),BCA(1),BCB(1)
	BCA(1) = YA(1) -1D0
	BCB(1) = YB(1) - EXP(-1D0/SQRT(Bp)) 
END SUBROUTINE BCSUB

!Initial Guess
SUBROUTINE GUESS_Y(X,Y)
	DOUBLE PRECISION :: X,Y(NODE)
	Y(1) =0.5d0
	Y(2) = 0d0
END SUBROUTINE GUESS_Y

END MODULE DEFINE_FCN


PROGRAM CASH21

USE DEFINE_FCN
USE BVP_M

IMPLICIT NONE

TYPE(BVP_SOL) :: SOL !BVP_SOLVER main solution structure

! Variables for BVP_SOLVER
INTEGER :: I ! counter for solution output
INTEGER :: METH ! Method to be employed by BVP_SOLVER.
INTEGER :: ERRORCON !error control method
DOUBLE PRECISION :: ERREST ! Estimate of global error.
DOUBLE PRECISION :: TTOL !tolerance
DOUBLE PRECISION :: A=0D0,B=1D0 ! Define interval using global
DOUBLE PRECISION :: YPLOT(NODE), XPLOT !Plot solution

!Set method
METH=6
!Set tolerance
TTOL=1E-6
!Set Bp
Bp = 0.01D0
!Set ERROR_CONTROL_METHOD
ERRORCON = 1 !for defect control

SOL = BVP_INIT(2,1,(/A,B/),GUESS_Y,MAX_NUM_SUBINTERVALS=1000000)
SOL = BVP_SOLVER(SOL,FSUB,BCSUB,METHOD=METH, &
	ERROR_CONTROL=ERRORCON,TOL=TTOL,HOERROR=ERREST)
                
PRINT *, "Estimated global error: ", ERREST

OPEN(UNIT=7,FILE="cash21.dat")
  DO I = 1,10000
    XPLOT = A + (I-1)*(B - A)/9999D0
    CALL BVP_EVAL(SOL,XPLOT,YPLOT)
    WRITE(UNIT=7,FMT="(6D12.4)") XPLOT,YPLOT
END DO

CLOSE(7)
				
CALL BVP_TERMINATE(SOL)

END PROGRAM CASH21
