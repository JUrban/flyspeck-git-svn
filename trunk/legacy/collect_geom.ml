needs "Multivariate/vectors.ml";; (* Eventually should load entire *)


(* let DOT_BASIS_BASIS_UNEQUAL = prove(`!i j. ~(i = j) ==> (basis i) dot (basis j) = &0`,
  SIMP_TAC[basis; dot; LAMBDA_BETA] THEN ONCE_REWRITE_TAC[COND_RAND] THEN
   SIMP_TAC[SUM_0; REAL_MUL_RZERO; REAL_MUL_LZERO; COND_ID]);; *)

needs "Examples/analysis.ml";; (* multivariate-complex theory. *)	   
needs "Examples/transc.ml";; (* Then it won't need these three. *)
needs "convex_header.ml";; 
needs "definitions_kepler.ml";;
needs "geomdetail.ml";;

prioritize_real();;

let ups_x = new_definition ` ups_x x1 x2 x6 =
         --x1 * x1 - x2 * x2 - x6 * x6 +
         &2 * x1 * x6 +
         &2 * x1 * x2 +
         &2 * x2 * x6 `;;
let rho = new_definition ` rho (x12 :real) x13 x14 x23 x24 x34 =
         --(x14 * x14 * x23 * x23) -
         x13 * x13 * x24 * x24 -
         x12 * x12 * x34 * x34 +
         &2 *
         (x12 * x14 * x23 * x34 +
          x12 * x13 * x24 * x34 +
          x13 * x14 * x23 * x24) `;;
let chi = new_definition ` chi x12 x13 x14 x23 x24 x34 =
         x13 * x23 * x24 +
         x14 * x23 * x24 +
         x12 * x23 * x34 +
         x14 * x23 * x34 +
         x12 * x24 * x34 +
         x13 * x24 * x34 -
         &2 * x23 * x24 * x34 -
         x12 * x34 * x34 -
         x14 * x23 * x23 -
         x13 * x24 * x24 `;;
let delta = new_definition ` delta x12 x13 x14 x23 x24 x34 =
   --(x12 * x13 * x23) -
         x12 * x14 * x24 -
         x13 * x14 * x34 -
         x23 * x24 * x34 +
         x12 * x34 * (--x12 + x13 + x14 + x23 + x24 - x34) + 
         x13 * x24 * (x12 - x13 + x14 + x23 - x24 + x34 ) +
         x14 * x23 * ( x12 + x13 - x14 - x23 + x24 + x34 ) `;;

let eta_v = new_definition ` eta_v v1 v2 (v3: real^N) =
        let e1 = dist (v2, v3) in
  	  let e2 = dist (v1, v3) in
  	  let e3 = dist (v2, v1) in
  	  e1 * e2 * e3 / sqrt ( ups_x (e1 pow 2 ) ( e2 pow 2) ( e3 pow 2 ) ) `;;


let max_real3 = new_definition ` max_real3 x y z = max_real (max_real x y ) z `;;
let ups_x_pow2 = new_definition` ups_x_pow2 x y z = ups_x ( x*x ) ( y * y) ( z * z)`;;
let plane_norm = new_definition `
  plane_norm p <=>
         (?n v0. ~(n = vec 0) /\ p = {v | n dot (v - v0) = &0}) `;;


let delta_x34 = new_definition ` delta_x34 x12 x13 x14 x23 x24 x34  = 
-- &2 * x12 * x34 + 
(--x13 * x14 +
      --x23 * x24 +
      x13 * x24 +
      x14 * x23 +
      --x12 * x12 +
      x12 * x14 +
      x12 * x24 +
      x12 * x13 +
      x12 * x23) `;;


let plane_3p = new_definition `plane_3p (a:real^3) b c =
         {x | ~collinear {a, b, c} /\
              (?ta tb tc. ta + tb + tc = &1 /\ x = ta % a + tb % b + tc % c)}`;;


(* end new_definition *)

(* NGUYEN DUC PHUONG *)
(* Definition of Cayley � Menger square cm3 *)
let cm3_ups_x = new_definition `!(v1:real^3) (v2:real^3) (v3:real^3).
   cm3_ups_x v1 v2 v3 = 
  (((v2 - v1)$2 * (v3 - v1)$3 ) - ((v2 - v1)$3 * (v3 - v1)$2)) pow 2 +
  (((v2 - v1)$3 * (v3 - v1)$1 ) - ((v2 - v1)$1 * (v3 - v1)$3)) pow 2 +
  (((v2 - v1)$1 * (v3 - v1)$2 ) - ((v2 - v1)$2 * (v3 - v1)$1)) pow 2 `;;

(* Nguyen Tuyen Hoang, Nguyen Duc Phuong *)

(* The polynomial ups can be expressed as a Cayley- Menger square *)  

let lemma_cm3 = prove (`!(x:real^3) y. 
(x-y)$1 = x$1 - y$1 /\ (x-y)$2 = x$2 - y$2 /\ (x-y)$3 = x$3 - y$3`, 

(REPEAT GEN_TAC) THEN (REPEAT CONJ_TAC) THENL 
[(MESON_TAC[VECTOR_SUB_COMPONENT;DIMINDEX_3;ARITH_RULE `1 <= 1 /\ 1 <= 3`]);
(MESON_TAC[VECTOR_SUB_COMPONENT;DIMINDEX_3;ARITH_RULE `1 <= 2 /\ 2 <= 3`]);
(MESON_TAC[VECTOR_SUB_COMPONENT;DIMINDEX_3;ARITH_RULE `1 <= 3 /\ 3 <= 3`])]);;

let lemma7 = prove ( `! (v1 : real ^3)(v2: real^3)(v3:real^3).
  cm3_ups_x v1 v2 v3 = 
  ups_x (norm (v1 -v2) pow 2) (norm (v2 -v3) pow 2) (norm (v3 -v1) pow 2) / &4`,

 (REPEAT GEN_TAC) THEN
 (REWRITE_TAC[cm3_ups_x; ups_x]) THEN
 (REWRITE_TAC[GSYM DOT_SQUARE_NORM;DOT_3;REAL_POW_2]) THEN
 (REWRITE_TAC[lemma_cm3]) THEN
  REAL_ARITH_TAC );;

let pow_g = prove ( `! (x:real). &0 <= x pow 2`,
  GEN_TAC THEN REWRITE_TAC[REAL_POW_2; REAL_LE_SQUARE]);;

let lemma8 = prove ( `! (v1:real^3)(v2:real^3)(v3:real^3). 
&0 <= ups_x (norm (v1 - v2) pow 2)(norm (v2 - v3) pow 2)(norm (v3 - v1) pow 2)`,
 (REPEAT GEN_TAC)
THEN (MATCH_MP_TAC (REAL_ARITH `&0 <= a/ &4 ==> &0 <= a `))
THEN (REWRITE_TAC[GSYM lemma7])
THEN (REWRITE_TAC[cm3_ups_x])

THEN (ABBREV_TAC `(a:real) = (((v2:real^3) - v1)$2 * (v3 - v1)$3 - (v2 - v1)$3 * (v3 - v1)$2) pow 2`)
THEN (FIRST_X_ASSUM ((LABEL_TAC "1") o GSYM))
THEN (ABBREV_TAC `(b:real) = (((v2:real^3) - v1)$3 * (v3 - v1)$1 - (v2 - v1)$1 * (v3 - v1)$3) pow 2`)
THEN (FIRST_X_ASSUM((LABEL_TAC "2") o GSYM))
THEN (ABBREV_TAC `(c:real) = (((v2:real^3) - v1)$1 * (v3 - v1)$2 - (v2 - v1)$2 * (v3 - v1)$1) pow 2`)
THEN (FIRST_X_ASSUM((LABEL_TAC "3") o GSYM))

THEN (MATCH_MP_TAC (SPEC_ALL REAL_LE_ADD))
THEN CONJ_TAC
THEN (ASM_REWRITE_TAC[pow_g])
THEN (MATCH_MP_TAC (SPEC_ALL REAL_LE_ADD))
THEN CONJ_TAC
THEN (ASM_REWRITE_TAC[pow_g]));;

(* ========== *)
(* QUANG TRUONG *)
(* ============ *)
let GONTONG = REAL_RING ` ((a + b) + c = a + b + c ) `;;
let SUB_SUM_SUB = REAL_RING ` (a - ( b + c ) = a - b - c )/\( a - (b- c) = a - b + c )` ;;

(* lemma 4, p 7 *)
let JVUNDLC = prove(`!a b c s.
     s = (a + b + c) / &2
     ==> &16 * s * (s - a) * (s - b) * (s - c) =
         ups_x (a pow 2) (b pow 2) (c pow 2)`, SIMP_TAC [ ups_x] THEN 
REWRITE_TAC[REAL_FIELD` a / &2 - b = ( a - &2 * b ) / &2 `] THEN 
REWRITE_TAC[REAL_FIELD ` &16 * ( a / &2 ) * ( b / &2 ) * (c / &2 ) *
( d / &2 ) = a * b * c * d `] THEN REAL_ARITH_TAC);;

let SET_TAC =
   let basicthms =
    [NOT_IN_EMPTY; IN_UNIV; IN_UNION; IN_INTER; IN_DIFF; IN_INSERT;
     IN_DELETE; IN_REST; IN_INTERS; IN_UNIONS; IN_IMAGE] in
   let allthms = basicthms @ map (REWRITE_RULE[IN]) basicthms @
                 [IN_ELIM_THM; IN] in
   let PRESET_TAC =
     TRY(POP_ASSUM_LIST(MP_TAC o end_itlist CONJ)) THEN
     REPEAT COND_CASES_TAC THEN
     REWRITE_TAC[EXTENSION; SUBSET; PSUBSET; DISJOINT; SING] THEN
     REWRITE_TAC allthms in
   fun ths ->
     PRESET_TAC THEN
     (if ths = [] then ALL_TAC else MP_TAC(end_itlist CONJ ths)) THEN
     MESON_TAC[];;

 let SET_RULE tm = prove(tm,SET_TAC[]);;

(* some TRUONG TACTICS *)

let PHA = REWRITE_TAC[ MESON[] ` (a/\b)/\c <=> a/\ b /\ c `];;

let NGOAC = REWRITE_TAC[ MESON[] ` a/\b/\c <=> (a/\b)/\c `];;

let DAO = NGOAC THEN REWRITE_TAC[ MESON[]` a /\ b <=> b /\ a`];;

let PHAT = REWRITE_TAC[ MESON[] ` (a\/b)\/c <=> a\/b\/c `];;

let NGOACT =  REWRITE_TAC[ GSYM (MESON[] ` (a\/b)\/c <=> a\/b\/c `)];;

let KHANANG = PHA THEN REWRITE_TAC[ MESON[]` ( a\/ b ) /\ c <=> a /\ c \/ b /\ c `] THEN 
 REWRITE_TAC[ MESON[]` a /\ ( b \/ c ) <=> a /\ b \/ a /\ c `];;

let ATTACH thm = MATCH_MP (MESON[]` ! a b. ( a ==> b ) ==> ( a <=> a /\ b )`) thm;;

let NHANH tm = ONCE_REWRITE_TAC[ ATTACH (tm)];;
let STRIP_TR = REPEAT STRIP_TAC THEN REPEAT (FIRST_X_ASSUM MP_TAC)
      THEN REWRITE_TAC[IMP_IMP] THEN PHA;;


let elimin = REWRITE_RULE[IN];;

let CONV_EM = prove(`conv {} = {}:real^A->bool`,
  REWRITE_TAC[conv;sgn_ge;affsign;UNION_EMPTY;FUN_EQ_THM;elimin
NOT_IN_EMPTY;lin_combo;SUM_CLAUSES]
  THEN REAL_ARITH_TAC);;

let CONV_SING = prove(`!u. conv {u:real^A} = {u}`,
 REWRITE_TAC[conv;sgn_ge;affsign;FUN_EQ_THM;UNION_EMPTY;lin_combo;SUM_SING;VSUM_SING;
 elimin IN_SING] THEN REPEAT GEN_TAC THEN
 REWRITE_TAC[TAUT `(p <=> q) = ((p ==> q) /\ (q ==> p))`] THEN
 REPEAT STRIP_TAC THENL [ASM_MESON_TAC[VECTOR_MUL_LID];
 ASM_REWRITE_TAC[]] THEN EXISTS_TAC `\ (v:real^A). &1` THEN
 MESON_TAC[VECTOR_MUL_LID;REAL_ARITH `&0 <= &1`] );;

let IN_ACT_SING = SET_RULE `! a x. ({a} x <=> a = x ) /\ ( x IN {a} <=> x = a) /\ {a} a`;;

let IN_SET2 = SET_RULE `!a b x.
         (x IN {a, b} <=> x = a \/ x = b) /\ ({a, b} x <=> x = a \/ x = b)`;;

let SUM_DIS2 = prove(`! x y f. ~(x=y) ==> sum {x,y} f = f x + f y `,REWRITE_TAC[
   SET_RULE ` ~( x = y)
 <=> ~(x IN {y})`] THEN MESON_TAC[ FINITE_RULES; SUM_CLAUSES; SUM_SING]);;


let VSUM_DIS2 = prove(` ! x y f. ~(x=y) ==>  vsum {x,y} f = f x + f y`, REWRITE_TAC[
   SET_RULE ` ~( x = y)
 <=> ~(x IN {y})`] THEN MESON_TAC[ FINITE_RULES; VSUM_CLAUSES; VSUM_SING]);;

let NOV10 = prove(` ! x y. (x = y
      ==> (!x. y = x <=>
               (?a b. &0 <= a /\ &0 <= b /\ a + b = &1 /\ x = a % y + b % y))) `,
REWRITE_TAC[GSYM VECTOR_ADD_RDISTRIB] THEN 
REWRITE_TAC[ MESON[VECTOR_MUL_LID]` a + b = &1 /\ x = (a + b) % y <=> a + b = &1 /\ 
x = y`]THEN REPEAT GEN_TAC THEN DISCH_TAC THEN GEN_TAC THEN NGOAC THEN 
REWRITE_TAC[LEFT_EXISTS_AND_THM] THEN MATCH_MP_TAC (MESON[]` a ==> ( x = y <=> a /\
 y = x )`)THEN EXISTS_TAC `&0` THEN EXISTS_TAC ` &1` THEN REAL_ARITH_TAC);;


let TRUONG_LEMMA = prove
  (  `!x y x':real^N.
       (?f. x' = f x % x + f y % y /\ (&0 <= f x /\ &0 <= f y) /\
            f x + f y = &1) <=>
       (?a b. &0 <= a /\ &0 <= b /\ a + b = &1 /\ x' = a % x + b % y)`   ,
   REPEAT GEN_TAC THEN EQ_TAC 
THENL [MESON_TAC[]; STRIP_TAC] THEN
   ASM_CASES_TAC `y:real^N = x` THENL
    [EXISTS_TAC `\x:real^N. &1 / &2`;
     EXISTS_TAC `\u:real^N. if u = x then (a:real) else b`] THEN
   ASM_REWRITE_TAC[GSYM VECTOR_ADD_RDISTRIB] THEN
   CONV_TAC REAL_RAT_REDUCE_CONV);;

let CONV_SET2 = prove(` ! x y:real^A. conv {x,y} = {w | ? a b. &0 <= a /\ &0 <= b /\ a + b = &1 /\
  w = a%x + b%y}`,
ONCE_REWRITE_TAC[ MESON[] ` (! a b. P a b ) <=> ( ! a b. a = b \/ ~( a= b)
  ==> P a b )`] THEN 
REWRITE_TAC[ MESON[]` a \/ b ==> c <=> ( a==> c) /\ ( b==> c)`] THEN 
SIMP_TAC[] THEN REWRITE_TAC[ SET_RULE ` {a,a} = {a}`; CONV_SING; FUN_EQ_THM;
 IN_ELIM_THM] THEN REWRITE_TAC[ IN_ACT_SING] THEN REWRITE_TAC[NOV10] THEN 
REWRITE_TAC[conv; sgn_ge; affsign; lin_combo] THEN 
REWRITE_TAC[UNION_EMPTY; IN_SET2] THEN 
ONCE_REWRITE_TAC[ MESON[]`  ~(x = y) ==> (!x'. (?f. P f x') <=> l x') <=>
  ~(x = y) ==> (!x'. (?f. ~(x=y) /\ P f x') <=> l x')`] THEN 
REWRITE_TAC[ MESON[VSUM_DIS2; SUM_DIS2]` ~(x = y) /\x' = vsum {x, y} ff /\ l /\ 
sum {x, y} f = &1 <=> ~(x = y) /\ x' = ff x + ff y /\ l /\ f x + f y = &1 `] THEN 
REWRITE_TAC[ MESON[]` (!w. w = x \/ w = y ==> &0 <= f w) <=> &0 <= f x /\ &0 <= f y`] 
THEN ONCE_REWRITE_TAC[ GSYM (MESON[]`  ~(x = y) ==> (!x'. (?f. P f x') <=> l x') <=>
  ~(x = y) ==> (!x'. (?f. ~(x=y) /\ P f x') <=> l x')`)] THEN 
REPEAT GEN_TAC THEN DISCH_TAC THEN GEN_TAC THEN REWRITE_TAC[ TRUONG_LEMMA]);;

let LE_OF_ZPGPXNN = prove(` ! a b v v1 v2 . &0 <= a /\ &0 <= b /\ a + b = &1 /\
 v = a % v1 + b % v2  ==> dist ( v,v1) + dist (v,v2) = dist(v1,v2)`, 
SIMP_TAC[dist; REAL_ARITH ` a + b = &1 <=> b = &1 - a `] THEN 
REWRITE_TAC[VECTOR_ARITH ` (a % v1 + (&1 - a) % v2) - v1 = ( a - &1 )%( v1 - v2)`] THEN 
REWRITE_TAC[VECTOR_ARITH` (a % v1 + (&1 - a) % v2) - v2 = a % ( v1 - v2) `] THEN 
SIMP_TAC[NORM_MUL; GSYM REAL_ABS_REFL] THEN REWRITE_TAC[ REAL_ARITH ` abs ( a - &1 )
 = abs ( &1 - a ) `] THEN REAL_ARITH_TAC);;

let LENGTH_EQUA = prove(` ! v v1 v2. v IN conv {v1,v2} ==> dist (v,v1) + 
 dist (v,v2) = dist (v1,v2) `,REWRITE_TAC[CONV_SET2; IN_ELIM_THM] THEN 
MESON_TAC[LE_OF_ZPGPXNN]);;

let simp_def2 = new_axiom`(!a b v0.
          aff_gt {a, b} {v0} =
          {x | ?ta tb t.
                   ta + tb + t = &1 /\ &0 < t /\ x = ta % a + tb % b + t % v0} /\
          aff_ge {a, b} {v0} =
          {x | ?ta tb t.
                   ta + tb + t = &1 /\
                   &0 <= t /\
                   x = ta % a + tb % b + t % v0}) /\
     (!x y z.
          conv0 {x, y, z} =
          {t | ?a b c.
                   a + b + c = &1 /\
                   &0 < a /\
                   &0 < b /\
                   &0 < c /\
                   t = a % x + b % y + c % z}) /\
     (!x y z.
          affine hull {x, y, z} =
          {t | ?a b c. a + b + c = &1 /\ t = a % x + b % y + c % z})/\
 (!v1 v2 v3.
          aff_lt {v2, v3} {v1} =
          {x | ?t2 t3 t1.
                   t2 + t3 + t1 = &1 /\
                   t1 < &0 /\
                   x = t2 % v2 + t3 % v3 + t1 % v1}) `;;

(* lemma 10. p 14 *)
let ZPGPXNN = prove(`!v1 v2 v. dist (v1,v2) < dist (v,v1) + dist (v,v2) ==> 
 ~(v IN conv {v1, v2})`,
REWRITE_TAC[MESON[] `a ==> ~ b <=> ~(a /\ b )`] THEN REWRITE_TAC[CONV_SET2; IN_ELIM_THM]
THEN MESON_TAC[LE_OF_ZPGPXNN; REAL_ARITH ` a < b ==> ~ ( a = b ) `]);;

let REDUCE_T2 = MESON[]` !P Q.
     (!v1 v2 v3 t1 t2 t3. P v1 t1 v2 t2 v3 t3 <=> P v2 t2 v1 t1 v3 t3) /\
     (!v1 v2 v3. Q v1 v2 v3 <=> Q v2 v1 v3) /\
     (!v1 v2 v3 t1 t2 t3.
          ~(t1 = &0 /\ t3 = &0) /\ P v1 t1 v2 t2 v3 t3 ==> Q v1 v2 v3)
     ==> (!v1 v2 v3 t1 t2 t3.
              ~(t1 = &0 /\ t2 = &0 /\ t3 = &0) /\ P v1 t1 v2 t2 v3 t3
              ==> Q v1 v2 v3)`;;

let VEC_PER2_3 = VECTOR_ARITH `((a:real^N ) + b + c = b + a + c)/\
   ( (a:real^N ) + b + c = c + b + a )`;;
let PER2_IN3 = SET_RULE `  {a,b,c} = {b,a,c} /\ {a,b,c} = {c,b,a}`;;

let REDUCE_T3 = MESON[]`!P Q.
     (!v1 v2 v3 t1 t2 t3. P v1 t1 v2 t2 v3 t3 <=> P v3 t3 v2 t2 v1 t1) /\
     (!v1 v2 v3. Q v1 v2 v3 <=> Q v3 v2 v1) /\
     (!v1 v2 v3 t1 t2 t3. ~(t1 = &0) /\ P v1 t1 v2 t2 v3 t3 ==> Q v1 v2 v3)
     ==> (!v1 v2 v3 t1 t2 t3.
              ~(t1 = &0 /\ t3 = &0) /\ P v1 t1 v2 t2 v3 t3 ==> Q v1 v2 v3)`;;


let SUB_PACKING = prove(`!sub s.
     packing s /\ sub SUBSET s
     ==> (!x y. x IN sub /\ y IN sub /\ ~(x = y) ==> &2 <= d3 x y)`,
REWRITE_TAC[ packing; GSYM d3] THEN SET_TAC[]);;


let PAIR_EQ_EXPAND =
 SET_RULE `{a,b} = {c,d} <=> a = c /\ b = d \/ a = d /\ b = c`;;

let IN_SET3 = SET_RULE ` x IN {a,b,c} <=> x = a \/ x = b \/ x = c `;;
let IN_SET4 = SET_RULE ` x IN {a,b,c,d} <=> x = a \/ x = b \/ x = c \/ x = d `;;

(* le 8. p 13 *)
let SGFCDZO = prove(`! (v1:real^3) v2 v3 t1 t2 t3.
     t1 % v1 + t2 % v2 + t3 % v3 = vec 0 /\
     t1 + t2 + t3 = &0 /\
     ~(t1 = &0 /\ t2 = &0 /\ t3 = &0)
     ==> collinear {v1, v2, v3}`, 
ONCE_REWRITE_TAC[MESON[]` a /\ b/\c <=> c /\ a /\ b `] THEN 
MATCH_MP_TAC REDUCE_T2 THEN 
CONJ_TAC THENL [SIMP_TAC[VEC_PER2_3; REAL_ADD_AC]; CONJ_TAC THENL 
  [SIMP_TAC[PER2_IN3]; MATCH_MP_TAC REDUCE_T3]] THEN 
CONJ_TAC THENL [SIMP_TAC[REAL_ADD_AC; VEC_PER2_3]; 
CONJ_TAC THENL [SIMP_TAC[PER2_IN3];  REWRITE_TAC[]]] THEN 
REPEAT GEN_TAC THEN REWRITE_TAC[collinear] THEN 
STRIP_TAC THEN EXISTS_TAC `v2 - (v3:real^3)` THEN 
ONCE_REWRITE_TAC[MESON[]` x IN s /\ y IN s <=> 
  ( x = y \/ ~ ( x = y))/\ x IN s /\ y IN s `] THEN 
REWRITE_TAC[IN_SET3] THEN REPEAT GEN_TAC THEN 
REWRITE_TAC[MESON[]` (a \/ b) /\ c ==> d <=> (a /\ c ==> d) /\ (b /\ c ==> d)`] 
THEN CONJ_TAC THENL [DISCH_TAC THEN EXISTS_TAC `&0` THEN 
FIRST_X_ASSUM MP_TAC THEN MATCH_MP_TAC (MESON[]` (a ==> c) ==> a /\ b ==> c `) THEN 
MESON_TAC[VECTOR_MUL_LZERO; VECTOR_SUB_EQ]; STRIP_TAC] THENL [

ASM_MESON_TAC[] ;

EXISTS_TAC ` t3  / t1 ` THEN ASM_SIMP_TAC[] THEN STRIP_TR THEN 
ONCE_REWRITE_TAC[MESON[VECTOR_MUL_LCANCEL]`
  ~(t1 = &0) /\ a ==> x = y <=> ~(t1 = &0) /\ a ==> t1 % x = t1 % y`] THEN 
REWRITE_TAC[VECTOR_MUL_ASSOC] THEN SIMP_TAC[REAL_DIV_LMUL] THEN 
ONCE_REWRITE_TAC[GSYM VECTOR_SUB_EQ] THEN 
REWRITE_TAC[ VECTOR_ARITH ` ( a + b + (c:real^N) ) - vec 0 = vec 0 <=>
  a = -- ( b + c ) `; REAL_ARITH` a + b + c = &0 <=> a = -- ( b + c ) `] THEN 
SIMP_TAC[VECTOR_SUB_LDISTRIB] THEN 
MESON_TAC[VECTOR_ARITH ` --(t2 % v2 + t3 % v3) - --(t2 + t3) % v2 - 
  (t3 % v2 - t3 % v3) = vec 0`]; 

EXISTS_TAC ` ( -- t2 ) / t1 ` THEN ASM_SIMP_TAC[] THEN STRIP_TR THEN 
ONCE_REWRITE_TAC[MESON[VECTOR_MUL_LCANCEL]`
  ~(t1 = &0) /\ a ==> x = y <=> ~(t1 = &0) /\ a ==> t1 % x = t1 % y`] THEN 
REWRITE_TAC[VECTOR_MUL_ASSOC] THEN SIMP_TAC[REAL_DIV_LMUL] THEN 
ONCE_REWRITE_TAC[GSYM VECTOR_SUB_EQ] THEN 
REWRITE_TAC[ VECTOR_ARITH ` ( a + b + (c:real^N) ) - vec 0 = vec 0 <=>
  a = -- ( b + c ) `; REAL_ARITH` a + b + c = &0 <=> a = -- ( b + c ) `] THEN 
SIMP_TAC[VECTOR_SUB_LDISTRIB] THEN 
MESON_TAC[VECTOR_ARITH ` --(t2 % v2 + t3 % v3) - --(t2 + t3) % v3 - 
 (--t2 % v2 - --t2 % v3) =  vec 0`];


EXISTS_TAC ` ( -- t3) / t1 ` THEN ASM_SIMP_TAC[] THEN STRIP_TR THEN 
ONCE_REWRITE_TAC[MESON[VECTOR_MUL_LCANCEL]`
  ~(t1 = &0) /\ a ==> x = y <=> ~(t1 = &0) /\ a ==> t1 % x = t1 % y`] THEN 
REWRITE_TAC[VECTOR_MUL_ASSOC] THEN SIMP_TAC[REAL_DIV_LMUL] THEN 
ONCE_REWRITE_TAC[GSYM VECTOR_SUB_EQ] THEN 
REWRITE_TAC[ VECTOR_ARITH ` ( a + b + (c:real^N) ) - vec 0 = vec 0 <=>
  a = -- ( b + c ) `; REAL_ARITH` a + b + c = &0 <=> a = -- ( b + c ) `] THEN 
SIMP_TAC[VECTOR_SUB_LDISTRIB] THEN MESON_TAC[VECTOR_ARITH ` --(t2 + t3) % v2 
- --(t2 % v2 + t3 % v3) - (--t3 % v2 - --t3 % v3) = vec 0`];


ASM_MESON_TAC[];


EXISTS_TAC ` &1 ` THEN ASM_SIMP_TAC[VECTOR_MUL_LID];


EXISTS_TAC ` t2 / t1 ` THEN ASM_SIMP_TAC[] THEN STRIP_TR THEN 
ONCE_REWRITE_TAC[MESON[VECTOR_MUL_LCANCEL]`
  ~(t1 = &0) /\ a ==> x = y <=> ~(t1 = &0) /\ a ==> t1 % x = t1 % y`] THEN 
REWRITE_TAC[VECTOR_MUL_ASSOC] THEN SIMP_TAC[REAL_DIV_LMUL] THEN 
ONCE_REWRITE_TAC[GSYM VECTOR_SUB_EQ] THEN 
REWRITE_TAC[ VECTOR_ARITH ` ( a + b + (c:real^N) ) - vec 0 = vec 0 <=>
  a = -- ( b + c ) `; REAL_ARITH` a + b + c = &0 <=> a = -- ( b + c ) `] THEN 
SIMP_TAC[VECTOR_SUB_LDISTRIB] THEN 
MESON_TAC[VECTOR_ARITH ` --(t2 + t3) % v3 - --(t2 % v2 + t3 % v3) -
   (t2 % v2 - t2 % v3) = vec 0`];

EXISTS_TAC ` -- &1 ` THEN ASM_MESON_TAC[VECTOR_ARITH ` v3 - v2 = -- &1 % (v2 - v3)`];


ASM_MESON_TAC[]]);;


(* le 2. p 6 *)
let RHUFIIB = prove( ` !x12 x13 x14 x23 x24 x34.
         rho x12 x13 x14 x23 x24 x34 * ups_x x34 x24 x23 =
         chi x12 x13 x14 x23 x24 x34 pow 2 +
         &4 * delta x12 x13 x14 x23 x24 x34 * x34 * x24 * x23 `,
REWRITE_TAC[rho; chi; delta; ups_x] THEN REAL_ARITH_TAC);;


let RIGHT_END_POINT = prove( `!x aa bb.
     (?a b. &0 < a /\ b = &0 /\ a + b = &1 /\ x = a % aa + b % bb) <=> x = aa`,
REPEAT GEN_TAC THEN EQ_TAC THENL [STRIP_TR THEN 
REWRITE_TAC[ MESON[REAL_ARITH `b = &0 /\ a + b = &1 <=> b= &0 /\ a = &1 `]`
   b = &0 /\ a + b = &1 /\ P a b  <=>  b = &0 /\ a = &1 /\ P (&1 ) ( &0 ) `] THEN 
MESON_TAC[VECTOR_ARITH ` &1 % aa + &0 % bb = aa `];
DISCH_TAC  THEN EXISTS_TAC ` &1 ` THEN EXISTS_TAC ` &0 ` THEN 
REWRITE_TAC[REAL_ARITH ` &0 < &1 /\ &1 + &0 = &1 `] THEN 
ASM_MESON_TAC[VECTOR_ARITH ` &1 % aa + &0 % bb = aa `]]);;

let LEFT_END_POINT = prove(` !x aa bb.
     (?a b. a = &0 /\ &0 < b /\ a + b = &1 /\ x = &0 % aa + &1 % bb)
  <=> x = bb `,
REWRITE_TAC[VECTOR_ARITH ` &0 % aa + &1 % bb = bb `] THEN 
MESON_TAC[REAL_ARITH ` &0 = &0 /\ &0 < &1 /\ &0 + &1 = &1 `]);;


let CONV_CONV0 = prove(`! x a b. x IN conv {a,b} <=> x = a \/ x = b \/ x IN conv0 {a,b} `,
REWRITE_TAC[CONV_SET2; CONV0_SET2; IN_ELIM_THM] THEN 
REWRITE_TAC[REAL_ARITH ` &0 <= a <=> a = &0 \/ &0 < a `] THEN 
KHANANG THEN REWRITE_TAC[EXISTS_OR_THM] THEN 
SIMP_TAC[MESON[REAL_ARITH ` ~(a = &0 /\ b = &0 /\ a + b = &1)`]`
  ~(a = &0 /\ b = &0 /\ a + b = &1 /\ las )` ] THEN 
REWRITE_TAC[MESON[REAL_ARITH ` a = &0 /\ a + b = &1 <=> a = &0 /\ b = &1 `]`
  a = &0 /\ &0 < b /\ a + b = &1 /\ x = a % aa + b % ba <=>
     a = &0 /\ &0 < b /\ a + b = &1 /\ x = &0 % aa + &1 % ba`] THEN 
MESON_TAC[ RIGHT_END_POINT; LEFT_END_POINT]);;




let CON3_SUB_CONE3 = prove(` ! w1 v1 v2 v3. conv {v1, v2, v3} SUBSET cone w1 {v1,v2,v3}`,
REWRITE_TAC[CONV_SET3; cone; GSYM aff_ge_def; simp_def] THEN 
REWRITE_TAC[ SET_RULE ` {x | p x} SUBSET {x | q x} <=> ( ! x. p x ==> q x)`] THEN 
MESON_TAC[ REAL_ARITH ` &0 + a = a `; VECTOR_ARITH ` &0 % x + y = y `]);;



let QHSEWMI = prove (` !v1 v2 v3 w1 w2.
         ~(conv {w1, w2} INTER conv {v1, v2, v3} = {}) /\
         ~(w1 IN conv {v1, v2, v3})
         ==> w2 IN cone w1 {v1, v2, v3}`,
REWRITE_TAC[INTER_DIF_EM_EX] THEN REPEAT GEN_TAC THEN REWRITE_TAC[CONV_CONV0] THEN 
STRIP_TAC THENL [ASM_MESON_TAC[]; 
ASM_MESON_TAC[CON3_SUB_CONE3;SET_RULE`a SUBSET b <=> (! x. x IN a ==> x IN b )`];
ASM_MESON_TAC[REWRITE_RULE[INTER_DIF_EM_EX] AFF_LE_CONE ]]);;


let GONTONG = REWRITE_TAC[REAL_ARITH ` ( a + b ) + c = a + b + c `];;

(* le 27. p 20 *)
let MAEWNPU = prove(` ?b c.
         !x12 x13 x14 x23 x24 x34.
             delta x12 x13 x14 x23 x24 x34 =
             --x12 * x34 pow 2 +
             b x12 x13 x14 x23 x24 * x34 +
             c x12 x13 x14 x23 x24 `,
REWRITE_TAC[delta; REAL_ARITH ` a - b = a + -- b `; 
  REAL_ARITH ` a * (b + c )= a * b + a * c ` ] THEN 
REWRITE_TAC[REAL_ARITH ` a * b * -- c = -- a * b * c /\ -- ( a * b ) = -- a * b `] THEN 
REWRITE_TAC[REAL_ARITH` x12 * x34 * x23 + x12 * x34 * x24 +
   --x12 * x34 * x34 = x12 * x34 * x23 + x12 * x34 * x24 +
   -- x12 * ( x34 pow 2 )  `] THEN 
REWRITE_TAC[REAL_ARITH ` ( a + b ) + c = a + b + c `] THEN 
REWRITE_TAC[REAL_ARITH ` a + b * c pow 2 + d = b * c pow 2 + a + d `] THEN 
ONCE_REWRITE_TAC[REAL_ARITH `a + b + c + d + e = a + d + b + c + e `] THEN 
REWRITE_TAC[REAL_ARITH ` a * b * c = ( a * b ) * c `] THEN 
REPLICATE_TAC 30 ( ONCE_REWRITE_TAC[REAL_ARITH ` a * x pow 2 + b * x + d + e
  = a * x pow 2 + b * x + e + d `] THEN GONTONG THEN REWRITE_TAC[ REAL_ARITH 
 ` a * x pow 2 + b * x + d * x  + e = a * x pow 2 + ( b  +  d)  * x  + e`]) THEN 
REPLICATE_TAC 50 ( ONCE_REWRITE_TAC[REAL_ARITH ` a * x pow 2 + b * x + d + e
  = a * x pow 2 + b * x + e + d `] THEN GONTONG THEN ONCE_REWRITE_TAC[ REAL_ARITH ` a * x pow 2 + b * x + (d * x) * h  + e
 = a * x pow 2 + ( b  +  d * h )  * x  + e`]) THEN 
EXISTS_TAC ` (\ x12 x13 x14 x23 x24. --x13 * x14 +
          --x23 * x24 +
          x13 * x24 +
          x14 * x23 +
          --x12 * x12 +
          x12 * x14 +
          x12 * x24 +
          x12 * x13 +
          x12 * x23 ) ` THEN 
EXISTS_TAC ` (\ x12 x13 x14 x23 x24. (x14 * x23) * x12 +
         (x14 * x23) * x13 +
         (--x14 * x23) * x14 +
         (--x14 * x23) * x23 +
         (x14 * x23) * x24 +
         (--x12 * x13) * x23 +
         (--x12 * x14) * x24 +
         (x13 * x24) * x12 +
         (--x13 * x24) * x13 +
         (x13 * x24) * x14 +
         (x13 * x24) * x23 +
         (--x13 * x24) * x24 ) ` THEN 
SIMP_TAC[]);;

(* ----new ------- *)

let DELTA_COEFS = new_specification ["b_coef"; "c_coef"] MAEWNPU;;


let DELTA_X34 = prove(` !x12 x13 x14 x23 x24 x34.
     delta x12 x13 x14 x23 x24 x34 =
     --x12 * x34 pow 2 +
     (--x13 * x14 +
      --x23 * x24 +
      x13 * x24 +
      x14 * x23 +
      --x12 * x12 +
      x12 * x14 +
      x12 * x24 +
      x12 * x13 +
      x12 * x23) *
     x34 +
     (x14 * x23) * x12 +
     (x14 * x23) * x13 +
     (--x14 * x23) * x14 +
     (--x14 * x23) * x23 +
     (x14 * x23) * x24 +
     (--x12 * x13) * x23 +
     (--x12 * x14) * x24 +
     (x13 * x24) * x12 +
     (--x13 * x24) * x13 +
     (x13 * x24) * x14 +
     (x13 * x24) * x23 +
     (--x13 * x24) * x24`, REWRITE_TAC[delta] THEN REAL_ARITH_TAC);;

let C_COEF_FORMULA = prove(`! x12 x13 x14 x23 x24. c_coef x12 x13 x14 x23 x24
  = (x14 * x23) * x12 +
         (x14 * x23) * x13 +
         (--x14 * x23) * x14 +
         (--x14 * x23) * x23 +
         (x14 * x23) * x24 +
         (--x12 * x13) * x23 +
         (--x12 * x14) * x24 +
         (x13 * x24) * x12 +
         (--x13 * x24) * x13 +
         (x13 * x24) * x14 +
         (x13 * x24) * x23 +
         (--x13 * x24) * x24`, MP_TAC DELTA_COEFS THEN 
NHANH (MESON[]` (!x12 x13 x14 x23 x24 x34. p x12 x13 x14 x23 x24 x34)
  ==> (! x12 x13 x14 x23 x24. p x12 x13 x14 x23 x24 (&0) ) `) THEN 
REWRITE_TAC[DELTA_X34] THEN 
REWRITE_TAC[REAL_ARITH ` &0 pow 2 = &0 `; REAL_MUL_RZERO; REAL_ADD_LID] THEN 
SIMP_TAC[]);;

let BC_DEL_FOR = prove(` ! x12 x13 x14 x23 x24. b_coef x12 x13 x14 x23 x24 =
  --x13 * x14 +
          --x23 * x24 +
          x13 * x24 +
          x14 * x23 +
          --x12 * x12 +
          x12 * x14 +
          x12 * x24 +
          x12 * x13 +
          x12 * x23 /\ 
  c_coef x12 x13 x14 x23 x24 =
         (x14 * x23) * x12 +
         (x14 * x23) * x13 +
         (--x14 * x23) * x14 +
         (--x14 * x23) * x23 +
         (x14 * x23) * x24 +
         (--x12 * x13) * x23 +
         (--x12 * x14) * x24 +
         (x13 * x24) * x12 +
         (--x13 * x24) * x13 +
         (x13 * x24) * x14 +
         (x13 * x24) * x23 +
         (--x13 * x24) * x24 `, REWRITE_TAC[C_COEF_FORMULA] THEN 
MP_TAC DELTA_COEFS THEN NHANH (MESON[]` (!x12 x13 x14 x23 x24 x34. 
p x12 x13 x14 x23 x24 x34)
  ==> (! x12 x13 x14 x23 x24. p x12 x13 x14 x23 x24 (&1) ) `) THEN 
REWRITE_TAC[DELTA_X34; C_COEF_FORMULA] THEN 
REWRITE_TAC[REAL_ARITH ` a + b + c = a + b' + c <=> b = b' `] THEN 
SIMP_TAC[REAL_RING` a * &1 = a `]);;

let AGBWHRD = prove(` !x12 x13 x14 x23 x24 x12 x13 x14 x23 x24.
         b_coef x12 x13 x14 x23 x24 pow 2 +
         &4 * x12 * c_coef x12 x13 x14 x23 x24 =
         ups_x x12 x23 x13 * ups_x x12 x24 x14`, REWRITE_TAC[BC_DEL_FOR; ups_x] THEN 
REAL_ARITH_TAC);;


let COLLINEAR_EX = prove(` ! x y (z:real^3) . collinear {x,y,z} <=> ( ? a b c. a + b + c = &0 /\ ~ ( a = &0 /\
b = &0 /\ c = &0 ) /\ a % x + b % y + c % z = vec 0 ) `,
REWRITE_TAC[collinear] THEN 
REPEAT GEN_TAC THEN 
STRIP_TR THEN 
EQ_TAC THENL [
NHANH (SET_RULE` (!x' y'. x' IN {x, y, z} /\ y' IN {x, y, z} ==> P x' y' )
    ==> P x y /\ P x z `) THEN 
STRIP_TR THEN 
DISJ_CASES_TAC (MESON[]` c = &0 /\ c' = &0 \/ ~( c = &0 /\ c' = &0  ) `) THENL [
ASM_SIMP_TAC[VECTOR_ARITH ` x - y = &0 % t <=> y = x`] THEN 
DISCH_TAC THEN 
EXISTS_TAC ` &1 ` THEN EXISTS_TAC ` &1 ` THEN 
EXISTS_TAC ` -- &2 ` THEN 
REWRITE_TAC[REAL_ARITH ` &1 + &1 + -- &2 = &0 /\
 ~(&1 = &0 /\ &1 = &0 /\ -- &2 = &0)`; VECTOR_ARITH` &1 % x + &1 % x + 
  -- &2 % x = vec 0`];



NHANH (MESON[VECTOR_MUL_LCANCEL]` x = c % u /\
  y  = c' % u ==> c' % x = c' % (c % u) /\ c % y = c % c' % u `) THEN 
REWRITE_TAC[VECTOR_ARITH ` x = c' % c % u /\ y = c % c' % u <=>
   x = y /\ y = c % c' % u`] THEN 
REWRITE_TAC[VECTOR_ARITH ` c' % (x - y) = c % (x - z) <=> (c - c' ) % x + c' % y +
  -- c % z = vec 0 `] THEN 
ASM_MESON_TAC[REAL_ARITH ` (( c - b ) + b + -- c = &0 ) /\ (~( c = &0 ) 
   <=> ~( -- c = &0 ))`]];REWRITE_TAC[GSYM collinear] THEN MESON_TAC[SGFCDZO]]);;


let MAX_REAL_LESS_EX = prove(`!x y a. max_real x y <= a <=> x <= a /\ y <= a`,
REWRITE_TAC[max_real; COND_EXPAND; COND_ELIM_THM;COND_RAND; COND_RATOR] THEN 
REPEAT GEN_TAC THEN 
MESON_TAC[REAL_ARITH ` (~ ( b < a ) /\ b <= c ==> a <= c)`;  REAL_ARITH ` a < b /\ b <= c ==> a <= c `]);;


let MAX_REAL3_LESS_EX = prove(`! x y z a. max_real3 x y z <= a <=> x <= a /\ 
y <= a /\ z <= a `, REWRITE_TAC[max_real3; MAX_REAL_LESS_EX] THEN MESON_TAC[]);;


MESON[]` (!x y z.
          (P x y z <=> P y x z) /\
          (P x y z <=> P x z y) /\
          (Q x y z <=> Q y x z) /\
          (Q x y z <=> Q x z y)) /\
     (!x y z. P x y z ==> Q x y z)
     ==> (!x y z. P x y z ==> Q x y z /\ Q y x z /\ Q z x y)`;;
(* ========== *)

let UPS_X_SYM = prove(` ! x y z. ups_x x y z = ups_x y x z /\
  ups_x x y z = ups_x x z y `, REWRITE_TAC[ups_x] THEN REAL_ARITH_TAC);;

let PER_MUL3 = REAL_ARITH ` a*b*c = b * a * c /\ a *b *c = a * c * b `;;

let ETA_X_SYM = prove(` ! x y z. &0 <= x /\ &0 <= y /\ &0 <= z /\ &0 <= ups_x x y z ==>
  eta_x x y z = eta_x y x z /\ eta_x x y z = eta_x x z y `,
REWRITE_TAC[eta_x] THEN 
NHANH (MESON[UPS_X_SYM]` &0 <= ups_x x y z ==> &0 <= ups_x y x z 
  /\ &0 <= ups_x x z y `) THEN 
NHANH (MESON[REAL_LE_MUL]`&0 <= x /\ &0 <= y /\ &0 <= z /\ las ==> 
  &0 <= x * y * z`) THEN 
PHA THEN NHANH (MESON[REAL_LE_DIV; REAL_ARITH ` a * b * c = b * a * c 
  /\ a * b * c = a * c * b `]`
  &0 <= ups_x x y z /\ &0 <= aa /\ &0 <= bb /\ &0 <= x * y * z
     ==> &0 <= (x * y * z) / ups_x x y z /\
         &0 <= (y * x * z) / aa /\
         &0 <= (x * z * y) / bb`) THEN 
SIMP_TAC[SQRT_INJ] THEN 
MESON_TAC[UPS_X_SYM; PER_MUL3]);;

let ETA_Y_SYM = prove(` ! x y z. &0 <= ups_x (x * x) (y * y) (z * z) ==>
  eta_y x y z = eta_y y x z /\ eta_y x y z = eta_y x z y `,
REWRITE_TAC[eta_y] THEN REPEAT LET_TAC THEN MESON_TAC[ETA_X_SYM; REAL_LE_SQUARE]);;



let ETA_Y_SYMM = MESON[UPS_X_SYM; ETA_Y_SYM]` ! x y z. &0 <= ups_x (x * x) (y * y) (z * z)
   ==> eta_y x y z = eta_y x z y /\
         eta_y x y z = eta_y y x z /\
         eta_y x y z = eta_y z x y /\
         eta_y x y z = eta_y y z x /\
         eta_y x y z = eta_y z y x`;;


let IMPLY_POS = prove(`! x y z . &0 <= ups_x (x * x) (y * y) (z * z) ==>
  &0 <= ((z * z) * (x * x) * y * y) / ups_x (z * z) (x * x) (y * y) /\ 
  &0 <= ((x * x) * (y * y) * z * z) / ups_x (x * x) (y * y) (z * z) /\
  &0 <= ((y * y) * (z * z) * x * x) / ups_x (y * y) (z * z) (x * x) `, MP_TAC
 REAL_LE_SQUARE THEN MP_TAC REAL_LE_MUL THEN MESON_TAC[UPS_X_SYM; REAL_LE_DIV]);;

let POW2_COND = MESON[REAL_ABS_REFL; REAL_LE_SQUARE_ABS]` ! a b. &0 <= a /\ &0 <= b ==> 
( a <= b <=> a pow 2 <= b pow 2 ) `;;


let TRUONGG = prove(`! x y z. &0 < ups_x_pow2 z x y ==> 
 ((z * z) * (x * x) * y * y) / ups_x (z * z) (x * x) (y * y) -
    z pow 2 / &4 = ( z pow 2 * (( z pow 2 - x pow 2 - y pow 2 ) pow 2 )) 
   / (&4 * ups_x_pow2 z x y )`,
REWRITE_TAC[ups_x; ups_x_pow2] THEN CONV_TAC REAL_FIELD);;

let RE_TRUONGG = REWRITE_RULE[GSYM ups_x_pow2] TRUONGG;;

let HVXIKHW = prove(` !x y z.
         &0 <= x /\ &0 <= y /\ &0 <= z /\ &0 < ups_x_pow2 x y z
         ==> max_real3 x y z / &2 <= eta_y x y z`,
REWRITE_TAC[REAL_ARITH` a / &2 <= b <=> a <= &2 * b `; MAX_REAL3_LESS_EX] THEN 
REWRITE_TAC[eta_x; ups_x_pow2] THEN 
NHANH (REAL_ARITH` &0 < a ==> &0 <= a `) THEN 
DAO THEN REPEAT GEN_TAC THEN 
REWRITE_TAC[MESON[ETA_Y_SYMM]` &0 <= ups_x (x * x) (y * y) (z * z) /\ las
 ==> z <= &2 * eta_y x y z /\ x <= &2 * eta_y x y z /\ y <= &2 * eta_y x y z 
  <=> &0 <= ups_x (x * x) (y * y) (z * z) /\ las
 ==> z <= &2 * eta_y z x y /\ x <= &2 * eta_y x y z /\ y <= &2 * eta_y y z x`] THEN 
REWRITE_TAC[eta_y] THEN CONV_TAC (TOP_DEPTH_CONV let_CONV) THEN REWRITE_TAC[eta_x] 
THEN NHANH (SPEC_ALL IMPLY_POS) THEN 
NHANH (SPEC_ALL (prove(` ! a b x y. &0 <= a / b /\ &0 <= x /\ &0 <= y ==>
   &0 <=  &2 * sqrt ( a/b) /\ &0 <= &2 * sqrt x /\ &0 <= &2 * sqrt y `,
REWRITE_TAC[REAL_ARITH ` &0 <= &2 * a <=> &0 <= a `] THEN 
SIMP_TAC[SQRT_WORKS]))) THEN SIMP_TAC[POW2_COND] THEN 
REWRITE_TAC[REAL_ARITH ` x <= ( &2 * y ) pow 2 <=> x / &4 <= y pow 2 `] THEN 
SIMP_TAC[ SQRT_POW_2] THEN REWRITE_TAC[ GSYM ups_x_pow2] THEN 
REWRITE_TAC[REAL_FIELD` a / b <= c <=> &0 <= c - a / b `] THEN 
SIMP_TAC[ups_x_pow2; UPS_X_SYM; RE_TRUONGG] THEN DAO THEN 
MATCH_MP_TAC (MESON[]` (a4 ==> l) ==> (a1/\a2/\a3/\a4/\a5) ==> l `) THEN 
MP_TAC REAL_LE_SQUARE THEN MP_TAC REAL_LE_MUL THEN MP_TAC REAL_LE_DIV THEN 
REWRITE_TAC[GSYM REAL_POW_2] THEN MESON_TAC[REAL_ARITH ` &0 < a ==> &0 <= &4 * a `]);;


let EXISTS_INV = REAL_FIELD` ~( a = &0 ) <=> a * &1 / a = &1 /\ &1 / a * a = &1 `;;


let MIDDLE_POINT = prove(` ! x y (z:real^3) . collinear {x,y,z} ==> x IN conv {y,z} \/ 
y IN conv {x,z} \/  z IN conv {x,y} `, REWRITE_TAC[COLLINEAR_EX] THEN REPEAT 
GEN_TAC THEN 
MATCH_MP_TAC (prove(`(!(a:real) (b:real) (c:real). P a b c <=> P (--a) (--b) (--c)) /\
   ((?a b c. &0 <= a /\ P a b c) ==> l) ==>  ( ? a b c. P a b c ) ==> l `,
 DISCH_TAC THEN ASM_MESON_TAC[REAL_ARITH ` ! a. a <= &0 \/ &0 <= a`;
   REAL_ARITH ` a <= &0 <=> &0 <= -- a `])) THEN 
CONJ_TAC THENL [MESON_TAC[REAL_ARITH` a = &0 <=> -- a = &0 `; REAL_ARITH ` a + b + c = &0
  <=> --a + --b + --c = &0`; VECTOR_ARITH ` a % x + b % y + c % z = vec 0
  <=> --a % x + --b % y + --c % z = vec 0 `]; STRIP_TAC] THEN 
DISJ_CASES_TAC (REAL_ARITH ` &0 < b \/ b <= &0`) THENL
[STRIP_TR THEN REWRITE_TAC[VECTOR_ARITH ` a + b + c % z = vec 0 <=>
  --c % z = a + b `] THEN 
NHANH (MESON[VECTOR_MUL_LCANCEL]` a % x = y ==> (&1 / a) % a % x = &1 / a % y `) THEN 
REWRITE_TAC[VECTOR_ADD_LDISTRIB; VECTOR_MUL_ASSOC] THEN 
REWRITE_TAC[MESON[]` a1/\a2/\a3/\a4/\a5 ==> l <=> a1 /\ a5 /\ a2 ==>
  a3/\a4 ==> l `] THEN 
NHANH (REAL_FIELD ` &0 <= a /\ &0 < b /\ a + b + c = &0 ==> 
  a / ( -- c ) + b /( -- c ) = &1 /\ ~ ( -- c = &0 )/\ &0 < -- c `) THEN 
SIMP_TAC[EXISTS_INV] THEN 
ONCE_REWRITE_TAC[MESON[POS_EQ_INV_POS]` a /\ &0 < c <=> a /\ &0 < &1 / c `] THEN 
REWRITE_TAC[VECTOR_MUL_LID; CONV_SET2; IN_ELIM_THM; GSYM (REAL_ARITH` a / b =
   &1 / b * a `)] THEN 
ONCE_REWRITE_TAC[REAL_ARITH` a / b = &1 / b * a `] THEN 
MP_TAC (GEN_ALL (MESON[REAL_ARITH`( a * &1 = a ) /\ ( &0 < a ==> &0 <= a )`; 
 REAL_LE_MUL]` &0 < &1 / c * &1 /\ ( &0 <= a \/ &0 < a ) ==> &0 <= &1 / c * a `)) THEN 
MESON_TAC[]; STRIP_TR THEN 
NHANH (MESON[REAL_ARITH` &0 <= c \/ c <= &0`]` a + b + v = &0 ==>
  &0 <= v \/ v <= &0 `) THEN 
REWRITE_TAC[MESON[]` a1/\(a2 /\ (aa\/ bb))/\ dd <=>
  (aa\/bb) /\ a1/\a2/\dd`] THEN SPEC_TAC (`a:real`, `a:real`) THEN 
SPEC_TAC (`b:real`, `b:real`) THEN SPEC_TAC (`c:real`, `c:real`) THEN 
KHANANG THEN REWRITE_TAC[(prove( `&0 <= c /\ &0 <= a /\ a + b + c = &0 /\
 ~(a = &0 /\ b = &0 /\ c = &0) /\ a % x + b % y + c % z = vec 0 /\
 b <= &0 <=> --a <= &0 /\ &0 <= --b /\ --b + --c + --a = &0 /\
 ~(--b = &0 /\ --c = &0 /\ --a = &0) /\ --b % y + --c % z + -- a % x = vec 0 /\
 --c <= &0`, MESON_TAC[
REAL_ARITH ` (a = &0 <=> --a = &0) /\ ( b <= &0 <=> &0 <= -- b ) /\
     (&0 <= a <=> --a <= &0) /\
     (a + b + c = &0 <=> --b + --c + -- a = &0)`;
VECTOR_ARITH` a % x + b % y + c % z = vec 0 <=> 
 --b % y + --c % z + --a % x = vec 0 `]))] THEN 
REWRITE_TAC[MESON[]` a \/ b ==> c <=> (a ==> c) /\(b==>c)`] THEN 
REWRITE_TAC[MESON[REAL_ARITH `&0 <= a <=> a = &0 \/ &0 < a `]`
  c <= &0 /\ &0 <= a /\ l <=> ( a = &0 \/ &0 < a ) /\ c <= &0 /\ l`] THEN 
KHANANG THEN 
REWRITE_TAC[MESON[REAL_ARITH `a = &0 /\ c <= &0 /\ a + b + c = &0 /\ b <= &0
     ==> a = &0 /\ b = &0 /\ c = &0`]`a = &0 /\      c <= &0 /\
      a + b + c = &0 /\ ~(a = &0 /\ b = &0 /\ c = &0) /\a2/\ b <= &0 <=> F `] THEN 
NHANH (MESON[REAL_FIELD ` &0 < a /\
         a + b + c = &0 ==> -- b / a + -- c / a = &1 `]`&0 < a /\      c <= &0 /\
      a + b + c = &0 /\ l ==> --b / a + --c / a = &1 `) THEN 
REWRITE_TAC[VECTOR_ARITH `  a % x + b % y + c % z = vec 0 <=>
  a % x = -- b % y + -- c % z `] THEN 
NHANH (MESON[VECTOR_MUL_LCANCEL]` a % x = y ==> &1 / a % a % x = &1 / a % y `) THEN 
REWRITE_TAC[VECTOR_ADD_LDISTRIB; VECTOR_MUL_ASSOC; REAL_ARITH ` &1 / a * b 
  = b / a `;VECTOR_MUL_LID ] THEN PHA THEN 
PURE_ONCE_REWRITE_TAC[MESON[REAL_FIELD ` &0 < a ==> a / a = &1`]`
   &0 < a /\ P ( a / a) <=> &0 < a /\ P ( &1 ) `] THEN 
REWRITE_TAC[VECTOR_MUL_LID ] THEN 
REWRITE_TAC[MESON[SET_RULE ` {a,b} = {b,a}`]` y IN conv {x, z} \/ z IN conv {x, y}
  <=> y IN conv {z,x} \/ z IN conv {x,y} `] THEN 
REWRITE_TAC[CONV_SET2; IN_ELIM_THM] THEN 
REWRITE_TAC[ REAL_ARITH ` a <= &0 <=> &0 <= -- a `] THEN 
MESON_TAC[REAL_LE_DIV; REAL_ARITH ` &0 < a ==> &0 <= a `]]);;

(* 
let REAL_SQRTSOSFIELD =
 let inv_tm = `inv:real->real`
 and sqrt_tm = `sqrt:real->real` in
 let prenex_conv =
   TOP_DEPTH_CONV BETA_CONV THENC
   PURE_REWRITE_CONV[FORALL_SIMP; EXISTS_SIMP; real_div;
                     REAL_INV_INV; REAL_INV_MUL; GSYM REAL_POW_INV] THENC
   NNFC_CONV THENC DEPTH_BINOP_CONV `(/\)` CONDS_CELIM_CONV THENC
   PRENEX_CONV
 and setup_conv = NNF_CONV THENC WEAK_CNF_CONV THENC CONJ_CANON_CONV
 and core_rule t =
   try REAL_ARITH t
   with Failure _ -> try REAL_RING t
   with Failure _ -> REAL_SOS t
 and is_inv =
   let is_div = is_binop `(/):real->real->real` in
   fun tm -> (is_div tm or (is_comb tm & rator tm = inv_tm)) &
             not(is_ratconst(rand tm))
 and is_sqrt tm = is_comb tm & rator tm = sqrt_tm in
 let SQRT_HYP_THM = prove
  (`!x. &0 <= x ==> &0 <= sqrt x /\ (sqrt x) * (sqrt x) = x`,
   MESON_TAC[SQRT_POS_LE; SQRT_POW_2; REAL_POW_2]) in
 let BASIC_REAL_FIELD tm =
   let is_freeinv t = is_inv t & free_in t tm
   and is_freesqrt t = is_sqrt t & free_in t tm in
   let itms = setify(map rand (find_terms is_freeinv tm)) in
   let hyps = map (fun t -> SPEC t REAL_MUL_RINV) itms in
   let tm' = itlist (fun th t -> mk_imp(concl th,t)) hyps tm in
   let itms' = map (curry mk_comb inv_tm) itms in
   let gvs = map (genvar o type_of) itms' in
   let tm'' = subst (zip gvs itms') tm' in
   let stms = setify(map rand (find_terms is_freesqrt tm'')) in
   let syps =  map (fun t -> SPEC t SQRT_HYP_THM) stms in
   let tm''' = itlist (fun th t -> mk_imp(concl th,t)) syps tm'' in
   let stms' = map (curry mk_comb sqrt_tm) stms in
   let hvs = map (genvar o type_of) stms' in
   let tm'''' = subst (zip hvs stms') tm''' in
   let th1 = setup_conv tm'''' in
   let cjs = conjuncts(rand(concl th1)) in
   let ths = map core_rule cjs in
   let th2 = EQ_MP (SYM th1) (end_itlist CONJ ths) in
   rev_itlist (C MP) (syps @ hyps)
              (INST (zip itms' gvs @ zip stms' hvs) th2) in
 fun tm ->
   let th0 = prenex_conv tm in
   let tm0 = rand(concl th0) in
   let avs,bod = strip_forall tm0 in
   let th1 = setup_conv bod in
   let ths = map BASIC_REAL_FIELD (conjuncts(rand(concl th1))) in
   EQ_MP (SYM th0) (GENL avs (EQ_MP (SYM th1) (end_itlist CONJ ths)));;

*)
let IN_CONV_COLLINEAR = prove(` ! (v:real^3) v1 v2. v IN conv {v1,v2} ==> 
collinear {v,v1,v2} `, REWRITE_TAC[COLLINEAR_EX] THEN 
REWRITE_TAC[COLLINEAR_EX; CONV_SET2; IN_ELIM_THM] THEN 
REWRITE_TAC[VECTOR_ARITH ` v = a % v1 + b % v2 <=> 
   &1 % v + -- a % v1 + -- b % v2 = vec 0 `] THEN 
MESON_TAC[REAL_ARITH `~ ( &1 = &0 ) /\ (a + b = &1 <=> &1 + --a + --b = &0 )`]);;

let COLLINERA_AS_IN_CONV2 = prove(` ! x y (z:real^3) . collinear {x,y,z} <=> 
x IN conv {y,z} \/ 
y IN conv {x,z} \/  z IN conv {x,y}`, 
MESON_TAC[PER_SET3; IN_CONV_COLLINEAR; MIDDLE_POINT]);;


let LENGTH_EQ_EX = prove(`!v v1 v2.
     dist (v1,v) + dist (v,v2) = dist (v1,v2) <=>
     ~(dist (v1,v2) < dist (v1,v) + dist (v,v2))`,
REPEAT GEN_TAC THEN 
REWRITE_TAC[REAL_ARITH ` ~( a < b) <=> b <= a `] THEN 
EQ_TAC THENL [REAL_ARITH_TAC; 
NHANH (MESON[DIST_TRIANGLE]` dist (v1,v) + dist (v,v2) <= dist (v1,v2)
  ==> dist(v1,v2) <= dist (v1,v) + dist (v,v2)`) THEN 
REAL_ARITH_TAC]);;


let BETWEEN_IMP_IN_CONVEX_HULL = new_axiom` !v v1 v2. dist(v1,v) + dist(v,v2) = 
dist(v1,v2)
 ==> (?a b. &0 <= a /\ &0 <= b /\ a + b = &1 /\  v = a % v1 + b % v2)`;;
(* HARRISON have proved this lemma as following, but it must be loaded after convex.ml *)
(*   let BETWEEN_IFF_IN_CONVEX_HULL = prove
  (`!v v1 v2:real^N.
         dist(v1,v) + dist(v,v2) = dist(v1,v2) <=> v IN convex hull {v1,v2}`,
   REPEAT GEN_TAC THEN ASM_CASES_TAC  `v1:real^N = v2` THENL
    [ASM_REWRITE_TAC[INSERT_AC; CONVEX_HULL_SING; IN_SING] THEN NORM_ARITH_TAC;
     REWRITE_TAC[CONVEX_HULL_2_ALT; IN_ELIM_THM] THEN EQ_TAC THENL
      [DISCH_TAC THEN EXISTS_TAC `dist(v1:real^N,v) / dist(v1,v2)` THEN
       ASM_SIMP_TAC[REAL_LE_LDIV_EQ; REAL_LE_RDIV_EQ; DIST_POS_LT] THEN CONJ_TAC
       THENL [FIRST_ASSUM(SUBST1_TAC o SYM) THEN NORM_ARITH_TAC; ALL_TAC] THEN
       MATCH_MP_TAC VECTOR_MUL_LCANCEL_IMP THEN
       EXISTS_TAC `dist(v1:real^N,v2)` THEN
       ASM_SIMP_TAC[VECTOR_MUL_ASSOC; VECTOR_ADD_LDISTRIB; REAL_SUB_LDISTRIB;
                    REAL_DIV_LMUL; DIST_EQ_0] THEN
       FIRST_ASSUM(MP_TAC o GEN_REWRITE_RULE I [DIST_TRIANGLE_EQ] o SYM) THEN
       FIRST_ASSUM(SUBST1_TAC o SYM) THEN
       REWRITE_TAC[dist; REAL_ARITH `(a + b) * &1 - a = b`] THEN
       VECTOR_ARITH_TAC;
       STRIP_TAC THEN ASM_REWRITE_TAC[dist] THEN
       REWRITE_TAC[VECTOR_ARITH `a - (a + b:real^N) = --b`;
                   VECTOR_ARITH `(a + u % (b - a)) - b = (&1 - u) % (a - b)`;
                   NORM_NEG; NORM_MUL; GSYM REAL_ADD_LDISTRIB] THEN
       REWRITE_TAC[NORM_SUB] THEN REPEAT(POP_ASSUM MP_TAC) THEN
       CONV_TAC REAL_FIELD]]);;

From this, your version follows easily:

 let BETWEEN_IMP_IN_CONVEX_HULL = prove
  (`!v v1 v2. dist(v1,v) + dist(v,v2) = dist(v1,v2)
              ==> (?a b. &0 <= a /\ &0 <= b /\ a + b = &1 /\
                         v = a % v1 + b % v2)`,
   REWRITE_TAC[BETWEEN_IFF_IN_CONVEX_HULL; CONVEX_HULL_2; IN_ELIM_THM] THEN
   REWRITE_TAC[CONJ_ASSOC]);;
*)



let PRE_HE = prove(` ! x y z. let p = ( x + y + z ) / &2 in
  ups_x_pow2 x y z = &16 * p * ( p - x ) * ( p - y ) * ( p - z ) `,
CONV_TAC (TOP_DEPTH_CONV let_CONV) THEN 
REWRITE_TAC[ups_x_pow2; ups_x] THEN REAL_ARITH_TAC);;

let PRE_HER = prove(`!x y z.
     ups_x_pow2 x y z =
     &16 *
     (x + y + z) / &2 *
     ((x + y + z) / &2 - x) *
     ((x + y + z) / &2 - y) *
     ((x + y + z) / &2 - z)`, 
REWRITE_TAC[ups_x_pow2; ups_x] THEN REAL_ARITH_TAC);;


let TRIVIVAL_LE = prove(`!v1 v2 v3.
     ~(v2 = v3 /\ v1 = v2)
     ==> ~(dist (v1,v2) + dist (v1,v3) + dist (v2,v3) = &0)`,
SIMP_TAC[DE_MORGAN_THM; DIST_NZ] THEN 
NHANH (MESON[DIST_POS_LE]`&0 < dist (v2,v3) \/ &0 < dist (v1,v2) ==>
  &0 <= dist(v1,v3) `) THEN MP_TAC DIST_POS_LE THEN KHANANG THEN 
REWRITE_TAC[OR_IMP_EX] THEN 
NHANH (MESON[DIST_POS_LE]`&0 < dist (v2,v3) /\ &0 <= dist (v1,v3)
  ==> &0 <= dist(v1,v2) `) THEN 
SIMP_TAC[REAL_ARITH`( &0 < a /\ &0 <= b ) /\ &0 <= c ==> ~(c + b + a = &0 ) `] THEN 
NHANH (MESON[DIST_POS_LE]`&0 < dist (v1,v2) /\ &0 <= dist (v1,v3) ==>
  &0 <= dist(v2,v3) `) THEN 
MESON_TAC[REAL_ARITH ` &0 < a /\ &0 <= b /\ &0 <= c ==> ~( a + b + c = &0 ) `]);;



let MID_COND = prove(` ! v v1 v2. v IN conv {v1,v2} <=> dist(v1,v) + dist(v,v2)
 = dist(v1,v2) `, REPEAT GEN_TAC THEN EQ_TAC THENL [MESON_TAC[LENGTH_EQUA; DIST_SYM];
REWRITE_TAC[CONV_SET2; IN_ELIM_THM] THEN 
MESON_TAC[DIST_SYM; BETWEEN_IMP_IN_CONVEX_HULL]]);;


(* lemma 9. p 13 *)
let FHFMKIY = prove(`!(v1:real^3) v2 v3 x12 x13 x23.
         x12 = dist (v1,v2) pow 2 /\
         x13 = dist (v1,v3) pow 2 /\
         x23 = dist (v2,v3) pow 2
         ==> (collinear {v1, v2, v3} <=> ups_x x12 x13 x23 = &0)`,
REPEAT STRIP_TAC THEN ASM_SIMP_TAC[] THEN REWRITE_TAC[COLLINERA_AS_IN_CONV2]
 THEN REWRITE_TAC[REAL_ARITH ` x pow 2 = x * x `; GSYM ups_x_pow2] THEN 
REWRITE_TAC[PRE_HER] THEN REWRITE_TAC[REAL_ENTIRE] THEN 
ONCE_REWRITE_TAC[MESON[]`( v1 IN conv {v2, v3} \/ a \/ b <=> l ) <=> 
(v1 = v2 /\ v1 = v3 ) \/  ~(v1 = v2 /\ v1 = v3) ==> ( v1 IN conv {v2, v3} 
\/ a \/ b <=> l )`] THEN REWRITE_TAC[OR_IMP_EX] THEN 
SIMP_TAC[DIST_SYM; DIST_REFL; MESON[]` a= b/\ a= c <=> b = c /\ a= b`] THEN 
SIMP_TAC[SET_RULE ` {a,a} = {a} /\ a IN {a} `; CONV_SING;
   REAL_ARITH ` (&0 + &0 + &0)/ &2 = &0 `] THEN SIMP_TAC[ TRIVIVAL_LE; 
REAL_ARITH `~( &16 = &0) /\(~( a = &0) ==> ~( a / &2 = &0))`] THEN 
REWRITE_TAC[REAL_ARITH ` (a+ b + c ) / &2 - a = &0 <=> b + c = a `] THEN 
REWRITE_TAC[REAL_ARITH ` (a+ b + c ) / &2 - b = &0 <=> c + a = b  `] THEN 
REWRITE_TAC[REAL_ARITH ` (a+ b + c ) / &2 - c = &0 <=> a + b = c `] THEN 
REWRITE_TAC[MESON[SET_RULE `{a,b} = {b,a} `]`v2 IN conv {v1, v3} \/ v3 IN 
conv {v1, v2}  <=> v2 IN conv {v3,v1} \/ v3 IN conv {v1, v2}`] THEN 
REWRITE_TAC[MID_COND] THEN MESON_TAC[DIST_SYM]);;

(* le 11. p 14 *)
(* NGUYEN QUANG TRUONG *)


(* These following lemma are Multivariate/convex.ml *)
let AFFINE_HULL_EXPLICIT = new_axiom` 
  !p. affine hull p =
     {y | ?s u.
              FINITE s /\
              ~(s = {}) /\
              s SUBSET p /\
              sum s u = &1 /\
              vsum s (\v. u v % v) = y}` ;;

let affine_dependent = new_definition
 `affine_dependent (s:real^N -> bool) <=>
        ?x. x IN s /\ x IN (affine hull (s DELETE x))`;;

let AFFINE_DEPENDENT_EXPLICIT_FINITE = new_axiom
`!s. FINITE(s:real^N -> bool)
       ==> (affine_dependent s <=>
            ?u. sum s u = &0 /\
                (?v. v IN s /\ ~(u v = &0)) /\
                vsum s (\v. u v % v) = vec 0)`;;

 let AFFINE_HULL_FINITE = prove
  (`!s:real^N->bool.
       FINITE s
       ==> affine hull s = {y | ?u. sum s u = &1 /\ vsum s (\v. u v % v) = y}`,
   GEN_TAC THEN DISCH_TAC THEN
   REWRITE_TAC[EXTENSION; AFFINE_HULL_EXPLICIT; IN_ELIM_THM] THEN
   X_GEN_TAC `x:real^N` THEN EQ_TAC THEN REWRITE_TAC[LEFT_IMP_EXISTS_THM] THENL
    [MAP_EVERY X_GEN_TAC [`t:real^N->bool`; `f:real^N->real`] THEN
     STRIP_TAC THEN
     EXISTS_TAC `\x:real^N. if x IN t then f x else &0` THEN
     REWRITE_TAC[] THEN ONCE_REWRITE_TAC[COND_RAND] THEN
     ONCE_REWRITE_TAC[COND_RATOR] THEN REWRITE_TAC[VECTOR_MUL_LZERO] THEN
     ASM_SIMP_TAC[GSYM VSUM_RESTRICT_SET; GSYM SUM_RESTRICT_SET] THEN
     ASM_SIMP_TAC[SET_RULE `t SUBSET s ==> {x | x IN s /\ x IN t} = t`];
     X_GEN_TAC `f:real^N->real` THEN
     ASM_CASES_TAC `s:real^N->bool = {}` THEN
     ASM_REWRITE_TAC[SUM_CLAUSES; REAL_OF_NUM_EQ; ARITH] THEN STRIP_TAC THEN
     MAP_EVERY EXISTS_TAC [`s:real^N->bool`; `f:real^N->real`] THEN
     ASM_REWRITE_TAC[GSYM EXTENSION; SUBSET_REFL]]);;

 let IN_AFFINE_HULL_IMP_COLLINEAR = prove
  (`!a b c:real^N. a IN (affine hull {b,c}) ==> collinear {a,b,c}`,
   REPEAT GEN_TAC THEN MAP_EVERY ASM_CASES_TAC
    [`a:real^N = b`; `a:real^N = c`; `b:real^N = c`] THEN
   TRY(ASM_REWRITE_TAC[INSERT_AC; COLLINEAR_SING; COLLINEAR_2] THEN NO_TAC) THEN
   SIMP_TAC[AFFINE_HULL_FINITE; FINITE_INSERT; FINITE_SING] THEN
   SIMP_TAC[SUM_CLAUSES; VSUM_CLAUSES; FINITE_RULES; REAL_ADD_RID] THEN
   ASM_REWRITE_TAC[IN_INSERT; IN_ELIM_THM; NOT_IN_EMPTY; VECTOR_ADD_RID] THEN
   DISCH_THEN(X_CHOOSE_THEN `f:real^N->real` STRIP_ASSUME_TAC) THEN
   ONCE_REWRITE_TAC[SET_RULE `{a,b,c} = {c,b,a}`] THEN
   ASM_REWRITE_TAC[COLLINEAR_3; COLLINEAR_LEMMA; VECTOR_SUB_EQ] THEN
   EXISTS_TAC `(f:real^N->real) c` THEN EXPAND_TAC "a" THEN
   FIRST_X_ASSUM(SUBST1_TAC o MATCH_MP (REAL_ARITH
    `b + c = &1 ==> b = &1 - c`)) THEN VECTOR_ARITH_TAC);;


 let AFFINE_DEPENDENT_3_IMP_COLLINEAR = prove
  (`!a b c:real^N. affine_dependent{a,b,c} ==> collinear{a,b,c}`,
   REPEAT GEN_TAC THEN
   MAP_EVERY ASM_CASES_TAC
    [`a:real^N = b`; `a:real^N = c`; `b:real^N = c`] THEN
   TRY(ASM_REWRITE_TAC[INSERT_AC; COLLINEAR_SING; COLLINEAR_2] THEN NO_TAC) THEN
   REWRITE_TAC[affine_dependent; IN_INSERT; NOT_IN_EMPTY] THEN STRIP_TAC THEN
   FIRST_X_ASSUM SUBST_ALL_TAC THENL
    [ALL_TAC;
     ONCE_REWRITE_TAC[SET_RULE `{a,b,c} = {b,a,c}`];
     ONCE_REWRITE_TAC[SET_RULE `{a,b,c} = {c,b,a}`]] THEN
   MATCH_MP_TAC IN_AFFINE_HULL_IMP_COLLINEAR THEN
   FIRST_X_ASSUM(MATCH_MP_TAC o MATCH_MP (MESON[]
    `x IN s ==> s = t ==> x IN t`)) THEN
   AP_TERM_TAC THEN ASM SET_TAC[]);;

(* LEMMA 11 *)
let FAFKVLR = prove
 (`!v1 v2 v3 v:real^N.
       ~collinear{v1,v2,v3} /\ v IN (affine hull {v1,v2,v3})

       ==> ?t1 t2 t3. v = t1 % v1 + t2 % v2 + t3 % v3 /\
                      t1 + t2 + t3 = &1 /\
                      !ta tb tc. v = ta % v1 + tb % v2 + tc % v3 /\

                                 ta + tb + tc = &1
                                 ==> ta = t1 /\ tb = t2 /\ tc = t3`,
 REPEAT GEN_TAC THEN
 MAP_EVERY ASM_CASES_TAC
  [`v1:real^N = v2`; `v2:real^N = v3`; `v1:real^N = v3`] THEN
 TRY(ASM_REWRITE_TAC[INSERT_AC; COLLINEAR_SING; COLLINEAR_2] THEN NO_TAC) THEN
 SIMP_TAC[AFFINE_HULL_FINITE; FINITE_INSERT; FINITE_SING; IN_ELIM_THM] THEN
 DISCH_THEN(CONJUNCTS_THEN2 ASSUME_TAC MP_TAC) THEN
 SIMP_TAC[SUM_CLAUSES; VSUM_CLAUSES; FINITE_INSERT; FINITE_SING;
          SUM_SING; VSUM_SING] THEN
 ASM_REWRITE_TAC[IN_INSERT; NOT_IN_EMPTY; LEFT_IMP_EXISTS_THM] THEN
 X_GEN_TAC `f:real^N->real` THEN STRIP_TAC THEN
 MAP_EVERY EXISTS_TAC
  [`(f:real^N->real) v1`; `(f:real^N->real) v2`; `(f:real^N->real) v3`] THEN
 ASM_REWRITE_TAC[] THEN REPEAT GEN_TAC THEN EXPAND_TAC "v" THEN
 DISCH_TAC THEN MATCH_MP_TAC(TAUT `(~p ==> F) ==> p`) THEN DISCH_TAC THEN
 UNDISCH_TAC `~collinear{v1:real^N,v2,v3}` THEN REWRITE_TAC[] THEN
 MATCH_MP_TAC AFFINE_DEPENDENT_3_IMP_COLLINEAR THEN
 SIMP_TAC[AFFINE_DEPENDENT_EXPLICIT_FINITE; FINITE_INSERT; FINITE_RULES;
          SUM_CLAUSES; VSUM_CLAUSES] THEN
 ASM_REWRITE_TAC[IN_INSERT; NOT_IN_EMPTY] THEN
 EXISTS_TAC `\x. if x = v1 then f v1 - ta
                 else if x = v2 then f v2 - tb
                 else (f:real^N->real) v3 - tc` THEN
 ASM_REWRITE_TAC[REAL_ADD_RID; VECTOR_ADD_RID] THEN REPEAT CONJ_TAC THENL
  [ASM_REAL_ARITH_TAC;
   ASM_REWRITE_TAC[EXISTS_OR_THM; RIGHT_OR_DISTRIB; UNWIND_THM2] THEN
   ASM_REWRITE_TAC[REAL_SUB_0] THEN ASM_MESON_TAC[];
   ASM_REWRITE_TAC[VECTOR_ARITH
    `(a - a') % x + (b - b') % y + (c - c') % z = vec 0 <=>
     a % x + b % y + c % z = a' % x + b' % y + c' % z`] THEN
   ASM_MESON_TAC[]]);;



 let FAFKVLR_ALT = prove
  (`!v1 v2 v3 v:real^N.
         ~collinear{v1,v2,v3} /\ v IN (affine hull {v1,v2,v3})
         ==> ?!(t1,t2,t3). v = t1 % v1 + t2 % v2 + t3 % v3 /\
                           t1 + t2 + t3 = &1`,
   REWRITE_TAC(map(REWRITE_RULE[ETA_AX])
    [EXISTS_UNIQUE; FORALL_PAIR_THM; EXISTS_PAIR_THM]) THEN
   REWRITE_TAC[PAIR_EQ; GSYM CONJ_ASSOC; FAFKVLR]);;


let equivalent_lemma = prove(` (?t1 t2 t3.
         !v1 v2 v3 (v:real^N).
             v IN affine hull {v1, v2, v3} /\ ~collinear {v1, v2, v3}
             ==> v =
                 t1 v1 v2 v3 v % v1 + t2 v1 v2 v3 v % v2 + t3 v1 v2 v3 v % v3 /\
                 t1 v1 v2 v3 v + t2 v1 v2 v3 v + t3 v1 v2 v3 v = &1 /\
                 (!ta tb tc.
                      v = ta % v1 + tb % v2 + tc % v3 /\ ta + tb + tc = &1 
                      ==> ta = t1 v1 v2 v3 v /\
                          tb = t2 v1 v2 v3 v /\
                          tc = t3 v1 v2 v3 v))  <=>
     
          ( !v1 v2 v3 (v:real^N).
             v IN affine hull {v1, v2, v3} /\ ~collinear {v1, v2, v3}
          ==> (?t1 t2 t3.
                   v = t1 % v1 + t2 % v2 + t3 % v3 /\
                   t1 + t2 + t3 = &1 /\
                   (!ta tb tc.
                        v = ta % v1 + tb % v2 + tc % v3 /\ ta + tb + tc = &1
                        ==> ta = t1 /\ tb = t2 /\ tc = t3))) `,
REWRITE_TAC[GSYM SKOLEM_THM; LEFT_FORALL_IMP_THM; RIGHT_EXISTS_IMP_THM]);;


 let LAMBDA_TRIPLED_THM = prove
  (`!t. (\(x,y,z). t x y z) = (\p. t (FST p) (FST(SND p)) (SND(SND p)))`,
   REWRITE_TAC[FUN_EQ_THM; FORALL_PAIR_THM]);;

 let FORALL_TRIPLED_THM = prove
  (`!P. (!(x,y,z). P x y z) <=> (!x y z. P x y z)`,
   REWRITE_TAC[LAMBDA_TRIPLED_THM] THEN REWRITE_TAC[FORALL_PAIR_THM]);;

 let EXISTS_TRIPLED_THM = prove
  (`!P. (?(x,y,z). P x y z) <=> (?x y z. P x y z)`,
   REWRITE_TAC[LAMBDA_TRIPLED_THM] THEN REWRITE_TAC[EXISTS_PAIR_THM]);;

 let EXISTS_UNIQUE_TRIPLED_THM = prove
  (`!P. (?!(x,y,z). P x y z) <=>
        (?x y z. P x y z /\
                 (!x' y' z'. P x' y' z' ==> x' = x /\ y' = y /\ z' = z))`,
   REWRITE_TAC[REWRITE_RULE[ETA_AX] EXISTS_UNIQUE] THEN
   REWRITE_TAC[FORALL_TRIPLED_THM; EXISTS_TRIPLED_THM] THEN
   REWRITE_TAC[EXISTS_PAIR_THM; FORALL_PAIR_THM; PAIR_EQ]);;


 let theoremmm = prove
 (`( !v1 v2 v3 v:real^N.
      v IN affine hull {v1, v2, v3} /\ ~collinear {v1, v2, v3}
      ==> (?t1 t2 t3.
               v = t1 % v1 + t2 % v2 + t3 % v3 /\
               t1 + t2 + t3 = &1 /\
               (!ta tb tc.
                    v = ta % v1 + tb % v2 + tc % v3 /\
                    ta + tb + tc = &1
                    ==> ta = t1 /\ tb = t2 /\ tc = t3)) )
   <=>
   ( !v1 v2 v3 v:real^N.
            ~collinear {v1, v2, v3} /\ v IN affine hull {v1, v2, v3}
            ==> (?!(t1,t2,t3). v = t1 % v1 + t2 % v2 + t3 % v3 /\
                               t1 + t2 + t3 = &1))`,
   REWRITE_TAC[EXISTS_UNIQUE_TRIPLED_THM] THEN REWRITE_TAC[CONJ_ACI]);;




let FAFKVLR = prove(` (?t1 t2 t3.
         !v1 v2 v3 (v:real^N).
             v IN affine hull {v1, v2, v3} /\ ~collinear {v1, v2, v3}
             ==> v =
                 t1 v1 v2 v3 v % v1 + t2 v1 v2 v3 v % v2 + t3 v1 v2 v3 v % v3 /\
                 t1 v1 v2 v3 v + t2 v1 v2 v3 v + t3 v1 v2 v3 v = &1 /\
                 (!ta tb tc.
                      v = ta % v1 + tb % v2 + tc % v3 /\ ta + tb + tc = &1 
                      ==> ta = t1 v1 v2 v3 v /\
                          tb = t2 v1 v2 v3 v /\
                          tc = t3 v1 v2 v3 v))  `,
SIMP_TAC[equivalent_lemma; FAFKVLR]);;
let LEMMA11 = FAFKVLR;;
let lemma11 = REWRITE_RULE[equivalent_lemma] FAFKVLR;;
let COEFS = new_specification ["coef1"; "coef2"; "coef3"] FAFKVLR;;

let lem11 = REWRITE_RULE[simp_def2; IN_ELIM_THM] lemma11;;

let REAL_PER3 = REAL_ARITH `!a b c. a + b + c = b + a + c /\ a + b + c = c + b + a `;;


MESON[VEC_PER2_3]` (!ta tb tc.
      v = ta % v1 + tb % v2 + tc % v3 ==> ta = t1 /\ tb = t2 /\ tc = t3) /\bbb/\
 v = ta''' % v1 + tb''' % v2 + t''' % v3 /\
 v = ta'' % v3 + tb'' % v1 + t'' % v2 /\
 v = ta' % v2 + tb' % v3 + t' % v1 /\
aa  ==> t' = t1 /\ t'' = t2 /\ t''' = t3 `;;


let IN_CONV3_EQ = prove(`! (v:real^3) v1 v2 v3. ~collinear {v1,v2,v3} ==> (v IN conv {v1, v2, v3} <=> 
  v IN aff_ge {v1,v2} {v3} /\
  v IN aff_ge {v2,v3} {v1} /\ v IN aff_ge {v3,v1} {v2} )`,
REWRITE_TAC[CONV_SET3; simp_def2; IN_ELIM_THM] THEN 
REPEAT GEN_TAC THEN DISCH_TAC THEN  EQ_TAC THENL [
MESON_TAC[REAL_ARITH` a + b + c = b + a + c /\ a + b + c = c + b + a `;
  VECTOR_ARITH `(a:real^N) + b + c = b + a + c /\ a + b + c = c + b + a `; lem11]; 
NHANH (MESON[]` (? a b c. P a b c /\ Q c /\ R a b c) /\ aa /\ bb ==>
   (? a b c. P a b c /\ R a b c) `) THEN 
FIRST_X_ASSUM MP_TAC THEN 
REWRITE_TAC[IMP_IMP] THEN 
REWRITE_TAC[MESON[]` ~a/\ b <=> b /\ ~ a `] THEN 
PHA THEN 
NHANH (SPEC_ALL lem11) THEN 
STRIP_TR THEN REWRITE_TAC[MESON[]` (v = w:real^N) /\ a <=> a /\ v = w `] THEN PHA] THEN 
NHANH (MESON[VEC_PER2_3; REAL_PER3]` ta + tb + t = &1 /\
 &0 <= t /\
 ta' + tb' + t' = &1 /\
 &0 <= t' /\
 ta'' + tb'' + t'' = &1 /\
 &0 <= t'' /\
a1/\
a2/\
 t1 + t2 + t3 = &1 /\
 (!ta tb tc.
      ta + tb + tc = &1 /\ v = ta % v1 + tb % v2 + tc % v3
      ==> ta = t1 /\ tb = t2 /\ tc = t3) /\
 v = t1 % v1 + t2 % v2 + t3 % v3 /\
a3/\
 v = ta'' % v3 + tb'' % v1 + t'' % v2 /\
 v = ta' % v2 + tb' % v3 + t' % v1 /\
 v = ta % v1 + tb % v2 + t % v3 ==> t1 = t' /\ t2 = t'' /\ t3 = t`) THEN 
MESON_TAC[]);;


let IN_CONV03_EQ = prove(
`! (v:real^3) v1 v2 v3. ~collinear {v1,v2,v3} ==> 
(v IN conv0 {v1, v2, v3} <=>   v IN aff_gt {v1,v2} {v3} /\
  v IN aff_gt {v2,v3} {v1} /\ v IN aff_gt {v3,v1} {v2} )`,
REWRITE_TAC[CONV_SET3; simp_def2; IN_ELIM_THM] THEN 
REPEAT GEN_TAC THEN DISCH_TAC THEN  EQ_TAC THENL [
MESON_TAC[REAL_ARITH` a + b + c = b + a + c /\ a + b + c = c + b + a `;
  VECTOR_ARITH `(a:real^N) + b + c = b + a + c /\ a + b + c = c + b + a `; lem11]; 
NHANH (MESON[]` (? a b c. P a b c /\ Q c /\ R a b c) /\ aa /\ bb ==>
   (? a b c. P a b c /\ R a b c) `) THEN 
FIRST_X_ASSUM MP_TAC THEN 
REWRITE_TAC[IMP_IMP] THEN 
REWRITE_TAC[MESON[]` ~a/\ b <=> b /\ ~ a `] THEN 
PHA THEN 
NHANH (SPEC_ALL lem11) THEN 
STRIP_TR THEN REWRITE_TAC[MESON[]` (v = w:real^N) /\ a <=> a /\ v = w `]]
 THEN PHA THEN NHANH (MESON[VEC_PER2_3; REAL_PER3]`
  ta + tb + t = &1 /\
 &0 < t /\
 ta' + tb' + t' = &1 /\
 &0 < t' /\
 ta'' + tb'' + t'' = &1 /\
 &0 < t'' /\ a33 /\ a22 /\
 t1 + t2 + t3 = &1 /\
 (!ta tb tc.
      ta + tb + tc = &1 /\ v = ta % v1 + tb % v2 + tc % v3
      ==> ta = t1 /\ tb = t2 /\ tc = t3) /\
 v = t1 % v1 + t2 % v2 + t3 % v3 /\ a11 /\
 v = ta'' % v3 + tb'' % v1 + t'' % v2 /\
 v = ta' % v2 + tb' % v3 + t' % v1 /\
 v = ta % v1 + tb % v2 + t % v3 ==>
  t1 = t' /\ t2 = t'' /\ t3 = t `) THEN MESON_TAC[]);;



let AFFINE_SET_GEN_BY_TWO_POINTS = 
prove(`! a b. affine {x | ?ta tb. ta + tb = &1 /\ x = ta % a + tb % b}`,
REWRITE_TAC[affine; IN_ELIM_THM] THEN 
REPEAT GEN_TAC THEN 
STRIP_TAC THEN 
EXISTS_TAC ` u * ta + v * ta' ` THEN 
EXISTS_TAC ` u * tb + v * tb' ` THEN 
REWRITE_TAC[REAL_ARITH ` (u * ta + v * ta') + u * tb + v * tb' =
  u * (ta + tb) + v * (ta' + tb' ) `] THEN 
ASM_SIMP_TAC[REAL_ARITH ` a * &1 = a `] THEN 
CONV_TAC VECTOR_ARITH);;



let GENERATING_POINT_IN_SET_AFF = prove(` ! a b. {a,b} SUBSET {x | ?ta tb. 
ta + tb = &1 /\ x = ta % a + tb % b}`,REWRITE_TAC[SET2_SU_EX; IN_ELIM_THM]
THEN REPEAT GEN_TAC THEN 
MESON_TAC[REAL_ARITH` &0 + &1 = &1 /\ a + b = b + a`; VECTOR_ARITH `
  a = &0 % b + &1 % a /\ a = &1 % a + &0 % b `]);;


let AFF_2POINTS_INTERPRET = prove(`!a b. aff {a, b} = {x | ?ta tb. ta + tb = &1 /\ x = ta % a + tb % b}`,
REWRITE_TAC[aff; hull] THEN 
REPEAT GEN_TAC THEN 
REWRITE_TAC[GSYM SUBSET_ANTISYM_EQ] THEN 
SIMP_TAC[INTERS_SUBSET; AFFINE_SET_GEN_BY_TWO_POINTS;
  GENERATING_POINT_IN_SET_AFF] THEN 
REWRITE_TAC[SUBSET; IN_ELIM_THM] THEN 
REWRITE_TAC[SUBSET; IN_ELIM_THM; IN_INTERS; affine] THEN 
SET_TAC[]);;


let IN_AFF_GE_INTERPRET_TO_AFF_GT_AND_AFF = prove(` ! v v1 v2 v3 . 
v IN aff_ge {v1,v2} {v3} <=> v IN aff_gt {v1,v2} {v3} \/
  v IN aff {v1,v2} `,
REWRITE_TAC[simp_def2; AFF_2POINTS_INTERPRET; IN_ELIM_THM ] THEN 
REWRITE_TAC [REAL_ARITH ` &0 <= a <=> &0 < a \/ a = &0 `] THEN 
MESON_TAC[REAL_ARITH ` (&0 <= a <=> &0 < a \/ a = &0 )/\( a + &0 = a ) `;
  VECTOR_ARITH ` a + &0 % c = a `]);;

let DOWN_TAC = REPEAT (FIRST_X_ASSUM MP_TAC) THEN REWRITE_TAC[IMP_IMP] THEN PHA;;
let IMP_IMP_TAC = REWRITE_TAC[IMP_IMP] THEN PHA;;


let AFFINE_AFF_HULL = prove(` ! s. affine ( aff s ) `, 
REWRITE_TAC[aff; AFFINE_AFFINE_HULL]);;


let AFFINE_CONTAIN_LINE = prove(`! a b s. affine s /\ {a,b} SUBSET s ==>
 aff {a,b} SUBSET s `,
REWRITE_TAC[affine ; AFF_2POINTS_INTERPRET; IN_ELIM_THM] THEN SET_TAC[]);;

let VECTOR_SUB_DISTRIBUTE = VECTOR_ARITH ` ! a x y. a % x - a % y = a % ( x - y ) `;;


let CHANGE_SIDE = prove(` ~( a = &0 ) ==> ( x = a % y <=> ( &1 / a) % x = y )`,
MESON_TAC[ VECTOR_ARITH `  ( a * b ) % x = a % b % x `; VECTOR_MUL_LID;
  REAL_FIELD `~( a = &0 ) ==>  a * &1 / a = &1 `; VECTOR_MUL_LCANCEL]);;


let PRE_INVERSE_SUB = prove(` ! a b v w. {a, b} SUBSET aff {v, w} /\ ~(a = b)
 ==> {v, w} SUBSET aff {a, b}`, 
REWRITE_TAC[AFF_2POINTS_INTERPRET; SET2_SU_EX; IN_ELIM_THM] THEN 
REPEAT GEN_TAC THEN STRIP_TAC THEN REPEAT (FIRST_X_ASSUM MP_TAC) THEN 
REWRITE_TAC[IMP_IMP] THEN PHA THEN 
NHANH (MESON[]` (a:real^N) = b /\ gg /\ a' = b' /\ ll ==> a - a' = b - b' `) THEN 
REWRITE_TAC[VECTOR_ARITH` (ta % v + tb % w) - (ta' % v + tb' % w) =
  ( ta - ta') % v + ( tb - tb' ) % w `] THEN 
PHA THEN REWRITE_TAC[MESON[]` a = &1 /\ b <=> b /\ a = &1 `] THEN PHA THEN 
NHANH (REAL_ARITH ` ta + tb = &1 /\ ta' + tb' = &1 ==> ta' - ta = tb - tb' `) THEN 
REWRITE_TAC[VECTOR_ARITH ` a + ( x - y ) % b = a - ( y - x) % b `] THEN 
REWRITE_TAC[MESON[]` a - b = ta % v - tb % w /\aa/\
   ta = tb <=> a - b = ta % v - ta % w /\ aa /\ ta = tb `] THEN 
ASM_CASES_TAC `(ta:real) = ta' ` THENL [ASM_SIMP_TAC[REAL_SUB_REFL; 
VECTOR_MUL_LZERO; VECTOR_SUB_RZERO; VECTOR_SUB_EQ] THEN MESON_TAC[]; ALL_TAC] THEN 
REWRITE_TAC[VECTOR_SUB_DISTRIBUTE] THEN FIRST_X_ASSUM MP_TAC THEN 
ONCE_REWRITE_TAC[REAL_ARITH` ~( a = b) <=> ~( a - b = &0 )`] THEN IMP_IMP_TAC THEN 
REWRITE_TAC[MESON[]` ~( a = b:real) /\ l <=> l /\ ~(a = b) `; MESON[]` 
a = d % b /\ l  <=> l /\  a = d % b `] THEN PHA THEN 
REWRITE_TAC[MESON[CHANGE_SIDE]` x = a % y /\ ~( a = &0 ) <=>  &1 / a % x = y /\
 ~( a = &0 )`] THEN NHANH (MESON[VECTOR_MUL_LCANCEL]` ta - ta' = tb' - tb /\
 a = b  /\ l ==> tb % a = tb % b /\ ta % a = ta % b `) THEN 
ONCE_REWRITE_TAC[MESON[]` a = (b:real^n) /\ l <=> l /\ a = b `] THEN PHA 
THEN REWRITE_TAC[GSYM VECTOR_SUB_DISTRIBUTE] THEN 
ONCE_REWRITE_TAC[VECTOR_ARITH` a = (b:real^N) /\ a1 = (b1:real^N) /\ a2 = 
  (b2:real^N) <=> a2 = b2 /\ a + a2 = b + b2 /\ a2 - a1 = b2 - b1 `] THEN 
REWRITE_TAC[VECTOR_ARITH` (ta % v + tb % w) - (ta % v - ta % w) = ( ta + tb ) % w `;
  VECTOR_ARITH` tb % v - tb % w + ta % v + tb % w = ( ta + tb ) % v `] THEN 
REWRITE_TAC[VECTOR_MUL_ASSOC; VECTOR_ARITH` a - ( x % a - y % b ) = 
(&1 - x ) % a + y % b `] THEN REWRITE_TAC[VECTOR_ARITH` a % x - b % y + x = 
(a + &1 ) % x + --b % y `] THEN 
REWRITE_TAC[MESON[]` a = &1 /\ b = &1 /\ l <=> a = &1 /\ l /\b = &1 `] THEN 
DAO THEN MATCH_MP_TAC (MESON[]`( a1 /\a2/\a3/\a5 ==> l) ==> 
(a1/\a2/\a3/\a4/\a5/\a6   ==> l ) `) THEN PURE_ONCE_REWRITE_TAC[ MESON[]`
 a + b = &1 /\ P ( a + b ) <=> a + b = &1 /\  P (&1) `] THEN 
REWRITE_TAC[VECTOR_MUL_LID] THEN MESON_TAC[REAL_FIELD ` ~(ta - ta' = &0)
     ==> (tb * &1 / (ta - ta') + &1) + --(tb * &1 / (ta - ta')) = &1 /\ 
  &1 - ta * &1 / (ta - ta') + ta * &1 / (ta - ta') = &1 `]);;



let LEMMA5 = prove(
`!(a:real^N) b x. line x /\ {a, b} SUBSET x /\ ~(a = b) ==> x = aff {a, b}`,
REWRITE_TAC[line; GSYM aff] THEN REPEAT GEN_TAC THEN STRIP_TAC THEN 
REWRITE_TAC[GSYM SUBSET_ANTISYM_EQ] THEN ASM_SIMP_TAC[AFFINE_AFF_HULL; 
AFFINE_CONTAIN_LINE] THEN STRIP_TR THEN 
ABBREV_TAC ` (ki : bool ) = aff {(v:real^N), (w:real^N)} 
  SUBSET aff {(a:real^N), (b:real^N)}` THEN 
REWRITE_TAC[MESON[]` a/\b/\c ==> d <=> b ==> a/\c ==> d `] THEN SIMP_TAC[]
THEN DISCH_TAC THEN IMP_IMP_TAC THEN 
NHANH (MESON[PRE_INVERSE_SUB]`{a, b} SUBSET aff {v, w} /\ aa /\ ~(a = b) 
  ==> {v, w} SUBSET aff {a, b} `) THEN 
NHANH (MESON[AFFINE_AFF_HULL]` aa /\ v SUBSET aff {a, b} ==> affine (aff {a,b})`)
THEN DOWN_TAC THEN MESON_TAC[AFFINE_CONTAIN_LINE]);;

let RCEABUJ = LEMMA5;;


let COL_EQ_UPS_0 = GEN_ALL (MESON[FHFMKIY]` collinear {(v1:real^3), v2, v3} <=>
 ups_x (dist (v1,v2) pow 2) (dist (v1,v3) pow 2) (dist (v2,v3) pow 2) = &0`);;



let EQ_POW2_COND = prove(`!a b. &0 <= a /\ &0 <= b ==> (a = b <=> a pow 2 = b pow 2)`,
REWRITE_TAC[REAL_ARITH` a = b <=> a <= b /\ b <= a `] THEN SIMP_TAC[POW2_COND]);;


let D3_POS_LE = MESON[d3; DIST_POS_LE]` ! x y. &0 <= d3 x y `;;


let delta_x12 = new_definition ` delta_x12 x12 x13 x14 x23 x24 x34 =
  -- x13 * x23 + -- x14 * x24 + x34 * ( -- x12 + x13 + x14 + x23 + x24 + -- x34 )
  + -- x12 * x34 + x13 * x24 + x14 * x23 `;;

let delta_x13 = new_definition` delta_x13 x12 x13 x14 x23 x24 x34 =
  -- x12 * x23 + -- x14 * x34 + x12 * x34 + x24 * ( x12 + -- x13 + x14 + x23 + 
  -- x24 + x34 ) + -- x13 * x24 + x14 * x23 `;;

let delta_x14 = new_definition`delta_x14 x12 x13 x14 x23 x24 x34 =
         --x12 * x24 +
         --x13 * x34 +
         x12 * x34 +
         x13 * x24 +
         x23 * (x12 + x13 + --x14 + --x23 + x24 + x34) +
         --x14 * x23`;;



let DIST_POW2_DOT = 
prove(` ! a (b:real^N) . dist (a,b) pow 2 = ( a - b ) dot ( a- b) `,
SIMP_TAC[dist; vector_norm; DOT_POS_LE; SQRT_WORKS]);;



(* the following lemma is in Multivariate/convex.ml *)
let AFFINE_HULL_3 = new_axiom` affine hull {a,b,c} =
    { u % a + v % b + w % c | u + v + w = &1}`;;


let LET_TR = CONV_TAC (TOP_DEPTH_CONV let_CONV);;


(* BEGINING *)
(* lemma 16 SDIHJZK *)

let TO_UYCH = prove(` &0 < ups_x a12 a13 a23 ==>
  delta_x12 a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23 +
     delta_x13 a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23 +
     delta_x14 a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23 =
     &1 `,
REWRITE_TAC[ups_x; delta_x12; delta_x13; delta_x14] THEN CONV_TAC REAL_FIELD);;




let NOT_UPS_X_ZERO_IMP_SMT = prove(`~(ups_x a12 a13 a23 = &0)
 ==> (delta_x13 a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23) pow 2 * a12 +
     delta_x13 a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23 *
     delta_x14 a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23 *
     (a12 + a13 - a23) +
     (delta_x14 a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23) pow 2 * a13 
     =
     a01 - delta a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23 /\

(delta_x14 a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23) pow 2 * a23 +
     delta_x14 a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23 *
     delta_x12 a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23 *
     (a23 + a12 - a13) +
     (delta_x12 a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23) pow 2 * a12 
      =
     a02 - delta a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23 /\

(delta_x12 a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23) pow 2 * a13 +
     delta_x12 a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23 *
     delta_x13 a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23 *
     (a13 + a23 - a12) +
     (delta_x13 a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23) pow 2 * a23 =
     a03 - delta a01 a02 a03 a12 a13 a23 / ups_x a12 a13 a23`,
ONCE_REWRITE_TAC[REAL_FIELD` ~( a = &0 ) ==> ( x = y ) /\ ( xx = yy ) /\ ( xxx = yyy)
  <=> ~( a = &0 ) ==> ( x * a pow 2 = y * a pow 2 ) /\
  ( xx * a pow 2 = yy * a pow 2 ) /\
  ( xxx * a pow 2 = yyy * a pow 2 ) `] THEN 
SIMP_TAC[REAL_FIELD` ~( a = &0 ) ==> ( b - c / a ) * a pow 2 = b * a pow 2 - c * a `
  ; REAL_ADD_RDISTRIB] THEN 
SIMP_TAC[REAL_ARITH` ( a * b ) * c = a * b * c `;
  REAL_FIELD` ~ ( a = &0 ) ==> ( b / a ) pow 2 * c * a pow 2 =
  b pow 2 * c `; REAL_FIELD ` ~ ( a = &0 ) ==> b / a * c / a * d * 
  a pow 2 = b * c * d `] THEN DISCH_TAC THEN 
REWRITE_TAC[delta_x12; delta_x13; delta_x14; delta; ups_x] THEN REAL_ARITH_TAC);;


let TROI_OI_DAT_HOI = MESON[ lemma8; dist; DIST_SYM]` &0 <=
           ups_x ( dist((v1:real^3),v2) pow 2) (dist(v2,v3) pow 2)
           (dist(v1,v3) pow 2)`;;



let ZERO_LE_UPS_X = MESON[TROI_OI_DAT_HOI; d3; DIST_SYM]` 
  &0 <= ups_x (d3 x y pow 2) (d3 x z pow 2) (d3 y z pow 2) `;;


let UPS_X_EQ_ZERO_COND = prove(` ! v1 v2 (v3: real^3). (collinear {v1, v2, v3} <=>
            ups_x (dist (v1,v2) pow 2) (dist (v1,v3) pow 2)
            (dist (v2,v3) pow 2) =
            &0) `,
MP_TAC FHFMKIY THEN MESON_TAC[]);;



let NORM_POW2_SUM2 = prove(` norm ( a % x + b % y ) pow 2 =
  a pow 2 * norm x pow 2 + &2 * ( a * b ) * ( x dot y ) + 
  b pow 2 * norm y pow 2 `, REWRITE_TAC[vector_norm] THEN 
SIMP_TAC[DOT_POS_LE; SQRT_WORKS] THEN CONV_TAC VECTOR_ARITH);;



let X_DOT_X_EQ = prove( ` x dot x = norm x pow 2 `,
SIMP_TAC[vector_norm; DOT_POS_LE; SQRT_WORKS]);;



let SUB_DIST_POW2_INTERPRETE = prove(`! x y (v:real^N) c. 
dist(x,v) pow 2 - dist(y,v) pow 2 = c <=>
( &2 % v  - ( x + y )) dot ( y - x ) = c `,
SIMP_TAC[DIST_POW2_DOT; DOT_SUB_ADD; VECTOR_ARITH`
 (x - v - (y - v)) dot (x - v + y - v) =  (&2 % v - (x + y)) dot (y - x) `]);;


let SDIHJZK = prove(`! (v1:real^3) v2 v3 (a01: real) a02 a03.
         ~collinear {v1, v2, v3} /\
         (let x12 = d3 v1 v2 pow 2 in
          let x13 = d3 v1 v3 pow 2 in
          let x23 = d3 v2 v3 pow 2 in delta a01 a02 a03 x12 x13 x23 = &0)
         ==> (?!v0. a01 = d3 v0 v1 pow 2 /\
                    a02 = d3 v0 v2 pow 2 /\
                    a03 = d3 v0 v3 pow 2 /\
                    (let x12 = d3 v1 v2 pow 2 in
                     let x13 = d3 v1 v3 pow 2 in
                     let x23 = d3 v2 v3 pow 2 in
                     let vv = ups_x x12 x13 x23 in
                     let t1 = delta_x12 a01 a02 a03 x12 x13 x23 / vv in
                     let t2 = delta_x13 a01 a02 a03 x12 x13 x23 / vv in
                     let t3 = delta_x14 a01 a02 a03 x12 x13 x23 / vv in
                     v0 = t1 % v1 + t2 % v2 + t3 % v3 /\ t1 + t2 + t3 = &1 ))`, 
REPEAT GEN_TAC THEN 
LET_TR THEN 
STRIP_TAC THEN 
REWRITE_TAC[EXISTS_UNIQUE] THEN 
EXISTS_TAC ` delta_x12 a01 a02 a03 (d3 v1 v2 pow 2) (d3 v1 v3 pow 2)
       (d3 v2 v3 pow 2) /
       ups_x (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v2 v3 pow 2) %
       v1 +
       delta_x13 a01 a02 a03 (d3 v1 v2 pow 2) (d3 v1 v3 pow 2)
       (d3 v2 v3 pow 2) /
       ups_x (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v2 v3 pow 2) %
       v2 +
       delta_x14 a01 a02 a03 (d3 v1 v2 pow 2) (d3 v1 v3 pow 2)
       (d3 v2 v3 pow 2) /
       ups_x (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v2 v3 pow 2) %
       v3 ` THEN 
UNDISCH_TAC `~collinear {(v1:real^3), v2, v3}` THEN 
MP_TAC (GEN_ALL ZERO_LE_UPS_X) THEN 
REWRITE_TAC[UPS_X_EQ_ZERO_COND] THEN 
REWRITE_TAC[MESON[]` a ==> b ==> c <=> a /\ b ==> c `; d3] THEN 
NHANH (MESON[REAL_ARITH ` &0 <= a <=> &0 < a \/ a = &0 `]`
   (!(x:real^3) y z.
        &0 <= ups_x (dist (x,y) pow 2) (dist (x,z) pow 2) (dist (y,z) pow 2)) /\
   ~(ups_x (dist (v1,v2) pow 2) (dist (v1,v3) pow 2) (dist (v2,v3) pow 2) = &0)
    ==> &0 < ups_x (dist ((v1:real^3),v2) pow 2) (dist (v1,v3) pow 2) (dist (v2,v3) pow 2) `) THEN 
REWRITE_TAC[ GSYM d3] THEN 
STRIP_TAC THEN 
CONJ_TAC THENL [

UNDISCH_TAC ` &0 < ups_x (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v2 v3 pow 2)` THEN 
ABBREV_TAC ` a12 = d3 v1 v2 pow 2 ` THEN ABBREV_TAC ` a13 = d3 v1 v3 pow 2 ` THEN 
ABBREV_TAC ` a23 = d3 v2 v3 pow 2 ` THEN SIMP_TAC[TO_UYCH] THEN 
REWRITE_TAC[MESON[d3; dist] ` aa = d3 a b pow 2 <=> aa = norm ( a- b ) pow 2 `] THEN 
ONCE_REWRITE_TAC[VECTOR_ARITH ` a - b = a - &1 % b `] THEN 
NHANH (GSYM TO_UYCH) THEN SIMP_TAC[] THEN 
SIMP_TAC[VECTOR_ARITH ` (a % v1 + b % v2 + c % v3) - (a + b + c) % v2 =
     (b % v2 + c % v3 + a % v1) - (b + c + a) % v2 /\
  (a % v1 + b % v2 + c % v3) - (a + b + c) % v3 = 
  (c % v3 + a % v1 + b % v2 ) - ( c + a + b ) % v3 `] THEN 
REWRITE_TAC[VECTOR_ARITH` ( a % v1 + b % v2 + c % v3)  - 
  ( a + b + c ) % v1 = b % ( v2 - v1 ) + c % ( v3 - v1 ) `] THEN 
REWRITE_TAC[NORM_POW2_SUM2 ; REAL_ARITH ` &2 * ( a * b ) * c = a * b * &2 * c `] THEN 
REWRITE_TAC[VECTOR_ARITH ` &2 * ( x dot y ) = x dot x + y dot y - ( x - y ) dot ( x - y ) `] THEN 
REWRITE_TAC[VECTOR_ARITH` v1 - v3 - (v2 - v3) = (v1:real^3) - v2 `] THEN 
REWRITE_TAC[X_DOT_X_EQ; GSYM dist; GSYM d3] THEN 
SIMP_TAC[D3_SYM] THEN ASM_SIMP_TAC[] THEN STRIP_TAC THEN 
UNDISCH_TAC ` ~(ups_x a12 a13 a23 = &0)` THEN NHANH NOT_UPS_X_ZERO_IMP_SMT  THEN 
ASM_SIMP_TAC[REAL_DIV_LZERO; REAL_SUB_RZERO];
MESON_TAC[]]);;



let HALF_OF_LE16 = prove(` ! (v1:real^3) v2 v3 (a01: real) a02 a03.
         ~collinear {v1, v2, v3} /\
         (let x12 = d3 v1 v2 pow 2 in
          let x13 = d3 v1 v3 pow 2 in
          let x23 = d3 v2 v3 pow 2 in delta a01 a02 a03 x12 x13 x23 = &0)
==> ?v0. (v0 IN aff {v1, v2, v3} /\
       a01 = d3 v0 v1 pow 2 /\
       a02 = d3 v0 v2 pow 2 /\
       a03 = d3 v0 v3 pow 2 /\
       (let x12 = d3 v1 v2 pow 2 in
        let x13 = d3 v1 v3 pow 2 in
        let x23 = d3 v2 v3 pow 2 in
        let vv = ups_x x12 x13 x23 in
        let t1 = delta_x12 a01 a02 a03 x12 x13 x23 / vv in
        let t2 = delta_x13 a01 a02 a03 x12 x13 x23 / vv in
        let t3 = delta_x14 a01 a02 a03 x12 x13 x23 / vv in
        v0 = t1 % v1 + t2 % v2 + t3 % v3)) `,
REPEAT GEN_TAC THEN LET_TR THEN STRIP_TAC THEN REWRITE_TAC[EXISTS_UNIQUE] THEN 
EXISTS_TAC ` delta_x12 a01 a02 a03 (d3 v1 v2 pow 2) (d3 v1 v3 pow 2)
       (d3 v2 v3 pow 2) /
       ups_x (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v2 v3 pow 2) %
       v1 +
       delta_x13 a01 a02 a03 (d3 v1 v2 pow 2) (d3 v1 v3 pow 2)
       (d3 v2 v3 pow 2) /
       ups_x (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v2 v3 pow 2) %
       v2 +
       delta_x14 a01 a02 a03 (d3 v1 v2 pow 2) (d3 v1 v3 pow 2)
       (d3 v2 v3 pow 2) /
       ups_x (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v2 v3 pow 2) %
       v3 ` THEN 
UNDISCH_TAC `~collinear {(v1:real^3), v2, v3}` THEN 
MP_TAC (GEN_ALL ZERO_LE_UPS_X) THEN 
REWRITE_TAC[UPS_X_EQ_ZERO_COND] THEN 
REWRITE_TAC[MESON[]` a ==> b ==> c <=> a /\ b ==> c `; d3] THEN 
NHANH (MESON[REAL_ARITH ` &0 <= a <=> &0 < a \/ a = &0 `]`
   (!(x:real^3) y z.
        &0 <= ups_x (dist (x,y) pow 2) (dist (x,z) pow 2) (dist (y,z) pow 2)) /\
   ~(ups_x (dist (v1,v2) pow 2) (dist (v1,v3) pow 2) (dist (v2,v3) pow 2) = &0)
    ==> &0 < ups_x (dist ((v1:real^3),v2) pow 2) (dist (v1,v3) pow 2) (dist (v2,v3) pow 2) `) THEN 
REWRITE_TAC[ GSYM d3] THEN 
STRIP_TAC THEN 
UNDISCH_TAC ` &0 < ups_x (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v2 v3 pow 2)` THEN 
ABBREV_TAC ` a12 = d3 v1 v2 pow 2 ` THEN ABBREV_TAC ` a13 = d3 v1 v3 pow 2 ` THEN 
ABBREV_TAC ` a23 = d3 v2 v3 pow 2 ` THEN SIMP_TAC[TO_UYCH] THEN 
REWRITE_TAC[MESON[d3; dist] ` aa = d3 a b pow 2 <=> aa = norm ( a- b ) pow 2 `] THEN 
ONCE_REWRITE_TAC[VECTOR_ARITH ` a - b = a - &1 % b `] THEN 
NHANH (GSYM TO_UYCH) THEN SIMP_TAC[] THEN 
SIMP_TAC[VECTOR_ARITH ` (a % v1 + b % v2 + c % v3) - (a + b + c) % v2 =
     (b % v2 + c % v3 + a % v1) - (b + c + a) % v2 /\
  (a % v1 + b % v2 + c % v3) - (a + b + c) % v3 = 
  (c % v3 + a % v1 + b % v2 ) - ( c + a + b ) % v3 `] THEN 
REWRITE_TAC[VECTOR_ARITH` ( a % v1 + b % v2 + c % v3)  - 
  ( a + b + c ) % v1 = b % ( v2 - v1 ) + c % ( v3 - v1 ) `] THEN 
REWRITE_TAC[NORM_POW2_SUM2 ; REAL_ARITH ` &2 * ( a * b ) * c = a * b * &2 * c `] THEN 
REWRITE_TAC[VECTOR_ARITH ` &2 * ( x dot y ) = x dot x + y dot y - ( x - y ) dot ( x - y ) `] THEN 
REWRITE_TAC[VECTOR_ARITH` v1 - v3 - (v2 - v3) = (v1:real^3) - v2 `] THEN 
REWRITE_TAC[X_DOT_X_EQ; GSYM dist; GSYM d3] THEN 
SIMP_TAC[D3_SYM] THEN ASM_SIMP_TAC[] THEN STRIP_TAC THEN 
UNDISCH_TAC ` ~(ups_x a12 a13 a23 = &0)` THEN NHANH NOT_UPS_X_ZERO_IMP_SMT  THEN 
ASM_SIMP_TAC[REAL_DIV_LZERO; REAL_SUB_RZERO] THEN 
REWRITE_TAC[aff; AFFINE_HULL_3; IN_ELIM_THM] THEN ASM_MESON_TAC[]);;




let EQ_SUB_DIST_POW2_IMP_IDENTIFIED = prove(` ! v1 v2 v3 (u:real^N) w. 
{u,w} SUBSET affine hull {v1,v2,v3} /\
dist (u,v2) pow 2 - dist (u,v1) pow 2 = dist (w,v2) pow 2 - dist (w,v1) pow 2 /\
dist (u,v3) pow 2 - dist (u,v1) pow 2 = dist (w,v3) pow 2 - dist (w,v1) pow 2 ==>
w = u `, 
REPEAT GEN_TAC THEN ONCE_REWRITE_TAC[DIST_SYM] THEN 
SIMP_TAC[SUB_DIST_POW2_INTERPRETE ] THEN ONCE_REWRITE_TAC[EQ_SYM_EQ] THEN 
SIMP_TAC[SUB_DIST_POW2_INTERPRETE ] THEN 
ONCE_REWRITE_TAC[REAL_ARITH` a = b <=> a - b = &0 `] THEN 
SIMP_TAC[GSYM DOT_LSUB] THEN 
SIMP_TAC[GSYM DOT_LSUB; VECTOR_ARITH` a - b - ( aa - b ) =
  (a:real^N) - aa `; GSYM VECTOR_SUB_LDISTRIB; AFFINE_HULL_3;
  SET2_SU_EX; IN_ELIM_THM] THEN STRIP_TAC THEN 
REPEAT (FIRST_X_ASSUM MP_TAC ) THEN 
REWRITE_TAC[MESON[]` a ==> b ==> c <=> b /\ a ==> c `] THEN 
NHANH (MESON[]` a = (aa:real^N) /\ la /\ b = bb /\ lb ==>
  a - b = aa - bb `) THEN 
REWRITE_TAC[REAL_ARITH` a + b = &1 <=> a = &1 - b `] THEN PHA THEN 
STRIP_TAC THEN FIRST_X_ASSUM MP_TAC THEN UNDISCH_TAC`u' = &1 - (v + w')` THEN 
UNDISCH_TAC`u'' = &1 - (v' + w'')` THEN SIMP_TAC[] THEN 
SIMP_TAC[VECTOR_ARITH` ((&1 - (v' + w'')) % v1 + v' % v2 + w'' % v3) -
     ((&1 - (v + w')) % v1 + v % v2 + w' % v3) =
  ( v - v' ) % ( v1 - v2 ) + (w' - w'' ) % ( v1 - v3 ) `] THEN 
REPEAT STRIP_TAC THEN 
ONCE_REWRITE_TAC[VECTOR_ARITH ` a = b <=> b - a = vec 0` ] THEN 
REWRITE_TAC[GSYM DOT_EQ_0] THEN FIRST_X_ASSUM MP_TAC THEN 
REWRITE_TAC[MESON[]` a = b ==> a dot a = &0 <=> a = b ==>
  a dot b = &0 `] THEN 
REWRITE_TAC[DOT_RADD; DOT_RMUL; REAL_ARITH ` a * ( b dot c ) + aa * bb = &0
  <=> a * &2 * ( b dot c ) + aa * &2 * bb = &0 `] THEN 
ONCE_REWRITE_TAC[GSYM DOT_LMUL] THEN 
ABBREV_TAC ` as = &2 % ((w:real^N) - u) dot (v1 - v2)` THEN 
ABBREV_TAC ` bs = &2 % ((w:real^N) - u) dot (v1 - v3)` THEN 
DISCH_TAC THEN ASM_SIMP_TAC[] THEN REAL_ARITH_TAC);;

(* lemma 16 SDIHJZK *)

let SDIHJZK = prove(`! (v1:real^3) v2 v3 (a01: real) a02 a03.
         ~collinear {v1, v2, v3} /\
         (let x12 = d3 v1 v2 pow 2 in
          let x13 = d3 v1 v3 pow 2 in
          let x23 = d3 v2 v3 pow 2 in delta a01 a02 a03 x12 x13 x23 = &0)
         ==> (?v0. v0 IN aff {v1,v2,v3} /\
                    a01 = d3 v0 v1 pow 2 /\
                    a02 = d3 v0 v2 pow 2 /\
                    a03 = d3 v0 v3 pow 2 /\ 
                   (! vv0. vv0 IN aff {v1,v2,v3} /\
                    a01 = d3 vv0 v1 pow 2 /\
                    a02 = d3 vv0 v2 pow 2 /\
                    a03 = d3 vv0 v3 pow 2 ==> vv0 = v0 ) /\
                    (let x12 = d3 v1 v2 pow 2 in
                     let x13 = d3 v1 v3 pow 2 in
                     let x23 = d3 v2 v3 pow 2 in
                     let vv = ups_x x12 x13 x23 in
                     let t1 = delta_x12 a01 a02 a03 x12 x13 x23  / vv in
                     let t2 = delta_x13 a01 a02 a03 x12 x13 x23  / vv in
                     let t3 = delta_x14 a01 a02 a03 x12 x13 x23  / vv in
                     v0 = t1 % v1 + t2 % v2 + t3 % v3))`,
REPEAT GEN_TAC THEN NHANH (SPEC_ALL HALF_OF_LE16  ) THEN STRIP_TAC THEN 
EXISTS_TAC `v0:real^3` THEN ASM_SIMP_TAC[] THEN 
GEN_TAC THEN UNDISCH_TAC ` (v0:real^3) IN aff {v1, v2, v3}` THEN 
ONCE_REWRITE_TAC[REAL_ARITH ` a1 = b1 /\ a2 = b2 /\ a3 = b3 <=>
  a2 - a1 = b2 - b1 /\ a3 - a1 = b3 - b1 /\ a1 = b1 `] THEN 
REWRITE_TAC[aff; SET2_SU_EX] THEN REWRITE_TAC[d3] THEN 
PHA THEN MESON_TAC[SET2_SU_EX; EQ_SUB_DIST_POW2_IMP_IDENTIFIED]);;



let SDIHJZK_INTERPRETE = prove(`!(v1:real^3) v2 v3 a01 a02 a03.
     ~collinear {v1, v2, v3} /\
     delta a01 a02 a03 (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v2 v3 pow 2) =
     &0
     ==> (?v0. v0 IN aff {v1, v2, v3} /\
               a01 = d3 v0 v1 pow 2 /\
               a02 = d3 v0 v2 pow 2 /\
               a03 = d3 v0 v3 pow 2 /\
               (!vv0. vv0 IN aff {v1, v2, v3} /\
                      a01 = d3 vv0 v1 pow 2 /\
                      a02 = d3 vv0 v2 pow 2 /\
                      a03 = d3 vv0 v3 pow 2
                      ==> vv0 = v0) /\
               v0 =
               delta_x12 a01 a02 a03 (d3 v1 v2 pow 2) (d3 v1 v3 pow 2)
               (d3 v2 v3 pow 2) /
               ups_x (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v2 v3 pow 2) %
               v1 +
               delta_x13 a01 a02 a03 (d3 v1 v2 pow 2) (d3 v1 v3 pow 2)
               (d3 v2 v3 pow 2) /
               ups_x (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v2 v3 pow 2) %
               v2 +
               delta_x14 a01 a02 a03 (d3 v1 v2 pow 2) (d3 v1 v3 pow 2)
               (d3 v2 v3 pow 2) /
               ups_x (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v2 v3 pow 2) %
               v3)`, MP_TAC SDIHJZK THEN LET_TR THEN SIMP_TAC[]);;



let DELTA_RRR_INTERPRETE = prove(` delta r r r a b c = -- a * b * c + r * ups_x a b c `,
REWRITE_TAC[delta; ups_x] THEN REAL_ARITH_TAC);;


let NOT_UPS_X_EQ_0_IMP = prove(` ~( ups_x a b c = &0 ) 
 ==> delta ( ( a * b * c ) / ups_x a b c ) ( ( a * b * c ) / ups_x a b c ) 
  ( ( a * b * c ) / ups_x a b c ) a b c = &0 `,
REWRITE_TAC[DELTA_RRR_INTERPRETE ] THEN CONV_TAC REAL_FIELD);;




let COL_EQ_UPS_0 = GEN_ALL (MESON[FHFMKIY]` collinear {(v1:real^3), v2, v3} <=>
 ups_x (dist (v1,v2) pow 2) (dist (v1,v3) pow 2) (dist (v2,v3) pow 2) = &0`);;


(* CDEUSDF POST ZERO_LE_UPS_X *)




let PROVE_EXISTS_RADV = prove(`!(va:real^3) vb vc.
     ~collinear {va, vb, vc}
     ==> (?p. p IN affine hull {va, vb, vc} /\
              (?c. ( !w. w IN {va, vb, vc} ==> c = dist (p,w)) /\
                 (!p'. p' IN affine hull {va, vb, vc} /\
                    ( !w. w IN {va, vb, vc} ==> c = dist (p',w))
                    ==> p = p'))) `,
REWRITE_TAC[COL_EQ_UPS_0] THEN 
NHANH (NOT_UPS_X_EQ_0_IMP ) THEN 
REWRITE_TAC[GSYM COL_EQ_UPS_0] THEN 
REWRITE_TAC[GSYM d3] THEN 
NHANH (SPEC_ALL SDIHJZK_INTERPRETE) THEN 
REWRITE_TAC[EXISTS_UNIQUE] THEN 
REPEAT STRIP_TAC THEN 
ABBREV_TAC ` r = (d3 va vb pow 2 * d3 va vc pow 2 * d3 vb vc pow 2) /
      ups_x (d3 va vb pow 2) (d3 va vc pow 2) (d3 vb vc pow 2)  ` THEN 
EXISTS_TAC ` v0 :real^3` THEN 
UNDISCH_TAC ` (v0:real^3) IN aff {va, vb, vc}` THEN 
SIMP_TAC[aff; SET_RULE ` (! x. x IN {a,b,c} ==> P x ) <=>
  P a /\ P b /\ P c `] THEN 
DISCH_TAC THEN EXISTS_TAC ` sqrt ( r ) ` THEN 
UNDISCH_TAC ` (d3 va vb pow 2 * d3 va vc pow 2 * d3 vb vc pow 2) /
      ups_x (d3 va vb pow 2) (d3 va vc pow 2) (d3 vb vc pow 2) = r` THEN 
NHANH (MESON[REAL_LE_SQUARE_POW; REAL_LE_DIV; REAL_LE_MUL; 
  ZERO_LE_UPS_X ]` (d3 va vb pow 2 * d3 va vc pow 2 * d3 vb vc pow 2) /
 ups_x (d3 va vb pow 2) (d3 va vc pow 2) (d3 vb vc pow 2) =
 r ==> &0 <= r `) THEN 
SIMP_TAC[SQRT_WORKS; EQ_POW2_COND; D3_POS_LE] THEN 
ASM_MESON_TAC[aff]);;




let COND_FOR_CIRCUMCENTER_PROPERTIESS = prove(`~collinear {(v1:real^3), v2, v3}
 ==> circumcenter {v1, v2, v3} IN affine hull {v1, v2, v3} /\
     (?c. !v. v IN {v1, v2, v3} ==> c = dist (circumcenter {v1, v2, v3}, v))`,
NHANH (MESON[PROVE_EXISTS_RADV]`~collinear {(va:real^3), vb, vc}
         ==> (?p. p IN affine hull {va, vb, vc} /\
                  (?c. (!w. w IN {va, vb, vc} ==> c = dist (p,w)))) `) THEN 
REWRITE_TAC[IN; circumcenter] THEN MESON_TAC[EXISTS_THM]);;


let DELTA_X14_RRR = prove(` delta_x14 r r r a b c = a * ( b + c - a ) `,
REWRITE_TAC[delta_x14] THEN REAL_ARITH_TAC);;


let DELTA_X1I_RRR = prove(` delta_x12 r r r a b c = c * ( b + a - c ) /\
  delta_x13 r r r a b c = b * ( c + a  - b ) /\
  delta_x14 r r r a b c = a * (c + b - a) `,
REWRITE_TAC[delta_x12; delta_x13; delta_x14] THEN REAL_ARITH_TAC);;





let PRE_RADV_COND = prove(` ~ collinear {va,vb,vc} ==>
(? c. ! w. {va,vb,(vc:real^3)} w ==> c = dist(circumcenter {va,vb,vc} , w )) `,
NHANH (COND_FOR_CIRCUMCENTER_PROPERTIESS ) THEN MESON_TAC[IN]);;


let NOT_COL_IMP_RADV_PROPERTIY = prove(` ~collinear {(va:real^3), vb, vc}
 ==>  ( ! w. {va, vb, vc} w ==> 
  radV {va, vb, vc} = dist (circumcenter {va, vb, vc},w)) `,
NHANH (PRE_RADV_COND ) THEN SIMP_TAC[EXISTS_THM; radV]);;




let CIRCUMCENTER_FORMULAR2 = prove(`! (va:real^3) vb vc a b c.
     a = d3 vb vc /\ b = d3 va vc /\ c = d3 va vb /\ ~collinear {va, vb, vc}
     ==> 
         (let al_a =
              (a pow 2 * (b pow 2 + c pow 2 - a pow 2)) /
              (ups_x (a pow 2) (b pow 2) (c pow 2)) in
          let al_b =
              (b pow 2 * (a pow 2 + c pow 2 - b pow 2)) /
              (ups_x (a pow 2) (b pow 2) (c pow 2)) in
          let al_c =
              (c pow 2 * (a pow 2 + b pow 2 - c pow 2)) /
              (ups_x (a pow 2) (b pow 2) (c pow 2)) in
          al_a % va + al_b % vb + al_c % vc = circumcenter {va, vb, vc})`,
REWRITE_TAC[COL_EQ_UPS_0] THEN 
NHANH (NOT_UPS_X_EQ_0_IMP) THEN 
REWRITE_TAC[GSYM COL_EQ_UPS_0; GSYM d3] THEN 
NHANH (SPEC_ALL SDIHJZK_INTERPRETE ) THEN 
REPEAT STRIP_TAC THEN 
ABBREV_TAC ` r = (d3 va vb pow 2 * d3 va vc pow 2 * d3 vb vc pow 2) /
           ups_x (d3 va vb pow 2) (d3 va vc pow 2) (d3 vb vc pow 2) ` THEN 
UNDISCH_TAC ` v0 =
      delta_x12 r r r (d3 va vb pow 2) (d3 va vc pow 2) (d3 vb vc pow 2) /
      ups_x (d3 va vb pow 2) (d3 va vc pow 2) (d3 vb vc pow 2) %
      va +
      delta_x13 r r r (d3 va vb pow 2) (d3 va vc pow 2) (d3 vb vc pow 2) /
      ups_x (d3 va vb pow 2) (d3 va vc pow 2) (d3 vb vc pow 2) %
      vb +
      delta_x14 r r r (d3 va vb pow 2) (d3 va vc pow 2) (d3 vb vc pow 2) /
      ups_x (d3 va vb pow 2) (d3 va vc pow 2) (d3 vb vc pow 2) %
      vc`  THEN 
LET_TR THEN 
UNDISCH_TAC ` a = d3 vb vc ` THEN 
UNDISCH_TAC ` b = d3 va vc ` THEN 
UNDISCH_TAC ` c = d3 va vb ` THEN 
SIMP_TAC[DELTA_X1I_RRR] THEN 
SIMP_TAC[MESON[UPS_X_SYM]` ups_x a b c = ups_x c b a `] THEN 
ONCE_REWRITE_TAC[EQ_SYM_EQ] THEN 
SIMP_TAC[] THEN 
REPEAT STRIP_TAC THEN 
UNDISCH_TAC ` ~collinear {(va:real^3), vb, vc} ` THEN 
NHANH (COND_FOR_CIRCUMCENTER_PROPERTIESS) THEN 
REWRITE_TAC[SET_RULE ` (! x. x IN {a,b,c} ==> P x )
  <=> P a /\ P b /\ P c `] THEN 
REWRITE_TAC[SET_RULE ` (! x. x IN {a,b,c} ==> P x )
  <=> P a /\ P b /\ P c `; MESON[]` (? cc. cc = a /\ cc = b /\ cc = c)
  <=> a = b /\ a = c  `] THEN 
UNDISCH_TAC ` v0 IN aff {va, vb, (vc:real^3)}` THEN 
REWRITE_TAC[aff; SET_RULE ` a IN s ==> b /\ aa IN s /\ l ==>
  ll <=> b ==>  {a,aa} SUBSET s /\ l ==> ll `] THEN 
DISCH_TAC THEN 
UNDISCH_TAC` r = d3 v0 va pow 2 ` THEN 
UNDISCH_TAC` r = d3 v0 vb pow 2 ` THEN 
UNDISCH_TAC` r = d3 v0 vc pow 2 ` THEN 
REWRITE_TAC[MESON[]` r = a1 ==> r = a2 ==> r = a3 ==> l ==> ll <=>
  r = a1 /\ l /\ a2 = a3 /\ a1 = a3 ==> ll `;d3] THEN 
ONCE_REWRITE_TAC[MESON[]` dist(a,b) = s <=> s = dist(a,b) `] THEN 
SIMP_TAC[DIST_POS_LE; EQ_POW2_COND] THEN 
ONCE_REWRITE_TAC[REAL_ARITH` a = b <=> a - b = &0 `] THEN 
MESON_TAC[EQ_SUB_DIST_POW2_IMP_IDENTIFIED ]);;




let NOT_COLL_IMP_RADV_FORMULAR = prove(`! (va:real^3) vb vc a b c.
     a = d3 vb vc /\ b = d3 va vc /\ c = d3 va vb /\ ~collinear {va, vb, vc}
     ==>  radV {va, vb, vc} = eta_y a b c`,
REWRITE_TAC[COL_EQ_UPS_0] THEN 
NHANH (NOT_UPS_X_EQ_0_IMP) THEN 
REWRITE_TAC[GSYM COL_EQ_UPS_0; GSYM d3] THEN 
NHANH (SPEC_ALL SDIHJZK_INTERPRETE ) THEN 
REPEAT STRIP_TAC THEN 
ABBREV_TAC ` r = (d3 va vb pow 2 * d3 va vc pow 2 * d3 vb vc pow 2) /
           ups_x (d3 va vb pow 2) (d3 va vc pow 2) (d3 vb vc pow 2) ` THEN 
LET_TR THEN 
UNDISCH_TAC ` a = d3 vb vc ` THEN 
UNDISCH_TAC ` b = d3 va vc ` THEN 
UNDISCH_TAC ` c = d3 va vb ` THEN 
SIMP_TAC[DELTA_X1I_RRR] THEN 
SIMP_TAC[MESON[UPS_X_SYM]` ups_x a b c = ups_x c b a `] THEN 
ONCE_REWRITE_TAC[EQ_SYM_EQ] THEN 
SIMP_TAC[] THEN 
REPEAT STRIP_TAC THEN 
UNDISCH_TAC ` ~collinear {(va:real^3), vb, vc} ` THEN 
NHANH (COND_FOR_CIRCUMCENTER_PROPERTIESS) THEN 
REWRITE_TAC[SET_RULE ` (! x. x IN {a,b,c} ==> P x )
  <=> P a /\ P b /\ P c `] THEN 
REWRITE_TAC[SET_RULE ` (! x. x IN {a,b,c} ==> P x )
  <=> P a /\ P b /\ P c `; MESON[]` (? cc. cc = a /\ cc = b /\ cc = c)
  <=> a = b /\ a = c  `] THEN 
UNDISCH_TAC ` v0 IN aff {va, vb, (vc:real^3)}` THEN 
REWRITE_TAC[aff; SET_RULE ` a IN s ==> b /\ aa IN s /\ l ==>
  ll <=> b ==>  {a,aa} SUBSET s /\ l ==> ll `] THEN 
DISCH_TAC THEN 
UNDISCH_TAC` r = d3 v0 va pow 2 ` THEN 
UNDISCH_TAC` r = d3 v0 vb pow 2 ` THEN 
UNDISCH_TAC` r = d3 v0 vc pow 2 ` THEN 
REWRITE_TAC[MESON[]` r = a1 ==> r = a2 ==> r = a3 ==> l ==> ll <=>
  r = a1 /\ l /\ a2 = a3 /\ a1 = a3 ==> ll `;d3] THEN 
ONCE_REWRITE_TAC[MESON[]` dist(a,b) = s <=> s = dist(a,b) `] THEN 
SIMP_TAC[DIST_POS_LE; EQ_POW2_COND] THEN 
ONCE_REWRITE_TAC[REAL_ARITH` a = b <=> a - b = &0 `] THEN 
REWRITE_TAC[MESON[]` ( a /\ a1 = &0 /\ a2 = &0 ) /\ b1 = &0 /\ b2 = &0 <=>
  b1 = &0 /\ b2 = &0 /\ a /\ b1 = a1 /\ b2 = a2 `] THEN 
NHANH (SPEC_ALL EQ_SUB_DIST_POW2_IMP_IDENTIFIED ) THEN 
STRIP_TAC THEN 
UNDISCH_TAC ` ~collinear {(va:real^3), vb, vc}` THEN 
NHANH (NOT_COL_IMP_RADV_PROPERTIY ) THEN 
FIRST_X_ASSUM MP_TAC THEN 
SIMP_TAC[] THEN 
SIMP_TAC[SET_RULE ` (!w. {va, vb, vc} w ==> P w ) <=>
  P va /\ P vb /\ P vc `] THEN 
REPEAT STRIP_TAC THEN 
EXPAND_TAC "a" THEN 
EXPAND_TAC "b" THEN 
EXPAND_TAC "c" THEN 
UNDISCH_TAC ` r - dist ((v0:real^3),vc) pow 2 = &0 ` THEN 
SIMP_TAC[REAL_ARITH` a - b = &0 <=> b = a `] THEN 
EXPAND_TAC "r" THEN 
REWRITE_TAC[eta_y; eta_x] THEN 
LET_TR THEN 
MP_TAC (GEN_ALL ZERO_LE_UPS_X) THEN 
SIMP_TAC[GSYM REAL_POW_2] THEN 
SIMP_TAC[REAL_ARITH` a * b * c = c * b * a `;
  UPS_X_SYM; d3] THEN 
MP_TAC (MESON[d3; DIST_POS_LE]` &0 <= d3 v0 vc `) THEN 
MP_TAC (MESON[REAL_LE_DIV; REAL_LE_MUL_EQ; REAL_LE_POW_2;REAL_LE_MUL; ZERO_LE_UPS_X;
SQRT_WORKS]` &0 <= ((d3 va vb pow 2 * d3 va vc pow 2 * d3 vb vc pow 2) /
      ups_x (d3 va vb pow 2) (d3 va vc pow 2) (d3 vb vc pow 2)) /\
  &0 <= sqrt ((d3 va vb pow 2 * d3 va vc pow 2 * d3 vb vc pow 2) /
      ups_x (d3 va vb pow 2) (d3 va vc pow 2) (d3 vb vc pow 2)) `) THEN 
REWRITE_TAC[MESON[]` a ==> b ==> c <=> b /\ a ==> c `] THEN 
MATCH_MP_TAC (MESON[]` (a1 /\ a3 ==> l) ==> a1 /\a2 /\a3 ==> l`) THEN 
SIMP_TAC[d3; EQ_POW2_COND; SQRT_WORKS]);;


let CDEUSDF = prove(`!(va:real^3) vb vc a b c.
     a = d3 vb vc /\ b = d3 va vc /\ c = d3 va vb /\ ~collinear {va, vb, vc}
     ==> (?p. p IN affine hull {va, vb, vc} /\
              (?c. ( !w. w IN {va, vb, vc} ==> c = dist (p,w)) /\
              (!p'. p' IN affine hull {va, vb, vc} /\
                    ( !w. w IN {va, vb, vc} ==> c = dist (p',w))
                    ==> p = p'))) /\
         (let al_a =
              (a pow 2 * (b pow 2 + c pow 2 - a pow 2)) /
              (ups_x (a pow 2) (b pow 2) (c pow 2)) in
          let al_b =
              (b pow 2 * (a pow 2 + c pow 2 - b pow 2)) /
              (ups_x (a pow 2) (b pow 2) (c pow 2)) in
          let al_c =
              (c pow 2 * (a pow 2 + b pow 2 - c pow 2)) /
              (ups_x (a pow 2) (b pow 2) (c pow 2)) in
          al_a % va + al_b % vb + al_c % vc = circumcenter {va, vb, vc}) /\
         radV {va, vb, vc} = eta_y a b c`,
SIMP_TAC[PROVE_EXISTS_RADV; CIRCUMCENTER_FORMULAR2;  NOT_COLL_IMP_RADV_FORMULAR ]);;

let LEMMA17 = CDEUSDF;;

let DIST_EQ_IS_UNIQUE = prove(` {u, w} SUBSET affine hull {v1, v2, v3} /\
  dist (u,v2) = dist (u,v1) /\ dist (u,v3) = dist (u,v1) /\
  dist (w,v2) = dist (w,v1) /\ dist (w,v3) = dist (w,v1) ==>
  u = w `,
SIMP_TAC[EQ_POW2_COND; DIST_POS_LE] THEN ONCE_REWRITE_TAC[REAL_ARITH`
 a = b <=> a - b = &0 `] THEN MESON_TAC[EQ_SUB_DIST_POW2_IMP_IDENTIFIED]);;


let NEVER_USED_AGAIN = prove(` p IN affine hull {va, vb, vc} /\ c = dist (p,va) 
/\ c = dist (p,vb) /\ c = dist (p,vc)  ==>
  (! p'.  p' IN affine hull {va, vb, vc} /\
           dist (p',vb) = dist (p',va) /\
           dist (p',vc) = dist (p',va) <=>
  p' IN affine hull {va, vb, vc} /\
  c = dist (p',va) /\
  c = dist (p',vb) /\
  c = dist (p',vc) )`,
MESON_TAC[DIST_EQ_IS_UNIQUE; SET2_SU_EX]);;



let TRUONG_WELL = prove(`! (va:real^3) vb vc. ~collinear {va, vb, vc}
     ==> (?p. p IN affine hull {va, vb, vc} /\
              (?c. !w. w IN {va, vb, vc} ==> c = dist (p,w)) /\
              (!p'. p' IN affine hull {va, vb, vc} /\
                    (?c. !w. w IN {va, vb, vc} ==> c = dist (p',w))
                    ==> p = p'))`,
NHANH (SPEC_ALL PROVE_EXISTS_RADV) THEN REPEAT STRIP_TAC THEN EXISTS_TAC `p:real^3`
THEN CONJ_TAC THENL [ASM_SIMP_TAC[]; CONJ_TAC] THENL [ASM_MESON_TAC[]; 
REPLICATE_TAC 3 (FIRST_X_ASSUM MP_TAC) THEN 
REWRITE_TAC[SET_RULE` (!a. a IN {x,y,z} ==> p a)
  <=> p x /\ p y /\ p z `] THEN 
REWRITE_TAC[MESON[]` (?c. c = a /\ c = b /\ c = cc ) <=>
 b = a /\ cc = a `]] THEN 
REWRITE_TAC[MESON[]` a ==> b ==> c <=> a /\b ==> c `] THEN 
  PHA THEN MESON_TAC[NEVER_USED_AGAIN ]);;




let NGAY_MONG6 = MESON[TRUONG_WELL] `! va vb (vc:real^3). 
         ~collinear {va, vb, vc} ==> (?p. p IN affine hull {va, vb, vc} /\
                  (?c. !w. w IN {va, vb, vc} ==> c = dist (p,w))  ) `;;


let CIRCUMCENTER_PROPTIES = prove(`!va vb (vc:real^3).
     ~collinear {va, vb, vc}
     ==> circumcenter {va, vb, vc} IN affine hull {va, vb, vc} /\
(?c. !w. w IN {va, vb, vc}
                  ==> c = dist (circumcenter {va, vb, vc},w))`,
NHANH (SPEC_ALL NGAY_MONG6) THEN REWRITE_TAC[IN; 
circumcenter; EXISTS_THM] THEN SIMP_TAC[]);;






let SIMP_DOT_ALEM = prove(  `&0 < (b - a) dot x <=> x dot (a - b) < &0`,
SIMP_TAC[DOT_SYM] THEN 
REWRITE_TAC[ REAL_ARITH ` a < &0 <=> &0 < -- a `; GSYM DOT_RNEG] THEN 
REWRITE_TAC[VECTOR_ARITH ` -- ((a:real^N) - b) = b - a `]);;




let MONG7_ROI = prove(` ! p a (b:real^A). dist (p,a) = dist (p,b) <=> 
  (p - &1 / &2 % ( a + b )) dot ( a - b)  = &0 `,
REWRITE_TAC[ REAL_ARITH ` a = b <=> ~ ( a < b) /\ ~( b < a ) `; 
DIST_LT_HALF_PLANE] THEN 
REWRITE_TAC[VECTOR_ARITH` (p - &1 / &2 % (a + b)) dot (a - b)
  = &1 / &2 * ( (&2 % p - (a + b ) ) dot ( a- b ) )  `] THEN 
REWRITE_TAC[REAL_ARITH `( &1 / &2 * a < &0 <=> a < &0) /\ 
(&0 < &1 / &2 * a <=> &0 < a )`] THEN 
REWRITE_TAC[SIMP_DOT_ALEM] THEN 
SIMP_TAC[VECTOR_ARITH` (a - b) dot (c - d) = (b - a) dot (d - c)`; DOT_SYM; 
VECTOR_ADD_SYM] THEN MESON_TAC[]);;

let LEMMA26 = prove(`!v1 v2 (v3:real^3) p.
     ~collinear {v1, v2, v3} /\ p = circumcenter {v1, v2, v3}
     ==> (p - &1 / &2 % (v1 + v2)) dot (v1 - v2) = &0 /\
         (p - &1 / &2 % (v2 + v3)) dot (v2 - v3) = &0 /\
         (p - &1 / &2 % (v3 + v1)) dot (v3 - v1) = &0`,
NHANH (SPEC_ALL CIRCUMCENTER_PROPTIES) THEN 
NHANH (SET_RULE` (?c. !w. w IN {v1, v2, v3} ==> c = P w) ==> P v1 = P v2
  /\ P v2 = P v3 /\ P v3 = P v1 `) THEN 
SIMP_TAC[MONG7_ROI]);;

let POXDVXO = LEMMA26;;



let NOT_COLL_IMP_RADV_EQ_ETA_Y = MESON[prove(`!va vb vc a b c.
     a = d3 vb vc /\ b = d3 va vc /\ c = d3 va vb /\ ~collinear {va, vb, vc}
     ==> radV {va, vb, vc} = eta_y (d3 vb vc) (d3 va vc) (d3 va vb)`,
SIMP_TAC[CDEUSDF])]` 
  !va vb vc . ~collinear {va, vb, vc}
     ==> radV {va, vb, vc} = eta_y (d3 vb vc) (d3 va vc) (d3 va vb)`;;


 g ` ! x (y:real^N). collinear {x,y} `;;
e (REPEAT GEN_TAC THEN REWRITE_TAC[collinear]);;
e (EXISTS_TAC ` x -(y: real^N)`);;
e (ASM_SIMP_TAC[SET_RULE` a = b ==> {a,b,c} = {a,c} `]);;
e (REWRITE_TAC[IN_SET2]);;
e (REPEAT GEN_TAC);;
e (STRIP_TAC);;

e (ASM_SIMP_TAC[] THEN EXISTS_TAC ` &0 ` THEN CONV_TAC VECTOR_ARITH);;

e (ASM_SIMP_TAC[] THEN EXISTS_TAC ` &1 ` THEN CONV_TAC VECTOR_ARITH);;

e (ASM_SIMP_TAC[] THEN EXISTS_TAC ` -- &1 ` THEN CONV_TAC VECTOR_ARITH);;

e (ASM_SIMP_TAC[] THEN EXISTS_TAC ` &0 ` THEN CONV_TAC VECTOR_ARITH);;
let COLLINEAR2 = top_thm();;


let TWO_EQ_IMP_COL3 = prove(` ! (x:real^N) y z .  x = y ==> collinear {x, y, z} `,
STRIP_TR THEN SIMP_TAC[SET_RULE` a = b ==> {a,b,c} = {a,c} `; COLLINEAR2]);;


let NOT_CO_IMP_DIST_POS = prove(`! x y z. ~ collinear {x,y,z} ==> &0 < dist (x,y) `,
NHANH (MESON[TWO_EQ_IMP_COL3]` ~collinear {x, y, z} ==> ~( x= y) `) THEN 
SIMP_TAC[DIST_POS_LT]);;


let NOT_COLL_IMP_POS_SUM = prove( ` !x y z.
     ~collinear {x, y, z} ==> &0 < ( d3 x y + d3 y z + d3 z x) / &2 `,
NHANH (SPEC_ALL NOT_CO_IMP_DIST_POS) THEN 
NHANH (MESON[DIST_POS_LE]` ~collinear {x, y, z} ==>
  &0 <= dist (y,z) /\ &0 <= dist (z,x) `) THEN 
SIMP_TAC[d3] THEN REAL_ARITH_TAC);;

let PER_SET2 = SET_RULE ` {a,b} = {b,a} `;;


let COLLINEAR_AS_IN_CONV2 = MESON[PER_SET2; COLLINERA_AS_IN_CONV2]`! x y (z:real^3). collinear {x, y, z} <=>
 x IN conv {y, z} \/ y IN conv {z, x} \/ z IN conv {x, y}`;;

let COLLINEAR_IMP_POS_UPS2 = prove(` ! x y (z:real^3). ~ collinear {x,y,z} ==>
  &0 < ups_x_pow2 ( d3 x y ) ( d3 y z ) ( d3 z x ) `,
REWRITE_TAC[PRE_HER] THEN NHANH (SPEC_ALL NOT_COLL_IMP_POS_SUM ) THEN 
REWRITE_TAC[COLLINEAR_AS_IN_CONV2] THEN REWRITE_TAC[MID_COND] THEN 
REWRITE_TAC[LENGTH_EQ_EX] THEN REWRITE_TAC[DE_MORGAN_THM] THEN 
SIMP_TAC[d3] THEN REPEAT GEN_TAC THEN SIMP_TAC[
prove(` &0 < a ==> ( &0 < &16 * a * b <=> &0 < b ) `,
REWRITE_TAC[REAL_ARITH ` &0 < &16 * a <=> &0 < a `] THEN 
REWRITE_TAC[REAL_LT_MUL_EQ])] THEN 
REWRITE_TAC[REAL_ARITH ` (a + b + c ) / &2 - a = ( b + c - a ) / &2 `] THEN 
REWRITE_TAC[REAL_ARITH ` (a + b + c ) / &2 - b = ( c + a - b ) / &2 `] THEN 
REWRITE_TAC[REAL_ARITH ` (a + b + c ) / &2 - c = ( a + b - c ) / &2 `] THEN 
REWRITE_TAC[REAL_ARITH ` a < b + c <=> &0 < ( b + c - a ) / &2 `] THEN 
SIMP_TAC[DIST_SYM] THEN SIMP_TAC[REAL_ARITH ` a + b - c = b + a - c `] THEN 
SIMP_TAC[REAL_LT_MUL]);;



let RADV_FORMULAR = MESON[CDEUSDF]` !(va:real^3) vb vc.
     ~collinear {va, vb, vc}
     ==> radV {va, vb, vc} = eta_y (d3 vb vc) (d3 va vc) (d3 va vb)`;;



let MUL3_SYM = REAL_ARITH ` ! a b c. a * b * c = b * a * c /\
  a * b * c = c * b * a `;;

let ETA_X_SYMM = prove(` ! a b c. eta_x a b c = eta_x b a c /\
 eta_x a b c = eta_x c b a `,SIMP_TAC[eta_x; MUL3_SYM; UPS_X_SYM]);;

let ETA_Y_SYYM = prove(` ! x y z. eta_y x y z = eta_y y x z /\ 
eta_y x y z = eta_y z y x `, REWRITE_TAC[eta_y] THEN 
CONV_TAC (TOP_DEPTH_CONV let_CONV) THEN MESON_TAC[ETA_X_SYMM]);;



let NOT_COL3_IMP_DIFF = MESON[PER_SET3; TWO_EQ_IMP_COL3]`!a b c. 
~collinear {a, b, c} ==> ~(a = b \/ a = c \/ b = c)`;;

let LET_TR = CONV_TAC (TOP_DEPTH_CONV let_CONV);;


let POW2_COND_LT = MESON[POW2_COND; REAL_ARITH ` &0 < a ==> &0 <= a `]` 
  !a b. &0 < a /\ &0 < b ==> (a <= b <=> a pow 2 <= b pow 2)`;;


let ETA_Y_2 = prove(` eta_y (&2) (&2) (&2)  = &2 / sqrt (&3) `,
REWRITE_TAC[eta_y; eta_x; ups_x] THEN 
LET_TR THEN 
REWRITE_TAC[REAL_ARITH ` ((&2 * &2) * (&2 * &2) * &2 * &2) /
  (--(&2 * &2) * &2 * &2 - (&2 * &2) * &2 * &2 - (&2 * &2) * &2 * &2 +
   &2 * (&2 * &2) * &2 * &2 +
   &2 * (&2 * &2) * &2 * &2 +
   &2 * (&2 * &2) * &2 * &2) = &4 / &3 `] THEN 
MP_TAC (MESON[REAL_LT_DIV; MESON[SQRT_POS_LT; REAL_ARITH` &0 < &3 `] ` 
&0 < sqrt (&3) `; REAL_ARITH ` &0 < &2 /\ &0 < &4 /\ &0 < &3 `] ` &0 < &4 / &3 
/\ &0 < &2 / sqrt (&3) `) THEN 
REWRITE_TAC[REAL_ARITH` a = b <=> a <= b /\ b <= a `] THEN 
SIMP_TAC[SQRT_POS_LT; POW2_COND_LT] THEN 
REWRITE_TAC[GSYM (REAL_ARITH` a = b <=> a <= b /\ b <= a `)] THEN 
SIMP_TAC[REAL_LT_IMP_LE; SQRT_POW_2] THEN 
REWRITE_TAC[REAL_FIELD` (a/ b) pow 2 = a pow 2 / ( b pow 2 ) `] THEN 
SIMP_TAC[REAL_ARITH ` &0 <= &3 `; SQRT_POW_2] THEN 
REAL_ARITH_TAC);;

let D3_POS_LE = MESON[d3; DIST_POS_LE]` ! x y. &0 <= d3 x y `;;


(* le 19. p 17 *)
let BYOWBDF = new_axiom`! a b c a' b' ( c':real). &0 < a /\
         a <= a' /\
         &0 < b /\
         b <= b' /\
         &0 < c /\
         c <= c' /\
         a' pow 2 <= b pow 2 + c pow 2 /\
         b' pow 2 <= a pow 2 + c pow 2 /\
         c' pow 2 <= a pow 2 + b pow 2
         ==> eta_y a b c <= eta_y a' b' c' `;;


let LEMMA25 = prove(` !(a:real^3) b c.
 packing {a, b, c} /\ ~ collinear {a,b,c}
         ==> &2 / sqrt (&3) <= radV {a, b, c} `, 
SIMP_TAC[RADV_FORMULAR] THEN REPEAT GEN_TAC THEN 
ASM_CASES_TAC ` (? x. x IN  { d3 b c, d3 c a, d3 a b } /\ &4 / sqrt (&3)
    <= x ) ` THENL [DOWN_TAC THEN STRIP_TAC THEN DOWN_TAC THEN 
NHANH (SPEC_ALL COLLINEAR_IMP_POS_UPS2) THEN 
REWRITE_TAC[d3] THEN NHANH (MESON[DIST_POS_LE; HVXIKHW]` 
&0 < ups_x_pow2 (dist (a,b)) (dist (b,c)) (dist (c,a))
  ==> max_real3 (dist (a,b)) (dist (b,c)) (dist (c,a)) / &2 <=
 eta_y (dist (a,b)) (dist (b,c)) (dist (c,a)) `) THEN 
REWRITE_TAC[REAL_ARITH` a / &2 <= b <=> a <= &2 * b `; MAX_REAL3_LESS_EX] THEN 
NHANH (SET_RULE ` x IN { a , b, c } /\ a1/\a2/\a3/\a4 /\ c <= aa /\ a <= aa
  /\ b <= aa ==> x <= aa `) THEN REWRITE_TAC[MESON[]` a/ b <= aa /\ l <=> l 
/\ a/b <= aa `] THEN PHA THEN DAO THEN 
NHANH (MESON[REAL_LE_TRANS]` a <= b /\ c <= a /\ l ==> c <= b `) THEN 
MATCH_MP_TAC (MESON[]` ( b ==> c ) ==> a/\b ==> c `) THEN 
REWRITE_TAC[REAL_ARITH ` &4 / a <= &2 * b <=> &2 / a <= b `] THEN 
MESON_TAC[DIST_SYM; ETA_Y_SYYM]; REWRITE_TAC[packing] THEN 
NHANH (SPEC_ALL NOT_COL3_IMP_DIFF) THEN 
NHANH (SET_RULE` (!u v. {a, b, c} u /\ {a, b, c} v /\ ~(u = v) ==> P u v )
  /\ l /\ ~(a = b \/ a = c \/ b = c) ==> P a b /\ P b c /\ P c a `) THEN 
DOWN_TAC THEN REWRITE_TAC[NOT_EXISTS_THM] THEN 
NHANH (SET_RULE` (! x. ~( x IN {a,b,c} /\ P x )) ==> ~ P a /\ ~P b /\ ~P c`) THEN 
SIMP_TAC[MESON[REAL_LE_DIV; SQRT_POS_LE; REAL_ARITH ` &0 <= &3 /\ &0 <= &4 `]`
     &0 <=  &4 / sqrt (&3)  `; D3_POS_LE; POW2_COND] THEN 
REWRITE_TAC[REAL_ARITH` ~( a <= b ) <=> b < a `] THEN 
REWRITE_TAC[REAL_FIELD` ( &4 / a ) pow 2 = &16 / ( a pow 2 ) `] THEN 
SIMP_TAC[REAL_ARITH` &0 <= &3 `; SQRT_POW_2] THEN 
NHANH (REAL_ARITH ` a < &16 / &3 ==> a <= &2 pow 2 + &2 pow 2 `) THEN 
PHA THEN REWRITE_TAC[MESON[]` a <= b + c /\ d <=> d /\ a <= b + c `] THEN 
REWRITE_TAC[GSYM d3] THEN PHA THEN 
NHANH (MESON[REAL_ARITH `&0 < &2 `; BYOWBDF]`&2 <= d3 a b /\
 &2 <= d3 b c /\ &2 <= d3 c a /\ d3 a b pow 2 <= &2 pow 2 + &2 pow 2 /\
 d3 c a pow 2 <= &2 pow 2 + &2 pow 2 /\ d3 b c pow 2 <= &2 pow 2 + &2 pow 2 
==>  eta_y (&2) (&2) (&2) <= eta_y (d3 a b) (d3 b c) (d3 c a) `) THEN 
DAO THEN MATCH_MP_TAC (TAUT` (a ==> b) ==> a /\ c ==> b `) THEN 
SIMP_TAC[ETA_Y_2;D3_SYM; ETA_Y_SYYM] THEN MESON_TAC[ETA_Y_SYYM]]);;

let HMWTCNS = LEMMA25;;


let COEF1_POS_EQ_V1_IN = prove(`!v1 v2 v3 (v:real^3). ~collinear {v1, v2, v3} /\ 
v IN affine hull {v1, v2, v3} ==> 
  ( &0 < coef1 v1 v2 v3 v <=> v IN aff_gt {v2, v3} {v1} ) `, DAO THEN 
NHANH (SPEC_ALL COEFS) THEN REWRITE_TAC[simp_def2; IN_ELIM_THM] THEN 
MESON_TAC[REAL_ADD_AC; VEC_PER2_3]);;


let COEFS1_EQ_0_IFF_V_IN_AFF = prove(` !v1 v2 v3 v.
         ~collinear {v1, v2, v3} /\ v IN affine hull {v1, v2, v3} ==>
  (&0 = coef1 v1 v2 v3 v <=> v IN aff {v2, v3}) `,
DAO THEN NHANH (SPEC_ALL COEFS) THEN 
REWRITE_TAC[AFF_2POINTS_INTERPRET; IN_ELIM_THM] THEN 
REPEAT GEN_TAC THEN STRIP_TAC THEN EQ_TAC THENL [
DOWN_TAC THEN DAO THEN PURE_ONCE_REWRITE_TAC[MESON[]` &0 = a /\
 P a <=> &0 = a /\ P ( &0 ) `] THEN REWRITE_TAC[VECTOR_MUL_LZERO;
 VECTOR_ADD_LID; REAL_ADD_LID] THEN MESON_TAC[]; 
STRIP_TAC THEN DOWN_TAC THEN DAO THEN 
MESON_TAC[VECTOR_MUL_LZERO; VECTOR_ADD_LID; REAL_ADD_LID]]);;


let cayleytr = new_definition ` 
  cayleytr x12 x13 x14 x15 x23 x24 x25 x34 x35 x45 = 
  &2 * x23 * x25 * x34 +
      &2 * x23 * x24 * x35 +
      -- &1 * x23 pow 2 * x45 +
      -- &2 * x15 * x23 * x34 +
      -- &2 * x15 * x23 * x24 +
      &2 * x15 * x23 pow 2 +
      -- &2 * x14 * x23 * x35 +
      -- &2 * x14 * x23 * x25 +
      &2 * x14 * x23 pow 2 +
      &4 * x14 * x15 * x23 +
      -- &2 * x13 * x25 * x34 +
      -- &2 * x13 * x24 * x35 +
      &4 * x13 * x24 * x25 +
      &2 * x13 * x23 * x45 +
      -- &2 * x13 * x23 * x25 +
      -- &2 * x13 * x23 * x24 +
      &2 * x13 * x15 * x34 +
      -- &2 * x13 * x15 * x24 +
      -- &2 * x13 * x15 * x23 +
      &2 * x13 * x14 * x35 +
      -- &2 * x13 * x14 * x25 +
      -- &2 * x13 * x14 * x23 +
      -- &1 * x13 pow 2 * x45 +
      &2 * x13 pow 2 * x25 +
      &2 * x13 pow 2 * x24 +
      &4 * x12 * x34 * x35 +
      -- &2 * x12 * x25 * x34 +
      -- &2 * x12 * x24 * x35 +
      &2 * x12 * x23 * x45 +
      -- &2 * x12 * x23 * x35 +
      -- &2 * x12 * x23 * x34 +
   -- &2 * x12 * x15 * x34 +
      &2 * x12 * x15 * x24 +
      -- &2 * x12 * x15 * x23 +
      -- &2 * x12 * x14 * x35 +
      &2 * x12 * x14 * x25 +
      -- &2 * x12 * x14 * x23 +
      &2 * x12 * x13 * x45 +
      -- &2 * x12 * x13 * x35 +
      -- &2 * x12 * x13 * x34 +
      -- &2 * x12 * x13 * x25 +
      -- &2 * x12 * x13 * x24 +
      &4 * x12 * x13 * x23 +
      -- &1 * x12 pow 2 * x45 +
      &2 * x12 pow 2 * x35 +
      &2 * x12 pow 2 * x34 `;;


let LTCTBAN = prove(` cayleyR x12 x13 x14 x15 x23 x24 x25 x34 x35 x45 = 
ups_x x12 x13 x23 * x45 pow 2 + cayleytr x12 x13 x14 x15 x23 x24 x25 x34 x35 ( &0 )
* x45 + cayleyR x12 x13 x14 x15 x23 x24 x25 x34 x35 ( &0 ) `,
REWRITE_TAC[ups_x; cayleyR;cayleytr] THEN REAL_ARITH_TAC);;


let COEF1_NEG_IFF_V1_IN_AFF_LT = prove(` ! v1 v2 v3 v. ~collinear {v1, v2, v3} /\
 v IN affine hull {v1, v2, v3}
  ==> (coef1 v1 v2 v3 v < &0 <=> v IN aff_lt {v2, v3} {v1}) `,
DAO THEN NHANH (SPEC_ALL COEFS) THEN REWRITE_TAC[simp_def2; IN_ELIM_THM] THEN 
MESON_TAC[REAL_ADD_AC; VEC_PER2_3]);;

let condA = new_definition `condA (v1:real^3) v2 v3 v4 x12 x13 x14 x23 x24 x34 = 
  ( ~ ( v1 = v2 ) /\ coplanar {v1,v2,v3,v4} /\
  ( dist ( v1, v2) pow 2 ) = x12 /\
  dist (v1,v3) pow 2 = x13 /\
  dist (v1,v4) pow 2 = x14 /\
  dist (v2,v3) pow 2 = x23 /\ dist (v2,v4) pow 2 = x24 )`;;


let det_vec3 = new_definition ` det_vec3 (a:real^3) (b:real^3) (c:real^3) = 
  a$1 * b$2 * c$3 + b$1 * c$2 * a$3 + c$1 * a$2 * b$3 - 
  ( a$1 * c$2 * b$3 + b$1 * a$2 * c$3 + c$1 * b$2 * a$3 ) `;;


(* the following lemmas has been proved as follow, but it 
run after some files that are not conmpatibale here *)

let COPLANAR_DET_VEC3_EQ_0 = new_axiom  `!v0 v1 (v2: real^3) v3.
       coplanar {v0,v1,v2,v3} <=>
       det_vec3 ( v1 - v0 ) ( v2 - v0 ) ( v3 - v0 ) = &0`;;


let NONCOPLANAR_3_BASIS = new_axiom
 (`!v1 v2 v3 v0 v:real^3.
    ~coplanar {v0, v1, v2, v3}
    ==> (?t1 t2 t3.
             v = t1 % (v1 - v0) + t2 % (v2 - v0) + t3 % (v3 - v0) /\
             (!ta tb tc.
                  v = ta % (v1 - v0) + tb % (v2 - v0) + tc % (v3 - v0)
                ==> ta = t1 /\ tb = t2 /\ tc = t3))`);;


let COPLANAR = new_axiom`2 <= dimindex(:N)
  ==> !s:real^N->bool. coplanar s <=> ?u v w. s SUBSET affine hull {u,v,w}`;;


let COPLANAR_3 = new_axiom `!a b c:real^N. 2 <= dimindex(:N) ==> coplanar {a,b,c}`;;

(* 
needs "Multivariate/determinants.ml";;
needs "Multivariate/convex.ml";;

(* ------------------------------------------------------------------------- *)
(* Flyspeck definitions we use.                                              *)
(* ------------------------------------------------------------------------- *)

let plane = new_definition
 `plane x = (?u v w. ~(collinear {u,v,w}) /\ (x = affine hull {u,v,w}))`;;

let coplanar = new_definition `coplanar S = (?x. plane x /\ S SUBSET x)`;;



let COPLANAR_DET_EQ_0 = prove
 (`!v0 v1 (v2: real^3) v3.
       coplanar {v0,v1,v2,v3} <=>
       det(vector[v1 - v0; v2 - v0; v3 - v0]) = &0`,
 REPEAT GEN_TAC THEN REWRITE_TAC[DET_EQ_0_RANK; RANK_ROW] THEN
 REWRITE_TAC[rows; row; LAMBDA_ETA] THEN
 ONCE_REWRITE_TAC[SIMPLE_IMAGE_GEN] THEN
 REWRITE_TAC[GSYM numseg; DIMINDEX_3] THEN
 CONV_TAC(ONCE_DEPTH_CONV NUMSEG_CONV) THEN
 SIMP_TAC[IMAGE_CLAUSES; VECTOR_3] THEN EQ_TAC THENL
  [REWRITE_TAC[coplanar; plane; LEFT_AND_EXISTS_THM; LEFT_IMP_EXISTS_THM] THEN
   MAP_EVERY X_GEN_TAC
    [`p:real^3->bool`; `a:real^3`; `b:real^3`; `c:real^3`] THEN
   DISCH_THEN(CONJUNCTS_THEN2 STRIP_ASSUME_TAC MP_TAC) THEN
   FIRST_X_ASSUM SUBST1_TAC THEN
   W(MP_TAC o PART_MATCH lhand AFFINE_HULL_INSERT_SUBSET_SPAN o
       rand o lhand o snd) THEN
   REWRITE_TAC[GSYM IMP_CONJ_ALT] THEN
   DISCH_THEN(MP_TAC o MATCH_MP SUBSET_TRANS) THEN
   DISCH_THEN(MP_TAC o ISPEC `\x:real^3. x - a` o MATCH_MP IMAGE_SUBSET) THEN
   ONCE_REWRITE_TAC[SIMPLE_IMAGE_GEN] THEN
   REWRITE_TAC[IMAGE_CLAUSES; GSYM IMAGE_o; o_DEF; VECTOR_ADD_SUB; IMAGE_ID;
               SIMPLE_IMAGE] THEN
   REWRITE_TAC[INSERT_SUBSET] THEN STRIP_TAC THEN
   GEN_REWRITE_TAC LAND_CONV [GSYM DIM_SPAN] THEN MATCH_MP_TAC LET_TRANS THEN
   EXISTS_TAC `CARD {b - a:real^3,c - a}` THEN
   CONJ_TAC THENL
    [MATCH_MP_TAC SPAN_CARD_GE_DIM;
     SIMP_TAC[CARD_CLAUSES; FINITE_RULES] THEN ARITH_TAC] THEN
   REWRITE_TAC[FINITE_INSERT; FINITE_RULES] THEN
   GEN_REWRITE_TAC RAND_CONV [GSYM SPAN_SPAN] THEN
   MATCH_MP_TAC SPAN_MONO THEN REWRITE_TAC[INSERT_SUBSET; EMPTY_SUBSET] THEN
   MP_TAC(VECTOR_ARITH `!x y:real^3. x - y = (x - a) - (y - a)`) THEN
   DISCH_THEN(fun th -> REPEAT CONJ_TAC THEN
     GEN_REWRITE_TAC LAND_CONV [th]) THEN
   MATCH_MP_TAC SPAN_SUB THEN ASM_REWRITE_TAC[];

   DISCH_TAC THEN
   MP_TAC(ISPECL [`{v1 - v0,v2 - v0,v3 - v0}:real^3->bool`; `2`]
                 LOWDIM_EXPAND_BASIS) THEN
   ASM_REWRITE_TAC[ARITH_RULE `n <= 2 <=> n < 3`; DIMINDEX_3; ARITH] THEN
   DISCH_THEN(X_CHOOSE_THEN `t:real^3->bool`
    (CONJUNCTS_THEN2 MP_TAC STRIP_ASSUME_TAC)) THEN
   CONV_TAC(LAND_CONV HAS_SIZE_CONV) THEN
   REWRITE_TAC[LEFT_IMP_EXISTS_THM] THEN
   MAP_EVERY X_GEN_TAC [`a:real^3`; `b:real^3`] THEN
   DISCH_THEN(CONJUNCTS_THEN2 ASSUME_TAC SUBST_ALL_TAC) THEN
   REWRITE_TAC[coplanar; plane] THEN
   EXISTS_TAC `affine hull {v0,v0 + a,v0 + b}:real^3->bool` THEN
   CONJ_TAC THENL
    [MAP_EVERY EXISTS_TAC [`v0:real^3`; `v0 + a:real^3`; `v0 + b:real^3`] THEN
     REWRITE_TAC[COLLINEAR_3; COLLINEAR_LEMMA;
                 VECTOR_ARITH `--x = vec 0 <=> x = vec 0`;
                 VECTOR_ARITH `u - (u + a):real^3 = --a`;
                 VECTOR_ARITH `(u + b) - (u + a):real^3 = b - a`] THEN
     REWRITE_TAC[DE_MORGAN_THM; VECTOR_SUB_EQ;
       VECTOR_ARITH `b - a = c % -- a <=> (c - &1) % a + &1 % b = vec 0`] THEN
     ASM_REWRITE_TAC[] THEN CONJ_TAC THENL
      [ASM_MESON_TAC[IN_INSERT; INDEPENDENT_NONZERO]; ALL_TAC] THEN
     DISCH_THEN(X_CHOOSE_TAC `u:real`) THEN
     FIRST_X_ASSUM(MP_TAC o GEN_REWRITE_RULE I [independent]) THEN
     REWRITE_TAC[DEPENDENT_EXPLICIT] THEN
     MAP_EVERY EXISTS_TAC [`{a:real^3,b}`;
                           `\x:real^3. if x = a then u - &1 else &1`] THEN
     REWRITE_TAC[FINITE_INSERT; FINITE_RULES; SUBSET_REFL] THEN
     CONJ_TAC THENL
      [EXISTS_TAC `b:real^3` THEN ASM_REWRITE_TAC[IN_INSERT] THEN
       REAL_ARITH_TAC;
       ALL_TAC] THEN
     SIMP_TAC[VSUM_CLAUSES; FINITE_RULES] THEN
     ASM_REWRITE_TAC[IN_INSERT; NOT_IN_EMPTY; VECTOR_ADD_RID];
     ALL_TAC] THEN
   W(MP_TAC o PART_MATCH (lhs o rand) AFFINE_HULL_INSERT_SPAN o
     rand o snd) THEN
   ANTS_TAC THENL
    [REWRITE_TAC[IN_INSERT; NOT_IN_EMPTY] THEN
     REWRITE_TAC[VECTOR_ARITH `u = u + a <=> a = vec 0`] THEN
     ASM_MESON_TAC[INDEPENDENT_NONZERO; IN_INSERT];
     ALL_TAC] THEN
   DISCH_THEN SUBST1_TAC THEN
   ONCE_REWRITE_TAC[SIMPLE_IMAGE_GEN] THEN
   REWRITE_TAC[SIMPLE_IMAGE; IMAGE_CLAUSES; IMAGE_ID; VECTOR_ADD_SUB] THEN
   MATCH_MP_TAC SUBSET_TRANS THEN EXISTS_TAC
    `IMAGE (\v:real^3. v0 + v) (span{v1 - v0, v2 - v0, v3 - v0})` THEN
   ASM_SIMP_TAC[IMAGE_SUBSET] THEN
   REWRITE_TAC[INSERT_SUBSET; EMPTY_SUBSET; IN_IMAGE] THEN CONJ_TAC THENL
    [EXISTS_TAC `vec 0:real^3` THEN REWRITE_TAC[SPAN_0] THEN VECTOR_ARITH_TAC;
     REWRITE_TAC[VECTOR_ARITH `v1:real^N = v0 + x <=> x = v1 - v0`] THEN
     REWRITE_TAC[UNWIND_THM2] THEN REPEAT CONJ_TAC THEN
     MATCH_MP_TAC SPAN_SUPERSET THEN REWRITE_TAC[IN_INSERT]]]);;



let COPLANAR = prove
 (`2 <= dimindex(:N)
  ==> !s:real^N->bool. coplanar s <=> ?u v w. s SUBSET affine hull {u,v,w}`,
 DISCH_TAC THEN GEN_TAC THEN REWRITE_TAC[coplanar; plane] THEN
 REWRITE_TAC[LEFT_AND_EXISTS_THM] THEN
 ONCE_REWRITE_TAC[MESON[]
  `(?x u v w. p x u v w) <=> (?u v w x. p x u v w)`] THEN
 REWRITE_TAC[GSYM CONJ_ASSOC; RIGHT_EXISTS_AND_THM; UNWIND_THM2] THEN
 EQ_TAC THENL [MESON_TAC[]; REWRITE_TAC[LEFT_IMP_EXISTS_THM]] THEN
 MAP_EVERY X_GEN_TAC [`u:real^N`; `v:real^N`; `w:real^N`] THEN DISCH_TAC THEN
 SUBGOAL_THEN
  `s SUBSET {u + x:real^N | x | x IN span {y - u | y IN {v,w}}}`
 MP_TAC THENL
  [FIRST_X_ASSUM(MATCH_MP_TAC o MATCH_MP
    (REWRITE_RULE[IMP_CONJ] SUBSET_TRANS)) THEN
   REWRITE_TAC[AFFINE_HULL_INSERT_SUBSET_SPAN];
   ALL_TAC] THEN
 ONCE_REWRITE_TAC[SIMPLE_IMAGE_GEN] THEN
 DISCH_THEN(MP_TAC o ISPEC `\x:real^N. x - u` o MATCH_MP IMAGE_SUBSET) THEN
 REWRITE_TAC[GSYM IMAGE_o; o_DEF; VECTOR_ADD_SUB; IMAGE_ID; SIMPLE_IMAGE] THEN
 REWRITE_TAC[IMAGE_CLAUSES] THEN
 MP_TAC(ISPECL [`{v - u:real^N,w - u}`; `2`] LOWDIM_EXPAND_BASIS) THEN
 ANTS_TAC THENL
  [ASM_REWRITE_TAC[] THEN MATCH_MP_TAC LE_TRANS THEN
   EXISTS_TAC `CARD{v - u:real^N,w - u}` THEN
   SIMP_TAC[DIM_LE_CARD; FINITE_INSERT; FINITE_RULES] THEN
   SIMP_TAC[CARD_CLAUSES; FINITE_RULES] THEN ARITH_TAC;
   ALL_TAC] THEN
 DISCH_THEN(X_CHOOSE_THEN `t:real^N->bool`
  (CONJUNCTS_THEN2 MP_TAC STRIP_ASSUME_TAC)) THEN
 CONV_TAC(LAND_CONV HAS_SIZE_CONV) THEN
 REWRITE_TAC[LEFT_IMP_EXISTS_THM] THEN
 MAP_EVERY X_GEN_TAC [`a:real^N`; `b:real^N`] THEN
 DISCH_THEN(CONJUNCTS_THEN2 ASSUME_TAC SUBST_ALL_TAC) THEN
 UNDISCH_TAC `span {v - u, w - u} SUBSET span {a:real^N, b}` THEN
 REWRITE_TAC[GSYM IMP_CONJ_ALT] THEN
 DISCH_THEN(ASSUME_TAC o MATCH_MP SUBSET_TRANS) THEN
 MAP_EVERY EXISTS_TAC [`u:real^N`; `u + a:real^N`; `u + b:real^N`] THEN
 CONJ_TAC THENL
  [REWRITE_TAC[COLLINEAR_3; COLLINEAR_LEMMA;
               VECTOR_ARITH `--x = vec 0 <=> x = vec 0`;
               VECTOR_ARITH `u - (u + a):real^N = --a`;
               VECTOR_ARITH `(u + b) - (u + a):real^N = b - a`] THEN
   REWRITE_TAC[DE_MORGAN_THM; VECTOR_SUB_EQ;
     VECTOR_ARITH `b - a = c % -- a <=> (c - &1) % a + &1 % b = vec 0`] THEN
   ASM_REWRITE_TAC[] THEN CONJ_TAC THENL
    [ASM_MESON_TAC[IN_INSERT; INDEPENDENT_NONZERO]; ALL_TAC] THEN
   DISCH_THEN(X_CHOOSE_TAC `u:real`) THEN
   FIRST_X_ASSUM(MP_TAC o GEN_REWRITE_RULE I [independent]) THEN
   REWRITE_TAC[DEPENDENT_EXPLICIT] THEN
   MAP_EVERY EXISTS_TAC [`{a:real^N,b}`;
                         `\x:real^N. if x = a then u - &1 else &1`] THEN
   REWRITE_TAC[FINITE_INSERT; FINITE_RULES; SUBSET_REFL] THEN
   CONJ_TAC THENL
    [EXISTS_TAC `b:real^N` THEN ASM_REWRITE_TAC[IN_INSERT] THEN
     REAL_ARITH_TAC;
     ALL_TAC] THEN
   SIMP_TAC[VSUM_CLAUSES; FINITE_RULES] THEN
   ASM_REWRITE_TAC[IN_INSERT; NOT_IN_EMPTY; VECTOR_ADD_RID];
   ALL_TAC] THEN
 W(MP_TAC o PART_MATCH (lhs o rand) AFFINE_HULL_INSERT_SPAN o rand o snd) THEN
 ANTS_TAC THENL
  [REWRITE_TAC[IN_INSERT; NOT_IN_EMPTY] THEN
   REWRITE_TAC[VECTOR_ARITH `u = u + a <=> a = vec 0`] THEN
   ASM_MESON_TAC[INDEPENDENT_NONZERO; IN_INSERT];
   ALL_TAC] THEN
 DISCH_THEN SUBST1_TAC THEN
 FIRST_ASSUM(MP_TAC o ISPEC `\x:real^N. u + x` o MATCH_MP IMAGE_SUBSET) THEN
 REWRITE_TAC[GSYM IMAGE_o; o_DEF; IMAGE_ID;
             ONCE_REWRITE_RULE[VECTOR_ADD_SYM] VECTOR_SUB_ADD] THEN
 MATCH_MP_TAC(REWRITE_RULE[IMP_CONJ_ALT] SUBSET_TRANS) THEN
 REWRITE_TAC[SUBSET; FORALL_IN_IMAGE] THEN
 REWRITE_TAC[SIMPLE_IMAGE; IMAGE_CLAUSES; VECTOR_ADD_SUB] THEN
 SET_TAC[]);;

(* this LEMMA in determinants.ml *)
let DET_3 = new_axiom`!A:real^3^3.
        det(A) = A$1$1 * A$2$2 * A$3$3 +
                 A$1$2 * A$2$3 * A$3$1 +
                 A$1$3 * A$2$1 * A$3$2 -
                 A$1$1 * A$2$3 * A$3$2 -
                 A$1$2 * A$2$1 * A$3$3 -
                 A$1$3 * A$2$2 * A$3$1`;;


let det_vec3 = new_definition ` det_vec3 (a:real^3) (b:real^3) (c:real^3) = 
  a$1 * b$2 * c$3 + b$1 * c$2 * a$3 + c$1 * a$2 * b$3 - 
  ( a$1 * c$2 * b$3 + b$1 * a$2 * c$3 + c$1 * b$2 * a$3 ) `;;


let DET_VEC3_EXPAND = prove
 (`det (vector [a; b; (c:real^3)] ) = det_vec3 a b c`,
 REWRITE_TAC[det_vec3; DET_3; VECTOR_3] THEN REAL_ARITH_TAC);;

let COPLANAR_DET_VEC3_EQ_0 = prove( `!v0 v1 (v2: real^3) v3.
       coplanar {v0,v1,v2,v3} <=>
       det_vec3 ( v1 - v0 ) ( v2 - v0 ) ( v3 - v0 ) = &0`, REWRITE_TAC[COPLANAR_DET_EQ_0; DET_VEC3_EXPAND]);;



let COPLANAR_3 = prove
 (`!a b c:real^N. 2 <= dimindex(:N) ==> coplanar {a,b,c}`,
 SIMP_TAC[COPLANAR; SUBSET] THEN MESON_TAC[HULL_INC]);;

let NONCOPLANAR_4_DISTINCT = prove
 (`!a b c d:real^N.
       ~(coplanar{a,b,c,d}) /\ 2 <= dimindex(:N)
       ==> ~(a = b) /\ ~(a = c) /\ ~(a = d) /\
           ~(b = c) /\ ~(b = d) /\ ~(c = d)`,
 REPEAT GEN_TAC THEN DISCH_THEN(CONJUNCTS_THEN2 MP_TAC ASSUME_TAC) THEN
 ONCE_REWRITE_TAC[GSYM CONTRAPOS_THM] THEN REWRITE_TAC[DE_MORGAN_THM] THEN
 STRIP_TAC THEN ASM_SIMP_TAC[INSERT_AC; COPLANAR_3]);;



let NONCOPLANAR_3_BASIS = prove
 (`!v1 v2 v3 v0 v:real^3.
    ~coplanar {v0, v1, v2, v3}
    ==> (?t1 t2 t3.
             v = t1 % (v1 - v0) + t2 % (v2 - v0) + t3 % (v3 - v0) /\
             (!ta tb tc.
                  v = ta % (v1 - v0) + tb % (v2 - v0) + tc % (v3 - v0)
                  ==> ta = t1 /\ tb = t2 /\ tc = t3))`,
 REPEAT STRIP_TAC THEN
 FIRST_ASSUM(MP_TAC o MATCH_MP (REWRITE_RULE[IMP_CONJ]
   NONCOPLANAR_4_DISTINCT)) THEN
 REWRITE_TAC[DIMINDEX_3; ARITH] THEN STRIP_TAC THEN
 SUBGOAL_THEN `independent {v1 - v0:real^3,v2 - v0,v3 - v0}` ASSUME_TAC THENL
  [FIRST_X_ASSUM(MP_TAC o GEN_REWRITE_RULE RAND_CONV [COPLANAR_DET_EQ_0]) THEN
   ONCE_REWRITE_TAC[GSYM CONTRAPOS_THM] THEN REWRITE_TAC[independent] THEN
   DISCH_TAC THEN MATCH_MP_TAC DET_DEPENDENT_ROWS THEN
   REWRITE_TAC[rows; row; LAMBDA_ETA; GSYM IN_NUMSEG; DIMINDEX_3] THEN
   ONCE_REWRITE_TAC[SIMPLE_IMAGE] THEN
   CONV_TAC(ONCE_DEPTH_CONV NUMSEG_CONV) THEN
   ASM_REWRITE_TAC[IMAGE_CLAUSES; VECTOR_3];
   ALL_TAC] THEN
 MP_TAC(ISPECL [`(:real^3)`; `{v1 - v0:real^3,v2 - v0,v3 - v0}`]
   CARD_GE_DIM_INDEPENDENT) THEN
 ASM_REWRITE_TAC[DIM_UNIV; SUBSET_UNIV] THEN ANTS_TAC THENL
  [SIMP_TAC[CARD_CLAUSES; FINITE_INSERT; FINITE_RULES] THEN
   ASM_REWRITE_TAC[IN_INSERT; NOT_IN_EMPTY; DIMINDEX_3; ARITH;
                   VECTOR_ARITH `x - a:real^N = y - a <=> x = y`];
   ALL_TAC] THEN
 REWRITE_TAC[SUBSET; IN_UNIV; SPAN_BREAKDOWN_EQ; SPAN_EMPTY] THEN
 DISCH_THEN(MP_TAC o SPEC `v:real^3`) THEN
 MAP_EVERY (fun t -> MATCH_MP_TAC MONO_EXISTS THEN X_GEN_TAC t)
           [`t1:real`; `t2:real`; `t3:real`] THEN
 REWRITE_TAC[IN_SING; VECTOR_ARITH
   `a - b - c - d:real^N = vec 0 <=> a = b + c + d`] THEN
 DISCH_THEN SUBST1_TAC THEN REWRITE_TAC[] THEN
 MAP_EVERY X_GEN_TAC [`ta:real`; `tb:real`; `tc:real`] THEN
 REWRITE_TAC[VECTOR_ARITH
  `t1 % x + t2 % y + t3 % z = ta % x + tb % y + tc % z <=>
   (t1 - ta) % x + (t2 - tb) % y + (t3 - tc) % z = vec 0`] THEN
 STRIP_TAC THEN FIRST_ASSUM(MP_TAC o GEN_REWRITE_RULE I [independent]) THEN
 REWRITE_TAC[DEPENDENT_EXPLICIT; NOT_EXISTS_THM] THEN
 DISCH_THEN(MP_TAC o SPECL
  [`{v1 - v0:real^3,v2 - v0,v3 - v0}`;
   `\v:real^3. if v = v1 - v0 then t1 - ta
               else if v = v2 - v0 then t2 - tb
               else t3 - tc`]) THEN
 SIMP_TAC[FINITE_INSERT; FINITE_RULES; SUBSET_REFL; VSUM_CLAUSES] THEN
 ASM_REWRITE_TAC[IN_INSERT; NOT_IN_EMPTY; VECTOR_ADD_RID;
                 RIGHT_OR_DISTRIB; EXISTS_OR_THM; UNWIND_THM2;
                   VECTOR_ARITH `x - a:real^N = y - a <=> x = y`] THEN
 SIMP_TAC[DE_MORGAN_THM; REAL_SUB_0]);;

*)






let DET_VEC3_AND_DELTA = prove(`!(a:real^3) b c d.
     &4 * ( det_vec3 (a - d) (b - d) (c - d) ) pow 2 =
     delta  ( d3 a d pow 2)
     (d3 b d pow 2)
     (d3 c d pow 2) (d3 a b pow 2) (d3 a c pow 2) (d3 b c pow 2)   `,
SIMP_TAC[d3; dist] THEN 
REWRITE_TAC[GSYM (MESON[VECTOR_ARITH ` (a :real^N) - b = ( a - x ) - ( b - x ) `]`
  delta      (norm (a - d) pow 2)     (norm (b - d) pow 2)
     (norm (c - d) pow 2) (norm ((a - d)  - (b - d )) pow 2) 
(norm ((a - d)  - ( c - d )) pow 2) (norm ((b - d ) - ( c - d )) pow 2)    =
   delta   (norm (a - d) pow 2)     (norm (b - d) pow 2)   (norm (c - d) pow 2)
(norm (a - b) pow 2) (norm (a - c) pow 2) (norm (b - c) pow 2)    `)] THEN 
SIMP_TAC[ vector_norm; DOT_POS_LE; SQRT_WORKS] THEN 
REWRITE_TAC[DOT_3] THEN 
REWRITE_TAC[MESON[lemma_cm3]`((a:real^3) - d - (b - d))$1 = (a - d)$1 - (b - d)$1 /\
  (a - d - (b - d))$2 = (a - d)$2 - (b - d)$2 /\
  (a - d - (b - d))$3 = (a - d)$3 - (b - d)$3 `] THEN 
REWRITE_TAC[delta; det_vec3] THEN 
REAL_ARITH_TAC);;



let POLFLZY = prove(` !(x1:real^3) x2 x3 x4.
         let x12 = dist (x1,x2) pow 2 in
         let x13 = dist (x1,x3) pow 2 in
         let x14 = dist (x1,x4) pow 2 in
         let x23 = dist (x2,x3) pow 2 in
         let x24 = dist (x2,x4) pow 2 in
         let x34 = dist (x3,x4) pow 2 in
         coplanar {x1, x2, x3, x4} <=> delta x12 x13 x14 x23 x24 x34 = &0 `,
LET_TR THEN REPEAT GEN_TAC THEN MP_TAC (GSYM (SPECL [` x2 :real^3`; 
` x3:real^3`;` x4:real^3`; ` x1 :real^3`] DET_VEC3_AND_DELTA)) THEN 
SIMP_TAC[d3; DIST_SYM] THEN REWRITE_TAC[REAL_ARITH ` &4 * a = &0 <=> a = &0 `]
THEN SIMP_TAC[GSYM ( REAL_FIELD ` x = &0 <=> x pow 2 = &0 `);
COPLANAR_DET_VEC3_EQ_0]);;


let LEMMA15 = POLFLZY;;

let muy_delta = new_definition ` muy_delta = delta `;;

(* LEMMA29 *)
let VCRJIHC = prove(`!(v1:real^3) v2 v3 v4 x34 x12 x13 x14 x23 x24.
         condA v1 v2 v3 v4 x12 x13 x14 x23 x24 x34
         ==> muy_delta x12 x13 x14 x23 x24 (dist (v3,v4) pow 2) = &0`,
REWRITE_TAC[condA; muy_delta] THEN MP_TAC POLFLZY THEN LET_TR THEN MESON_TAC[]);;


let ZERO_NEUTRAL = REAL_ARITH ` ! x. &0 * x = &0 /\ x * &0 = &0 /\ &0 + x = x /\ x + &0 = x /\ x - &0 = x /\
  -- &0 = &0 `;;

let EQUATE_CONEFS_POLINOMIAL_POW2 = prove( `!a b c aa bb cc. ( ! x. 
     a * x pow 2 + b * x + c = aa * x pow 2 + bb * x + cc ) <=>
     a = aa /\ b = bb /\ c = cc`, REPEAT GEN_TAC THEN EQ_TAC THENL [
NHANH (MESON[]` (! (x:real). P x ) ==> P ( &0 ) /\ P ( &1 ) /\ P ( -- &1 )`) THEN 
REAL_ARITH_TAC THEN REAL_ARITH_TAC; SIMP_TAC[]]);;

let GJWYYPS = prove(`!x12 x13 x14 x15 x23 x24 x25 x34 x35 a b c.
    (! x45.  cayleyR x12 x13 x14 x15 x23 x24 x25 x34 x35 x45 =
     a  * x45 pow 2 + b * x45 + c )
     ==> b pow 2 - &4 * a * c =
         &16 * delta x12 x13 x14 x23 x24 x34 * delta x12 x13 x15 x23 x25 x35`,
ONCE_REWRITE_TAC[LTCTBAN] THEN REPEAT GEN_TAC THEN 
REWRITE_TAC[EQUATE_CONEFS_POLINOMIAL_POW2] THEN ONCE_REWRITE_TAC[EQ_SYM_EQ]
THEN SIMP_TAC[] THEN DISCH_TAC THEN REWRITE_TAC[ups_x; cayleytr; cayleyR;
 delta; ZERO_NEUTRAL] THEN REAL_ARITH_TAC);;

let LEMMA51 = GJWYYPS ;;

g `!v1 v2 (v:real^3). ~(v1 = v2) ==> (collinear {v, v1, v2} <=> v IN aff {v1, v2})`;;
e (REWRITE_TAC[COLLINEAR_EX]);;
e (NHANH (MESON[]` a % b + c = vec 0 ==> ( a = &0 \/ ~(a = &0 ))`));;
e (KHANANG);;
e (NGOAC THEN PURE_ONCE_REWRITE_TAC[MESON[]` P a /\ a = &0 <=> P ( &0 ) 
  /\ a = &0 `]);;
e (REWRITE_TAC[REAL_ADD_LID; VECTOR_MUL_LZERO; VECTOR_ADD_LID]);;
e (REWRITE_TAC[REAL_ARITH ` a + b= &0 <=> a = -- b `; VECTOR_ARITH` a % x + b % y = vec 0 
 <=> a % x = ( -- b) % y`]);;
e (NHANH (MESON[REAL_ARITH ` a = &0 <=> -- a = &0 `; VECTOR_MUL_LCANCEL]` (b = --c /\ ~(b = &0 /\ c = &0)) /\ b % v1 = --c % v2
  ==> v1 = v2 `));;
e (SIMP_TAC[]);;
e (REWRITE_TAC[AFF_2POINTS_INTERPRET; IN_ELIM_THM]);;
e (REPEAT GEN_TAC THEN DISCH_TAC THEN EQ_TAC);;
e (REWRITE_TAC[VECTOR_ARITH ` a % v + b % v1 + c % v2 = vec 0 <=>
  a % v = ( -- b) % v1 + ( --c ) % v2 `]);;
e (PHA THEN REWRITE_TAC[MESON[CHANGE_SIDE]` a % v = v1  /\
               ~(a = &0) <=> v = &1 / a % v1 /\ ~( a = &0 ) `]);;
e (REWRITE_TAC[VECTOR_ADD_LDISTRIB; VECTOR_MUL_ASSOC; REAL_ARITH `&1 / a * b = b / a`]);;
e (REWRITE_TAC[AFF_2POINTS_INTERPRET; IN_ELIM_THM]);;
e (MESON_TAC[REAL_FIELD ` ~ ( a = &0 ) /\ a = -- (b + c) ==>
   ( -- b) / a + ( -- c) / a = &1 `]);;
e (STRIP_TAC);;
e (EXISTS_TAC ` &1 `);;
e (EXISTS_TAC ` -- ta`);;
e (EXISTS_TAC ` -- tb`);;
e (PHA);;
e (ASM_SIMP_TAC[REAL_ARITH` ~(&1 = &0 ) /\ -- ( -- a + -- b ) = a + b `]);;
e (CONV_TAC VECTOR_ARITH);;

let NOT_TOW_EQ_IMP_COL_EQUAVALENT = top_thm();;


let LEMMA30 = prove(`!v1 v2 v3 v4 x12 x13 x14 x23 x24 x34 a b c.
         condA v1 v2 v3 v4 x12 x13 x14 x23 x24 x34 /\
         (!x12 x13 x14 x23 x24 x34.
              muy_delta x12 x13 x14 x23 x24 x34 =
              a x12 x13 x14 x23 x24 * x34 pow 2 +
              b x12 x13 x14 x23 x24 * x34 +
              c x12 x13 x14 x23 x24 )
         ==> (v3 IN aff {v1, v2} \/ v4 IN aff {v1, v2} <=>
              b x12 x13 x14 x23 x24 pow 2 -
              &4 * a x12 x13 x14 x23 x24 * c x12 x13 x14 x23 x24 =
              &0)`,
REWRITE_TAC[muy_delta; DELTA_COEFS; EQUATE_CONEFS_POLINOMIAL_POW2 ] THEN 
ONCE_REWRITE_TAC[EQ_SYM_EQ] THEN SIMP_TAC[] THEN REPEAT GEN_TAC THEN 
DISCH_TAC THEN REWRITE_TAC[REAL_ARITH` a - b * -- c * d = a + b * c * d `; 
AGBWHRD] THEN DOWN_TAC THEN SIMP_TAC[condA; REAL_ENTIRE; 
GSYM NOT_TOW_EQ_IMP_COL_EQUAVALENT] THEN ONCE_REWRITE_TAC[MESON[PER_SET3]`
 p {v3, v1, v2} \/ p {v4, v1, v2}  <=> p {v1,v2,v3} \/ p {v1,v2,v4} `] THEN 
ONCE_REWRITE_TAC[MESON[UPS_X_SYM]` ups_x x12 x23 x13 = &0 \/ 
ups_x x12 x24 x14 = &0 <=>     ups_x x12 x13 x23 = &0 \/ 
ups_x x12 x14 x24 = &0 `] THEN MESON_TAC[UPS_X_SYM; PER_SET3; FHFMKIY]);;

let EWVIFXW = LEMMA30;;



let WITH_COEF1 = prove(` ! (v1:real^3) (v2:real^3) (v3:real^3) (v:real^3).
 ~ collinear {v1,v2,v3} /\ v IN affine hull {v1, v2, v3} 
  ==> ( &0 < coef1 v1 v2 v3 v <=> v IN aff_gt {v2,v3} {v1} ) /\
  ( &0 = coef1 v1 v2 v3 v <=> v IN aff {v2,v3} ) /\
  ( coef1 v1 v2 v3 v < &0 <=> v IN aff_lt {v2,v3} {v1} ) `,
SIMP_TAC[COEF1_POS_EQ_V1_IN; COEFS1_EQ_0_IFF_V_IN_AFF; COEF1_NEG_IFF_V1_IN_AFF_LT]);;

let PER_COEF1_COEF2 = prove(` ! (v1:real^3) (v2:real^3) (v3:real^3) (v:real^3).
           v IN affine hull {v1, v2, v3} /\ ~collinear {v1, v2, v3}
==> coef1 v2 v3 v1 v = coef2 v1 v2 v3 v ` ,
NHANH (SPEC_ALL COEFS) THEN 
ONCE_REWRITE_TAC[MESON[PER_SET3]` p {a,b,c} = p {b,c,a} `] THEN 
NHANH (SPEC_ALL COEFS) THEN MESON_TAC[VEC_PER2_3; REAL_PER3]);;


let PER_COEF1_COEF3 = prove(` ! (v1:real^3) (v2:real^3) (v3:real^3) (v:real^3).
           v IN affine hull {v1, v2, v3} /\ ~collinear {v1, v2, v3}
==> coef1 v3 v1 v2 v = coef3 v1 v2 v3 v `, NHANH (SPEC_ALL COEFS) THEN 
ONCE_REWRITE_TAC[MESON[PER_SET3]` p {a,b,c} = p {c,a,b} `] THEN 
NHANH (SPEC_ALL COEFS) THEN MESON_TAC[VEC_PER2_3; REAL_PER3]);;

let PER_COEF1 = prove(  ` ! (v1:real^3) (v2:real^3) (v3:real^3) (v:real^3).
           v IN affine hull {v1, v2, v3} /\ ~collinear {v1, v2, v3}
==> coef1 v3 v1 v2 v = coef3 v1 v2 v3 v /\ coef1 v2 v3 v1 v = coef2 v1 v2 v3 v `,
SIMP_TAC[PER_COEF1_COEF2; PER_COEF1_COEF3]);;



let LEMMA12 = prove(`! (v1:real^3) (v2:real^3) (v3:real^3) (v:real^3). 
~ collinear {v1,v2,v3} /\ v IN affine hull {v1, v2, v3} 
  ==> ( &0 < coef1 v1 v2 v3 v <=> v IN aff_gt {v2,v3} {v1} ) /\
  ( &0 = coef1 v1 v2 v3 v <=> v IN aff {v2,v3} ) /\
  ( coef1 v1 v2 v3 v < &0 <=> v IN aff_lt {v2,v3} {v1} ) /\
   ( &0 < coef2 v1 v2 v3 v <=> v IN aff_gt {v3,v1} {v2} ) /\
  ( &0 = coef2 v1 v2 v3 v <=> v IN aff {v3,v1} ) /\
  ( coef2 v1 v2 v3 v < &0 <=> v IN aff_lt {v3,v1} {v2} )/\
   ( &0 < coef3 v1 v2 v3 v <=> v IN aff_gt {v1,v2} {v3} ) /\
  ( &0 = coef3 v1 v2 v3 v <=> v IN aff {v1,v2} ) /\
  ( coef3 v1 v2 v3 v < &0 <=> v IN aff_lt {v1,v2} {v3})`,
MP_TAC WITH_COEF1 THEN SIMP_TAC[PER_SET3; GSYM PER_COEF1_COEF3; PER_COEF1]);;

let CNXIFFC = LEMMA12;;
 

let NGAY_23_THANG1 = prove(`! (v1:real^3) (v2:real^3) (v3:real^3) (v:real^3). ~collinear {v1, v2, v3} /\ v IN affine hull {v1, v2, v3} ==>
  ( v IN aff_ge {v2, v3} {v1} <=> &0 <= coef1 v1 v2 v3 v ) /\
  ( v IN aff_ge {v3,v1} {v2} <=> &0 <= coef2 v1 v2 v3 v ) /\
  ( v IN aff_ge {v1,v2} {v3} <=> &0 <= coef3 v1 
v2 v3 v ) `,
REWRITE_TAC[IN_AFF_GE_INTERPRET_TO_AFF_GT_AND_AFF; REAL_ARITH ` &0 <= a
  <=> &0 < a \/ &0 = a `] THEN SIMP_TAC[CNXIFFC]);;


let MYOQCBS = prove(` !(v1:real^3) v2 v3 v.
         ~collinear {v1, v2, v3} /\ v IN affine hull {v1, v2, v3}
         ==> (v IN conv {v1, v2, v3} <=>
              &0 <= coef1 v1 v2 v3 v /\
              &0 <= coef2 v1 v2 v3 v /\
              &0 <= coef3 v1 v2 v3 v) /\
             (v IN conv0 {v1, v2, v3} <=>
              &0 < coef1 v1 v2 v3 v /\
              &0 < coef2 v1 v2 v3 v /\
              &0 < coef3 v1 v2 v3 v) `,
SIMP_TAC[IN_CONV3_EQ; IN_CONV03_EQ; NGAY_23_THANG1; CNXIFFC ] THEN MESON_TAC[]);;

let LEMMA51 = GJWYYPS;;
let LEMMA50 = LTCTBAN;;
let muy_v = new_definition ` muy_v (x1: real^N ) (x2:real^N) (x3:real^N) (x4:real^N)
(x5:real^N) x45 = 
          (let x12 = dist (x1,x2) pow 2 in
          let x13 = dist (x1,x3) pow 2 in
          let x14 = dist (x1,x4) pow 2 in
          let x15 = dist (x1,x5) pow 2 in
          let x23 = dist (x2,x3) pow 2 in
          let x24 = dist (x2,x4) pow 2 in
          let x25 = dist (x2,x5) pow 2 in
          let x34 = dist (x3,x4) pow 2 in
          let x35 = dist (x3,x5) pow 2 in
          cayleyR x12 x13 x14 x15 x23 x24 x25 x34 x35 x45) `;;

let REMOVE_TAC = MATCH_MP_TAC (MESON[]` a ==> b ==> a `);;

let ALE = MESON[LTCTBAN]`!x12 x13 x14 x15 x23 x24 x25 x34 x35.
     (!a b c. (! x.
          cayleyR x12 x13 x14 x15 x23 x24 x25 x34 x35 x =
          a * x pow 2 + b * x + c )
          ==> b pow 2 - &4 * a * c = &0)
     ==> cayleytr x12 x13 x14 x15 x23 x24 x25 x34 x35 (&0) pow 2 -
         &4 *
         ups_x x12 x13 x23 *
         cayleyR x12 x13 x14 x15 x23 x24 x25 x34 x35 (&0) =
         &0`;;

let DISCRIMINANT_OF_CAY = MESON[LTCTBAN; GJWYYPS]`cayleytr x12 x13 x14 x15 x23 x24 x25 x34 x35 (&0) pow 2 -
 &4 * ups_x x12 x13 x23 * cayleyR x12 x13 x14 x15 x23 x24 x25 x34 x35 (&0) =
 &16 * delta x12 x13 x14 x23 x24 x34 * delta x12 x13 x15 x23 x25 x35`;;

let NOT_TWO_EQ_IMP_COL_EQUAVALENT = NOT_TOW_EQ_IMP_COL_EQUAVALENT;;

let GDLRUZB = prove(` ! (v1:real^3) (v2:real^3) (v3:real^3) (v4:real^3) (v5:real^3) a b c.
  coplanar {v1, v2, v3, v4} \/ coplanar {v1, v2, v3, v5} <=>
         (! a b c. (! x. muy_v v1 v2 v3 v4 v5 x = a * x pow 2 + b * x + c )
 ==> b pow 2 - &4 * a * c = &0) `,REWRITE_TAC[muy_v] THEN LET_TR THEN 
REPEAT GEN_TAC THEN EQ_TAC THENL [DISCH_TAC THEN 
NHANH (MESON[GJWYYPS]` (!x45. cayleyR x12 x13 x14 x15 x23 x24 x25 x34 x35 x45 =
                a * x45 pow 2 + b * x45 + c)
         ==> b pow 2 - &4 * a * c =
             &16 *
             delta x12 x13 x14 x23 x24 x34 *
             delta x12 x13 x15 x23 x25 x35`) THEN SIMP_TAC[] THEN 
UNDISCH_TAC ` coplanar {(v1:real^3), v2, v3, v4}\/ coplanar {v1, v2, v3, v5}` THEN 
MP_TAC LEMMA15 THEN LET_TR THEN REWRITE_TAC[REAL_FIELD` &16 * a * b = &0 
<=> a = &0 \/ b = &0 `] THEN SIMP_TAC[]; NHANH (SPEC_ALL ALE) THEN 
REWRITE_TAC[DISCRIMINANT_OF_CAY ] THEN MP_TAC POLFLZY THEN LET_TR THEN 
REWRITE_TAC[REAL_FIELD` &16 * a * b = &0 <=> a = &0 \/ b = &0 `] THEN 
MESON_TAC[]]);;


let DET_VECC3_AND_DELTA = prove(` (! d a b c .
      delta (d3 d a pow 2) (d3 d b pow 2) (d3 d c pow 2) (d3 a b pow 2)
      (d3 a c pow 2)
      (d3 b c pow 2) =
      &4 * det_vec3 (a - d) (b - d) (c - d) pow 2) `, MESON_TAC[D3_SYM; 
DET_VEC3_AND_DELTA]);;


let DELTA_POS_4POINTS = prove(`!x1 x2 x3 (x4:real^3).
     &0 <=
     delta (dist (x1,x2) pow 2) (dist (x1,x3) pow 2) (dist (x1,x4) pow 2)
     (dist (x2,x3) pow 2)
     (dist (x2,x4) pow 2)
     (dist (x3,x4) pow 2)`, REWRITE_TAC[GSYM d3] THEN SIMP_TAC[D3_SYM] THEN 
MP_TAC (DET_VECC3_AND_DELTA) THEN SIMP_TAC[] THEN DISCH_TAC THEN MP_TAC
 REAL_LE_SQUARE_POW THEN MESON_TAC[REAL_ARITH` &0 <= x <=> &0 <= &4 * x `]);;



let DIST_POW2_DOT = 
prove(` ! a (b:real^N) . dist (a,b) pow 2 = ( a - b ) dot ( a- b) `,
SIMP_TAC[dist; vector_norm; DOT_POS_LE; SQRT_WORKS]);;

(* this lemma is proved as below, but it take quite a long time to run it *)
let CAYLEYR_5POINTS = new_axiom` !x1 x2 x3 x4 (x5 :real^3). 
         let x12 = dist (x1,x2) pow 2 in
         let x13 = dist (x1,x3) pow 2 in
         let x14 = dist (x1,x4) pow 2 in
         let x15 = dist (x1,x5) pow 2 in
         let x23 = dist (x2,x3) pow 2 in
         let x24 = dist (x2,x4) pow 2 in
         let x25 = dist (x2,x5) pow 2 in
         let x34 = dist (x3,x4) pow 2 in
         let x35 = dist (x3,x5) pow 2 in
         let x45 = dist (x4,x5) pow 2 in
         cayleyR x12 x13 x14 x15 x23 x24 x25 x34 x35 x45 = &0 `;;

(* let CAYLEYR_5POINTS = prove(`  !x1 x2 x3 x4 (x5 :real^3). 
         let x12 = dist (x1,x2) pow 2 in
         let x13 = dist (x1,x3) pow 2 in
         let x14 = dist (x1,x4) pow 2 in
         let x15 = dist (x1,x5) pow 2 in
         let x23 = dist (x2,x3) pow 2 in
         let x24 = dist (x2,x4) pow 2 in
         let x25 = dist (x2,x5) pow 2 in
         let x34 = dist (x3,x4) pow 2 in
         let x35 = dist (x3,x5) pow 2 in
         let x45 = dist (x4,x5) pow 2 in
         cayleyR x12 x13 x14 x15 x23 x24 x25 x34 x35 x45 = &0 `,
LET_TR THEN REWRITE_TAC[ DIST_POW2_DOT] THEN REPEAT GEN_TAC THEN 
REWRITE_TAC[ MESON[VECTOR_ARITH` (a:real^n) - b = a - x - ( b - x ) `]`
  AA ( (x1 - x5 ) dot ( x1 - x5)) ((x2 - x3) dot (x2 - x3))
 ((x2 - x4) dot (x2 - x4))
 ((x2 - x5) dot (x2 - x5))
 ((x3 - x4) dot (x3 - x4))
 ((x3 - x5) dot (x3 - x5))
 ((x4 - x5) dot (x4 - x5)) =
  AA ( (x1 - x5 ) dot ( x1 - x5)) ((x2 - x1 - ( x3 - x1 )) dot (x2 - x1 - ( x3 - x1 )))
  ((x2 - x1 - ( x4 - x1 )) dot (x2 - x1 - ( x4 - x1 )))
  ((x2 - x1 - ( x5 - x1 )) dot (x2 - x1 - ( x5 - x1 )))
  ((x3 - x1 - ( x4 - x1 )) dot (x3 - x1 - ( x4 - x1 )))
  ((x3 - x1 - ( x5 - x1 )) dot (x3 - x1 - ( x5 - x1 )))
    ((x4 - x1 - ( x5 - x1 )) dot (x4 - x1 - ( x5 - x1 ))) ` ] THEN 
SIMP_TAC[VECTOR_ARITH ` ((x4: real^N) - x1 - (x5 - x1)) = x1 - x5 - ( x1 - x4 ) `] THEN 
ABBREV_TAC ` x12 = (x1 - ( x2:real^3)) ` THEN 
ABBREV_TAC ` x13 = (x1 - ( x3:real^3)) ` THEN 
ABBREV_TAC ` x14 = (x1 - ( x4:real^3)) ` THEN 
ABBREV_TAC ` x15 = (x1 - ( x5:real^3)) ` THEN 
REWRITE_TAC[DOT_3] THEN REWRITE_TAC[lemma_cm3; cayleyR] THEN REAL_AROTH_TAC);; *)


let UPS_X_POS = MESON[lemma8; UPS_X_SYM; NORM_SUB]` &0 <=
          ups_x (norm ((x1 : real^3) - x2) pow 2) (norm (x1 - x3) pow 2)
          (norm (x2 - x3) pow 2) `;;

let UPS_X_SYM = MESON[UPS_X_SYM]` !x y z. ups_x x y z = ups_x y x z /\ ups_x x y z = ups_x x z y
  /\ ups_x x y z = ups_x x z y `;;

let LEMMA3 = prove(` !x1 x2 x3 x4 (x5 :real^3). 
                 let x12 = dist (x1,x2) pow 2 in
         let x13 = dist (x1,x3) pow 2 in
         let x14 = dist (x1,x4) pow 2 in
         let x15 = dist (x1,x5) pow 2 in
         let x23 = dist (x2,x3) pow 2 in
         let x24 = dist (x2,x4) pow 2 in
         let x25 = dist (x2,x5) pow 2 in
         let x34 = dist (x3,x4) pow 2 in
         let x35 = dist (x3,x5) pow 2 in
         let x45 = dist (x4,x5) pow 2 in
         &0 <= ups_x x12 x13 x23 /\
         &0 <= delta x12 x13 x14 x23 x24 x34 /\
         cayleyR x12 x13 x14 x15 x23 x24 x25 x34 x35 x45 = &0 `, MP_TAC 
CAYLEYR_5POINTS THEN LET_TR THEN 
SIMP_TAC[ dist; UPS_X_POS; DELTA_POS_4POINTS]);;


(* LEMMA 3 *)
let NUHSVLM = LEMMA3;;

let LEMMA52 = prove( `! v1 v2 v3 v4 (v5:real^3).
  muy_v v1 v2 v3 v4 v5 ( (d3 v4 v5) pow 2 ) = &0 `,
REWRITE_TAC[muy_v; d3] THEN MP_TAC LEMMA3 THEN 
LET_TR THEN SIMP_TAC[]);;

let PFDFWWV = LEMMA52;;

let PRE_VIET = 
REAL_ARITH `!x x1 x2. (x - x1) * (x - x2) = x pow 2 - (x1 + x2) * x + x1 * x2 /\
 a * (x - x1) * (x - x2) = a * x pow 2 + ( -- a * (x1 + x2)) * x + a * x1 * x2 `;;


let VIET_THEOREM = prove(`! x1 x2 a b c. (!x. a * x pow 2 + b * x + c = 
a * (x - x1) * (x - x2)) ==>  -- b = a * ( x1 + x2 ) /\ c = a * x1 * x2 `,
REWRITE_TAC[PRE_VIET; REAL_LDISTRIB;REAL_SUB_LDISTRIB;
REAL_ARITH ` a - b * c = a + -- b * c `; REAL_ARITH` ( a + b ) + c = 
a + b + c `] THEN 
REWRITE_TAC[REAL_MUL_ASSOC; EQUATE_CONEFS_POLINOMIAL_POW2] THEN 
SIMP_TAC[] THEN REAL_ARITH_TAC);;

let ADD_SUB_POW2_EX = REAL_RING ` ( a + b ) pow 2 = a pow 2 + &2 * a * b + b pow 2 /\
( a - b ) pow 2 = a pow 2 - &2 * a * b + b pow 2 `;;

let PRESENT_SUB_POW2 = REAL_RING` ! a b. ( a - b ) pow 2 = ( a + b ) pow 2 
  - &4 * a * b `;;

let DIST_ROOT_AND_DISCRIMINANT = prove(` ! a b c x1 x2. ( ! x. a * x pow 2 + b * x + c =
 a * ( x - x1 ) * ( x - x2 ) )
  ==> ( a pow 2 ) * ( x1 - x2 ) pow 2 = b pow 2 - &4 * a * c `,
NHANH (SPEC_ALL VIET_THEOREM) THEN REWRITE_TAC[PRESENT_SUB_POW2] THEN 
SIMP_TAC[REAL_ARITH ` -- b = a <=> b = -- a `] THEN REAL_ARITH_TAC);;

(* le 33. P 22 MARKED *)

let REAL_EQ_TO_LE_LT = REAL_ARITH ` 
  ( a = b <=> ~( a < b \/ b < a ) )`;;

let FEBRUARY_13_09 = prove(` &0 < (u - v) dot (&2 % x - (u + v)) <=>
  &0 < (u - v) dot (x - &1 / &2 % (u + v)) `,
ONCE_REWRITE_TAC[MESON[REAL_ARITH ` &0 < a <=> &0 < &2 * a `]` (a <=> &0 < b ) <=>
  ( a <=> &0 < &2 * b ) `] THEN ONCE_REWRITE_TAC[VECTOR_ARITH ` x * (a dot b) =
  a dot x % b `] THEN 
REWRITE_TAC[GSYM VECTOR_SUB_DISTRIBUTE; VECTOR_MUL_ASSOC] THEN 
REWRITE_TAC[REAL_ARITH ` &2 * &1 / &2 = &1 `; VECTOR_MUL_LID]);;

let SUB_DOT_NEG_TO_POS = MESON[VECTOR_ARITH ` ( a - b ) dot x = 
--  (( b - a ) dot x ) `;  REAL_ARITH ` -- a < &0 <=> &0 < a `]
`! a b.  ( a - b ) dot x < &0 <=> &0 < ( b - a ) dot x `;;


let LEMMA6 = prove(` !(u:real^3) v. ~(u = v) ==> plane_norm (bis u v) `,
REWRITE_TAC[plane_norm; bis] THEN REPEAT STRIP_TAC THEN 
EXISTS_TAC ` (u: real^3) - v ` THEN 
EXISTS_TAC ` &1 / &2 % ((u: real^3) + v )` THEN 
REWRITE_TAC[FUN_EQ_THM; IN_ELIM_THM] THEN ASM_SIMP_TAC[VECTOR_SUB_EQ] THEN 
REWRITE_TAC[REAL_EQ_TO_LE_LT; DIST_LT_HALF_PLANE;FEBRUARY_13_09;
 SUB_DOT_NEG_TO_POS] THEN SIMP_TAC[VECTOR_ADD_SYM] THEN MESON_TAC[]);;

let BXVMKNF = LEMMA6;;


let b_coef = BC_DEL_FOR;;
let c_coef = b_coef ;;

let DELTA_X34_B = prove(` ! x12 x13 x14 x23 x24 x. delta_x34 x12 x13 x14 x23 x24 x =
  -- &2 * x12 * x + b_coef x12 x13 x14 x23 x24 `, REWRITE_TAC[ delta_x34; b_coef]);;




let EQ_POW2_COND = prove(`!a b. &0 <= a /\ &0 <= b ==> (a = b <=> a pow 2 = b pow 2)`,
REWRITE_TAC[REAL_ARITH` a = b <=> a <= b /\ b <= a `] THEN SIMP_TAC[POW2_COND]);;


let EQ_SQRT_POW2_EQ = prove(` &0 <= a /\ &0 <= b ==> ( a = sqrt b <=> a pow 2 = b ) `,
SIMP_TAC[SQRT_WORKS; EQ_POW2_COND]);;


let LEMMA33 = prove(` !x34 x12 x13 v1 x14 v3 x23 v2 v4 x24 x34' x34'' a.
 condA v1 v2 v3 v4 x12 x13 x14 x23 x24 x34 /\
          (! x. muy_delta x12 x13 x14 x23 x24 x = a * ( x - x34' ) * ( x - x34'')) 
/\ x34' <= x34'' 
  ==> delta_x34 x12 x13 x14 x23 x24 x34' =
             sqrt (ups_x x12 x13 x23 * ups_x x12 x14 x24) /\
             delta_x34 x12 x13 x14 x23 x24 x34'' =
             --sqrt (ups_x x12 x13 x23 * ups_x x12 x14 x24) `,
REWRITE_TAC[muy_delta; DELTA_X34_B; DELTA_COEFS] THEN 
SIMP_TAC[EQUATE_CONEFS_POLINOMIAL_POW2; PRE_VIET; 
REAL_ARITH ` -- a = b <=> b = -- a`] THEN 
SIMP_TAC[REAL_RING `-- &2 * x12 * x34' + -- --x12 * (x34' + x34'') = a <=>
  -- &2 * x12 * x34'' + -- --x12 * (x34' + x34'') = -- a `] THEN 
REWRITE_TAC[REAL_ARITH` -- &2 * x12 * x34'' + -- --x12 * (x34' + x34'')
  = x12 * ( x34' - x34'' ) `; condA] THEN REPEAT STRIP_TAC THEN 
EXPAND_TAC "x12"  THEN EXPAND_TAC "x13" THEN EXPAND_TAC "x23" THEN 
EXPAND_TAC "x14" THEN EXPAND_TAC "x24" THEN 
UNDISCH_TAC ` x34' <= (x34'':real)` THEN 
ONCE_REWRITE_TAC[REAL_ARITH ` a <= b <=> &0 <= b - a `] THEN 
ONCE_REWRITE_TAC[ REAL_ARITH ` a * ( b - c ) = -- ( a * ( c - b ) ) `] THEN 
MP_TAC (GEN_ALL TROI_OI_DAT_HOI) THEN MP_TAC REAL_LE_POW_2 THEN 
REWRITE_TAC[REAL_ARITH` -- a = -- b <=> a = b `] THEN 
SIMP_TAC[UPS_X_SYM; REAL_LE_MUL; EQ_SQRT_POW2_EQ ] THEN 
ASM_SIMP_TAC[] THEN REPEAT STRIP_TAC THEN 
ONCE_REWRITE_TAC[ REAL_ARITH ` ( a * b ) pow 2 = a pow 2 * b pow 2 `] THEN 
REWRITE_TAC[PRESENT_SUB_POW2] THEN 
REWRITE_TAC[REAL_SUB_LDISTRIB; REAL_ARITH ` a pow 2 * b pow 2 = 
( -- a * b ) pow 2   /\ a pow 2 * &4 * b = -- a * &4 * -- a * b `] THEN 
UNDISCH_TAC `b_coef x12 x13 x14 x23 x24 = --a * (x34' + x34'')` THEN 
UNDISCH_TAC `c_coef x12 x13 x14 x23 x24 = a * x34' * x34''` THEN 
UNDISCH_TAC `(a: real) = --x12` THEN ONCE_REWRITE_TAC[EQ_SYM_EQ] THEN 
SIMP_TAC[] THEN SIMP_TAC[REAL_ARITH` -- -- a = a /\ ( -- a * b) pow 2 = 
  ( a * b ) pow 2 /\ ( a * -- b) pow 2 = ( a * b ) pow 2  `; REAL_ADD_SYM;
 REAL_MUL_SYM] THEN SIMP_TAC[REAL_ADD_SYM; REAL_MUL_SYM] THEN 
ONCE_REWRITE_TAC[REAL_ARITH ` ( a * b ) pow 2 = ( b * -- a ) pow 2 `] THEN 
SIMP_TAC[] THEN REPEAT STRIP_TAC THEN EXPAND_TAC "a" THEN 
REWRITE_TAC[REAL_RING ` a - -- c * b * &4 = a + &4 * c * b `] THEN 
MESON_TAC[AGBWHRD; UPS_X_SYM]);;

let CMUDPKT = LEMMA33;;

(* ============= *)


let LEMMA_OF_LE20 = prove(` ! x y z: real^3.
   &2 <= d3 x y /\
         d3 x y <= #2.52 /\
         &2 <= d3 x z /\
         d3 x z <= #2.2 /\
         &2 <= d3 y z /\
         d3 y z <= #2.2
         ==> ~collinear {x, y, z}  `,
MP_TAC JVUNDLC THEN 
SIMP_TAC[] THEN 
ONCE_REWRITE_TAC[EQ_SYM_EQ] THEN 
REWRITE_TAC[MESON[]` (! a b c s. P a b c = s ==> Q a b c ) <=> 
  (! a b c . Q a b c ) `] THEN 
SIMP_TAC[COL_EQ_UPS_0] THEN 
MATCH_MP_TAC (TAUT` a ==> b ==> a `) THEN 
REWRITE_TAC[GSYM d3] THEN 
REWRITE_TAC[REAL_ENTIRE] THEN 
CONV_TAC REAL_FIELD);;



let LT_POW2_EQ_LT = MESON[POW2_COND_LT; REAL_ARITH ` a <= b <=> ~ ( b < a ) `]
`&0 < a /\ &0 < b ==> ( a < b <=> a pow 2 < b pow 2 ) `;;




let ETA_Y_LT_SQRT2 = prove(`eta_y #2.2 #2.2 #2.52 < sqrt #2`,
REWRITE_TAC[eta_y; eta_x; ups_x] THEN LET_TR THEN 
CONV_TAC REAL_RAT_REDUCE_CONV THEN MP_TAC (REAL_FIELD ` &14641 / &8131< &2 `)
 THEN MP_TAC (REAL_FIELD ` &0 < &2 /\ &0 < &14641 / &8131 `) THEN 
NHANH (SPEC_ALL SQRT_POS_LT) THEN REWRITE_TAC[ REAL_ARITH ` #2 = &2 `] THEN 
SIMP_TAC[REAL_ARITH ` &0 < a ==> &0 <= a `;SQRT_POS_LT; LT_POW2_EQ_LT; SQRT_WORKS]);;

let ETA_YY_LT_SQRT2 = MESON[ETA_Y_LT_SQRT2; REAL_ARITH ` #2 = &2 `]`
  eta_y #2.2 #2.2 #2.52 < sqrt ( &2 ) `;;

let THANG_DEU = prove(` &2 <= x ==> &2 pow 2 <= x pow 2 `,
NHANH (REAL_ARITH ` &2 <= x ==> &0 <= &2 /\ &0 <= x `) 
THEN MESON_TAC[POW2_COND]);;

let LEMMA19 = BYOWBDF;;

MESON[BYOWBDF; REAL_ARITH ` a + b = b + a `]` !a b c a' b' c'.
         &0 < a /\
         a <= a' /\
         &0 < b /\
         b <= b' /\
         &0 < c /\
         c <= c' /\
         a' pow 2 <= b pow 2 + c pow 2 /\
         b' pow 2 <= c pow 2 + a pow 2 /\
         c' pow 2 <= a pow 2 + b pow 2
         ==> eta_y a b c <= eta_y a' b' c' `;;




let LEMMA20 = prove(` ! x y z: real^3.
   &2 <= d3 x y /\
         d3 x y <= #2.52 /\
         &2 <= d3 x z /\
         d3 x z <= #2.2 /\
         &2 <= d3 y z /\
         d3 y z <= #2.2
         ==> ~collinear {x, y, z} /\ radV {x, y, z} < sqrt (&2)`,
REPEAT GEN_TAC THEN 
NHANH (SPEC_ALL LEMMA_OF_LE20) THEN 
SIMP_TAC[RADV_FORMULAR] THEN 
MP_TAC (REAL_ARITH ` #2.2 pow 2 <= &2 pow 2 + &2 pow 2 /\
  #2.52 pow 2 <=  &2 pow 2 + &2 pow 2 `) THEN 
IMP_IMP_TAC THEN 
NHANH THANG_DEU THEN 
PHA THEN 
NHANH (MESON[REAL_ARITH `
  a <= b + c /\ b <= bb /\ c <= cc ==> a <= bb + cc `]`
  #2.2 pow 2 <= &2 pow 2 + &2 pow 2 /\
     #2.52 pow 2 <= &2 pow 2 + &2 pow 2 /\
     a1 /\
     &2 pow 2 <= d3 x y pow 2 /\
     a2 /\
     a3 /\
     &2 pow 2 <= d3 x z pow 2 /\
     a4 /\
     a5 /\
     &2 pow 2 <= d3 y z pow 2 /\ last
     ==> #2.2 pow 2 <= d3 x z pow 2 + d3 x y pow 2 /\
         #2.2 pow 2 <= d3 x y pow 2 + d3 y z pow 2 /\
  #2.52 pow 2 <= d3 y z pow 2 + d3 x z pow 2 `) THEN 
MP_TAC (REAL_ARITH`! a b c. a <= b /\ b < c ==> a < c`) THEN 
MESON_TAC[BYOWBDF; ETA_YY_LT_SQRT2 ; REAL_ARITH ` b + c = c + b /\
 ( &2 <= a ==> &0 < a) `]);;

let BFYVLKP = LEMMA20;;

let NGAY23_THANG2_09 = prove(` &2 <= y /\ y <= sqrt (&8) ==>
  &2 pow 2 <= y * y /\ y * y <= &8 `,
REWRITE_TAC[ GSYM REAL_POW_2] THEN DISCH_TAC THEN CONJ_TAC THENL 
[ASM_MESON_TAC[REAL_ARITH ` &2 <= a ==> &0 <= &2 /\ &0 <= a `;POW2_COND]; 
ASM_MESON_TAC[ SQRT_WORKS; REAL_ARITH ` &0 <= &8 `;
  POW2_COND; REAL_ARITH `&2 <= a /\ a <= b ==> &0 <= b /\ &0 <= a `]]);;



let ETA_Y_SQRT8_2_251 = prove(` eta_y ( sqrt (&8) ) (&2) #2.51 < #1.453`,
REWRITE_TAC[eta_y; eta_x; ups_x; GSYM POW_2] THEN 
LET_TR THEN 
REWRITE_TAC[MESON[SQRT_WORKS; REAL_ARITH ` &0 <= &8 `]` sqrt (&8) pow 2 = &8 `] THEN 
CONV_TAC REAL_RAT_REDUCE_CONV THEN 
MP_TAC (REAL_FIELD ` &0 < &20160320000 / &9551113999 /\ &0 < #1.453 `) THEN 
NHANH (SPEC_ALL SQRT_POS_LT) THEN 
SIMP_TAC[LT_POW2_EQ_LT; REAL_ARITH ` &0 < a ==> &0 <= a `; SQRT_POW_2] THEN 
DISCH_TAC THEN 
CONV_TAC REAL_FIELD );;

MESON[BYOWBDF; REAL_ARITH ` a + b = b + a `]` !a b c a' b' c'.
         &0 < a /\
         a <= a' /\
         &0 < b /\
         b <= b' /\
         &0 < c /\
         c <= c' /\
         a' pow 2 <= b pow 2 + c pow 2 /\
         b' pow 2 <= c pow 2 + a pow 2 /\
         c' pow 2 <= a pow 2 + b pow 2
         ==> eta_y a b c <= eta_y a' b' c' `;;


(* le 21 *)
let LEMMA21 = prove(` ! y. &2 <= y /\ y <= sqrt8 ==> eta_y y (&2) #2.51 < #1.453`,
REWRITE_TAC[sqrt8; GSYM POW_2] THEN 
NHANH (NGAY23_THANG2_09) THEN 
REWRITE_TAC[sqrt8; GSYM POW_2] THEN 
NHANH (REAL_ARITH ` &2 pow 2 <= y pow 2 /\ y pow 2 <= &8
     ==> &2 pow 2 <= #2.51 pow 2 + y pow 2 /\
         #2.51 pow 2 <= y pow 2 + &2 pow 2 /\
         &8 <= &2 pow 2 + #2.51 pow 2 `) THEN 
NHANH (REAL_ARITH ` &2 <= a ==> &0 < a /\ &0 < &2 /\ &0 < #2.51 /\ (! a. a <= a ) `) THEN 
GEN_TAC THEN 
MP_TAC (MESON[SQRT_WORKS; REAL_ARITH ` &0 <= &8 `]` sqrt (&8) pow 2 = &8 `) THEN 
MESON_TAC[REAL_ADD_SYM; BYOWBDF; ETA_Y_SQRT8_2_251;
  REAL_ARITH ` a <= b /\ b < c ==> a < c `]);;

let WDOMZXH = LEMMA21;;




let CDEUSDF_CHANGE = CDEUSDF;;


let CIRCUMCENTER_FORMULAR = prove(` ! va vb vc.  ~collinear {va, vb, vc}
 ==> circumcenter {va, vb, vc} =
  (d3 vb vc pow 2 *
           (d3 va vc pow 2 + d3 va vb pow 2 - d3 vb vc pow 2)) /
          (ups_x (d3 vb vc pow 2) (d3 va vc pow 2) (d3 va vb pow 2)) %
          va +
          (d3 va vc pow 2 *
           (d3 vb vc pow 2 + d3 va vb pow 2 - d3 va vc pow 2)) /
          (ups_x (d3 vb vc pow 2) (d3 va vc pow 2) (d3 va vb pow 2)) %
          vb +
          (d3 va vb pow 2 *
           (d3 vb vc pow 2 + d3 va vc pow 2 - d3 va vb pow 2)) /
          (ups_x (d3 vb vc pow 2) (d3 va vc pow 2) (d3 va vb pow 2)) %
          vc `,
ONCE_REWRITE_TAC[EQ_SYM_EQ] THEN 
MP_TAC CDEUSDF_CHANGE THEN LET_TR THEN MESON_TAC[]);;

let LE_EX = REAL_ARITH ` &0 <= a <=> a = &0 \/ &0 < a `;;

let SUM_UPS_X_1 = prove(`!a b c.
     &0 < ups_x a b c
     ==> (c * (b + a - c)) / ups_x a b c +
         (a * (c + b - a)) / ups_x a b c +
         (b * (c + a - b)) / ups_x a b c =
         &1`, REWRITE_TAC[ups_x] THEN CONV_TAC REAL_FIELD);;


let LEMMA18 = prove(` !x (y:real^3) z p.
         d3 x z pow 2 < d3 x y pow 2 + d3 y z pow 2 /\
         ~collinear {x, y, z} /\
         p = circumcenter {x, y, z}
         ==> p IN aff_gt {x, z} {y}  `,
SIMP_TAC[CIRCUMCENTER_FORMULAR] THEN 
REWRITE_TAC[ UPS_X_EQ_ZERO_COND; GSYM d3 ] THEN 
REPEAT GEN_TAC THEN MP_TAC ZERO_LE_UPS_X  THEN 
IMP_IMP_TAC THEN REWRITE_TAC[LE_EX] THEN 
REWRITE_TAC[MESON[]`( a \/ b ) /\ c /\ ~a /\ e <=>
  b /\ c /\ ~a /\ e `] THEN ONCE_REWRITE_TAC[REAL_ARITH
 ` a < b + c <=> &0 < b + c - a `] THEN 
REWRITE_TAC[d3; GSYM UPS_X_EQ_ZERO_COND] THEN 
ONCE_REWRITE_TAC[VECTOR_ARITH` (a:real^N) + b + c = a + c + b `] THEN 
NHANH (MESON[TWO_EQ_IMP_COL3; PER_SET3]`~collinear {x, y, z} ==> ~ ( x = z)`) 
THEN REWRITE_TAC[DIST_NZ; simp_def2; IN_ELIM_THM] THEN 
STRIP_TAC THEN SIMP_TAC[DIST_SYM] THEN UNDISCH_TAC 
` &0 < ups_x (dist (x,y) pow 2)   (dist (x,z) pow 2) 
(dist ((y:real^3),z) pow 2) ` THEN 
SIMP_TAC [MESON[UPS_X_SYM]` ups_x x y z = ups_x z y x `] THEN 
DOWN_TAC THEN 
ONCE_REWRITE_TAC[MESON[REAL_ARITH `a + b - c = b + a - c `]` ( &0
  < a + b - c /\ l ==> ll ) <=> ( &0 < b + a - c /\ l ==> ll )`] THEN 
STRIP_TAC THEN EXISTS_TAC ` (dist ((y:real^3),z) pow 2 *
      (dist (x,z) pow 2 + dist (x,y) pow 2 - dist (y,z) pow 2)) /
     ups_x (dist (x,y) pow 2) (dist (x,z) pow 2) (dist (y,z) pow 2) ` THEN 
EXISTS_TAC `(dist ((x:real^3),y) pow 2 *
      (dist (y,z) pow 2 + dist (x,z) pow 2 - dist (x,y) pow 2)) /
     ups_x (dist (x,y) pow 2) (dist (x,z) pow 2) (dist (y,z) pow 2)` THEN 
EXISTS_TAC `   (dist ((x:real^3),z) pow 2 *
      (dist (y,z) pow 2 + dist (x,y) pow 2 - dist (x,z) pow 2)) /
     ups_x (dist (x,y) pow 2) (dist (x,z) pow 2) (dist (y,z) pow 2) ` THEN 
CONJ_TAC THENL [UNDISCH_TAC `&0 < ups_x (dist (x,y) pow 2)
   (dist (x,z) pow 2) (dist ((y:real^3),z) pow 2)` THEN 
REWRITE_TAC[SUM_UPS_X_1]; CONJ_TAC] THENL [DOWN_TAC THEN 
REWRITE_TAC[MESON[POW_2]` ( a pow 2) * b = ( a * a ) * b `] THEN
MESON_TAC[REAL_LT_MUL; REAL_LT_DIV]; SIMP_TAC[]]);;

let WSMRDKN = LEMMA18;;
let LEMMA19 = BYOWBDF;; 



MESON[POW2_COND; REAL_ARITH `&2 <= a /\ a <= b ==> &0 <= b /\ &0 <= a `]`
  &2 <= y /\ y <= b ==> y pow 2 <= b pow 2 `;;


let FACTOR_OF_QUADRARTIC = prove(`! a b c x. ~(a = &0) /\ 
&0 <= b pow 2 - &4 * a * c ==> a * x pow 2 + b * x + c =
     a *
     (x - (--b + sqrt (b pow 2 - &4 * a * c)) / (&2 * a)) *
     (x - (--b - sqrt (b pow 2 - &4 * a * c)) / (&2 * a))`   ,
REWRITE_TAC[PRE_VIET] THEN SIMP_TAC[REAL_FIELD ` ~( a = &0 ) ==> 
-- a * ( ( --b + del) / ( &2 * a ) + ( --b - del) / ( &2 * a )) = b `] THEN 
REWRITE_TAC[REAL_FIELD ` a / b * a' / b = ( a * a' ) / ( b pow 2 ) `] THEN 
REWRITE_TAC[REAL_FIELD ` a / b * a' / b = ( a * a' ) / ( b pow 2 ) `; 
  REAL_DIFFSQ; GSYM REAL_POW_2] THEN SIMP_TAC[SQRT_WORKS] THEN 
SIMP_TAC[REAL_FIELD ` ~ ( a = &0 ) ==> a * (--b pow 2 - 
 (b pow 2 - &4 * a * c)) / (&2 * a) pow 2 = c `]);;


let COMPUTE_TO_QUA_POLY = prove(` #2.696 <= x /\ x <= sqrt8  ==> 
x pow 2  * ( &1 / eta_y x #2.45 #2.45 pow 2 -
  &1 / eta_y x ( &2 ) #2.51 pow 2 ) = &4331842500 / &363188227801 * x pow 4 +
     -- &45702201 / &302530802 * x pow 2 +
     &529046001 / &2520040000 `, REWRITE_TAC[eta_y; eta_x; ups_x] THEN 
LET_TR THEN 
CONV_TAC REAL_RAT_REDUCE_CONV THEN 
NHANH (MESON[REAL_ARITH ` #2.696 <= x /\ x <= sqrt8 ==>
  &0 <= #2.696 /\ &0 <= x `; REAL_LE_MUL2] ` #2.696 <= x /\ x <= sqrt8 ==>
   #2.696 * #2.696 <= x * x /\ x * x <= sqrt8 * sqrt8 `) THEN 
NHANH (MESON[REAL_ARITH ` #2.696 * #2.696 <= x ==> &0 <= #2.696 * #2.696 /\ &0 <= x `; REAL_LE_MUL2] `
  #2.696 * #2.696 <= x /\ x <= hh ==> (#2.696 * #2.696) * #2.696 * #2.696 <= x * x /\
  x * x <= hh * hh `) THEN 
REWRITE_TAC[sqrt8] THEN 
REWRITE_TAC[REAL_POLY_CONV ` (--(x * x) * x * x - &16 - &3969126001 / &100000000 +
        &2 * (x * x) * &63001 / &10000 +
        &2 * (x * x) * &4 +
        &63001 / &1250) `] THEN 
REWRITE_TAC[REAL_POLY_CONV `
  (--(x * x) * x * x - &5764801 / &160000 - &5764801 / &160000 +
        &2 * (x * x) * &2401 / &400 +
        &2 * (x * x) * &2401 / &400 +
        &5764801 / &80000) `] THEN 
REWRITE_TAC[REAL_ARITH ` x pow 4 = ( x pow 2 ) pow 2 `] THEN 
MP_TAC (REAL_ARITH ` ~ ( -- &1 = &0 ) /\ &0 <= ( &103001 / &5000 ) pow 2 - &4 * ( -- &1 ) * -- &529046001 / &100000000 `) THEN 
SIMP_TAC[FACTOR_OF_QUADRARTIC] THEN 
CONV_TAC REAL_RAT_REDUCE_CONV THEN 
REWRITE_TAC[REAL_ARITH ` (&252004 / &625) = ( &502 / &25 ) * ( &502 / &25 ) `] THEN 
REWRITE_TAC[MESON[REAL_ARITH ` &0 <= &502 / &25 /\ x * x = x pow 2 `; POW_2_SQRT]`
  sqrt ( ( &502 / &25 ) * ( &502 / &25 )) = ( &502 / &25 ) `] THEN 
CONV_TAC REAL_RAT_REDUCE_CONV THEN 
REWRITE_TAC[ GSYM POW_2] THEN 
REWRITE_TAC[REAL_ARITH `  a * x pow 2 + b * x = ( a * x + b ) * x `] THEN 
REWRITE_TAC[MESON[SQRT_WORKS; REAL_ARITH ` &0 <= &8`]` sqrt (&8) pow 2 = &8 `] THEN 
NHANH (REAL_FIELD ` (&113569 / &15625 <= x pow 2 /\ x pow 2 <= &8) 
  ==> &0 <= (-- &1 * x pow 2 + &2401 / &100) /\
  &0 <= (x pow 2 - &2601 / &10000 ) /\
  &0 <= -- ((x pow 2 - &203401 / &10000) )/\ &0 <= &5764801 / &160000 /\ 
&0 <= &63001 / &2500`) THEN 
MP_TAC REAL_LE_POW_2 THEN 
REWRITE_TAC[REAL_ARITH ` -- &1 * a * b = a * -- b `] THEN 
REWRITE_TAC[REAL_FIELD ` ( &1 / a ) pow 2  = &1 / ( a pow 2 ) `] THEN 
MP_TAC REAL_LE_MUL THEN 
MP_TAC REAL_LE_DIV THEN 
SIMP_TAC[ SQRT_WORKS] THEN 
REWRITE_TAC[REAL_SUB_LDISTRIB] THEN 
REWRITE_TAC[REAL_FIELD ` &1 / ( a / b ) = b / a `] THEN 
SIMP_TAC[REAL_FIELD ` &113569 / &15625 <= a ==> a * ( b / ( a * c )) = b / c `] THEN 
REWRITE_TAC[REAL_POLY_CONV ` ((-- &1 * x pow 2 + &2401 / &100) * x pow 2) / (&5764801 / &160000) -
     ((x pow 2 - &2601 / &10000) * --(x pow 2 - &203401 / &10000)) /
     (&63001 / &2500) `] THEN 
REWRITE_TAC[REAL_ARITH ` a pow 4 = a pow 2 pow 2 `]);;

REAL_ARITH ` &4650694416 = ( &68196 ) pow 2 `;;
REAL_ARITH` &4650694416 / &363188227801 = ( &68196 / &602651 ) pow 2 `;;


let PHAN_TICH = prove(  `! x. &4331842500 / &363188227801 *
     (x pow 2 - &488365801 / &44090000) *
     (x pow 2 - &2081667 / &1310000) =
     &4331842500 / &363188227801 * x pow 4 +
     -- &45702201 / &302530802 * x pow 2 +
     &529046001 / &2520040000`   , REAL_ARITH_TAC);;

let Q_TR = prove(`! x. #2.696 <= x /\ x <= sqrt8 ==>
  x pow 2 *
         (&1 / eta_y x #2.45 #2.45 pow 2 - &1 / eta_y x (&2) #2.51 pow 2) <= &0 `, 
SIMP_TAC[COMPUTE_TO_QUA_POLY; GSYM PHAN_TICH ] THEN 
NHANH (MESON[REAL_ARITH ` #2.696 <= x /\ x <= hh ==> &0 <= #2.696 /\ &0 <= x`
  ; REAL_LE_MUL2] ` #2.696 <= x /\ x <= hh ==>
   #2.696 * #2.696 <= x * x /\ x * x <= hh * hh `) THEN 
REWRITE_TAC[REAL_ARITH `
         &4331842500 / &363188227801 * a <= &0 <=> a <= &0 `] THEN 
CONV_TAC REAL_RAT_REDUCE_CONV THEN 
REWRITE_TAC[REAL_ARITH ` &0 <=
         &4331842500 / &363188227801 * a <=> &0 <= a `; sqrt8; GSYM POW_2;
  MESON[SQRT_WORKS; REAL_ARITH ` &0 <= &8 `]` sqrt (&8) pow 2 = &8 `] THEN 
NHANH (REAL_ARITH ` &113569 / &15625 <= x pow 2 /\
     x pow 2 <= &8 ==> x pow 2 - &488365801 / &44090000 <= &0 /\
  x pow 2 - &2081667 / &1310000 >= &0 `) THEN 
REWRITE_TAC[ REAL_ARITH ` ( a >= &0 <=> &0 <= a)/\ (a <= &0 <=> &0 <= -- a ) `] THEN 
REWRITE_TAC[REAL_ARITH ` -- ( a * b ) = -- a * b `] THEN 
MESON_TAC[REAL_LE_MUL]);;

let SQRT8_LT = prove(` sqrt (&8) < &4 * #2.45 `,
MP_TAC (REAL_ARITH ` &0 < &8 /\ &0 <  &4 * #2.45`) THEN 
SIMP_TAC[SQRT_POS_LT; LT_POW2_EQ_LT] THEN 
SIMP_TAC[REAL_LT_IMP_LE; SQRT_WORKS] THEN REAL_ARITH_TAC);;



let SQRT8_POW2 = MESON[SQRT_WORKS; REAL_ARITH ` &0 <= &8 `]` sqrt (&8) pow 2 = &8 `;;


let IM_UP_POS = prove(`! x. #2.696 <= x /\ x <= sqrt8 ==>
&0 < ups_x (x * x) (#2.45 * #2.45) (#2.45 * #2.45) /\
&0 < ups_x (x * x) (&2 * &2) (#2.51 * #2.51) `,
REWRITE_TAC[ups_x] THEN 
REWRITE_TAC[REAL_IDEAL_CONV [` (x:real) pow 2 `]` 
         --(x * x) * x * x -
         (#2.45 * #2.45) * #2.45 * #2.45 -
         (#2.45 * #2.45) * #2.45 * #2.45 +
         &2 * (x * x) * #2.45 * #2.45 +
         &2 * (x * x) * #2.45 * #2.45 +
         &2 * (#2.45 * #2.45) * #2.45 * #2.45 `] THEN 
CONV_TAC REAL_RAT_REDUCE_CONV THEN 
REWRITE_TAC[REAL_POLY_CONV ` --(x * x) * x * x - &16 - &3969126001 / &100000000 +
         &2 * (x * x) * &63001 / &10000 +
         &2 * (x * x) * &4 +
         &63001 / &1250 `] THEN 
NHANH (REAL_ARITH` #2.696 <= x /\ x <= s ==> &0 <= #2.696 /\
  &0 <= x /\ &0 <= s `) THEN 
ONCE_REWRITE_TAC[MESON[]` a /\ b ==> c <=> b ==> a ==> c `] THEN 
SIMP_TAC[POW2_COND; sqrt8; SQRT8_POW2] THEN 
NHANH (REAL_ARITH` #2.696 pow 2 <= x /\ x <= &8 ==> 
  &0 < &2401 / &100 + -- &1 * x /\ &0 < x /\
  ~ ( -- &1 = &0 ) /\ &0 <= ( &103001 / &5000 ) pow 2 - &4 * -- &1 *
  -- &529046001 / &100000000 `) THEN 
SIMP_TAC[REAL_ARITH ` x pow 4 = x pow 2 pow 2 `; FACTOR_OF_QUADRARTIC] THEN 
CONV_TAC REAL_RAT_REDUCE_CONV THEN 
REWRITE_TAC[REAL_ARITH ` &252004 / &625 = ( &502 / &25) pow 2 `] THEN 
REWRITE_TAC[MESON[POW_2_SQRT; REAL_ARITH ` &0 <= &502 / &25 `]` 
  sqrt ((&502 / &25) pow 2) = &502 / &25 `] THEN 
CONV_TAC REAL_RAT_REDUCE_CONV THEN 
NHANH (REAL_ARITH ` &113569 / &15625 <= x pow 2 /\ x pow 2 <= &8 ==>
  &0 < x pow 2 - &2601 / &10000 /\ &0 < -- (x pow 2 - &203401 / &10000) `) THEN 
REWRITE_TAC[REAL_ARITH ` -- &1 * a * b = a * --b `] THEN 
SIMP_TAC[REAL_LT_MUL]);;


let IMP_ETAY_POS = prove( `! x. #2.696 <= x /\ x <= sqrt8 ==>
&0 < eta_y x #2.45 #2.45 /\ &0 < eta_y x (&2) #2.51 `,
REWRITE_TAC[eta_y; eta_x] THEN 
LET_TR THEN 
NHANH (MESON[REAL_ARITH ` &0 <= #2.696`; REAL_LE_MUL2]`
  #2.696 <= x ==> #2.696 * #2.696 <= x * x `) THEN 
NHANH (REAL_ARITH ` #2.696 * #2.696 <= x * x ==>
  &0 < ((x * x) * (#2.45 * #2.45) * #2.45 * #2.45) /\
  &0 < ((x * x) * (&2 * &2) * #2.51 * #2.51) `) THEN 
MESON_TAC[IM_UP_POS; REAL_LT_DIV; SQRT_POS_LT]);;


let REAL_LE_RDIV_0 = prove(` ! a b. &0 < b ==> ( &0 <= a / b <=> &0 <= a ) `,
REWRITE_TAC[REAL_ARITH ` &0 <= a <=> &0 < a \/ a = &0 `] THEN 
SIMP_TAC[REAL_LT_RDIV_0] THEN 
SIMP_TAC[REAL_FIELD `&0 < b ==> ( a / b = &0 <=> a = &0 ) `]);;


let NHSJMDH = prove(` ! y. #2.696 <= y /\ y <= sqrt8 ==>
     eta_y y (&2) (#2.51) <= eta_y y #2.45 (#2.45) `,
NHANH (SPEC_ALL Q_TR) THEN 
ONCE_REWRITE_TAC[MESON[]` a /\ b ==> c <=> a ==> b ==> c `] THEN 
NHANH (MESON[REAL_ARITH ` &0 <= #2.696`; REAL_LE_MUL2]`
  #2.696 <= x ==> #2.696 * #2.696 <= x * x `)  THEN 
REWRITE_TAC[POW_2] THEN 
NHANH (REAL_ARITH `#2.696 * #2.696 <= y ==> &0 < y `) THEN 
REWRITE_TAC[REAL_ARITH ` a * b <= &0 <=> &0 <= a * -- b `] THEN 
SIMP_TAC[REAL_LE_MUL_EQ] THEN 
ONCE_REWRITE_TAC[MESON[]`( a/\b ) /\ c <=> ( a /\ c ) /\ b `] THEN 
NHANH (SPEC_ALL IMP_ETAY_POS) THEN 
NHANH (REAL_ARITH ` &0 < eta_y a b c ==> ~(eta_y a b c = &0 ) `) THEN 
REWRITE_TAC[GSYM REAL_POSSQ] THEN SIMP_TAC[REAL_FIELD ` &0 < a /\
 &0 < b ==>  -- (&1 / a - &1 / b) = (a - b) / ( a * b ) `] THEN 
PHA THEN SIMP_TAC[REAL_LT_MUL; REAL_LE_RDIV_0] THEN 
REWRITE_TAC[GSYM REAL_DIFFSQ] THEN 
SIMP_TAC[REAL_LT_ADD; REAL_LE_MUL_EQ] THEN REAL_ARITH_TAC);;


















(* NEW WORKS *)
let SQRT8_LE = MESON[ REAL_ARITH ` &0 <= &8`; SQRT_WORKS]` &0 <= sqrt (&8) `;;

let RELATE_POW2 = prove(` ( a = &0 <=> a pow 2 = &0 ) /\
  ( &0 < a pow 2 <=> &0 < a \/ ~( &0 <= a )) `,
MP_TAC (REAL_FIELD ` a = &0 <=> a pow 2 = &0 `) THEN DISCH_TAC THEN 
CONJ_TAC THENL [ASM_SIMP_TAC[]; MP_TAC REAL_LE_POW_2] THEN 
MP_TAC (REAL_ARITH `( ! a. &0 < a \/ ~(&0 <= a) \/ a = &0 )`) THEN 
MP_TAC (REAL_FIELD ` a = &0 <=> a pow 2 = &0 `) THEN 
REWRITE_TAC[REAL_ARITH ` A <= b <=> A = b \/ A < b `] THEN 
MESON_TAC[REAL_ARITH ` ~ ( a = &0 /\ ( &0 < a \/ ~( &0 <= a ) )) `]);;

let LT_POW2_COND = prove(`!a b. &0 <= a /\ &0 <= b ==> (a < b <=> a pow 2 < b pow 2)`,
REPEAT GEN_TAC THEN ASM_CASES_TAC ` a = &0 ` THENL
[ASM_SIMP_TAC[REAL_ARITH` &0 pow 2 = &0 `] THEN MESON_TAC[RELATE_POW2]; 
ASM_SIMP_TAC[REAL_LE_LT]] THEN STRIP_TAC THENL [ASM_MESON_TAC[LT_POW2_EQ_LT];
EXPAND_TAC "b"] THEN UNDISCH_TAC `&0 < a ` THEN REWRITE_TAC[REAL_ARITH `
 &0 pow 2 = &0 /\ (a < &0 <=> ~(&0 <= a))`] THEN MP_TAC REAL_LE_POW_2 THEN 
MESON_TAC[REAL_LT_IMP_LE]);;


let POS_IMP_POW2 = MESON[REAL_LE_TRANS; POW2_COND]` &0 <= a /\ a <= b ==> a pow 2 
  <= b pow 2 `;;


let SQRT8_LE_EQ_8_LESS_POW2 = prove(` sqrt (&8 ) <= a ==> &8 <= a pow 2 `,
MP_TAC SQRT8_LE THEN MESON_TAC[SQRT8_POW2; POS_IMP_POW2]);;


let MINIMAL_QUADRATIC_POLY =  prove(` 
! b c (x:real). ( &4 * c - b pow 2 ) / &4 <= x pow 2 + b * x + c `,
ONCE_REWRITE_TAC[REAL_ARITH ` a <= b <=> &0 <= b - a `] THEN 
REWRITE_TAC[REAL_ARITH ` (x pow 2 + b * x + c) - (&4 * c - b pow 2) / &4
  = ( x + b / &2 ) pow 2 `; REAL_LE_POW_2]);;

let GREATER_THAN_MID_QUADRATIC_PO = prove(` ! b c x x0. -- b / &2 <= x0 /\ x0 <= x ==>
  x0 pow 2 + b * x0 + c <= x pow 2 + b * x + c `,
REWRITE_TAC[REAL_ARITH ` x0 pow 2 + b * x0 + c <= x pow 2 + b * x + c
  <=> &0 <= ( x - x0 ) * ( x + x0 + b ) `] THEN 
MESON_TAC[REAL_ARITH ` --b / &2 <= x0 /\ x0 <= x ==>
  &0 <= x - x0 /\ &0 <= x + x0 + b `; REAL_LE_MUL]);;

(* PERMAINENCE *)
(* MARCH WORKS *)

let SQRT8_TWO_TWO = prove(` sqrt (&8) <= &2 + &2 `,
MP_TAC SQRT8_LE THEN NHANH (MESON[REAL_ARITH ` &0 <= &2 + &2 `]
`&0 <= sqrt (&8) ==> &0 <= &2 + &2 `) THEN SIMP_TAC[POW2_COND] THEN 
SIMP_TAC[REAL_ARITH ` &0 <= &8 `; SQRT_WORKS] THEN REAL_ARITH_TAC);;


let A_POS_DELTA = prove(` &0 < delta (#3.2 pow 2 ) (sqrt8 pow 2 ) (&2 pow 2) (sqrt8 pow 2) 
(&2 pow 2) (&2 pow 2) `, REWRITE_TAC[delta; sqrt8; SQRT8_POW2] THEN REAL_ARITH_TAC);;

(* le 35. p 22 *)
let THADGSB = new_axiom` !M13 m12 m14 M24 m34 m23 v1 v2 v3 v4.
         (!x. x IN {M13, m12, m14, M24, m34, m23} ==> &0 <= x) /\
         M13 < m12 + m23 /\
         M13 < m14 + m34 /\
         M24 < m12 + m14 /\
         M24 < m23 + m34 /\
         &0 <
         delta (M13 pow 2) (m12 pow 2) (m14 pow 2) (M24 pow 2) (m34 pow 2)
         (m23 pow 2) /\
         CARD {v1, v2, v3, v4} = 4 /\ 
   m12 <= d3 v1 v2 /\
         m23 <= d3 v2 v3 /\
         m34 <= d3 v3 v4 /\
         m14 <= d3 v1 v4 /\
         d3 v1 v3 <= M13 /\
         d3 v2 v4 <= M24 ==> conv {v1,v3} INTER conv {v2,v4} = {} `;;

let MET_LAM_ROI = prove(` #3.2 < sqrt8 + &2 /\ #3.2 < &2 + &2 /\ sqrt8 < sqrt8 + &2 /\
sqrt8 < &2 + &2 `,
REWRITE_TAC[sqrt8; REAL_ARITH ` a < sqrt (&8) + b <=> a - b < sqrt (&8) `] THEN 
REWRITE_TAC[REAL_ARITH ` sqrt (&8) - &2 < sqrt (&8) `] THEN 
CONV_TAC REAL_RAT_REDUCE_CONV THEN MP_TAC SQRT8_LE  THEN 
MP_TAC (REAL_ARITH` &0 <= &6 / &5 /\ &0 <= &4 `) THEN 
SIMP_TAC[LT_POW2_COND ] THEN SIMP_TAC[LT_POW2_COND; SQRT8_POW2 ] THEN 
REAL_ARITH_TAC);;


let PROVE_POS_THINGS = prove(` ! x. x IN {#3.2 , sqrt8, &2 , sqrt8, &2, &2 } ==> &0 <= x `,
REWRITE_TAC[SET_RULE `( !x. x IN {a,b,c,d,s,e} ==> p x ) <=>
  p a /\ p b /\ p c /\ p d /\ p s /\ p e `;sqrt8;  SQRT8_LE] THEN REAL_ARITH_TAC);;



let IMP_GT_THAN_TWO = prove(` ! v1 v2 w1 (w2:real^3).
           CARD {v1, w1,v2, w2} = 4 /\
           packing {v1, w1,v2, w2}
==>       &2 <= d3 w1 v2 /\
         &2 <= d3 v2 w2 /\
         &2 <= d3 v1 w2  `,
REWRITE_TAC[CARD4; packing; GSYM d3; sqrt8] THEN SET_TAC[]);;

(*       THADGSB         *)

let JGYWWBX = prove(` ~ (?v1 v2 w1 (w2:real^3).
           CARD {v1, v2, w1, w2} = 4 /\
           packing {v1, v2, w1, w2} /\
           dist (v1,w1) >= sqrt8 /\
           dist (v1,v2) <= #3.2 /\
           dist (w1,w2) <= sqrt8 /\
           ~(conv {v1, v2} INTER conv {w1, w2} = {}))`,
MP_TAC (MESON[ REAL_ARITH ` &0 <= &8 /\ &0 <= &2 /\ &0 <= #3.2 `;
   SQRT_WORKS]` &0 <= sqrt (&8) /\ &0 <= &2 /\ &0 <= #3.2`) THEN 
MP_TAC MET_LAM_ROI THEN 
REWRITE_TAC[MESON[]` CARD s = 4 /\ b /\ c <=> ( CARD s = 4 /\ b ) /\ c `] THEN 
ONCE_REWRITE_TAC[SET_RULE ` {v1, v2, w1, w2} = {v1,w1,v2,w2} `] THEN 
NHANH (SPEC_ALL IMP_GT_THAN_TWO ) THEN MP_TAC PROVE_POS_THINGS THEN 
MP_TAC A_POS_DELTA THEN REWRITE_TAC[GSYM d3; REAL_ARITH ` a >= b <=> b <= a `]
 THEN IMP_IMP_TAC THEN DISCH_TAC THEN NGOAC THEN 
MATCH_MP_TAC (MESON[]` (! v1 v2 w1 w2. P v1 v2 w1 w2 ==> Q v1 v2 w1 w2)
  ==> ~(? v1 v2 w1 w2. P v1 v2 w1 w2 /\ ~( Q v1 v2 w1 w2)) `) THEN 
REPEAT GEN_TAC THEN FIRST_X_ASSUM MP_TAC  THEN ABBREV_TAC `M13 = #3.2 ` THEN 
PHA THEN REWRITE_TAC[sqrt8] THEN MP_TAC (SPECL [`M13:real`; `sqrt8`; `&2`;`sqrt8`
;`&2 `; `&2`;  `v1:real^3` ; `w1:real^3`; `v2:real^3`; `w2:real^3`] THADGSB) THEN 
SIMP_TAC[D3_SYM; sqrt8]);;

let LEMMA37 = JGYWWBX;;


let LEMMA_FOR_PAHFWSI = prove(`! v1 v2 v3 v4. CARD {v1, v2, v3, v4} = 4 /\
         packing {v1, v2, v3, v4} /\
         dist (v1,v3) <= #3.2 /\
         #2.51 <= dist (v1,v2) /\
         dist (v2,v4) <= #2.51
==>     (!x. x IN {#3.2, #2.51, &2, #2.51, &2, &2} ==> &0 <= x) /\
         #3.2 < #2.51 + &2 /\
         #3.2 < &2 + &2 /\
         #2.51 < #2.51 + &2 /\
         #2.51 < &2 + &2 /\
         &0 <
         delta (#3.2 pow 2) (#2.51 pow 2) (&2 pow 2) (#2.51 pow 2) (&2 pow 2)
         (&2 pow 2) /\
         CARD {v1, v2, v3, v4} = 4 /\
         #2.51 <= d3 v1 v2 /\
         &2 <= d3 v2 v3 /\
         &2 <= d3 v3 v4 /\
         &2 <= d3 v1 v4 /\
         d3 v1 v3 <= #3.2 /\
         d3 v2 v4 <= #2.51 `,
REWRITE_TAC[SET_RULE ` (!x. x IN {a,b,c,d,e,f} ==> P x ) <=>
  P a /\ P b /\ P c /\ P d /\ P e /\ P f `; REAL_ARITH ` 
  &0 <= #2.51 /\
          &0 <= &2 /\
          &0 <= &2 /\
          &0 <= #3.2 /\
          &0 <= &2 /\
          &0 <= #2.51 /\ #2.51 < &2 + #2.51 /\
         #2.51 < &2 + &2 /\
         #3.2 < &2 + &2 /\
         #3.2 < #2.51 + &2 /\ #3.2 < &2 + #2.51 /\
         #2.51 < #2.51 + &2  `] THEN SIMP_TAC[GSYM d3] THEN 
REWRITE_TAC[CARD4; packing; delta; d3] THEN CONV_TAC REAL_RAT_REDUCE_CONV
THEN SET_TAC[]);;

let PAHFWSI = prove(` !(v1:real^3) v2 v3 v4.
         CARD {v1, v2, v3, v4} = 4 /\
         packing {v1, v2, v3, v4} /\
         dist (v1,v3) <= #3.2 /\
         #2.51 <= dist (v1,v2) /\
         dist (v2,v4) <= #2.51
         ==> conv {v1, v3} INTER conv {v2, v4} = {} `, REPEAT GEN_TAC THEN 
MP_TAC (SPECL [` #3.2 `; `#2.51`;` &2 `; ` #2.51 `;` &2 `; `&2`] THADGSB) THEN 
NHANH (SPEC_ALL LEMMA_FOR_PAHFWSI ) THEN SIMP_TAC[]);;
let LEMMA38 = PAHFWSI;;

let LEMMA_OF_39 = prove(` ! (v1:real^3) v2 w1 w2.
         CARD {v1, v2, w1, w2} = 4 /\
         packing {v1, v2, w1, w2} /\
         dist (w1,w2) <= #2.51 /\
         dist (v1,v2) <= #3.07
==> (!x. x IN {#2.51, &2, &2, #3.07, &2, &2} ==> &0 <= x) /\
     #2.51 < &2 + &2 /\
     #2.51 < &2 + &2 /\
     #3.07 < &2 + &2 /\
     #3.07 < &2 + &2 /\
     &0 <
     delta (#2.51 pow 2) (&2 pow 2) (&2 pow 2) (#3.07 pow 2) (&2 pow 2)
     (&2 pow 2) /\
     CARD {w1, v1, w2, v2} = 4 /\
     &2 <= d3 w1 v1 /\
     &2 <= d3 v1 w2 /\
     &2 <= d3 w2 v2 /\
     &2 <= d3 w1 v2 /\
     d3 w1 w2 <= #2.51 /\
     d3 v1 v2 <= #3.07 `,
REWRITE_TAC[SET_RULE ` (!x. x IN {a,b,c,d,e,f} ==> P x ) <=>
  P a /\ P b /\ P c /\ P d /\ P e /\ P f `; delta; GSYM d3] THEN CONV_TAC 
REAL_RAT_REDUCE_CONV THEN REPEAT GEN_TAC THEN STRIP_TAC THEN CONJ_TAC THENL 
[ASM_MESON_TAC[SET_RULE ` {v1, v2, w1, w2} = {w1, v1, w2, v2}`];DOWN_TAC]
 THEN REWRITE_TAC[CARD4; packing; d3] THEN SET_TAC[]);;


let UVGVIXB = prove(` ! (v1:real^3) v2 w1 w2.
         CARD {v1, v2, w1, w2} = 4 /\
         packing {v1, v2, w1, w2} /\
         dist (w1,w2) <= #2.51 /\
         dist (v1,v2) <= #3.07
         ==> conv {w1, w2} INTER conv {v1, v2} = {}`, NHANH (SPEC_ALL LEMMA_OF_39)
 THEN SIMP_TAC[ SPECL [ ` #2.51 `; `&2 `; `&2 `; `#3.07 `; `&2 `; ` &2 `; 
` w1:real^3 `; ` v1:real^3`;` w2:real^3`; `v2:real^3 `] THADGSB ]);;

let LEMMA39 = UVGVIXB;;

let LEMMA_OF_LEMMA40 = prove(`! v1 v2 w1 (w2:real^3).  CARD {v1, v2, w1, w2} = 4 /\
         packing {v1, v2, w1, w2} /\
         dist (v1,v2) <= #3.2 /\
         dist (w1,w2) <= #2.51 /\
         #2.2 <= dist (v1,w1)
==> (!x. x IN {#3.2, #2.2, &2, #2.51, &2, &2} ==> &0 <= x) /\
     #3.2 < #2.2 + &2 /\
     #3.2 < &2 + &2 /\
     #2.51 < #2.2 + &2 /\
     #2.51 < &2 + &2 /\
     &0 <
     delta (#3.2 pow 2) (#2.2 pow 2) (&2 pow 2) (#2.51 pow 2) (&2 pow 2)
     (&2 pow 2) /\
     CARD {v1, w1, v2, w2} = 4 /\
     #2.2 <= d3 v1 w1 /\
     &2 <= d3 w1 v2 /\
     &2 <= d3 v2 w2 /\
     &2 <= d3 v1 w2 /\
     d3 v1 v2 <= #3.2 /\
     d3 w1 w2 <= #2.51 `,
REWRITE_TAC[SET_RULE ` (! x. x IN {a,b,c,d,e,f} ==> P x ) <=>
  P a /\ P b /\ P c /\ P d /\ P e /\ P f `; delta] THEN 
CONV_TAC REAL_RAT_REDUCE_CONV THEN SIMP_TAC[SET_RULE ` 
{v1, v2, w1, w2} = {v1, w1, v2, w2} `; packing] THEN 
SIMP_TAC[CARD4; GSYM d3] THEN SET_TAC[]);;

let PJFAYXI = prove(`! (v1:real^3) v2 w1 w2.
 CARD {v1, v2, w1, w2} = 4 /\  packing {v1, v2, w1, w2} /\
         dist (v1,v2) <= #3.2 /\
         dist (w1,w2) <= #2.51 /\
         #2.2 <= dist (v1,w1)
         ==> conv {v1, v2} INTER conv {w1, w2} = {}`,
NHANH (SPEC_ALL LEMMA_OF_LEMMA40) THEN SIMP_TAC[ 
SPECL [ ` #3.2 `; `#2.2 `; `&2 `; `#2.51 `; `&2 `; ` &2 `;
 ` v1:real^3 `; ` w1:real^3`;` v2:real^3`; `w2:real^3 `] THADGSB ]);;

let LEMMA40 = PJFAYXI;;



let LEOF41 = prove(
`#3.114467 < x ==> delta (#2.51 pow 2) (&2 pow 2) (&2 pow 2) (&2 pow 2)
 (&2 pow 2) (x pow 2) < &0`,
NHANH (MESON[REAL_ARITH ` #3.114467 < x ==> &0 < #3.114467 /\ &0 < x `;
  LT_POW2_EQ_LT]` #3.114467 < x ==> ( #3.114467 ) pow 2 < x pow 2 `) THEN 
REWRITE_TAC[delta] THEN CONV_TAC REAL_RAT_REDUCE_CONV THEN 
REWRITE_TAC[ REAL_POLY_CONV ` -- &126002 / &625 - &4 * &4 * x pow 2 - &4 * &4 * x pow 2 +
     &63001 / &10000 *     x pow 2 *
     (-- &63001 / &10000 + &4 + &4 + &4 + &4 - x pow 2) +
     &4 * &4 * (&23001 / &10000 + &4 + &0 + x pow 2) +
     &4 * &4 * (&63001 / &10000 + -- &4 + &4 + x pow 2) `] THEN 
REWRITE_TAC[REAL_ARITH ` a pow 4 = a pow 2 pow 2 `] THEN 
REWRITE_TAC[REAL_ARITH ` a * x pow 2 + b * x = ( a * x + b ) * x `] THEN 
NHANH (REAL_ARITH `&9699904694089 / &1000000000000 < x pow 2
     ==> -- &63001 / &10000 * x pow 2 + &6111033999 / &100000000 < &0` ) THEN 
NHANH (REAL_ARITH `&9699904694089 / &1000000000000 < x ==> &0 < x `) THEN 
REWRITE_TAC[REAL_ARITH ` a < &0 <=> &0 < -- a `;
  REAL_ARITH ` -- ( a * b ) = -- a * b `] THEN MESON_TAC[REAL_LT_MUL]);;


let LEMMA41 = prove(`! v1 v2 v3 (v4:real^3).
 CARD {v1,v2,v3,v4} = 4 /\ 
 d3 v1 v2 = #2.51 /\
         d3 v1 v3 = &2 /\
         d3 v1 v4 = &2 /\
         d3 v2 v3 = &2 /\
         d3 v2 v4 = &2
         ==> d3 v3 v4 <= #3.114467 `,
REPEAT GEN_TAC THEN MP_TAC LEMMA3 THEN LET_TR THEN 
REWRITE_TAC[REAL_ARITH ` x <= #3.114467 <=> ~ (#3.114467 < x ) `] THEN 
REWRITE_TAC[REAL_ARITH ` x <= #3.114467 <=> ~ (#3.114467 < x ) `;
   MESON[]` a ==> ~ b <=> a /\ b ==> F `] THEN PHA THEN 
NHANH (SPEC_ALL (prove(`! (v1:real^3) v2 v3 v4. d3 v1 v2 = #2.51 /\
d3 v1 v3 = &2 /\ d3 v1 v4 = &2 /\ d3 v2 v3 = &2 /\ d3 v2 v4 = &2 /\ 
#3.114467 < d3 v3 v4 ==> delta (dist (v1,v2) pow 2) (dist (v1,v3) pow 2) 
(dist (v1,v4) pow 2) (dist (v2,v3) pow 2) (dist (v2,v4) pow 2)
 (dist (v3,v4) pow 2) < &0 `, SIMP_TAC[d3] THEN MESON_TAC[LEOF41]))) THEN 
REWRITE_TAC[REAL_ARITH ` a < &0 <=> ~( &0 <= a ) `; d3] THEN MESON_TAC[]);;

let YXWIPMH = LEMMA41;;

let LEMMA_OF_L42 = prove(`sqrt8 <= d3 v2 v4 /\ #3.488 <= x
 ==> -- &1 * x pow 2 * d3 v2 v4 pow 2 +
     -- &1 * x pow 4 +
     &103001 / &5000 * x pow 2 +
     -- &529046001 / &100000000 <
     &0`,
MP_TAC SQRT8_LE THEN 
IMP_IMP_TAC THEN 
NHANH (MESON[REAL_ARITH ` &0 <= a /\ a <= b /\ #3.488 <= x ==> &0 <= b /\
  &0 <= #3.488 /\ &0 <= x `; POW2_COND]`
  &0 <= a /\ a <= b /\ #3.488 <= x ==> a pow 2 <= b pow 2 /\
  #3.488 pow 2 <= x pow 2 `) THEN 
REWRITE_TAC[SQRT8_POW2; sqrt8] THEN 
NHANH (MESON[REAL_ARITH ` &0 <= a /\ a <= b /\ #3.488 <= x ==> &0 <= b /\
  &0 <= #3.488 /\ &0 <= x `; POW2_COND]`
  &0 <= a /\ a <= b /\ #3.488 <= x ==> a pow 2 <= b pow 2 /\
  #3.488 pow 2 <= x pow 2 `) THEN 
REWRITE_TAC[SQRT8_POW2] THEN 
NHANH (MESON[REAL_ARITH ` &0 <= &8 /\ &0 <= #3.488 pow 2 `; REAL_LE_MUL2]` &8 <= a /\
 #3.488 pow 2 <= b ==> &8 * #3.488 pow 2 <= a * b `) THEN 
REWRITE_TAC[REAL_ARITH` a pow 4 = a pow 2 pow 2 `] THEN 
NHANH (MESON[REAL_ARITH ` #3.488 pow 2 <= x ==> &0 <= #3.488 pow 2 /\
  &0 <= x `; POW2_COND]` #3.488 pow 2 <= x ==> #3.488 pow 2 pow 2 <= x pow 2 `) THEN 
REWRITE_TAC[REAL_ARITH ` a + -- &1 * x pow 2 + b * x + c =
  a + -- &1 * ( x pow 2 + -- b * x + -- c ) `] THEN 
NHANH (prove(` #3.488 pow 2 <= x pow 2 ==>
  #3.488 pow 2 pow 2 +
      --(&103001 / &5000) * #3.488 pow 2 +
      --(-- &529046001 / &100000000) <= x pow 2 pow 2 +
      --(&103001 / &5000) * x pow 2 +
      --(-- &529046001 / &100000000) `,
MP_TAC (REAL_ARITH ` -- (  --(&103001 / &5000))  / &2 <= #3.488 pow 2 `) THEN 
MESON_TAC[GREATER_THAN_MID_QUADRATIC_PO ])) THEN 
REAL_ARITH_TAC);;



let LEMMA_IN_LEMMA42_P25 = prove(` ! v1 v2 v3 v4 x. 
            d3 v1 v2 = #2.51 /\
            d3 v1 v4 = #2.51 /\
            d3 v2 v3 = &2 /\
            d3 v3 v4 = &2 /\
            sqrt8 <= d3 v2 v4 /\
            #3.488 <= x
==>   delta (d3 v1 v2 pow 2) ( x pow 2) (d3 v1 v4 pow 2)
      (d3 v2 v3 pow 2)
      (d3 v2 v4 pow 2)
      (d3 v3 v4 pow 2) < &0 `,
SIMP_TAC[] THEN 
NHANH (MESON[REAL_ARITH` #3.488 <= x ==> &0 <= #3.488 /\ &0 <= x `; POW2_COND]`
  #3.488 <= x ==> (#3.488 pow 2 <= x pow 2 ) `) THEN 
REWRITE_TAC[delta] THEN 
CONV_TAC REAL_RAT_REDUCE_CONV THEN 
REWRITE_TAC[REAL_POLY_CONV `--(&63001 / &10000 * x pow 2 * &4) -
         &63001 / &10000 * &63001 / &10000 * d3 v2 v4 pow 2 -
         x pow 2 * &63001 / &2500 -
         &4 * d3 v2 v4 pow 2 * &4 +
         &63001 / &10000 *
         &4 *
         (-- &63001 / &10000 +
          x pow 2 +
          &63001 / &10000 +
          &4 +
          d3 v2 v4 pow 2 - &4) +
         x pow 2 *
         d3 v2 v4 pow 2 *
         (&63001 / &10000 - x pow 2 +
          &63001 / &10000 +
          &4 - d3 v2 v4 pow 2 +
          &4) +
         &63001 / &10000 *
         &4 *
         (&63001 / &10000 +
          x pow 2 - &63001 / &10000 - &4 +
          d3 v2 v4 pow 2 +
          &4) `] THEN 
REWRITE_TAC[REAL_IDEAL_CONV [` y pow 2 `] `-- &1 * x pow 4 * y pow 2 +
         -- &1 * x pow 2 * y pow 4 +
         &103001 / &5000 * x pow 2 * y pow 2 +
         -- &529046001 / &100000000 * y pow 2 `] THEN 
REWRITE_TAC[MESON[]` a/\ #3.488 <= x /\ c <=> (a/\ #3.488 <= x )/\ c`] THEN 
NHANH (LEMMA_OF_L42) THEN 
REWRITE_TAC[sqrt8] THEN 
NHANH (SQRT8_LE_EQ_8_LESS_POW2) THEN 
REPEAT GEN_TAC THEN 
STRIP_TAC THEN 
UNDISCH_TAC ` &8 <= d3 v2 v4 pow 2 ` THEN 
UNDISCH_TAC ` -- &1 * x pow 2 * d3 v2 v4 pow 2 +
      -- &1 * x pow 4 +
      &103001 / &5000 * x pow 2 +
      -- &529046001 / &100000000 <
      &0 ` THEN 
ABBREV_TAC ` xx = (-- &1 * x pow 2 * d3 v2 v4 pow 2 +
      -- &1 * x pow 4 +
      &103001 / &5000 * x pow 2 +
      -- &529046001 / &100000000)` THEN 
NHANH (REAL_ARITH ` &8 <= a ==> &0 < a `) THEN 
REWRITE_TAC[REAL_ARITH ` ( a * b < &0 <=> &0 < ( -- a ) * b )/\
  ( a < &0 <=> &0 < -- a )`] THEN 
SIMP_TAC[REAL_LT_MUL]);;

let PAATDXJ =prove(` ! v1 v2 v3 (v4:real^3).
         CARD {v1,v2,v3,v4} = 4 /\ 
         d3 v1 v2 = #2.51 /\
         d3 v1 v4 = #2.51 /\
         d3 v2 v3 = &2 /\
         d3 v3 v4 = &2 /\
         sqrt8 <= d3 v2 v4
         ==> d3 v1 v3 < #3.488 `,
MP_TAC LEMMA3 THEN LET_TR THEN REWRITE_TAC[REAL_ARITH ` a < b <=> ~ ( b <= a )`]
THEN REWRITE_TAC[MESON[]` a ==> ~ b <=> ~( a /\b)`] THEN 
PHA THEN NHANH (SPEC_ALL LEMMA_IN_LEMMA42_P25) THEN 
REWRITE_TAC[REAL_ARITH` a < b <=> ~(b <= a ) `] THEN SIMP_TAC[d3]);;


(* the following lemma are in Multivariate/convex.ml *)


let CONVEX_FINITE = new_axiom `!s:real^N->bool.
        FINITE s
        ==> (convex s <=>
                !u. (!x. x IN s ==> &0 <= u x) /\
                    sum s u = &1
                    ==> vsum s (\x. u(x) % x) IN s)`;;

let CONVEX_BALL = new_axiom `!x:real^N e. convex( normball x e) `;;

let CONVEX_HULL_FINITE = new_axiom `
  !s. FINITE s
       ==> convex hull s =
                {y:real^N | ?u. (!x. x IN s ==> &0 <= u x) /\
                                sum s u = &1 /\
                                vsum s (\x. u(x) % x) = y} `;;

let CONVEX_HULL4 = 
MATCH_MP CONVEX_HULL_FINITE (MESON[ FINITE_RULES]` FINITE {(v1:real^N),v2,v3,v4} `);;



let CONVEX_EXPLICIT = new_axiom `!s:real^N->bool.
        convex s <=>
        !t u. FINITE t /\ t SUBSET s /\ (!x. x IN t ==> &0 <= u x) /\
              sum t u = &1
              ==> vsum t (\x. u(x) % x) IN s`;;

let CONVEX_HULL_FINITE_STEP = new_axiom
`((?u. (!x. x IN {} ==> &0 <= u x) /\
         sum {} u = w /\
         vsum {} (\x. u(x) % x) = y) <=> w = &0 /\ y = vec 0) /\
   (FINITE(s:real^N->bool)
    ==> ((?u. (!x. x IN (a INSERT s) ==> &0 <= u x) /\
              sum (a INSERT s) u = w /\
              vsum (a INSERT s) (\x. u(x) % x) = y) <=>
         ?v. &0 <= v /\
             ?u. (!x. x IN s ==> &0 <= u x) /\
              sum s u = w - v /\
              vsum s (\x. u(x) % x) = y - v % a))`;;

let CONVEX_HULL_4_EQUIV = prove(` ! v1 v2 v3 (v4:real^N).
  conv {v1,v2,v3,v4} = { x | ? a b c d. 
  &0 <= a /\
          &0 <= b /\
          &0 <= c /\
          &0 <= d /\
          a + b + c + d = &1 /\
          a % v1 + b % v2 + c % v3 + d % v4 = x } `,
REWRITE_TAC[conv; FUN_EQ_THM; affsign; lin_combo; UNION_EMPTY; 
 IN_ELIM_THM; sgn_ge] THEN 
REWRITE_TAC[MESON[]` x = vsum aa bb /\ a /\ b <=>
  a /\ b /\ vsum aa bb = x `] THEN 
ONCE_REWRITE_TAC[SET_RULE ` a s ==> b <=> s IN a ==> b `] THEN 
 SIMP_TAC[CONVEX_HULL_FINITE_STEP; FINITE_INSERT; FINITE_RULES] THEN
 REWRITE_TAC[REAL_ARITH `x - y = z:real <=> x = y + z`;
             VECTOR_ARITH `x - y = z:real^N <=> x = y + z`] THEN
 REWRITE_TAC[VECTOR_ADD_RID; REAL_ADD_RID] THEN MESON_TAC[IN]);;


let TXDIACY = prove(`! (a:real^3) b c d (v0: real^3) r.
 {a, b, c, d} SUBSET normball v0 r
         ==> convex hull {a, b, c, d} SUBSET normball v0 r `,
REPEAT GEN_TAC THEN MP_TAC (MESON[CONVEX_BALL]` convex (normball (v0:real^3) r)`) THEN 
NHANH (MESON[FINITE6] ` {a, b, c, d} SUBSET s ==> FINITE {(a:real^3),b,c,d} `) THEN 
REWRITE_TAC[CONVEX_HULL4; CONVEX_EXPLICIT] THEN 
IMP_IMP_TAC THEN 
REWRITE_TAC[SET_RULE ` {a | P a } SUBSET b <=> (! a. P a ==> a IN b)`] THEN 
REWRITE_TAC[MESON[]` (! y. ( ? u. P u y ) ==> Q y ) <=>
  (! y u. P u y ==> Q y ) `] THEN 
REWRITE_TAC[MESON[]`(!y u. P u /\ Q u /\ R u = y ==> Z y) <=> 
  (!u. P u /\ Q u ==> Z (R u)) `] THEN MESON_TAC[]);;
let LEMMA14 = TXDIACY;;


let ECSEVNC = prove(`?t1 t2 t3 t4.
     !v1 v2 v3 v4 (v: real^3).
         ~coplanar {v1, v2, v3, v4}
         ==> t1 v1 v2 v3 v4 v +
             t2 v1 v2 v3 v4 v +
             t3 v1 v2 v3 v4 v +
             t4 v1 v2 v3 v4 v =
             &1 /\
             v =
             t1 v1 v2 v3 v4 v % v1 +
             t2 v1 v2 v3 v4 v % v2 +
             t3 v1 v2 v3 v4 v % v3 +
             t4 v1 v2 v3 v4 v % v4 /\
             (!ta tb tc td.
                  v = ta % v1 + tb % v2 + tc % v3 + td % v4 /\
                  ta + tb + tc + td = &1
                  ==> ta = t1 v1 v2 v3 v4 v /\
                      tb = t2 v1 v2 v3 v4 v /\
                      tc = t3 v1 v2 v3 v4 v /\
                      td = t4 v1 v2 v3 v4 v) `,
REWRITE_TAC[GSYM SKOLEM_THM; RIGHT_EXISTS_IMP_THM] THEN REPEAT 
GEN_TAC THEN NHANH (SPEC_ALL (prove(`!v1 v2 v3 v0 v:real^3.
    ~coplanar {v0, v1, v2, v3} ==> (?t1 t2 t3. v - v0 = t1 % (v1 - v0)
 + t2 % (v2 - v0) + t3 % (v3 - v0) /\ (!ta tb tc. v - v0 = ta % (v1 - v0)
 + tb % (v2 - v0) + tc % (v3 - v0)   ==> ta = t1 /\
 tb = t2 /\ tc = t3))`, SIMP_TAC[NONCOPLANAR_3_BASIS]))) THEN 
STRIP_TAC THEN EXISTS_TAC ` &1 - t1 - t2 - t3 ` THEN 
EXISTS_TAC ` t1:real ` THEN EXISTS_TAC ` t2:real ` THEN 
EXISTS_TAC ` t3:real ` THEN CONJ_TAC THENL [REAL_ARITH_TAC;
 CONJ_TAC] THENL [UNDISCH_TAC ` (v:real^3) - v1 = t1 % (v2 - v1) + 
t2 % (v3 - v1) + t3 % (v4 - v1)` THEN 
CONV_TAC VECTOR_ARITH; REPEAT GEN_TAC] THEN 
REWRITE_TAC[MESON[]` a /\ b ==> c <=> b ==> a ==> c `;
  REAL_ARITH ` ta + tb + tc + td = &1 <=> ta = &1 - tb - tc - td `] THEN 
SIMP_TAC[] THEN REWRITE_TAC[VECTOR_ARITH `   v = (&1 - tb - tc - td) % v1
 + tb % v2 + tc % v3 + td % v4 <=>  v - v1 = tb % ( v2 - v1 ) + 
tc % ( v3 - v1 ) + td % ( v4 - v1 ) `] THEN ASM_MESON_TAC[]);;

let LEMMA76 = ECSEVNC;;

let COEFS_4 = new_specification ["COEF4_1"; "COEF4_2"; "COEF4_3"; "COEF4_4"] ECSEVNC ;;





let COEF_1_EQ_ZERO = prove(` ! v1 v2 v3 v4 (v:real^3).
  ~ coplanar {v1,v2,v3,v4} ==>
  ( COEF4_1 v1 v2 v3 v4 v = &0 <=> v IN aff {v2,v3,v4} ) `,
REWRITE_TAC[aff; AFFINE_HULL_3; IN_ELIM_THM] THEN 
NHANH (SPEC_ALL COEFS_4) THEN 
REPEAT GEN_TAC THEN STRIP_TAC THEN 
ONCE_REWRITE_TAC[REAL_ARITH` u + v + w = &0 + u + v + w `] THEN 
ONCE_REWRITE_TAC[VECTOR_ARITH` u + v + w = &0 % v1 + u + v + w `] THEN 
ASM_MESON_TAC[]);;


let EQ_IMP_COPLANAR = prove(`! a b c (d:real^3). ( a = b \/ a = c \/ a = d )
 ==> coplanar {a,b,c,d} `,
REPEAT STRIP_TAC THENL [
ASM_SIMP_TAC[SET_RULE ` a INSERT ( a INSERT s ) = a INSERT s `] THEN 
MP_TAC (DIMINDEX_3) THEN MESON_TAC[COPLANAR_3;  ARITH_RULE` a = 3 ==> 2 <= a `];
ONCE_REWRITE_TAC[SET_RULE` {a,b,v,c} = {a,v,b,c} `] THEN 
ASM_SIMP_TAC[SET_RULE ` a INSERT ( a INSERT s ) = a INSERT s `] THEN 
MP_TAC (DIMINDEX_3) THEN MESON_TAC[COPLANAR_3;  ARITH_RULE` a = 3 ==> 2 <= a `];
ONCE_REWRITE_TAC[SET_RULE` {a,b,v,c} = {a,c,v,b} `] THEN 
ASM_SIMP_TAC[SET_RULE ` a INSERT ( a INSERT s ) = a INSERT s `] THEN 
MP_TAC (DIMINDEX_3) THEN MESON_TAC[COPLANAR_3;  ARITH_RULE` a = 3 ==> 2 <= a `]]);;





let AFFINE_HULL_FINITE_STEP_GEN = prove
 (`!P:real^N->real->bool.
       ((?u. (!x. x IN {} ==> P x (u x)) /\
             sum {} u = w /\ vsum {} (\x. u(x) % x) = y) <=>
        w = &0 /\ y = vec 0) /\
       (FINITE(s:real^N->bool) /\
        (!y. a IN s /\ P a y ==> P a (y / &2)) /\
        (!x y. a IN s /\ P a x /\ P a y ==> P a (x + y))
        ==> ((?u. (!x. x IN (a INSERT s) ==> P x (u x)) /\
                  sum (a INSERT s) u = w /\
                  vsum (a INSERT s) (\x. u(x) % x) = y) <=>
             ?v u. P a v /\ (!x. x IN s ==> P x (u x)) /\
                   sum s u = w - v /\
                   vsum s (\x. u(x) % x) = y - v % a))`,
 GEN_TAC THEN SIMP_TAC[SUM_CLAUSES; VSUM_CLAUSES; NOT_IN_EMPTY] THEN
 CONJ_TAC THENL [MESON_TAC[]; ALL_TAC] THEN DISCH_TAC THEN
 ASM_CASES_TAC `(a:real^N) IN s` THEN ASM_REWRITE_TAC[] THENL
  [ASM_SIMP_TAC[SET_RULE `a IN s ==> a INSERT s = s`] THEN EQ_TAC THEN
   REWRITE_TAC[LEFT_IMP_EXISTS_THM] THENL
    [X_GEN_TAC `u:real^N->real` THEN STRIP_TAC THEN
     EXISTS_TAC `(u:real^N->real) a / &2` THEN
     EXISTS_TAC `\x:real^N. if x = a then u x / &2 else u x`;
     MAP_EVERY X_GEN_TAC [`v:real`; `u:real^N->real`] THEN
     STRIP_TAC THEN
     EXISTS_TAC `\x:real^N. if x = a then u x + v else u x`] THEN
   ASM_SIMP_TAC[] THEN (CONJ_TAC THENL [ASM_MESON_TAC[]; ALL_TAC]) THEN
   ONCE_REWRITE_TAC[COND_RAND] THEN ONCE_REWRITE_TAC[COND_RATOR] THEN
   ASM_SIMP_TAC[VSUM_CASES; SUM_CASES] THEN
   ASM_SIMP_TAC[GSYM DELETE; SUM_DELETE; VSUM_DELETE] THEN
   ASM_SIMP_TAC[SET_RULE `a IN s ==> {x | x IN s /\ x = a} = {a}`] THEN
   REWRITE_TAC[SUM_SING; VSUM_SING] THEN
   (CONJ_TAC THENL [REAL_ARITH_TAC; VECTOR_ARITH_TAC]);
   EQ_TAC THEN REWRITE_TAC[LEFT_IMP_EXISTS_THM] THENL
    [X_GEN_TAC `u:real^N->real` THEN STRIP_TAC THEN
     EXISTS_TAC `(u:real^N->real) a` THEN
     EXISTS_TAC `u:real^N->real` THEN ASM_SIMP_TAC[IN_INSERT] THEN
     REPEAT(FIRST_X_ASSUM(SUBST1_TAC o SYM)) THEN
     CONJ_TAC THENL [REAL_ARITH_TAC; VECTOR_ARITH_TAC];
     MAP_EVERY X_GEN_TAC [`v:real`; `u:real^N->real`] THEN
     STRIP_TAC THEN
     EXISTS_TAC `\x:real^N. if x = a then v:real else u x` THEN
     ASM_SIMP_TAC[IN_INSERT] THEN CONJ_TAC THENL
      [ASM_MESON_TAC[]; ALL_TAC] THEN
     ONCE_REWRITE_TAC[COND_RAND] THEN ONCE_REWRITE_TAC[COND_RATOR] THEN
     ASM_SIMP_TAC[VSUM_CASES; SUM_CASES] THEN
     ASM_SIMP_TAC[GSYM DELETE; SUM_DELETE; VSUM_DELETE] THEN
     ASM_SIMP_TAC[SET_RULE `~(a IN s) ==> {x | x IN s /\ x = a} = {}`] THEN
     ASM_SIMP_TAC[SET_RULE `~(a IN s) ==> s DELETE a = s`] THEN
     REWRITE_TAC[SUM_CLAUSES; VSUM_CLAUSES] THEN
     CONJ_TAC THENL [REAL_ARITH_TAC; VECTOR_ARITH_TAC]]]);;



let THEOREM_RE_AFF_LT31 = prove
 (`!v1 v2 v3 vv x:real^N.
       ~(v1 = vv) /\ ~(v2 = vv) /\ ~(v3 = vv)
       ==> ((?f. f vv < &0 /\
                 sum {v1, v2, v3, vv} f = &1 /\
                 x = vsum {v1, v2, v3, vv} (\v. f v % v)) <=>
            {x | ?a b c t.
                     a + b + c + t = &1 /\
                     x = a % v1 + b % v2 + c % v3 + t % vv /\
                     t < &0}
            x)`,
 REPEAT STRIP_TAC THEN MATCH_MP_TAC EQ_TRANS THEN
 EXISTS_TAC
  `?f. (!x:real^N. x IN {v1, v2, v3, vv} ==> vv = x ==> f x < &0) /\
       sum {v1, v2, v3, vv} f = &1 /\
       vsum {v1, v2, v3, vv} (\v. f v % v) = x` THEN
 CONJ_TAC THENL
  [ASM_REWRITE_TAC[FORALL_IN_INSERT; NOT_IN_EMPTY] THEN MESON_TAC[];
   SIMP_TAC[AFFINE_HULL_FINITE_STEP_GEN;
            REAL_ARITH `x < &0 /\ y < &0 ==> x + y < &0`;
            REAL_ARITH `x < &0 ==> x / &2 < &0`;
            FINITE_INSERT; CONJUNCT1 FINITE_RULES; RIGHT_EXISTS_AND_THM] THEN
   ASM_REWRITE_TAC[IN_ELIM_THM;
                   REAL_ARITH `x - y:real = z <=> x = y + z`;
                   VECTOR_ARITH `x - y:real^N = z <=> x = y + z`] THEN
   REWRITE_TAC[VECTOR_ADD_RID; REAL_ADD_RID] THEN MESON_TAC[]]);;

let AFF_LT31 = prove(` ! v1 v2 v3 (vv: real^N). ~ (vv IN {v1,v2,v3} ) ==>
aff_lt {v1,v2,v3} {vv} = 
   { x| ? a b c t. t < &0 /\ a + b + c + t = &1 /\
           x = a % v1 + b % v2 + c % v3 + t % vv } `,
REWRITE_TAC[IN_SET3; DE_MORGAN_THM; aff_lt_def;FUN_EQ_THM; 
 affsign; lin_combo; sgn_lt] THEN 
REWRITE_TAC[SET_RULE` {v1, v2, v3} UNION {vv} = {v1, v2, v3, vv}`] THEN 
REWRITE_TAC[SET_RULE` a /\ (!w. {vv} w ==> f w < &0) /\ b
  <=> f vv < &0 /\ b /\ a `] THEN 
SIMP_TAC[THEOREM_RE_AFF_LT31; IN_ELIM_THM] THEN SET_TAC[]);;

let AFF_LT21 = prove(`! a b (v0:real^N). ~ ( a = v0 ) /\ ~( b = v0 ) ==>
aff_lt {a,b} {v0} =
          {x | ? ta tb t.
                   ta + tb + t = &1 /\
                   t < &0 /\
                   x = ta % a + tb % b + t % v0} `,
REWRITE_TAC[SET_RULE` ~(a = v0) /\ ~(b = v0) <=>
  ~ ( v0 IN {a,b} ) `] THEN 
ONCE_REWRITE_TAC[SET_RULE` {a,b} = {a,b,b} `] THEN SIMP_TAC[AFF_LT31] THEN 
SIMP_TAC[AFF_LT31; FUN_EQ_THM; IN_ELIM_THM] THEN 
REWRITE_TAC[VECTOR_ARITH` a % b + c % b + x = ( a + c ) % b + x `] THEN 
MESON_TAC[REAL_ARITH` a + b + c = ( a + b ) + c `;
VECTOR_ARITH ` a % v = ( a + &0 ) % v `; REAL_ARITH `
   a + b = a + &0 + b `]);;


let INSET3 = SET_RULE` a IN {a,b,c} /\ b IN {a,b,c} /\ c IN {a,b,c} `;;






let AFF_GT33 = prove(`! (v1:real^N) v2 v3 w1 w2 w3.
     {v1, v2, v3} INTER {w1, w2, w3} = {}
     ==> aff_gt {v1, v2, v3} {w1, w2, w3} =
         {x | ?a1 a2 a3 b1 b2 b3.
                  &0 < b1 /\
                  &0 < b2 /\
                  &0 < b3 /\
                  a1 + a2 + a3 + b1 + b2 + b3 = &1 /\
                  x =
                  a1 % v1 + a2 % v2 + a3 % v3 + b1 % w1 + b2 % w2 + b3 % w3}`,
REWRITE_TAC[aff_gt_def; FUN_EQ_THM; affsign; lin_combo; sgn_gt] THEN 
REPEAT STRIP_TAC THEN 
MATCH_MP_TAC EQ_TRANS  THEN 
REWRITE_TAC[SET_RULE ` ( a INSERT b ) UNION c =
   b UNION ( a INSERT c ) /\ {} UNION b = b `] THEN 
EXISTS_TAC ` (? f. x = vsum {v3, v2, v1, w1, w2, w3} (\v. f v % v) /\
           (!(w:real^N). w IN {v3,v2,v1, w1, w2, w3} ==> w IN {w1,w2,w3} ==>  &0 < f w) /\
           sum {v3, v2, v1, w1, w2, w3} f = &1 ) ` THEN 
REWRITE_TAC[SET_RULE` (!x. ({v1, v2, v3} INTER {w1, w2, w3}) x <=> {} x)
  <=> {v1, v2, v3} INTER {w1, w2, w3} = {} `] THEN 
CONJ_TAC THENL [ 
FIRST_X_ASSUM MP_TAC THEN 
REWRITE_TAC[SET_RULE` (!x. ({v1, v2, v3} INTER {w1, w2, w3}) x <=> {} x)
  <=> {v1, v2, v3} INTER {w1, w2, w3} = {} `] THEN 
MESON_TAC[SET_RULE` {v1, v2, v3} INTER {w1, w2, w3} = {} ==>
  ( (!w. {w1, w2, w3} w ==> &0 < f w) <=>
  (!w. w IN {v3, v2, v1, w1, w2, w3}
                ==> w IN {w1, w2, w3}
                ==> &0 < f w) ) `];
REWRITE_TAC[MESON[]` a /\ (!z. P z ) /\ aa = &1 <=>
  (!z. P z ) /\ aa = &1 /\ a `]] THEN 
ONCE_REWRITE_TAC[MESON[]` a = vsum b c <=> vsum b c = a `] THEN 
 SIMP_TAC[AFFINE_HULL_FINITE_STEP_GEN;FINITE_INSERT; CONJUNCT1 FINITE_RULES;
            RIGHT_EXISTS_AND_THM;
            REAL_ARITH `&0 < x /\ &0 < y ==> &0 < x + y`;
            REAL_ARITH `&0 < x  ==> &0 < x / &2 `] THEN 
FIRST_X_ASSUM MP_TAC THEN 
REWRITE_TAC[SET_RULE` (!x. ({v1, v2, v3} INTER {w1, w2, w3}) x <=> {} x)
  <=> {v1, v2, v3} INTER {w1, w2, w3} = {} `; SET_RULE` ( a INSERT s ) INTER ss = {} <=>
~ ( a IN ss ) /\ s INTER ss = {} `] THEN 
SIMP_TAC[INSET3] THEN 
SIMP_TAC[INSET3; REAL_ARITH` a - b = c <=> a = b + c `;
  VECTOR_ARITH` a:real^N - b = c <=> a = b + c `] THEN 
REWRITE_TAC[ GSYM  RIGHT_EXISTS_AND_THM; ZERO_NEUTRAL; 
 IN_ELIM_THM; VECTOR_ARITH ` a + vec 0 = a `] THEN 
DISCH_TAC THEN 
MESON_TAC[REAL_ARITH` a + b + c + d = c + b + a + d `;
  VECTOR_ARITH` ( a:real^N ) + b + c + d = c + b + a + d `]);;


g `! (v1:real^N) v2 v3 w1 w2 w3.
     {v1, v2, v3} INTER {w1, w2, w3} = {}
     ==> aff_ge {v1, v2, v3} {w1, w2, w3} =
         {x | ?a1 a2 a3 b1 b2 b3.
                  &0 <= b1 /\
                  &0 <= b2 /\
                  &0 <= b3 /\
                  a1 + a2 + a3 + b1 + b2 + b3 = &1 /\
                  x =
                  a1 % v1 + a2 % v2 + a3 % v3 + b1 % w1 + b2 % w2 + b3 % w3}`;;
e (REWRITE_TAC[aff_gt_def; aff_ge_def; FUN_EQ_THM; affsign; lin_combo; sgn_gt; sgn_ge]);;
e (REPEAT STRIP_TAC);;
e (MATCH_MP_TAC EQ_TRANS );;
e (REWRITE_TAC[SET_RULE ` ( a INSERT b ) UNION c =
   b UNION ( a INSERT c ) /\ {} UNION b = b `]);;
e (EXISTS_TAC ` (? f. x = vsum {v3, v2, v1, w1, w2, w3} (\v. f v % v) /\
           (!(w:real^N). w IN {v3,v2,v1, w1, w2, w3} ==> w IN {w1,w2,w3} ==>  &0 <= f w) /\
           sum {v3, v2, v1, w1, w2, w3} f = &1 ) `);;
e (CONJ_TAC);;
e (FIRST_X_ASSUM MP_TAC);;
e (REWRITE_TAC[SET_RULE` (!x. ({v1, v2, v3} INTER {w1, w2, w3}) x <=> {} x)
  <=> {v1, v2, v3} INTER {w1, w2, w3} = {} `]);;
e (MESON_TAC[SET_RULE` {v1, v2, v3} INTER {w1, w2, w3} = {} ==>
  ( (!w. {w1, w2, w3} w ==> &0 <= f w) <=>
  (!w. w IN {v3, v2, v1, w1, w2, w3}
                ==> w IN {w1, w2, w3}
                ==> &0 <= f w) ) `]);;
e (REWRITE_TAC[MESON[]` a /\ (!z. P z ) /\ aa = &1 <=>
  (!z. P z ) /\ aa = &1 /\ a `]);;
e (ONCE_REWRITE_TAC[MESON[]` a = vsum b c <=> vsum b c = a `]);;
e ( SIMP_TAC[AFFINE_HULL_FINITE_STEP_GEN;FINITE_INSERT; CONJUNCT1 FINITE_RULES;
            RIGHT_EXISTS_AND_THM;
            REAL_ARITH `&0 <= x /\ &0 <= y ==> &0 <= x + y`;
            REAL_ARITH `&0 <= x  ==> &0 <= x / &2 `]);;
e (FIRST_X_ASSUM MP_TAC);;
e (REWRITE_TAC[SET_RULE` (!x. ({v1, v2, v3} INTER {w1, w2, w3}) x <=> {} x)
  <=> {v1, v2, v3} INTER {w1, w2, w3} = {} `; SET_RULE` ( a INSERT s ) INTER ss = {} <=>
~ ( a IN ss ) /\ s INTER ss = {} `]);;
e (SIMP_TAC[INSET3]);;
e (SIMP_TAC[INSET3; REAL_ARITH` a - b = c <=> a = b + c `;
  VECTOR_ARITH` a:real^N - b = c <=> a = b + c `]);;
e (REWRITE_TAC[ GSYM  RIGHT_EXISTS_AND_THM; ZERO_NEUTRAL; 
 IN_ELIM_THM; VECTOR_ARITH ` a + vec 0 = a `]);;
e (DISCH_TAC);;
e (MESON_TAC[REAL_ARITH` a + b + c + d = c + b + a + d `;
  VECTOR_ARITH` ( a:real^N ) + b + c + d = c + b + a + d `]);;
let AFF_GE33 = top_thm();;


let AFF_GE_12 = prove(`!v0 (a:real^N) b.
     ~(v0 = a \/ v0 = b)
     ==> aff_ge {v0} {a, b} =
         {x | ?tv ta tb.
                  &0 <= ta /\
                  &0 <= tb /\
                  tv + ta + tb = &1 /\
                  x = tv % v0 + ta % a + tb % b}`,
REWRITE_TAC[SET_RULE ` ~(v0 = a \/ v0 = b) <=> {v0} INTER {a,b} = {} `] THEN 
ONCE_REWRITE_TAC[SET_RULE` {a} = {a,a} `] THEN 
ONCE_REWRITE_TAC[SET_RULE` {a,a} = {a,a,a} `] THEN 
ONCE_REWRITE_TAC[SET_RULE` {a,b,b,b} = {a,b,b} `] THEN 
SIMP_TAC[AFF_GE33] THEN REWRITE_TAC[FUN_EQ_THM; IN_ELIM_THM] THEN 
REPEAT STRIP_TAC THEN 
REWRITE_TAC[GSYM VECTOR_ADD_RDISTRIB; VECTOR_ARITH` a % v + 
  b % v + y = ( a + b ) % v + y `] THEN GONTONG THEN EQ_TAC THENL [
MESON_TAC[REAL_ARITH` a1 + a2 + a3 + b1 + b2 + b3 =
  ( a1 + a2 + a3 ) + b1 + b2 + b3 `; REAL_ARITH ` &0 <= a 
/\ &0 <= b ==> &0 <= a + b `];STRIP_TAC] THEN EXISTS_TAC` tv: real ` 
THEN EXISTS_TAC` &0 ` THEN EXISTS_TAC` &0` THEN EXISTS_TAC` ta :real `
 THEN EXISTS_TAC` &0` THEN EXISTS_TAC` tb:real ` THEN 
ASM_SIMP_TAC[REAL_ARITH ` a <= a `; ZERO_NEUTRAL]);;


let INSET3 = SET_RULE` a IN {a, b, c} /\ b IN {a, b, c} /\ c IN {a, b, c}
 /\ {a, b, c} a /\ {a, b, c} b /\ {a, b, c} c `;;



let AFF_LE_LT33 = prove(`! (v1:real^N) v2 v3 w1 w2 w3.
     {v1, v2, v3} INTER {w1, w2, w3} = {}
     ==> aff_le {v1, v2, v3} {w1, w2, w3} =
         {x | ?a1 a2 a3 b1 b2 b3.
                  b1 <= &0 /\
                  b2 <= &0  /\
                  b3 <= &0  /\
                  a1 + a2 + a3 + b1 + b2 + b3 = &1 /\
                  x =
                  a1 % v1 + a2 % v2 + a3 % v3 + b1 % w1 + b2 % w2 + b3 % w3} /\
   aff_lt {v1, v2, v3} {w1, w2, w3} =
         {x | ?a1 a2 a3 b1 b2 b3.
                  b1 < &0 /\
                  b2 < &0  /\
                  b3 < &0  /\
                  a1 + a2 + a3 + b1 + b2 + b3 = &1 /\
                  x =
                  a1 % v1 + a2 % v2 + a3 % v3 + b1 % w1 + b2 % w2 + b3 % w3} `,
REWRITE_TAC[IN_ELIM_THM; aff_le_def; FUN_EQ_THM; aff_lt_def; 
 affsign; lin_combo; sgn_lt; sgn_le] THEN 
REWRITE_TAC[SET_RULE` {v1, v2, v3} UNION {w1, w2, w3} = 
  {v1,v2,v3,w1,w2,w3} `] THEN 
ONCE_REWRITE_TAC[SET_RULE` {w1, w2, w3} w ==> P w <=>
  w IN {v1,v2,v3,w1,w2,w3} ==> {w1,w2,w3} w ==> P w `] THEN 
REWRITE_TAC[MESON[]` a = vsum aa bb /\
  (! w. P w ) /\ b <=> (! w. P w ) /\ b /\ vsum aa bb = a `] THEN 
 SIMP_TAC[AFFINE_HULL_FINITE_STEP_GEN;
            REAL_ARITH `( x < &0 /\ y < &0 ==> x + y < &0) /\ ( x <= &0 /\ y <= &0 ==> x + y <= &0)`;
            REAL_ARITH ` (x < &0 ==> x / &2 < &0 ) /\ (x <= &0 ==> x / &2 <= &0 )`;
            FINITE_INSERT; CONJUNCT1 FINITE_RULES
; RIGHT_EXISTS_AND_THM]  THEN 
SIMP_TAC[ GSYM RIGHT_EXISTS_AND_THM; SET_RULE ` 
  (!x. ({v1, v2, v3} INTER s ) x <=> {} x) <=>
  ~ ( s v1 ) /\ ~ ( s v2 ) /\ ~ ( s v3 ) `; INSET3] THEN 
REWRITE_TAC[REAL_ARITH` a - b = c <=> a = b + c`; REAL_ARITH `
  a + &0 = a `; VECTOR_ARITH` (a:real^N) - b = c <=> a = b + c`;
  VECTOR_ARITH` a + vec 0 = a `] THEN 
MESON_TAC[]);;




let AFF_GES_LTS = prove(` ! a b c (v0 :real^N). 
 ~ ( a = v0 ) /\ ~( b = v0 ) /\ ~( c = v0 ) ==>
aff_gt {a, b} {v0} =
          {x | ?ta tb t.
                   ta + tb + t = &1 /\ &0 < t /\ x = ta % a + tb % b + t % v0} /\
aff_ge {a, b} {v0} =
          {x | ?ta tb t.
                   ta + tb + t = &1 /\
                   &0 <= t /\
                   x = ta % a + tb % b + t % v0} /\
aff_lt {a,b,c} {v0} = 
   { x| ? ta tb tc t. t < &0 /\ ta + tb + tc + t = &1 /\
           x = ta % a + tb % b + tc % c + t % v0 }  /\
aff_gt {a,b,c} {v0} =  
   { x| ? ta tb tc t. &0 < t /\ ta + tb + tc + t = &1 /\
     x = ta % a + tb % b + tc % c + t % v0 } `, 
ONCE_REWRITE_TAC[SET_RULE` {a} = {a,a,a} `] THEN 
ONCE_REWRITE_TAC[SET_RULE` {a,b,b,b} = {a,b,b} `] THEN 
ONCE_REWRITE_TAC[SET_RULE` {a,b,c,c} = {a,b,c} `] THEN 
NHANH (SET_RULE` ~(a = v0) /\ ~(b = v0) /\ ~(c = v0) ==>
  {a,b,b} INTER {v0,v0,v0} = {} /\ {a,b,c} INTER {v0,v0,v0} = {} `) THEN 
SIMP_TAC[AFF_LE_LT33; AFF_GE33; AFF_GT33] THEN 
REWRITE_TAC[GSYM VECTOR_ADD_RDISTRIB; VECTOR_ARITH` a % x + b % x + y
  = ( a + b ) % x + y `] THEN 
REWRITE_TAC[REAL_ARITH` (a + b ) + c = a + b + c `] THEN 
REPEAT STRIP_TAC THENL [
REWRITE_TAC[FUN_EQ_THM; IN_ELIM_THM] THEN GEN_TAC THEN 
EQ_TAC THENL [MESON_TAC[REAL_ARITH ` &0 < a /\ &0 < b ==> &0 < a + b `;
  REAL_ARITH ` a + b + c + d = a + ( b + c ) + d `]; 
MESON_TAC[REAL_ARITH ` a + b + c = a + b / &2 + b / &2 + c / &3 +
  c / &3 + c / &3 `; REAL_ARITH` &0 < a <=> &0 < a / &3 `;
  REAL_ARITH` a = a / &2 + a / &2 /\ b = b / &3 + b / &3 + b / &3 /\ b =
 ( b / &3 + b / &3 ) + b / &3  `]];
REPEAT STRIP_TAC THEN 
REWRITE_TAC[FUN_EQ_THM; IN_ELIM_THM] THEN GEN_TAC THEN 
EQ_TAC THENL [
MESON_TAC[REAL_ARITH ` ( &0 < a /\ &0 < b ==> &0 < a + b ) /\ ( &0 <= a /\ &0 <= b ==> &0 <= a + b )  `;
  REAL_ARITH ` a + b + c + d = a + ( b + c ) + d `] ; 
MESON_TAC[REAL_ARITH ` a + b + c = a + b / &2 + b / &2 + c / &3 +
  c / &3 + c / &3 `; REAL_ARITH` ( &0 < a <=> &0 < a / &3) /\ ( &0 <= a <=> &0 <= a / &3) `;
  REAL_ARITH` a = a / &2 + a / &2 /\ b = b / &3 + b / &3 + b / &3 /\ b = ( b / &3 + b / &3 ) + b / &3  `]];
REPEAT STRIP_TAC THEN 
REWRITE_TAC[FUN_EQ_THM; IN_ELIM_THM] THEN GEN_TAC THEN 
EQ_TAC THENL [MESON_TAC[REAL_ARITH ` ( &0 < a /\ &0 < b ==> &0 < a + b ) 
/\ ( &0 <= a /\ &0 <= b ==> &0 <= a + b )  `; REAL_ARITH ` ( a < &0 /\ b < &0 
==> a + b < &0 )`; REAL_ARITH ` a + b + c + d = a + ( b + c ) + d `]; STRIP_TAC] THEN 
EXISTS_TAC `ta :real` THEN 
EXISTS_TAC `tb :real` THEN 
EXISTS_TAC `tc :real` THEN 
REPEAT (EXISTS_TAC ` t / &3 `) THEN 
ASM_MESON_TAC[REAL_ARITH` a < &0 <=> a / &3 < &0 `;
  REAL_ARITH ` a = a / &3 + a / &3 + a / &3 `];
REPEAT STRIP_TAC THEN 
REWRITE_TAC[FUN_EQ_THM; IN_ELIM_THM] THEN GEN_TAC THEN 
EQ_TAC THENL [MESON_TAC[REAL_ARITH ` ( &0 < a /\ &0 < b ==> &0 < a + b ) /\ ( &0 <= a /\ &0 <= b
 ==> &0 <= a + b )  `; REAL_ARITH ` ( a < &0 /\ b < &0 ==> a + b < &0 )`;
  REAL_ARITH ` a + b + c + d = a + ( b + c ) + d `]; STRIP_TAC] THEN 
EXISTS_TAC `ta :real` THEN 
EXISTS_TAC `tb :real` THEN 
EXISTS_TAC `tc :real` THEN 
REPEAT (EXISTS_TAC ` t / &3 `) THEN 
ASM_MESON_TAC[REAL_ARITH ` a = a / &3 + a / &3 + a / &3 `;
  REAL_ARITH ` &0 < a <=> &0 < a / &3 `]]);;


let AFF_GES_GTS = prove(` ! a b c (v0:real^N).
~(a = v0) /\ ~(b = v0) /\ ~(c = v0)
     ==> aff_gt {a, b} {v0} =
               {x | ?ta tb t.
                        ta + tb + t = &1 /\
                        &0 < t /\
                        x = ta % a + tb % b + t % v0} /\
               aff_ge {a, b} {v0} =
               {x | ?ta tb t.
                        ta + tb + t = &1 /\
                        &0 <= t /\
                        x = ta % a + tb % b + t % v0} /\
               aff_lt {a, b, c} {v0} =
               {x | ?ta tb tc t.
                        t < &0 /\
                        ta + tb + tc + t = &1 /\
                        x = ta % a + tb % b + tc % c + t % v0} /\
               aff_gt {a, b, c} {v0} =
               {x | ?ta tb tc t.
                        &0 < t /\
                        ta + tb + tc + t = &1 /\
                        x = ta % a + tb % b + tc % c + t % v0} /\
         aff_ge {a, b, c} {v0} =
         {x | ?ta tb tc t.
                  &0 <= t /\
                  ta + tb + tc + t = &1 /\
                  x = ta % a + tb % b + tc % c + t % v0} `,
REPEAT GEN_TAC THEN 
REWRITE_TAC[MESON[]` (a ==> a1 /\ a2 /\ a3 /\ a4 /\ a5) <=>
  ( a ==> a1 /\ a2 /\ a3 /\a4 ) /\ ( a ==> a5) `] THEN 
REWRITE_TAC[AFF_GES_LTS] THEN 
NHANH (SET_RULE` ~(a = v0) /\ ~(b = v0) /\ ~(c = v0) 
  ==> {a,b,c} INTER {v0,v0,v0} = {} `) THEN 
ONCE_REWRITE_TAC[SET_RULE` {v} = {v,v,v} `] THEN 
ONCE_REWRITE_TAC[SET_RULE` {a, b, c, c, c} = {a,b,c} `] THEN 
SIMP_TAC[AFF_GE33] THEN 
REPEAT STRIP_TAC THEN 
REWRITE_TAC[FUN_EQ_THM; IN_ELIM_THM; GSYM VECTOR_ADD_RDISTRIB] THEN 
GEN_TAC THEN EQ_TAC THENL [ 
MESON_TAC[REAL_ARITH` &0 <= a /\ &0 <= b ==> &0 <= a + b `]; 
STRIP_TAC THEN 
EXISTS_TAC ` ta :real` THEN 
EXISTS_TAC ` tb :real` THEN 
EXISTS_TAC ` tc :real` THEN 
REPEAT ( EXISTS_TAC ` t / &3 `) THEN 
ASM_MESON_TAC[REAL_ARITH` a = a / &3 + a / &3 + a / &3 `;
  REAL_ARITH` &0 <= a <=> &0 <= a / &3 `]]);;


let COEF_1_POS_NEG = prove(` ! v1 v2 v3 v4 (v:real^3).
  ~ coplanar {v1,v2,v3,v4} ==>
  ( COEF4_1 v1 v2 v3 v4 v > &0 <=> v IN aff_gt {v2,v3,v4} {v1} ) /\
( COEF4_1 v1 v2 v3 v4 v < &0 <=> v IN aff_lt {v2,v3, v4} {v1} ) `,
NHANH (MESON[EQ_IMP_COPLANAR]`~coplanar {v1, v2, v3, v4} ==>
  ~ ( v2 = v1 ) /\ ~ ((v3:real^3) = v1 ) /\ ~ (v4 = v1 ) `) THEN 
SIMP_TAC[AFF_GES_LTS] THEN NHANH (SPEC_ALL COEFS_4) THEN 
REWRITE_TAC[IN_ELIM_THM; REAL_ARITH ` a > b <=> b < a `] THEN
REPEAT GEN_TAC THEN STRIP_TAC THEN 
ONCE_REWRITE_TAC[REAL_ARITH ` a + b + c + t = t + a + b + c `] THEN 
ONCE_REWRITE_TAC[VECTOR_ARITH ` (a:real^N) + b + c + t = t + a + b + c `] THEN 
ASM_MESON_TAC[]);;


let ALL_ABOUT_COEF_1 = prove(` ! v1 v2 v3 v4 (v:real^3).
  ~ coplanar {v1,v2,v3,v4} ==>
  ( COEF4_1 v1 v2 v3 v4 v < &0 <=> v IN aff_lt {v2,v3, v4} {v1} ) /\
  ( COEF4_1 v1 v2 v3 v4 v = &0 <=> v IN aff {v2,v3,v4} ) /\
  ( COEF4_1 v1 v2 v3 v4 v > &0 <=> v IN aff_gt {v2,v3,v4} {v1} )`,
SIMP_TAC[COEF_1_EQ_ZERO ; COEF_1_POS_NEG ]);;

let PER_COEF1_WITH_COEF2 = prove(`! v1 v2 v3 v4 (v:real^3).
 ~coplanar {v1, v2, v3, v4} ==>
   COEF4_2 v1 v2 v3 v4 v = COEF4_1 v2 v3 v4 v1 v `,
NHANH (SPEC_ALL COEFS_4) THEN 
REPEAT GEN_TAC THEN STRIP_TAC THEN 
MP_TAC (SPECL [` v2:real^3 `; `v3:real^3`; `v4:real^3`; ` v1:real^3`;
 `v:real^3 `] COEFS_4) THEN 
UNDISCH_TAC ` ~coplanar {v1, v2, v3, (v4:real^3)}` THEN 
IMP_IMP_TAC THEN 
REWRITE_TAC[MESON[SET_RULE` {v1, v2, v3, v4} = {v2, v3, v4, v1}`]`
  ~coplanar {v1, v2, v3, v4} /\
 (~coplanar {v2, v3, v4, v1} ==> l ) <=> ~coplanar {v1, v2, v3, v4}
  /\ l `] THEN 
ONCE_REWRITE_TAC[GSYM (REAL_ARITH` a + b + c + d = b + c + d + a `)] THEN 
ONCE_REWRITE_TAC[GSYM (VECTOR_ARITH` (a:real^N) + b + c + d = b + c + d + a `)] THEN 
ASM_MESON_TAC[]);;

let PER_COEF1_WITH_COEF3 = prove(`! v1 v2 v3 v4 (v:real^3).
 ~coplanar {v1, v2, v3, v4} ==>
   COEF4_3 v1 v2 v3 v4 v = COEF4_1 v3 v4 v1 v2 v `,
NHANH (SPEC_ALL COEFS_4) THEN 
REPEAT GEN_TAC THEN STRIP_TAC THEN 
MP_TAC (SPECL [`v3:real^3`; `v4:real^3`; ` v1:real^3`; ` v2:real^3`;
 `v:real^3 `] COEFS_4) THEN 
UNDISCH_TAC ` ~coplanar {v1, v2, v3, (v4:real^3)}` THEN 
IMP_IMP_TAC THEN 
REWRITE_TAC[MESON[SET_RULE` {v1, v2, v3, v4} = {v3, v4, v1, v2}`]`
  ~coplanar {v1, v2, v3, v4} /\
 (~coplanar {v3, v4, v1, v2} ==> l ) <=> ~coplanar {v1, v2, v3, v4}
  /\ l `] THEN 
ONCE_REWRITE_TAC[GSYM (REAL_ARITH` a + b + c + d = c + d + a + b`)] THEN 
ONCE_REWRITE_TAC[GSYM (VECTOR_ARITH` (a:real^N) + b + c + d = c + d + a + b`)]
 THEN ASM_MESON_TAC[]);;

let PER_COEF1_WITH_COEF4 = prove(`! v1 v2 v3 v4 (v:real^3).
 ~coplanar {v1, v2, v3, v4} ==>
   COEF4_4 v1 v2 v3 v4 v = COEF4_1 v4 v1 v2 v3 v `,
NHANH (SPEC_ALL COEFS_4) THEN 
REPEAT GEN_TAC THEN 
ONCE_REWRITE_TAC[SET_RULE` {v1, v2, v3, v4} = {v4,v1, v2, v3}`] THEN 
NHANH (SPEC_ALL COEFS_4) THEN 
MESON_TAC[REAL_ARITH` ta + tb + tc + td = td + ta + tb + tc`;
  VECTOR_ARITH` ta + tb + tc + td = td + ta + tb + (tc:real^N)`]);;

let ALL_ABOUT_COEF_2 = prove(` ! v1 v2 v3 v4 (v:real^3).
  ~ coplanar {v1,v2,v3,v4} ==>
  ( COEF4_2 v1 v2 v3 v4 v < &0 <=> v IN aff_lt {v1,v3, v4} {v2} ) /\
  ( COEF4_2 v1 v2 v3 v4 v = &0 <=> v IN aff {v1,v3,v4} ) /\
  ( COEF4_2 v1 v2 v3 v4 v > &0 <=> v IN aff_gt {v1,v3,v4} {v2} )`,
SIMP_TAC[PER_COEF1_WITH_COEF2] THEN MP_TAC ALL_ABOUT_COEF_1 THEN 
MESON_TAC[SET_RULE` {v1, v2, v3, v4} = {v2, v3, v4, v1}`;
SET_RULE` {v1, v2, v3} = {v2, v3,v1}`]);;




let ALL_ABOUT_COEF_3 = prove(` ! v1 v2 v3 v4 (v:real^3).
  ~ coplanar {v1,v2,v3,v4} ==>
  ( COEF4_3 v1 v2 v3 v4 v < &0 <=> v IN aff_lt {v2,v1, v4} {v3} ) /\
  ( COEF4_3 v1 v2 v3 v4 v = &0 <=> v IN aff {v2,v1,v4} ) /\
  ( COEF4_3 v1 v2 v3 v4 v > &0 <=> v IN aff_gt {v2,v1,v4} {v3} ) `,
SIMP_TAC[PER_COEF1_WITH_COEF3] THEN 
ONCE_REWRITE_TAC[SET_RULE` {v2, v1, v4} = {v4,v1,v2} `] THEN 
ONCE_REWRITE_TAC[SET_RULE` {v1, v4, v3, v2} = {v3,v4,v1,v2} `] THEN 
SIMP_TAC[ALL_ABOUT_COEF_1]);;

let SRGTIHY = prove(` ! v1 v2 v3 v4 (v:real^3).
  ~ coplanar {v1,v2,v3,v4} ==>
  ( COEF4_1 v1 v2 v3 v4 v < &0 <=> v IN aff_lt {v2,v3, v4} {v1} ) /\
  ( COEF4_1 v1 v2 v3 v4 v = &0 <=> v IN aff {v2,v3,v4} ) /\
  ( COEF4_1 v1 v2 v3 v4 v > &0 <=> v IN aff_gt {v2,v3,v4} {v1} ) /\
  ( COEF4_2 v1 v2 v3 v4 v < &0 <=> v IN aff_lt {v1,v3, v4} {v2} ) /\
  ( COEF4_2 v1 v2 v3 v4 v = &0 <=> v IN aff {v1,v3,v4} ) /\
  ( COEF4_2 v1 v2 v3 v4 v > &0 <=> v IN aff_gt {v1,v3,v4} {v2} ) /\  
  ( COEF4_3 v1 v2 v3 v4 v < &0 <=> v IN aff_lt {v2,v1, v4} {v3} ) /\
  ( COEF4_3 v1 v2 v3 v4 v = &0 <=> v IN aff {v2,v1,v4} ) /\
  ( COEF4_3 v1 v2 v3 v4 v > &0 <=> v IN aff_gt {v2,v1,v4} {v3} )/\  
  ( COEF4_4 v1 v2 v3 v4 v < &0 <=> v IN aff_lt {v2,v1, v3} {v4} ) /\
  ( COEF4_4 v1 v2 v3 v4 v = &0 <=> v IN aff {v2,v1,v3} ) /\
  ( COEF4_4 v1 v2 v3 v4 v > &0 <=> v IN aff_gt {v2,v1,v3} {v4} )`,
SIMP_TAC[ALL_ABOUT_COEF_1; ALL_ABOUT_COEF_2; ALL_ABOUT_COEF_3;
  PER_COEF1_WITH_COEF4] THEN 
ONCE_REWRITE_TAC[SET_RULE` {v2, v1, v3} = {v1,v2,v3}`] THEN 
ONCE_REWRITE_TAC[SET_RULE` {v1, v3, v2, v4} = {v4,v1,v2,v3}`] THEN 
SIMP_TAC[ALL_ABOUT_COEF_1]);;
let LEMMA77 = SRGTIHY;;


 let CONV0_4 = prove
  (`conv0 {v1, v2, v3, v4} =
         {x:real^N | ?a b c d.
         &0 < a /\
         &0 < b /\
         &0 < c /\
         &0 < d /\
         a + b + c + d = &1 /\
         a % v1 + b % v2 + c % v3 + d % v4 = x}`,
   REWRITE_TAC[FUN_EQ_THM; IN_ELIM_THM] THEN X_GEN_TAC `y:real^N` THEN
   REWRITE_TAC[conv0; affsign; sgn_gt; lin_combo; UNION_EMPTY] THEN
   MATCH_MP_TAC EQ_TRANS THEN
   EXISTS_TAC
    `?f. (!w:real^N. w IN {v1, v2, v3, v4} ==> &0 < f w) /\
         sum {v1, v2, v3, v4} f = &1 /\
         vsum {v1, v2, v3, v4} (\v. f v % v) = y` THEN
   CONJ_TAC THENL [REWRITE_TAC[IN] THEN MESON_TAC[]; ALL_TAC] THEN
   SIMP_TAC[AFFINE_HULL_FINITE_STEP_GEN;
            REAL_ARITH `&0 < x /\ &0 < y ==> &0 < x + y`;
            REAL_ARITH `&0 < x ==> &0 < x / &2`;
            FINITE_INSERT; CONJUNCT1 FINITE_RULES; RIGHT_EXISTS_AND_THM] THEN
   ASM_REWRITE_TAC[IN_ELIM_THM;
                   REAL_ARITH `x - y:real = z <=> x = y + z`;
                   VECTOR_ARITH `x - y:real^N = z <=> x = y + z`] THEN
   REWRITE_TAC[VECTOR_ADD_RID; REAL_ADD_RID] THEN MESON_TAC[]);;

(* ======================= *)
(* LEMMA 81 *)
(* ======================= *)

let ARIKWRQ = prove(`! v1 v2 v3 (v4:real^3).
  let s = {v1,v2,v3,v4} in
  CARD s = 4 /\ ~ coplanar s ==>
  conv s = aff_ge ( s DIFF {v1} ) {v1} INTER 
  aff_ge ( s DIFF {v2} ) {v2} INTER 
  aff_ge ( s DIFF {v3} ) {v3} INTER 
  aff_ge ( s DIFF {v4} ) {v4} `, LET_TR THEN 
SIMP_TAC[CARD4; SET_RULE ` ~(v1 IN {v2, v3, v4}) /\ ~(v2 = v3 \/ v3 = v4 \/ v4 = v2)
  ==> {v1, v2, v3, v4} DIFF {v1} = {v2,v3,v4} /\
  {v1, v2, v3, v4} DIFF {v2} = {v3,v4,v1} /\
  {v1, v2, v3, v4} DIFF {v3} = {v4,v1,v2} /\
  {v1, v2, v3, v4} DIFF {v4} = {v1,v2,v3} `] THEN 
REWRITE_TAC[CARD4; IN_SET3;DE_MORGAN_THM] THEN 
SIMP_TAC[AFF_GES_GTS] THEN 
REWRITE_TAC[CONVEX_HULL_4_EQUIV] THEN 
REPEAT STRIP_TAC THEN 
REWRITE_TAC[SET_RULE ` a = b <=> (! x. x IN a <=> x IN b ) `;
  IN_INTER; IN_ELIM_THM] THEN 
GEN_TAC THEN EQ_TAC THENL [
ASM_MESON_TAC[REAL_ARITH` a + b + c + d = d + a + b + c `;
  VECTOR_ARITH` (a:real^N) + b + c + d = d + a + b + c `];
FIRST_X_ASSUM MP_TAC ] THEN
NHANH (SPEC ` x: real^3` (GEN ` v:real^3` (SPEC_ALL COEFS_4))) THEN 
ABBREV_TAC ` aa = COEF4_1 v1 v2 v3 v4 x ` THEN 
ABBREV_TAC ` bb = COEF4_2 v1 v2 v3 v4 x ` THEN 
ABBREV_TAC ` cc = COEF4_3 v1 v2 v3 v4 x ` THEN 
ABBREV_TAC ` dd = COEF4_4 v1 v2 v3 v4 x ` THEN 
REWRITE_TAC[MESON[]` a ==> b ==> c <=> a /\ b ==> c `] THEN PHA THEN 
NHANH (MESON[REAL_ARITH` a + b + c + d = d + a + b + c `;
  VECTOR_ARITH` (a:real^N) + b + c + d = d + a + b + c `]`
aa + bb + cc + dd = &1 /\
 x = aa % v1 + bb % v2 + cc % v3 + dd % v4 /\
 (!ta tb tc td.
      x = ta % v1 + tb % v2 + tc % v3 + td % v4 /\ ta + tb + tc + td = &1
      ==> ta = aa /\ tb = bb /\ tc = cc /\ td = dd) /\
 (?ta tb tc t.
      &0 <= t /\
      ta + tb + tc + t = &1 /\
      x = ta % v2 + tb % v3 + tc % v4 + t % v1) /\
 (?ta tb tc t.
      &0 <= t /\
      ta + tb + tc + t = &1 /\
      x = ta % v3 + tb % v4 + tc % v1 + t % v2) /\
 (?ta tb tc t.
      &0 <= t /\
      ta + tb + tc + t = &1 /\
      x = ta % v4 + tb % v1 + tc % v2 + t % v3) /\
 (?ta tb tc t.
      &0 <= t /\
      ta + tb + tc + t = &1 /\
      x = ta % v1 + tb % v2 + tc % v3 + t % v4)
 ==> &0 <= aa /\ &0 <= bb /\ &0 <= cc /\ &0 <= dd`) THEN 
MATCH_MP_TAC (MESON[]` ( a1 /\ a2 /\ a3 ==> l) ==>
  aa /\ ( a1 /\ a2 /\ a4 ) /\ a3 ==> l `) THEN MESON_TAC[]);;





(* ================ *)
(* LEMMA 82 *)
(* ================= *)




let MXHKOXR = prove(`! v1 v2 v3 (v4:real^3). let s = {v1,v2,v3,v4} in
  CARD s = 4 /\ ~ coplanar s ==>
  conv0 s = aff_gt ( s DIFF {v1} ) {v1} INTER 
  aff_gt ( s DIFF {v2} ) {v2} INTER 
  aff_gt ( s DIFF {v3} ) {v3} INTER 
  aff_gt ( s DIFF {v4} ) {v4} `, LET_TR THEN 
SIMP_TAC[CARD4; SET_RULE ` ~(v1 IN {v2, v3, v4}) /\ ~(v2 = v3 \/ v3 = v4 \/ v4 = v2)
  ==> {v1, v2, v3, v4} DIFF {v1} = {v2,v3,v4} /\
  {v1, v2, v3, v4} DIFF {v2} = {v3,v4,v1} /\
  {v1, v2, v3, v4} DIFF {v3} = {v4,v1,v2} /\
  {v1, v2, v3, v4} DIFF {v4} = {v1,v2,v3} `] THEN 
REWRITE_TAC[CARD4; IN_SET3;DE_MORGAN_THM] THEN 
SIMP_TAC[AFF_GES_GTS; CONV0_4 ] THEN 
REPEAT STRIP_TAC THEN 
REWRITE_TAC[SET_RULE ` a = b <=> (! x. x IN a <=> x IN b ) `;
  IN_INTER; IN_ELIM_THM] THEN 
GEN_TAC THEN EQ_TAC THENL [
ASM_MESON_TAC[REAL_ARITH` a + b + c + d = d + a + b + c `;
  VECTOR_ARITH` (a:real^N) + b + c + d = d + a + b + c `];
FIRST_X_ASSUM MP_TAC ] THEN
NHANH (SPEC ` x: real^3` (GEN ` v:real^3` (SPEC_ALL COEFS_4))) THEN 
ABBREV_TAC ` aa = COEF4_1 v1 v2 v3 v4 x ` THEN 
ABBREV_TAC ` bb = COEF4_2 v1 v2 v3 v4 x ` THEN 
ABBREV_TAC ` cc = COEF4_3 v1 v2 v3 v4 x ` THEN 
ABBREV_TAC ` dd = COEF4_4 v1 v2 v3 v4 x ` THEN 
REWRITE_TAC[MESON[]` a ==> b ==> c <=> a /\ b ==> c `] THEN PHA THEN 
NHANH (MESON[REAL_ARITH` a + b + c + d = d + a + b + c `;
  VECTOR_ARITH` (a:real^N) + b + c + d = d + a + b + c `]`
aa + bb + cc + dd = &1 /\
 x = aa % v1 + bb % v2 + cc % v3 + dd % v4 /\
 (!ta tb tc td.
      x = ta % v1 + tb % v2 + tc % v3 + td % v4 /\ ta + tb + tc + td = &1
      ==> ta = aa /\ tb = bb /\ tc = cc /\ td = dd) /\
 (?ta tb tc t.
      &0 < t /\
      ta + tb + tc + t = &1 /\
      x = ta % v2 + tb % v3 + tc % v4 + t % v1) /\
 (?ta tb tc t.
      &0 < t /\
      ta + tb + tc + t = &1 /\
      x = ta % v3 + tb % v4 + tc % v1 + t % v2) /\
 (?ta tb tc t.
      &0 < t /\
      ta + tb + tc + t = &1 /\
      x = ta % v4 + tb % v1 + tc % v2 + t % v3) /\
 (?ta tb tc t.
      &0 < t /\
      ta + tb + tc + t = &1 /\
      x = ta % v1 + tb % v2 + tc % v3 + t % v4)
==> &0 < aa /\ &0 < bb /\ &0 < cc /\ &0 < dd `) THEN 
MATCH_MP_TAC (MESON[]` ( a1 /\ a2 /\ a3 ==> l) ==>
  aa /\ ( a1 /\ a2 /\ a4 ) /\ a3 ==> l `) THEN MESON_TAC[]);;


 let CONV0_4 = prove
  (`conv0 {v1, v2, v3, v4} =
         {x:real^N | ?a b c d.
         &0 < a /\
         &0 < b /\
         &0 < c /\
         &0 < d /\
         a + b + c + d = &1 /\
         a % v1 + b % v2 + c % v3 + d % v4 = x}`,
   REWRITE_TAC[FUN_EQ_THM; IN_ELIM_THM] THEN X_GEN_TAC `y:real^N` THEN
   REWRITE_TAC[conv0; affsign; sgn_gt; lin_combo; UNION_EMPTY] THEN
   MATCH_MP_TAC EQ_TRANS THEN
   EXISTS_TAC
    `?f. (!w:real^N. w IN {v1, v2, v3, v4} ==> &0 < f w) /\
         sum {v1, v2, v3, v4} f = &1 /\
         vsum {v1, v2, v3, v4} (\v. f v % v) = y` THEN
   CONJ_TAC THENL [REWRITE_TAC[IN] THEN MESON_TAC[]; ALL_TAC] THEN
   SIMP_TAC[AFFINE_HULL_FINITE_STEP_GEN;
            REAL_ARITH `&0 < x /\ &0 < y ==> &0 < x + y`;
            REAL_ARITH `&0 < x ==> &0 < x / &2`;
            FINITE_INSERT; CONJUNCT1 FINITE_RULES; RIGHT_EXISTS_AND_THM] THEN
   ASM_REWRITE_TAC[IN_ELIM_THM;
                   REAL_ARITH `x - y:real = z <=> x = y + z`;
                   VECTOR_ARITH `x - y:real^N = z <=> x = y + z`] THEN
   REWRITE_TAC[VECTOR_ADD_RID; REAL_ADD_RID] THEN MESON_TAC[]);;


let CONV0_4POINTS = CONV0_4;;



(* ================== *)
(* LEMMA 78 *)

(* ================== *)


let ZRFMKPY = prove(` ! v1 v2 v3 v4 (v:real^3).
  ~coplanar {v1, v2, v3, v4}
         ==> (v IN conv {v1, v2, v3, v4} <=>
              &0 <= COEF4_1 v1 v2 v3 v4 v /\
              &0 <= COEF4_2 v1 v2 v3 v4 v /\
              &0 <= COEF4_3 v1 v2 v3 v4 v /\
              &0 <= COEF4_4 v1 v2 v3 v4 v) /\
             (v IN conv0 {v1, v2, v3, v4} <=>
              &0 < COEF4_1 v1 v2 v3 v4 v /\
              &0 < COEF4_2 v1 v2 v3 v4 v /\
              &0 < COEF4_3 v1 v2 v3 v4 v /\
              &0 < COEF4_4 v1 v2 v3 v4 v) `,
NHANH (SPEC_ALL COEFS_4) THEN REWRITE_TAC[CONVEX_HULL_4_EQUIV; 
CONV0_4POINTS; IN_ELIM_THM] THEN MESON_TAC[]);;

let LEMMA78 = ZRFMKPY;;



(* APRIL WORKS *)
(* =========== *)
(* NGUYEN QUANG TRUONG *)
let IMP_TAC = IMP_IMP_TAC;;



let QUAANG_TRUOONN = prove(` ! v0 v1 v2 v3 (v4:real^N).
   CARD {v0, v1, v2, v3, v4} = 5 /\
         (?x. ~(x = v0) /\ x IN cone v0 {v1, v3} INTER cone v0 {v2, v4})
         ==> ~(conv {v1, v3} INTER cone v0 {v2, v4} = {})`,
REWRITE_TAC[CONV_SET2; cone; CARD5; SET_RULE ` a INTER b = {} <=> 
  ~ (? x. a x /\ b x ) `; GSYM aff_ge_def; IN; IN_INTER] THEN 
NHANH (SET_RULE ` ~{v1, v2, v3, v4} v0 ==>
  ~ ( v0 = v1 \/ v0 = v3 ) /\ ~ ( v0 = v2 \/ v0 = v4 ) `) THEN 
ONCE_REWRITE_TAC[MESON[]` a /\ b ==> c <=> a ==> b ==> c `] THEN 
SIMP_TAC[AFF_GE_12] THEN REWRITE_TAC[DE_MORGAN_THM] THEN 
REWRITE_TAC[IN_ELIM_THM] THEN REPEAT STRIP_TAC THEN 
UNDISCH_TAC ` (x:real^N) = tv % v0 + ta % v1 + tb % v3` THEN 
UNDISCH_TAC ` (x:real^N) = tv' % v0 + ta' % v2 + tb' % v4` THEN 
REWRITE_TAC[MESON[]` x = a 
 ==> x = (b:real^N) ==> c <=> x = a /\ a = b ==> c `] THEN 
REWRITE_TAC[VECTOR_ARITH` a % v + d = b % v + e <=>
  ( a - b ) % v + d = e `] THEN 
ASM_CASES_TAC ` &0 < ta + tb ` THENL [DOWN_TAC THEN 
REWRITE_TAC[MESON[VECTOR_MUL_LCANCEL; REAL_FIELD ` &0 < a ==> ~ ( &1 / a = &0 )`]`
  &0 < ta + tb /\ aaa /\
 aa = ta % v1 + tb % v3 <=> &0 < ta + tb /\ aaa /\
  &1 / ( ta + tb ) % aa = &1 / ( ta + tb ) % ( ta % v1 + tb % v3) `] THEN 
REWRITE_TAC[VECTOR_ADD_LDISTRIB; VECTOR_MUL_ASSOC; REAL_ARITH `
  &1 / a * b = b / a `] THEN STRIP_TAC THEN DOWN_TAC THEN 
NHANH (MESON[REAL_LE_RDIV_0]`&0 <= ta /\ &0 <= tb /\ a1 /\ &0 <= ta' /\
 &0 <= tb' /\ a2 /\
 &0 < ta + tb /\ a3 ==> &0 <= ta / (ta + tb) /\ &0 <= tb / (ta + tb) /\
  &0 <= ta' / (ta + tb) /\ &0 <= tb' / (ta + tb) `) THEN ASM_MESON_TAC[
REAL_FIELD` tv + ta + tb = &1 /\ tv' + ta' + tb' = &1 /\
  &0 < ta + tb ==> (tv' - tv) / (ta + tb) + ta' / (ta + tb) +
  tb' / (ta + tb) = &1 /\ ta / ( ta + tb ) + tb / ( ta + tb ) = &1`];
DOWN_TAC THEN 
NHANH (MESON[REAL_ARITH` &0 <= a /\ &0 <= b /\ ~( &0 < a + b ) 
==> a = &0 /\ b = &0 `]`&0 <= ta /\ &0 <= tb /\a1/\a2 /\a3/\a4 /\
 ~(&0 < ta + tb) /\ a5 ==> ta = &0 /\ tb = &0`) THEN 
PURE_ONCE_REWRITE_TAC[MESON[]` P ta tb /\ ta = &0 /\ tb = &0 
  <=> P ( &0 ) ( &0 ) /\ ta = &0 /\ tb = &0 `] THEN 
REWRITE_TAC[ZERO_NEUTRAL; VECTOR_MUL_LZERO; VECTOR_ADD_LID] THEN 
REWRITE_TAC[VECTOR_ARITH` (tv' - tv) % v + a = vec 0 <=> tv' % v + a
  = tv % v `; MESON[]` a = b /\ b = c <=> a = c /\ b = c `] THEN 
MESON_TAC[VECTOR_ARITH ` &1 % v = v `]]);;

(* le 80. p 51 *)
(* ================ *)

let JVDAFRS = prove(` ! v0 v1 v2 v3 (v4:real^N).
   CARD {v0, v1, v2, v3, v4} = 5 /\
         (?x. ~(x = v0) /\ x IN cone v0 {v1, v3} INTER cone v0 {v2, v4})
         ==> ~(conv {v1, v3} INTER cone v0 {v2, v4} = {} /\
               conv {v2, v4} INTER cone v0 {v1, v3} = {})`, MESON_TAC[QUAANG_TRUOONN]);;

(* LEMMA 22 *)
(* =========================== *)

let SQRT8_POS = MESON[REAL_ARITH ` &0 < &8 `; SQRT_POS_LT]` &0 < sqrt (&8) `;;

let SQRT8_LT_4_45 = prove(` sqrt8 < #4.45 `,
SIMP_TAC[sqrt8; REAL_ARITH ` &0 < #4.45 `; MESON[REAL_ARITH ` &0 < &8 `; 
SQRT_POS_LT]` &0 < sqrt (&8) `; LT_POW2_EQ_LT; SQRT8_POW2] THEN REAL_ARITH_TAC);;


let PROVE_NOT_COLLINEAR = prove(` ! v0 v1 (v2:real^3).
         &2 <= d3 v0 v1 /\
         d3 v0 v1 <= #2.51 /\
         #2.45 <= d3 v1 v2 /\
         d3 v1 v2 <= #2.51 /\
         #2.77 <= d3 v0 v2 /\
         d3 v0 v2 <= sqrt8
         ==> ~ collinear {v0, v1, v2}`,
REWRITE_TAC[COLLINEAR_AS_IN_CONV2; MID_COND; d3; LENGTH_EQ_EX; DE_MORGAN_THM] THEN 
SIMP_TAC[DIST_SYM] THEN 
REPEAT GEN_TAC THEN 
ABBREV_TAC ` a = dist(v0,v1:real^3)` THEN 
ABBREV_TAC ` b = dist(v0,v2:real^3)` THEN 
ABBREV_TAC ` c = dist(v1,v2:real^3)` THEN 
MP_TAC SQRT8_LT_4_45  THEN 
REAL_ARITH_TAC);;



let BPOW8APOW2CPOW2 = prove(`&2 <= a /\
 a <= #2.51 /\
 #2.45 <= c /\
 c <= #2.51 /\
 #2.77 <= b /\
 b <= sqrt8
==> b pow 2 <= &8 /\ a pow 2 <= #2.51 pow 2 /\ c pow 2 <= #2.51 pow 2 `,
REWRITE_TAC[MESON[]` a1 /\ a2 /\a3 /\a4 /\a5 /\a6 ==> l <=>
  a1 /\a3 /\a5 ==> a2 /\a4 /\a6 ==> l `] THEN 
NHANH (REAL_ARITH`&2 <= a /\ #2.45 <= c /\ #2.77 <= b ==>
 &0 < a /\ &0 < b /\ &0 < c /\ &0 < #2.51 `) THEN 
SIMP_TAC[sqrt8; POW2_COND_LT; SQRT8_POS; SQRT8_POW2]);;


let IMP_PRE_LE_19 = prove(`&2 <= a /\
 a <= #2.51 /\
 #2.45 <= c /\
 c <= #2.51 /\
 #2.77 <= b /\
 b <= sqrt8
 ==> &0 < &2 /\
     &2 <= a /\
     &0 < #2.77 /\
     #2.77 <= b /\
     &0 < #2.45 /\
     #2.45 <= c /\
     a pow 2 <= #2.77 pow 2 + #2.45 pow 2 /\
     b pow 2 <= &2 pow 2 + #2.45 pow 2 /\
     c pow 2 <= &2 pow 2 + #2.77 pow 2 `,
CONV_TAC REAL_RAT_REDUCE_CONV THEN NHANH (BPOW8APOW2CPOW2 ) THEN REAL_ARITH_TAC);;



let ZEDIDCF = prove(` ! v0 v1 (v2:real^3).
         &2 <= d3 v0 v1 /\
         d3 v0 v1 <= #2.51 /\
         #2.45 <= d3 v1 v2 /\
         d3 v1 v2 <= #2.51 /\
         #2.77 <= d3 v0 v2 /\
         d3 v0 v2 <= sqrt8
         ==> sqrt2 < radV {v0, v1, v2}`,
NHANH (SPEC_ALL PROVE_NOT_COLLINEAR) THEN 
SIMP_TAC[RADV_FORMULAR] THEN REPEAT GEN_TAC THEN 
SIMP_TAC[d3; DIST_SYM] THEN 
ABBREV_TAC ` a = dist(v0,v1:real^3)` THEN 
ABBREV_TAC ` b = dist(v0,v2:real^3)` THEN 
ABBREV_TAC ` c = dist(v1,v2:real^3)` THEN 
NHANH (IMP_PRE_LE_19 ) THEN NHANH (SPEC_ALL BYOWBDF) THEN 
SIMP_TAC[ETA_Y_SYYM] THEN STRIP_TAC THEN 
UNDISCH_TAC ` eta_y #2.77 #2.45 (&2) <= eta_y a b c ` THEN 
ABBREV_TAC ` l = eta_y a b c ` THEN 
REWRITE_TAC[eta_y; eta_x; ups_x; sqrt2] THEN LET_TR THEN 
CONV_TAC REAL_RAT_REDUCE_CONV THEN 
MP_TAC (prove(`  sqrt (&2) < sqrt (&93993025 / &46231104) `,
SIMP_TAC[SQRT_WORKS; REAL_ARITH ` &0 <= &2 /\
  &0 <= &93993025 / &46231104 `; LT_POW2_COND] THEN REAL_ARITH_TAC)) 
THEN REAL_ARITH_TAC);;


(* ==================== *)

let condC = new_definition ` condC M13 m12 m14 M24 m34 (m23:real) =
  ((! x. x IN {M13, m12, m14, M24, m34, m23 } ==> &0 <= x ) /\
  M13 <= m12 + m23 /\
  M13 <= m14 + m34 /\ 
  M24 < m12 + m14 /\
  M24 < m23 + m34 /\ 
  &0 <= delta (M13 pow 2) (m12 pow 2) (m14 pow 2) (M24 pow 2) (m34 pow 2 )
   (m23 pow 2 ) )`;;


let CXWOCGN = new_axiom` !M13 m12 m14 M24 m34 m23 (v1:real^3) v2 v3 v4.
         condC M13 m12 m14 M24 m34 m23 /\
  CARD {v1,v2,v3,v4} = 4 /\
  m12 <= d3 v1 v2 /\ 
  m23 <= d3 v2 v3 /\
  m34 <= d3 v3 v4 /\ 
  m14 <= d3 v1 v4 /\ 
  d3 v1 v3 < M13 /\
  d3 v2 v4 <= M24 ==>
  conv {v1,v3} INTER conv {v2,v4} = {} `;;
SPECL [` sqrt (&8 ) `; ` &2 `; ` &2 `; ` sqrt (&8) `; ` &2 `;
  ` &2 `; ` u :real^3 `; ` w : real^3 `; ` v :real^3 `; ` u + v - ( w:real^3 )`] CXWOCGN;;


g ` a < sqrt (&8) ==> ~ ( &2 <= &1 / &2 * a ) `;;
e (ASM_CASES_TAC ` &0 <= a `);;
e (UNDISCH_TAC `&0 <= a `);;
e (SIMP_TAC[REAL_LT_IMP_LE; SQRT8_POS; LT_POW2_COND; REAL_ARITH `
  &2 <= &1 / &2 * a <=> &4 <= a `; REAL_ARITH` &0 <= &4 `;
  POW2_COND; SQRT8_POW2]);;
e (REAL_ARITH_TAC);;
e (FIRST_X_ASSUM MP_TAC);;
e (REAL_ARITH_TAC);;
let LT_SQ8_IMP_LT2 = top_thm();;



let LE_FOR_LEMMA36 = prove(`(CARD {u, v, w} = 3 /\ packing {u, v, w} /\ dist (u,v) < sqrt8) /\
       ~(dist (u,v) / &2 < dist (w,&1 / &2 % (u + v))) ==>
  condC (sqrt (&8)) (&2) (&2) (sqrt (&8)) (&2) (&2) /\
     CARD {u, w, v, u + v - w} = 4 /\
     &2 <= d3 u w /\
     &2 <= d3 w v /\
     &2 <= d3 v (u + v - w) /\
     &2 <= d3 u (u + v - w) /\
     d3 u v < sqrt (&8) /\
     d3 w (u + v - w) <= sqrt (&8) `,
REWRITE_TAC[condC; delta; SQRT8_POW2] THEN 
REWRITE_TAC[SET_RULE ` (! x. x IN ( a INSERT b ) ==> p x ) <=>
  p a /\ (! x. x IN b  ==> p x ) `; NOT_IN_EMPTY] THEN 
CONV_TAC REAL_RAT_REDUCE_CONV THEN 
SIMP_TAC[SQRT8_POS; REAL_LT_IMP_LE; d3; sqrt8; packing] THEN 
SIMP_TAC[REAL_LT_IMP_LE; SQRT8_POS; LT_POW2_COND;
  REAL_ARITH ` &0 <= &4 `; POW2_COND; SQRT8_POW2] THEN 
CONV_TAC REAL_RAT_REDUCE_CONV THEN 
REWRITE_TAC[NORM_ARITH` dist (v,u + v - w) = dist (u,w) /\
  dist (u,u + v - w) = dist (v,w) /\ 
  dist (w,u + v - w) = &2 * dist (w,&1 / &2 % (u + v)) `] THEN 
STRIP_TAC THEN CONJ_TAC THENL [
UNDISCH_TAC `CARD {(u:real^3), v, w} = 3` THEN 
REWRITE_TAC[CARD3; CARD4; IN_SET3] THEN 
REWRITE_TAC[DE_MORGAN_THM] THEN DAO THEN 
STRIP_TAC THEN CONJ_TAC THENL [
NHANH (NORM_ARITH`u + v - w = w ==> dist (w,u) = &1 / &2 *  dist (u,v) `) THEN 
UNDISCH_TAC `dist ((u:real^3),v) < sqrt (&8)` THEN 
 NHANH (LT_SQ8_IMP_LT2 ) THEN DOWN_TAC THEN SET_TAC[];  
REWRITE_TAC[VECTOR_ARITH ` ((v:real^N) = u + v - w <=> u = w )`;
  VECTOR_ARITH ` ((u:real^N) = u + v - w <=> v = w ) `] THEN ASM_MESON_TAC[]]; 
DAO THEN CONJ_TAC THENL [REPLICATE_TAC 2 (FIRST_X_ASSUM MP_TAC) THEN 
REAL_ARITH_TAC;DOWN_TAC THEN REWRITE_TAC[CARD3] THEN SET_TAC[]]]);;
let MIDDLE_POINT_IN_CONV2 = prove(` &1 / &2 % ( u + v ) IN conv {u,v} `,
REWRITE_TAC[CONV_SET2; IN_ELIM_THM; VECTOR_ADD_LDISTRIB] THEN 
MESON_TAC[REAL_ARITH ` &0 <= &1 / &2 `; REAL_ARITH` &1 / &2 + &1 / &2 = &1 `]);;

let INTER_DISJONT_EX = 
SET_RULE ` ( a INTER b = {} ) <=> (! x. ~ (x IN a /\ x IN b )) `;;


(* LEMMA36 *)

(* ================== *)
let ZZSBSIO = prove(` ! (u:real^3) v w. CARD {u,v,w} = 3 /\ packing {u,v,w} /\
  dist (u,v) < sqrt8 ==>  dist (u,v) / &2 < dist (w, &1 / &2 % ( u + v )) `,
REWRITE_TAC[MESON[]` a ==> b <=> ~ ( a /\ ~ b ) `] THEN 
NHANH (LE_FOR_LEMMA36) THEN 
NHANH (SPEC_ALL CXWOCGN) THEN 
REPEAT STRIP_TAC THEN 
FIRST_X_ASSUM MP_TAC THEN 
REWRITE_TAC[INTER_DISJONT_EX] THEN 
MESON_TAC[MIDDLE_POINT_IN_CONV2 ; VECTOR_ARITH ` 
  u + v = w + u + v - (w:real^N) `]);;




MATCH_MP (SPEC_ALL AFFINE_HULL_FINITE) (MESON[FINITE_RULES] ` FINITE {(a:real^N),b,c} `) ;;



let PLANE_IMP_AFFINE = prove(`plane (p:real^N -> bool ) ==> affine p `, 
MESON_TAC[plane; AFFINE_AFFINE_HULL]);;


let AFFINE = new_axiom `!V:real^N->bool.
     affine V <=>
         !(s:real^N->bool) (u:real^N->real).
             FINITE s /\ ~(s = {}) /\ s SUBSET V /\ sum s u = &1
             ==> vsum s (\x. u x % x) IN V`;;


let PLANE_IMP_AFFINE = prove(` plane (p:real^N -> bool ) ==> affine p `,
REWRITE_TAC[plane; AFFINE_HULL_3; affine; FUN_EQ_THM; IN_ELIM_THM] THEN 
STRIP_TAC THEN ASM_SIMP_TAC[IN] THEN REPEAT STRIP_TAC THEN ASM_SIMP_TAC[] THEN 
SIMP_TAC[VECTOR_ADD_LDISTRIB; VECTOR_MUL_ASSOC] THEN 
REWRITE_TAC[VECTOR_ARITH` (( a:real^N) + b + c ) + a' + b' + c'
  = ( a + a' ) + ( b + b') + c + c' `] THEN EXISTS_TAC ` u' * u'' + v' * u''' ` THEN 
EXISTS_TAC ` (u' * v'' + v' * v''')` THEN EXISTS_TAC ` (u' * w' + v' * w'')` THEN 
ASM_SIMP_TAC[prove(` u' + v' = &1 /\
  u''' + v''' + w'' = &1 /\
  u'' + v'' + w' = &1 ==>
  (u' * u'' + v' * u''') + (u' * v'' + v' * v''') + u' * w' + v' * w'' = &1 `,
SIMP_TAC[REAL_ARITH` a + b = &1 <=> a = &1 - b `] THEN REAL_ARITH_TAC);
  GSYM VECTOR_ADD_RDISTRIB]);;




let IMP_AFFINE_HULL_SUBSET = prove(` FINITE a /\ a SUBSET s /\ 
~( a = {} )/\ affine s  ==> ( affine hull a ) SUBSET s `,
SIMP_TAC[AFFINE_HULL_FINITE; SUBSET; IN_ELIM_THM] THEN 
REWRITE_TAC[ GSYM SUBSET] THEN MESON_TAC[AFFINE]);;



let SET_EQ_EX = SET_RULE `a = b <=> (! x. x IN a <=> x IN b ) `;;
let SET_EQ_TO_SUBSET = SET_RULE ` a = b <=>  a SUBSET b /\ b SUBSET a `;;




let OTHORGONAL_QUATER_FOR = prove(` delta x12 ( x12 + x23 ) ( x12 + x24 )  x23 x24 x34 =
  x12 * ups_x x23 x24 x34 `, REWRITE_TAC[delta; ups_x] THEN REAL_ARITH_TAC);;


let ORTHOGONAL_CROSS_PRODUCT = prove(` u dot ( cross u v ) = &0 /\
  v dot ( cross u v ) = &0 `,
REWRITE_TAC[cross; triple_of_real3; real3_of_triple; mk_vec3] THEN
LET_TR THEN REWRITE_TAC[DOT_3; VECTOR_3] THEN REAL_ARITH_TAC);;



let PITHAGOR_CROSS = prove(` dist (a + cross (b - a) (c - a),b) pow 2 = 
dist (b,a) pow 2 +  norm ( cross (b - a) (c - a) ) pow 2 `,
REWRITE_TAC[vector_norm; dist] THEN
SIMP_TAC[DOT_POS_LE; SQRT_WORKS] THEN 
REWRITE_TAC[VECTOR_ARITH` ((a:real^N) + b) - c = b - (c - a ) `] THEN 
ABBREV_TAC ` ab = ( b - (a:real^3)) ` THEN 
ABBREV_TAC ` ac = ( c - (a:real^3)) ` THEN 
REWRITE_TAC[DOT_LSUB; DOT_RSUB] THEN 
SIMP_TAC[ORTHOGONAL_CROSS_PRODUCT; DOT_SYM] THEN 
REAL_ARITH_TAC);;


let PITHAGOR_NORM = prove(` a dot b = &0 ==> dist (a,b) pow 2 = norm a pow 2 +
  norm b pow 2 `,
SIMP_TAC[dist; vector_norm; DOT_POS_LE; SQRT_WORKS] THEN 
SIMP_TAC[DOT_LSUB; DOT_RSUB; DOT_SYM] THEN REAL_ARITH_TAC);;









prove(` dist ( cross a b, a ) pow 2  = norm (cross a b) pow 2 + 
  norm a pow 2 /\dist ( cross a b, b ) pow 2  = norm (cross a b) pow 2 + 
  norm b pow 2 `, 
SIMP_TAC[DOT_SYM;ORTHOGONAL_CROSS_PRODUCT ; PITHAGOR_NORM; DIST_SYM]);;








let VEC3_EQ_EX= prove(`! a (b:real^3). a = b <=> a$1 = b$1 /\ a$2 = b$2 /\ a$3 = b$3 `,
SIMP_TAC[CART_EQ; DIMINDEX_3] THEN 
REWRITE_TAC[ARITH_RULE`1 <= i /\ i <= 3 <=>
  i = 1 \/ i = 2 \/ i = 3 `] THEN MESON_TAC[]);;


g ` cross (b - a) (c - d) = cross (a - b) (d - c )`;;
e (REWRITE_TAC[cross; triple_of_real3; real3_of_triple; mk_vec3]);;
e (LET_TR);;
e (REWRITE_TAC[lemma_cm3 ]);;
e (REWRITE_TAC[VEC3_EQ_EX]);;
e (REWRITE_TAC[VEC3_EQ_EX; VECTOR_3]);;
e (REAL_ARITH_TAC);;
let CROSS_CONVERT = top_thm();;



g ` &4 * norm (cross (b - a) (c - a)) pow 2 =
  ups_x (dist (a,b) pow 2) (dist (a,c) pow 2) (dist (b,c) pow 2)`;;
e (REWRITE_TAC[MESON[
prove(` dist(b,c) pow 2 = (a - c - (a - b)) dot (a - c - (a - b)) `,
SIMP_TAC[dist; vector_norm; DOT_POS_LE; SQRT_WORKS] THEN 
MESON_TAC[VECTOR_ARITH` b - (c:real^N) = (a - c) - ( a - b) `])]`
  ups_x  aa bb (dist (b,c) pow 2 ) = 
  ups_x aa bb (( a - c - (a - b)) dot (a - c - (a - b))) `]);;
e (ONCE_REWRITE_TAC[CROSS_CONVERT]);;
e (SIMP_TAC[ups_x;DIST_SYM; dist; vector_norm; DOT_POS_LE; SQRT_WORKS]);;
e (REWRITE_TAC[cross; triple_of_real3; real3_of_triple; mk_vec3]);;
e (LET_TR);;
e (REWRITE_TAC[DOT_3; VECTOR_3]);;
e (ABBREV_TAC ` ab = a - (b:real^3) `);;
e (ABBREV_TAC ` cc = a - (c:real^3) `);;
e (REWRITE_TAC[lemma_cm3 ] THEN REAL_ARITH_TAC);;

let NORM_CROSS_PRODUCT_UPS_X = top_thm();;


g ` ! u v (w:real^3). ~ collinear {a,b,c} ==> ~ coplanar {
  a + cross (b - a ) ( c - a ),a,b,c} `;;
e (MP_TAC POLFLZY);;
e (LET_TR);;
e (SIMP_TAC[]);;
e (DISCH_TAC);;
e (REWRITE_TAC[NORM_ARITH` dist (a + b ,a) = norm (b ) `]);;
e (REWRITE_TAC[NORM_ARITH`dist (a + c,b) =
  dist ( c, b - a ) `]);;
e (SIMP_TAC[prove(` dist ( cross a b, a ) pow 2  = norm (cross a b) pow 2 + 
  norm a pow 2 /\dist ( cross a b, b ) pow 2  = norm (cross a b) pow 2 + 
  norm b pow 2 `, 
SIMP_TAC[DOT_SYM;ORTHOGONAL_CROSS_PRODUCT ; PITHAGOR_NORM; DIST_SYM])]);;
e (REWRITE_TAC[GSYM dist]);;
e (SIMP_TAC[DIST_SYM; OTHORGONAL_QUATER_FOR]);;
e (ONCE_REWRITE_TAC[REAL_ARITH` a * b = &0 <=> ( &4 * a ) * b = &0 `]);;
e (SIMP_TAC[NORM_CROSS_PRODUCT_UPS_X]);;
e (REWRITE_TAC[REAL_ENTIRE]);;
e (MESON_TAC[FHFMKIY]);;
let NOT_COLLINEAR_IMP_CROSS_NOT_COPLANAR = top_thm();;




let ORTHOGONAL_IMP_PITHAGOR = prove(` (x:real^N) dot ((a:real^N) - b) = &0 ==>
  dist (a + x,b) pow 2 = norm x pow 2 + dist (a,b) pow 2`,
SIMP_TAC[dist; vector_norm; DOT_POS_LE; SQRT_WORKS] THEN 
REWRITE_TAC[VECTOR_ARITH` (a + c) - b = c + a - (b:real^N)`] THEN 
ABBREV_TAC ` aa = ( a - (b:real^N)) ` THEN 
SIMP_TAC[DOT_LADD; DOT_RADD; DOT_SYM; ZERO_NEUTRAL]);;



let NOT_COL_AND_ORTHO_IMP_NOT_COPL = prove(`! a b c (x:real^3).
 ~collinear {a, b, c} /\ x dot (a - b) = &0 /\
 x dot (a - c) = &0 /\ ~(x = vec 0)
 ==> ~coplanar {a + x, a, b, c}`,
MP_TAC POLFLZY THEN LET_TR THEN SIMP_TAC[] THEN 
SIMP_TAC[ORTHOGONAL_IMP_PITHAGOR ] THEN 
SIMP_TAC[ORTHOGONAL_IMP_PITHAGOR; NORM_ARITH ` dist (a + x,a) = norm x `] THEN 
SIMP_TAC[ORTHOGONAL_IMP_PITHAGOR; NORM_ARITH ` dist (a + x,a) = norm x `;
OTHORGONAL_QUATER_FOR] THEN SIMP_TAC[COL_EQ_UPS_0] THEN 
SIMP_TAC[COL_EQ_UPS_0; GSYM NORM_POS_LT; REAL_ENTIRE; MESON[RELATE_POW2]`
  a pow 2 = &0 <=> a = &0 `; REAL_ARITH ` &0 < a ==> ~( a = &0 ) `]);;





let PLANE_NORM_IMP_AFFINE = prove(`! p. plane_norm p ==> affine p `,
REWRITE_TAC[plane_norm; affine] THEN GEN_TAC THEN STRIP_TAC THEN 
ASM_SIMP_TAC[IN_ELIM_THM;  MESON[]` a = &1 <=> &1 = a `] THEN 
ONCE_REWRITE_TAC[ VECTOR_ARITH ` ( a + b ) - c = ( a + b ) - &1 % c `] THEN 
ASM_SIMP_TAC[ VECTOR_ARITH` (u % x + v % y) - (u + v) % v0 = 
u % ( x - v0 ) +  v % ( y - v0 ) `; DOT_RADD; DOT_RMUL; ZERO_NEUTRAL]);;




let IN_PLANE_IMP_OTHORGONAL = prove(`
 n dot (x - v0) = &0 /\ n dot (y - v0) = &0 /\ n dot (z - v0) = &0 ==>
  n dot ( x - y ) = &0 /\ n dot ( x - z ) = &0 `,
SIMP_TAC[DOT_RSUB] THEN REAL_ARITH_TAC);;




 g `(n:real^N) dot (x - v0) = &0 /\
 n dot (y - v0) = &0 /\
 n dot (z - v0) = &0 /\
 ~(n = vec 0) /\
 x' = a1 % (x + n) + a2 % x + a3 % y + a4 % z /\
 a1 + a2 + a3 + a4 = &1 /\
 n dot (x' - v0) = &0
 ==> a1 = &0`;;
e (STRIP_TAC);;
e (UNDISCH_TAC ` (n:real^N) dot (x' - v0) = &0`);;
e (ASM_SIMP_TAC[VECTOR_ARITH`(a1 % x + y ) - v0 = a1 % ( x - v0 ) + y - v0 + a1 % v0 `]);;
e (ONCE_REWRITE_TAC[ VECTOR_ARITH` a % x - y =
  a % ( x - y ) + a % y - y `]);;
e (ASM_SIMP_TAC[DOT_RADD; VECTOR_ARITH` ( a + b ) - (c:real^N) 
  = b + a - c `; DOT_RMUL; ZERO_NEUTRAL]);;
e (ASM_SIMP_TAC[DOT_RADD; VECTOR_ARITH` ( a + b ) - (c:real^N) 
  = b + a - c `; DOT_RMUL; ZERO_NEUTRAL; DOT_RSUB;
REAL_ARITH` ((a4 * (n dot v0) - n dot v0 + a3 * (n dot v0)) + a2 * (n dot v0)) +
 a1 * (n dot v0) = ( a1 + a2 + a3 + a4 ) * ( n dot v0 ) - n dot v0 `;
  REAL_ARITH ` &1 * a - a = &0 `]);;
e (ASM_MESON_TAC[REAL_ENTIRE; GSYM DOT_EQ_0]);;
let IMP_A1_EQ_0 = top_thm();;





let LEMMA7 = prove(` !x y z (p:real^3 -> bool).
         plane_norm p /\ ~collinear {x, y, z} /\ {x, y, z} SUBSET p
         ==> p = aff {x, y, z}`,
NHANH (PLANE_IMP_AFFINE) THEN 
REPEAT STRIP_TAC THEN 
REWRITE_TAC[aff; SET_EQ_TO_SUBSET] THEN CONJ_TAC THENL [
UNDISCH_TAC ` plane_norm (p:real^3 -> bool ) ` THEN 
REWRITE_TAC[plane_norm] THEN 
STRIP_TAC THEN 
UNDISCH_TAC ` {(x:real^3), y, z} SUBSET p` THEN 
ASM_SIMP_TAC[SET3_SUBSET; IN_ELIM_THM] THEN 
NHANH (IN_PLANE_IMP_OTHORGONAL ) THEN 
DOWN_TAC THEN 
NHANH (MESON[NOT_COL_AND_ORTHO_IMP_NOT_COPL]`
  ~collinear {(x:real^3), y, z} /\
 ~(n = vec 0) /\a1 /\a2 /\a4 /\a3/\
 n dot (x - y) = &0 /\
 n dot (x - z) = &0 ==> ~coplanar { x + n ,x,y,z} `) THEN 
REWRITE_TAC[SUBSET; IN_ELIM_THM] THEN 
REPEAT STRIP_TAC THEN 
UNDISCH_TAC `~coplanar {x + n, x, y, (z:real^3)} ` THEN 
NHANH (SPEC `x' :real^3` (GEN `v :real^3` ( SPEC_ALL COEFS_4 ))) THEN 
ABBREV_TAC ` a1 = COEF4_1 (x + n) x y z x'` THEN 
ABBREV_TAC ` a2 = COEF4_2 (x + n) x y z x'` THEN 
ABBREV_TAC ` a3 = COEF4_3 (x + n) x y z x'` THEN 
ABBREV_TAC ` a4 = COEF4_4 (x + n) x y z x'` THEN 
STRIP_TAC THEN 
DOWN_TAC THEN 
REWRITE_TAC[AFFINE_HULL_3; IN_ELIM_THM] THEN 
NHANH (MESON[IMP_A1_EQ_0]` ~(n = vec 0) /\
 aa1 /\
 n dot (x - v0) = &0 /\
 n dot (y - v0) = &0 /\
 n dot (z - v0) = &0 /\
 aa2 /\aa3 /\
 n dot (x' - v0) = &0 /\aa4/\aa5 /\aa6/\aa7/\
 ~coplanar {x + n, x, y, z} /\
 a1 + a2 + a3 + a4 = &1 /\
 x' = a1 % (x + n) + a2 % x + a3 % y + a4 % z /\ l ==>
  a1 = &0 `) THEN 
PURE_ONCE_REWRITE_TAC[MESON[]` P a1 /\ a1 = &0 <=> P (&0) /\
  a1 = &0 `] THEN 
REWRITE_TAC[ZERO_NEUTRAL; VECTOR_ARITH` &0 % x + y = y `] THEN 
MESON_TAC[];
ASM_MESON_TAC[PLANE_NORM_IMP_AFFINE ; FINITE_RULES; 
SET_RULE` ~({(x:real^N), y, z} = {} )`;  IMP_AFFINE_HULL_SUBSET]]);;

let SMWTDMU = LEMMA7;;


g ` det_vec3 v1 v2 v3 = ( cross v1 v2 ) dot v3 `;;
e (REWRITE_TAC[det_vec3; cross; triple_of_real3;
  real3_of_triple; mk_vec3; DOT_3; VECTOR_3]);;
e (LET_TR);;
e (REWRITE_TAC[det_vec3; cross; triple_of_real3;
  real3_of_triple; mk_vec3; DOT_3; VECTOR_3]);;
e (REAL_ARITH_TAC);;
let DET_VEC3_AS_CROSS_DOT = top_thm();;



g ` ! v1 v2 (v3:real^3). collinear {v1,v2,v3} <=>
 norm (cross (v2 - v1) (v3 - v1)) pow 2 = &0 `;;
e (REWRITE_TAC[COL_EQ_UPS_0]);;
e (REWRITE_TAC[GSYM NORM_CROSS_PRODUCT_UPS_X]);;
e (REAL_ARITH_TAC);;
let COL_EQ_NORM_CROSS = top_thm();;

let COLLINEAR_IMP_COPLANAR = prove(` ! v1 v2 v3 v3 (v:real^3). collinear {v1,v2,v3} ==>
coplanar {v1,v2,v3,v} `,
REWRITE_TAC[COPLANAR_DET_VEC3_EQ_0; COL_EQ_NORM_CROSS; DET_VEC3_AS_CROSS_DOT ] THEN 
REWRITE_TAC[GSYM RELATE_POW2; NORM_EQ_0] THEN REPEAT GEN_TAC THEN 
SIMP_TAC[VECTOR_ARITH ` vec 0 dot x = &0 `]);;

(* MAY WORKS, LEMMA 85 ; VBVYGGT *)




let POS_EQ_NOT_COPLANANR = prove(` &0 <   delta (dist ((x1:real^3),x2) pow 2) (dist (x1,x3) pow 2)
           (dist (x1,x4) pow 2)
           (dist (x2,x3) pow 2)
           (dist (x2,x4) pow 2)
           (dist (x3,x4) pow 2) <=> ~coplanar {x1, x2, x3, x4} `,
MP_TAC (DELTA_POS_4POINTS) THEN MP_TAC POLFLZY THEN LET_TR THEN 
REWRITE_TAC[REAL_ARITH` a <= b <=> a = b \/ a < b `] THEN 
MESON_TAC[REAL_ARITH` ~( a = b /\ a < b ) `]);;

let SUM_CHI_EQ_2DELTA = prove(` let chi11 = chi x12 x13 x14 x23 x24 x34 in
 let chi22 = chi x12 x24 x23 x14 x13 x34 in
 let chi33 = chi x34 x13 x23 x14 x24 x12 in
 let chi44 = chi x34 x24 x14 x23 x13 x12 in
 &2 * delta x12 x13 x14 x23 x24 x34 = chi11 + chi22 + chi33 + chi44`, LET_TR THEN 
REWRITE_TAC[chi; delta] THEN REAL_ARITH_TAC);;

let NOT_0_IMP_SUM_CHI_1 = prove(`~(delta x12 x13 x14 x23 x24 x34 = &0)
 ==> chi x12 x13 x14 x23 x24 x34 / (&2 * delta x12 x13 x14 x23 x24 x34) +
     chi x12 x24 x23 x14 x13 x34 / (&2 * delta x12 x13 x14 x23 x24 x34) +
     chi x34 x13 x23 x14 x24 x12 / (&2 * delta x12 x13 x14 x23 x24 x34) +
     chi x34 x24 x14 x23 x13 x12 / (&2 * delta x12 x13 x14 x23 x24 x34) =
     &1`, MP_TAC SUM_CHI_EQ_2DELTA THEN 
LET_TR THEN CONV_TAC REAL_FIELD);;

(* MAY WORKS *)

let PROVE_DIST_FROM_V1 = prove(` ~coplanar {v1, v2, v3, v4} ==>
let x12 = dist (v1,v2) pow 2 in
 let x13 = dist (v1,v3) pow 2 in
 let x14 = dist (v1,v4) pow 2 in
 let x23 = dist (v2,v3) pow 2 in
 let x24 = dist (v2,v4) pow 2 in
 let x34 = dist (v3,v4) pow 2 in
 let chi11 = chi x12 x13 x14 x23 x24 x34 in
 let chi22 = chi x12 x24 x23 x14 x13 x34 in
 let chi33 = chi x34 x13 x23 x14 x24 x12 in
 let chi44 = chi x34 x24 x14 x23 x13 x12 in
 p =
 &1 / (&2 * delta x12 x13 x14 x23 x24 x34) %
 (chi11 % v1 + chi22 % v2 + chi33 % v3 + chi44 % v4)
 ==> d3 p v1 pow 2 =
    ( &1 / &2 ) * rho x12 x13 x14 x23 x24 x34 / (&2 * delta x12 x13 x14 x23 x24 x34) `,
REWRITE_TAC[ GSYM POS_EQ_NOT_COPLANANR] THEN 
NHANH (REAL_ARITH` a < b ==> ~( b = a ) `) THEN 
NHANH NOT_0_IMP_SUM_CHI_1  THEN 
LET_TR THEN REWRITE_TAC[VECTOR_ADD_LDISTRIB; VECTOR_MUL_ASSOC;
  REAL_ARITH` ( &1 / a ) * b = b / a `] THEN 
ABBREV_TAC ` a1 = chi (dist (v1,v2) pow 2) (dist (v1,v3) pow 2) (dist (v1,v4) pow 2)
     (dist (v2,v3) pow 2)
     (dist (v2,v4) pow 2)
     (dist (v3,v4) pow 2) /
     (&2 *
      delta (dist (v1,v2) pow 2) (dist (v1,v3) pow 2) (dist (v1,v4) pow 2)
      (dist (v2,v3) pow 2)
      (dist (v2,v4) pow 2)
      (dist (v3,(v4:real^3)) pow 2))` THEN 
ABBREV_TAC ` a2 = chi (dist (v1,v2) pow 2) (dist (v2,v4) pow 2) (dist (v2,v3) pow 2)
     (dist (v1,v4) pow 2)
     (dist (v1,v3) pow 2)
     (dist (v3,v4) pow 2) /
     (&2 *
      delta (dist (v1,v2) pow 2) (dist (v1,v3) pow 2) (dist (v1,v4) pow 2)
      (dist (v2,v3) pow 2)
      (dist (v2,v4) pow 2)
      (dist (v3,(v4:real^3)) pow 2)) ` THEN 
REWRITE_TAC[ GSYM d3] THEN 
ABBREV_TAC ` a3 = chi (d3 v3 v4 pow 2) (d3 v1 v3 pow 2) (d3 v2 v3 pow 2) (d3 v1 v4 pow 2)
     (d3 v2 v4 pow 2)
     (d3 v1 v2 pow 2) /
     (&2 *
      delta (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v1 v4 pow 2)
      (d3 v2 v3 pow 2)
      (d3 v2 v4 pow 2)
      (d3 v3 v4 pow 2)) ` THEN 
ABBREV_TAC ` a4 = chi (d3 v3 v4 pow 2) (d3 v2 v4 pow 2) (d3 v1 v4 pow 2) (d3 v2 v3 pow 2)
     (d3 v1 v3 pow 2)
     (d3 v1 v2 pow 2) /
     (&2 *
      delta (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v1 v4 pow 2)
      (d3 v2 v3 pow 2)
      (d3 v2 v4 pow 2)
      (d3 v3 v4 pow 2)) ` THEN 
SIMP_TAC[REAL_ARITH` a + b = &1 <=> a = &1 - b `] THEN 
REPEAT STRIP_TAC THEN 
REWRITE_TAC[d3; dist; NORM_POW_2; VECTOR_ARITH` 
  (((&1 - (a2 + a3 + a4)) % v1 + a2 % v2 + a3 % v3 + a4 % v4) - v1) =
  a2 % ( v2 - v1 ) + a3 % (v3 - v1 ) + a4 % ( v4 - v1 ) `;
  VECTOR_ARITH` ( a + b ) dot ( a + b ) = a dot a + &2 * ( a dot b )
  + b dot b `] THEN 
REWRITE_TAC[DOT_RADD; DOT_LMUL; DOT_RMUL] THEN 
REWRITE_TAC[X_DOT_X_EQ] THEN 
REWRITE_TAC[DOT_NORM_NEG; VECTOR_ARITH` v2 - v1 - (v4 - v1)
  = (v2:real^N) - v4 `] THEN 
SIMP_TAC[GSYM dist; DIST_SYM; GSYM d3; D3_SYM] THEN 
EXPAND_TAC "a2" THEN 
EXPAND_TAC "a3" THEN 
EXPAND_TAC "a4" THEN 
REWRITE_TAC[GSYM d3 ] THEN 
ABBREV_TAC ` x12 = d3 v1 v2 pow 2 ` THEN 
ABBREV_TAC ` x13 = d3 v1 v3 pow 2 ` THEN 
ABBREV_TAC ` x14 = d3 v1 v4 pow 2 ` THEN 
ABBREV_TAC ` x23 = d3 v2 v3 pow 2 ` THEN 
ABBREV_TAC ` x24 = d3 v2 v4 pow 2 ` THEN 
ABBREV_TAC ` x34 = d3 v3 v4 pow 2 ` THEN 
UNDISCH_TAC ` &0 < delta x12 x13 x14 x23 x24 x34 ` THEN 
ONCE_REWRITE_TAC[REAL_FIELD` &0 < a ==> b = c <=> &0 < a
 ==> b * ( &2 * a) pow 2 = c * ( &2 * a ) pow 2 `] THEN 
ONCE_REWRITE_TAC[REAL_ARITH` &0 < a <=> &0 < &2 * a `] THEN 
SIMP_TAC[REAL_FIELD` &0 < b ==> ( a / b ) * b pow 2 = a * b `;
  REAL_RDISTRIB; REAL_FIELD` &0 < b ==> ( a / b ) * ( aa / b ) * c * 
b pow 2 = a * aa * c `; REAL_ADD_LDISTRIB] THEN 
SIMP_TAC[REAL_LDISTRIB; REAL_ARITH` (a*b)*c = a *b * c `;
  REAL_FIELD` &0 < b ==> ( a / b ) * ( a / b ) * c * b pow 2 = a pow 2 * c `;
  REAL_ARITH` &2 * a * b * c / &2 * d = a * b * d * c `] THEN 
SIMP_TAC[REAL_FIELD` &0 < a ==> ( b / a ) * ( bb / a ) * a pow 2 
  * d = b * bb * d `] THEN 
SIMP_TAC[REAL_FIELD` &0 < a ==> b / a / &2 * a pow 2 =
  a * b / &2 `] THEN 
REWRITE_TAC[chi; rho; delta] THEN 
REAL_ARITH_TAC);;



let PROVE_EQ_DIST_FROM4 = prove(` ~coplanar {v1, v2, v3, v4} ==>
let x12 = dist (v1,v2) pow 2 in
 let x13 = dist (v1,v3) pow 2 in
 let x14 = dist (v1,v4) pow 2 in
 let x23 = dist (v2,v3) pow 2 in
 let x24 = dist (v2,v4) pow 2 in
 let x34 = dist (v3,v4) pow 2 in
 let chi11 = chi x12 x13 x14 x23 x24 x34 in
 let chi22 = chi x12 x24 x23 x14 x13 x34 in
 let chi33 = chi x34 x13 x23 x14 x24 x12 in
 let chi44 = chi x34 x24 x14 x23 x13 x12 in
 p =
 &1 / (&2 * delta x12 x13 x14 x23 x24 x34) %
 (chi11 % v1 + chi22 % v2 + chi33 % v3 + chi44 % v4)
==>
d3 p v2 pow 2 = ( &1 / &2 ) * rho x12 x13 x14 x23 x24 x34 / (&2 * delta x12 x13 x14 x23 x24 x34) /\
d3 p v3 pow 2 = ( &1 / &2 ) * rho x12 x13 x14 x23 x24 x34 / (&2 * delta x12 x13 x14 x23 x24 x34) /\
d3 p v4 pow 2 =
 ( &1 / &2 ) * rho x12 x13 x14 x23 x24 x34 / (&2 * delta x12 x13 x14 x23 x24 x34)  `,
REWRITE_TAC[ GSYM POS_EQ_NOT_COPLANANR] THEN 
NHANH (REAL_ARITH` a < b ==> ~( b = a ) `) THEN 
NHANH NOT_0_IMP_SUM_CHI_1  THEN 
LET_TR THEN REWRITE_TAC[VECTOR_ADD_LDISTRIB; VECTOR_MUL_ASSOC;
  REAL_ARITH` ( &1 / a ) * b = b / a `] THEN 
ABBREV_TAC ` a1 = chi (dist (v1,v2) pow 2) (dist (v1,v3) pow 2) (dist (v1,v4) pow 2)
     (dist (v2,v3) pow 2)
     (dist (v2,v4) pow 2)
     (dist (v3,v4) pow 2) /
     (&2 *
      delta (dist (v1,v2) pow 2) (dist (v1,v3) pow 2) (dist (v1,v4) pow 2)
      (dist (v2,v3) pow 2)
      (dist (v2,v4) pow 2)
      (dist (v3,(v4:real^3)) pow 2))` THEN 
ABBREV_TAC ` a2 = chi (dist (v1,v2) pow 2) (dist (v2,v4) pow 2) (dist (v2,v3) pow 2)
     (dist (v1,v4) pow 2)
     (dist (v1,v3) pow 2)
     (dist (v3,v4) pow 2) /
     (&2 *
      delta (dist (v1,v2) pow 2) (dist (v1,v3) pow 2) (dist (v1,v4) pow 2)
      (dist (v2,v3) pow 2)
      (dist (v2,v4) pow 2)
      (dist (v3,(v4:real^3)) pow 2)) ` THEN 
REWRITE_TAC[ GSYM d3] THEN 
ABBREV_TAC ` a3 = chi (d3 v3 v4 pow 2) (d3 v1 v3 pow 2) (d3 v2 v3 pow 2) (d3 v1 v4 pow 2)
     (d3 v2 v4 pow 2)
     (d3 v1 v2 pow 2) /
     (&2 *
      delta (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v1 v4 pow 2)
      (d3 v2 v3 pow 2)
      (d3 v2 v4 pow 2)
      (d3 v3 v4 pow 2)) ` THEN 
ABBREV_TAC ` a4 = chi (d3 v3 v4 pow 2) (d3 v2 v4 pow 2) (d3 v1 v4 pow 2) (d3 v2 v3 pow 2)
     (d3 v1 v3 pow 2)
     (d3 v1 v2 pow 2) /
     (&2 *
      delta (d3 v1 v2 pow 2) (d3 v1 v3 pow 2) (d3 v1 v4 pow 2)
      (d3 v2 v3 pow 2)
      (d3 v2 v4 pow 2)
      (d3 v3 v4 pow 2)) ` THEN 
ONCE_REWRITE_TAC[MESON[VECTOR_ARITH` &1 % x = x `]` d3 a b pow 2 =
  aa <=> d3 a ( &1 % b ) pow 2 = aa `] THEN 
ONCE_REWRITE_TAC[MESON[]` a = &1 <=> &1 = a `] THEN 
SIMP_TAC[] THEN 
STRIP_TAC THEN STRIP_TAC THEN 
REWRITE_TAC[d3; dist] THEN 
REWRITE_TAC[VECTOR_ARITH` (a1 % v1 + a2 % v2 + a3 % v3 + a4 % v4) - (a1 + a2 + a3 + a4) % v2
  = a1 % ( v1 - v2 ) + a3 % ( v3 - v2 ) + a4 % (v4 - v2 ) `;
  VECTOR_ARITH` (a1 % v1 + a2 % v2 + a3 % v3 + a4 % v4) - (a1 + a2 + a3 + a4) % v3
  = a1 % ( v1 - v3 ) + a2 % ( v2 - v3 ) + a4 % (v4 - v3 )`;
  VECTOR_ARITH` (a1 % v1 + a2 % v2 + a3 % v3 + a4 % v4) - (a1 + a2 + a3 + a4) % v4 =
  a1 % ( v1 - v4 ) + a2 % ( v2 - v4 ) + a3 % (v3 - v4 )`] THEN 
REWRITE_TAC[NORM_POW_2] THEN 
REWRITE_TAC[DOT_LADD; DOT_RADD; DOT_LMUL; DOT_RMUL; GSYM NORM_POW_2] THEN 
REWRITE_TAC[DOT_NORM_NEG; VECTOR_ARITH` v3 - v4 - (v2 - v4) =
  (v3:real^N) - v2 `; GSYM dist; GSYM d3 ] THEN 
EXPAND_TAC "a1" THEN 
EXPAND_TAC "a2" THEN 
EXPAND_TAC "a3" THEN 
EXPAND_TAC "a4" THEN 
REWRITE_TAC[GSYM d3 ] THEN 
REWRITE_TAC[prove(` d3 (v4 - v3) (v1 - v3) = d3 v1 v4 `, 
REWRITE_TAC[d3] THEN CONV_TAC NORM_ARITH)] THEN 
SIMP_TAC[D3_SYM] THEN 
ABBREV_TAC ` x12 = d3 v1 v2 pow 2 ` THEN 
ABBREV_TAC ` x13 = d3 v1 v3 pow 2 ` THEN 
ABBREV_TAC ` x14 = d3 v1 v4 pow 2 ` THEN 
ABBREV_TAC ` x23 = d3 v2 v3 pow 2 ` THEN 
ABBREV_TAC ` x24 = d3 v2 v4 pow 2 ` THEN 
ABBREV_TAC ` x34 = d3 v3 v4 pow 2 ` THEN 
UNDISCH_TAC ` &0 < delta x12 x13 x14 x23 x24 x34 ` THEN 
ONCE_REWRITE_TAC[REAL_FIELD` &0 < a ==> ( b = c ) /\ ( bb = cc ) /\ ( bbb = ccc ) 
<=> &0 < a
 ==> ( b * ( &2 * a) pow 2 = c * ( &2 * a ) pow 2 ) /\
( bb * ( &2 * a) pow 2 = cc * ( &2 * a ) pow 2 ) /\
( bbb * ( &2 * a) pow 2 = ccc * ( &2 * a ) pow 2 ) `] THEN 
ONCE_REWRITE_TAC[REAL_ARITH` &0 < a <=> &0 < &2 * a `] THEN 
SIMP_TAC[REAL_FIELD` &0 < b ==> ( a / b ) * b pow 2 = a * b `;
  REAL_RDISTRIB; REAL_FIELD` &0 < b ==> ( a / b ) * ( aa / b ) * c * 
b pow 2 = a * aa * c `; REAL_ADD_LDISTRIB] THEN 
SIMP_TAC[REAL_LDISTRIB; REAL_ARITH` (a*b)*c = a *b * c `;
  REAL_FIELD` &0 < b ==> ( a / b ) * ( a / b ) * c * b pow 2 = a pow 2 * c `;
  REAL_ARITH` &2 * a * b * c / &2 * d = a * b * d * c `] THEN 
SIMP_TAC[REAL_FIELD` &0 < a ==> ( b / a ) * ( bb / a ) * a pow 2 
  * d = b * bb * d `] THEN 
SIMP_TAC[REAL_FIELD` &0 < a ==> b / a / &2 * a pow 2 =
  a * b / &2 `] THEN SIMP_TAC[REAL_FIELD` &0 < b ==> ( a / b ) * b pow 2 = a * b `;
  REAL_RDISTRIB; REAL_FIELD` &0 < b ==> ( a / b ) * ( aa / b ) * c * 
b pow 2 = a * aa * c `; REAL_ADD_LDISTRIB] THEN 
SIMP_TAC[REAL_LDISTRIB; REAL_ARITH` (a*b)*c = a *b * c `;
  REAL_FIELD` &0 < b ==> ( a / b ) * ( a / b ) * c * b pow 2 = a pow 2 * c `;
  REAL_ARITH` &2 * a * b * c / &2 * d = a * b * d * c `] THEN 
SIMP_TAC[REAL_FIELD` &0 < a ==> ( b / a ) * ( bb / a ) * a pow 2 
  * d = b * bb * d `] THEN 
SIMP_TAC[REAL_FIELD` &0 < a ==> b / a / &2 * a pow 2 =
  a * b / &2 `] THEN 
DISCH_TAC THEN REWRITE_TAC[chi; rho; delta] THEN 
REAL_ARITH_TAC);;



(* the following lemma is in Multivariate/convex.ml *)
let AFFINE_HULL_FINITE_STEP = new_axiom
`((?u. sum {} u = w /\ vsum {} (\x. u(x) % x) = y) <=>
    w = &0 /\ y = vec 0) /\
   (FINITE(s:real^N->bool)
    ==> ((?u. sum (a INSERT s) u = w /\
              vsum (a INSERT s) (\x. u(x) % x) = y) <=>
         ?v u.  sum s u = w - v /\
                vsum s (\x. u(x) % x) = y - v % a))`;;

let AFFINE_HULL_3 = prove
 (`affine hull {a,b,c} =
    { u % a + v % b + w % c | u + v + w = &1}`,
  SIMP_TAC[AFFINE_HULL_FINITE; FINITE_INSERT; FINITE_RULES] THEN
  SIMP_TAC[AFFINE_HULL_FINITE_STEP; FINITE_INSERT; FINITE_RULES] THEN
  REWRITE_TAC[REAL_ARITH `x - y = z:real <=> x = y + z`;
              VECTOR_ARITH `x - y = z:real^N <=> x = y + z`] THEN
  REWRITE_TAC[VECTOR_ADD_RID; REAL_ADD_RID] THEN SET_TAC[]);;

let AFFINE_HULL_4 = prove
 (`affine hull {a,b,c,d} =
    { u % a + v % b + w % c + z % d | u + v + w + z = &1}`,
  SIMP_TAC[AFFINE_HULL_FINITE; FINITE_INSERT; FINITE_RULES] THEN
  SIMP_TAC[AFFINE_HULL_FINITE_STEP; FINITE_INSERT; FINITE_RULES] THEN
  REWRITE_TAC[REAL_ARITH `x - y = z:real <=> x = y + z`;
              VECTOR_ARITH `x - y = z:real^N <=> x = y + z`] THEN
  REWRITE_TAC[VECTOR_ADD_RID; REAL_ADD_RID] THEN SET_TAC[]);;


let PROVE_EXISTS_CIR_OF_FOUR_POINTS = prove(`!(v1:real^3) v2 v3 v4.
         CARD {v1, v2, v3, v4} = 4 /\ ~coplanar {v1, v2, v3, v4}
         ==> (? p. p IN affine hull {v1, v2, v3, v4} /\
             (?r. !v. v IN {v1, v2, v3, v4}
                      ==> r = dist (p, v))) `,
NHANH (REWRITE_RULE[RIGHT_FORALL_IMP_THM]  (GEN `p:real^3` PROVE_DIST_FROM_V1)) THEN 
NHANH (REWRITE_RULE[RIGHT_FORALL_IMP_THM]  (GEN `p:real^3` PROVE_EQ_DIST_FROM4 )) THEN 
REPEAT GEN_TAC THEN REPEAT LET_TAC THEN ABBREV_TAC `rr = &1 / &2 *
       rho x12 x13 x14 x23 x24 x34 / (&2 * delta x12 x13 x14 x23 x24 x34) ` THEN 
REWRITE_TAC[GSYM POS_EQ_NOT_COPLANANR] THEN 
NHANH (SPEC_ALL REAL_POS_NZ) THEN ASM_SIMP_TAC[] THEN 
NHANH (NOT_0_IMP_SUM_CHI_1 ) THEN ASM_SIMP_TAC[] THEN 
REWRITE_TAC[VECTOR_ADD_LDISTRIB; VECTOR_MUL_ASSOC;
  REAL_ARITH ` &1 / a * b = b / a `] THEN 
REWRITE_TAC[FORALL_IN_CLAUSES; MESON[]`(? r. (r:real) = a /\
  r = b /\ r = c /\ r = d ) <=> a = b /\ a = c /\ a = d `] THEN 
REWRITE_TAC[MESON[]` (! x. x = a ==> P a ) <=> P a `] THEN DISCH_TAC THEN 
EXISTS_TAC ` chi11 / (&2 * delta x12 x13 x14 x23 x24 x34) % (v1:real^3) +
      chi22 / (&2 * delta x12 x13 x14 x23 x24 x34) % v2 +
      chi33 / (&2 * delta x12 x13 x14 x23 x24 x34) % v3 +
      chi44 / (&2 * delta x12 x13 x14 x23 x24 x34) % v4 ` THEN 
CONJ_TAC THENL [REWRITE_TAC[AFFINE_HULL_4; IN_ELIM_THM] THEN 
FIRST_X_ASSUM MP_TAC THEN MESON_TAC[NOT_0_IMP_SUM_CHI_1 ]; 
FIRST_X_ASSUM MP_TAC THEN SIMP_TAC[d3; DIST_POS_LE; EQ_POW2_COND]]);;












let IMP_PROPERTIES_OF_CIR4 = prove(`!(v1:real^3) v2 v3 v4.
         CARD {v1, v2, v3, v4} = 4 /\ ~coplanar {v1, v2, v3, v4}
         ==> circumcenter {v1, v2, v3, v4} IN affine hull {v1, v2, v3, v4} /\
             (?r. !v. v IN {v1, v2, v3, v4}
                      ==> r = dist (circumcenter {v1, v2, v3, v4},v))`,
NHANH (SPEC_ALL PROVE_EXISTS_CIR_OF_FOUR_POINTS ) THEN REWRITE_TAC[circumcenter; IN]
THEN MESON_TAC[EXISTS_THM]);;




let DIST_EQ_IMP_ORTHOGONAL = prove(` dist (pp,v2) = dist (pp,v1) /\
  dist (p,v2) = dist (p,v1) ==>
  (pp - p ) dot (v2 - v1 ) = &0 `,
REWRITE_TAC[MONG7_ROI; DOT_LSUB] THEN REAL_ARITH_TAC);;



let IMP_OTHO4 = prove(` n dot (v2 - v1) = &0 /\
  n dot (v3 - v1) = &0 /\
  n dot (v4 - v1) = &0 /\
  x IN affine hull {v1,v2,v3,v4} /\
  y IN affine hull {v1,v2,v3,v4} ==>
  n dot (x - y ) = &0 `,
REWRITE_TAC[AFFINE_HULL_4; IN_ELIM_THM] THEN STRIP_TAC THEN 
DOWN_TAC THEN IMP_TAC THEN SIMP_TAC[REAL_ARITH`a + b = c <=> a = c - b `] THEN 
PHA THEN REWRITE_TAC[VECTOR_ARITH` ((&1 - (v' + w' + z')) % v1 + v' % v2 +
 w' % v3 + z' % v4) - ((&1 - (v + w + z)) % v1 + v % v2 + w % v3 + z % v4)  =
  ( v' - v ) % ( v2 - v1 ) + ( w' - w ) % ( v3 - v1 ) +
  ( z' - z ) % ( v4 - v1 ) `] THEN 
SIMP_TAC[DOT_RADD; DOT_RMUL; ZERO_NEUTRAL]);;





let UNIQUE_EXISISTING_PROPERTY_C4 = prove(`!(v1:real^3) v2 v3 v4.
         CARD {v1, v2, v3, v4} = 4 /\ ~coplanar {v1, v2, v3, v4}
         ==>   (!p. p IN affine hull {v1, v2, v3, v4} /\
                  (?r. !v. v IN {v1, v2, v3, v4} ==> r = dist (p,v))
                  ==> p = circumcenter {v1, v2, v3, v4}) `,
NHANH (SPEC_ALL IMP_PROPERTIES_OF_CIR4 ) THEN 
REPEAT GEN_TAC THEN 
ABBREV_TAC ` pp = circumcenter {(v1:real^3), v2, v3, v4}` THEN 
REPEAT STRIP_TAC THEN 
DOWN_TAC THEN 
REWRITE_TAC[FORALL_IN_CLAUSES] THEN 
REWRITE_TAC[MESON[]` r = a /\ r = b /\ r = c /\ r = d <=> r = a /\ b = a /\ c = a 
  /\ d = a `] THEN 
PHA THEN 
NHANH (MESON[DIST_EQ_IMP_ORTHOGONAL ]`dist (pp,v2) = dist (pp,v1) /\
 dist (pp,v3) = dist (pp,v1) /\
 dist (pp,v4) = dist (pp,v1) /\a11/\a2/\
 dist (p,v2) = dist (p,v1) /\
 dist (p,v3) = dist (p,v1) /\
 dist (p,v4) = dist (p,v1) ==>
  ( p - pp) dot ( v2 - v1 ) = &0 /\
  ( p - pp ) dot ( v3 - v1 ) = &0 /\
  ( p - pp ) dot ( v4 - v1 ) = &0 `) THEN 
ONCE_REWRITE_TAC[GSYM VECTOR_SUB_EQ] THEN 
REWRITE_TAC[GSYM DOT_EQ_0] THEN MESON_TAC[IMP_OTHO4 ]);;




let PROVE_IN_AFFINE_HULL_4 = prove(
`~(delta x12 x13 x14 x23 x24 x34 = &0)
 ==> &1 / (&2 * delta x12 x13 x14 x23 x24 x34) %
     (chi x12 x13 x14 x23 x24 x34 % v1 +
      chi x12 x24 x23 x14 x13 x34 % v2 +
      chi x34 x13 x23 x14 x24 x12 % v3 +
      chi x34 x24 x14 x23 x13 x12 % v4) IN
     affine hull {(v1:real^3), v2, v3, v4}`,
REWRITE_TAC[AFFINE_HULL_4; IN_ELIM_THM; VECTOR_ADD_LDISTRIB;
  VECTOR_MUL_ASSOC; REAL_ARITH ` ( &1 / a ) * b = b/a `]
 THEN MESON_TAC[NOT_0_IMP_SUM_CHI_1]);;



(* VBVYGGT , le 85 *)



MESON[POW_2_SQRT; DIST_POS_LE]` dist (x,y) pow 2 = r ==> dist (x,y) = sqrt ( r ) `;;

(* LEMMA 85 *)
let VBVYGGT = prove(`!(v1:real^3) v2 v3 v4.
         CARD {v1, v2, v3, v4} = 4 /\ ~coplanar {v1, v2, v3, v4}
         ==> circumcenter {v1, v2, v3, v4} IN affine hull {v1, v2, v3, v4} /\
             (?r. !v. v IN {v1, v2, v3, v4}
                      ==> r = dist (circumcenter {v1, v2, v3, v4},v)) /\
             (!p. p IN affine hull {v1, v2, v3, v4} /\
                  (?r. !v. v IN {v1, v2, v3, v4} ==> r = dist (p,v))
                  ==> p = circumcenter {v1, v2, v3, v4}) /\
             (let x12 = dist (v1,v2) pow 2 in
              let x13 = dist (v1,v3) pow 2 in
              let x14 = dist (v1,v4) pow 2 in
              let x23 = dist (v2,v3) pow 2 in
              let x24 = dist (v2,v4) pow 2 in
              let x34 = dist (v3,v4) pow 2 in
              let chi11 = chi x12 x13 x14 x23 x24 x34 in
              let chi22 = chi x12 x24 x23 x14 x13 x34 in
              let chi33 = chi x34 x13 x23 x14 x24 x12 in
              let chi44 = chi x34 x24 x14 x23 x13 x12 in
              circumcenter {v1, v2, v3, v4} =
              &1 / (&2 * delta x12 x13 x14 x23 x24 x34) %
              (chi11 % v1 + chi22 % v2 + chi33 % v3 + chi44 % v4)) `,
NHANH (SPEC_ALL UNIQUE_EXISISTING_PROPERTY_C4 ) THEN 
NHANH (SPEC_ALL IMP_PROPERTIES_OF_CIR4 ) THEN 
REWRITE_TAC[MESON[]` (a /\ b1/\b2) /\ b ==> b1 /\b2/\ b/\ d <=> a /\ b1 /\b2/\b==>d `] THEN 
NHANH (REWRITE_RULE[RIGHT_FORALL_IMP_THM] ( GEN `p: real^3 `PROVE_DIST_FROM_V1)) THEN 
NHANH (REWRITE_RULE[RIGHT_FORALL_IMP_THM] ( GEN `p: real^3 ` PROVE_EQ_DIST_FROM4)) THEN 
REPEAT GEN_TAC THEN REPEAT LET_TAC THEN ABBREV_TAC `rr = &1 / &2 *
       rho x12 x13 x14 x23 x24 x34 / (&2 * delta x12 x13 x14 x23 x24 x34) ` THEN 
REWRITE_TAC[MESON[]` (! x. x = a ==> P x ) <=> P a `] THEN 
REWRITE_TAC[GSYM POS_EQ_NOT_COPLANANR] THEN 
NHANH (REAL_ARITH` &0 < a ==> ~( a = &0 )`) THEN 
NHANH (PROVE_IN_AFFINE_HULL_4 ) THEN 
UNDISCH_TAC ` dist ((v1:real^3),v2) pow 2 = x12` THEN 
UNDISCH_TAC ` dist ((v1:real^3),v3) pow 2 = x13` THEN 
UNDISCH_TAC ` dist ((v1:real^3),v4) pow 2 = x14` THEN 
UNDISCH_TAC ` dist ((v2:real^3),v3) pow 2 = x23` THEN 
UNDISCH_TAC ` dist ((v2:real^3),v4) pow 2 = x24` THEN 
UNDISCH_TAC ` dist ((v3:real^3),v4) pow 2 = x34` THEN 
UNDISCH_TAC ` chi x12 x13 x14 x23 x24 x34 = chi11 ` THEN 
UNDISCH_TAC ` chi x12 x24 x23 x14 x13 x34 = chi22 ` THEN 
UNDISCH_TAC ` chi x34 x13 x23 x14 x24 x12 = chi33` THEN 
UNDISCH_TAC ` chi x34 x24 x14 x23 x13 x12 = chi44` THEN 
REWRITE_TAC[MESON[]` a = b ==> P a <=> a = b ==> P b `] THEN 
ABBREV_TAC ` w =  &1 / (&2 * delta x12 x13 x14 x23 x24 x34) %
     (chi11 % (v1:real^3) + chi22 % v2 + chi33 % v3 + chi44 % v4)` THEN 
REWRITE_TAC[MESON[]` a /\ b ==> c <=> a ==> b ==> c `]
THEN REPLICATE_TAC 13 DISCH_TAC THEN 
REWRITE_TAC[FORALL_IN_CLAUSES;d3] THEN PHA THEN 
NHANH (MESON[POW_2_SQRT; DIST_POS_LE]` dist (x,y) pow 2 = r
 ==> dist (x,y) = sqrt ( r ) `) THEN MESON_TAC[]);;

(* lemma 85 *)
(* let VBVYGGT = new_axiom `!(v1:real^3) v2 v3 v4.
         CARD {v1, v2, v3, v4} = 4 /\ ~coplanar {v1, v2, v3, v4}
         ==> circumcenter {v1, v2, v3, v4} IN affine hull {v1, v2, v3, v4} /\
             (?r. !v. v IN {v1, v2, v3, v4}
                      ==> r = dist (circumcenter {v1, v2, v3, v4},v)) /\
             (!p. p IN affine hull {v1, v2, v3, v4} /\
                  (?r. !v. v IN {v1, v2, v3, v4} ==> r = dist (p,v))
                  ==> p = circumcenter {v1, v2, v3, v4}) /\
             (let x12 = dist (v1,v2) pow 2 in
              let x13 = dist (v1,v3) pow 2 in
              let x14 = dist (v1,v4) pow 2 in
              let x23 = dist (v2,v3) pow 2 in
              let x24 = dist (v2,v4) pow 2 in
              let x34 = dist (v3,v4) pow 2 in
              let chi11 = chi x12 x13 x14 x23 x24 x34 in
              let chi22 = chi x12 x24 x23 x14 x13 x34 in
              let chi33 = chi x34 x13 x23 x14 x24 x12 in
              let chi44 = chi x34 x24 x14 x23 x13 x12 in
              circumcenter {v1, v2, v3, v4} =
              &1 / (&2 * delta x12 x13 x14 x23 x24 x34) %
              (chi11 % v1 + chi22 % v2 + chi33 % v3 + chi44 % v4)) `;; *)



let NOT_COPLANAR_IMP_EXISTS_CIR = prove(`! (v1:real^3) v2 v3 v4.
       CARD {v1, v2, v3, v4} = 4 /\ ~coplanar {v1, v2, v3, v4}
       ==> circumcenter {v1, v2, v3, v4} IN affine hull {v1, v2, v3, v4} /\
           (?r. !v. v IN {v1, v2, v3, v4}
                    ==> r = dist (circumcenter {v1, v2, v3, v4},v)) `,
MESON_TAC[VBVYGGT]);;




let THREE_POINTS_COP = prove(` ! v1 v2 (v3:real^3). coplanar {v1,v2,v3} `,
MESON_TAC[DIMINDEX_3; ARITH_RULE` 2 <= 3 `; COPLANAR_3]);;




let PER_SET4 = SET_RULE ` {a,b,c,d} = {b,a,c,d} /\
  {a,b,c,d} = {c,b,a,d} /\
  {a,b,c,d} = {d,b,c,a} `;;


let NOT_COPLANAR_IMP_CARD4 = prove(` ~ coplanar {(v1:real^3), v2, v3, v4} 
==> CARD {v1, v2, v3, v4} = 4 `, REWRITE_TAC[CARD4; IN_SET3] THEN 
MP_TAC (GEN_ALL THREE_POINTS_COP ) THEN 
MESON_TAC[PER_SET4; SET_RULE` {a,a,b,c} = {a,b,c} `]);;


let NOT_COPLANAR_IMP_EXISTS_CIR2 = MESON[NOT_COPLANAR_IMP_EXISTS_CIR ; 
NOT_COPLANAR_IMP_CARD4 ]` ! (v1:real^3) v2 v3 v4. ~ coplanar {v1, v2, v3, v4}
       ==> circumcenter {v1, v2, v3, v4} IN affine hull {v1, v2, v3, v4} /\
           (?r. !v. v IN {v1, v2, v3, v4}
                    ==> r = dist (circumcenter {v1, v2, v3, v4},v)) `;;



let NOT_COPLANAR_IMP_RADV_PROPERTIES = prove(` ~coplanar {(v1:real^3), v2, v3, v4} ==>
  (! w. {v1, v2, v3, v4} w ==> radV {v1, v2, v3, v4} 
    = dist (circumcenter {v1,v2,v3,v4} ,w) ) `,
NHANH (SPEC_ALL NOT_COPLANAR_IMP_EXISTS_CIR2) THEN 
REWRITE_TAC[IN; radV] THEN MESON_TAC[EXISTS_THM]);;



let ZJEWPAP = ` ! v1 v2 v3 (v4:real^3).
  let s = {v1, v2, v3, v4} in CARD s = 4 /\ ~ coplanar s 
  ==> radV {v1,v2,v3}  <= radV s  `;;



let PHA = REWRITE_TAC[MESON[]` ( a ==> b ==> c <=> a /\ b ==> c ) /\
  ( (a /\ b ) /\ c <=> a /\ b /\ c ) `];;


let NOT_COL_EQ_UPS_X_POS = prove(`! v1 v2 v3.  ~ collinear {(v1:real^3), v2, v3} <=>
           &0 < ups_x (dist (v1,v2) pow 2) (dist (v1,v3) pow 2)
           (dist (v2,v3) pow 2) `,
MP_TAC (GEN_ALL ZERO_LE_UPS_X) THEN REWRITE_TAC[UPS_X_EQ_ZERO_COND] THEN 
REWRITE_TAC[UPS_X_EQ_ZERO_COND; REAL_ARITH` a <= b <=> a = b \/ a < b `] THEN 
REWRITE_TAC[d3] THEN MESON_TAC[REAL_ARITH` ~( a = b /\ a < b ) `]);;


let ETA_Y_POW2_EQ = prove(`(dist (v1,v2) pow 2 * dist (v1,v3) pow 2 * dist (v2,v3) pow 2) /
      ups_x (dist (v1,v2) pow 2) (dist (v1,v3) pow 2) (dist (v2,v3) pow 2) =
( eta_y (d3 v2 v3) (d3 v1 v3) (d3 v1 v2)) pow 2 `,
REWRITE_TAC[eta_y;d3; eta_x] THEN LET_TR THEN 
REWRITE_TAC[GSYM REAL_POW_2; GSYM d3 ] THEN 
SIMP_TAC[MESON[UPS_X_SYM]` ups_x a b c = ups_x c b a `; 
REAL_ARITH ` a * b * c = c * b * a `] THEN 
MESON_TAC[SQRT_WORKS; REAL_LE_SQUARE_POW; REAL_LE_MUL;
  REAL_LE_DIV; d3 ; ZERO_LE_UPS_X; UPS_X_SYM]);;


let ETA_Y_POS_LE = prove(` &0 <= eta_y (d3 v1 v2) (d3 v1 v3) (d3 v2 v3) `,
REWRITE_TAC[eta_y; eta_x] THEN LET_TR THEN REWRITE_TAC[GSYM REAL_POW_2] THEN 
MESON_TAC[REAL_LE_POW_2; REAL_LE_MUL; ZERO_LE_UPS_X; REAL_LE_DIV;
  SQRT_POS_LE]);;


(* lemma 87 *)
let ZJEWPAP = prove(` ! v1 v2 v3 (v4:real^3).
  let s = {v1, v2, v3, v4} in CARD s = 4 /\ ~ coplanar s 
  ==> radV {v1,v2,v3}  <= radV s  `,
LET_TR THEN 
NHANH (MESON[COLLINEAR_IMP_COPLANAR ]`~coplanar {v1, v2, v3, v4}
  ==> ~ collinear {(v1:real^3),v2,v3} `) THEN 
SIMP_TAC[NOT_COLL_IMP_RADV_EQ_ETA_Y] THEN 
REWRITE_TAC[MESON[]` a /\ b /\ c <=> (a/\b)/\c`] THEN 
NHANH (SPEC_ALL VBVYGGT) THEN 
REPEAT GEN_TAC THEN 
NHANH (NOT_COPLANAR_IMP_RADV_PROPERTIES) THEN 
ABBREV_TAC ` pp = circumcenter {(v1:real^3), v2, v3, v4}` THEN 
MP_TAC (SPECL [`pp :real^3`; ` v1: real^3`; `v2:real^3`; ` v3:real^3`] DELTA_POS_4POINTS ) THEN 
REWRITE_TAC[REWRITE_RULE[IN] FORALL_IN_CLAUSES; 
   FORALL_IN_CLAUSES ] THEN 
REWRITE_TAC[MESON[]` ( a ==> b ==> c <=> a /\ b ==> c ) /\
  ( (a /\ b ) /\ c <=> a /\ b /\ c ) `] THEN 
REPEAT STRIP_TAC THEN 
UNDISCH_TAC ` &0 <=
      delta (dist ((pp:real^3),v1) pow 2) (dist (pp,v2) pow 2) (dist (pp,v3) pow 2)
      (dist (v1,v2) pow 2)
      (dist (v1,v3) pow 2)
      (dist (v2,v3) pow 2)` THEN 
ABBREV_TAC `p1 = dist ((pp:real^3),v1)` THEN 
ABBREV_TAC `p2 = dist ((pp:real^3),v2)` THEN 
ABBREV_TAC `p3 = dist ((pp:real^3),v3)` THEN 
 REPLICATE_TAC 3 (FIRST_X_ASSUM MP_TAC THEN MATCH_MP_TAC 
(MESON[]` a ==> b ==> a `)) THEN 
EXPAND_TAC "p1" THEN 
EXPAND_TAC "p2" THEN 
EXPAND_TAC "p3" THEN 
FIRST_X_ASSUM MP_TAC THEN 
REWRITE_TAC[NOT_COL_EQ_UPS_X_POS ] THEN 
REWRITE_TAC[NOT_COL_EQ_UPS_X_POS; DELTA_RRR_INTERPRETE] THEN 
SIMP_TAC[REAL_FIELD` &0 < a ==> -- b * c + r * a = a * ( r - ( b * c )  / a ) `] THEN 
SIMP_TAC[ETA_Y_POW2_EQ; REAL_LE_MUL_EQ] THEN 
UNDISCH_TAC ` radV {(v1:real^3), v2, v3, v4} = p1 ` THEN 
SIMP_TAC[] THEN 
EXPAND_TAC "p1" THEN 
UNDISCH_TAC `r = dist ((pp: real^3),v4)` THEN 
SIMP_TAC[] THEN 
REPLICATE_TAC 3 REMOVE_TAC THEN 
SIMP_TAC[ETA_Y_SYYM; REAL_ARITH` &0 <= a - b <=> b <= a `] THEN 
MESON_TAC[DIST_POS_LE; POW2_COND; ETA_Y_POS_LE ]);;





let NOT_EQ_BASIS_IMP_OTHORGANAL = MESON[DOT_BASIS_BASIS_UNEQUAL]
` ! i j. ~( i = j ) ==> basis i dot basis j = &0 `;;


let BASIS_DIS_OTHORGONAL = 
MESON[ARITH_RULE` ~( 1 = 2 \/ 1 = 3 \/ 2 = 3 ) `; NOT_EQ_BASIS_IMP_OTHORGANAL]
` basis 1 dot basis 2 = &0 /\
  basis 1 dot basis 3 = &0 /\
  basis 2 dot basis 3 = &0 ` ;;


let NORM_BASIS_VEC3 = prove(` ! i. i = 1 \/ i = 2 \/ i = 3 ==> 
norm (( basis i ):real^3 ) = &1 `,
MESON_TAC[DIMINDEX_3; ARITH_RULE` i = 1 \/ i = 2 \/ i = 3 <=>
  1 <= i /\ i <= 3`; NORM_BASIS]);;


let AAA_LEMMA = prove(` &0 < a /\
 a <= b /\
 b <= c /\ ll ==> &0 <= b pow 2 - a pow 2 /\ &0 <= c pow 2 - b pow 2 `,
REWRITE_TAC[REAL_ARITH` &0 <= a - b <=> b <= a `] THEN 
MESON_TAC[REAL_LT_IMP_LE; POW2_COND; POS_IMP_POW2; REAL_LE_TRANS]);;


let LLEEMAA = prove(` &0 < a /\
     a <= b /\
     b <= c /\
     &0 < a' /\
     a' <= b' /\
     b' <= c' /\
     a <= a' /\
     b <= b' /\
     c <= c' /\ l ==> &0 <= a' pow 2 - a pow 2 /\
  &0 <= b' pow 2 - b pow 2 /\
  &0 <= c' pow 2 - c pow 2 `,
REWRITE_TAC[REAL_ARITH` &0 <= a - b <=> b <= a `] THEN 
MESON_TAC[POS_IMP_POW2; REAL_ARITH` a < b ==> a <= b `;
  REAL_LE_TRANS]);;



let TYUNJLA = prove(` !(e1:real^3) e2 e3 a b c a' b' c' t1 t2 t3.
  e1 = basis 1 /\
     e2 = basis 2 /\
     e3 = basis 3 /\
     &0 < a /\
     a <= b /\
     b <= c /\
     &0 < a' /\
     a' <= b' /\
     b' <= c' /\
     a <= a' /\
     b <= b' /\
     c <= c' /\
     (!x. x IN {t1, t2, t3} ==> &0 < x) /\
     t1 + t2 + t3 < &1 /\
     v =
     ((t1 + t2 + t3) * a) % e1 +
     ((t2 + t3) * sqrt (b pow 2 - a pow 2)) % e2 +
     (t3 * sqrt (c pow 2 - b pow 2)) % e3 /\
  v' = ((t1 + t2 + t3) * a') % e1 +
     ((t2 + t3) * sqrt (b' pow 2 - a' pow 2)) % e2 +
     (t3 * sqrt (c' pow 2 - b' pow 2)) % e3 ==>
  norm v <= norm v' `,
REPEAT STRIP_TAC THEN FIRST_X_ASSUM MP_TAC THEN 
FIRST_X_ASSUM MP_TAC THEN 
SIMP_TAC[POW2_COND; NORM_POS_LE; NORM_POW_2; DOT_LADD; DOT_RADD;
DOT_LMUL; DOT_RMUL] THEN ASM_SIMP_TAC[] THEN 
SIMP_TAC[GSYM NORM_POW_2; NORM_BASIS_VEC3 ] THEN 
SIMP_TAC[BASIS_DIS_OTHORGONAL; MESON[DOT_SYM; BASIS_DIS_OTHORGONAL]
  ` basis 2 dot basis 1 = &0 /\ basis 3 dot basis 1 = &0 /\
  basis 3 dot basis 2 = &0 `; ZERO_NEUTRAL] THEN 
REWRITE_TAC[REAL_ARITH` (a * x ) * ( b * x ) * c = a * b * c * x pow 2 `] THEN 
REPEAT STRIP_TAC THEN DOWN_TAC THEN 
NHANH (AAA_LEMMA) THEN PHA THEN 
NHANH (MESON[AAA_LEMMA]` &0 < a /\ a <= b /\ b <= c /\ aa <= a /\ l ==>
  &0 <= b pow 2 - a pow 2 /\ &0 <= c pow 2 - b pow 2 `) THEN 
SIMP_TAC[SQRT_WORKS] THEN 
ONCE_REWRITE_TAC[REAL_ARITH` a <= b <=> &0 <= b - a `] THEN 
REWRITE_TAC[REAL_ARITH` ((t1 + t2 + t3) * (t1 + t2 + t3) * &1 pow 2 * a' pow 2 +
      (t2 + t3) * (t2 + t3) * &1 pow 2 * (b' pow 2 - a' pow 2) +
      t3 * t3 * &1 pow 2 * (c' pow 2 - b' pow 2)) -
     ((t1 + t2 + t3) * (t1 + t2 + t3) * &1 pow 2 * a pow 2 +
      (t2 + t3) * (t2 + t3) * &1 pow 2 * (b pow 2 - a pow 2) +
      t3 * t3 * &1 pow 2 * (c pow 2 - b pow 2)) = 
  t1 * ( t1 + &2 * t2 + &2 * t3 ) * ( a' pow 2 - a pow 2 ) +
  t2 * (t2 + &2 * t3 ) * ( b' pow 2 - b pow 2 ) +
  t3 pow 2 * ( c' pow 2 - c pow 2 ) `] THEN 
REWRITE_TAC[REAL_ARITH` &0 <= a - b <=> b <= a `] THEN 
PHA THEN NHANH (LLEEMAA) THEN STRIP_TAC THEN 
UNDISCH_TAC ` (!x. x IN {t1, t2, t3} ==> &0 < x)` THEN 
REPLICATE_TAC 3 ( FIRST_X_ASSUM MP_TAC) THEN 
REWRITE_TAC[FORALL_IN_CLAUSES] THEN PHA THEN 
NHANH (REAL_ARITH` &0 < t1 /\ &0 < t2 /\ &0 < t3 ==>
  &0 <= t1 /\ &0 <= t2 /\ &0 <= t1 + &2 * t2 + &2 * t3 /\
  &0 <= t2 + &2 * t3 `) THEN 
MESON_TAC[REAL_LE_ADD; REAL_LE_MUL; REAL_LE_POW_2]);;

let LEMMA83 = TYUNJLA ;;



(* This lemma will be proved by Harrison *)
let NORM_TOWARD_FORTH_POINT = new_axiom`!(v1:real^3) v2 v3 w.
     ~coplanar {v1, v2, v3, w}
     ==> (?nor. norm nor = &1 /\
                (!x. x IN aff_ge {v1, v2, v3} {w} <=>
                     (?xx h.
                          xx IN affine hull {v1, v2, v3} /\
                          &0 <= h /\
                          x = xx + h % nor)) /\
                (!x y.
                     {x, y} SUBSET affine hull {v1, v2, v3}
                     ==> nor dot (x - y) = &0))`;;


let DELTA_TRIPLE_SUB_H_EXPAND = prove(`
delta (a01 - h) (a02 - h) (a03 - h) x12 x13 x23 = 
  delta a01 a02 a03 x12 x13 x23 - h * ups_x x12 x13 x23 `,
REWRITE_TAC[delta;ups_x] THEN REAL_ARITH_TAC);;

let PROVE_EXISTS_H_DELTA_0 = prove(`&0 < ups_x x12 x13 x23 /\ &0 <= delta a01 a02 a03 x12 x13 x23
 ==> (?h. &0 <= h /\ h = ( delta a01 a02 a03 x12 x13 x23 ) / ups_x x12 x13 x23 /\
 delta (a01 - h) (a02 - h) (a03 - h) x12 x13 x23 = &0 )`,
REWRITE_TAC[DELTA_TRIPLE_SUB_H_EXPAND] THEN 
DISCH_TAC THEN 
EXISTS_TAC`( delta a01 a02 a03 x12 x13 x23 ) / ups_x x12 x13 x23` THEN 
ASM_SIMP_TAC[REAL_LT_IMP_LE; REAL_LE_DIV] THEN 
FIRST_X_ASSUM MP_TAC THEN CONV_TAC REAL_FIELD);;



let FIRST_POINT_IN_AFF3 = prove(` ! w v1 v2. w IN aff {w,v1,v2} `,
REWRITE_TAC[aff; AFFINE_HULL_3; IN_ELIM_THM] THEN REPEAT GEN_TAC THEN 
EXISTS_TAC ` &1 ` THEN EXISTS_TAC `&0` THEN EXISTS_TAC `&0` THEN 
REWRITE_TAC[ZERO_NEUTRAL] THEN CONV_TAC VECTOR_ARITH);;

let THREE_GEN_POINTS_IN_AFF3 = MESON[PER_SET3; FIRST_POINT_IN_AFF3 ]` a IN aff {a,b,c} /\
  b IN aff {a,b,c} /\ c IN aff {a,b,c} `;;


(* LEMMA73 *)
let OFGJQUS = prove(` ! v1 v2 v3 (v4:real^3) a01 a02 a03 .
  let x12 = d3 v1 v2 pow 2 in
         let x13 = d3 v1 v3 pow 2 in
         let x23 = d3 v2 v3 pow 2 in
         CARD {v1, v2, v3, v4} = 4 /\

         ~coplanar {v1, v2, v3, v4} /\
  &0 <= a01 /\ &0 <= a02 /\ &0 <= a03 /\ 
  delta a01 a02 a03 x12 x13 x23 >= &0
         ==> (?v0. v0 IN aff_ge {v1, v2, v3} {v4} /\
                   d3 v0 v1 pow 2 = a01 /\
                   d3 v0 v2 pow 2 = a02 /\
                   d3 v0 v3 pow 2 = a03 /\
                   (!vv0. vv0 IN aff_ge {v1, v2, v3} {v4} /\
                          d3 vv0 v1 pow 2 = a01 /\
                          d3 vv0 v2 pow 2 = a02 /\
                          d3 vv0 v3 pow 2 = a03
                          ==> vv0 = v0) /\
                   ( v0 IN aff {v1,v2,v3} <=> 
                     delta a01 a02 a03 x12 x13 x23 = &0 )) `,
REPEAT GEN_TAC THEN 
REPEAT LET_TAC THEN 
NHANH (MESON[COLLINEAR_IMP_COPLANAR ]`~coplanar {v1, v2, v3, v4}
  ==> ~ collinear {(v1:real^3),v2,v3} `) THEN 
REWRITE_TAC[NOT_COL_EQ_UPS_X_POS] THEN 
PHA THEN REWRITE_TAC[MESON[]` ( &0 < a ) /\ l <=> l /\ &0 < a `] THEN 
PHA THEN 
REWRITE_TAC[d3 ; REAL_ARITH` a >= b <=> b <= a `; 
  GSYM (MESON[]` ( &0 < a ) /\ l <=> l /\ &0 < a `)] THEN 
EXPAND_TAC "x12" THEN 
EXPAND_TAC "x13" THEN 
EXPAND_TAC "x23" THEN 
REWRITE_TAC[d3] THEN NHANH (PROVE_EXISTS_H_DELTA_0 ) THEN 
NHANH (SPEC_ALL NORM_TOWARD_FORTH_POINT ) THEN 
NHANH (MESON[COLLINEAR_IMP_COPLANAR]`~coplanar {v1, v2, v3, v4}
  ==> ~ collinear {(v1:real^3),v2,v3} `) THEN 
STRIP_TAC THEN 
FIRST_X_ASSUM MP_TAC THEN 
UNDISCH_TAC ` ~collinear {(v1:real^3), v2, v3}` THEN 
PHA THEN 
REWRITE_TAC[GSYM d3] THEN 
NHANH (SPEC_ALL SDIHJZK_INTERPRETE) THEN 
STRIP_TAC THEN 
EXISTS_TAC ` (v0:real^3) + sqrt (h) % nor ` THEN 
CONJ_TAC THENL [
ASM_MESON_TAC[SQRT_WORKS; d3; aff];  
UNDISCH_TAC ` !x y. {x, y} SUBSET affine hull {v1, v2, v3} 
  ==> (nor:real^3) dot (x - y) = &0`] THEN 
NHANH (MESON[]` (! x y. P x y ) ==> P v0 v1 /\ P v0 v2 /\ P v0 v3 `) THEN 
SIMP_TAC[SET2_SU_EX; GSYM aff; THREE_GEN_POINTS_IN_AFF3 ] THEN 
UNDISCH_TAC ` (v0:real^3) IN aff {v1, v2, v3}` THEN 
SIMP_TAC[] THEN 
NHANH (MESON[REAL_MUL_RZERO; DOT_LMUL]`nor dot v = &0 ==>
  sqrt h % nor dot v = &0 `) THEN 
SIMP_TAC[ORTHOGONAL_IMP_PITHAGOR; d3; NORM_MUL; REAL_ARITH ` (a * b ) pow 2 = 
a pow 2 * b pow 2 `;  REAL_POW2_ABS] THEN 
STRIP_TAC THEN 
STRIP_TAC THEN 
UNDISCH_TAC ` &0 <= h ` THEN 
UNDISCH_TAC` norm (nor:real^3) = &1` THEN 
SIMP_TAC[SQRT_WORKS; REAL_ARITH` &1 pow 2 = &1`; REAL_MUL_RID] THEN 
REPLICATE_TAC 2 DISCH_TAC THEN 
UNDISCH_TAC `a01 - h = d3 v0 v1 pow 2` THEN 
UNDISCH_TAC `a02 - h = d3 v0 v2 pow 2` THEN 
UNDISCH_TAC `a03 - h = d3 v0 v3 pow 2` THEN 
SIMP_TAC[REAL_ARITH` a - b = c <=> c = a - b `; d3 ; 
  REAL_ARITH` a + b - a = b `] THEN 
REPEAT STRIP_TAC THENL [
UNDISCH_TAC` vv0 IN aff_ge {v1, v2, v3} {(v4:real^3)} ` THEN 
UNDISCH_TAC ` !x. (x:real^3) IN aff_ge {v1, v2, v3} {v4} <=>
          (?xx h.
               xx IN affine hull {v1, v2, v3} /\ &0 <= h /\ x = xx + h % nor) ` THEN 
SIMP_TAC[] THEN 
REPEAT STRIP_TAC THEN 
REPLICATE_TAC 7 (FIRST_X_ASSUM MP_TAC) THEN PHA THEN DAO THEN 

PURE_ONCE_REWRITE_TAC[MESON[]`a = b /\ P a <=> a = b /\ P b `] THEN 
UNDISCH_TAC`!x y.
          (x:real^3) IN aff {v1, v2, v3} /\ y IN aff {v1, v2, v3}
          ==> nor dot (x - y) = &0 /\ sqrt h % nor dot (x - y) = &0` THEN 
PHA THEN 
NHANH (MESON[THREE_GEN_POINTS_IN_AFF3; aff]`(!x y.
      x IN aff {v1, v2, v3} /\ y IN aff {v1, v2, v3} ==> P x y ) /\
  a1 /\ a2 /\ xx IN affine hull {v1, v2, v3} /\ l ==>
  P xx v1 /\ P xx v2 /\ P xx v3 `) THEN 
NHANH (MESON[DOT_LMUL; REAL_MUL_RZERO]` nor dot (xx - v1) = &0 /\ l ==>
  ( h' % nor) dot ( xx - v1 ) = &0 `) THEN 
DAO THEN 
ONCE_REWRITE_TAC[MESON[]` a1/\a2/\a3/\a4/\a5/\a6/\a7/\l ==> las
  <=> a1/\a2/\a3/\a4/\a5/\a6/\a7 ==> l ==> las `] THEN 
SIMP_TAC[ORTHOGONAL_IMP_PITHAGOR] THEN 
REWRITE_TAC[MESON[]` a1 /\a2/\a3/\ (! x. P x ) /\ l <=> (a1 /\a2/\a3)
  /\ (! x. P x ) /\ l`] THEN 
REWRITE_TAC[REAL_ARITH` c + a = aa /\ c + b = bb /\ c + d = dd
  <=> c + a = aa /\ a - b = aa - bb /\ d - b = dd - bb `] THEN 
REPLICATE_TAC 3 (FIRST_X_ASSUM MP_TAC) THEN 
PHA THEN 
SIMP_TAC[MESON[]` a1/\a2/\a3/\a4 <=> (a1/\a2/\a3)/\a4 `] THEN 
REWRITE_TAC[REAL_ARITH` a3 = aa3 - h /\ a2 = aa2 - h /\ 
  a1 = aa1 - h <=> a2 - a1 = aa2 - aa1 /\ a3 - a1 = aa3 - aa1 /\
  a3 = aa3 - h `] THEN 
STRIP_TAC THEN 

UNDISCH_TAC`dist ((v0:real^3),v2) pow 2 - dist (v0,v1) pow 2 = a02 - a01` THEN 
UNDISCH_TAC`dist ((v0:real^3),v3) pow 2 - dist (v0,v1) pow 2 = a03 - a01` THEN 
UNDISCH_TAC`dist ((xx:real^3),v2) pow 2 - dist (xx,v1) pow 2 = a02 - a01` THEN 
UNDISCH_TAC`dist ((xx:real^3),v3) pow 2 - dist (xx,v1) pow 2 = a03 - a01` THEN 

UNDISCH_TAC `(v0:real^3) IN aff {v1, v2, v3}` THEN 
UNDISCH_TAC `(xx:real^3) IN affine hull {v1, v2, v3}` THEN 
PHA THEN 
REWRITE_TAC[MESON[]` a1 = a /\ b1 = b /\ a2 = a /\ b2 = b <=>
  a1 = a /\ b1 = b /\ b1 = b2 /\ a1 = a2 `] THEN 
REWRITE_TAC[aff; MESON[SET2_SU_EX]`  a IN s /\ b IN s /\ a1 
  /\a2 /\ l <=> a1/\a2/\ {a,b} SUBSET s /\ l `] THEN 
NHANH (SPEC_ALL EQ_SUB_DIST_POW2_IMP_IDENTIFIED) THEN 
UNDISCH_TAC ` dist ((v0:real^3),v3) pow 2 = a03 - h` THEN 
UNDISCH_TAC` norm (h' % (nor:real^3)) pow 2 + dist ((xx:real^3),v2) pow 2 = a02` THEN 
PHA THEN DAO THEN 
REWRITE_TAC[MESON[]` a /\ b ==> c <=> a ==> b ==> c `] THEN 
SIMP_TAC[REAL_ARITH` a - b = c <=> a = b + c `] THEN 
SIMP_TAC[REAL_ARITH` a + b + c = d <=> b = d - a - c `] THEN 
REWRITE_TAC[REAL_ARITH` a02 - norm (h' % nor) pow 2 - (a02 - a01) + a03 - a01 = a03 - h
  <=> norm (h' % nor) pow 2 = h `] THEN 
REPLICATE_TAC 7 DISCH_TAC THEN 
SIMP_TAC[NORM_MUL; REAL_ARITH` (a*b) pow 2 = a pow 2 * b pow 2 `;
  REAL_POW2_ABS] THEN 
UNDISCH_TAC` norm (nor:real^3) = &1 ` THEN 
SIMP_TAC[REAL_ARITH` a * &1 pow 2 = a `] THEN 
UNDISCH_TAC ` &0 <= h ` THEN 
UNDISCH_TAC ` &0 <= h' ` THEN 
MESON_TAC[SQRT_WORKS; EQ_POW2_COND];




EQ_TAC THENL[
UNDISCH_TAC `(v0:real^3) IN aff {v1, v2, v3}` THEN 
UNDISCH_TAC` !(x:real^3) y.
          x IN aff {v1, v2, v3} /\ y IN aff {v1, v2, v3}
          ==> nor dot (x - y) = &0 /\ sqrt h % nor dot (x - y) = &0 ` THEN 
PHA THEN 
NHANH (MESON[]` (! x y. x IN aff {v1, v2, v3} /\ y IN aff {v1, v2, v3} ==> l x y ) 
  /\ a IN aff {v1, v2, v3} /\ b IN aff {v1, v2, v3} ==> l a b `) THEN 
REWRITE_TAC[VECTOR_ARITH` a - ( a + s % x ) = ( -- s ) % x `;
  DOT_RMUL; GSYM NORM_POW_2] THEN 
UNDISCH_TAC ` norm (nor:real^3) = &1 ` THEN 
SIMP_TAC[REAL_ARITH` a * &1 pow 2 = a `; DOT_LMUL; GSYM NORM_POW_2;
  REAL_ARITH` ( -- a ) * a = &0 <=> a pow 2 = &0 `] THEN 
UNDISCH_TAC` &0 <= h ` THEN 
UNDISCH_TAC` delta (a01 - h) (a02 - h) (a03 - h) (d3 v1 v2 pow 2) (d3 v1 v3 pow 2)
      (d3 v2 v3 pow 2) =
      &0 ` THEN 
SIMP_TAC[SQRT_WORKS; d3] THEN 
MESON_TAC[REAL_ARITH` a - &0 = a `];
ABBREV_TAC ` tu = delta a01 a02 a03 (dist ((v1:real^3),v2) pow 2) (dist (v1,v3) pow 2)
 (dist (v2,v3) pow 2) ` THEN 
UNDISCH_TAC` h =
      tu /
      ups_x (dist ((v1:real^3),v2) pow 2) (dist (v1,v3) pow 2) (dist (v2,v3) pow 2)` THEN 
PHA THEN SIMP_TAC[REAL_ARITH` &0 / a = &0 `] THEN 
STRIP_TAC THEN 
SIMP_TAC[SQRT_0; VECTOR_MUL_LZERO; VECTOR_ADD_RID] THEN 
UNDISCH_TAC` (v0:real^3) IN aff {v1, v2, v3}` THEN 
SIMP_TAC[]]]);;

(* END *)












let PROVE_THE_HYPOTHESI_FOR_74 = prove(` (let s = {v1, v2, v3, v4} in
         CARD s = 4 /\

         ~coplanar s /\
         eta_y (d3 v1 v2 ) (d3 v1 v3) (d3 v2 v3) <= r )
==> ( let x12 = d3 v1 v2 pow 2 in
     let x13 = d3 v1 v3 pow 2 in
     let x23 = d3 v2 v3 pow 2 in
     CARD {v1, v2, v3, v4} = 4 /\

     ~coplanar {v1, v2, v3, v4} /\
     &0 <= r pow 2 /\
     &0 <= r pow 2 /\
     &0 <= r pow 2 /\
     delta (r pow 2) (r pow 2) (r pow 2) x12 x13 x23 >= &0 ) `,
REPEAT LET_TAC THEN 
SIMP_TAC[REAL_LE_POW_2] THEN 
REWRITE_TAC[DELTA_RRR_INTERPRETE] THEN 
EXPAND_TAC "s" THEN 
NHANH (MESON[COLLINEAR_IMP_COPLANAR]` ~ coplanar {v1, v2, v3, v} ==>
  ~ collinear {v1, v2, (v3:real^3)} `) THEN 
REWRITE_TAC[NOT_COL_EQ_UPS_X_POS] THEN 
EXPAND_TAC "x12" THEN 
EXPAND_TAC "x13" THEN 
EXPAND_TAC "x23" THEN 
REWRITE_TAC[d3] THEN 
SIMP_TAC[REAL_FIELD` &0 < a ==> -- x * y + r * a = a * ( r - (x * y ) / a )`] THEN 
SIMP_TAC[ETA_Y_POW2_EQ;d3; ETA_Y_SYYM] THEN 
MP_TAC ETA_Y_POS_LE THEN 
DAO THEN PHA THEN 
REWRITE_TAC[d3] THEN DAO THEN 
NHANH (MESON[POS_IMP_POW2]` a <= b /\ &0 <= a ==> 
  a pow 2 <= b pow 2 `) THEN 
ONCE_REWRITE_TAC[REAL_ARITH` a <= b <=> &0 <= b - a `] THEN 
REWRITE_TAC[REAL_ARITH` a >= &0 <=> &0 <= a `] THEN 
SIMP_TAC[REAL_LT_IMP_LE; REAL_LE_MUL]);;



(*   OFGJQUS       *)
(* LEMMA 74 *)

let LFYTDXC = prove(` ? p. ! v1 v2 v3 (v4:real^3) r.
  let s = {v1, v2, v3, v4} in
         CARD s = 4 /\

         ~coplanar s /\
         eta_y (d3 v1 v2 ) (d3 v1 v3 ) (d3 v2 v3 ) <= r
         ==> p v1 v2 v3 v4 r IN aff_ge {v1, v2, v3} {v4} /\
                   r = d3 ( p v1 v2 v3 v4 r ) v1 /\
                   r = d3 ( p v1 v2 v3 v4 r ) v2 /\
                   r = d3 ( p v1 v2 v3 v4 r )  v3 /\
                   (!w. w IN aff_ge {v1, v2, v3} {v4} /\
                        r = d3 w v1 /\
                        r = d3 w v2 /\
                        r = d3 w v3
                        ==> w = ( p v1 v2 v3 v4 r ) ) `,
REWRITE_TAC[GSYM SKOLEM_THM] THEN 
REPEAT GEN_TAC THEN (MP_TAC PROVE_THE_HYPOTHESI_FOR_74 ) THEN LET_TAC THEN 
REWRITE_TAC[RIGHT_EXISTS_IMP_THM] THEN 
MP_TAC (SPECL [`v1:real^3`;`v2:real^3`;`v3:real^3`;` v4:real^3`;
  ` r pow 2 `; ` r pow 2 `; ` r pow 2 `] OFGJQUS) THEN REPEAT LET_TAC THEN 
REWRITE_TAC[MESON[]` ( a ==> b ) ==> a ==> c <=> a /\ b ==> c`]
 THEN EXPAND_TAC "s" THEN REWRITE_TAC[MESON[]` ( a ==> b) ==> c /\ a ==> l <=> 
  a /\ b /\ c ==> l `] THEN MATCH_MP_TAC (MESON[]` (c /\ b ==> l ) ==> 
a /\ b /\ c ==> l `) THEN NHANH (MESON[ETA_Y_POS_LE; REAL_LE_TRANS]
` eta_y (d3 v1 v2) (d3 v1 v3) (d3 v2 v3) <= r  ==> &0 <= r `    ) THEN 
STRIP_TAC THEN EXISTS_TAC `v0:real^3` THEN ASM_MESON_TAC[D3_POS_LE;
 GSYM EQ_POW2_COND]);;



let LEMMA74 = LFYTDXC;;
let point_eq = new_specification ["point_eq"] LFYTDXC;;



let INSERT_SUBSET = SET_RULE` {} SUBSET s /\
  ( ( a INSERT s ) SUBSET ss <=> a IN ss /\ s SUBSET  ss ) `;;


let IMP_TAC = REWRITE_TAC[MESON[]` a /\ b ==> c <=> a ==> b ==> c `];;

let IMP_OTHORGONAL_AFF3 = prove(`!v1 v2 v3 u.
     u dot (v1 - v2) = &0 /\ u dot (v1 - v3) = &0
     ==> (!x y. {x, y} SUBSET aff {v1, v2, v3} ==> u dot (x - y) = &0)`,
REWRITE_TAC[aff; AFFINE_HULL_3; INSERT_SUBSET; IN_ELIM_THM] THEN 
REPEAT STRIP_TAC THEN DOWN_TAC THEN 
REWRITE_TAC[MESON[]` a /\ b ==> c <=> a ==> b ==> c `] THEN 
SIMP_TAC[REAL_ARITH` a + b = &1 <=> a = &1 - b `] THEN 
REWRITE_TAC[VECTOR_ARITH` ((&1 - (v + w)) % v1 + v % v2 + w % v3) -
      ((&1 - (v' + w')) % v1 + v' % v2 + w' % v3) =
  ( v' - v ) % ( v1 - v2 ) + ( w' - w ) % ( v1 - v3 ) `] THEN REPEAT STRIP_TAC
 THEN ASM_SIMP_TAC[DOT_RADD; DOT_RMUL; ZERO_NEUTRAL]);;


(* MONG7_ROI *)

let DIST_EQ_IMP_OTHORGONAL = prove(` ! a b p q. dist (p,a) = dist (p,b) /\ dist (q,a) = dist(q,b) 
==> ( p - q ) dot ( a - b ) = &0 `,
REWRITE_TAC[MONG7_ROI; DOT_LSUB] THEN REAL_ARITH_TAC);;

let NOT_COPLANAR_IMP_NOT_COLLINEAR =
  MATCH_MP (MESON[]` (a ==> b) ==> ~ b ==> ~ a `) (SPEC_ALL COLLINEAR_IMP_COPLANAR);;


(* LEMMA 75 *)
let TIEEBHT = prove(` !v1 v2 v3 (v4:real^3) r p p' u. let s = {v1,v2,v3,v4} in
let x12 = d3 v1 v2  in
let x13 = d3 v1 v3  in
let x23 = d3 v2 v3  in
~ coplanar s /\
CARD s = 4 /\
eta_y x12 x13 x23 <= r /\
p' = point_eq v1 v2 v3 v4 r /\
p = circumcenter {v1,v2,v3} /\ u IN aff {v1,v2,v3} ==>
( p' - p ) dot ( u - p ) = &0 `,
REPEAT STRIP_TAC THEN LET_TR THEN NHANH NOT_COPLANAR_IMP_NOT_COLLINEAR THEN 
NHANH PRE_RADV_COND THEN MP_TAC ( SPEC_ALL point_eq) THEN LET_TR THEN 
REWRITE_TAC[MESON[]` ( a /\ b /\ c ==> l ) ==>
  ( b /\ bb ) /\ a /\ c /\ las ==> ll <=>
  a /\ b /\ c /\ bb /\ las /\ l ==> ll `] THEN 
NGOAC THEN REWRITE_TAC[MESON[]` a /\ p = circumcenter {v1, v2, v3} 
  <=> p = circumcenter {v1, v2, v3} /\ a `] THEN PHA THEN 
NHANH (SPEC_ALL CIRCUMCENTER_PROPTIES) THEN 
REWRITE_TAC[MESON[]` a = b /\ P b <=> a = b /\ P a `] THEN 
REWRITE_TAC[REWRITE_RULE[IN] FORALL_IN_CLAUSES] THEN 
REWRITE_TAC[MESON[]`(? c. c = a /\ c = b /\ c = d ) <=>
   a = b /\ a = d `; MESON[]` r = a /\ r = b /\ r = c /\ l <=>
  a = b /\ a = c /\ r = c /\ l `; d3] THEN 
NHANH (MESON[DIST_EQ_IMP_OTHORGONAL]` (dist (p,v1) = dist (p,v2) /\ 
dist (p,v1) = dist (p,v3)) /\ a1 /\a2 /\a3/\ dist (p',v1) = dist (p',v2) /\
 dist (p',v1) = dist (p',v3) /\ l ==>  ( p' - p ) dot ( v1 - v2 ) = &0 /\
  (p' - p ) dot ( v1 - v3 ) = &0 `) THEN 
REWRITE_TAC[GSYM aff] THEN STRIP_TAC THEN 
UNDISCH_TAC` (p:real^3) IN aff {v1, v2, v3}` THEN 
UNDISCH_TAC` (u:real^3) IN aff {v1, v2, v3}` THEN 
PHA THEN REWRITE_TAC[GSYM SET2_SU_EX] THEN 
REPLICATE_TAC 2 (FIRST_X_ASSUM MP_TAC) THEN PHA THEN 
MESON_TAC[IMP_OTHORGONAL_AFF3 ]);;


(* lemma 89 *)
let PVLJZLA = prove( `! (v1:real^3) v2 v3 v4.
     let s = {v1, v2, v3, v4} in
     ~coplanar s
     ==> (circumcenter s IN conv0 s <=>
          orientation s v1 (\x. &0 < x) /\
          orientation s v2 (\x. &0 < x) /\
          orientation s v3 (\x. &0 < x) /\
          orientation s v4 (\x. &0 < x))`,
REWRITE_TAC[orientation; affsign] THEN 
REPEAT GEN_TAC THEN 
LET_TR THEN 
REWRITE_TAC[lin_combo] THEN 
REWRITE_TAC[SET_RULE` s DIFF {a} UNION {a} = s UNION {a} `;
  SET_RULE` {a,b,c,d} UNION {a} = {a,b,c,d} /\
  {a,b,c,d} UNION {b} = {a,b,c,d} /\
  {a,b,c,d} UNION {c} = {a,b,c,d} /\
  {a,b,c,d} UNION {d} = {a,b,c,d}`] THEN 
REWRITE_TAC[MESON[]`a = b /\ c /\ d <=> c /\ d /\ b = a `] THEN 
REWRITE_TAC[SET_RULE` (!w. {v1} w ==> &0 < f w) /\
           sum {v1, v2, v3, v4} f = &1 /\ l
  <=> (!w. w IN {v1,v2,v3,v4} ==> {v1} w ==> &0 < f w) /\
  sum {v1, v2, v3, v4} f = &1 /\ l `;
  SET_RULE` (!w. {v2} w ==> &0 < f w) /\
           sum {v1, v2, v3, v4} f = &1 /\ l
  <=> (!w. w IN {v1,v2,v3,v4} ==> {v2} w ==> &0 < f w) /\
  sum {v1, v2, v3, v4} f = &1 /\ l `;
  SET_RULE` (!w. {v2} w ==> &0 < f w) /\
           sum {v1, v2, v3, v4} f = &1 /\ l
  <=> (!w. w IN {v1,v2,v3,v4} ==> {v2} w ==> &0 < f w) /\
  sum {v1, v2, v3, v4} f = &1 /\ l `;
  SET_RULE` (!w. {v3} w ==> &0 < f w) /\
           sum {v1, v2, v3, v4} f = &1 /\ l
  <=> (!w. w IN {v1,v2,v3,v4} ==> {v3} w ==> &0 < f w) /\
  sum {v1, v2, v3, v4} f = &1 /\ l `;
  SET_RULE` (!w. {v4} w ==> &0 < f w) /\
           sum {v1, v2, v3, v4} f = &1 /\ l
  <=> (!w. w IN {v1,v2,v3,v4} ==> {v4} w ==> &0 < f w) /\
  sum {v1, v2, v3, v4} f = &1 /\ l `] THEN 
 SIMP_TAC[AFFINE_HULL_FINITE_STEP_GEN;
            REAL_ARITH `&0 < x /\ &0 < y  ==> &0 < x + y`;
            REAL_ARITH ` &0 < x ==> &0 < x / &2`;
            FINITE_INSERT; CONJUNCT1 FINITE_RULES
; RIGHT_EXISTS_AND_THM]  THEN 
NHANH (NOT_COPLANAR_IMP_CARD4) THEN 
SIMP_TAC[IN_ACT_SING; CARD4; IN_SET3; DE_MORGAN_THM] THEN 
REWRITE_TAC[REAL_ARITH` a - b = c <=> a = b + c `; ZERO_NEUTRAL;
  VECTOR_ARITH`(a:real^N) - b = c <=> a = b + c `; VECTOR_ARITH` x +
  vec 0 = x `] THEN 
REWRITE_TAC[CONV0_4; IN_ELIM_THM] THEN 
NHANH (SPEC ` circumcenter {(v1:real^3), v2, v3, v4} ` ( GEN `v:real^3` (SPEC_ALL COEFS_4))) THEN 
STRIP_TAC THEN 
EQ_TAC THENL [
MESON_TAC[]; 
UNDISCH_TAC ` !ta tb tc td.
          circumcenter {v1, v2, v3, v4} =
          ta % v1 + tb % v2 + tc % v3 + td % v4 /\
          ta + tb + tc + td = &1
          ==> ta = COEF4_1 v1 v2 v3 v4 (circumcenter {v1, v2, v3, v4}) /\
              tb = COEF4_2 v1 v2 v3 v4 (circumcenter {v1, v2, v3, v4}) /\
              tc = COEF4_3 v1 v2 v3 v4 (circumcenter {v1, v2, v3, v4}) /\
              td = COEF4_4 v1 v2 v3 v4 (circumcenter {v1, v2, v3, v4})` THEN 
REWRITE_TAC[MESON[]`&0 < v /\ ( ? b . P v b ) <=>
  (? b. &0 < v /\ P v b ) `] THEN 
REWRITE_TAC[MESON[]` &1 = a /\ aa = b <=> a = &1 /\ b = aa `] THEN 
ABBREV_TAC ` (vv:real^3) = circumcenter {v1, v2, v3, v4} ` THEN 
ABBREV_TAC ` a1 = COEF4_1 v1 v2 v3 v4 vv ` THEN 
ABBREV_TAC ` a2 = COEF4_2 v1 v2 v3 v4 vv ` THEN 
ABBREV_TAC ` a3 = COEF4_3 v1 v2 v3 v4 vv ` THEN 
ABBREV_TAC ` a4 = COEF4_4 v1 v2 v3 v4 vv ` THEN PHA THEN 
IMP_TAC THEN STRIP_TAC THEN STRIP_TAC THEN 
REPLICATE_TAC 4 (FIRST_X_ASSUM MP_TAC) THEN PHA THEN 
NHANH (MESON[]`(!ta tb tc td.
      vv = ta % v1 + tb % v2 + tc % v3 + td % v4 /\ ta + tb + tc + td = &1
      ==> ta = a1 /\ tb = a2 /\ tc = a3 /\ td = a4) /\
 a111  /\
 v + v' + v'' + v''' = &1 /\
 v % v1 + v' % v2 + v'' % v3 + v''' % v4 = vv /\
 (?v v' v'' v'''.
      &0 < v' /\
      v + v' + v'' + v''' = &1 /\
      v % v1 + v' % v2 + v'' % v3 + v''' % v4 = vv) /\
 (?v v' v'' v'''.
      &0 < v'' /\
      v + v' + v'' + v''' = &1 /\
      v % v1 + v' % v2 + v'' % v3 + v''' % v4 = vv) /\
 (?v v' v'' v'''.
      &0 < v''' /\
      v + v' + v'' + v''' = &1 /\
      v % v1 + v' % v2 + v'' % v3 + v''' % v4 = vv) ==>
  &0 < v' /\ &0 < v'' /\ &0 < v''' `) THEN MESON_TAC[]]);;




let IMP_IN_AFF_LT = prove(`CARD {v1, v2, v3, v4} = 4 ==> ( (?v v' v'' v'''.
           v < &0 /\
           &1 = v + v' + v'' + v''' /\ vv =
           v % v1 + v' % v2 + v'' % v3 + v''' % v4) <=>
  vv IN aff_lt {v2,v3,v4} {v1} ) `,
REWRITE_TAC[CARD4; IN_SET3; DE_MORGAN_THM] THEN SIMP_TAC[AFF_GES_GTS; IN_ELIM_THM]
THEN REMOVE_TAC THEN 
MESON_TAC[REAL_ARITH` a + b + c + d = d + a + b + c `;
  VECTOR_ARITH` a + b + c + d = d + a + b + (c:real^N)`]);;




(* LEMMA 85 *)
let VBVYGGT = new_axiom `!(v1:real^3) v2 v3 v4.
         CARD {v1, v2, v3, v4} = 4 /\ ~coplanar {v1, v2, v3, v4}
         ==> circumcenter {v1, v2, v3, v4} IN affine hull {v1, v2, v3, v4} /\
             (?r. !v. v IN {v1, v2, v3, v4}
                      ==> r = dist (circumcenter {v1, v2, v3, v4},v)) /\
             (!p. p IN affine hull {v1, v2, v3, v4} /\
                  (?r. !v. v IN {v1, v2, v3, v4} ==> r = dist (p,v))
                  ==> p = circumcenter {v1, v2, v3, v4}) /\
             (let x12 = dist (v1,v2) pow 2 in
              let x13 = dist (v1,v3) pow 2 in
              let x14 = dist (v1,v4) pow 2 in
              let x23 = dist (v2,v3) pow 2 in
              let x24 = dist (v2,v4) pow 2 in
              let x34 = dist (v3,v4) pow 2 in
              let chi11 = chi x12 x13 x14 x23 x24 x34 in
              let chi22 = chi x12 x24 x23 x14 x13 x34 in
              let chi33 = chi x34 x13 x23 x14 x24 x12 in
              let chi44 = chi x34 x24 x14 x23 x13 x12 in
              circumcenter {v1, v2, v3, v4} =
              &1 / (&2 * delta x12 x13 x14 x23 x24 x34) %
              (chi11 % v1 + chi22 % v2 + chi33 % v3 + chi44 % v4)) `;;






(* lemma 88 *)
let VSMPQYO = prove(` ! v1 v2 v3 (v4:real^3).
         CARD {v1, v2, v3, v4} = 4 /\ ~ coplanar {v1,v2,v3,v4} 
         ==> (let s = {v1, v2, v3, v4} in
              let x12 = dist (v1,v2) pow 2 in
              let x13 = dist (v1,v3) pow 2 in
              let x14 = dist (v1,v4) pow 2 in
              let x23 = dist (v2,v3) pow 2 in
              let x24 = dist (v2,v4) pow 2 in
              let x34 = dist (v3,v4) pow 2 in
              orientation s v1 (\t. t < &0) <=>
              chi x12 x13 x14 x23 x24 x34 < &0) `,
REWRITE_TAC[orientation; affsign; lin_combo] THEN REPEAT GEN_TAC THEN 
LET_TAC THEN EXPAND_TAC "s" THEN 
REWRITE_TAC[CARD4; SET_RULE` ( a INSERT s) DIFF {a} UNION {a} = 
  a INSERT s `] THEN 
REWRITE_TAC[MESON[]` a = b /\ c /\ d <=> c /\ d /\ b = a `] THEN 
ONCE_REWRITE_TAC[SET_RULE` {v1} w ==> P <=> w IN {v1,v2,v3,v4} ==>
  {v1} w ==> P `] THEN  SIMP_TAC[AFFINE_HULL_FINITE_STEP_GEN;
            REAL_ARITH `x < &0 /\ y < &0 ==> x + y < &0`;
            REAL_ARITH `x < &0 ==> x / &2 < &0`;
            FINITE_INSERT; CONJUNCT1 FINITE_RULES
; RIGHT_EXISTS_AND_THM]  THEN 
SIMP_TAC[IN_ACT_SING; IN_SET3; DE_MORGAN_THM] THEN 
SIMP_TAC[REAL_ARITH` a - b = c <=> a = b + c `; ZERO_NEUTRAL;
  VECTOR_ARITH` a - b = c <=> a = b + (c:real^y)`; VECTOR_ADD_RID;
  RIGHT_AND_EXISTS_THM] THEN 
REWRITE_TAC[GSYM DE_MORGAN_THM; GSYM IN_SET3] THEN 
REWRITE_TAC[DE_MORGAN_THM] THEN 
REWRITE_TAC[MESON[]` a1 /\ ~ a /\ ~ b /\ ~ ( c = d )  <=> a1 /\ ~ ( a \/ b \/ 
  c = d ) `; GSYM CARD4 ] THEN NHANH (SPEC_ALL VBVYGGT) THEN STRIP_TAC THEN 
UNDISCH_TAC ` CARD {(v1:real^3), v2, v3, v4} = 4` THEN 
SIMP_TAC[IMP_IN_AFF_LT ] THEN 
UNDISCH_TAC `~coplanar {(v1:real^3), v2, v3, v4}` THEN 
SIMP_TAC[ GSYM SRGTIHY] THEN 
NHANH (SPECL [` v1:real^3`; `v2:real^3`;`v3:real^3`;`v4:real^3`; 
  ` circumcenter {(v1:real^3), v2, v3, v4} `] COEFS_4) THEN 
MP_TAC (GEN_ALL SUM_CHI_EQ_2DELTA ) THEN 
ABBREV_TAC ` p = circumcenter {(v1:real^3), v2, v3, v4}` THEN 
ABBREV_TAC `c1 = COEF4_1 v1 v2 v3 v4 p` THEN 
ABBREV_TAC `c2 = COEF4_2 v1 v2 v3 v4 p` THEN 
ABBREV_TAC `c3 = COEF4_3 v1 v2 v3 v4 p` THEN 
ABBREV_TAC `c4 = COEF4_4 v1 v2 v3 v4 p` THEN 
PHA THEN STRIP_TAC THEN 
REPLICATE_TAC 12 (FIRST_X_ASSUM MP_TAC) THEN 
REPEAT LET_TAC THEN EXPAND_TAC "chi11" THEN 
EXPAND_TAC "chi22" THEN EXPAND_TAC "chi33" THEN 
EXPAND_TAC "chi44" THEN 
REWRITE_TAC[VECTOR_ADD_LDISTRIB; VECTOR_MUL_ASSOC; 
  REAL_ARITH` ( &1 / a ) * b = b / a `] THEN 
REWRITE_TAC[GSYM POS_EQ_NOT_COPLANANR ] THEN 
REPLICATE_TAC 7 STRIP_TAC THEN 
UNDISCH_TAC ` dist ((v1:real^3),v2) pow 2 = x12 ` THEN 
UNDISCH_TAC ` dist ((v1:real^3),v3) pow 2 = x13 ` THEN 
UNDISCH_TAC ` dist ((v1:real^3),v4) pow 2 = x14 ` THEN 
UNDISCH_TAC ` dist ((v2:real^3),v3) pow 2 = x23 ` THEN 
UNDISCH_TAC ` dist ((v2:real^3),v4) pow 2 = x24 ` THEN 
UNDISCH_TAC ` dist ((v3:real^3),v4) pow 2 = x34 ` THEN 
REWRITE_TAC[MESON[]` a = b ==> P a <=> a = b ==> P b `] THEN 
NHANH (REAL_ARITH` &0 < a ==> ~( a = &0 ) `) THEN 
NHANH (NOT_0_IMP_SUM_CHI_1 ) THEN REPEAT STRIP_TAC THEN 
UNDISCH_TAC ` &0 < delta x12 x13 x14 x23 x24 x34 ` THEN 
ONCE_REWRITE_TAC[
prove(` &0 < p a ==> ( aa <=> q a < &0)  <=> &0 < p a ==> ( aa <=> (  q a ) / ( &2 * p a ) < &0 ) `,
REWRITE_TAC[REAL_ARITH` a < &0 <=> &0 < -- a `;
  REAL_ARITH ` -- ( a / b ) = ( -- a ) / b `] THEN 
MESON_TAC[REAL_LT_RDIV_0; REAL_ARITH` &0 < a <=> &0 < &2 * a `])] THEN 
ABBREV_TAC ` c11 = chi x12 x13 x14 x23 x24 x34 / (&2 * delta x12 x13 x14 x23 x24 x34) ` THEN 
ABBREV_TAC ` c22 = chi x12 x24 x23 x14 x13 x34 / (&2 * delta x12 x13 x14 x23 x24 x34) ` THEN 
ABBREV_TAC ` c33 = chi x34 x13 x23 x14 x24 x12 / (&2 * delta x12 x13 x14 x23 x24 x34) ` THEN 
ABBREV_TAC ` c44 = chi x34 x24 x14 x23 x13 x12 / (&2 * delta x12 x13 x14 x23 x24 x34) ` THEN 
REPLICATE_TAC 5 (FIRST_X_ASSUM MP_TAC THEN REMOVE_TAC) THEN 
REPLICATE_TAC 4 (FIRST_X_ASSUM MP_TAC) THEN UNDISCH_TAC 
` (p:real^3) = c11 % v1 + c22 % v2 + c33 % v3 + c44 % v4` THEN MESON_TAC[]);;












let SQRT4_EQ2 = prove(` sqrt ( &4 ) = &2 `,
REWRITE_TAC[REAL_ARITH` &4 = &2 pow 2 `] THEN 
MESON_TAC[POW_2_SQRT; REAL_ARITH` &0 <= &2 `]);;









let RHUFIIB = prove( ` !x12 x13 x14 x23 x24 x34.
         rho x12 x13 x14 x23 x24 x34 * ups_x x34 x24 x23 =
         chi x12 x13 x14 x23 x24 x34 pow 2 +
         &4 * delta x12 x13 x14 x23 x24 x34 * x34 * x24 * x23 `,
REWRITE_TAC[rho; chi; delta; ups_x] THEN REAL_ARITH_TAC);;


(* lemma 84 *)
let SHOGYBS = prove(` ! x1 x2 x3 (x4:real^3).
  ~coplanar {x1,x2,x3,x4} ==>
         let x12 = dist (x1,x2) pow 2 in
         let x13 = dist (x1,x3) pow 2 in
         let x14 = dist (x1,x4) pow 2 in
         let x23 = dist (x2,x3) pow 2 in
         let x24 = dist (x2,x4) pow 2 in
         let x34 = dist (x3,x4) pow 2 in
  &0 <= rho x12 x13 x14 x23 x24 x34  `,
ONCE_REWRITE_TAC[SET_RULE` {v1,v2,v3,v4} =  {v2,v3,v4,v1} `] THEN 
NHANH (NOT_COPLANAR_IMP_NOT_COLLINEAR) THEN 
ONCE_REWRITE_TAC[GSYM (SET_RULE` {v1,v2,v3,v4} =  {v2,v3,v4,v1} `)] THEN 
REWRITE_TAC[NOT_COL_EQ_UPS_X_POS] THEN REPEAT GEN_TAC THEN 
MP_TAC (SPEC_ALL DELTA_POS_4POINTS) THEN 
REPEAT LET_TAC THEN MP_TAC (SPEC_ALL RHUFIIB) THEN DOWN_TAC THEN 
NHANH (MESON[REAL_LE_POW_2]` a pow 2 = b   ==> &0 <= b `) THEN DAO THEN 
SIMP_TAC[UPS_X_SYM] THEN 
REWRITE_TAC[MESON[REAL_FIELD` &0 < a ==> (b * a = c <=> b = c / a )`]`
  &0 < a /\a1 /\a2/\ b * a = c /\l <=>  &0 < a /\a1 /\a2/\ b = c / a /\ l `] THEN 
MP_TAC (REAL_ARITH` &0 <= &4 `) THEN PHA THEN 
NHANH (MESON[REAL_LT_IMP_LE; REAL_LE_DIV;
  REAL_LE_MUL; REAL_LE_ADD; REAL_LE_POW_2]`  &0 <= &4 /\
 &0 < ups_x x23 x24 x34 /\a1/\
 &0 <= delta x12 x13 x14 x23 x24 x34 /\ a2 /\
 &0 <= x34 /\a3 /\ &0 <= x24 /\a4 /\ &0 <= x23 /\a5/\
 &0 <= x14 /\a6 /\ &0 <= x13 /\a7 /\a8 /\ &0 <= x12 ==> 
  &0 <= &4 * delta x12 x13 x14 x23 x24 x34 * x34 * x24 * x23 `) THEN 
ABBREV_TAC ` aaa = &4 * delta x12 x13 x14 x23 x24 x34 * x34 * x24 * x23 ` THEN STRIP_TAC THEN 
FIRST_X_ASSUM MP_TAC THEN UNDISCH_TAC ` rho x12 x13 x14 x23 x24 x34 =
      (chi x12 x13 x14 x23 x24 x34 pow 2 + aaa) / ups_x x23 x24 x34 ` THEN 
UNDISCH_TAC`&0 < ups_x x23 x24 x34` THEN MESON_TAC[REAL_LT_IMP_LE; REAL_LE_DIV;
  REAL_LE_MUL; REAL_LE_ADD; REAL_LE_POW_2]);;


(* le 86 . GDRQXLG *)


let GDRQXLG = prove(` ! v1 v2 v3 (v4:real^3).
  let s = {v1, v2, v3, v4} in
let x12 = dist (v1,v2) pow 2 in
                    let x13 = dist (v1,v3) pow 2 in
                    let x14 = dist (v1,v4) pow 2 in
                    let x23 = dist (v2,v3) pow 2 in
                    let x24 = dist (v2,v4) pow 2 in
                    let x34 = dist (v3,v4) pow 2 in
     CARD s = 4 /\ ~coplanar s
     ==> radV s =
        sqrt ( rho x12 x13 x14 x23 x24 x34) /
         (&2 * sqrt (delta x12 x13 x14 x23 x24 x34))`,
REPEAT GEN_TAC THEN REPEAT LET_TAC THEN EXPAND_TAC "s" THEN 
NHANH (NOT_COPLANAR_IMP_RADV_PROPERTIES) THEN 
NHANH (REWRITE_RULE[RIGHT_FORALL_IMP_THM] (GEN `p:real^3` PROVE_DIST_FROM_V1  )) THEN 
NHANH (REWRITE_RULE[RIGHT_FORALL_IMP_THM] (GEN `p:real^3` PROVE_EQ_DIST_FROM4 ) ) THEN 
REWRITE_TAC[GSYM POS_EQ_NOT_COPLANANR] THEN 
NHANH (REAL_ARITH` &0 < a ==> ~( a = &0 )`) THEN 
NHANH (PROVE_IN_AFFINE_HULL_4 ) THEN LET_TR THEN 
REWRITE_TAC[MESON[]`(!x. x = a ==> p x) <=> p a `] THEN 
ABBREV_TAC `taa = (&1 /    (&2 *
     delta (dist (v1,v2) pow 2) (dist (v1,v3) pow 2) (dist (v1,v4) pow 2)
     (dist (v2,v3) pow 2)
     (dist (v2,v4) pow 2)
     (dist (v3,v4) pow 2)) %
    (chi (dist (v1,v2) pow 2) (dist (v1,v3) pow 2) (dist (v1,v4) pow 2)
     (dist (v2,v3) pow 2)
     (dist (v2,v4) pow 2)
     (dist (v3,v4) pow 2) %
     (v1:real^3) +
     chi (dist (v1,v2) pow 2) (dist (v2,v4) pow 2) (dist (v2,v3) pow 2)
     (dist (v1,v4) pow 2)
     (dist (v1,v3) pow 2)
     (dist (v3,v4) pow 2) %
     v2 +
     chi (dist (v3,v4) pow 2) (dist (v1,v3) pow 2) (dist (v2,v3) pow 2)
     (dist (v1,v4) pow 2)
     (dist (v2,v4) pow 2)
     (dist (v1,v2) pow 2) %
     v3 +
     chi (dist (v3,v4) pow 2) (dist (v2,v4) pow 2) (dist (v1,v4) pow 2)
     (dist (v2,v3) pow 2)
     (dist (v1,v3) pow 2)
     (dist (v1,v2) pow 2) %
     v4)) ` THEN 
REWRITE_TAC[ POS_EQ_NOT_COPLANANR] THEN NGOAC THEN 
NHANH (SPEC_ALL UNIQUE_EXISISTING_PROPERTY_C4 ) THEN 
REWRITE_TAC[FORALL_IN_CLAUSES] THEN ABBREV_TAC ` abc = &1 / &2 *
 rho (dist (v1,v2) pow 2) (dist (v1,v3) pow 2) (dist (v1,v4) pow 2)
 (dist (v2,v3) pow 2) (dist (v2,v4) pow 2) (dist (v3,v4) pow 2) /
 (&2 *
  delta (dist ((v1:real^3),v2) pow 2) (dist (v1,v3) pow 2) (dist (v1,v4) pow 2)
  (dist (v2,v3) pow 2)
  (dist (v2,v4) pow 2)
  (dist (v3,v4) pow 2)) ` THEN REWRITE_TAC[d3] THEN 
NHANH (MESON[POW_2_SQRT; DIST_POS_LE]` dist (taa,v2) pow 2 = a ==>
  dist(taa,v2) = sqrt a `) THEN PHA THEN 
NHANH (MESON[]`(!p. p IN affine hull {v1, v2, v3, v4} /\
      (?r. r = dist (p,v1) /\
           r = dist (p,v2) /\
           r = dist (p,v3) /\
           r = dist (p,v4))
      ==> p = circumcenter {v1, v2, v3, v4}) /\ a11 /\
 taa IN affine hull {v1, v2, v3, v4} /\
 dist (taa,v2) pow 2 = abc /\
 dist (taa,v2) = sqrt abc /\
 dist (taa,v3) pow 2 = abc /\
 dist (taa,v3) = sqrt abc /\
 dist (taa,v4) pow 2 = abc /\
 dist (taa,v4) = sqrt abc /\
 dist (taa,v1) pow 2 = abc /\
 dist (taa,v1) = sqrt abc /\ lll ==> taa = circumcenter {v1, v2, v3, v4} `) THEN 
NHANH (SET_RULE ` (!w. {v1, v2, v3, v4} w ==> P w ) ==> P v1 `) THEN PHA THEN 
REWRITE_TAC[MESON[]` a = dist (aa,b) /\ ta = aa <=> ta = aa  /\ a = dist (ta,b) `] THEN 
NHANH (MESON[]` a = b /\ a1 /\ a2 /\ c = a ==> c = b `) THEN NHANH (SPEC_ALL SHOGYBS) THEN 
MP_TAC (SPECL [`v1:real^3`;` v2:real^3`;`v3:real^3`;`v4:real^3`] 
DELTA_POS_4POINTS) THEN REPEAT LET_TAC THEN IMP_TAC THEN REPEAT (FIRST_X_ASSUM MP_TAC) THEN 
REWRITE_TAC[MESON[]` a = b ==> P a <=> a = b ==> P b `] THEN 
REWRITE_TAC[MESON[]` a = b ==> a = c <=> a = b ==> c = b `] THEN REPEAT STRIP_TAC THEN 
UNDISCH_TAC ` &1 / &2 *      rho x12 x13 x14 x23 x24 x34 / (&2 * delta x12 x13 x14 x23 x24 x34) =
      abc ` THEN UNDISCH_TAC ` &0 <= rho x12 x13 x14 x23 x24 x34 ` THEN 
ABBREV_TAC ` edl = delta x12 x13 x14 x23 x24 x34 ` THEN UNDISCH_TAC` &0 <= edl ` THEN 
SIMP_TAC[REAL_ARITH` &0 <= &4 `; GSYM SQRT_MUL; GSYM SQRT4_EQ2] THEN 
SIMP_TAC[REAL_ARITH` &0 <= &4 `; REAL_LE_MUL;  GSYM SQRT_DIV] THEN 
REWRITE_TAC[SQRT4_EQ2] THEN MESON_TAC[REAL_FIELD` &1 / &2 * x34 / (&2 * edl) =  x34 / (&4 * edl)`]);;


let BAJSVHC =  ` ! v1 v2 v3 v4 (v5:real^3).
   CARD {v1, v2, v3, v4, v5} = 5 /\
     ~coplanar {v1, v2, v3, v4} /\
     v5 IN aff_ge {v1, v3} {v2, v4} /\
     ~(v5 IN aff {v1, v3})
     ==> aff_ge {v1, v3} {v2, v4} =
         aff_ge {v1, v3} {v2, v5} UNION aff_ge {v1, v3} {v4, v5} /\
         aff_gt {v1, v3} {v2, v5} INTER aff_gt {v1, v3} {v4, v5} = {}`;;
let LEMMA104 = BAJSVHC;;





let AFF_GE22 = prove(`!v1 v2 w1 (w2:real^N).
     {v1, v2} INTER {w1, w2} = {}
     ==> aff_ge {v1, v2} {w1, w2} =
         {x | ?a1 a2 b1 b2.
                  &0 <= b1 /\
                  &0 <= b2 /\
                  a1 + a2 + b1 + b2 = &1 /\
                  x = a1 % v1 + a2 % v2 + b1 % w1 + b2 % w2}`,
REWRITE_TAC[aff_ge_def; affsign; FUN_EQ_THM; lin_combo; sgn_ge] THEN 
REWRITE_TAC[MESON[]` (a = aa )/\ (! w. P w ) /\ b <=>
  (!w. P w ) /\ b /\ ( aa = a ) `] THEN 
ONCE_REWRITE_TAC[SET_RULE` {w1, w2} w ==> P w <=> w IN ( v1 INSERT ( v2 
  INSERT {w1, w2} )) ==> {w1, w2} w ==> P w `;
  SET_RULE` {a,b} UNION {c,d} = {a,b,c,d} `] THEN 
SIMP_TAC[AFFINE_HULL_FINITE_STEP_GEN;
            REAL_ARITH `&0 <= x /\ &0 <= y ==> &0 <= x + y`;
            REAL_ARITH `&0 <= x ==> &0 <= x / &2`;
            FINITE_INSERT; CONJUNCT1 FINITE_RULES
; RIGHT_EXISTS_AND_THM]  THEN 
SIMP_TAC[SET_RULE`(!x. ({v1, v2} INTER {w1, w2}) x <=> {} x)
  <=> ~ ({w1,w2} v1 ) /\ ~({w1,w2} v2 )`;
  SET_RULE` {a,b} a /\ {a,b} b `] THEN 
REPEAT STRIP_TAC THEN REWRITE_TAC[RIGHT_AND_EXISTS_THM; IN_ELIM_THM;
  REAL_ARITH` a - b = c <=> a = b + c `; ZERO_NEUTRAL;
  VECTOR_ARITH` a - b = c <=> a = b + (c:real^N)`; VECTOR_ADD_RID;
  REAL_ARITH` &1 = a <=> a = &1 `]);;





let PROVE_UNION_AFF22_SUBSET = prove(` ! v1 v2 v3 v4 (v5:real^3).
   CARD {v1, v2, v3, v4, v5} = 5 /\ ~coplanar {v1, v2, v3, v4} /\
     v5 IN aff_ge {v1, v3} {v2, v4} /\
     ~(v5 IN aff {v1, v3})
     ==>  aff_ge {v1, v3} {v2, v5} UNION aff_ge {v1, v3} {v4, v5} 
 SUBSET aff_ge {v1, v3} {v2, v4} `,
REWRITE_TAC[UNION_SUBSET] THEN 
ONCE_REWRITE_TAC[MESON[INSERT_AC]` a /\ b SUBSET 
  s {v1,v2} <=> a /\ b SUBSET s {v2,v1} `] THEN 
MATCH_MP_TAC (MESON[]` (! v1 v2 v3 v4 v5. P v1 v2 v3 v4 v5 <=>
  P v1 v4 v3 v2 v5 ) /\ (! v1 v2 v3 v4 v5.
  P v1 v2 v3 v4 v5 ==> Q v1 v2 v3 v4 v5 ) ==>
  (! v1 v2 v3 v4 v5. P v1 v2 v3 v4 v5 ==>
  Q v1 v2 v3 v4 v5 /\ Q v1 v4 v3 v2 v5 ) `) THEN 
SIMP_TAC[INSERT_AC] THEN REPEAT GEN_TAC THEN 
ONCE_REWRITE_TAC[SET_RULE ` {a,b,c,d,e} = {e,a,b,c,d}`] THEN 
REWRITE_TAC[CARD5] THEN 
NHANH (SET_RULE` ~(v1 IN {v2, v3, v4}) /\
      ~(v2 = v3 \/ v3 = v4 \/ v4 = v2) ==>
  {v1,v3} INTER {v2,v4} = {} `) THEN 
NHANH (SPEC_ALL AFF_GE22) THEN PHA THEN 
REWRITE_TAC[IN_ELIM_THM; MESON[]` a = b /\ a1 /\ v IN a /\l <=>
  a = b /\ a1 /\ v IN b /\ l`] THEN 
NHANH (SET_RULE` ~(v5 IN {v1, v2, v3, v4}) /\
 ~(v1 IN {v2, v3, v4}) /\
 ~(v2 = v3 \/ v3 = v4 \/ v4 = v2) /\ l ==>
  {v1,v3} INTER {v2,v5} = {} /\
  {v1,v3} INTER {v4,v5} = {} `) THEN 
SIMP_TAC[AFF_GE22] THEN STRIP_TAC THEN 
SIMP_TAC[UNION_SUBSET; SUBSET; IN_ELIM_THM] THEN 
GEN_TAC THEN STRIP_TAC THEN 
UNDISCH_TAC ` x = a1' % v1 + a2' % v3 + b1' % v2 + b2' % (v5:real^3)` THEN 
UNDISCH_TAC ` v5 = a1 % v1 + a2 % v3 + b1 % v2 + b2 % (v4:real^3)` THEN 
PHA THEN 
PURE_ONCE_REWRITE_TAC[MESON[]` a = b /\ P a <=> a = b /\ P (b:real^3) `] THEN 
REWRITE_TAC[VECTOR_ARITH` a1' % v1 + a2' % v3 + b1' % v2 +
 b2' % (a1 % v1 + a2 % v3 + b1 % v2 + b2 % v4) =
  (a1' + b2' * a1 ) % v1 + (a2' + b2' * a2 ) % v3
  + (b1' + b2' * b1 ) % v2 + (b2' * b2 ) % v4 `] THEN 
STRIP_TAC THEN EXISTS_TAC `a1' + b2' * a1` THEN 
EXISTS_TAC `a2' + b2' * a2` THEN 
EXISTS_TAC `b1' + b2' * b1` THEN EXISTS_TAC `b2' * b2` THEN 
ASM_SIMP_TAC[REAL_LE_ADD; REAL_LE_MUL;
prove(`a1 + a2 + b1 + b2 = &1 /\ a1' + a2' + b1' + b2' = &1
 ==> (a1' + b2' * a1) + (a2' + b2' * a2) + (b1' + b2' * b1) + b2' * b2 = &1`,
SIMP_TAC[REAL_ARITH` a + b = c <=> a = c - b `] THEN REAL_ARITH_TAC)]);;









(* AFF_GES_GTS *)

let AFF_GT21 = MESON[AFF_GES_GTS]`!a b v0.
         ~(a = v0) /\ ~(b = v0) 
         ==> aff_gt {a, b} {v0} =
             {x | ?ta tb t.
                      ta + tb + t = &1 /\
                      &0 < t /\
                      x = ta % a + tb % b + t % v0}`;;
 let AFF_GE21 = MESON[AFF_GES_GTS]`!a b v0.
         ~(a = v0) /\ ~(b = v0) 
         ==> aff_ge {a, b} {v0} =
             {x | ?ta tb t.
                      ta + tb + t = &1 /\
                      &0 <= t /\
                      x = ta % a + tb % b + t % v0}`;;


let AFF_GT31 = MESON[AFF_GES_GTS]`!a b c v0.
         ~(a = v0) /\ ~(b = v0) /\ ~(c = v0 )
         ==> aff_gt {a, b, c} {v0} =
             {x | ?ta tb tc t.
                      &0 < t /\
                      ta + tb + tc + t = &1 /\
                      x = ta % a + tb % b + tc % c + t % v0}`;;
let AFF_GE31 = MESON[AFF_GES_GTS]`!a b c v0.
         ~(a = v0) /\ ~(b = v0) /\ ~(c = v0 )
         ==> aff_ge {a, b, c} {v0} =
             {x | ?ta tb tc t.
                      &0 <= t /\
                      ta + tb + tc + t = &1 /\
                      x = ta % a + tb % b + tc % c + t % v0}`;;







let AFF_GE21_SUBSET_AFF22 = prove(`{a,b} INTER {x,y} = {}
==>  aff_ge {a,b} {y} SUBSET aff_ge {a,b} {x,y} `,
NHANH (SET_RULE ` {a,b} INTER {x,y} = {} ==>
   ~ ( a = y ) /\ ~ ( b = y ) `) THEN 
SIMP_TAC[AFF_GE22; AFF_GE21; SUBSET; IN_ELIM_THM] THEN 
REPEAT STRIP_TAC THEN 
EXISTS_TAC`ta :real` THEN 
EXISTS_TAC`tb :real` THEN 
EXISTS_TAC`&0 ` THEN 
EXISTS_TAC`t :real` THEN 
ASM_SIMP_TAC[REAL_LE_REFL; ZERO_NEUTRAL; 
VECTOR_MUL_LZERO; VECTOR_ADD_LID]);;










let V5_IN_AFF21_IMP_SET_EQ = prove(`   (v5:real^3) IN aff_ge {v1, v3} {v4} /\
 ~coplanar {v1, v2, v3, v4} /\
 ~(v5 IN aff {v1, v3}) /\ CARD {v1, v2, v3, v4, v5} = 5 
 ==> aff_ge {v1, v3} {v2, v4} = aff_ge {v1, v3} {v2, v5}`,
REWRITE_TAC[CARD5] THEN NHANH (SET_RULE` ~(v1 IN {v2, v3, v4, v5}) /\
 ~(v2 IN {v3, v4, v5}) /\ ~(v3 = v4 \/ v4 = v5 \/ v5 = v3) ==>  {v1,v3} INTER {v2,v4} = {} `) THEN 
NHANH (AFF_GE21_SUBSET_AFF22 ) THEN REWRITE_TAC[ GSYM CARD5] THEN 
REWRITE_TAC[MESON[]` x IN s /\l <=> l /\ x IN s `] THEN  PHA THEN 
NHANH (SET_RULE ` a SUBSET b /\ x IN a ==> x IN b `) THEN ONCE_REWRITE_TAC[MESON[]` a1 /\ a2 /\ CARD s = 5
  /\ a4 /\ a5 /\ a6 <=>a4 /\ a5 /\ CARD s = 5 /\ a1 /\a6 /\a2 `] THEN 
NHANH (SPEC_ALL PROVE_UNION_AFF22_SUBSET ) THEN SIMP_TAC[UNION_SUBSET; SET_EQ_TO_SUBSET] THEN 
SIMP_TAC[GSYM SET_EQ_TO_SUBSET; CARD5] THEN NHANH (SET_RULE` ~(v1 IN {v2, v3, v4, v5}) /\
   ~(v2 IN {v3, v4, v5}) /\   ~(v3 = v4 \/ v4 = v5 \/ v5 = v3) ==>
  {v1, v3} INTER {v2, v5} = {} `) THEN SIMP_TAC[AFF_GE22] THEN 
REWRITE_TAC[GSYM SET_EQ_TO_SUBSET; SET_RULE ` {v1, v3} INTER {v2, v4} = {}
  <=> ~(v1 = v4) /\ ~(v3 = v4) /\ ~(v1 = v2) /\ ~(v3 = v2)`] THEN 
ONCE_REWRITE_TAC[MESON[]` a /\b ==> c <=> a ==> b ==> c `] THEN SIMP_TAC[AFF_GE21] THEN 
REWRITE_TAC[IN_ELIM_THM; AFF_2POINTS_INTERPRET] THEN REPEAT STRIP_TAC THEN 
ASM_CASES_TAC `t = &0 ` THENL [UNDISCH_TAC `ta + tb + t = &1` THEN 
UNDISCH_TAC `(v5:real^3) = ta % v1 + tb % v3 + t % v4` THEN UNDISCH_TAC` t = &0 ` THEN 
SIMP_TAC[ZERO_NEUTRAL; VECTOR_MUL_LZERO; VECTOR_ADD_RID] THEN PHA THEN ASM_MESON_TAC[];
REWRITE_TAC[SUBSET; IN_ELIM_THM] THEN REPEAT STRIP_TAC THEN 
UNDISCH_TAC `x = a1 % v1 + a2 % v3 + b1 % v2 + b2 % (v4:real^3)` THEN 
ONCE_REWRITE_TAC[MESON[]` a ==> b <=> ~b ==> ~ a `] THEN DISCH_TAC THEN 
ONCE_REWRITE_TAC[VECTOR_ARITH` x = a <=> x = a - (b2 /t) % (v5:real^3) + (b2 /t) % (v5:real^3)`] THEN 
UNDISCH_TAC` (v5:real^3) = ta % v1 + tb % v3 + t % v4 ` THEN SIMP_TAC[] THEN 
REWRITE_TAC[VECTOR_ARITH` (a1 % v1 + a2 % v3 + b1 % v2 + b2 % v4) -
        tt % (ta % v1 + tb % v3 + t % v4) =   ( a1 - tt * ta ) % v1 + ( a2 - tt * tb ) % v3  + b1 % v2 +
  ( b2 - tt * t ) % v4 `] THEN ONCE_REWRITE_TAC[EQ_SYM_EQ] THEN 
UNDISCH_TAC`~(t = &0 )` THEN SIMP_TAC[REAL_FIELD` ~( a = &0) ==> b / a * a = b `;
  REAL_SUB_REFL; VECTOR_MUL_LZERO; VECTOR_ADD_RID] THEN UNDISCH_TAC`ta + tb + t = &1` THEN 
UNDISCH_TAC ` a1 + a2 + b1 + b2 = &1 ` THEN PHA THEN DAO THEN NHANH (REAL_FIELD` ~(t = &0) /\
 a1 + a2 + b1 + b2 = &1 /\ ta + tb + t = &1 ==> a1 - b2 / t * ta + a2 - b2 / t * tb + b1 + b2 / t = &1`) THEN 
UNDISCH_TAC ` &0 <= b2 ` THEN UNDISCH_TAC ` &0 <= t ` THEN PHA THEN 
NHANH (MESON[REAL_LE_DIV]` &0 <= t /\ &0 <= b /\ l ==> &0 <= b / t `) THEN 
REPLICATE_TAC 2 (FIRST_X_ASSUM MP_TAC) THEN REWRITE_TAC[VECTOR_ARITH` ((a:real^N) + b ) + c =
  a + b + c `] THEN MESON_TAC[]]);;














let AFF_GT22 = prove( `{(a:real^N), b} INTER {x, y} = {}
 ==> aff_gt {a, b} {x, y} =
     {w | ?ta tb tx ty.
              &0 < tx /\
              &0 < ty /\
              ta + tb + tx + ty = &1 /\
              w = ta % a + tb % b + tx % x + ty % y}`,
REWRITE_TAC[aff_gt_def; FUN_EQ_THM; affsign; sgn_gt;
  lin_combo] THEN 
ONCE_REWRITE_TAC[SET_RULE` {x, y} w ==> P <=>
  w IN ({a, b} UNION {x, y}) ==> {x, y} w ==> P`] THEN 
REWRITE_TAC[MESON[]` a = b /\ cc /\ j <=> cc /\ j 
  /\ b = a `] THEN 
REWRITE_TAC[SET_RULE` {a, b} UNION {x, y} =
  {a,b,x,y}`] THEN 
 SIMP_TAC[AFFINE_HULL_FINITE_STEP_GEN;
            REAL_ARITH `&0 < x /\ &0 < y ==> &0 < x + y`;
            REAL_ARITH `&0 < x ==> &0 < x / &2`;
            FINITE_INSERT; CONJUNCT1 FINITE_RULES
; RIGHT_EXISTS_AND_THM]  THEN 
NHANH (SET_RULE` (!x'. ({a, b} INTER {x, y}) x' <=> {} x')
    ==> ~( {x,y} a ) /\ ~( {x,y} b ) /\ {x,y} x /\ {x,y} y `) THEN 
SIMP_TAC[RIGHT_AND_EXISTS_THM; REAL_ARITH` a - b = c 
  <=> a = b + c `; ZERO_NEUTRAL; VECTOR_ARITH` (a:real^N) - b 
  = c <=> a = b + c `; VECTOR_ADD_RID; IN_ELIM_THM] THEN 
SIMP_TAC[EQ_SYM_EQ]);;




let PROVE_B1B2_POS = prove(` ~((?ta tb t. ta + tb + t = &1 /\ &0 <= t /\ v5 = ta % v1 + tb % v3 + t % v2) \/
   (?ta tb t. ta + tb + t = &1 /\ &0 <= t /\ v5 = ta % v1 + tb % v3 + t % v4)) /\
 ~coplanar {v1, v2, v3, v4} /\
 &0 <= b1 /\
 &0 <= b2 /\
 a1 + a2 + b1 + b2 = &1 /\
 v5 = a1 % v1 + a2 % v3 + b1 % v2 + b2 % v4 /\ l
  ==> &0 < b1 /\ &0 < b2 `,
ASM_CASES_TAC `b1 = &0 ` THENL [
ASM_SIMP_TAC[ZERO_NEUTRAL; VECTOR_MUL_LZERO; VECTOR_ADD_LID] THEN 
MESON_TAC[]; ASM_CASES_TAC `b2 = &0 ` THENL [
ASM_SIMP_TAC[ZERO_NEUTRAL; VECTOR_MUL_LZERO; VECTOR_ADD_LID; VECTOR_ADD_RID] 
THEN MESON_TAC[]; ASM_SIMP_TAC[REAL_ARITH` a <= b <=> b = a \/ a < b `]]]);;



let NOT_COPLANAR_AND_SUM_IMP_UNIQUE = prove(
` ~coplanar {(v1:real^3), v2, v3, v4} ==>
(! x s1 s2 s3 s4 t1 t2 t3 t4.
  t1 + t2 + t3 + t4 = &1 /\
  x = t1 % v1 + t2 % v2 + t3 % v3 + t4 % v4 /\
 s1 + s2 + s3 + s4 = &1 /\
  x = s1 % v1 + s2 % v2 + s3 % v3 + s4 % v4 ==>
  s1 = t1 /\ s2 = t2 /\ s3 = t3 /\ s4 = t4 ) `,
NHANH (SPEC_ALL (REWRITE_RULE[RIGHT_FORALL_IMP_THM] COEFS_4)) 
THEN MESON_TAC[]);;



g ` ! (v1:real^3) (v2:real^3) (v3:real^3) (v4:real^3) (v5:real^3).
   CARD {v1, v2, v3, v4, v5} = 5 /\
     ~coplanar {v1, v2, v3, v4} /\
     v5 IN aff_ge {v1, v3} {v2, v4} /\
     ~(v5 IN aff {v1, v3})
     ==> aff_ge {v1, v3} {v2, v4} =
         aff_ge {v1, v3} {v2, v5} UNION aff_ge {v1, v3} {v4, v5} /\
         aff_gt {v1, v3} {v2, v5} INTER aff_gt {v1, v3} {v4, v5} = {}`;;
e (SIMP_TAC[GSYM SUBSET_ANTISYM_EQ; PROVE_UNION_AFF22_SUBSET; 
EMPTY_SUBSET ]);;
e (REPEAT GEN_TAC);;
e (ASM_CASES_TAC ` (v5:real^3) IN aff_ge {v1,v3} {v2} \/
  v5 IN aff_ge {v1,v3} {v4} `);;
e (DOWN_TAC);;
e (SPEC_TAC (`v2:real^3`,`v2:real^3`));;
e (SPEC_TAC (`v4:real^3`,`v4:real^3`));;
e (ONCE_REWRITE_TAC[MESON[]` a /\ b ==> c <=> 
  a ==> b ==> c `]);;
e (MATCH_MP_TAC (MESON[]`(! a b. L a b <=> L b a ) /\ (! a b . P a ==> L a b )  ==> (! a b. P b \/ P a ==>
  L a b ) `));;
e (CONJ_TAC);;
e (SIMP_TAC[UNION_COMM; INTER_COMM; INSERT_AC]);;
e (PHA);;
e (ONCE_REWRITE_TAC[MESON[]`a1 /\a2/\a3/\a4/\a5 <=>
  a4 /\ a1 /\a3/\a5/\a2`]);;
e (NHANH (V5_IN_AFF21_IMP_SET_EQ));;
e (SIMP_TAC[SET_RULE` a = b ==> a SUBSET (b UNION cc )`]);;
e (ONCE_REWRITE_TAC[MESON[]`a IN s /\ b /\ ss = tt ==> l
  <=> ss = tt ==> a IN s /\ b ==> l`]);;
e (ONCE_REWRITE_TAC[GSYM (MESON[]`a1 /\a2/\a3/\a4/\a5 <=>
  a4 /\ a1 /\a3/\a5/\a2`)]);;
e (ONCE_REWRITE_TAC[SET_RULE ` {a,b,c,d,e} = {e,a,b,c,d}`]);;
e (REWRITE_TAC[CARD5]);;
e (NHANH (SET_RULE` ~(v1 IN {v2, v3, v4}) /\
      ~(v2 = v3 \/ v3 = v4 \/ v4 = v2) ==>
  {v1,v3} INTER {v2,v4} = {} `));;
e (NHANH (SPEC_ALL AFF_GE22));;
e (PHA);;
e (REWRITE_TAC[IN_ELIM_THM; MESON[]` a = b /\ a1 /\ v IN a /\l <=>
  a = b /\ a1 /\ v IN b /\ l`]);;
e (REWRITE_TAC[IN_INSERT; NOT_IN_EMPTY; DE_MORGAN_THM]);;
e (PHA);;
e (NHANH (MESON[AFF_GE21]` ~(v1 = v4) /\
     ~(v2 = v3) /\
     ~(v3 = v4) /\ ll ==>
  aff_ge {v1,v3} {v4} = 
               {x | ?ta tb t.
                        ta + tb + t = &1 /\
                        &0 <= t /\
                        x = ta % v1 + tb % v3 + t % v4}`));;
e (REWRITE_TAC[MESON[]` a IN s /\ l <=> l /\ a IN s `]);;
e (REWRITE_TAC[MESON[]` a IN s /\ l <=> l /\ a IN s `;
  MESON[]` a = b /\ x IN a <=> a = b /\ x IN b `; IN_ELIM_THM]);;
e (PHA);;
e (REWRITE_TAC[MESON[]` a = b /\ x IN a <=>
  x IN b /\ a = b `; IN_ELIM_THM]);;
e (NHANH (SET_RULE`  ~(v5 = v1) /\
     ~(v5 = v2) /\
     ~(v5 = v3) /\
     ~(v5 = v4) /\
     ~(v1 = v2) /\
     ~(v1 = v3) /\
     ~(v1 = v4) /\
     ~(v2 = v3) /\
     ~(v3 = v4) /\
     ~(v4 = v2) /\ l ==> {v1, v3} INTER {v2, v5} = {} /\
  {v1,v3} INTER {v4,v5} = {} `));;
e (SIMP_TAC[AFF_GT22]);;
e (REWRITE_TAC[SET_RULE` a INTER b SUBSET {} <=> (! x. ~( x IN a 
  /\ x IN b ))`]);;
e (REWRITE_TAC[SET_RULE` a INTER b SUBSET {} <=> (! x. ~( x IN a 
  /\ x IN b ))`; IN_ELIM_THM] THEN REPEAT STRIP_TAC);;
e (ASM_CASES_TAC ` t = &0 `);;



e (UNDISCH_TAC `v5 = ta % v1 + tb % v3 + t % (v4:real^3)`);;
e (UNDISCH_TAC `ta + tb + t = &1`);;
e (UNDISCH_TAC `t = &0`);;
e (UNDISCH_TAC `~(v5 IN aff {v1, (v3:real^3)})`);;
e (SIMP_TAC[ZERO_NEUTRAL; VECTOR_MUL_LZERO; VECTOR_ADD_RID;
 AFF_2POINTS_INTERPRET; IN_ELIM_THM]);;
e (MESON_TAC[]);;
e (REPLICATE_TAC 13 (FIRST_X_ASSUM MP_TAC));;
e (PURE_ONCE_REWRITE_TAC[MESON[]` a = b ==> p a <=> a = b ==> p b `]);;


e (REWRITE_TAC[  VECTOR_ARITH` ta' % v1 + tb' % v3 + tx % v2 + ty % (ta % v1 + tb % v3 + t % v4) = 
  ( ta' + ty * ta ) % v1 + ( tb' + ty * tb ) % v3 + tx % v2 + ( ty * t ) % v4 `]);;


e (REWRITE_TAC[VECTOR_ARITH` (ta'' + ty' * ta) % v1 +
     (tb'' + ty' * tb) % v3 +
     tx' % v4 +
     (ty' * t) % v4 =
  (ta'' + ty' * ta ) % v1 + (tb'' + ty' * tb ) % v3 + &0 % v2 + (tx' + ty' * t ) % v4 `]);;

e (REPEAT STRIP_TAC);;
e (UNDISCH_TAC `ta + tb + t = &1`);;
e (UNDISCH_TAC `ta' + tb' + tx + ty = &1`);;
e (UNDISCH_TAC `ta'' + tb'' + tx' + ty' = &1`);;
e (PHA);;
e (NHANH (REAL_FIELD`ta'' + tb'' + tx' + ty' = &1 /\ ta' + tb' + tx + ty = &1 /\ ta + tb + t = &1 ==>
  (ta' + ty * ta) + (tb' + ty * tb) + tx + (ty * t) = &1 /\
  (ta'' + ty' * ta) + (tb'' + ty' * tb) + &0 + (tx' + ty' * t ) = &1 `));;
e (MATCH_MP_TAC (MESON[]` (b ==> c) ==> ( a /\ b ==> c)`));;
e (UNDISCH_TAC `x =
      (ta' + ty * ta) % v1 + (tb' + ty * tb) % v3 + tx % v2 + (ty * t) % (v4:real^3)`);;
e (UNDISCH_TAC `x =
      (ta'' + ty' * ta) % v1 +
      (tb'' + ty' * tb) % v3 +
      &0 % v2 +
      (tx' + ty' * t) % (v4:real^3)`);;
e (UNDISCH_TAC `~coplanar {v1, v2, v3, (v4:real^3)}`);;
e (ONCE_REWRITE_TAC[SET_RULE` {v1, v2, v3, v4} =
  {v1,v3,v2,v4}`]);;
e (PHA THEN ONCE_REWRITE_TAC[MESON[]`a1/\a2/\a3/\a4/\a5 <=>
  a1/\a5/\a2/\a4/\a3`]);;
e (ABBREV_TAC ` t11 = (ta'' + ty' * ta) `);;
e (ABBREV_TAC ` t33 = (tb'' + ty' * tb) `);;
e (ABBREV_TAC ` t44 = (tx' + ty' * t) `);;
e (ABBREV_TAC ` s11 = (ta' + ty * ta) `);;
e (ABBREV_TAC ` s33 = (tb' + ty * tb) `);;
e (ABBREV_TAC ` s44 = (ty * t) `);;
e (NHANH (SPEC_ALL (REWRITE_RULE[RIGHT_FORALL_IMP_THM] COEFS_4)));;
e (NHANH (MESON[]`(! x. p x ) ==> p (x:real^3)`));;
e (PHA);;
e (NHANH (MESON[]`(!ta tb tc td.
      x = ta % v1 + tb % v3 + tc % v2 + td % v4 /\ ta + tb + tc + td = &1
      ==> ta = COEF4_1 v1 v3 v2 v4 x /\
          tb = COEF4_2 v1 v3 v2 v4 x /\
          tc = COEF4_3 v1 v3 v2 v4 x /\
          td = COEF4_4 v1 v3 v2 v4 x) /\
 t11 + t33 + &0 + t44 = &1 /\
 x = t11 % v1 + t33 % v3 + &0 % v2 + t44 % v4 /\
 s11 + s33 + tx + s44 = &1 /\
 x = s11 % v1 + s33 % v3 + tx % v2 + s44 % v4 ==>
  tx = &0 `));;
e (STRIP_TAC);;
e (UNDISCH_TAC `&0 < tx `);;
e (UNDISCH_TAC ` tx = &0 `);;
e (MESON_TAC[REAL_ARITH`~( a = &0 /\ &0 < a )`]);;



e (DOWN_TAC);;
e (ONCE_REWRITE_TAC[MESON[]` a/\b/\c ==> l <=> b ==> a /\ c ==> l`]);;
e (REWRITE_TAC[CARD5]);;
e (NHANH (SET_RULE` ~(v1 IN {v2, v3, v4, v5}) /\
 ~(v2 IN {v3, v4, v5}) /\
 ~(v3 = v4 \/ v4 = v5 \/ v5 = v3) ==>
  ~(v1 = v2 ) /\ ~(v3 = v2) /\ ~(v1 = v4) /\ ~ (v3 = v4) /\
  {v1,v3} INTER {v2,v4} = {} /\
  {v1, v3} INTER {v2, v5} = {} /\
  {v1, v3} INTER {v4, v5} = {}`));;
e (SIMP_TAC[AFF_GE22; AFF_GT22; AFF_GE21]);;
e (REWRITE_TAC[IN_ELIM_THM]);;
e (STRIP_TAC THEN STRIP_TAC);;
e (DOWN_TAC);;

(* *)
e (NHANH (PROVE_B1B2_POS ));;
e (REPEAT STRIP_TAC);;
e (REWRITE_TAC[FUN_EQ_THM; IN_ELIM_THM; SUBSET; IN_UNION]);;
e (REPEAT STRIP_TAC);;
e (ABBREV_TAC ` r = b1 * b2' - b1' * b2`);;
e (ASM_CASES_TAC ` &0 <= r `);;
e (UNDISCH_TAC `x = a1' % v1 + a2' % v3 + b1' % v2 + b2' % (v4:real^3)`);;
e (ONCE_REWRITE_TAC[MESON[VECTOR_ARITH` a = a - b + (b:real^N)`]` x = a ==> l <=>
  x = a - ( b1' / b1 ) % v5 + ( b1' / b1 ) % v5 ==> l `]);;
e (UNDISCH_TAC `v5 = a1 % v1 + a2 % v3 + b1 % v2 + b2 % (v4:real^3)`);;
e (PHA THEN PURE_ONCE_REWRITE_TAC[MESON[]`v = b /\ x = aa - t % v + t % v <=>
  v = b /\ x = aa - t % b + t % v `]);;
e (REWRITE_TAC[VECTOR_ADD_LDISTRIB; VECTOR_MUL_ASSOC]);;
e (IMP_TAC);;
e (DISCH_TAC);;
e (UNDISCH_TAC` &0 < b1 `);;
e (SIMP_TAC[REAL_FIELD` &0 < b ==> a / b * b = a `]);;
e (REWRITE_TAC[VECTOR_ARITH` (a1' % v1 + a2' % v3 + b1' % v2 + b2' % v4) -
     (b1 % v1 +
      b2 % v3 +
      b1' % v2 +
       bb % v4) = (a1' - b1 ) % v1 
  + (a2' - b2 ) % v3 + ( b2' - bb ) % v4 `]);;
e (SIMP_TAC[REAL_FIELD`&0 < b ==> a - x / b * c = ( a * b - x * c ) / b `]);;
e (REPEAT STRIP_TAC THEN DISJ2_TAC);;
e (EXISTS_TAC`(a1' * b1 - b1' * a1) / b1 `);;
e (EXISTS_TAC`(a2' * b1 - b1' * a2) / b1`);;
e (EXISTS_TAC`(b2' * b1 - b1' * b2) / b1`);;
e (EXISTS_TAC`b1' / b1`);;
e (SIMP_TAC[VECTOR_ARITH` (a+b) + (c:real^N) = a + b + c `]);;
e (ASM_SIMP_TAC[REAL_LE_DIV; REAL_ARITH` b1 * b2' - b1' * b2
  = b2' * b1 - b1' * b2 `]);;
e (ASM_MESON_TAC[REAL_FIELD` &0 < b1 /\ a1 + a2 + b1 + b2 = &1 /\
  a1' + a2' + b1' + b2' = &1 /\ b1 * b2' - b1' * b2 = r ==>
  (a1' * b1 - b1' * a1) / b1 + (a2' * b1 - b1' * a2) / b1 + r / b1 + b1' / b1 =
 &1 `]);;
e (UNDISCH_TAC `x = a1' % v1 + a2' % v3 + b1' % v2 + b2' % (v4:real^3)`);;
e (ONCE_REWRITE_TAC[MESON[VECTOR_ARITH` a = a - b + (b:real^N)`]` x = a ==> l <=>
  x = a - ( b2' / b2 ) % v5 + ( b2' / b2 ) % v5 ==> l `]);;
e (UNDISCH_TAC `v5 = a1 % v1 + a2 % v3 + b1 % v2 + b2 % (v4:real^3)`);;
e (PHA THEN PURE_ONCE_REWRITE_TAC[MESON[]`v = b /\ x = aa - t % v + t % v <=>
  v = b /\ x = aa - t % b + t % v `]);;
e (REWRITE_TAC[VECTOR_ADD_LDISTRIB; VECTOR_MUL_ASSOC]);;
e (UNDISCH_TAC` &0 < b2 `);;
e (ONCE_REWRITE_TAC[MESON[]` a ==> b /\ c ==> l <=>
  b ==> a /\ c ==> l`]);;
e (DISCH_TAC);;
e (IMP_TAC THEN SIMP_TAC[REAL_FIELD` &0 < b2 ==> b2' / b2 * b2 = b2'`]);;
e (REWRITE_TAC[VECTOR_ARITH`(a1' % v1 + a2' % v3 + b1' % v2 + a44 % v4) -
     (a11 % v1 + a33 % v3 + a22 % v2 + a44 % v4) +
     a55 % v5 =
     (a1' - a11) % v1 + (a2' - a33) % v3 + (b1' - a22) % v2 + a55 % v5`]);;
e (REPEAT STRIP_TAC THEN DISJ1_TAC);;
e (EXISTS_TAC` (a1' - b2' / b2 * a1) `);;
e (EXISTS_TAC` (a2' - b2' / b2 * a2) `);;
e (EXISTS_TAC` (b1' - b2' / b2 * b1) `);;
e (EXISTS_TAC` b2' / b2 `);;
e (UNDISCH_TAC ` ~( &0 <= r )`);;
e (ASM_SIMP_TAC[REAL_LE_DIV; REAL_FIELD` &0 < b2 ==>
  b1' - b2' / b2 * b1 = ( -- ( b1 * b2' - b1' * b2 ))/ b2 `;
  REAL_ARITH` ~( &0 <= a) <=> &0 <= -- a /\ ~( a = &0 ) `]);;
e (STRIP_TAC);;
e (EXPAND_TAC "r");;
e (ASM_SIMP_TAC[REAL_FIELD` &0 < b2 /\ a1' + a2' + b1' + b2' = &1 /\ a1 + a2 + b1 + b2 = &1
     ==> --(a1 * b2' - a1' * b2) / b2 +
         --(a2 * b2' - a2' * b2) / b2 +
         --(b1 * b2' - b1' * b2) / b2 +
         b2' / b2 =
         &1 `]);;
e (REWRITE_TAC[SET_RULE`a INTER b SUBSET {} <=> (! x. ~( x IN a /\ x IN b ))`; IN_ELIM_THM]);;
e (GEN_TAC);;
e (ASM_SIMP_TAC[VECTOR_ARITH` ta % v1 +
        tb % v3 +
        tx % v2 +
        ty % (a1 % v1 + a2 % v3 + b1 % v2 + b2 % v4)
  = (ta + ty * a1 ) % v1 + ( tb + ty * a2 ) % v3 +
  ( tx + ty * b1 ) % v2 + ( ty * b2 ) % v4 `;
  VECTOR_ARITH` ta % v1 +
        tb % v3 +
        tx % v4 +
        ty % (a1 % v1 + a2 % v3 + b1 % v2 + b2 % v4) =
  ( ta + ty * a1 ) % v1 + ( tb + ty * a2 ) % v3 +
  ( ty * b1 ) % v2 + ( tx + ty * b2 ) % v4 `]);;
e (ONCE_REWRITE_TAC[MESON[]` ~ a <=> a ==> F `] THEN STRIP_TAC);;
e (UNDISCH_TAC` ta + tb + tx + ty = &1 `);;
e (UNDISCH_TAC` a1 + a2 + b1 + b2 = &1 `);;
e (UNDISCH_TAC` ta' + tb' + tx' + ty' = &1 `);;
e (PHA);;
e (NHANH (REAL_FIELD`ta' + tb' + tx' + ty' = &1 /\
   a1 + a2 + b1 + b2 = &1 /\
   ta + tb + tx + ty = &1 ==>
  (ta' + ty' * a1) + (tb' + ty' * a2) + (ty' * b1) +
  (tx' + ty' * b2) = &1 /\
  (ta + ty * a1) + (tb + ty * a2) + (tx + ty * b1) +
  (ty * b2) = &1 `));;
e (STRIP_TAC);;
e (UNDISCH_TAC `x =
      (ta + ty * a1) % v1 +
      (tb + ty * a2) % v3 +
      (tx + ty * b1) % v2 +
      (ty * b2) % (v4:real^3)`);;
e (UNDISCH_TAC `(ta + ty * a1) + (tb + ty * a2) + (tx + ty * b1) + ty * b2 = &1`);;
e (UNDISCH_TAC`x =
      (ta' + ty' * a1) % v1 +
      (tb' + ty' * a2) % v3 +
      (ty' * b1) % v2 +
      (tx' + ty' * b2) % (v4:real^3) `);;
e (UNDISCH_TAC`(ta' + ty' * a1) + (tb' + ty' * a2) + ty' * b1 + tx' + ty' * b2 = &1 `);;
e (UNDISCH_TAC `~coplanar {(v1:real^3), v2, v3, v4}`);;
e (PHA);;
e (ONCE_REWRITE_TAC[SET_RULE` {a,b,c,d} = {a,c,b,d}`]);;
e (NHANH (NOT_COPLANAR_AND_SUM_IMP_UNIQUE));;
e (PHA);;
e (NHANH (MESON[]`(!x s1 s2 s3 s4 t1 t2 t3 t4.
        t1 + t2 + t3 + t4 = &1 /\
        x = t1 % v1 + t2 % v3 + t3 % v2 + t4 % v4 /\
        s1 + s2 + s3 + s4 = &1 /\
        x = s1 % v1 + s2 % v3 + s3 % v2 + s4 % v4
        ==> s1 = t1 /\ s2 = t2 /\ s3 = t3 /\ s4 = t4) /\
   (ta' + ty' * a1) + (tb' + ty' * a2) + ty' * b1 + tx' + ty' * b2 = &1 /\
   x =
   (ta' + ty' * a1) % v1 +
   (tb' + ty' * a2) % v3 +
   (ty' * b1) % v2 +
   (tx' + ty' * b2) % v4 /\
   (ta + ty * a1) + (tb + ty * a2) + (tx + ty * b1) + ty * b2 = &1 /\
   x =
   (ta + ty * a1) % v1 +
   (tb + ty * a2) % v3 +
   (tx + ty * b1) % v2 +
   (ty * b2) % v4 ==>
  ty' * b1 = (tx + ty * b1) /\
  (tx' + ty' * b2) = (ty * b2) `));;
e (NHANH (REAL_FIELD`a = b /\ aa = bb ==>
  a * bb - b * aa = &0 `));;

e (STRIP_TAC);;
e (FIRST_X_ASSUM MP_TAC);;
e (ONCE_REWRITE_TAC[REAL_ARITH` a = &0 <=> -- a = &0 `]);;
e (ONCE_REWRITE_TAC[REAL_ARITH` a = &0 <=> -- a = &0 `]);;
e (REWRITE_TAC[REAL_POLY_CONV` --((ty' * b1) * ty * b2 - (tx + ty * b1) * (tx' + ty' * b2)) `]);;
e (UNDISCH_TAC ` &0 < b1 `);;
e (UNDISCH_TAC ` &0 < b2 `);;
e (UNDISCH_TAC ` &0 < tx `);;
e (UNDISCH_TAC ` &0 < ty `);;
e (UNDISCH_TAC ` &0 < tx' `);;
e (UNDISCH_TAC ` &0 < ty' `);;
e (PHA);;
e (NHANH (MESON[REAL_LT_MUL]`
  &0 < ty' /\ &0 < tx' /\ &0 < ty /\ &0 < tx /\ &0 < b2 /\ &0 < b1
  ==> &0 < b1 * tx' * ty  /\ &0 < b2 * tx * ty' /\ &0 < tx * tx' `));;
e (MESON_TAC[REAL_LT_IMP_NZ; REAL_LT_ADD]);;
let BAJSVHC = top_thm();;





