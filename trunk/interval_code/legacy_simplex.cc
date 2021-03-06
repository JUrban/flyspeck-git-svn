/* ========================================================================== */
/* FLYSPECK - CODE FORMALIZATION                                              */
/*                                                                            */
/* Chapter: nonlinear inequalities                                            */
/* Author:  Thomas Hales     */
/* Date: 1997, 2010-09-04                                                     */
/* Split off from taylorData 2012-6 */
/* ========================================================================== */

// old version of taylorSimplex functions.
// used now for regression testing of new implementation.
// This is legacy code.

// parameter passing modes (const-reference parameters)
// http://pages.cs.wisc.edu/~hasti/cs368/CppTutorial/NOTES/PARAMS.html


#include <iomanip>
#include <utility>
#include <tr1/unordered_map>
extern "C"
{
#include <math.h>
#include <time.h>
#include <stdlib.h>
#include <float.h>
#include <assert.h>
}
#include "interval.h"
#include "univariate.h"
#include "lineInterval.h"
#include "wide.h"
#include "secondDerive.h"
#include "taylorData.h"
#include "legacy_simplex.h"

using namespace std;
using namespace tr1;


/* ========================================================================== */
/*                                                                            */
/*   Section:FunctionLibrary                                                            */
/*                                                                            */
/* ========================================================================== */


static inline double max(double x,double y)
{ return (x>y ? x : y); }

static inline double dabs(const interval x) {
  return interMath::sup(interMath::max(x,-x));
}

static void testAbs(double DD[6][6],const char* s) {
  for (int i=0;i<6;i++) for (int j=0;j<6;j++) {
      if (DD[i][j] < 0) {
	error::message("negative absolute value detected " );
	cout << s << " " << DD[i][j] << " " << i << " " << j << endl;
      }
    }
}

static void intervalToAbsDouble(const interval DDx[6][6],double DD[6][6])
{
  for (int i=0;i<6;i++) for (int j=0;j<6;j++) 	
			  DD[i][j]= dabs(DDx[i][j]);
}

static double taylorError(const domain& w,const double DD[6][6])
{
  interMath::up();
  double t=0.0;
  int i,j;
  for (i=0;i<6;i++) {
    if (w.getValue(i) < 0.0) { 
      error::message("negative width"); cout << w.getValue(i); }
  }
  for (i=0;i<6;i++) for (j=0;j<6;j++) {
      if (DD[i][j] < 0.0)  { error::message("negative DD in taylorError"); } 
    }
  for (i=0;i<6;i++) t = t + (w.getValue(i)*w.getValue(i))*DD[i][i];
  t = t/2.0;
  for (i=0;i<6;i++) for (j=i+1;j<6;j++)
		      t = t+ (w.getValue(i)*w.getValue(j))*DD[i][j];
  return t;
}

const Function legacy_simplex::unit(Function::unit);




/*implement x1 */
static int setZero(const domain& ,const domain& ,double DD[6][6])
{
  for (int i=0;i<6;i++) for (int j=0;j<6;j++) DD[i][j]=0.0;
  testAbs(DD,"setZero");
  return 1;
}
static lineInterval lineX1(const domain& x)
{
  static const interval one("1");
  lineInterval h(interval(x.getValue(0),x.getValue(0)));
  h.Df[0]=one;
  return h;
}
//primitiveA x1p(lineX1,setZero);
const Function legacy_simplex::x1 = Function::mk_raw(lineX1,setZero);


/*implement x2 */
static lineInterval lineX2(const domain& x)
{
  static const interval one("1");
  lineInterval h(interval(x.getValue(1),x.getValue(1)));
  h.Df[1]=one;
  return h;
}
//primitiveA x2p(lineX2,setZero);
const Function legacy_simplex::x2= Function::mk_raw(lineX2,setZero);

/*implement x3 */
static lineInterval lineX3(const domain& x)
{
  static const interval one("1");
  lineInterval h(interval(x.getValue(2),x.getValue(2)));
  h.Df[2]=one;
  return h;
}
//primitiveA x3p(lineX3,setZero);
const Function legacy_simplex::x3= Function::mk_raw(lineX3,setZero);

/*implement x4 */
static lineInterval lineX4(const domain& x)
{
  static const interval one("1");
  lineInterval h(interval(x.getValue(3),x.getValue(3)));
  h.Df[3]=one;
  return h;
}
//primitiveA x4p(lineX4,setZero);
const Function legacy_simplex::x4= Function::mk_raw(lineX4,setZero);

/*implement x5 */
static lineInterval lineX5(const domain& x)
{
  static const interval one("1");
  lineInterval h(interval(x.getValue(4),x.getValue(4)));
  h.Df[4]=one;
  return h;
}
//primitiveA x5p(lineX5,setZero);
const Function legacy_simplex::x5= Function::mk_raw(lineX5,setZero);

/*implement x6 */
static lineInterval lineX6(const domain& x)
{
  static const interval one("1");
  lineInterval h(interval(x.getValue(5),x.getValue(5)));
  h.Df[5]=one;
  return h;
}
//primitiveA x6p(lineX6,setZero);
const Function legacy_simplex::x6= Function::mk_raw(lineX6,setZero);


 Function legacy_simplex::rotate2(const Function& f) {
  Function g = Function::compose
  (f,
   legacy_simplex::x2,legacy_simplex::x3,legacy_simplex::x1,
   legacy_simplex::x5,legacy_simplex::x6,legacy_simplex::x4);
  return g;
}

 Function legacy_simplex::rotate3(const Function& f) {
  Function g = Function::compose
  (f,
   legacy_simplex::x3,legacy_simplex::x1,legacy_simplex::x2,
   legacy_simplex::x6,legacy_simplex::x4,legacy_simplex::x5);
  return g;
}

 Function legacy_simplex::rotate4(const Function& f) {
  Function g = Function::compose
    (f,
  legacy_simplex::x4  , legacy_simplex::x2, legacy_simplex::x6,
  legacy_simplex::x1 , legacy_simplex::x5,  legacy_simplex::x3);
  return g;
}

 Function legacy_simplex::rotate5(const Function& f) {
  Function g = Function::compose
    (f,
     legacy_simplex::x5  , legacy_simplex::x3, legacy_simplex::x4,
     legacy_simplex::x2 , legacy_simplex::x6, legacy_simplex::x1);
  return g;
}

 Function legacy_simplex::rotate6(const Function& f) {
  Function g = Function::compose
    (f,
     legacy_simplex::x6  , legacy_simplex::x1, legacy_simplex::x5,
     legacy_simplex::x3 , legacy_simplex::x4, legacy_simplex::x2);
  return g;
}


/*implement deltaLC */
const Function legacy_simplex::delta_y_LC = Function::mk_LC(wide::delta_y);

/*implement mdtau_y_LC */
const Function legacy_simplex::mdtau_y_LC= Function::mk_LC(wide::mdtau_y);

/*implement mdtau2_y_LC */
const Function legacy_simplex::mdtau2_y_LC= Function::mk_LC(wide::mdtau2uf_y);

/*implement y1 */
static lineInterval sqrt(lineInterval a)
{
  lineInterval temp;
  static const interval one("1");
  static const interval two("2");
  temp.f = interMath::sqrt(a.f);
  if (! interMath::boundedFromZero(temp.f)) { throw unstable::x; }
  interval rs = one/(two*temp.f);
  int i;
  for (i=0;i<6;i++) temp.Df[i]=rs*a.Df[i];
  return temp;
}

static lineInterval lineY1(const domain& x)
{
  static const interval one("1");
  lineInterval h(interval(x.getValue(0),x.getValue(0)));
  h.Df[0]=one;
  return sqrt(h);
}

static int setY1(const domain& x,const domain&,double DD[6][6])
{
  for (int i=0;i<6;i++) for (int j=0;j<6;j++) DD[i][j]=0.0;
  double x0 = x.getValue(0);
  if (x0<1.0e-8) return 0;
  interMath::down();
  double y = sqrt(x0);
  double y3 = 4.0*y*y*y;
  interMath::up();
  if (y3</*float.h*/DBL_EPSILON) return 0;
  DD[0][0]= 1.0/y3;
  testAbs(DD,"setY1");
  return 1;
}
//primitiveA Y1(lineY1,setY1);
const Function legacy_simplex::y1= Function::mk_raw(lineY1,setY1); // (&::Y1);

/*implement y2 */
static lineInterval lineY2(const domain& x)
{
  static const interval one("1");
  lineInterval h(interval(x.getValue(1),x.getValue(1)));
  h.Df[1]=one;
  return sqrt(h);
}
static int setY2(const domain& x,const domain&,double DD[6][6])
{
  for (int i=0;i<6;i++) for (int j=0;j<6;j++) DD[i][j]=0.0;
  double x0 = x.getValue(1);
  if (x0<1.0e-8) return 0;
  interMath::down();
  double y = sqrt(x0);
  double y3 = 4.0*y*y*y;
  if (y3</*float.h*/DBL_EPSILON) return 0;
  interMath::up();
  DD[1][1]= 1.0/y3;
  testAbs(DD,"setY2");
  return 1;
}
//primitiveA Y2(lineY2,setY2);
const Function legacy_simplex::y2= Function::mk_raw(lineY2,setY2); //(&::Y2);
 
/*implement y3 */
static lineInterval lineY3(const domain& x)
{
  static const interval one("1");
  lineInterval h(interval(x.getValue(2),x.getValue(2)));
  h.Df[2]=one;
  return sqrt(h);
}
static int setY3(const domain& x,const domain&,double DD[6][6])
{
  for (int i=0;i<6;i++) for (int j=0;j<6;j++) DD[i][j]=0.0;
  double x0 = x.getValue(2);
  if (x0<1.0e-8) return 0;
  interMath::down();
  double y = sqrt(x0);
  double y3 = 4.0*y*y*y;
  if (y3</*float.h*/DBL_EPSILON) return 0;
  interMath::up();
  DD[2][2]= 1.0/y3;
  testAbs(DD,"setY3");
  return 1;
}
//primitiveA Y3(lineY3,setY3);
const Function legacy_simplex::y3= Function::mk_raw(lineY3,setY3);//(&::Y3);

/*implement y4 */
static lineInterval lineY4(const domain& x)
{
  static const interval one("1");
  lineInterval h(interval(x.getValue(3),x.getValue(3)));
  h.Df[3]=one;
  return sqrt(h);
}
static int setY4(const domain& x,const domain&,double DD[6][6])
{
  for (int i=0;i<6;i++) for (int j=0;j<6;j++) DD[i][j]=0.0;
  double x0 = x.getValue(3);
  if (x0<1.0e-8) return 0;
  interMath::down();
  double y = sqrt(x0);
  double y3 = 4.0*y*y*y;
  if (y3</*float.h*/DBL_EPSILON) return 0;
  interMath::up();
  DD[3][3]= 1.0/y3;
  testAbs(DD,"setY4");
  return 1;
}
//primitiveA Y4(lineY4,setY4);
const Function legacy_simplex::y4= Function::mk_raw(lineY4,setY4);//(&::Y4);

/*implement y5 */
static lineInterval lineY5(const domain& x)
{
  static const interval one("1");
  lineInterval h(interval(x.getValue(4),x.getValue(4)));
  h.Df[4]=one;
  return sqrt(h);
}
static int setY5(const domain& x,const domain&,double DD[6][6])
{
  for (int i=0;i<6;i++) for (int j=0;j<6;j++) DD[i][j]=0.0;
  double x0 = x.getValue(4);
  if (x0<1.0e-8) return 0;
  interMath::down();
  double y = sqrt(x0);
  double y3 = 4.0*y*y*y;
  if (y3</*float.h*/DBL_EPSILON) return 0;
  interMath::up();
  DD[4][4]= 1.0/y3;
  testAbs(DD,"setY5");
  return 1;
}
//primitiveA Y5(lineY5,setY5);
const Function legacy_simplex::y5= Function::mk_raw(lineY5,setY5);//(&::Y5);

/*implement y6 */
static lineInterval lineY6(const domain& x)
{
  static const interval one("1");
  lineInterval h(interval(x.getValue(5),x.getValue(5)));
  h.Df[5]=one;
  return sqrt(h);
}
static int setY6(const domain& x,const domain&,double DD[6][6])
{
  for (int i=0;i<6;i++) for (int j=0;j<6;j++) DD[i][j]=0.0;
  double x0 = x.getValue(5);
  if (x0<1.0e-8) return 0;
  interMath::down();
  double y = sqrt(x0);
  double y3 = 4.0*y*y*y;
  if (y3</*float.h*/DBL_EPSILON) return 0;
  interMath::up();
  DD[5][5]= 1.0/y3;
  testAbs(DD,"setY6");
  return 1;
}
//primitiveA Y6(lineY6,setY6);
const Function legacy_simplex::y6= Function::mk_raw(lineY6,setY6);//(&::Y6);

/*implement x1*x2 */
static lineInterval lineX1X2(const domain& x)
{
  //static const interval one("1");
  lineInterval h(interval(x.getValue(0),x.getValue(0)) * 
		 interval(x.getValue(1),x.getValue(1)));
  h.Df[0]= interval(x.getValue(1),x.getValue(1));
  h.Df[1]= interval(x.getValue(0),x.getValue(0));
  return h;
}
static int setX1X2DD(const domain& ,const domain& ,double DD[6][6])
{
  for (int i=0;i<6;i++) for (int j=0;j<6;j++) DD[i][j]=0.0;
  DD[1][0]=1.0;
  DD[0][1]=1.0;
  testAbs(DD,"setX1X2DD");
  return 1;
}
//static primitiveA x1x2Prim(lineX1X2,setX1X2DD);
static const Function x1x2= Function::mk_raw(lineX1X2,setX1X2DD);// (&::x1x2Prim);


/*implement delta */
static int setAbsDelta(const domain& x,const domain& z,double DD[6][6])
{
  double X[6],Z[6];
  interval DDh[6][6];
  int i;
  for (i=0;i<6;i++) { X[i]=x.getValue(i); Z[i]=z.getValue(i); }
  secondDerive::setDelta(X,Z,DDh);
  intervalToAbsDouble(DDh,DD);
  testAbs(DD,"setAbsDelta");
  return 1;
}
//primitiveA deltaPrimitive(linearization::delta,setAbsDelta);
const Function legacy_simplex::delta_x= Function::mk_raw(linearization::delta,setAbsDelta);// (&::deltaPrimitive);


/*implement vol_x */ 
static interval one("1");
static interval twelve("12");
static Function f_twelth = legacy_simplex::y1 * (one/ twelve);
//primitiveC volXPrimitive
const Function legacy_simplex::vol_x = Function::compose
 (f_twelth,
  legacy_simplex::delta_x  , legacy_simplex::unit, legacy_simplex::unit,
  legacy_simplex::unit  , legacy_simplex::unit, legacy_simplex::unit);
//const Function legacy_simplex::vol_x(&::volXPrimitive);


/*implement chi126 */
static int setAbsChi126(const domain& x,const domain& z,double DD[6][6])
{
  double X[6],Z[6];
  interval DDh[6][6];
  int i;
  for (i=0;i<6;i++) { X[i]=x.getValue(i); Z[i]=z.getValue(i); }
  secondDerive::setChi126(X,Z,DDh);
  intervalToAbsDouble(DDh,DD);
  testAbs(DD,"setAbsChi126");
  return 1;
}
//primitiveA chi126Primitive(linearization::chi126,setAbsChi126);
static const Function chi126= Function::mk_raw(linearization::chi126,setAbsChi126);//(&::chi126Primitive);


/*implement rad2*/
static int setAbsRad2(const domain& x, const domain& z, double DD[6][6]) {
  double  X[6],Z[6];
  int i;
  double DD1[6][6], DD2[6][6];
  for (i=0;i<6;i++) { X[i]=x.getValue(i); Z[i]=z.getValue(i); }
  int r1 = secondDerive::setAbsEta2_x_126(X,Z,DD1);
  int r2 = secondDerive::setChi2over4uDelta(X,Z,DD2);
  interMath::up();
  for (int i=0;i<6;i++) for (int j=0;j<6;j++) { DD[i][j] = DD1[i][j] + DD2[i][j]; }
  if (r1+r2) { testAbs(DD,"setAbsRad2"); }
  return r1+r2;
}
//primitiveA rad2Primitive(linearization::rad2,setAbsRad2);
const Function legacy_simplex::rad2= Function::mk_raw(linearization::rad2,setAbsRad2);//(&::rad2Primitive);



/*implement delta_x4*/
static int setAbsDeltaX4(const domain& x,const domain& z,double DDf[6][6]) {
  for (int i=0;i<6;i++) for (int j=0;j<6;j++) { DDf[i][j]= 2.0; }
  // all second partials are pm 0,1,2.  
}
//primitiveA deltax4Primitive(linearization::delta_x4,setAbsDeltaX4);
const Function legacy_simplex::delta_x4= Function::mk_raw(linearization::delta_x4,setAbsDeltaX4);//(&::deltax4Primitive);


/*implement dih1*/
static int setAbsDihedral(const domain& x,const domain& z,double DD[6][6])
{
  double X[6],Z[6];
  int i;
  for (i=0;i<6;i++) { X[i]=x.getValue(i); Z[i]=z.getValue(i); }
  int r = secondDerive::setAbsDihedral(X,Z,DD);
  if (r) { testAbs(DD,"setAbsDihedral"); }
  return r;
}
const Function legacy_simplex::dih= Function::mk_raw(linearization::dih,setAbsDihedral);



const Function legacy_simplex::dih2 = legacy_simplex::rotate2(legacy_simplex::dih);
const Function legacy_simplex::dih3 = legacy_simplex::rotate3(legacy_simplex::dih);
const Function legacy_simplex::dih4 = legacy_simplex::rotate4(legacy_simplex::dih);
const Function legacy_simplex::dih5 = legacy_simplex::rotate5(legacy_simplex::dih);
const Function legacy_simplex::dih6 = legacy_simplex::rotate6(legacy_simplex::dih);


/*implement dih2*/
/*
static int setAbsDih2(const domain& x,const domain& z,double DD[6][6])
{
  double X[6],Z[6];
  int i;
  for (i=0;i<6;i++) { X[i]=x.getValue(i); Z[i]=z.getValue(i); }
  interval s,Ds[6],DDs[6][6];
  int outcome = secondDerive::setSqrtDelta(X,Z,s,Ds,DDs);
  if (!outcome) return outcome;
  interval h,Dh[6],DDh[6][6];
  outcome = secondDerive::setDih2(X,Z,s,Ds,DDs,h,Dh,DDh);
  if (!outcome) return outcome;
  intervalToAbsDouble(DDh,DD);
  testAbs(DD,"setAbsDih2");
  return outcome;
}
primitiveA dih2Primitive(linearization::dih2,setAbsDih2);
const Function legacy_simplex::dih2= Function::mk_raw(&::dih2Primitive);
*/

/*implement dih3*/
/*
static int setDih3(const domain& x,const domain& z,double DD[6][6])
{
  double X[6],Z[6];
  int i;
  for (i=0;i<6;i++) { X[i]=x.getValue(i); Z[i]=z.getValue(i); }
  interval s,Ds[6],DDs[6][6];
  int outcome = secondDerive::setSqrtDelta(X,Z,s,Ds,DDs);
  if (!outcome) return outcome;
  interval h,Dh[6],DDh[6][6];
  outcome = secondDerive::setDih3(X,Z,s,Ds,DDs,h,Dh,DDh);
  if (!outcome) return outcome;
  intervalToAbsDouble(DDh,DD);
  return outcome;
}
primitiveA dih3Primitive(linearization::dih3,setDih3);
const Function legacy_simplex::dih3= Function::mk_raw(&::dih3Primitive);
*/

/*implement dih4 : |- dih4_y y1 y2 y3 y4 y5 y6 = dih_y y4 y2 y6 y1 y5 y3 */ 
/*
primitiveC dih4Primitive
(&legacy_simplex::dih,
  &legacy_simplex::x4  , &legacy_simplex::x2, &legacy_simplex::x6,
  &legacy_simplex::x1 , &legacy_simplex::x5, &legacy_simplex::x3);
const Function legacy_simplex::dih4(&::dih4Primitive);
*/

/*implement dih5 : |- dih5_y y1 y2 y3 y4 y5 y6 = dih_y y5 y1 y6 y2 y4 y3 */
/*
primitiveC dih5Primitive
(&legacy_simplex::dih,
  &legacy_simplex::x5  , &legacy_simplex::x1, &legacy_simplex::x6,
  &legacy_simplex::x2 , &legacy_simplex::x4, &legacy_simplex::x3);
const Function legacy_simplex::dih5(&::dih5Primitive);
*/

/*implement dih6 : |- dih6_y y1 y2 y3 y4 y5 y6 = dih_y y6 y1 y5 y3 y4 y2 */
/*
primitiveC dih6Primitive
(&legacy_simplex::dih,
  &legacy_simplex::x6  , &legacy_simplex::x1, &legacy_simplex::x5,
  &legacy_simplex::x3 , &legacy_simplex::x4, &legacy_simplex::x2);
const Function legacy_simplex::dih6(&::dih6Primitive);
*/

/*implement rhazim*/
static int setRhazim(const domain& x,const domain& z,double DD[6][6])
{
  double X[6],Z[6];
  int i;
  for (i=0;i<6;i++) { X[i]=x.getValue(i); Z[i]=z.getValue(i); }
  interval s,Ds[6],DDs[6][6];
  int outcome = secondDerive::setSqrtDelta(X,Z,s,Ds,DDs);
  if (!outcome) return outcome;
  interval h,Dh[6],DDh[6][6];
  outcome = secondDerive::setDihedral(X,Z,s,Ds,DDs,h,Dh,DDh);
  if (!outcome) return outcome;
  interval DDa[6][6];
  outcome = secondDerive::setRhazim(X[0],Z[0],h,Dh,DDh,DDa);
  intervalToAbsDouble(DDa,DD);
  return outcome;
}
//primitiveA rhazimPrimitive(linearization::rhazim,setRhazim);
const Function legacy_simplex::rhazim_x= Function::mk_raw(linearization::rhazim,setRhazim);//(&::rhazimPrimitive);

/* secondary implementation of rhazim_x*/
/*
functional1_rho:
`!y. rho y = y * (const1/(&2 * h0 - &2)) + (&1 + const1/(&1 - h0))`,
 */
//univariate i_rho = L::i_pow1 * (L::const1/(L::two * L::h0 - L::two)) + 
//  L::i_pow0 * (L::one + L::const1/(L::one - L::h0));
/*
univariate i_rho_sqrt = L::i_sqrt * (L::const1/(L::two * L::h0 - L::two)) + 
  L::i_pow0 * (L::one + L::const1/(L::one - L::h0));

const Function Lib::rhazim_x = 
  Function::uni_slot(::i_rho_sqrt,0) * Lib::dih_x;
*/



/*implement rhazim2 ... */
const Function legacy_simplex::rhazim2_x = 
  legacy_simplex::rotate2(legacy_simplex::rhazim_x);
const Function legacy_simplex::rhazim3_x = 
  legacy_simplex::rotate3(legacy_simplex::rhazim_x);

/*
static int setRhazim2(const domain& x,const domain& z,double DD[6][6])
{
  double X[6],Z[6];
  int i;
  for (i=0;i<6;i++) { X[i]=x.getValue(i); Z[i]=z.getValue(i); }
  interval s,Ds[6],DDs[6][6];
  int outcome = secondDerive::setSqrtDelta(X,Z,s,Ds,DDs);
  if (!outcome) return outcome;
  interval h,Dh[6],DDh[6][6];
  outcome = secondDerive::setDih2(X,Z,s,Ds,DDs,h,Dh,DDh);
  if (!outcome) return outcome;
  interval DDa[6][6];
  outcome = secondDerive::setRhazim2(X[1],Z[1],h,Dh,DDh,DDa);
  intervalToAbsDouble(DDa,DD);
  return outcome;
}
primitiveA rhazim2Primitive(linearization::rhazim2,setRhazim2);
const Function legacy_simplex::rhazim2= Function::mk_raw(&::rhazim2Primitive);
*/

/*implement azim3*/
/*
static int setRhazim3(const domain& x,const domain& z,double DD[6][6])
{
  double X[6],Z[6];
  int i;
  for (i=0;i<6;i++) { X[i]=x.getValue(i); Z[i]=z.getValue(i); }
  interval s,Ds[6],DDs[6][6];
  int outcome = secondDerive::setSqrtDelta(X,Z,s,Ds,DDs);
  if (!outcome) return outcome;
  interval h,Dh[6],DDh[6][6];
  outcome = secondDerive::setDih3(X,Z,s,Ds,DDs,h,Dh,DDh);
  if (!outcome) return outcome;
  interval DDa[6][6];
  outcome = secondDerive::setRhazim3(X[2],Z[2],h,Dh,DDh,DDa);
  intervalToAbsDouble(DDa,DD);
  return outcome;
}
primitiveA rhazim3Primitive(linearization::rhazim3,setRhazim3);
const Function legacy_simplex::rhazim3= Function::mk_raw(&::rhazim3Primitive);
*/

/*implement sol*/
static int setSol(const domain& x,const domain& z,double DD[6][6])
{
  double X[6],Z[6];
  int i,j;
  for (i=0;i<6;i++) { X[i]=x.getValue(i); Z[i]=z.getValue(i); }
  interval s,Ds[6],DDs[6][6],DDx[6][6];
  if (!(secondDerive::setSqrtDelta(X,Z,s,Ds,DDs))) return 0;
  if (!(secondDerive::setSolid(X,Z,s,Ds,DDs,DDx))) return 0;
  for (i=0;i<6;i++) for (j=i;j<6;j++)
		      DD[i][j]=dabs(DDx[i][j]);
  for (i=0;i<6;i++) for (j=0;j<i;j++) DD[i][j]=DD[j][i];
  return 1;
}
//primitiveA solPrimitive(linearization::solid,setSol);
const Function legacy_simplex::sol= Function::mk_raw(linearization::solid,setSol);//(&::solPrimitive);

static int copy(double DD[6][6],const double sec[6][6])
{
  for (int i=0;i<6;i++) for (int j=0;j<6;j++)
			  DD[i][j]=sec[i][j];
  return 1;
}

/* implement halfbump_x (univariate) */
/*
 |- !x. &0 <= x
         ==> halfbump_x x =
             --(&4398119 / &2376200) +
             &17500 / &11881 * sqrt x - &31250 / &106929 * x
*/
static interval a0("-4398119");
static interval b0("2376200");
static interval a1("17500");
static interval b1("11881");
static interval a2("-31250");
static interval b2("106929");
univariate i_halfbump_x = univariate::i_pow0 * (a0 / b0) +
  univariate::i_sqrt * (a1 / b1) + univariate::i_pow1 * (a2 / b2);
//static primitive_univariate i_halfbump1P(::i_halfbump_x,0);
//static primitive_univariate i_halfbump4P(::i_halfbump_x,3);
const Function legacy_simplex::halfbump_x1 = 
  Function::uni_slot(::i_halfbump_x,0);//(&::i_halfbump1P);
const Function legacy_simplex::halfbump_x4 = 
  Function::uni_slot(::i_halfbump_x,3);//(&::i_halfbump4P);

/* implement marchalQuartic (univariate) */
// marchalQuartic[Sqrt[x]/2] = 
/* deprecated: 
static interval m0("-8.3439434337479413233");
static interval m1("29.738910202367943669");
static interval m2("-24.647762183814337061");
static interval m3("7.7264705379397797225");
static interval m4("-0.83466203370305222185");
univariate i_marchalQ = univariate::i_pow0 * m0 +
  univariate::i_sqrt * m1 +
  univariate::i_pow1 * m2 +
  univariate::i_pow3h2 * m3 +
  univariate::i_pow2 * m4;
static primitive_univariate i_marchalQprim(::i_marchalQ,0);
static Function marchalQ(&::i_marchalQprim);
const Function legacy_simplex::marchalDih = Function::product(marchalQ,legacy_simplex::dih);
const Function legacy_simplex::marchalDih2 = legacy_simplex::rotate2(legacy_simplex::marchalDih);
const Function legacy_simplex::marchalDih3 = legacy_simplex::rotate3(legacy_simplex::marchalDih);
const Function legacy_simplex::marchalDih4 = legacy_simplex::rotate4(legacy_simplex::marchalDih);
const Function legacy_simplex::marchalDih5 = legacy_simplex::rotate5(legacy_simplex::marchalDih);
const Function legacy_simplex::marchalDih6 = legacy_simplex::rotate6(legacy_simplex::marchalDih);
*/


/* implement gchi (univariate) */ 
// gchi (sqrt x) = &4 * mm1 / pi -(&504 * mm2 / pi)/ &13 +(&200 * (sqrt x) * mm2 /pi)/ &13
static interval i_gchi_c0("0.974990367692870754241952463595");
static interval i_gchi_c1("0.124456752559607807811255454313");
univariate i_gchi = univariate::i_sqrt* i_gchi_c1 + univariate::i_pow0 * i_gchi_c0;
/*implement gchi1_x x1 x2 x3 x4 x5 x6 = gchi (sqrt x1) * dih_x x1 x2 x3 x4 x5 x6; */
//static primitive_univariate i_gchi1P(::i_gchi, 0 );
static Function i_gchi1 = Function::uni_slot(::i_gchi, 0 );//(&::i_gchi1P);


const Function legacy_simplex::gchi1_x = Function::compose
(::x1x2,
  ::i_gchi1  , legacy_simplex::dih, legacy_simplex::unit,
  legacy_simplex::unit , legacy_simplex::unit, legacy_simplex::unit);
//const Function legacy_simplex::gchi1_x(&::gchi1XPrim);

const Function legacy_simplex::gchi2_x = legacy_simplex::rotate2(legacy_simplex::gchi1_x);
const Function legacy_simplex::gchi3_x = legacy_simplex::rotate3(legacy_simplex::gchi1_x);
const Function legacy_simplex::gchi4_x = legacy_simplex::rotate4(legacy_simplex::gchi1_x);
const Function legacy_simplex::gchi5_x = legacy_simplex::rotate5(legacy_simplex::gchi1_x);
const Function legacy_simplex::gchi6_x = legacy_simplex::rotate6(legacy_simplex::gchi1_x);

/* ========================================================================== */
/*                                                                            */
/*   Section:legacy_simplex local namespace                                            */
/*                                                                            */
/* ========================================================================== */


namespace local {

  /*
 Function operator*(const Function& f,const Function& g) {
   return Function::product(f,g);
 }
  */

  static const Function operator*(const Function& t,int j) {
    return t * interval(j * 1.0, j * 1.0);
  }

  static const Function operator*(int j,const Function& t) {
    return t * interval(j * 1.0, j * 1.0);
  }

  /*
  static const Function operator-
  (const Function& u,const Function& t) {
    static const interval mone("-1");
    return u + t * mone;
  }
  */

  Function uni(const univariate& u,const Function& f) {
   return Function::uni_compose(u,f);
  };

  Function y1 = legacy_simplex::y1;
  Function y2 = legacy_simplex::y2;
  Function y3 = legacy_simplex::y3;
  Function y4 = legacy_simplex::y4;

  Function x1 = legacy_simplex::x1;
  Function x2 = legacy_simplex::x2;
  Function x3 = legacy_simplex::x3;
  Function x4 = legacy_simplex::x4;
  Function x5 = legacy_simplex::x5;
  Function x6 = legacy_simplex::x6;

  Function delta = legacy_simplex::delta_x;
  Function delta_x4 = legacy_simplex::delta_x4;
  Function dih = legacy_simplex::dih;
  Function unit = legacy_simplex::unit;

  static const univariate i_inv = univariate::i_inv;
  static const univariate i_pow2 = univariate::i_pow2;
  static const univariate i_matan = univariate::i_matan;
  static const univariate i_sqrt = univariate::i_sqrt;
  static const univariate i_acos = univariate::i_acos;
  static const univariate i_sin = univariate::i_sin;
  static const univariate i_asin = univariate::i_asin;

  static const interval sqrt3("1.7320508075688772935");
  static const interval sqrt2("1.4142135623730950488");
  static const interval quarter("0.25");
  static const interval half("0.5");
  static const interval two ("2");
  static const interval three ("3");
  static const interval four ("4");
  static const interval eight ("8");
  static const interval sixteen ("16");
  static const interval mone("-1");
  static const interval pi("3.1415926535897932385");
  static const interval const1 ("0.175479656091821810");
  static const interval sol0("0.5512855984325308079421");
  static const interval mm1("1.01208086842065466") ;
  static const interval mm2("0.0254145072695089280");

  static const Function two_unit = unit * two;



   };

/*implement ups_126*/
namespace local {
static int setAbsUps(const domain& x,const domain& z,double DD[6][6])
{
  double xa[6],za[6];
  for (int i=0;i<6;i++) {
    xa[i] = x.getValue(i);
    za[i] = z.getValue(i);
  }
  interval DDi[6][6];
  secondDerive::setU126(xa,za,DDi);
  intervalToAbsDouble(DDi,DD);
  return 1;
}
  //primitiveA upsPrimitive(linearization::ups_126,setAbsUps);
  static const Function ups_126= Function::mk_raw(linearization::ups_126,setAbsUps);//(&upsPrimitive);
};

/*implement eta2_126*/
static int setEta2_126(const domain& x,const domain& z,double DD[6][6])
{
  double xa[6],za[6];
  for (int i=0;i<6;i++) {
    xa[i] = x.getValue(i);
    za[i] = z.getValue(i);
  }
  secondDerive::setAbsEta2_x_126(xa,za,DD);
  return 1;
}
//primitiveA eta2Primitive(linearization::eta2_126,setEta2_126);
const Function legacy_simplex::eta2_126= Function::mk_raw(linearization::eta2_126,setEta2_126);//(&::eta2Primitive);

/*implement ups_135*/
static Function ups_135 = Function::compose
(local::ups_126,
 legacy_simplex::x1,legacy_simplex::x3,legacy_simplex::unit,
 legacy_simplex::unit,legacy_simplex::unit,legacy_simplex::x5);
//const Function ups_135(&::ups_135_Primitive);

/*implement eta2_135*/
const Function legacy_simplex:: eta2_135 = Function::compose
(legacy_simplex::eta2_126,
 legacy_simplex::x1,legacy_simplex::x3,legacy_simplex::unit,
 legacy_simplex::unit,legacy_simplex::unit,legacy_simplex::x5);
//const Function legacy_simplex::eta2_135(&::eta2_135_Primitive);

/*implement eta2_234*/
const Function legacy_simplex:: eta2_234 = Function::compose
(legacy_simplex::eta2_126,
 legacy_simplex::x2,legacy_simplex::x3,legacy_simplex::unit,
 legacy_simplex::unit,legacy_simplex::unit,legacy_simplex::x4);
//const Function legacy_simplex::eta2_234(&::eta2_234_Primitive);

/*implement eta2_456*/
const Function legacy_simplex:: eta2_456 = Function::compose
(legacy_simplex::eta2_126,
 legacy_simplex::x4,legacy_simplex::x5,legacy_simplex::unit,
 legacy_simplex::unit,legacy_simplex::unit,legacy_simplex::x6);
//const Function legacy_simplex::eta2_456(&::eta2_456_Primitive);

/*implement acs_sqrt_x1_d4 */
const Function legacy_simplex::acs_sqrt_x1_d4 = 
  Function::uni_compose(univariate::i_acos,
			      legacy_simplex::y1 * local::quarter);

/*implement acs_sqrt_x2_d4 */
const Function legacy_simplex::acs_sqrt_x2_d4 = 
  legacy_simplex::rotate2(legacy_simplex::acs_sqrt_x1_d4);


/*implement asn797 */
namespace local {
  //   `k * asn (cos (#0.797) * sin (pi / k))`;; 
  static const interval cos0797("0.69885563921392235500");
  static const Function sinpik =  uni(i_sin, uni(i_inv,x1) * pi);
  static const Function asn797k =  x1 * uni(i_asin,sinpik * cos0797);
}

const Function legacy_simplex::asn797k = local::asn797k;

/*implement asnFnhk */
// k * asn (( h * sqrt3 / #4.0 + sqrt(&1 - (h/ &2) pow 2)/ &2) * sin (pi/ k))`;;
// sinpik as above.
// x1 = h, x2 = k.
namespace local {
static const Function sinpiR2 = legacy_simplex::rotate2(sinpik);
static const Function asnFh = 
  x1 * (sqrt3 / four) +
  (uni (i_sqrt,unit + 
  (uni (i_pow2,x1 * half)) * mone))*half;
static const Function asnFnhka = 
  uni(univariate::i_asin,asnFh * sinpiR2);
static const Function asnFnhk = x2 * asnFnhka;
}

const Function legacy_simplex::asnFnhk = local::asnFnhk;

/* implement lfun_y1 */
/*
`lfun_y1 (y1:real) (y2:real) (y3:real) 
  (y4:real) (y5:real) (y6:real) =  lfun y1`
`lfun h =  (h0 - h)/(h0 - &1)`
 */
namespace local {
  static const interval h0 ("1.26");
  static const Function lfun_y1 = 
    (unit * h0 + x1 * mone) * (one /  (h0 - one));


  static const Function lfun_sqrtx1_div2 = 
    (unit * h0 + y1 * mone * half) * (one / (h0 -one));

  const Function ldih_x = lfun_sqrtx1_div2 * dih;


};

const Function legacy_simplex::lfun_y1 = local::lfun_y1;


const Function legacy_simplex::ldih_x = local::ldih_x;
const Function legacy_simplex::ldih2_x = legacy_simplex::rotate2 (local::ldih_x);
const Function legacy_simplex::ldih3_x = legacy_simplex::rotate3 (local::ldih_x);
const Function legacy_simplex::ldih5_x = legacy_simplex::rotate5 (local::ldih_x);
const Function legacy_simplex::ldih6_x = legacy_simplex::rotate6 (local::ldih_x);

const Function legacy_simplex::lfun_sqrtx1_div2 = local::lfun_sqrtx1_div2;


/*implement norm2hh_x */
//(y1 - hminus - hplus)^2 + (y2 - 2)^2 + (y3 - 2)^2 + 
// (y4 - 2)^2 + (y5 - 2)^2 + (y6 - 2)^2;
static interval mfour("-4");
//static interval four("4");
static interval n0("-5.114308844180643");
static interval n1("26.539038738416085");
static univariate ym2sq = 
  univariate::i_pow1 + univariate::i_sqrt * "-4.0";
//static primitive_univariate ym2sqP(ym2sq,0);
static univariate ymmsq = 
  univariate::i_pow1 + univariate::i_sqrt * n0 + univariate::i_pow0 * n1;
//static primitive_univariate ymmsqP(ymmsq,0);
static Function t_ym2sq = Function::uni_slot(ym2sq,0);//(&ym2sqP);
static Function t_ymmsq = Function::uni_slot(ymmsq,0);//
const Function legacy_simplex::norm2hh_x =
  t_ymmsq + legacy_simplex::rotate2(t_ym2sq) +
   legacy_simplex::rotate3(t_ym2sq) +
  legacy_simplex::rotate4(t_ym2sq) +
  legacy_simplex::rotate5(t_ym2sq) +
  legacy_simplex::rotate6(t_ym2sq);
 


namespace local { 
  static const Function x1cube = x1 * x1 * x1;
}
const Function legacy_simplex::x1cube = local::x1cube;

namespace local { 
  static const Function x1square = x1  * x1;
}
const Function legacy_simplex::x1square = local::x1square;


/*implement arclength_x_123*/
//ArcCos[(x1 + x2 - x3)/(Sqrt[4 x1 x2])].

namespace local {
  static Function al_num = x1 + x2 + x3 * mone;
  static Function al_den = 
    uni(i_inv,uni(i_sqrt,(x1 * x2) * four));
  const Function arclength_x_123 = uni(i_acos,al_num * al_den);

 Function rotate234(const Function& f) {
  Function g = Function::compose
    (f,
     legacy_simplex::x2  , legacy_simplex::x3, legacy_simplex::x4,
     legacy_simplex::unit , legacy_simplex::unit, legacy_simplex::unit);
  return g;
 }

 Function rotate126(const Function& f) {
  Function g = Function::compose
    (f,
     legacy_simplex::x1  , legacy_simplex::x2, legacy_simplex::x6,
     legacy_simplex::unit , legacy_simplex::unit, legacy_simplex::unit);
  return g;
 }


 Function rotate345(const Function& f) {
  Function g = Function::compose
    (f,
     legacy_simplex::x3  , legacy_simplex::x4, legacy_simplex::x5,
     legacy_simplex::unit , legacy_simplex::unit, legacy_simplex::unit);
  return g;
 }


  const Function arclength_x_234 = rotate234(arclength_x_123);

  const Function arclength_x_126 = rotate126(arclength_x_123);

  const Function arclength_x_345 = rotate345(arclength_x_123);


};

const Function legacy_simplex::arclength_x_123 = local::arclength_x_123;

const Function legacy_simplex::arclength_x_234 = local::arclength_x_234;

const Function legacy_simplex::arclength_x_126 = local::arclength_x_126;

const Function legacy_simplex::arclength_x_345 = local::arclength_x_345;

/*
`sol_euler_x_div_sqrtdelta x1 x2 x3 x4 x5 x6 = 
  (let a = sqrt(x1*x2*x3) + sqrt( x1)*(x2 + x3 - x4)/ &2 + 
     sqrt(x2)*(x1 + x3 - x5)/ &2 + sqrt(x3)*(x1 + x2 - x6)/ &2 in
     (matan ((delta_x x1 x2 x3 x4 x5 x6)/(&4 * a pow 2 )))/( a))`;;
 */

/* implement sol_euler_x_div_sqrtdelta */  

namespace local {

  static const Function 
   a (y1 * y2 * y3 + y1 * (x2 + x3 + x4 * mone)* half +
     y2 * (x1 + x3 + x5* mone) * half + y3 * (x1 + x2 + x6* mone) * half);
  static const Function sol_euler_x_div_sqrtdelta = 
   (uni(i_matan, (delta * uni(i_inv,a * a * four ) )) * uni(i_inv,a));
};

const Function legacy_simplex::sol_euler_x_div_sqrtdelta = 
local::sol_euler_x_div_sqrtdelta;

const Function legacy_simplex::sol_euler246_x_div_sqrtdelta =
 legacy_simplex::rotate4(legacy_simplex::sol_euler_x_div_sqrtdelta);

const Function legacy_simplex::sol_euler345_x_div_sqrtdelta = 
legacy_simplex::rotate5(legacy_simplex::sol_euler_x_div_sqrtdelta);

const Function legacy_simplex::sol_euler156_x_div_sqrtdelta = 
legacy_simplex::rotate6(legacy_simplex::sol_euler_x_div_sqrtdelta);

/*
 `dih_x_div_sqrtdelta_posbranch x1 x2 x3 x4 x5 x6 =
  ( let d_x4 = delta_x4 x1 x2 x3 x4 x5 x6 in
          let d = delta_x x1 x2 x3 x4 x5 x6 in
	     (sqrt(&4 * x1) / d_x4) * matan((&4 * x1 * d)/(d_x4 pow 2)))`;;
 */

namespace local {
  static const Function dih_x_div_sqrtdelta_posbranch =
    (y1 * uni(i_inv,delta_x4) * two) *
    uni(i_matan,(x1 * delta *  uni(i_inv,uni(i_pow2,delta_x4)) * four));
};

const Function legacy_simplex::dih_x_div_sqrtdelta_posbranch = 
  local::dih_x_div_sqrtdelta_posbranch;

const Function legacy_simplex::dih2_x_div_sqrtdelta_posbranch = 
  legacy_simplex::rotate2 (legacy_simplex::dih_x_div_sqrtdelta_posbranch);

const Function legacy_simplex::dih3_x_div_sqrtdelta_posbranch = 
  legacy_simplex::rotate3 (legacy_simplex::dih_x_div_sqrtdelta_posbranch);

const Function legacy_simplex::dih4_x_div_sqrtdelta_posbranch = 
  legacy_simplex::rotate4 (legacy_simplex::dih_x_div_sqrtdelta_posbranch);

const Function legacy_simplex::dih5_x_div_sqrtdelta_posbranch = 
  legacy_simplex::rotate5 (legacy_simplex::dih_x_div_sqrtdelta_posbranch);

const Function legacy_simplex::dih6_x_div_sqrtdelta_posbranch = 
  legacy_simplex::rotate6 (legacy_simplex::dih_x_div_sqrtdelta_posbranch);



/*
`ldih_x_div_sqrtdelta_posbranch x1 x2 x3 x4 x5 x6 =
   lfun(sqrt(x1) / &2) * dih_x_div_sqrtdelta_posbranch x1 x2 x3 x4 x5 x6`;;

` !h. lfun h = (h0 - h) / (h0 - &1)`;;
 */

namespace local {
  static const Function ldih_x_div_sqrtdelta_posbranch =
    ( ( unit * h0 + y1 * (mone/ two)) * (one / (h0 - one))) * dih_x_div_sqrtdelta_posbranch;

  static const Function sqndelta = 
    uni(univariate::i_sqn,delta);

  static const Function sqrtdelta = 
    uni(univariate::i_sqrt,delta);


  static const Function ldih_x_n = sqndelta * ldih_x_div_sqrtdelta_posbranch;

}

const Function legacy_simplex::ldih_x_div_sqrtdelta_posbranch = 
  local::ldih_x_div_sqrtdelta_posbranch;

const Function legacy_simplex::ldih2_x_div_sqrtdelta_posbranch = 
  legacy_simplex::rotate2 (legacy_simplex::ldih_x_div_sqrtdelta_posbranch);

const Function legacy_simplex::ldih3_x_div_sqrtdelta_posbranch = 
  legacy_simplex::rotate3 (legacy_simplex::ldih_x_div_sqrtdelta_posbranch);

const Function legacy_simplex::ldih4_x_div_sqrtdelta_posbranch = 
  legacy_simplex::rotate4 (legacy_simplex::ldih_x_div_sqrtdelta_posbranch);

const Function legacy_simplex::ldih5_x_div_sqrtdelta_posbranch = 
  legacy_simplex::rotate5 (legacy_simplex::ldih_x_div_sqrtdelta_posbranch);

const Function legacy_simplex::ldih6_x_div_sqrtdelta_posbranch = 
  legacy_simplex::rotate6 (legacy_simplex::ldih_x_div_sqrtdelta_posbranch);


/*
 `taum_y1 a b y1 (y2) (y3) (y4) (y5) (y6) = 
  taum (&2) (&2) (&2) a b y1`;;

 `taum_y2 a b (y1) (y2) (y3) (y4) (y5) (y6) = 
  taum (&2) (&2) (&2) a b y2`;;

 `taum_y1_y2 a (y1) (y2) (y3) (y4) (y5) (y6) = 
  taum (&2) (&2) (&2) a y1 y2`;;

`taum_x1 a b x1 x2 x3 x4 x5 x6 = 
  taum_y1 a b (sqrt x1) (sqrt x2) (sqrt x3) (sqrt x4) (sqrt x5) (sqrt x6)`;;

`taum_x2 a b x1 x2 x3 x4 x5 x6 = 
  taum_y2 a b (sqrt x1) (sqrt x2) (sqrt x3) (sqrt x4) (sqrt x5) (sqrt x6)`;;

`taum_x1_x2 a x1 x2 x3 x4 x5 x6 = 
  taum_y1_y2 a (sqrt x1) (sqrt x2) (sqrt x3) (sqrt x4) (sqrt x5) (sqrt x6)`;;

`taum y1 y2 y3 y4 y5 y6 = rhazim y1 y2 y3 y4 y5 y6 + rhazim2 y1 y2 y3 y4 y5 y6 + rhazim3 y1  y2 y3 y4 y5 y6 - (&1 + const1)* pi`

 `arclength_y1 a b (y1) (y2) (y3) (y4) (y5) (y6) =  arclength y1 a b`;;

 `arclength_x1 a b x1 x2 x3 x4 x5 x6 = 
  arclength_y1 a b (sqrt x1) (sqrt x2) (sqrt x3) (sqrt x4) (sqrt x5) (sqrt x6)`;;
 */

namespace local { // truncated functions.

  /*
static const Function truncate_sqrt_delta_at135_x = 
  uni(i_truncate_sqrt,Function::compose
      (delta,x1,two_unit,x3,two_unit,x5,two_unit));

static const Function truncate_sqrt_delta_x = 
  uni(i_truncate_sqrt,delta);


static const Function truncate_dih_x = 
  pi2 * unit + uni(i_atn, (-delta4_x / 
			   (two_unit * y1 *truncate_sqrt_delta

staic const Function truncate_sol_at135_x = 
  uni(i_truncate_sqrt,taylor

  static const Function truncate_dih_x =
    pi/2 + uni(i_truncate_sqrt,delta);
	       
    (
     )
  (const interval& ic2) {
    Function c2 = unit * (ic2);
    Function g = 
      ((x2 + x6 + x1* mone) * y1 + (x1 + x6 + x2 * mone) * y2) * uni(i_inv,local::ups_126) * 
      uni(i_sqrt,Function::compose
	  (delta,x1,x2,c2,c2,c2,x6)) * quarter;
      return g;
  };
  */  


}

namespace local {




  /*
  static const Function taum_x = 
    legacy_simplex::rhazim_x + legacy_simplex::rhazim2_x +legacy_simplex::rhazim3_x
    + unit * (pi * mone * (one + const1));
  */

  static const Function taum_x1(const interval& a,const interval& b)
  {
    Function g = Function::compose
      (legacy_simplex::taum_x, // BUG?: replaced taum with taum_x 2012-6-2.
       unit * four  , unit * four, unit * four,
       unit * (a * a) , unit * (b * b) , x1);
    return g;
  }

  static const Function taum_x2(const interval& a,const interval& b)
  {
    Function g = Function::compose
      (legacy_simplex::taum_x, // BUG?: replaced taum with taum_x 2012-6-2.
       unit * four  , unit * four, unit * four,
       unit * (a * a) , unit * (b * b) , x2);
    return g;
  }

  static const Function taum_x1_x2(const interval& a)
  {
    Function g = Function::compose
      (legacy_simplex::taum_x , // BUG?: replaced taum with taum_x 2012-6-2.
       unit * four, unit * four, unit * four,
       unit * (a * a) , x1 , x2);
    return g;
  }

  static const Function arclength_x1
   (const interval& b,const interval& c) {
    Function g = Function::compose
    (legacy_simplex::arclength_x_123,
     x1, unit * (b * b), unit * (c* c), unit,unit,unit);
    return g;
  }

  static const Function arclength_x2
   (const interval& b,const interval& c) {
    Function g = Function::compose
    (legacy_simplex::arclength_x_123,
     x2, unit * (b * b), unit * (c* c), unit,unit,unit);
    return g;
  }


  static const Function surfR126d
  (const interval& ic2) {
    Function c2 = unit * (ic2);
    Function g = 
      ((x2 + x6 + x1* mone) * y1 + (x1 + x6 + x2 * mone) * y2) * uni(i_inv,local::ups_126) * 
      uni(i_sqrt,Function::compose
	  (delta,x1,x2,c2,c2,c2,x6)) * quarter;
      return g;
  };

  Function surfR12_6rad_x =  // cf. S.P.I Sec. 8.6.3.
      ((x2 + x6 + x1* mone) * y1 + (x1 + x6 + x2 * mone) * y2) * chi126 *
      uni(i_inv,
	  local::ups_126 * uni(i_sqrt,delta) * eight);

  static const Function surf_x =     local::surfR12_6rad_x +
    legacy_simplex::rotate2 (local::surfR12_6rad_x) +
    legacy_simplex::rotate3 (local::surfR12_6rad_x);
};

const Function legacy_simplex::surfR126d  (const interval& circumrad)  {
  return local::surfR126d(circumrad);
}

const Function legacy_simplex::surf_x = local::surf_x;

const Function 
 legacy_simplex::taum_x1(const interval& a,const interval& b) {
  return local::taum_x1(a,b);
}

const Function 
 legacy_simplex::taum_x2(const interval& a,const interval& b) {
  return local::taum_x2(a,b);
} 

const Function 
 legacy_simplex::taum_x1_x2(const interval& a) {
  return local::taum_x1_x2(a);
}  

const Function 
legacy_simplex::arclength_x1(const interval& b,const interval& c) {
  return local::arclength_x1(b,c);
}

const Function 
legacy_simplex::arclength_x2(const interval& b,const interval& c) {
  return local::arclength_x2(b,c);
}  

namespace local {

  /* `!x1 x2 x3 x4 x5 x6.  
  &0 <= x1 /\ &0 <= x2 /\ &0 <= x6 ==>
  (vol3_x_sqrt x1 x2 x3 x4 x5 x6 = vol_x x1 x2 (&2) (&2) (&2) x6)`, */


  static const Function vol3_x_sqrt = 
    Function::compose(legacy_simplex::vol_x,
			    x1,x2,two_unit,two_unit,two_unit,x6);

  static const Function vol3_x_135_s2 = 
    Function::compose(legacy_simplex::vol_x,
			    x1,two_unit,x3,two_unit,x5,two_unit);



  /*
`!x1 x2 x3 x4 x5 x6.  
   &0 <= x1 /\ &0 <= x2 /\ &0 <= x6 ==>
   vol3f_x_lfun x1 x2 x3 x4 x5 x6 =   (&2 * mm1 / pi) *
             (&2 * dih_x x1 x2 (&2) (&2) (&2) x6 +
              &2 * dih2_x x1 x2 (&2) (&2) (&2) x6 +
              &2 * dih6_x x1 x2 (&2) (&2) (&2) x6 +
              dih3_x x1 x2 (&2) (&2) (&2) x6 +
              dih4_x x1 x2 (&2) (&2) (&2) x6 +
              dih5_x x1 x2 (&2) (&2) (&2) x6 - &3 * pi) -
             (&8 * mm2 / pi) *
             ( ldih_x x1 x2 (&2) (&2) (&2) x6 +
              ldih2_x x1 x2 (&2) (&2) (&2) x6 +
              ldih6_x x1 x2 (&2) (&2) (&2) x6)`,
   */


  static const Function vol3f_x_lfun_mm1 = 
    Function::compose(legacy_simplex::dih,x1,x2,two_unit,two_unit,two_unit,x6) * two+
    Function::compose(legacy_simplex::dih2,x1,x2,two_unit,two_unit,two_unit,x6) * two+
    Function::compose(legacy_simplex::dih6,x1,x2,two_unit,two_unit,two_unit,x6) * two+
    Function::compose(legacy_simplex::dih3,x1,x2,two_unit,two_unit,two_unit,x6) +
    Function::compose(legacy_simplex::dih4,x1,x2,two_unit,two_unit,two_unit,x6) +
    Function::compose(legacy_simplex::dih5,x1,x2,two_unit,two_unit,two_unit,x6) +
    unit * (pi * mone * three);
 
   static const Function vol3f_x_lfun_mm2 = 
     Function::compose(legacy_simplex::ldih_x,x1,x2,two_unit,two_unit,two_unit,x6) +
     Function::compose(legacy_simplex::ldih2_x,x1,x2,two_unit,two_unit,two_unit,x6) +
     Function::compose(legacy_simplex::ldih6_x,x1,x2,two_unit,two_unit,two_unit,x6);

  static const Function vol3f_x_lfun = 
    vol3f_x_lfun_mm1 * (two * mm1 / pi) + vol3f_x_lfun_mm2 * (eight * mone * mm2 /pi);

  /*
  `!x1 x2 x3 x4 x5 x6.  
   ((&2 * h0) pow 2 <= x1) /\ &0 <= x2 /\ &0 <= x6 ==>
   vol3f_x_sqrt2_lmplus x1 x2 x3 x4 x5 x6 =   (&2 * mm1 / pi) *
             (&2 * dih_x x1 x2 (&2) (&2) (&2) x6 +
              &2 * dih2_x x1 x2 (&2) (&2) (&2) x6 +
              &2 * dih6_x x1 x2 (&2) (&2) (&2) x6 +
              dih3_x x1 x2 (&2) (&2) (&2) x6 +
              dih4_x x1 x2 (&2) (&2) (&2) x6 +
              dih5_x x1 x2 (&2) (&2) (&2) x6 - &3 * pi) -
             (&8 * mm2 / pi) *
             (
              ldih2_x x1 x2 (&2) (&2) (&2) x6 +
              ldih6_x x1 x2 (&2) (&2) (&2) x6)`,
  */

  static Function mk_135 (const Function& f) {
    return Function::compose(f,x1,two_unit,x3,two_unit,x5,two_unit);
  }

  static Function mk_126 (const Function& f) {
    return Function::compose(f,x1,x2,two_unit,two_unit,two_unit,x6);
  }

  const Function ldih_x_126_n = mk_126 (ldih_x_n);
  const Function ldih_x_135_n = mk_135 (ldih_x_n);


  static const Function vol3f_x_lfun_mm2_no_dih1 = 
    mk_126(legacy_simplex::ldih2_x) + mk_126(legacy_simplex::ldih6_x);

  /*
  static const Function vol3f_x_lfun_mm2_no_dih1 = 
      Function::compose(legacy_simplex::ldih2_x,x1,x2,two_unit,two_unit,two_unit,x6) +
     Function::compose(legacy_simplex::ldih6_x,x1,x2,two_unit,two_unit,two_unit,x6);
  */

  static const Function vol3f_x_sqrt2_lmplus = 
    vol3f_x_lfun_mm1 * (two * mm1 / pi) + vol3f_x_lfun_mm2_no_dih1 * (eight * mone * mm2 /pi);



  static const Function vol2r = (two_unit  + x1 * (mone/four) ) * (two * pi/three);

  static const Function vv_term_m1 = 
    (unit + y1 * (mone / (two * sqrt2))) * (four * mm1 ) ;

  static const Function vv_term_m2 = 
    lfun_sqrtx1_div2 * sixteen * mm2;

static const Function dih_x_126_s2 = mk_126(legacy_simplex::dih);
static const Function dih_x_135_s2 = mk_135(legacy_simplex::dih);


  // implement upper_dih_x
  /*
  `upper_dih_x x1 x2 x3 x4 x5 x6 =
  (let d = delta_x x1 x2 x3 x4 x5 x6 in
  let d4 = delta_x4 x1 x2 x3 x4 x5 x6 in (
   &2 * sqrt x1 * sqp d *
    matan (&4 * x1 * d / (d4 pow 2) ) / d4))`;;
   */
  static const Function rdelta_x4 = uni(univariate::i_inv,delta_x4);

  static const  Function upper_dih_x = 
    (y1 * uni (univariate::i_sqp,delta) * rdelta_x4 *
    uni(univariate::i_matan, ( x1 * delta * uni(univariate::i_pow2, rdelta_x4) ) * four) ) * two;


  static const Function upper_dih_x_126 = mk_126(upper_dih_x);
  static const Function upper_dih_x_135 = mk_135(upper_dih_x);


  // tau_lowform_x
  static const interval rho_y1_c0("0.337460877099657327908782072437");
  static const interval rho_y1_c1("0.325078245800685344182435855126");
  static const Function rho_y1 = 
    y1 * rho_y1_c0 + unit * rho_y1_c1;

  static const Function rhazim_x_div_sqrtdelta_posbranch =
    rho_y1 * dih_x_div_sqrtdelta_posbranch;

  static const Function rhazim2_x_div_sqrtdelta_posbranch =
    legacy_simplex::rotate2  (rhazim_x_div_sqrtdelta_posbranch);

  static const Function rhazim3_x_div_sqrtdelta_posbranch =
    legacy_simplex::rotate3  (rhazim_x_div_sqrtdelta_posbranch);

  // 
  static const Function tau_lowform_x =
    rho_y1 * pi - unit * (pi + sol0) +
    uni(univariate::i_sqp,delta) * rhazim_x_div_sqrtdelta_posbranch +
    uni(univariate::i_sqn,delta) * rhazim2_x_div_sqrtdelta_posbranch +
    uni(univariate::i_sqn,delta) * rhazim3_x_div_sqrtdelta_posbranch;

  // 
  static const Function tau_residual_x =
    rhazim_x_div_sqrtdelta_posbranch +
    rhazim2_x_div_sqrtdelta_posbranch +
    rhazim3_x_div_sqrtdelta_posbranch;

  // selling functions
  static const interval bcc_value("5.31473969997195748521421682011");
  static const interval fcc_sc("16.9705627484771405856202");
  //static const interval bcc_value_pow_6("23631533612.86479722208849");
  static const interval sqrt01("3.162277660168379331998893544"); // sqrt(0.1)/0.1;
  static const Function selling_volume2 = 
    x1*x2*x3 + x1*x3*x4 + x2*x3*x4 + x1*x2*x5 + 
    x2*x3*x5 + x1*x4*x5 + x2*x4*x5 + 
    x3*x4*x5 + x1*x2*x6 + x1*x3*x6 + x1*x4*x6 + 
    x2*x4*x6 + x3*x4*x6 + x1*x5*x6 + 
    x2*x5*x6 + x3*x5*x6;
  static const Function selling_surface_num = 
    2*(x1*uni(univariate::i_sqrt,x2 + x3 + x4 + x5)*x6 + (x1*x3 + x1*x5 + x3*x5)*uni(univariate::i_sqrt,x2 + x4 + x6) + 
       x2*x5*uni(univariate::i_sqrt,x1 + x3 + x4 + x6) + x3*x4*uni(univariate::i_sqrt,x1 + x2 + x5 + x6) + 
       (x1*x2 + x1*x4 + x2*x4)*uni(univariate::i_sqrt,x3 + x5 + x6) + 
       uni(univariate::i_sqrt,x1 + x4 + x5)*(x2*x3 + x2*x6 + x3*x6) + 
       uni(univariate::i_sqrt,x1 + x2 + x3)*(x4*x5 + x4*x6 + x5*x6));
  static const Function selling_surface_nn = 
    selling_surface_num - unit * bcc_value;
  static const Function selling_surface_nn2_013 = 
    2*(x1*uni(univariate::i_sqrt,x2 + x3 + x4 + x5)*x6 + 
       (x1*x3 + x1*x5 + x3*x5)*(x2 + x4 + x6)*sqrt01 + 
       x2*x5*uni(univariate::i_sqrt,x1 + x3 + x4 + x6) + x3*x4*uni(univariate::i_sqrt,x1 + x2 + x5 + x6) + 
       (x1*x2 + x1*x4 + x2*x4)*uni(univariate::i_sqrt,x3 + x5 + x6) + 
       uni(univariate::i_sqrt,x1 + x4 + x5)*(x2*x3 + x2*x6 + x3*x6) + 
       uni(univariate::i_sqrt,x1 + x2 + x3)*(x4*x5 + x4*x6 + x5*x6)) - unit * bcc_value;
  static const Function selling_surface_nn01_23 = 
    2*(x1*(x2 + x3 + x4 + x5)*x6*sqrt01 + 
       (x1*x3 + x1*x5 + x3*x5)*uni(univariate::i_sqrt,x2 + x4 + x6) + 
       x2*x5*uni(univariate::i_sqrt,x1 + x3 + x4 + x6) + x3*x4*uni(univariate::i_sqrt,x1 + x2 + x5 + x6) + 
       (x1*x2 + x1*x4 + x2*x4)*uni(univariate::i_sqrt,x3 + x5 + x6) + 
       uni(univariate::i_sqrt,x1 + x4 + x5)*(x2*x3 + x2*x6 + x3*x6) + 
       uni(univariate::i_sqrt,x1 + x2 + x3)*(x4*x5 + x4*x6 + x5*x6)) - unit * bcc_value;
  static const Function selling_homog = 
    selling_surface_num - 
    uni(univariate::i_pow5h6,selling_volume2)*bcc_value;
  static const Function fcc_ineq = 
    selling_surface_num - uni(univariate::i_sqrt,selling_volume2) * fcc_sc;
    
    

  // gamma3f_vLR_lfun
    static const Function gamma3f_x_vLR_lfun = 
    (dih + dih_x_126_s2 * mone +  dih_x_135_s2 * mone) * 
       (vol2r + vv_term_m1 * mone + vv_term_m2 ) *     (one / (two * pi));

  // gamma3f_vLR0
    static const Function gamma3f_x_vLR0 = 
    (dih + dih_x_126_s2 * mone +  dih_x_135_s2 * mone) * 
       (vol2r + vv_term_m1 * mone  ) *     (one / (two * pi));

  static const interval m03("-0.03");



  // gamma3f_x_vL_lfun
    static const Function gamma3f_x_vL_lfun = 
    (dih + dih_x_126_s2 * mone + unit * m03) * 
       (vol2r + vv_term_m1 * mone + vv_term_m2 ) *     (one / (two * pi));

  // gamma3f_vL0
    static const Function gamma3f_x_vL0 = 
    (dih + dih_x_126_s2 * mone +  unit * m03) * 
       (vol2r + vv_term_m1 * mone  ) *     (one / (two * pi));

  // gamma3f_v_lfun
    static const Function gamma3f_x_v_lfun = 
    (dih +  unit * two * m03) * 
       (vol2r + vv_term_m1 * mone + vv_term_m2 ) *     (one / (two * pi));

  // gamma3f_v0
    static const Function gamma3f_x_v0 = 
    (dih +   unit * two * m03) * 
       (vol2r + vv_term_m1 * mone  ) *     (one / (two * pi));

  // gamma3f_vLR_x_nlfun
    static const Function gamma3f_vLR_x_nlfun = 
    (dih + upper_dih_x_126 * mone + upper_dih_x_135 * mone) * 
       (vol2r + vv_term_m1 * mone + vv_term_m2 ) *     (one / (two * pi));

  // gamma3f_vLR_x_n0
    static const Function gamma3f_vLR_x_n0 = 
    (dih + upper_dih_x_126 * mone + upper_dih_x_135 * mone) * 
       (vol2r + vv_term_m1 * mone  ) *     (one / (two * pi));

  // gamma3f_vL_x_nlfun
    static const Function gamma3f_vL_x_nlfun = 
    (dih + upper_dih_x_126 * mone + unit * m03) * 
       (vol2r + vv_term_m1 * mone + vv_term_m2 ) *     (one / (two * pi));

  // gamma3f_vL_x_n0
    static const Function gamma3f_vL_x_n0 = 
    (dih + upper_dih_x_126 * mone +  unit * m03) * 
       (vol2r + vv_term_m1 * mone  ) *     (one / (two * pi));

  // gamma3f_135_x_s_n
  static const Function gamma3f_135_x_s_n =
    sqndelta * (unit * (one/twelve) + (sol_euler_x_div_sqrtdelta + legacy_simplex::sol_euler156_x_div_sqrtdelta + legacy_simplex::sol_euler345_x_div_sqrtdelta) * (mone * two * mm1 / pi));

 // gamma3f_126_x_s_n
  static const Function gamma3f_126_x_s_n =
    sqndelta * (unit * (one/twelve) + (sol_euler_x_div_sqrtdelta + legacy_simplex::sol_euler246_x_div_sqrtdelta + legacy_simplex::sol_euler156_x_div_sqrtdelta) * (mone* two * mm1 / pi));


  

  // num1
  /* thm =  |- !x1 x2 x3 x4 x5 x6.         num1 x1 x2 x3 x4 x5 x6 =
         &64 * x1 * x4 -          &32 * x2 * x4 -         &32 * x3 * x4 -
         &4 * x1 * x4 pow 2 -          &32 * x2 * x5 +         &32 * x3 * x5 +
         &4 * x2 * x4 * x5 +         &32 * x2 * x6 - &32 * x3 * x6 +         &4 * x3 * x4 * x6 */
  static const interval t64("64");
  static const interval t32("32");
  static const interval t16("16");

  static const Function num1 = 
     x1 * x4 * t64 +  x2 * x4 *mone * t32 +  x3 * x4 *mone * t32 
    + x1 * x4 * x4 * mone * four  +  x2 * x5 * mone * t32 + x3 * x5 * t32
    + x2 * x4 * x5  * four +  x2 * x6 * t32 + x3 * x6 * mone * t32 +  x3 * x4 * x6 * four;


  static const Function afac = y4 * (unit* t16  - x4);

  static const Function sd = uni(i_sqrt,Function::compose(delta,unit*four,unit*four,unit*four,x4,x5,x6));


  const Function rat1 = num1 * uni(univariate::i_inv, sd * afac) ;





  // implement edge_flat2_x.
  const Function bx_neg_quadratic = x1*(x2 + x3 + x5 + x6) -x1 * x1 - (x3 - x5)*(x2 - x6) ;
  const Function disc_quadratic =  uni(i_sqrt, ups_126 * ups_135 );
  const Function ax2_inv_quadratic = uni(i_inv,x1 * two) ;
  const Function edge_flat2_x = (bx_neg_quadratic + disc_quadratic) * ax2_inv_quadratic;
  const Function edge_flat_x = (uni(i_sqrt,edge_flat2_x));

  // implement taum_x.
  /* |- !x1 x2 x3 x4 x5 x6.
         taum_x x1 x2 x3 x4 x5 x6 =
         rhazim_x x1 x2 x3 x4 x5 x6 +
         rhazim2_x x1 x2 x3 x4 x5 x6 +
         rhazim3_x x1 x2 x3 x4 x5 x6 - (&1 + const1) * pi
  */
  const Function taum_x = legacy_simplex::rhazim_x + legacy_simplex::rhazim2_x + 
    legacy_simplex::rhazim3_x - unit  * pi * (one + const1);

  //implement delta4_squared_x
  const Function delta4_squared_x = legacy_simplex::delta_x4 * legacy_simplex::delta_x4;

  //implement x1_delta_x
  const Function x1_delta_x = legacy_simplex::x1 * legacy_simplex::delta_x;

  //implement lin_dih
  const Function lindih(const interval& theta) {
    double u = theta.lo;
    double v = theta.hi;
    assert(v < 3.14159);
    assert(u > -1.0);
    interMath::down();
    double u1 = tan(u);
    double v1 = tan(v);
    interMath::up();
    double u2 = tan(u); double v2 = tan(v);
    interval a1(u1,u2); interval b1(v1,v2);
    interval tantheta = interMath::combine (a1,b1);
    static const interval t2 = tantheta*tantheta;
    Function F = delta4_squared_x * t2 + x1_delta_x * four * mone;
    return F;
    // Delta4>0 ==> ( lin_dih > 0 <==> dih<theta ).
    // Delta4<0 ==> ( lin_dih > 0 <==> dih > pi - theta ).
  }

  // implement flat_term_x.
  const Function flat_term_x = (y1 - unit * two * h0) * sol0 * (one / (two * h0 - two));



  // implement euler_3flat_x
  /*
 `euler_3flat_x x1 x2 x3 x4 x5 x6 = 
let x5r = edge_flat2_x x5 x1 x3 (&0)    (&4) (&4) in
let x6r = edge_flat2_x x6 x1 x2 (&0)    (&4) (&4) in
let x4r = edge_flat2_x x4 x2 x3 (&0)    (&4) (&4) in
  (eulerA_x x1 x2 x3 x4r x5r x6r)`
   */
  const Function eulerA_x = 
    y1 * y2 * y3 + y1 * (x2 + x3 - x4) * half + y2 * (x1 + x3 - x5) * half +
    y3 * (x1 + x2 - x6) * half;

  const Function euler_3flat_x() 
  {
    static const interval zero ("0");
    static Function uz = unit * zero;
    static Function u4 = unit* four;
    static Function x4r = Function::compose(
						 edge_flat2_x,x4,x2,x3,uz,u4,u4);
    static Function x5r = Function::compose(
						 edge_flat2_x,x5,x1,x3,uz,u4,u4);
    static Function x6r = Function::compose(
						 edge_flat2_x,x6,x1,x2,uz,u4,u4);
    Function d = Function::compose(eulerA_x,
						   x1,x2,x3,x4r,x5r,x6r);
    return d;
  };


  // implement euler_2flat_x
  /*
`euler_2flat_x x1 x2 x3 x4 x5 x6 =
let x5r = edge_flat2_x x5 x1 x3 (&0)    (&4) (&4) in
let x6r = edge_flat2_x x6 x1 x2 (&0)    (&4) (&4) in
  (eulerA_x x1 x2 x3 x4 x5r x6r)`;;
   */
  const Function euler_2flat_x() 
  {
    static const interval zero ("0");
    static Function uz = unit * zero;
    static Function u4 = unit* four;
    static Function x5r = Function::compose(
						 edge_flat2_x,x5,x1,x3,uz,u4,u4);
    static Function x6r = Function::compose(
						 edge_flat2_x,x6,x1,x2,uz,u4,u4);
    Function d = Function::compose(eulerA_x,
						   x1,x2,x3,x4,x5r,x6r);
    return d;
  };


  // implement euler_1flat_x
  /*

let euler_1flat_x = new_definition
  `euler_1flat_x x1 x2 x3 x4 x5 x6 = 
let x6r = edge_flat2_x x6 x1 x2 (&0)    (&4) (&4) in
  (eulerA_x x1 x2 x3 x4 x5 x6r)`;;
   */
  const Function euler_1flat_x() 
  {
    static const interval zero ("0");
    static Function uz = unit * zero;
    static Function u4 = unit* four;
    static Function x6r = Function::compose(
						 edge_flat2_x,x6,x1,x2,uz,u4,u4);
    Function d = Function::compose(eulerA_x,
						   x1,x2,x3,x4,x5,x6r);
    return d;
  };

  //



  // implement taum_3flat_x
  /*
`taum_3flat_x x1 x2 x3 x23 x13 x12 = 
let x5 = edge_flat2_x x13 x1 x3 (&0)    (&4) (&4) in
let x6 = edge_flat2_x x12 x1 x2 (&0)    (&4) (&4) in
let x4 = edge_flat2_x x23 x2 x3 (&0)    (&4) (&4) in
  (taum_x x1 x2 x3 x4 x5 x6  + flat_term_x x12 + flat_term_x x23 + flat_term_x x13)`;
   */
  const Function taum_3flat_x() 
  {
    static const interval zero ("0");
    static Function uz = unit * zero;
    static Function u4 = unit* four;
    static Function x4r = Function::compose(
						 edge_flat2_x,x4,x2,x3,uz,u4,u4);
    static Function x5r = Function::compose(
						 edge_flat2_x,x5,x1,x3,uz,u4,u4);
    static Function x6r = Function::compose(
						 edge_flat2_x,x6,x1,x2,uz,u4,u4);
    static Function ft_4 = legacy_simplex::rotate4(flat_term_x);
    static Function ft_5 = legacy_simplex::rotate5(flat_term_x);
    static Function ft_6 = legacy_simplex::rotate6(flat_term_x);
    Function d = Function::compose(taum_x,
						   x1,x2,x3,x4r,x5r,x6r);
    Function e = d + ft_4 + ft_5 + ft_6;
    return e;
  };


  // implement taum_2flat_x
  /*
`taum_2flat_x x1 x2 x3 x4 x13 x12 = 
let x5 = edge_flat2_x x13 x1 x3 (&0)    (&4) (&4) in
let x6 = edge_flat2_x x12 x1 x2 (&0)    (&4) (&4) in
  (taum_x x1 x2 x3 x4 x5 x6  + flat_term_x x12 +  flat_term_x x13)`;;
   */
  const Function taum_2flat_x() 
  {
    static const interval zero ("0");
    static Function uz = unit * zero;
    static Function u4 = unit* four;
    static Function x5r = Function::compose(
						 edge_flat2_x,x5,x1,x3,uz,u4,u4);
    static Function x6r = Function::compose(
						 edge_flat2_x,x6,x1,x2,uz,u4,u4);
    Function d = Function::compose(taum_x,
						   x1,x2,x3,x4,x5r,x6r);
    static Function ft_5 = legacy_simplex::rotate5(flat_term_x);
    static Function ft_6 = legacy_simplex::rotate6(flat_term_x);
    Function e = d + ft_5 + ft_6;
    return e;
  };


  // implement taum_1flat_x
  /*
`taum_1flat_x x1 x2 x3 x4 x5 x12 = 
let x6 = edge_flat2_x x12 x1 x2 (&0)    (&4) (&4) in
  (taum_x x1 x2 x3 x4 x5 x6  + flat_term_x x12)`;;
   */
  const Function taum_1flat_x() 
  {
    static const interval zero ("0");
    static Function uz = unit * zero;
    static Function u4 = unit* four;
    static Function x6r = Function::compose(
						 edge_flat2_x,x6,x1,x2,uz,u4,u4);
    Function d = Function::compose(taum_x,
						   x1,x2,x3,x4,x5,x6r);
    static Function ft_6 = legacy_simplex::rotate6(flat_term_x);
    Function e = d +  ft_6;
    return e;
  };

  /*
  `delta_pent_x  (x1:real) (x2:real) (x3:real) (x4:real) (x5:real) (x6:real) = 
     delta_x x1 x2 x6 (&4) (&4) (#3.24 pow 2)`;;
  */
  static const Function delta_pent_x = Function::compose(
		delta,x1,x2,x6,unit * four,unit*four,unit*"10.4976");


  // delta_126_x
  const Function delta_126_x(const interval& x3s, const interval& x4s, const interval& x5s) {
    Function t = Function::compose(delta,x1,x2,unit * x3s, unit * x4s, unit *x5s, x6);
    return t;
  }

  // delta_234_x
  const Function delta_234_x(const interval& x1s, const interval& x5s, const interval& x6s) {
    Function t = Function::compose(delta,unit * x1s,x2,x3,x4, unit *x5s,unit* x6s);
    return t;
  }

  // delta_135_x
  const Function delta_135_x(const interval& x2s, const interval& x4s, const interval& x6s) {
    Function t = Function::compose(delta,x1,unit*x2s,x3,unit*x4s,x5,unit* x6s);
    return t;
  }


  // delta_sub1_x
  const Function delta_sub1_x(const interval& x1s) {
    Function t = Function::compose(delta,unit * x1s,x2,x3,x4,x5,x6);
    return t;
  }


  // taum_sub1_x
  const Function taum_sub1_x(const interval& x1s) {
    Function t = Function::compose(taum_x,unit * x1s,x2,x3,x4,x5,x6);
    return t;
  }

  // taum_sub...
	static const Function taum_sub246_x(const interval& x2s,const interval& x4s,const interval& x6s)  {
    Function t = Function::compose(taum_x,x1,unit *x2s,x3,unit *x4s,x5,unit * x6s);
    return t;
  }

  static const Function taum_sub345_x(const interval& x3s,const interval& x4s,const interval& x5s)  {
    Function t = Function::compose(taum_x,x1,x2,unit *x3s,unit *x4s,unit *x5s,x6);
    return t;
  }

  /*
const Function monomial(int i1,int i2,int i3,int i4,int i5,int i6) {
  return Function::mk_monomial(i1, i2,i3,i4,i5,i6);
}
  */

  // num_combo1 = ((num1^2 - 1/100 num2 // Simplify) /. {e1 -> x1, e2 -> x2, 
  //          e3 -> x3, a2 -> x4, b2 -> x5, c2 -> x6}) // CForm;
  static const Function x4_pow2 = x4 * x4;
  static const Function x5_pow2 = x5 * x5;
  static const Function x6_pow2 = x6 * x6;
  static const Function x4_pow3 = x4_pow2 * x4;
  static const Function x4_pow4 = x4_pow2 * x4_pow2;
  static const Function x4_pow5 = x4_pow3 * x4_pow2;
  static const Function x5mx6 = (x5 + x6 * mone);
  static const Function x5mx6_pow3 = x5mx6 * x5mx6 * x5mx6;
  static const Function num_combo1_subexp =
    x1* x4_pow2  + x4*(x1*16 + x2*(unit*-8 + x5) + 
    x3*(unit*-8 + x6))*mone + (x2 + x3*mone)*(x5 + x6*mone)*8;
  static const interval t25("25");

  // slow: 10^6 cases took 1292075074 -- 1292077520.
  // This is about 11x slower than num_combo1_alt.
  // deprecated.
  static const Function num_combo1_deprecated = 
     (2*(-2*x1*x4_pow5 + 2* x4_pow4 *(32*x1 + 3*(x2*(unit*-8 + x5) + x3*(unit*-8 + x6))) + 
       200*num_combo1_subexp * num_combo1_subexp  + 256*(x2 + x3*mone)* x5mx6_pow3  + 
       2* x4_pow2 *(x5 - x6)*(384*(x2 + x3*mone) + x2* x5_pow2  + 
          x5*(x1*-32 + x2*(unit*56  + 9*x6*mone) + 9*x3*(unit*-8 + x6)) + 8*(4*x1 + 9*x2 + x3*-7)*x6 
     +           x3* x6_pow2*mone ) - 16*x4*(x5 - x6)*
        ((x2 - 3*x3)* x5_pow2  + x6*(32*x1 + 3*x2*(unit*16 + x6) - x3*(unit*80 + x6)) - 
          4*x5*(8*x1 - 3*x3*(unit*-4 + x6) + x2*(unit*-20 + 3*x6))) + 
        x4_pow3 *(2*x1*(unit*-256 +  x5_pow2  - 2*x5*x6 +  x6_pow2 ) + 
          x2*( x5_pow2 *(unit*-8 + x6) - 16*x5*(unit*3 + x6) + 16*(unit*16 + 9*x6)) + 
		  x3*(x5*(unit*144 - 16*x6 +  x6_pow2 ) - 8*(unit*-32 + 6*x6 +  x6_pow2 ))))) * (one/t25);

static const Function num_combo1_alt = 
(512*Function::mk_monomial(0,0,1,0,0,3) - 1536*Function::mk_monomial(0,0,1,0,1,2) + 1536*Function::mk_monomial(0,0,1,0,2,1) - 
   512*Function::mk_monomial(0,0,1,0,3,0) - 2560*Function::mk_monomial(0,0,1,1,0,2) - 32*Function::mk_monomial(0,0,1,1,0,3) + 
   1024*Function::mk_monomial(0,0,1,1,1,1) + 416*Function::mk_monomial(0,0,1,1,1,2) + 1536*Function::mk_monomial(0,0,1,1,2,0) - 
   480*Function::mk_monomial(0,0,1,1,2,1) + 96*Function::mk_monomial(0,0,1,1,3,0) + 1536*Function::mk_monomial(0,0,1,2,0,1) + 
   224*Function::mk_monomial(0,0,1,2,0,2) + 4*Function::mk_monomial(0,0,1,2,0,3) - 1536*Function::mk_monomial(0,0,1,2,1,0) + 
   64*Function::mk_monomial(0,0,1,2,1,1) - 40*Function::mk_monomial(0,0,1,2,1,2) - 288*Function::mk_monomial(0,0,1,2,2,0) + 
   36*Function::mk_monomial(0,0,1,2,2,1) + 512*Function::mk_monomial(0,0,1,3,0,0) - 96*Function::mk_monomial(0,0,1,3,0,1) - 
   16*Function::mk_monomial(0,0,1,3,0,2) + 288*Function::mk_monomial(0,0,1,3,1,0) - 32*Function::mk_monomial(0,0,1,3,1,1) + 
   2*Function::mk_monomial(0,0,1,3,1,2) - 96*Function::mk_monomial(0,0,1,4,0,0) + 12*Function::mk_monomial(0,0,1,4,0,1) + 
   25600*Function::mk_monomial(0,0,2,0,0,2) - 51200*Function::mk_monomial(0,0,2,0,1,1) + 25600*Function::mk_monomial(0,0,2,0,2,0) + 
   51200*Function::mk_monomial(0,0,2,1,0,1) - 6400*Function::mk_monomial(0,0,2,1,0,2) - 51200*Function::mk_monomial(0,0,2,1,1,0) + 
   6400*Function::mk_monomial(0,0,2,1,1,1) + 25600*Function::mk_monomial(0,0,2,2,0,0) - 6400*Function::mk_monomial(0,0,2,2,0,1) + 
   400*Function::mk_monomial(0,0,2,2,0,2) - 512*Function::mk_monomial(0,1,0,0,0,3) + 1536*Function::mk_monomial(0,1,0,0,1,2) - 
   1536*Function::mk_monomial(0,1,0,0,2,1) + 512*Function::mk_monomial(0,1,0,0,3,0) + 1536*Function::mk_monomial(0,1,0,1,0,2) + 
   96*Function::mk_monomial(0,1,0,1,0,3) + 1024*Function::mk_monomial(0,1,0,1,1,1) - 480*Function::mk_monomial(0,1,0,1,1,2) - 
   2560*Function::mk_monomial(0,1,0,1,2,0) + 416*Function::mk_monomial(0,1,0,1,2,1) - 32*Function::mk_monomial(0,1,0,1,3,0) - 
   1536*Function::mk_monomial(0,1,0,2,0,1) - 288*Function::mk_monomial(0,1,0,2,0,2) + 1536*Function::mk_monomial(0,1,0,2,1,0) + 
   64*Function::mk_monomial(0,1,0,2,1,1) + 36*Function::mk_monomial(0,1,0,2,1,2) + 224*Function::mk_monomial(0,1,0,2,2,0) - 
   40*Function::mk_monomial(0,1,0,2,2,1) + 4*Function::mk_monomial(0,1,0,2,3,0) + 512*Function::mk_monomial(0,1,0,3,0,0) + 
   288*Function::mk_monomial(0,1,0,3,0,1) - 96*Function::mk_monomial(0,1,0,3,1,0) - 32*Function::mk_monomial(0,1,0,3,1,1) - 
   16*Function::mk_monomial(0,1,0,3,2,0) + 2*Function::mk_monomial(0,1,0,3,2,1) - 96*Function::mk_monomial(0,1,0,4,0,0) + 
   12*Function::mk_monomial(0,1,0,4,1,0) - 51200*Function::mk_monomial(0,1,1,0,0,2) + 102400*Function::mk_monomial(0,1,1,0,1,1) - 
   51200*Function::mk_monomial(0,1,1,0,2,0) + 6400*Function::mk_monomial(0,1,1,1,0,2) - 12800*Function::mk_monomial(0,1,1,1,1,1) + 
   6400*Function::mk_monomial(0,1,1,1,2,0) + 51200*Function::mk_monomial(0,1,1,2,0,0) - 6400*Function::mk_monomial(0,1,1,2,0,1) - 
   6400*Function::mk_monomial(0,1,1,2,1,0) + 800*Function::mk_monomial(0,1,1,2,1,1) + 25600*Function::mk_monomial(0,2,0,0,0,2) - 
   51200*Function::mk_monomial(0,2,0,0,1,1) + 25600*Function::mk_monomial(0,2,0,0,2,0) - 51200*Function::mk_monomial(0,2,0,1,0,1) + 
   51200*Function::mk_monomial(0,2,0,1,1,0) + 6400*Function::mk_monomial(0,2,0,1,1,1) - 6400*Function::mk_monomial(0,2,0,1,2,0) + 
   25600*Function::mk_monomial(0,2,0,2,0,0) - 6400*Function::mk_monomial(0,2,0,2,1,0) + 400*Function::mk_monomial(0,2,0,2,2,0) + 
   1024*Function::mk_monomial(1,0,0,1,0,2) - 2048*Function::mk_monomial(1,0,0,1,1,1) + 1024*Function::mk_monomial(1,0,0,1,2,0) - 
   128*Function::mk_monomial(1,0,0,2,0,2) + 256*Function::mk_monomial(1,0,0,2,1,1) - 128*Function::mk_monomial(1,0,0,2,2,0) - 
   1024*Function::mk_monomial(1,0,0,3,0,0) + 4*Function::mk_monomial(1,0,0,3,0,2) - 8*Function::mk_monomial(1,0,0,3,1,1) + 
   4*Function::mk_monomial(1,0,0,3,2,0) + 128*Function::mk_monomial(1,0,0,4,0,0) - 4*Function::mk_monomial(1,0,0,5,0,0) - 
   102400*Function::mk_monomial(1,0,1,1,0,1) + 102400*Function::mk_monomial(1,0,1,1,1,0) - 
   102400*Function::mk_monomial(1,0,1,2,0,0) + 19200*Function::mk_monomial(1,0,1,2,0,1) - 6400*Function::mk_monomial(1,0,1,2,1,0) + 
   6400*Function::mk_monomial(1,0,1,3,0,0) - 800*Function::mk_monomial(1,0,1,3,0,1) + 102400*Function::mk_monomial(1,1,0,1,0,1) - 
   102400*Function::mk_monomial(1,1,0,1,1,0) - 102400*Function::mk_monomial(1,1,0,2,0,0) - 6400*Function::mk_monomial(1,1,0,2,0,1) + 
   19200*Function::mk_monomial(1,1,0,2,1,0) + 6400*Function::mk_monomial(1,1,0,3,0,0) - 800*Function::mk_monomial(1,1,0,3,1,0) + 
   102400*Function::mk_monomial(2,0,0,2,0,0) - 12800*Function::mk_monomial(2,0,0,3,0,0) + 400*Function::mk_monomial(2,0,0,4,0,0))*(one/t25);

static const Function num2 = 
  (-2048)*Function::mk_monomial(0,0,1,0,0,3) + 6144*Function::mk_monomial(0,0,1,0,1,2) - 6144*Function::mk_monomial(0,0,1,0,2,1) + 
   2048*Function::mk_monomial(0,0,1,0,3,0) + 10240*Function::mk_monomial(0,0,1,1,0,2) + 128*Function::mk_monomial(0,0,1,1,0,3) - 
   4096*Function::mk_monomial(0,0,1,1,1,1) - 1664*Function::mk_monomial(0,0,1,1,1,2) - 6144*Function::mk_monomial(0,0,1,1,2,0) + 
   1920*Function::mk_monomial(0,0,1,1,2,1) - 384*Function::mk_monomial(0,0,1,1,3,0) - 6144*Function::mk_monomial(0,0,1,2,0,1) - 
   896*Function::mk_monomial(0,0,1,2,0,2) - 16*Function::mk_monomial(0,0,1,2,0,3) + 6144*Function::mk_monomial(0,0,1,2,1,0) - 
   256*Function::mk_monomial(0,0,1,2,1,1) + 160*Function::mk_monomial(0,0,1,2,1,2) + 1152*Function::mk_monomial(0,0,1,2,2,0) - 
   144*Function::mk_monomial(0,0,1,2,2,1) - 2048*Function::mk_monomial(0,0,1,3,0,0) + 384*Function::mk_monomial(0,0,1,3,0,1) + 
   64*Function::mk_monomial(0,0,1,3,0,2) - 1152*Function::mk_monomial(0,0,1,3,1,0) + 128*Function::mk_monomial(0,0,1,3,1,1) - 
   8*Function::mk_monomial(0,0,1,3,1,2) + 384*Function::mk_monomial(0,0,1,4,0,0) - 48*Function::mk_monomial(0,0,1,4,0,1) + 
   2048*Function::mk_monomial(0,1,0,0,0,3) - 6144*Function::mk_monomial(0,1,0,0,1,2) + 6144*Function::mk_monomial(0,1,0,0,2,1) - 
   2048*Function::mk_monomial(0,1,0,0,3,0) - 6144*Function::mk_monomial(0,1,0,1,0,2) - 384*Function::mk_monomial(0,1,0,1,0,3) - 
   4096*Function::mk_monomial(0,1,0,1,1,1) + 1920*Function::mk_monomial(0,1,0,1,1,2) + 10240*Function::mk_monomial(0,1,0,1,2,0) - 
   1664*Function::mk_monomial(0,1,0,1,2,1) + 128*Function::mk_monomial(0,1,0,1,3,0) + 6144*Function::mk_monomial(0,1,0,2,0,1) + 
   1152*Function::mk_monomial(0,1,0,2,0,2) - 6144*Function::mk_monomial(0,1,0,2,1,0) - 256*Function::mk_monomial(0,1,0,2,1,1) - 
   144*Function::mk_monomial(0,1,0,2,1,2) - 896*Function::mk_monomial(0,1,0,2,2,0) + 160*Function::mk_monomial(0,1,0,2,2,1) - 
   16*Function::mk_monomial(0,1,0,2,3,0) - 2048*Function::mk_monomial(0,1,0,3,0,0) - 1152*Function::mk_monomial(0,1,0,3,0,1) + 
   384*Function::mk_monomial(0,1,0,3,1,0) + 128*Function::mk_monomial(0,1,0,3,1,1) + 64*Function::mk_monomial(0,1,0,3,2,0) - 
   8*Function::mk_monomial(0,1,0,3,2,1) + 384*Function::mk_monomial(0,1,0,4,0,0) - 48*Function::mk_monomial(0,1,0,4,1,0) - 
   4096*Function::mk_monomial(1,0,0,1,0,2) + 8192*Function::mk_monomial(1,0,0,1,1,1) - 4096*Function::mk_monomial(1,0,0,1,2,0) + 
   512*Function::mk_monomial(1,0,0,2,0,2) - 1024*Function::mk_monomial(1,0,0,2,1,1) + 512*Function::mk_monomial(1,0,0,2,2,0) + 
   4096*Function::mk_monomial(1,0,0,3,0,0) - 16*Function::mk_monomial(1,0,0,3,0,2) + 32*Function::mk_monomial(1,0,0,3,1,1) - 
16*Function::mk_monomial(1,0,0,3,2,0) - 512*Function::mk_monomial(1,0,0,4,0,0) + 16*Function::mk_monomial(1,0,0,5,0,0);

  const Function den2 = uni(univariate::i_pow3,sd) * uni(univariate::i_pow2,  afac); 


  const Function rat2 = num2 * uni(univariate::i_inv,den2);

  const Function eta2_123 = Function::compose(
							  legacy_simplex::eta2_126,x1,x2,unit,unit,unit,x3);


  const Function ell_uvx  = 
    uni(univariate::i_sqrt, (eta2_123 - x1 * quarter) ) + 
    uni(univariate::i_sqrt, (eta2_123 - x2 * quarter) )
   ;

  const Function ell_vx2  = 
    uni(univariate::i_sqrt, (eta2_123 - x2 * quarter) )
   ;


}; // end local scope

const Function legacy_simplex::ell_uvx = local::ell_uvx;
const Function legacy_simplex::ell_vx2 = local::ell_vx2;

const Function legacy_simplex::vol3_x_sqrt = local::vol3_x_sqrt;

const Function legacy_simplex::vol3_x_135_s2 = local::vol3_x_135_s2;

const Function legacy_simplex::vol3f_x_lfun = local::vol3f_x_lfun;

const Function legacy_simplex::vol3f_x_sqrt2_lmplus = local::vol3f_x_sqrt2_lmplus;

const Function legacy_simplex::dih_x_126_s2 = local::dih_x_126_s2;
const Function legacy_simplex::dih2_x_126_s2 = local::mk_126(legacy_simplex::dih2);
const Function legacy_simplex::dih3_x_126_s2 = local::mk_126(legacy_simplex::dih3);
const Function legacy_simplex::dih4_x_126_s2 = local::mk_126(legacy_simplex::dih4);
const Function legacy_simplex::dih5_x_126_s2 = local::mk_126(legacy_simplex::dih5);
const Function legacy_simplex::dih6_x_126_s2 = local::mk_126(legacy_simplex::dih6);
 
const Function legacy_simplex::ldih_x_126_s2 = local::mk_126(legacy_simplex::ldih_x);
const Function legacy_simplex::ldih2_x_126_s2 = local::mk_126(legacy_simplex::ldih2_x);
const Function legacy_simplex::ldih6_x_126_s2 = local::mk_126(legacy_simplex::ldih6_x);
const Function legacy_simplex::delta_x_126_s2 = local::mk_126(legacy_simplex::delta_x);

const Function legacy_simplex::dih_x_135_s2 = local::dih_x_135_s2;
const Function legacy_simplex::dih2_x_135_s2 = local::mk_135(legacy_simplex::dih2);
const Function legacy_simplex::dih3_x_135_s2 = local::mk_135(legacy_simplex::dih3);
const Function legacy_simplex::dih4_x_135_s2 = local::mk_135(legacy_simplex::dih4);
const Function legacy_simplex::dih5_x_135_s2 = local::mk_135(legacy_simplex::dih5);
const Function legacy_simplex::dih6_x_135_s2 = local::mk_135(legacy_simplex::dih6);

const Function legacy_simplex::ldih_x_135_s2 = local::mk_135(legacy_simplex::ldih_x);
const Function legacy_simplex::ldih3_x_135_s2 = local::mk_135(legacy_simplex::ldih3_x);
const Function legacy_simplex::ldih5_x_135_s2 = local::mk_135(legacy_simplex::ldih5_x);
const Function legacy_simplex::delta_x_135_s2 = local::mk_135(legacy_simplex::delta_x);

const Function legacy_simplex::tau_lowform_x = local::tau_lowform_x;

const Function legacy_simplex::tau_residual_x = local::tau_residual_x;

const Function legacy_simplex::selling_homog = local::selling_homog;
const Function legacy_simplex::fcc_ineq = local::fcc_ineq;
const Function legacy_simplex::selling_volume2 = local::selling_volume2;
const Function legacy_simplex::selling_surface_nn = local::selling_surface_nn;
const Function legacy_simplex::selling_surface_nn2_013 = local::selling_surface_nn2_013;
const Function legacy_simplex::selling_surface_nn01_23 = local::selling_surface_nn01_23;


//
const Function legacy_simplex::ldih_x_126_n = local::ldih_x_126_n;
const Function legacy_simplex::ldih2_x_126_n=
  local::mk_126(legacy_simplex::rotate2(local::ldih_x_n));
const Function legacy_simplex::ldih6_x_126_n= 
  local::mk_126(legacy_simplex::rotate6(local::ldih_x_n));
const Function legacy_simplex::ldih_x_135_n=local::ldih_x_135_n;
const Function legacy_simplex::ldih3_x_135_n= 
  local::mk_135(legacy_simplex::rotate3(local::ldih_x_n));
const Function legacy_simplex::ldih5_x_135_n= 
  local::mk_135(legacy_simplex::rotate5(local::ldih_x_n));


const Function legacy_simplex::gamma3f_x_vLR_lfun = local::gamma3f_x_vLR_lfun;
const Function legacy_simplex::gamma3f_x_vLR0 = local::gamma3f_x_vLR0;
const Function legacy_simplex::gamma3f_x_vL_lfun = local::gamma3f_x_vL_lfun;
const Function legacy_simplex::gamma3f_x_vL0 = local::gamma3f_x_vL0;
const Function legacy_simplex::gamma3f_x_v_lfun = local::gamma3f_x_v_lfun;
const Function legacy_simplex::gamma3f_x_v0 = local::gamma3f_x_v0;

const Function legacy_simplex::gamma3f_vLR_x_nlfun = local::gamma3f_vLR_x_nlfun;
const Function legacy_simplex::gamma3f_vLR_x_n0 = local::gamma3f_vLR_x_n0;
const Function legacy_simplex::gamma3f_vL_x_nlfun = local::gamma3f_vL_x_nlfun;
const Function legacy_simplex::gamma3f_vL_x_n0 = local::gamma3f_vL_x_n0;

const Function legacy_simplex::gamma3f_135_x_s_n = local::gamma3f_135_x_s_n;
const Function legacy_simplex::gamma3f_126_x_s_n = local::gamma3f_126_x_s_n;

const Function legacy_simplex::upper_dih_x = local::upper_dih_x;

const Function legacy_simplex::num1 = local::num1;
const Function legacy_simplex::num2 = local::num2;
const Function legacy_simplex::rat1 = local::rat1;


const Function legacy_simplex::rat2 = local::rat2;
const Function legacy_simplex::den2 = local::den2;
const Function legacy_simplex::num_combo1 = local::num_combo1_alt;



const Function legacy_simplex::edge_flat2_x = local::edge_flat2_x;
const Function legacy_simplex::edge_flat_x = local::edge_flat_x;
const Function legacy_simplex::taum_x = local::taum_x;
const Function legacy_simplex::x1_delta_x = local::x1_delta_x;
const Function legacy_simplex::delta4_squared_x = local::delta4_squared_x;

const Function legacy_simplex::flat_term_x = local::flat_term_x;
const Function legacy_simplex::eulerA_x = local::eulerA_x;
const Function legacy_simplex::euler_3flat_x = local::euler_3flat_x();
const Function legacy_simplex::euler_2flat_x = local::euler_2flat_x();
const Function legacy_simplex::euler_1flat_x = local::euler_1flat_x();
const Function legacy_simplex::taum_3flat_x = local::taum_3flat_x();
const Function legacy_simplex::taum_2flat_x = local::taum_2flat_x();
const Function legacy_simplex::taum_1flat_x = local::taum_1flat_x();
const Function legacy_simplex::delta_pent_x = local::delta_pent_x;

const Function legacy_simplex::lindih(const interval& theta) {
  Function F = local::lindih(theta);
  return F;
}

const Function legacy_simplex::delta_126_x(const interval& x3s, const interval& x4s,
						 const interval & x5s) {
  return local::delta_126_x(x3s,x4s,x5s);
};

const Function legacy_simplex::delta_234_x(const interval& x1s, const interval& x5s, const interval& x6s) {
  return local::delta_234_x(x1s,x5s,x6s);
};

const Function legacy_simplex::delta_135_x(const interval& x2s, const interval& x4s, const interval& x6s) {
  return local::delta_135_x(x2s,x4s,x6s);
}

const Function legacy_simplex::delta_sub1_x(const interval& x1s) {
  return local::delta_sub1_x(x1s);
};


const Function legacy_simplex::taum_sub1_x(const interval& x1s) {
  return local::taum_sub1_x(x1s);
};

const Function legacy_simplex::taum_sub246_x(const interval& x2s,const interval& x4s,const interval& x6s)  {
  return local::taum_sub246_x(x2s,x4s,x6s);
};

const Function legacy_simplex::taum_sub345_x(const interval& x3s,const interval& x4s,const interval& x5s)  {
  return local::taum_sub345_x(x3s,x4s,x5s);
};

/*
static int primHasDeltaDenom(const primitive* p) {
  return
    ((p == &dih1Primitive) || (p == &dih2Primitive) || (p == &dih3Primitive) ||
     (p == &rhazimPrimitive) || (p== &rhazim2Primitive) || (p == &rhazim3Primitive) ||
     (p == &solPrimitive));
}
*/

/* ========================================================================== */
/*                                                                            */
/*    Section:TESTING ROUTINES                                                        */
/*                                                                            */
/* ========================================================================== */


static int epsilonClose(double x,interval y,double epsilon)
{
  if (interMath::abs(y-interval(x,x))>epsilon)
    {
      cout << "close eps : " << interMath::abs(y-interval(x,x))
	   << " x: " << x << " y: " << y << endl<< flush;
      return 0;
    }
  return 1;
}

static int epsilonCloseDoubles(double x,double y,double epsilon)
{
  if (abs(y-x)>epsilon)
    {
      cout << "close-doubles eps: " << abs(y-x)
	   << " x: " << x << "  y: " << y << endl<< flush;
      return 0;
    }
  return 1;
}


  /* from univariate.cc */
    static int epsilon3(double* f,const univariate & u) {
      interval x("0.21");
      for (int i=0;i<3;i++) {
	epsilonCloseDoubles(f[i],interMath::sup(u.eval(x,i)),1.0e-8);
      }
    }

static int barelyLess(double x,double y,double epsilon)
{
  if ((x>y)||(y>x+epsilon))
    {
      cout << "barelyLess " << x << " " << y << endl << flush;
      return 0;
    }
  return 1;
}

static double rand01()
{
  static int w =0;
  if (w==0) { srand(time(0)); w = 1; }
  double u = double(rand());
  double v = double(/*stdlib.h*/RAND_MAX);
  return u/v;
}

static double rand(int i,const domain& x,const domain& z,double t=1)
{
  return x.getValue(i) + t*rand01()*(z.getValue(i)-x.getValue(i));
}

static domain makeDomain(int i,const domain& x,const domain& z)
{
  int a[6]; int b=1;
  int j;
  for (j=0;j<6;j++)
    {
      a[j]= (i/b) % 2; // binary conversion
      b= b*2;
    }
  return domain(
		x.getValue(0)+ a[0]*(z.getValue(0)-x.getValue(0)),
		x.getValue(1)+ a[1]*(z.getValue(1)-x.getValue(1)),
		x.getValue(2)+ a[2]*(z.getValue(2)-x.getValue(2)),
		x.getValue(3)+ a[3]*(z.getValue(3)-x.getValue(3)),
		x.getValue(4)+ a[4]*(z.getValue(4)-x.getValue(4)),
		x.getValue(5)+ a[5]*(z.getValue(5)-x.getValue(5)));
}

//////////
//
// This compares the corners with the taylor upper bound.
// If the taylor upper bound is not close to the corner upper bound
// or if the taylor upper bound is less than a corner value, and
// error is issued.  There can be false reporting of errors here
// because the computed corner value might be much larger than
// the actual corner value (because of atan approximations, etc. ).
// Or the taylor upper bound might be extremely conservative and
// give an upper bound that is much bigger than needs be.

static void testProcedure(Function F,lineInterval (*G)(const domain&),
			  const domain& x,const domain& z,const char* s,double epsilon=1.0e-9)
{
  double t = 1.0e-5; 
  domain xx(rand(0,x,z),rand(1,x,z),rand(2,x,z),
	    rand(3,x,z),rand(4,x,z),rand(5,x,z));
  domain zz(rand(0,xx,z,t),rand(1,xx,z,t),rand(2,xx,z,t),
	    rand(3,xx,z,t),rand(4,xx,z,t),rand(5,xx,z,t));
  taylorData f = F.evalf(xx,zz); // evaluate f at random small cell.
  
  /*get max*/{
    int i,j;
    double temp = -/*float.h*/DBL_MAX; 
    double Dtemp[6]; for (i=0;i<6;i++) Dtemp[i]= -DBL_MAX;
    for (i=0;i<64;i++) 
      {
	domain c = makeDomain(i,xx,zz); 
	lineInterval li = (*G)(c);
	if (temp<li.hi()) temp = li.hi();
	for (j=0;j<6;j++) if (Dtemp[j]<interMath::sup(li.partial(j)))
			    Dtemp[j]=interMath::sup(li.partial(j));
      }
    for (int k=0;k<6;k++) 
      if (!barelyLess(Dtemp[k],f.upperPartial(k),epsilon))
	{
	  cout << "testProc Dmax("<<k<<") failed " << s << endl;
	  cout << "found = " << Dtemp[k] << " bounded by = " << 
	    f.upperPartial(k) << endl;
	  interMath::up();
	  cout << "diff = " << f.upperPartial(k) - Dtemp[k] << endl;
	  for (j=0;j<6;j++) cout << xx.getValue(j) << " "; cout << endl;
	  for (j=0;j<6;j++) cout << zz.getValue(j) << " "; cout << endl;
	}
    if (!barelyLess(temp,f.upperBound(),epsilon))
      {
	cout << "\n\ntestProc max failed " << s << endl;
	cout << "found = " << temp << " bounded by = " << f.upperBound() << endl;
	cout << "diff = " << f.upperBound() - temp << endl;
	for (j=0;j<6;j++) cout << xx.getValue(j) << " "; cout << endl;
	for (j=0;j<6;j++) cout << zz.getValue(j) << " "; cout << endl;
	cout << "tangentVector = " << f.tangentVector.hi() << endl;
	cout << "widths = "; for (j=0;j<6;j++) cout << f.w.getValue(j)<<" " << endl;
	cout << "center partials= "; 
	for (j=0;j<6;j++) cout << f.tangentVector.partial(j) << " " << endl;
	cout << "taylorError " << taylorError(f.w,f.DD) << endl << endl;
      }
    
  }
  
  /*get min*/{
    int i,j;
    double temp = /*float.h*/DBL_MAX; 
    double Dtemp[6]; for (i=0;i<6;i++) Dtemp[i]= DBL_MAX;
    for (i=0;i<64;i++) 
      {
	domain c = makeDomain(i,xx,zz); 
	lineInterval li = (*G)(c);
	if (temp>li.low()) temp = li.low();
	for (j=0;j<6;j++) if (Dtemp[j]>interMath::inf(li.partial(j)))
			    Dtemp[j]=interMath::inf(li.partial(j));
      }
    for (int k=0;k<6;k++) 
      if (!barelyLess(f.lowerPartial(k),Dtemp[k],epsilon))
	{
	  cout << "testProc Dmin("<<k<<") failed " << s << endl;
	  cout << "found = " << Dtemp[k] << " bounded by = " << 
	    f.lowerPartial(k) << endl;
	  interMath::up();
	  cout << "diff = " << -f.lowerPartial(k) + Dtemp[k] << endl;
	  for (j=0;j<6;j++) cout << xx.getValue(j) << " "; cout << endl;
	  for (j=0;j<6;j++) cout << zz.getValue(j) << " "; cout << endl;
	}
    if (!barelyLess(f.lowerBound(),temp,epsilon))
      {
	cout << "testProc min failed " << s << endl;
	cout << "found = " << temp << " bounded by = " << f.lowerBound() << endl;
	cout << "diff = " << f.lowerBound() - temp << endl;
	for (j=0;j<6;j++) cout << xx.getValue(j) << " "; cout << endl;
	for (j=0;j<6;j++) cout << zz.getValue(j) << " "; cout << endl;
      }
  }  
}


void legacy_simplex::selfTest()
{
  cout << " -- loading legacy_simplex testing routines " << endl << flush;


  /* test primitiveA. */
  domain d(2.0,2.1,2.2,2.3,2.4,2.5);
  Function x1 = legacy_simplex::x1;
  taylorData td = x1.evalf(d,d);
  

  /*test Proc*/{
    testProcedure(legacy_simplex::x1,lineX1,domain(2,2,2,2,2,2),
		  domain(2.51,2.51,2.51,2.51,2.51,2.51),"x1");
    testProcedure(legacy_simplex::dih,linearization::dih,
		  domain(4,4,4,4,4,4), domain(6.3001,6.3001,6.3001,6.3001,6.3001,6.3001),
		  "legacy_simplex::dih");
    testProcedure(legacy_simplex::dih2,linearization::dih2,
		  domain(4,4,4,4,4,4), domain(6.3001,6.3001,6.3001,6.3001,6.3001,6.3001),
		  "legacy_simplex::dih2");
    testProcedure(legacy_simplex::dih3,linearization::dih3,
		  domain(4,4,4,4,4,4), domain(6.3001,6.3001,6.3001,6.3001,6.3001,6.3001),
		  "legacy_simplex::dih3");
    testProcedure(legacy_simplex::sol,linearization::solid,
		  domain(4,4,4,4,4,4), domain(6.3001,6.3001,6.3001,6.3001,6.3001,6.3001),
		  "legacy_simplex::sol");
    testProcedure(legacy_simplex::eta2_126,linearization::eta2_126,
		  domain(4,4,4,4,4,4), domain(6.3001,6.3001,6.3001,6.3001,6.3001,6.3001),
		  "legacy_simplex::eta2_126",5.0e-6);
    testProcedure(legacy_simplex::eta2_135,linearization::eta2_135,
		  domain(4,4,4,4,4,4), domain(6.3001,6.3001,6.3001,6.3001,6.3001,6.3001),
		  "legacy_simplex::eta2_135",5.0e-6);
    testProcedure(legacy_simplex::eta2_234,linearization::eta2_234,
		  domain(4,4,4,4,4,4), domain(6.3001,6.3001,6.3001,6.3001,6.3001,6.3001),
		  "legacy_simplex::eta2_234",5.0e-6);
    testProcedure(legacy_simplex::eta2_456,linearization::eta2_456,
		  domain(4,4,4,4,4,4), domain(6.3001,6.3001,6.3001,6.3001,6.3001,6.3001),
		  "legacy_simplex::eta2_456",5.0e-6);
    
  }
  
  /*test +,*,evalf,tangentAtEstimate */{
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    domain z(4.11,4.22,4.33,4.44,4.55,4.66);
    Function f = legacy_simplex::x1*"17" + legacy_simplex::x2*"2";
    taylorData t = f.evalf(x,z);
    if (!epsilonClose(t.upperBound(),"78.31",1.0e-13))
      cout << " t.upperBound() = " << t.upperBound() << endl;
    if (!epsilonClose(t.lowerBound(),"78.1",1.0e-13))
      cout << " t.lowerBound() = " << t.lowerBound() << endl;
    if (!epsilonClose(t.upperPartial(0),"17",1.0e-15))
      cout << " t.upperPartial(0)= " << t.upperPartial(0) << endl;
    if (!epsilonClose(t.lowerPartial(0),"17",1.0e-15))
      cout << " t.lowerPartial(0)= " << t.lowerPartial(0) << endl;
    if (!epsilonClose(t.upperPartial(1),"2",1.0e-15))
      cout << " t.upperPartial(1)= " << t.upperPartial(1) << endl;
    if (!epsilonClose(t.lowerPartial(1),"2",1.0e-15))
      cout << " t.lowerPartial(1)= " << t.lowerPartial(1) << endl;
    lineInterval L = f.tangentAtEstimate(x);
    if (!epsilonClose(L.hi(),"78.1",1.0e-13))
      cout << " L.hi() = " << L.hi() << endl;
    if (!epsilonClose(L.low(),"78.1",1.0e-13))
      cout << " L.low() = " << L.low() << endl;
    if (!epsilonClose(17,L.partial(0),1.0e-15))
      cout << " L.partial(0)= " << L.partial(0) << endl;
    if (!epsilonClose(2,L.partial(1),1.0e-15))
      cout << " L.partial(1)= " << L.partial(1) << endl;
  }
  
  /*test plus,scale,center,upperBound,lowerBound,&partials*/ {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    domain z(4.11,4.22,4.33,4.44,4.55,4.66);
    taylorData t1 = legacy_simplex::x1.evalf(x,z);
    taylorData t2 = legacy_simplex::x2.evalf(x,z);
    taylorData s1 = taylorData::scale(t1,interval("17"));
    taylorData s2 = taylorData::scale(t2,interval("2"));
    taylorData t = taylorData::plus(s1,s2);
    if (!epsilonClose(t.upperBound(),"78.31",1.0e-13))
      cout << " t.upperBound() = " << t.upperBound() << endl;
    if (!epsilonClose(t.lowerBound(),"78.1",1.0e-13))
      cout << " t.lowerBound() = " << t.lowerBound() << endl;
    if (!epsilonClose(t.upperPartial(0),"17",1.0e-15))
      cout << " t.upperPartial(0)= " << t.upperPartial(0) << endl;
    if (!epsilonClose(t.lowerPartial(0),"17",1.0e-15))
      cout << " t.lowerPartial(0)= " << t.lowerPartial(0) << endl;
    if (!epsilonClose(t.upperPartial(1),"2",1.0e-15))
      cout << " t.upperPartial(1)= " << t.upperPartial(1) << endl;
    if (!epsilonClose(t.lowerPartial(1),"2",1.0e-15))
      cout << " t.lowerPartial(1)= " << t.lowerPartial(1) << endl;
    lineInterval c = t.tangentVectorOf();
    if (!epsilonClose(c.hi(),"78.205",1.0e-13))
      cout << " c.hi() = " << c.hi() << endl;
    if (!epsilonClose(c.low(),"78.205",1.0e-13))
      cout << " c.low() = " << c.low() << endl;
    if (!epsilonClose(17,c.partial(0),1.0e-15))
      cout << " c.partial(0)= " << c.partial(0) << endl;
    if (!epsilonClose(2,c.partial(1),1.0e-15))
      cout << " c.partial(1)= " << c.partial(1) << endl;
  }
  
  /*test x1*/  {
    int i,j;
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    domain z(4.11,4.22,4.33,4.44,4.55,4.66);
    char zz[6][30]={"4.11","4.22","4.33","4.44","4.55","4.66"};
    char xx[6][30]={"4.1","4.2","4.3","4.4","4.5","4.6"};
    for (j=0;j<6;j++) {
      taylorData t = legacy_simplex::x1.evalf(x,z);
      switch (j)
	{
	case 0 : t = legacy_simplex::x1.evalf(x,z); break;
	case 1 : t = legacy_simplex::x2.evalf(x,z); break;
	case 2 : t = legacy_simplex::x3.evalf(x,z); break;
	case 3 : t = legacy_simplex::x4.evalf(x,z); break;
	case 4 : t = legacy_simplex::x5.evalf(x,z); break;
	case 5 : t = legacy_simplex::x6.evalf(x,z); break;
	}
      if (!epsilonClose(t.upperBound(),zz[j],1.0e-14))
	cout << "x" << j+1 << "+ fails " << t.upperBound() << endl;
      if (!epsilonClose(t.lowerBound(),xx[j],1.0e-14))
	cout << "x" << j+1 << "- fails " << t.lowerBound() << endl;
      for (i=0;i<6;i++) {
	if (!epsilonClose(t.upperPartial(i),i==j ? "1" : "0",1.0e-15))
	  cout << "x" << j+1 << "++ fails " << i 
	       << " " << t.upperPartial(i) << endl;
	if (!epsilonClose(t.lowerPartial(i),i==j ? "1" : "0",1.0e-15))
	  cout << "x" << j+1 << "-- fails " << i 
	       << " " << t.lowerPartial(i) << endl;
      }
    }
  }

  /*test y1*/  {
    int i,j;
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    domain z(4.11,4.22,4.33,4.44,4.55,4.66);
    char zz[6][30]={"4.11","4.22","4.33","4.44","4.55","4.66"};
    char xx[6][30]={"4.1","4.2","4.3","4.4","4.5","4.6"};
    for (j=0;j<6;j++) {
      taylorData t = legacy_simplex::x1.evalf(x,z);
      switch (j)
	{
	case 0 : t = legacy_simplex::y1.evalf(x,z); break;
	case 1 : t = legacy_simplex::y2.evalf(x,z); break;
	case 2 : t = legacy_simplex::y3.evalf(x,z); break;
	case 3 : t = legacy_simplex::y4.evalf(x,z); break;
	case 4 : t = legacy_simplex::y5.evalf(x,z); break;
	case 5 : t = legacy_simplex::y6.evalf(x,z); break;
	}
      if (!epsilonClose(t.upperBound(),interMath::sqrt(interval(zz[j])),1.0e-4))
	cout << "x" << j+1 << "+ fails " << t.upperBound() << endl;
      if (!epsilonClose(t.lowerBound(),interMath::sqrt(interval(xx[j])),1.0e-5))
	cout << "x" << j+1 << "- fails " << t.lowerBound() << endl;
      static interval half("0.5");
      for (i=0;i<6;i++) {
	if (!epsilonClose(t.upperPartial(i),i==j ? 
			  half/interMath::sqrt(interval(xx[j])) : interval("0"),1.0e-5))
	  cout << "x" << j+1 << "++ fails " << i 
	       << " " << t.upperPartial(i) << endl;
	if (!epsilonClose(t.lowerPartial(i),i==j ? 
			  half/interMath::sqrt(interval(zz[j])) : interval("0"),1.0e-4))
	  cout << "x" << j+1 << "-- fails " << i 
	       << " " << t.lowerPartial(i) << endl;
      }
    }
  }

  /* test mdtau_y */   { 
    domain x(2.1,2.2,2.3,3.4,2.5,2.6);
    double mValue= -0.5994620477455596 ;
    double mathValueD[6]={0,0,0,0,0,0};
    taylorData at = legacy_simplex::mdtau_y_LC.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "mdtau_y_LC  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "mdtau_y_LC D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test mdtau2_y */   { 
    domain x(2.1,2.2,2.3,3.4,2.5,2.6);
    double mValue= 0.2804657791758259;
    double mathValueD[6]={0,0,0,0,0,0};
    taylorData at = legacy_simplex::mdtau2_y_LC.evalf(x,x); 
    /* NO LONGER ACCURATE.  THESE ARE CALCS OF mdtau2 / uf = mdtau2
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "mdtau2_y_LC  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "mdtau2_y_LC D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
        */
  }

  /* test delta_y_LC */   { 
    domain x(2.1,2.2,2.3,3.4,2.5,2.6);
    double mValue= 339.9384510;
    double mathValueD[6]={0,0,0,0,0,0};
    taylorData at = legacy_simplex::delta_y_LC.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "delta_y_LC  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "delta_y_LC D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test volx */   { 
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=1.0661359356729956;
    double mathValueD[6]={0.0716828019335723,0.06608105639401098,
   0.05995821824611842,0.06249854471173341,0.05728761862842055,
			       0.05155559993677649};
    taylorData at = legacy_simplex::vol_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "volx  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "volx D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }


  /* test chi126 */   { 
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=84.6;
    double mathValueD[6]={2.68,1.4499999999999957,17.019999999999996,
			  19.269999999999996,18.9,-1.3699999999999974};
    taylorData at = ::chi126.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "chi126  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "chi126 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }


  /* test rad2 */   { 
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=1.6333363881302794;
    double mathValueD[6]={0.057786164807838214,0.05761105521751131,
   0.05741965636296806,0.06701170422099567,0.06721538721254888,
			  0.06743943850325723};
    taylorData at = legacy_simplex::rad2.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "rad2  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "rad2 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test delta_x4 */   { 
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=19.19;
    double mathValueD[6]={0.5999999999999996,4.3,4.499999999999999,-8.2,
			  3.700000000000001,3.8999999999999986};
    taylorData at = legacy_simplex::delta_x4.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "delta_x4  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "delta_x4 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test marchalDih, deprecated */  
  /*  { 
    double md[3]={0.8148484787433622,12.760561387665467,-66.28061167966449};
      epsilon3(md,::i_marchalQ);
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=1.1314338321497612;
    double mathValueD[6]={-0.7804417742116788,-0.049120282260656074,
   -0.054018913876389546,0.14725412156249917,-0.042144869722190594,
      -0.04693241526153936};
    taylorData at = legacy_simplex::marchalDih.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "marchalDih  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "marchalDih D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
    } */

  /* test arclength_x_123 */   { 
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 1.0679029643628666;
    double mathValueD[6]={-0.07043519394425567,-0.07203236387496442,
			  0.13751633103402303,0,0,0};
    taylorData at = legacy_simplex::arclength_x_123.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "arclength_x_123  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "arclength_x_123 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test arclength_x_234 */   { 
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 1.0674194068234593;
    double mathValueD[6]={0,-0.06875697006122505,
			  -0.07028159730433495,0.13431594151495124,0,0};
    taylorData at = legacy_simplex::arclength_x_234.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "arclength_x_234  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "arclength_x_234 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test arclength_x_126 */   { 
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 1.1087112366844947;
    double mathValueD[6]={-0.07387006214108435,
			  -0.07531619563273523,0,0,0,0.13460766879042044};
    taylorData at = legacy_simplex::arclength_x_126.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "arclength_x_126  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "arclength_x_126 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test arclength_x_345 */   { 
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 1.066957923498952;
    double mathValueD[6]={0,0,-0.06715688186243648,
			  -0.06861379768796456,0.13126117818567132,0};
    taylorData at = legacy_simplex::arclength_x_345.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "arclength_x_345  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "arclength_x_345 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test arclength_x1 */   { 
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 1.0965338178368775;
    double mathValueD[6]={-0.07084353197306854,0,0,0,0,0};
    taylorData at = legacy_simplex::arclength_x1(interval::interval("2.08"),interval::interval("2.14")).evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "arclength_x1  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "arclength_x1 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test norm2hh_x */   { 
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 0.33641905470850064;
    double mathValueD[6]={-0.262888552950994,0.024099927051466907,
   0.0355143556591757,0.04653741075440776,0.057190958417936553,
			  0.06749519175968627};
    taylorData at = legacy_simplex::norm2hh_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "norm2hh_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "norm2hh_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test acs_sqrt_x1_d4 */   { 
    domain x(0.1,0.2,0.3,0.4,0.5,0.6);
    double mValue= 1.491656801832486;
    double mathValueD[6]={-0.396525792859072,0,0,0,0,0};
    taylorData at = legacy_simplex::acs_sqrt_x1_d4.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "acs_sqrt_x1_d4  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "acs_sqrt_x1_d4 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test asn797k */   { 
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 2.0742570836404837;
    double mathValueD[6]={0.0648275015403495,0,0,0,0,0};
    taylorData at = legacy_simplex::asn797k.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "asn797k  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "asn797k D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test asnFnhk */   { 
    domain x(1.04, 1.08, 1.12, 1.16, 1.2, 1.24);
    double mValue= 0.22005326245872275;
    double mathValueD[6]={0.07141922522392495,2.7397148354175482,0,
			  0,0,0};
    taylorData at = legacy_simplex::asnFnhk.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "asnFnhk  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "asnFnhk D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test eta2_126 */   { 
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 19.19;
    double mathValueD[6]={0.5999999999999996,4.3,4.499999999999999,-8.2,
			  3.700000000000001,3.8999999999999986};
    taylorData at = legacy_simplex::delta_x4.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "delta_x4  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "delta_x4 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test eta2_135 */   { 
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=1.4343699150244082;
    double mathValueD[6]={0.10607345504918758,0,0.11054816002151685,
			  0,0.11646925805115915,0};
    taylorData at = legacy_simplex::eta2_135.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "eta2_135  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "eta2_135 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test eta2_234 */   { 
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=1.4335919177340792;
    double mathValueD[6]={0,0.10856346275290063,0.11097076506380871,
			  0.11373888281761776,0,0};
    taylorData at = legacy_simplex::eta2_234.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "eta2_234  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "eta2_234 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test eta2_456 */   { 
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=1.5002470762642062;
    double mathValueD[6]={0,0,0,0.10867530033135317,
			  0.11098297337542629,0.11362008143844202};
    taylorData at = legacy_simplex::eta2_456.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "eta2_456  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "eta2_456 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test gchi1_x */   {
      double gchid[3]={1.0320236166281522,0.135793449845905,-0.32331773772834516};
      epsilon3(gchid,::i_gchi);
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue=1.4921173443920384;
      double mathValueD[6]={0.10048454642157742,-0.06477906444011666,
			    -0.07123930364273548,0.19419644576045844,-0.05557999884990159,
			    -0.06189373946233846};
    taylorData at = legacy_simplex::gchi1_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gchi1  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "gchi1 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test gchi2_x */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue=1.5340569117310174;
      double mathValueD[6]={-0.06572752258736782,0.10500885807170765,
   -0.07824003437923059,-0.056271683063299445,0.19703975945664476,
   -0.06851228454381249};
    taylorData at = legacy_simplex::gchi2_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gchi2  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "gchi2 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test gchi3_x */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue=1.5793842997093803;
      double mathValueD[6]={-0.07331727287522762,-0.07936025924977397,
   0.1095205207388263,-0.06342330577935136,-0.06934245768731484,
			    0.19986093458496015};
    taylorData at = legacy_simplex::gchi3_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gchi3  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "gchi3 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test gchi4_x */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue=1.4605568345059332;
      double mathValueD[6]={0.20266073908760945,-0.05787695290919818,
   -0.06431178785046088,0.09797074520733327,-0.06145584263882206,
			    -0.06773161581432371};
    taylorData at = legacy_simplex::gchi4_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gchi4  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "gchi4 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test gchi5_x */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue=1.502995593710665;
      double mathValueD[6]={-0.05879793125270706,0.205439897510248,
   -0.07127809859377435,-0.06229860835387361,0.10257294591611826,
			    -0.07448084572888418};
    taylorData at = legacy_simplex::gchi5_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gchi5  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "gchi5 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test gchi6_x */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue=1.5488309766758375;
      double mathValueD[6]={-0.06635662384100449,-0.07239247365030564,
   0.20819909435958153,-0.06958259964677825,-0.07548117388987628,
			    0.10720235004689033};
    taylorData at = legacy_simplex::gchi6_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gchi6  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "gchi6 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test x1_delta_x */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue=671.0757000000002;
      double mathValueD[6]={253.91800000000006,
   83.18899999999998,75.48100000000002,78.679,
			    72.11899999999999,64.90300000000006};
      taylorData at = local::x1_delta_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "x1_delta_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "x1_delta_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test delta4_squared_x */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue=368.25610000000006;
      double mathValueD[6]={23.027999999999988,165.034,
   172.70999999999998,-314.716,142.00600000000006,
			    149.68199999999996};
      taylorData at = local::delta4_squared_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "delta4_squared_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "delta4_squared_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test taum */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue=0.11401488191744286;
      double mathValueD[6]={0.03794036469543799,0.03897627648849593,
   0.04008789744884282,0.060373310393189945,0.05954757563245067,
			    0.05861887751578681};
      taylorData at = legacy_simplex::taum_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "taum  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "taum D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test taum_lowform_x */   {
      domain x(4.1,4.2,4.3,13.0,4.5,4.6);
      double mValue= -0.09297193692831349;
      double mathValueD[6]={-0.24482490694251993,
   0.38015846387975194,0.38126584517884354,
   -0.3876234171705304,0.44246843996649915,
			    0.44281661177015513};
      taylorData at = legacy_simplex::tau_lowform_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "tau_lowform_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "tau_lowform_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test taum_residual_x */   {
      domain x(4.1,4.2,4.3,13.0,4.5,4.6);
      double mValue= 0.08558539613421184;
      double mathValueD[6]={-0.021776254246248725,-0.020882156617352043,-0.0203939881662909,0.009425186655158749,
			    0.004666274566526227,0.004802448355845701};
      taylorData at = legacy_simplex::tau_residual_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "tau_residual_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "tau_residual_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test selling_volume2 */   {
      domain x(4.1,4.2,4.3,13.0,4.5,4.6);
      double mValue= 2608.486;
      double mathValueD[6]={270.96,269.18999999999994,301.88,150.35,257.03999999999996,255.35};
      taylorData at = legacy_simplex::selling_volume2.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "selling_volume2  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "selling_volume2 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test selling_surface_nn */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue= 2107.160938158643;
      double mathValueD[6]={207.31409519500576,205.376230567524,203.50058898761495,201.4052168868247,199.5613135015172,197.68692136039425};
      taylorData at = legacy_simplex::selling_surface_nn.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "selling_surface_nn  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "selling_surface_nn D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test taum_x1 */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue=0.05942793337929775;
      double mathValueD[6]={0.06745481394227296,0,0,0,0,0};
      taylorData at = legacy_simplex::taum_x1("2.08","2.14").evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "taum_x1  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "taum_x1 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test sol_x_div_sqrtdelta */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue=0.04709264939663462;
      double mathValueD[6]={-0.007970124315933509,
   -0.0078097332943296155,-0.007652473097370668,
   0.0020141581396420677,0.002054235662205097,
			    0.0020953681436752004};
    taylorData at = legacy_simplex::sol_euler_x_div_sqrtdelta.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "sol_euler  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "sol_euler D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test dih_x_div_sqrtdelta_posbranch */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue=0.09505303179216332;
      double mathValueD[6]={-0.0023705608269591763,
   -0.010018211153794957,-0.00988385942104016,0.006798828382032002,
			    -0.008648206061779122,-0.008539365987877277};
    taylorData at = legacy_simplex::dih_x_div_sqrtdelta_posbranch.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "dih_x_div  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "dih_x_div D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test ldih_x_div_sqrtdelta_posbranch */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue=0.09051138456508404;
      double mathValueD[6]={-0.04739512815129222,-0.00953953961592741,
   -0.009411607227858571,0.006473979405766214,-0.0082349935598826,
			    -0.008131353880018816};
    taylorData at = legacy_simplex::ldih_x_div_sqrtdelta_posbranch.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "ldih_x_div  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "ldih_x_div D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test surfR126d */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      interval iv("1.26");
      double mValue=0.24612962297243207;
      double mathValueD[6]={-0.09070836975729879,-0.09295483666087634,
			    0,0,0,-0.05957970324319257};
      taylorData at = local::surfR126d(iv*iv).evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "surfR126d  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "surfR126d D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test surf_x */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue=0.8292709333317916;
      double mathValueD[6]={-0.039547523814608646,
   -0.042240250046217266,-0.04530842004702463,0.10392001499779156,
			    0.10117451454538572,0.09806905563554107};
      taylorData at = local::surf_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "surf_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "surf_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test halfbump_x1 */   {
    double halfd[3]={-1.2372909856488465,1.3148592857021388,-3.8264506746765212};
      epsilon3(halfd,::i_halfbump_x);
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue= -0.06665321364422902;
      double mathValueD[6]={0.07146660745052882,0,0,0,0,0};
    taylorData at = legacy_simplex::halfbump_x1.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "halfbump_x1 fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "halfbump_x1 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test halfbump_x4 */   {
      domain x(4.1,4.2,4.3,4.4,4.5,4.6);
      double mValue= -0.047139389935398804;
      double mathValueD[6]={0,0,0,0.0588482960800643,0,0};
    taylorData at = legacy_simplex::halfbump_x4.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "halfbump_x4  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-10))
	cout << "halfbump_x4 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test dih4 */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=1.1816295663326204;
    double mathValueD[6]={0.1639579615001743,-0.04682400379844412,
   -0.05202995747407655,0.050900945512886715,-0.04971942136745523,
			  -0.0547966898177983};
    taylorData at = legacy_simplex::dih4.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "dih4  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "dih4 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test dih5 */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=1.2130685583865823;
    double mathValueD[6]={-0.04745584218563276,0.16581065263975656,
   -0.05752859201151561,-0.050281240571535483,0.0540659685457473,
			  -0.060113530960320245};
    taylorData at = legacy_simplex::dih5.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "dih5  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "dih5 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test dih6 */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=1.2471258394979472;
    double mathValueD[6]={-0.05343065929090237,-0.05829075337080253,
   0.16764287016855614,-0.05602822987514417,-0.06077778903656598,
			  0.05718408426966532};
    taylorData at = legacy_simplex::dih6.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "dih6  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-12))
	cout << "dih6 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test ldih_x */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=1.1579692760682505;
    double mathValueD[6]={-0.5284984757448858,-0.050272297038852574,
   -0.055285815942576776,0.1507076628774728,-0.04313329060478024,
			  -0.04803311813761087};
    taylorData at = legacy_simplex::ldih_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "ldih_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "ldih_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test dih3_x_135_s2 */   {
    /* fj[y1_, y2_, y3_, y4_, y5_, y6_] := Dihedral3[y1, sqrt2, y3, sqrt2, y5, sqrt2];    testDataY[fj, xD] */
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=0.8978353845717557;
    double mathValueD[6]={-0.11763582712748807,0,0.04693838886383641,
			  0,-0.1291648084755952,0};
    taylorData at = legacy_simplex::dih3_x_135_s2.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "dih3_x_135_s2  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "dih3_x_135_s2 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test ldih2_x_126_s2 */   {
    /* fj[y1_, y2_, y3_, y4_, y5_, y6_] := Lfun[y2/2] Dihedral2[y1, y2, sqrt2, 
       sqrt2, sqrt2, y6]; */
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=0.7968080665440581;
      double mathValueD[6]={-0.10245354865782212,-0.37336749454984774,
			    0,0,0,-0.11599764292809825};
    taylorData at = legacy_simplex::ldih2_x_126_s2.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "ldih2_x_126_s2  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "ldih2_x_126_s2 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test ldih_x_126_n */    {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=0.8236262990441832;
      double mathValueD[6]={-0.37197051623101446,
			    -0.1065059467538398,0,0,0,-0.1182704109076129};
    taylorData at = legacy_simplex::ldih_x_126_n.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "ldih_x_126_n  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "ldih_x_126_n D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
    } 

  /* test ldih2_x_126_n */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=0.7968080665440581;
      double mathValueD[6]={-0.10245354865782212,
			    -0.37336749454984774,0,0,0,-0.11599764292809825};
    taylorData at = legacy_simplex::ldih2_x_126_n.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "ldih2_x_126_n  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "ldih2_x_126_n D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
    } 

  /* test gamma3f_x_vLR_lfun */  {
    /* fj[y1_, y2_, y3_, y4_, y5_, y6_] :=
    (Dihedral[y1, y2, y3, y4, y5, y6] - 
    Dihedral[y1, y2, sqrt2, sqrt2, sqrt2, y6] - Dihedral[y1, sqrt2, y3, sqrt2,
           y5, sqrt2]) *(vol2r[y1, sqrt2] - ((2*mm1/Pi)* 2*Pi*(1 - y1/(
            sqrt2*2)) - (8*mm2/Pi)*2*Pi*Lfun [y1/2]))/(2*Pi); */
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=-0.10478996414996176;
    double mathValueD[6]={0.02370215728957028,0.012021942974373388,
   0.01156437446193877,0.032219123924855125,0.015414868484842895,
			  0.015015719816071069};
    taylorData at = legacy_simplex::gamma3f_x_vLR_lfun.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gamma3f_x_vLR_lfun  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "gamma3f_x_vLR_lfun D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  } 

  /* test gamma3f_x_vLR0 */   {
    /* fj[y1_, y2_, y3_, y4_, y5_, y6_] :=
    (Dihedral[y1, y2, y3, y4, y5, y6] - 
    Dihedral[y1, y2, sqrt2, sqrt2, sqrt2, y6] - Dihedral[y1, sqrt2, y3, sqrt2,
           y5, sqrt2]) *(vol2r[y1, sqrt2] - ((2*mm1/Pi)* 2*Pi*(1 - y1/(
            sqrt2*2)) ))/(2*Pi); */
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=-0.07306777810008296;
    double mathValueD[6]={0.009716449167778748,0.008382641111760384,
   0.00806358847343414,0.022465699044914193,0.010748454768823143,
   0.010470137025369903};
    taylorData at = legacy_simplex::gamma3f_x_vLR0.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gamma3f_x_vLR0  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "gamma3f_x_vLR0 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test gamma3f_vLR_x_nlfun */ {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=-0.10478996414996176;
    double mathValueD[6]={0.02370215728957028,0.012021942974373388,
   0.01156437446193877,0.032219123924855125,0.015414868484842895,
			  0.015015719816071069};
    taylorData at = legacy_simplex::gamma3f_vLR_x_nlfun.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gamma3f_vLR_x_nlfun  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "gamma3f_vLR_x_nlfun D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
    } 

  /* test gamma3f_vLR_x_n0  */ {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=-0.07306777810008296;
    double mathValueD[6]={0.009716449167778748,0.008382641111760384,
   0.00806358847343414,0.022465699044914193,0.010748454768823143,
   0.010470137025369903};
    taylorData at = legacy_simplex::gamma3f_vLR_x_n0.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gamma3f_vLR_x_n0  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "gamma3f_vLR_x_n0 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
    } 

 /* test gamma3f_x_vL_lfun */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=0.06537057859213256;
    double mathValueD[6]={-0.016383158282497496,0.012021942974373388,
   -0.011819309789103422,0.032219123924855125,-0.009221275207565662,
   0.015015719816071069};
    taylorData at = legacy_simplex::gamma3f_x_vL_lfun.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gamma3f_x_vL_lfun  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "gamma3f_x_vL_lfun D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test gamma3f_vL_x_nlfun */    {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=0.06537057859213256;
    double mathValueD[6]={-0.016383158282497496,0.012021942974373388,
   -0.011819309789103422,0.032219123924855125,-0.009221275207565662,
   0.015015719816071069};
    taylorData at = legacy_simplex::gamma3f_vL_x_nlfun.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gamma3f_vL_x_nlfun  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "gamma3f_vL_x_nlfun D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
    } 

/* test gamma3f_x_vL0 */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=0.04558149217427438;
    double mathValueD[6]={-0.007175030424085833,0.008382641111760384,
   -0.008241349369396288,0.022465699044914193,-0.0064297959841076065,
			  0.010470137025369903};
    taylorData at = legacy_simplex::gamma3f_x_vL0.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gamma3f_x_vL0  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "gamma3f_x_vL0 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test gamma3f_vL_x_n0 */    {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=0.04558149217427438;
    double mathValueD[6]={-0.007175030424085833,0.008382641111760384,
   -0.008241349369396288,0.022465699044914193,-0.0064297959841076065,
			  0.010470137025369903};
    taylorData at = legacy_simplex::gamma3f_vL_x_n0.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gamma3f_vL_x_n0  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "gamma3f_vL_x_n0 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
    } 

/* test gamma3f_x_v_lfun */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=0.2353428720907426;
    double mathValueD[6]={-0.05636749908923225,-0.010747491782145005,
   -0.011819309789103422,0.032219123924855125,-0.009221275207565662,
			  -0.010268787639757223};
    taylorData at = legacy_simplex::gamma3f_x_v_lfun.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gamma3f_x_v_lfun  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "gamma3f_x_v_lfun D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

/* test gamma3f_x_v0 */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=0.16409950031812143;
    double mathValueD[6]={-0.024008337266888214,-0.0074939938288978115,
   -0.008241349369396288,0.022465699044914193,-0.0064297959841076065,
			  -0.007160203772423269};
    taylorData at = legacy_simplex::gamma3f_x_v0.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "gamma3f_x_v0  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "gamma3f_x_v0 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

/* test num_combo1 */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=106856.19915775987;
    double mathValueD[6]={129116.82713599993,-36041.29702399999,-39139.13697279997,
			  3345.7972223999877,48540.89593855997,45449.9555584};
    taylorData at = legacy_simplex::num_combo1.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "num_combo1  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "num_combo1 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

/* test num2 */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= -400514.3541760006;
    double mathValueD[6]={183303.01440000001,-141693.01760000008,-129522.33472000009,
   -283267.08224000037,92448.90214400007,103929.62816000001};
    taylorData at = legacy_simplex::num2.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "num2  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "num2 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test rat1 */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=1.0698955725351036;
    double mathValueD[6]={0.6810949663514232,
   -0.19482732187952154,-0.210306752932963,
   -0.08624960600633869,0.2017254648627028,
			  0.1903349863136786};
    taylorData at = legacy_simplex::rat1.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "rat1  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "rat1 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test rat2 */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=-0.36183739972254936;
    double mathValueD[6]={0.16560177032420434,
   -0.12800997645316778,-0.1170145946391821,
   -0.17562113079076758,0.13988551095572183,
			  0.1461089273035437};
    taylorData at = legacy_simplex::rat2.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "rat2  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "rat2 D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

/* test edge_flat2_x */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 13.47804480741523;
    double mathValueD[6]={-0.9946443990172562,
   1.0737670163683373,1.0726015670201678,0,
			  0.9263130491578268,0.927319546791744};
    taylorData at = legacy_simplex::edge_flat2_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "edge_flat2_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "edge_flat2_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

/* test edge_flat_x */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 3.671245675164661;
    double mathValueD[6]={-0.13546415672286014,0.14624014726557039,0.14608142057560067,0,0.12615786726344322,
			  0.1262949457543661};
    taylorData at = legacy_simplex::edge_flat_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "edge_flat_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "edge_flat_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test euler_3flat_x */ {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= -2.121609865784845;
    double mathValueD[6]={
   0.6737084033773958,
   0.6902589278645416,
   0.7056477507843881,
   1.0091748931784064,
   1.0227533022114286,
1.0357403437633583};
    taylorData at = legacy_simplex::euler_3flat_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "euler_3flat_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "euler_3flat_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }


  /* test euler_2flat_x */ {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 5.6594786559641665;
    double mathValueD[6]={
   1.6226216377370315,
   1.6489436803632092,
   1.6568794951410062,
   -1.0124228365658292,
   1.0227533022114286,
   1.0357403437633583
};
    taylorData at = legacy_simplex::euler_2flat_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "euler_2flat_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "euler_2flat_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test euler_1flat_x */ {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 13.232326788404254;
    double mathValueD[6]={
 2.609893335624244,
   2.550473219939409,
   2.6284065596455224,-1.0124228365658292,
			  -1.02469507659596,
1.0357403437633583
};
    taylorData at = legacy_simplex::euler_1flat_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "euler_1flat_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "euler_1flat_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test taum_3flat_x */ {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 2.2414954157837754;
    double mathValueD[6]={
   -0.2613140942120977,
   -0.2692548488515125,
   -0.2766949823571116,
   -0.24406969240041604,
   -0.25312961074090523,
   -0.26174167375093715
      };
    taylorData at = legacy_simplex::taum_3flat_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "taum_3flat_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "taum_3flat_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test taum_2flat_x */ {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 0.44100012571539665;
    double mathValueD[6]={
   -0.027483496321557374,
   -0.034059014370184104,
   -0.039499518716381576,
   0.24119388495382113,
   0.11325504246946491,
   0.10504273307028097
      };
    taylorData at = legacy_simplex::taum_2flat_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "taum_2flat_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "taum_2flat_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }


  /* test taum_1flat_x */ {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= -0.30409206340858125;
    double mathValueD[6]={
   -0.012535113352211726,
   -0.009623703088404816,
   -0.0649878713945033,
   0.2528044930489979,
   0.25286723701958674,
			 0.40754754381729874
};
    taylorData at = legacy_simplex::taum_1flat_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "taum_1flat_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "taum_1flat_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test delta_pent_x */ {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 57.81269350399995;
    double mathValueD[6]={46.989440000000016,46.4392,0,0,0,
			  -35.66664576000002};
    taylorData at = legacy_simplex::delta_pent_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "delta_pent_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "delta_pent_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

 /* test delta_126_x */  {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 166.43650000000008;
    double mathValueD[6]={22.480000000000008,
			  20.73999999999999,0,0,0,16.199999999999996};
    taylorData at = legacy_simplex::delta_126_x("4.35","4.45","4.55").evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "delta_126_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "delta_126_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
    } 

 /* test delta_234_x */  {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 166.4485000000001;
    double mathValueD[6]={0,20.74,18.840000000000007,
			  19.599999999999998,0,0};
    taylorData at = legacy_simplex::delta_234_x("4.15","4.55","4.65").evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "delta_234_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "delta_234_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
    } 

 /* test delta_135_x */  {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 166.44249999999994;
    double mathValueD[6]={22.480000000000008,0,
			  18.839999999999993,0,17.979999999999997,0};
    taylorData at = legacy_simplex::delta_135_x("4.25","4.45","4.65").evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "delta_135_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "delta_135_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
    } 

 /* test delta_sub1_x */  {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 175.299000000000;
    double mathValueD[6]={0,22.869999999999994,21.11,19.19,
			  20.169999999999995,18.530000000000005};
    taylorData at = legacy_simplex::delta_sub1_x("4.7").evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "delta_sub1_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "delta_sub1_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
    } 

 /* test taum_sub1_x */  {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 0.137542519738995;
    double mathValueD[6]={0,0.04248662450733011,
   0.0433252030616502,0.062007556887295937,
			  0.053615459466031,0.05285918091664566};
    taylorData at = legacy_simplex::taum_sub1_x("4.7").evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "taum_sub1_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "taum_sub1_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
    } 

 /* test taum_sub246_x */  {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 0.12186337970835324;
    double mathValueD[6]={0.03790121323409336,0,
			  0.03997491414775098,0,0.06066512926774336,0};
    taylorData at = legacy_simplex::taum_sub246_x("4.25","4.45","4.65").evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "taum_sub246_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "taum_sub246_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
    } 

 /* test taum_sub345_x */  {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 0.1219653222134757;
    double mathValueD[6]={0.03786131479834624,
			  0.03886158799158322,0,0,0,0.05974169184110538};
    taylorData at = legacy_simplex::taum_sub345_x("4.35","4.45","4.55").evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "taum_sub345_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "taum_sub345_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
    } 

  /* test upper_dih_x */  {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue= 1.2160734358595164;
    double mathValueD[6]={0.051435930789879736,
   -0.052794842015294,-0.058059927441134945,
   0.15826981699207354,-0.04529761712139804,
			  -0.050443306412222735};
    taylorData at = legacy_simplex::upper_dih_x.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-7))
      cout << "upper_dih_x  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-7))
	cout << "upper_dih_x D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test vol3_x_sqrt */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=0.4652359019298107;
  double mathValueD[6]={-0.0038809463071660254,
			-0.006418488123389966,0,0,0,-0.01806132704488803};
    taylorData at = legacy_simplex::vol3_x_sqrt.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "vol3_x_sqrt  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "vol3_x_sqrt D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test vol3f_x_lfun */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=0.4457211325536522;
    double mathValueD[6]={-0.02940386658560512,-0.029833252900862778,
			  0,0,0,-0.03280740250782458};
    taylorData at = legacy_simplex::vol3f_x_lfun.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "vol3f_x_lfun  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "vol3f_x_lfun D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }

  /* test vol3f_x_sqrt2_lmplus */   {
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    double mValue=0.4990241768945513;
    double mathValueD[6]={-0.05347687268458264,-0.03672605271672298,
      0,0,0,-0.040461569165859704};
    taylorData at = legacy_simplex::vol3f_x_sqrt2_lmplus.evalf(x,x); 
    if (!epsilonCloseDoubles(at.upperBound(),mValue,1.0e-8))
      cout << "vol3f_x_sqrt2_lmplus  fails " << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonCloseDoubles(at.upperPartial(i),mathValueD[i],1.0e-8))
	cout << "vol3f_x_sqrt2_lmplus D " << i << "++ fails " << at.upperPartial(i) << endl;
    }
  }
  
  /* test hasDeltaDenom */ {
    /*
    Function F1 = legacy_simplex::y1 + legacy_simplex::dih2;
    if (!F1.hasDeltaDenom()) cout << "hasDeltaDenom fails 1" << endl;
    Function F2 (legacy_simplex::y2);
    if (F2.hasDeltaDenom()) cout << "hasDeltaDenom fails 2" << endl;
    Function F3( legacy_simplex::dih);
    if (!F3.hasDeltaDenom()) cout << "hasDeltaDenom fails 3" << endl;
    */
  }
  
  /* test primitiveC1 */  {
	  Function cD = Function::compose (legacy_simplex::dih,
		   legacy_simplex::x2,legacy_simplex::x3,legacy_simplex::x1,
		   legacy_simplex::x5,legacy_simplex::x6,legacy_simplex::x4);
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    domain w(0.0,0.0,0.0,0.0,0.0,0.0);
    taylorData t = cD.evalf4(w,x,x,x); //dih2alt
    taylorData u = legacy_simplex::dih2.evalf4(w,x,x,x);
    if (!epsilonClose(t.upperBound(),u.tangentVectorOf().f,1.0e-8))
      cout << "cD1  fails " << t.upperBound() << endl;
    if (!epsilonClose(t.lowerBound(),u.tangentVectorOf().f,1.0e-8))
      cout << "cD1 fails lB "  << t.lowerBound() << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonClose(t.upperPartial(i),u.tangentVectorOf().Df[i],1.0e-14))
	cout << "cD1 " << i << "++ fails " << t.upperPartial(i) << endl;
      if (!epsilonClose(t.lowerPartial(i),u.tangentVectorOf().Df[i],1.0e-14))
	cout << "cDl1 fails " << i 	<< " " << t.lowerPartial(i) << endl;
    }
  }
  
  /* test primitiveC sums */   {
    Function cdih2 = Function::compose (legacy_simplex::dih,
		      legacy_simplex::x2,legacy_simplex::x3,legacy_simplex::x1,
		      legacy_simplex::x5,legacy_simplex::x6,legacy_simplex::x4);
    Function cdih3 = Function::compose(legacy_simplex::dih,
		      legacy_simplex::x3,legacy_simplex::x1,legacy_simplex::x2,
		      legacy_simplex::x6,legacy_simplex::x4,legacy_simplex::x5);
    Function cD = cdih2 + cdih3 * "5.6";
    //Function::Function(&cdih2) + Function::Function(&cdih3) * "5.6";           
    
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    domain w(0.0,0.0,0.0,0.0,0.0,0.0);
    taylorData t = cD.evalf4(w,x,x,x); // dih2 + 5.6 dih3;
    
    taylorData udih2 = legacy_simplex::dih2.evalf4(w,x,x,x);
    taylorData udih3 = legacy_simplex::dih3.evalf4(w,x,x,x);
    taylorData uD = taylorData::plus(udih2,taylorData::scale(udih3,"5.6"));
    
    if (!epsilonClose(t.upperBound(),uD.tangentVectorOf().f,1.0e-8))
      cout << "cD  fails " << t.upperBound() << endl;
    if (!epsilonClose(t.lowerBound(),uD.tangentVectorOf().f,1.0e-8))
      cout << "cD fails lB "  << t.lowerBound() << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonClose(t.upperPartial(i),uD.tangentVectorOf().Df[i],1.0e-12))
	cout << "cD " << i << "++ fails " << t.upperPartial(i) << endl;
      if (!epsilonClose(t.lowerPartial(i),uD.tangentVectorOf().Df[i],1.0e-12))
	cout << "cDl fails " << i 	<< " " << t.lowerPartial(i) << endl;
    }
  }
  
  /* test primitiveC mixed sums */   {
    Function tdih2 = Function::compose (legacy_simplex::dih,
		      legacy_simplex::x2,legacy_simplex::x3,legacy_simplex::x1,
		      legacy_simplex::x5,legacy_simplex::x6,legacy_simplex::x4);
    Function tdih3 = Function::compose (legacy_simplex::dih,
		      legacy_simplex::x3,legacy_simplex::x1,legacy_simplex::x2,
		      legacy_simplex::x6,legacy_simplex::x4,legacy_simplex::x5);
    //Function tdih2(&cdih2);
    //Function tdih3(&cdih3);
    Function a = tdih2 + legacy_simplex::dih3 * "5.6";           
    Function b = legacy_simplex::dih2 + tdih3 * "5.6";
    Function c = legacy_simplex::dih2 + legacy_simplex::dih3 * "5.6";
    
    domain x(4.1,4.2,4.3,4.4,4.5,4.6);
    domain w(0.0,0.0,0.0,0.0,0.0,0.0);
    taylorData at = a.evalf4(w,x,x,x); // dih2 + 5.6 dih3;
    taylorData bt = b.evalf4(w,x,x,x); // dih2 + 5.6 dih3;
    taylorData ct = c.evalf4(w,x,x,x); 
    
    if (!epsilonClose(at.upperBound(),bt.tangentVectorOf().f,1.0e-8))
      cout << "at  fails " << endl;
    if (!epsilonClose(at.upperBound(),ct.tangentVectorOf().f,1.0e-8))
      cout << "ct  fails " << endl;
    if (!epsilonClose(at.lowerBound(),bt.tangentVectorOf().f,1.0e-8))
      cout << "aD fails lB "  << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonClose(at.upperPartial(i),bt.tangentVectorOf().Df[i],1.0e-12))
	cout << "aD " << i << "++ fails " << bt.upperPartial(i) << endl;
      if (!epsilonClose(at.lowerPartial(i),bt.tangentVectorOf().Df[i],1.0e-12))
	cout << "aDl fails " << i << endl;
    }


    
    lineInterval al = a.tangentAtEstimate(x);
    lineInterval bl = b.tangentAtEstimate(x);
    lineInterval cl = c.tangentAtEstimate(x);
    //Mathematica values.
    double p[6]={-0.38640611319175094,-0.30583249983684146,
		 0.2592175068905934 ,
		 -0.3337851812245894,-0.1547313284571169,0.8519721867862138};
    if (!epsilonClose(interMath::sup(al.f),bl.f,1.0e-8))
      cout << "at'  fails " << endl;
    if (!epsilonClose(interMath::sup(al.f),cl.f,1.0e-8))
      cout << "ct'  fails " << endl;
    if (!epsilonClose(8.419942742042776,bl.f,1.0e-8))
      cout << "aD' fails lB "  << endl;
    for (int i=0;i<6;i++) {
      if (!epsilonClose(interMath::sup(al.Df[i]),bl.Df[i],1.0e-12))
	cout << "aD' " << i << "++ fails "  << endl;
      if (!epsilonClose(interMath::sup(al.Df[i]),bl.Df[i],1.0e-12))
	cout << "aDl' fails " << i << endl;
      if (!epsilonClose(p[i],bl.Df[i],1.0e-12))
	cout << "aDl' fails " << i << endl;
      
    }
    
  }
      Function p(legacy_simplex::dih);
	cout << " -- done loading legacy_simplex" << endl << flush;
  
}
