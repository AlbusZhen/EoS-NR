C
C   Copyright (c) 1997 Silvano Bonazzola
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

	SUBROUTINE CEPLES(NDEG,NDR,INV,IPAIR,MM,CY,CC)

C
C           ROUTINE POUR LE DEVELOPPEMENT D' UNE FONCTION EN
C           EN FONCTIONS ASSOCIEES DE LEGENDRE.(ET VICE-VERSA)
C	    DANS LE CAS SYMMETRIQU OU SUPER-SYMMETRIQUE (SYMMETRIE
C           PAR RAPPORT LE PLAN EQUATORIALE Z=0 )
C
C           LE PRINCIPE EST LE SUIVANT: ON SUPPOSE QUE LA FONCTION
C           A DEVELOPPER SOIT DEVELOPPABLE EN FONCTIONS ASSOCIEES
C           DE LEGENDRE D'ORDRE M ET DE DEGRE' J :
C                    M
C                   P  (TETA)    (P(M,L))
C                    J
C
C           ON CHERCHE LES COEFFICIENTES DU DEVELOPPEMENT
C
C
C           F(TETA)=A(L)*P(M,L ) SOMME' SUR L. , 0 < L < L
C
C           LES FONCTIONS P(M,L) ONT LA FORME:
C           P(M,L)=SIN(TETA)**M*(B(J)*COS(TETA)**J) OU J VA DE
C           ZERO A L. LA FONCTION F EST DEVELOPPEE EN COEFFICIENTS
C           DE TCHEBYTCHEV DU PREMIER GENRE OU DU 2ME SELON QUE
C           M EST PAIRE OU IMPAIRE. LA ROUTINE CALCULE LES MA-
C           TRICES DE TRANSFORMATION DIRCTES ET INVERSES DES COEF-
C           FICIENTS DE TCHEBYTCHEV AU COEFFICIENTS DE LEGENDRE.
C           LE STOCKAGE EST EN "PARALLEL", (CFR LA ROUTINE
C           TFMS.)
C
C
C           LA CONVENTION DES INDICES EST LA SUIVANTE:
C           LA FONCTION ASSOCIEE DE LEGENDRE D'ORDRE
C           M ET DE DEGREE J DEFINIE DANS LA LITTERATURE
C           
C                   M
C                  P
C                   J
C
C           AVEC M.LE.J M.GE.0, J.GE.0 EST STOCKEE DANS UN TA-
C           BLEAU AYANT LES INDICES M=M+1, J=J-M+1.
C
C      NOTE:
C      ------
C
C           ON DOIT REMARQUER QUE LA REALATION DE PASSAGE DE LA-
C           GRANGE A TCHEBYTCHEV N'EST PAS UNIVOQUE POUR M>0.
C           IL FAUT EN GENERALE M+L COEFFICIENTS DE TCHEBYTCHEV
C           POUR DEVELOPPER UNE FONTION DE LEGENDRE D'ORDRE M
C           ET DEGREE L. VICE-VERSA ETANT DONNEA N COEFFICIENTS
C           DE TCHEBYTCHEV ON AURA UNE CORRESPONDANCE UNIVOQUE
C           AVEC N-M F COEFFICIENTS DE LEGENDRE.
C
C               ARGUMENTS DE LA ROUTINE:
C                        ...........................
C      
C           NDEG   = TABLEAU CONTENENT LE NOMBRE DE DEGRES DE
C		     LIBERTE EN R ET EN THETA
C	    IPAIR  = DRASPEAU: IPAIR=0 LA FONCTION EST SUPPOSEE ETRE
C		     SYMMETRIQUE PAR RAPPORT LE PLAN Z=0, SI IPAIR=1
C		     LA FONCTION EST ANTI-SYMMETRIQUE
C
C           INV = PARAMETRE: SI INV=0 LA ROUTINE EFFECTUE
C                 LE PASSAGE TCHEBYTCHEV LEGENDRE, SI INV=1
C                 ON A LA TRANSFORMATION LEGENDRE-TCHEBYTCHEV
C                 SI INV>1 ON A LA TRANSFORMATION LEGENDRE
C                 ESPACE DES TETA.
C
C           MM  = ORDRE DE LA FONCTION DE LEGENDRE.
C           CY  = IMPUT. SI INV=0 CY DOIT CONTENIR LE COEF-
C                CIENTS DE TCHEBYTCHEV DE LA FONCTION A TRAN-
C                SFORMER. SI INV > 0 DANS CY DOIVENT ETRE STO-
C                CQUES LES COEFF. DE LEGENDRE.
C                 BLEAU DOIVENT ETRE > NDEG(1)*NDEG(2)
C           CC   = OUTPUT. MEMES DIMENSIONS QUE POUR CY.
C
C           ROUTINE AYANT TESTEE LE 22/9/1993
C
	IMPLICIT NONE
C
C $Id: ceples.f,v 1.2 2012/03/30 12:12:42 j_novak Exp $
C $Log: ceples.f,v $
C Revision 1.2  2012/03/30 12:12:42  j_novak
C Cleaning of fortran files
C
C Revision 1.1.1.1  2001/11/20 15:19:30  e_gourgoulhon
C LORENE
C
c Revision 1.4  1997/10/13  12:42:42  eric
c Initialisation a zero de Y1.
c
C Revision 1.3  1997/09/11 09:39:04  hyc
C mise a jour cvstatic
C
C Revision 1.2  1997/05/23 11:33:54  hyc
C *** empty log message ***
C
C Revision 1.1  1997/05/07 16:40:29  hyc
C Initial revision
C
C
C $Header: /cvsroot/Lorene/F77/Source/Poisson2d/ceples.f,v 1.2 2012/03/30 12:12:42 j_novak Exp $
C
C
	character*120 header
	data header/'$Header: /cvsroot/Lorene/F77/Source/Poisson2d/ceples.f,v 1.2 2012/03/30 12:12:42 j_novak Exp $'/

C
	REAL*8
     1  X2,SQ2,WX,WPIG,WPI,WA1,WA2,WP,Y,CS,CC,OUT,WY,WPLJ,TETA
     1  ,Y1,WA3,WA5,WA4,WA6,WA,CY,C
C
	INTEGER NDIM,M33,M,MM,N,NL,L,IM,N1,N2,N21,NJ1,NJ2,MP,J,IS
     1	,I,I2,J2,JJ,NFON,MP1,INV,LMAX,N66,LMIN,IJ,MY1,MY2,J1,NJ21
     1  ,NY,NY1,MM1,MM2,IPAIR,NDEG,NDR,NR1,LR,LY,LY1
C
       DIMENSION WA1(65,65,65),WA2(65,65,65),WA3(65,65,33),CC(NDR,*)
       DIMENSION CY(NDR,*),Y1(132),WP(130,130),WY(260),IM(132)
	dimension CS(132),Y(132)
       DIMENSION WA4(65,65,34),WA5(65,65,34),WA6(65,65,34)
	dimension NDEG(3),C(132)
C
	SAVE X2,SQ2,IM,N1,N2,N21,NL,WX,WPIG,WPI
     1  ,NJ1,NJ2,NJ21,MP
     1  ,NFON
C
	SAVE JJ,WP,WA1,WA2,WA3,WA4,WA5,WA6
     1  ,MM1,MM2
C
	DATA NFON,NL/0,0/
C
C           PREPARATION DES PARAMETRES NECESSAIRS AU CALCUL.
C
       NR1=NDEG(1)
       NY1=NDEG(2)	 
       NY=NY1-1
       N1=NY1*2-1	
       N=N1-1
C	
       NDIM=130
       N66=129
       M33=65
C
       M=MM+1
C
       IF(N.GE.N66.OR.M.GT.M33) THEN
       PRINT 800,N,M
  800  FORMAT(10X,'DIMENSIONS INSUFFISANTES DANS LA ROUTINE CEPLES: ',
     , 'N=',I4,' M=',I4)
             CALL EXIT
             ENDIF
C
       IF(NY1.EQ.NL) GO TO 22
	NL=NY1
       N=N1-1
       N2=N/2
       N21=N2+1
       X2=2
       SQ2=SQRT(X2)
       DO 1 L=1,M33
       IM(L)=0
  1    CONTINUE
       WX=0
       WPIG=ACOS(WX)
       WPI=WPIG/N
  22   CONTINUE
       IF(IM(M).EQ.314) GO TO 21
       IM(M)=314
       NJ1=N-M+2
       NJ2=(NJ1-1)/2
       NJ21=NJ2+1 
       MP=1
       IF((M/2)*2.EQ.M)MP=0
C
C     PREPARATION DES MATRICES DE TRANSFORMATION'
C
C
       DO 2 J=1,N21
       DO 3 L=1,N21
       WA1(L,J,M)=0
       WA2(L,J,M)=0
  3    CONTINUE
  2    CONTINUE
C
C
C           PREPARATION DES FONCTION DE LEGENDRE POUR M=M ET POUR
C           J.LE.(N1-M). LES FONCTIONS SONT ECHANTILLONNEES DANS
C           L'INTERVAL 0 < TETA < PI.
C
C           NORMALISATION DES FONCTIONS DE LEGENDRE.
C
       CALL LEGE1(N,NDIM,M,WP)
C
       DO 8 J=1,NJ1
       DO 7 L=1,N1
       WP(L,J)=WP(L,J)/(N*M)
  7    CONTINUE
  8    CONTINUE
C
       DO 9 J=1,NJ1
       DO 10 L=1,N1
       Y(L)=WP(L,J)**2
  10   CONTINUE
       CALL CERARS(N,0,Y,CS,C)
       CALL INTRAS(N,C,OUT)
       WY(J)=OUT
  9    CONTINUE
C
       DO 11 J=1,NJ1
       DO 12 L=1,N1
       WPLJ=WP(L,J)/SQRT(WY(J))
       WP(L,J)=WPLJ
  12   CONTINUE
  11   CONTINUE
C
C
C           PREPARATION DES MATRICES DE TRANSFORMATION
C           TCHEBYTCHEV-LEGENDRE. LA MATRICE EST DEFINIE
C           PAR:  SOMME DE P(TETA,L,M)*T(TETA,J)*SIN(TETA) D(TETA)
C
C           CALCUL POUR LA PARTIE PAIRE DE LA FONCTION
C
       	DO  L=1,N1
       		Y1(L)=0
	ENDDO

       IS=1
       DO 13 I2=1,N21
       IS=-IS
       I=I2+I2-1
       IF(MP.EQ.1) THEN
       DO 14 L=1,N1
       TETA=(L-1)*WPI
       Y1(L)=COS(TETA*(I-1))*IS
  14   CONTINUE
       ENDIF
C
       IF(I.EQ.1.OR.I.EQ.N1)THEN
             DO 15 L=1,N1
             Y1(L)=Y1(L)*.5
  15   CONTINUE
             ENDIF
C
       IF(MP.EQ.0) THEN
       Y1(1)=0
       DO 16 L=1,N1
       TETA=(L-1)*WPI+WPIG
       Y1(L)=-SIN(TETA*I)
  16   CONTINUE
       ENDIF
C
       DO 17 J2=1,NJ21
       J=J2+J2-1
       DO 18 L=1,N1
       Y(L)=WP(L,J)
  18   CONTINUE
C
       DO 19 L=1,N1
       Y(L)=Y(L)*Y1(L)
  19   CONTINUE
       CALL CERARS(N,0,Y,CS,C)
       CALL INTRAS(N,C,OUT)
       WA1(I2,J2,M)=-OUT*SQ2
  17   CONTINUE
  13   CONTINUE
C
C           CALCUL DE LA MATRICE DE TRANSFORMATION POUR LA PARTIE
C           IMPAIRE DE LA FONCTION.
C
       DO 20 I2=1,N2
       I=I2+I2
       IF(MP.EQ.1) THEN
       DO 24 L=1,N1
       TETA=(L-1)*WPI+WPIG
       Y1(L)=COS(TETA*(I-1))
  24   CONTINUE
       ENDIF
C
       IF(MP.EQ.0) THEN
       DO 25 L=1,N1
       TETA=(L-1)*WPI+WPIG
       Y1(L)=SIN(TETA*I)
  25   CONTINUE
       ENDIF
C
       DO 26 J2=1,NJ2
       J=J2+J2
       DO 27 L=1,N1
       Y(L)=WP(L,J)
  27   CONTINUE
C
       DO 28 L=1,N1
       Y(L)=Y(L)*Y1(L)
  28   CONTINUE
C
       CALL CERARS(N,0,Y,CS,C)
       CALL INTRAS(N,C,OUT)
       WA2(I2,J2,M)=OUT*SQ2
  26   CONTINUE
  20   CONTINUE
C
C
C           CALCUL DES MATRICES POUR LE PASAGE DE LEGENDRE A TCHEBY-
C           TCHEV
C
C
C           CES MATRICES SONT DEFINIES PAR :
C           TRANSFORMATION DE TCHEBYTCHEV DES FONCTIONS DE
C           LEGENDRE. IL-Y-A QUATTRE MATRICES DEUX POUR MM PAIRE
C           OU IMPAIRE, ET DEUX POUR LES DEUX PARITES DE LA 
C           FONCTION A TRANSFORMER.
C
C
       DO 29 J=1,NJ21
       JJ=J+J-1
       DO 30 L=1,N1
       Y(L)=WP(L,JJ)
  30   CONTINUE
C
       IF(MP.EQ.1) THEN
       MM1=(M+1)/2
       CALL CERARS(N,0,Y,CS,C)
       DO 31 L=1,N21
       WA3(J,L,MM1)=C(L)/SQ2
  31   CONTINUE
       ENDIF
C
       IF(MP.EQ.0) THEN
       MM2=M/2
       CALL CERA2S(N,0,Y,CS,C)
       DO 32 L=1,N21
       WA5(J,L,MM2)=C(L)
  32   CONTINUE
       ENDIF
  29   CONTINUE
C
       DO 33 J=1,NJ2
       JJ=J+J
       DO 34 L=1,N1
       Y(L)=WP(L,JJ)
  34   CONTINUE
       IF(MP.EQ.1) THEN
       CALL CERARS(N,1,Y,CS,C)
       DO 35 L=1,N21
       WA4(J,L,MM1)=C(L)/SQ2 
  35   CONTINUE
       ENDIF
C
       IF(MP.EQ.0) THEN
       CALL CERA2S(N,1,Y,CS,C)
       DO 36 L=1,N21
       WA6(J,L,MM2)=C(L)/SQ2
  36   CONTINUE
       ENDIF
  33   CONTINUE
  21     CONTINUE
C
       IF(N.EQ.NFON) GO TO 23
       NFON=N
  23   CONTINUE
C
C  .......................................................................
C  ......
C
C           COMMENCEMENT DE LA TRANSFORMATION TCHEBYTCHEV-LEGENDRE.
C
	MP=1
	IF((M/2)*2.EQ.M) MP=0
       NJ1=N-M+2
       NJ2=(NJ1-1)/2   
       NJ21=NJ2+1
       MP1=MP+1
C
             IF(INV.EQ.0) THEN
C
C           TRANSFORMATION POUR LA PARTIE SYMMETRIQUE  DE LA FON-
C           TION.
C
       IF(IPAIR.EQ.0) THEN
	IF(MP.EQ.1)  THEN
C
       LMAX=N21
       DO 37 J=1,NJ21
       DO 38 LR=1,NR1
       WY(LR)=0
  38   CONTINUE
       LMIN=1
       IF(M.LT.3) LMIN=J
       DO 39 LY=LMIN,LMAX
       WA=WA1(LY,J,M)
       DO 40 LR=1,NR1
       WY(LR)=WY(LR)+WA*CY(LR,LY)
  40   CONTINUE
  39   CONTINUE
       DO 41 LR=1,NR1
       CC(LR,J)=WY(LR)
  41   CONTINUE
  37   CONTINUE
C
	IF(NJ21.LT.NY1) THEN
	DO J=NJ21+1,NY1
	DO LR=1,NR1
	CC(LR,J)=0
	ENDDO	
	ENDDO
	ENDIF
	RETURN
	ENDIF
C
	IF(MP.EQ.0)  THEN
C
      LMAX=N2
       DO 137 J=1,NJ21
       DO 138 LR=1,NR1
       WY(LR)=0
 138   CONTINUE
       LMIN=1
       IF(M.LT.3) LMIN=J
       DO 139 LY=LMIN,LMAX
       WA=WA1(LY,J,M)
       DO 140 LR=1,NR1
       WY(LR)=WY(LR)+WA*CY(LR,LY)
 140   CONTINUE
 139   CONTINUE
       DO 141 LR=1,NR1
       CC(LR,J)=WY(LR)
 141   CONTINUE
 137   CONTINUE
C
	IF(NJ21.LT.NY1) THEN
	DO J=NJ21+1,NY1
	DO LR=1,NR1
	CC(LR,J)=0
	ENDDO	
	ENDDO
	ENDIF
	RETURN
	ENDIF
C
		ENDIF
C
C           CAS ANTISYMMETRIQUE PAR RAPPORT z=0
C
	IF(IPAIR.EQ.1) THEN
	LMAX=N2
       IJ=0
       IF(MP.EQ.0) IJ=1
       DO 142 J=1,NJ2
       DO 143 LR=1,NR1
       WY(LR)=0
  143   CONTINUE
C
       LMIN=1
       IF(M.LT.3)LMIN=J
       DO 144 LY=LMIN,NY
       WA=WA2(LY,J,M)
       DO 145 LR=1,NR1
       WY(LR)=WY(LR)+WA*CY(LR,LY)
 145   CONTINUE
 144   CONTINUE
C
       DO 146 LR=1,NR1
       CC(LR,J)=WY(LR)
 146   CONTINUE
 142   CONTINUE
C
       IF(NJ2+1.LT.NY1) THEN
	DO LY=NJ2+1,NY1
	DO LR=1,NR1
	CC(LR,LY)=0
	ENDDO
	ENDDO
	ENDIF
	RETURN
C
	ENDIF
	ENDIF
C
C
C           TRANSFORMATION LEGENDRE-TCHEBYTCHEV ET LEGENDRE ESPACE
C           DES CONFIGUREATIONS
C
C
       IF(INV.EQ.1) THEN
C
       MY1=(M+1)/2
       MY2=MY1-1
C
	MP=1
	IF((MM/2)*2.EQ.MM) MP=0
	IF(MP.EQ.0) THEN
C
C           TRANSFORMATION POUR M PAIRE.
C		TRANSFORMATION CAS PAIRE
C
	IF(IPAIR.EQ.0) THEN
C
       MM1=(MM+2)/2
       DO 49 J=1,N21
       LMIN=1
       IF(J.GT.MY1) LMIN=J-MY2
       DO 50 LR=1,NR1
       WY(LR)=0
  50   CONTINUE
       DO 51 LY=LMIN,NJ21
       WA=WA3(LY,J,MM1)
      DO 52 LR=1,NR1
       WY(LR)=WY(LR)+WA*CY(LR,LY)
  52   CONTINUE
  51   CONTINUE
C
       DO 53 LR=1,NR1
       CC(LR,J)=WY(LR)
  53   CONTINUE
  49   CONTINUE
	DO LR=1,NR1
	CC(LR,NY1)=CC(LR,NY1)*2
	ENDDO
	RETURN 
	ENDIF
C
	IF(IPAIR.EQ.1) THEN
C
C           TRANSFORMATION DE LA PARTIE IMPAIRE DE LA FONCTION, M PAIRE
C

	MM1=(MM+2)/2
C
       DO 54 J=1,N21
       LMIN=1
       IF(J.GT.MY1) LMIN=J-MY2
       DO 55 LR=1,NR1
       WY(LR)=0
  55   CONTINUE
C
       DO 56 LY=LMIN,NJ21-1
       WA=WA4(LY,J,MM1)
       DO 57 LR=1,NR1
       WY(LR)=WY(LR)+WA*CY(LR,LY)
  57   CONTINUE
  56   CONTINUE
C
       DO 58 LR=1,NR1
       CC(LR,J)=WY(LR)
  58   CONTINUE
  54   CONTINUE
C
       DO 59 LR=1,NR1
       CC(LR,NY1)=CC(LR,NY1)*2
  59   CONTINUE
	RETURN
       ENDIF
	ENDIF
C
C
C           TRANSFORMATION POUR M IMPAIRE.
C
             IF(MP.EQ.1) THEN
C
C
C           TRANSFORMATION CAS FONCTION PAIRE M IMPAIRE
C
	       MM2=M/2
	IF(IPAIR.EQ.0) THEN	
       DO 60 J=1,N21
       LMIN=1
       IF(J.GT.MY1) LMIN=J-MY2
       DO 61 LR=1,NR1
       WY(LR)=0
  61   CONTINUE
       DO 62 LY=LMIN,NJ21
       WA=WA5(LY,J,MM2)/SQ2
       DO 63 LR=1,NR1
       WY(LR)=WY(LR)+CY(LR,LY)*WA
  63   CONTINUE
  62   CONTINUE
C
       DO 64 LR=1,NR1
       CC(LR,J)=WY(LR)
  64   CONTINUE
  60   CONTINUE
	RETURN
	ENDIF
C
C
C           TRANSFORMATION CAS FONCTION IMPAIRE M IMPAIRE
C
	IF(IPAIR.EQ.1) THEN
       DO 65 J=2,N21
       J1=J-1
       LMIN=J1-MY2
       IF(LMIN.LT.1) LMIN=1
       DO 66 LR=1,NR1
       WY(LR)=0
  66   CONTINUE
C
       DO 67 LY=LMIN,NJ21-1
	LY1=LY+1
       WA=WA6(LY,J,MM2)
       DO 68 LR=1,NR1
       WY(LR)=WY(LR)+WA*CY(LR,LY1)
  68   CONTINUE
  67   CONTINUE
C
       DO 69 LR=1,NR1
       CC(LR,J)=WY(LR)
  69   CONTINUE
  65   CONTINUE
C
	DO 80 LR=1,NR1
	CC(LR,1)=0
   80	CONTINUE
       ENDIF
C
	RETURN
	ENDIF
             ENDIF
C
  100  FORMAT(1X,10E10.3)
  101  FORMAT(1X,' ')
  111  FORMAT(1X,10E10.2)
  300  FORMAT(1X,4I4,5E10.3)
       RETURN
       END
