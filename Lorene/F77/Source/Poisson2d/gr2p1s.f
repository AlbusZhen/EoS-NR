C
C   Copyright (c) 1998 Silvano Bonazzola
C
C    This file is part of LORENE.
C
C    LORENE is free software; you can redistribute it and/or modify
C    it under the terms of the GNU General Public License as published by
C    the Free Software Foundation; either version 2 of the License, or
C    (at your option) any later version.
C
C    LORENE is distributed in the hope that it will be useful,
C    but WITHOUT ANY WARRANTY; without even the implied warranty of
C    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
C    GNU General Public License for more details.
C
C    You should have received a copy of the GNU General Public License
C    along with LORENE; if not, write to the Free Software
C    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
C
C
C
C $Id: gr2p1s.f,v 1.2 2012/03/30 12:12:43 j_novak Exp $
C $Log: gr2p1s.f,v $
C Revision 1.2  2012/03/30 12:12:43  j_novak
C Cleaning of fortran files
C
C Revision 1.1.1.1  2001/11/20 15:19:30  e_gourgoulhon
C LORENE
C
c Revision 1.1  1998/06/22  10:31:19  eric
c Initial revision
c
C
C $Header: /cvsroot/Lorene/F77/Source/Poisson2d/gr2p1s.f,v 1.2 2012/03/30 12:12:43 j_novak Exp $
C
C

	SUBROUTINE GR2P1S(NDL,NDR,IND,ERRE,CHAMP,POTES)

C
C		ROUTINE POUR LE CALCUL DU POTENTIEL GRAVITATIONNEL 
C		DANS UN ESPACE A 2 DIMENSIONS EN COORDONNES SPHERIQUES
C		1-D AVEC PLUSIEURS COQUILLES.
C		LES CONDITIONS AU CONTOUR DE LA DERNIERE COQUILLE SONT
C		CELLES DU VIDE.
C
C			ARGUMENTS DE LA ROUTINE:
C
C		NDL	=TABLEAU CONTENANT LES PARAMETRES DES COQUILLES:
C			 DANS NDL(1) IL-Y-A LE NOMBRE DES COQUILLES, DANS
C			 NDL(2),NDL(3),...NDL(NZON+1) LES DEGRES DE LIBERTE
C			 EN r DES DIFFERENTES COQUILLES.
C
C		NDR	 =PREMIERE DIMENSION DES TABLEAUX DE TRAVAIL
C			  EXACTEMENT COMME DECLAREE DANS LE PROGRAMME APPELLANT
C
C		IND	=DRAPEAU: SI IND=1 LE CALCUL EST EFFECTUE SEULEMENT
C			 DANS L'ESPACE FINI, SI IND =2 LE CALCUL EST
C			 EFFECTUE AUSSI DANS L'ESPACE COMPACTIFIE
C			 ( 0 < r < INFINI)
C
C		ERRE	=TABLEAU CONTENANT LA VARIABLE ERRE DES DIFFERENTES
C			 COQUILLES
C
C		CHAMP	=TABLEAU OUTPUT AVEC LE CHAMP GRAVITA-
C			 TIONNEL DANS L'ESPACE DES COEFFICIENTS.
C		POTES	=TABLEAU INPUT CONTENANT LES COEFFICIENTS DE FOURIER
C		   	 ET DE TCHEBYTCHEF DE LA SOURCE DU POTENTIEL DANS
C			 LES NZON COQUILLES. EN OUTPUT ON A LE POTENTIEL
C			 COMME POUR CHAMP.
C			 DIMENSIONS DES TABLEAUX = MAX(NR1+1)
C
C		N.B.: DANS LA COQUILLE COMPACTIFIEE LA SOURCE DOIT ETRE
C               ----  DIVISEE PREALABLEMENT PAR u**4
C
	IMPLICIT NONE
C
	character*120 header
	data header/'$Header: /cvsroot/Lorene/F77/Source/Poisson2d/gr2p1s.f,v 1.2 2012/03/30 12:12:43 j_novak Exp $'/

	INTEGER NDL,NDL1,NDR,N514,N15,NZOE,NZON,LR,LZON,NR1,NR,IND

	double PRECISION CHAMP,ERRE,POTES,CC,CS,YY,VA1,VA0,DE1
     1	,RR1,RR2,X1,S1,S2,CONST,R1NZ

	PARAMETER(N514=258,N15=15)
C
	DIMENSION CHAMP(NDR,*),ERRE(NDR,*),POTES(NDR,*)
	DIMENSION CC(N514),CS(N514),YY(N514),RR1(N15),NDL(*)
	DIMENSION NDL1(N15),RR2(N15)
C
	X1=1
	NZON=NDL(1)
	NZOE=NZON
	IF(IND.EQ.2) THEN 
	NZON=NZOE-1
	ENDIF	
C
	DO 1 LZON=2,NZOE
	NDL1(LZON)=NDL(LZON)
   1	CONTINUE
	NDL1(1)=NZON
C
	IF(NZOE.GE.N15) THEN
	PRINT*,'DIMENSIONS INSUFFISANTES DANS LA ROUTINE GR2P1S, NZON=',NZON
	STOP
	ENDIF
C
	DO 20 LZON=2,NZOE+1
	IF(NDL(LZON).GT.N514) THEN
	PRINT*,'DIMENSIONS INSUFFISANTES DANS LA ROUTINE GR2P1S'
	PRINT*,'LZON,NR1=',LZON,NDL(LZON)
	STOP
	ENDIF
   20	CONTINUE
C
C	
	X1=1
C		CALCUL POTENTIEL NOYAU SPHERIQUE
C
C		DESALIASAGE
C
	NR1=NDL(2)
	NR=NR1-1
	POTES(NR-1,1)=POTES(NR-1,1)+POTES(NR1,1)*.5
	POTES(NR1,1)=0
C
	IF(NZOE.GT.1) THEN
	DO LZON=2,NZOE
	NR1=NDL(LZON+1)
	NR=NR1-1
	POTES(NR1-2,LZON)=POTES(NR1-2,LZON)+.5*POTES(NR1,LZON)
	POTES(NR1-3,LZON)=POTES(NR1-3,LZON)+   POTES(NR ,LZON)
	POTES(NR1,LZON)=0
	POTES(NR,LZON)=0
	ENDDO
	ENDIF	
C
	X1=1.E-07
	IF(IND.EQ.2.AND.ABS(ERRE(NDL(NZOE+1),NZOE)).GT.X1) THEN
	PRINT*,'ROUTINE GR2P1S: LE CAS DU DEVELOPPEMENT EN 1/r DANS'
	PRINT*,'GRILLE NON COMPACTIFIEE N''EST PAS ENVISAGE'
	STOP
	ENDIF
C
	NR1=NDL(2)
	RR1(1)=0
	RR2(1)=ERRE(NR1,1)
	IF(NZOE.GT.1) THEN
	DO 5 LZON=2,NZOE
	NR1=NDL(LZON+1)
	RR1(LZON)=ERRE(1,LZON)
	RR2(LZON)=(ERRE(NR1,LZON)-RR1(LZON))*.5
   5	CONTINUE
	ENDIF
	R1NZ=RR1(NZOE)
C
	NR1=NDL(2)
C
	X1=1
C
	DO 7 LZON=2,NZON+1
	NR1=NDL(LZON)
	IF(NR1.GE.NDR) THEN
	PRINT*,'ROUTINE GR2P1S: DIMENSIONS DES TABLEAUX INSUFFISANTES'
	PRINT*,'LZON,NR1,NDR=',LZON,NR1,NDR
	STOP
	ENDIF
C
	NDL1(LZON)=NR1
   7	CONTINUE
	NDL1(1)=NZON
C
C		CALCUL DU CHAMP POUR LE NOYAU SPHERIQUE
C
C		MULTIPLICATION DE LA SOURCE PAR r ET CALCUL DE LA PRIMITIVE
C
	RR1(NZON+1)=ERRE(NDL1(NZON+1),NZON)
	CALL DIVQ1S(NDL1,NDR,2,RR1,POTES,CHAMP)
C
	DO LZON=1,NZON
	NR1=NDL(LZON+1)+1
	NDL1(LZON+1)=NR1
	CHAMP(NR1,LZON)=0
	ENDDO
C	
	CALL PRIQ1S(NDL1,NDR,1,RR1,CHAMP,POTES)
	CALL DIVQ1S(NDL1,NDR,0,RR1,POTES,CHAMP)
	CALL PRIQ1S(NDL1,NDR,1,RR1,CHAMP,POTES)
C
	DO LZON=1,NZON
	NR1=NDL(LZON+1)
	NDL1(LZON+1)=NR1
	POTES(NR1,LZON)=POTES(NR1,LZON)*2
	ENDDO
C
	NR1=NDL(NZON+1)
	NR=NR1-1
	DO LR=1,NR1
	CC(LR)=POTES(LR,NZON)
	ENDDO
	IF(NZON.EQ.1) THEN
	CALL EXTR1S(NR,1,0,0,CC,VA1)
	ELSE
	CALL EXTM1S(NR,1,0,CC,VA1)
	ENDIF
	IF(IND.EQ.0) THEN
C
C		RACCORDEMENT AVEC LE VIDE
C
	NR1=NDL(NZON+1)
	NR=NR1-1
	DO LR=1,NR1
	CC(LR)=POTES(LR,NZON)
	ENDDO
	IF(NZON.EQ.1) THEN
	CALL EXTR1S(NR,1,1,0,CC,DE1)
	ELSE
	CALL EXTM1S(NR,1,1,CC,DE1)
	ENDIF
	DE1=DE1/RR2(NZON)
C
	CONST=2*(ERRE(NR1,NZON)*DE1*LOG(ERRE(NR1,NZON))-VA1)
C
	DO LZON=1,NZON
	POTES(1,LZON)=POTES(1,LZON)+CONST
	ENDDO
        RETURN
C
	ENDIF
C		CALCUL DANS LA COQUILLE COMPACTIFIEE
C
	IF(IND.NE.0) THEN
	NR1=NDL(NZOE+1)
	RR1(NZOE)=R1NZ
C
C		LA SOURCE ETANT DEJA DIVISEE PAR u**4, on VA LA MULTIPLIER
C		PAR -u
	NR=NR1-1
	DO LR=1,NR1
	CC(LR)=POTES(LR,NZOE)
	ENDDO
	S1=RR1(NZOE)*RR2(NZOE)
	S2=RR2(NZOE)**2
	CALL DIRCMS(NR,N514,1,0,S1,S2,CC,CS)
C	
C		CALCUL DE LA PRIMITIVE
C
	CALL PRIMS(NR,CS,CC,1,YY)
C
C		CALCUL DU CHAMP
C	
	CALL EXTM1S(NR,1,0,CC,VA0)
	CC(1)=CC(1)-2*VA0
	S1=RR1(NZOE)
	S2=RR2(NZOE)
	CALL DIRCMS(NR,N514,1,1,S1,S2,CC,CS)
C
	DO LR=1,NR1
	CHAMP(LR,NZOE)=CS(LR)
	ENDDO
C	
C	CALCUL DU POTENTIEL
C
	CALL PRIMS(NR,CS,CC,1,YY)
	DO LR=1,NR1
	POTES(LR,NZOE)=CC(LR)*RR2(NZOE)
	ENDDO
C	
C		ON IMPOSE QUE LE POTENTIEL DE LA ZONE COMPACTIFIEE
C		SE RACCORDE AVEC LE POTENTIEL DE LA DERNIERE COQUILLE
C		SOIT NUL A L'INFINI
C
	CALL EXTM1S(NR,0,0,CC,VA0)
	POTES(1,NZOE)=POTES(1,NZOE)+2*(VA1-VA0*RR2(NZOE))
C
C		ON IMPOSE QUE LE POTENTIEL SOIT NUL A L'INFINI
	DO LR=1,NR1
	CC(LR)=POTES(LR,NZOE)
	ENDDO
	CALL EXTM1S(NR,1,0,CC,VA1)
	DO LZON=1,NZOE
	POTES(1,LZON)=POTES(1,LZON)-2*VA1
	ENDDO	
	RETURN
	ENDIF
C
C  100	FORMAT(1X,10E10.3)
C  101	FORMAT(1X,' ')
	END


