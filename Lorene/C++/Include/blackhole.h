/*
 *  Definition of Lorene class Black_hole
 *
 */

/*
 *   Copyright (c) 2005-2007 Keisuke Taniguchi
 *
 *   This file is part of LORENE.
 *
 *   LORENE is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License version 2
 *   as published by the Free Software Foundation.
 *
 *   LORENE is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with LORENE; if not, write to the Free Software
 *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

#ifndef __BLACKHOLE_H_ 
#define __BLACKHOLE_H_ 

/*
 * $Id: blackhole.h,v 1.4 2014/10/13 08:52:32 j_novak Exp $
 * $Log: blackhole.h,v $
 * Revision 1.4  2014/10/13 08:52:32  j_novak
 * Lorene classes and functions now belong to the namespace Lorene.
 *
 * Revision 1.3  2008/07/02 20:41:40  k_taniguchi
 * Addition of the routines to compute angular momentum
 *  and modification of the argument of equilibrium_spher.
 *
 * Revision 1.2  2008/05/15 18:53:37  k_taniguchi
 * Change of some parameters and introduction of some
 * computational routines.
 *
 * Revision 1.1  2007/06/22 01:02:57  k_taniguchi
 * *** empty log message ***
 *
 *
 * $Header: /cvsroot/Lorene/C++/Include/blackhole.h,v 1.4 2014/10/13 08:52:32 j_novak Exp $
 *
 */

// External classes which appear in the declaration of class Black_hole:
//class YYY ; 

// Headers Lorene
#include "metric.h"

                    //-------------------------------//
                    //     Base class Black_hole     //
                    //-------------------------------//

namespace Lorene {
/**
 * Base class for black holes.
 * \ingroup(star)
 *
 * According to the 3+1 formalism, the spacetime metric is written
 * \f[
 *   ds^2 = - \alpha^2 dt^2 + \gamma_{ij} ( dx^i + \beta^i dt )
 *                                        ( dx^j + \beta^j dt )
 * \f]
 * where \f$\gamma_{ij}\f$ is the spatial metric.
 * 
 */
class Black_hole {

    // Data : 
    // -----
    protected:
        /// Mapping associated with the black hole
        Map& mp ;

	/** \c true  for a Kerr-Schild background, \c false  for
	 *  a conformally flat background
	 */
	bool kerrschild ;

	/// Gravitational mass of BH
	double mass_bh ;

	// Metric quantities
	// -----------------

	/**
	 *  A function (lapse function * conformal factor) lapconf
	 *  generated by the black hole
	 */
	Scalar lapconf ;  // lapconf = lapconf_rs + lapconf_bh

	/// Part of lapconf from the numerical computation
	Scalar lapconf_rs ;

	/// Part of lapconf from the analytic background
	Scalar lapconf_bh ;

	/// Lapse function generated by the black hole
	Scalar lapse ;

	/// Shift vector generated by the black hole
	Vector shift ;  // shift = shift_rs + shift_bh

	/// Part of the shift vector from the numerical computation
	Vector shift_rs ;

	/// Part of the shift vector from the analytic background
	Vector shift_bh ;

	/// Conformal factor generated by the black hole
	Scalar confo ;

	/// Trace of the extrinsic curvature
	//	Scalar trace_k ;

	/** Extrinsic curvature tensor \f$\ A^{ij}\f$
	 *  generated by \c shift , \c lapse , and
	 *  \c confo .
	 */
	Sym_tensor taij ;

	/// Part of the extrinsic curvature tensor
	Sym_tensor taij_rs ;

	/** Part of the scalar \f$\eta_{ik} \eta_{jl} A^{ij} A^{kl}\f$
	 *  generated by \f$A_{ij}\f$
	 */
	Scalar taij_quad ;

	/// Part of the scalar
	Scalar taij_quad_rs ;

	/** Flat metric defined on the mapping (Spherical components
	 *  with respect to the mapping of the black hole ).
	 */
	Metric_flat flat ;

	/// Conformal metric \f$\tilde \gamma_{ij}\f$
	//	Metric tgij ;

    // Derived data : 
    // ------------
    protected:
	mutable double* p_mass_irr ;  /// Irreducible mass of the black hole

	mutable double* p_mass_adm ;  /// ADM mass

	mutable double* p_mass_kom ;  /// Komar mass

	mutable double* p_rad_ah ; /// Radius of the apparent horizon

	mutable double* p_spin_am_bh ; /// Spin angular momentum

	/// Total angular momentum of the black hole
	mutable Tbl* p_angu_mom_bh ;

    // Constructors - Destructor
    // -------------------------
    public:

	/** Standard constructor.
	 *
	 *  @param mp_i Mapping on which the black hole will be defined
	 */
	Black_hole(Map& mp_i, bool Kerr_schild, double massbh) ;

	Black_hole(const Black_hole& ) ;       ///< Copy constructor

	/** Constructor from a file (see \c sauve(FILE*) )
	 *
	 *  @param mp_i Mapping on which the black hole will be defined
	 *  @param fich input file (must have been created by the function
	 *         \c sauve )
	 */
	Black_hole(Map& mp_i, FILE* fich) ;    		

	virtual ~Black_hole() ;			///< Destructor
 

    // Memory management
    // -----------------
    protected:
	/// Deletes all the derived quantities
	virtual void del_deriv() const ;

	/// Sets to \c 0x0 all the pointers on derived quantities
	void set_der_0x0() const ;


    // Mutators / assignment
    // ---------------------
    public:
	/// Assignment to another \c Black_hole
	void operator=(const Black_hole&) ;

	/// Read/write of the mapping
	Map& set_mp() {return mp; } ;

	/// Read/write of the gravitational mass of BH [{\tt m\_unit}]
	double& set_mass_bh() {return mass_bh; } ;

    // Accessors
    // ---------
    public:
	/// Returns the mapping
	const Map& get_mp() const {return mp; } ;

	/** Returns \c true  for a Kerr-Schild background, \c false  for
	 *  a Conformally flat one
	 */
	bool is_kerrschild() const {return kerrschild; } ;

	/// Returns the gravitational mass of BH [{\tt m\_unit}]
	double get_mass_bh() const {return mass_bh; } ;

	/// Returns lapconf generated by the black hole
	const Scalar& get_lapconf() const {return lapconf; } ;

	/// Returns the part of lapconf from the numerical computation
	const Scalar& get_lapconf_rs() const {return lapconf_rs; } ;

	/// Returns the lapse function generated by the black hole
	const Scalar& get_lapse() const {return lapse; } ;

	/// Returns the shift vector generated by the black hole
	const Vector& get_shift() const {return shift; } ;

	/** Returns the part of the shift vector from
	 *  the numerical computation
	 */
	const Vector& get_shift_rs() const {return shift_rs; } ;

	/// Returns the conformal factor generated by the black hole
	const Scalar& get_confo() const {return confo; } ;

    // Outputs
    // -------
    public:
	virtual void sauve(FILE *) const ;	    ///< Save in a file
    
	/// Display
	friend ostream& operator<<(ostream& , const Black_hole& ) ;	

    protected:
	/// Operator >> (virtual function called by the operator <<)
	virtual ostream& operator>>(ostream& ) const ;

    // Global quantities
    // -----------------
    public:
	/// Irreducible mass of the black hole
	virtual double mass_irr() const ;

	/// ADM mass
	virtual double mass_adm() const ;

	/// Komar mass
	virtual double mass_kom() const ;

	/// Radius of the apparent horizon
	virtual double rad_ah() const ;

	/// Spin angular momentum
	double spin_am_bh(bool bclapconf_nd, bool bclapconf_fs,
			  const Tbl& xi_i, const double& phi_i,
			  const double& theta_i, const int& nrk_phi,
			  const int& nrk_theta) const ;

	/** Total angular momentum.
	 *
	 *  @return 1-D {\tt Tbl} of size 3, according to \\
	 *   {\tt angu\_mom()(0)} = $J^x$, \\
	 *   {\tt angu\_mom()(1)} = $J^y$, \\
	 *   {\tt angu\_mom()(2)} = $J^z$.
	 */
	const Tbl& angu_mom_bh() const ;

    // Computational routines
    // ----------------------
    public:
	/** Boundary condition on the apparent horizon of the black hole
	 *  for the lapse function: 2-D \c Valeur
	 */
	const Valeur bc_lapconf(bool neumann, bool first) const ;

	/** Boundary condition on the apparent horizon of the black hole
	 *  for the shift vector of the \fx\f direction: 2-D \c Valeur
	 */
	const Valeur bc_shift_x(double omega_r) const ;

	/** Boundary condition on the apparent horizon of the black hole
	 *  for the shift vector of the \fy\f direction: 2-D \c Valeur
	 */
	const Valeur bc_shift_y(double omega_r) const ;

	/** Boundary condition on the apparent horizon of the black hole
	 *  for the shift vector of the \fz\f direction: 2-D \c Valeur
	 */
	const Valeur bc_shift_z() const ;

	/** Boundary condition on the apparent horizon of the black hole
	 *  for the conformal factor: 2-D \c Valeur
	 */
	const Valeur bc_confo() const ;	

	/** Computes \c taij , \c taij_quad  from \c shift , \c lapse ,
	 *  \c confo .
	 */
	void extr_curv_bh() ;

	/** Computes a spherical, static black-hole by giving boundary
	 *  conditions on the apparent horizon.
	 *
	 *  @param neumann [input] \c true  for the neumann bc, \c false  for
	 *                 the dirichlet one for the lapse
	 *  @param first [input] \c true  for the first type of bc,
	 *               \c false  for the second type
	 *  @param spin_omega [input] spin parameter of the black hole
	 *  @param precis [input] threshold in the relative difference of
	 *                a metric quantity between two succesive steps
	 *                to stop the iterative procedure
	 *                (default value: 1.e-14)
	 *  @param precis_shift [input] threshold in the relative difference
	 *                of the shift vector between two succesive steps
	 *                to stop the iterative procedure
	 *                (default value: 1.e-8)
	 */
	void equilibrium_spher(bool neumann, bool first, double spin_omega,
			       double precis = 1.e-14,
			       double precis_shift = 1.e-8) ;

	/** Sets the metric quantities to a spherical, static blach-hole
	 *  analytic solution
	 *
	 *  @param neumann [input] \c true  for the neumann bc, \c false  for
	 *                 the dirichlet one for the lapse
	 *  @param first [input] \c true  for the first type of bc,
	 *               \c false  for the second type
	 */
	void static_bh(bool neumann, bool first) ;

	/** Computes a radius of apparent horizon (excised surface)
	 *  in isotropic coordinates
	 *
	 *  @param neumann [input] \c true  for the neumann bc, \c false  for
	 *                 the dirichlet one for the lapse
	 *  @param first [input] \c true  for the first type of bc,
	 *               \c false  for the second type
	 */
	double rah_iso(bool neumann, bool first) const ;

	/** Expresses the areal radial coordinate
	 *  by that in spatially isotropic coordinates
	 *
	 *  @param neumann [input] \c true  for the neumann bc, \c false  for
	 *                 the dirichlet one for the lapse
	 *  @param first [input] \c true  for the first type of bc,
	 *               \c false  for the second type
	 */
	const Scalar r_coord(bool neumann, bool first) const ;

	/** Compute a forth-order Runge-Kutta integration to the phi
	 *  direction for the solution of the Killing vectors on the
	 *  equator
	 *
	 *  @param xi_i [input] initial set of the Killing vectors
	 *              at the starting point on the equator
	 *  @param phi_i [input] initial phi coordinate at which the
	 *               integration starts
	 *  @param nrk [input] number of the Runge-Kutta integration
	 *             between two successive collocation points
	 */
	Tbl runge_kutta_phi_bh(const Tbl& xi_i, const double& phi_i,
			       const int& nrk) const ;

	/** Compute a forth-order Runge-Kutta integration to the theta
	 *  direction for the solution of the Killing vectors
	 *
	 *  @param xi_i [input] initial set of the Killing vectors
	 *              at the starting point on the equator
	 *  @param theta_i [input] initial theta coordinate at which the
	 *                 integration starts
	 *  @param phi [input] fixed phi coordinate during integration to
	 *             the theta direction
	 *  @param nrk [input] number of the Runge-Kutta integration
	 *             between two successive collocation points
	 */

	Tbl runge_kutta_theta_bh(const Tbl& xi_i, const double& theta_i,
				 const double& phi, const int& nrk) const ;

	/** Compute the Killing vector of a black hole normalized so that
	 *  its affine length is 2 M_PI
	 *
	 *  @param xi_i [input] initial set of the Killing vectors
	 *              at the starting point on the equator
	 *  @param phi_i [input] initial phi coordinate at which the
	 *               integration starts
	 *  @param theta_i [input] initial theta coordinate at which the
	 *                 integration starts
	 *  @param nrk_phi [input] number of the Runge-Kutta integration
	 *                 between two successive collocation points
	 *                 for the phi direction
	 *  @param nrk_theta [input] number of the Runge-Kutta integration
	 *                   between two successive collocation points
	 *                   for the theta direction
	 */
	Vector killing_vect_bh(const Tbl& xi_i, const double& phi_i,
			       const double& theta_i, const int& nrk_phi,
			       const int& nrk_theta) const ;

};
ostream& operator<<(ostream& , const Black_hole& ) ;

}
#endif
