
(* Hoang Le Truong *)

(* since you define C0,C1 independently, you need lemmas to relate this to other chapters.

lemmas 
`aff_gt {v} {v1,v2}={t1 % v+t2 % v1+t3 % v2 | ?t1 t2 t3. (t2 > &0)/\(t3 > &0)/\(t1+t2+t3= &1)}`;;

`aff_ge {v} {v1,v2}={t1 % v+t2 % v1+t3 % v2 | ?t1 t2 t3. (t2 >= &0)/\(t3 >= &0)/\(t1+t2+t3= &1)}`;;

*)

needs "Multivariate/vectors.ml";;
needs "Examples/analysis.ml";;       
needs "Examples/transc.ml";;         
needs "definitions_kepler.ml";;


 let graph = new_definition `graph E <=> (!e. E e ==> (e HAS_SIZE 2))`;;

 let fan1 = new_definition`fan1(x,V,E):bool <=>  FINITE V /\ ~(V SUBSET {}) `;;

 let fan2 = new_definition`fan2(x,V,E):bool <=>   ~(x IN V)`;;

 let fan3=new_definition`fan3(x,V,E):bool <=> (!v. (v IN V) ==> cyclic_set {w | {v,w} IN E } x v)`;;

 let fan4 = new_definition`fan4(x,V,E):bool<=>  (!e. (e IN E) ==> (aff_gt {x} e  INTER V={}))`;;

 let fan5 = new_definition`fan5(x,V,E):bool<=> (!e f. (e IN E)/\ (f IN E) /\ ~(e=f) ==> (aff_gt {x} e INTER aff_gt {x} f ={}))`;;

 let fan = new_definition`fan(x,V,E)<=>  ((UNIONS E) SUBSET V) /\ graph(E)/\ fan1(x,V,E)/\ fan2(x,V,E)/\ fan3(x,V,E)/\ fan4 (x,V,E) /\ fan5(x,V,E)`;;

 let base_point_fan=new_definition`base_point_fan (x,V,E)=x`;;

 let set_of_edges=new_definition`set_of_edges v E={w|{v,w} IN E}`;;

 let azim_cycle_fan= new_definition`azim_cycle_fan   = 
(?sigma. !v w proj e1 e2 e3 x V E. 
(fan(x, V, E))/\(V v)/\({v,w} IN E)/\((dist(v,w)) % e3 = (x-v))/\
(orthonormal e1 e2 e3) /\
(!u a b. (proj u = (a,b)) <=> (?h. (u = v + a % e1 + b % e2 + h % e3))) 
==> (proj (sigma  v w) = polar_cycle (IMAGE proj {y|{v,y} IN E}) (proj w))) `;;



 let azim_cycle_fan1= prove (`?sigma. !v w proj e1 e2 e3 x V E. 
(azim_cycle_fan) ==> ((fan(x, V, E))/\(V v)/\({v,w} IN E)/\((dist(v,w)) % e3 = (x-v))/\
(orthonormal e1 e2 e3) /\
(!u a b. (proj u = (a,b)) <=> (?h. (u = v + a % e1 + b % e2 + h % e3))) 
==> (proj (sigma  v w) = polar_cycle (IMAGE proj {y|{v,y} IN E}) (proj w)))`,
	(REWRITE_TAC[GSYM RIGHT_IMP_EXISTS_THM;GSYM RIGHT_IMP_FORALL_THM]) THEN
	  (REWRITE_TAC[azim_cycle_fan])
	   );;

 let sigma_fan= new_specification ["sigma_fan"] azim_cycle_fan1;;


 let D1=new_definition`D1 (x,V,E)={(x,v,w,w1)|(V v)/\(w IN set_of_edges v E)/\(w1=sigma_fan v w)}`;;



 let D2=new_definition`D2 (x,V,E)={ (x,v)|(V v)/\(set_of_edges v E={})}`;;


 let inverse_sigma_fan=new_definition`inverse_sigma_fan v w = @a. sigma_fan v a=w`;;

 let e_fan=new_definition`e_fan=(\(x,v,w,w1). (x,w,v,(sigma_fan w v)))`;;

 let f_fan=new_definition`f_fan = (\(x,v,w,w1). (x,w,(inverse_sigma_fan w v),v) )`;;

 let n_fan=new_definition`n_fan=(\(x,v,w,w1). (x,v,(sigma_fan v w),(sigma_fan v (sigma_fan v w))))`;;

 let i_fan=new_definition`i_fan=(\(x,v,w,w1). (x,v,w,(sigma_fan v w)))`;;

 let p1=new_definition`p1=(\(x,v,w,w1). x)`;;

 let p2=new_definition`p2=(\(x,v,w,w1). v)`;;

 let p3=new_definition`p3=(\(x,v,w,w1). w)`;;

 let p4=new_definition`p4=(\(x,v,w,w1). w1)`;;

 let o_fun=new_definition`!(f:A#B#C#D->A#B#C#D) (g:A#B#C#D->A#B#C#D). o_fun f g =(\(x:A,y:B,z:C,t:D).  f (p1 (g (x,y,z,t)),p2(g(x,y,z,t)),p3(g(x,y,z,t)),p4(g(x,y,z,t))))`;;



 let power_map= new_recursive_definition num_RECURSION `(power_map f 0 = i_fan)/\(power_map f  (SUC n)= o_fun f  (power_map f  n))`;;



 let power_map_point= new_recursive_definition num_RECURSION `(power_map_point f v w 0 = w)/\(power_map_point f v w  (SUC n)= f v (power_map_point f v w n))`;;


 let power_n_fan= new_definition`power_n_fan n=(\(x,v,w,w1). (x,v,(power_map_point sigma_fan v w n),(power_map_point sigma_fan v w (SUC n))))`;; 


 let a_node_fan=new_definition`a_node_fan (x,v,w,w1)={a | ?n. a=(power_map  n_fan n) (x,v,w,sigma_fan v w)}`;;






 let xfan= new_definition`xfan (x,V,E)={v | ?e. (E e)/\(v IN aff_ge {x} e)}`;;

 let yfan= new_definition`yfan (x,V,E)={v:real^3 | ?e. (E e)/\(~(v IN aff_ge {x} e))}`;;

 let w_dart=new_definition`w_dart x v w w1= wedge x v w (sigma_fan v w)`;;

 let azim_fan=new_definition`azim_fan x v w w1= azim x v w w1`;;

 let w_dart0=new_definition`w_dart0 x v w w1 y=(w_dart x v w w1) INTER (rcone_gt x v y)`;;

 let c_fan=new_definition`c_fan x v w y ={c | (c IN aff_ge {x} {v,w})/\ (~((c IN rcone_gt x v y)\/(c IN rcone_gt x w y)))}`;;




(* ************************************************* *)
(* Proof remark rem:fan *)
let asfan=prove(`{w,v}={v,w}`, SET_TAC[]);;


let remark_fan1=prove(`!v w E. (w IN set_of_edges v E)<=>(v IN set_of_edges w E)`, 
REPEAT GEN_TAC THEN REWRITE_TAC[set_of_edges] THEN REWRITE_TAC[IN_ELIM_THM] THEN MESON_TAC[asfan]);;




(* Proof Lemma 6.1 [AAUHTVE] *)



let node_fan=prove(`!n. power_map n_fan n=power_n_fan n`, REWRITE_TAC[power_map; n_fan; power_n_fan; power_map_point] THEN INDUCT_TAC THEN REWRITE_TAC[power_map; power_map_point; i_fan;] THEN REWRITE_TAC[power_map_point; power_map] THEN ASM_REWRITE_TAC[] THEN REWRITE_TAC[o_fun; p1; p2; p3; p4]);;


let lem_fan411=prove(`(!v w. sigma_fan v (inverse_sigma_fan v w)=w)==> (o_fun e_fan (o_fun n_fan f_fan)=i_fan)`, 
REWRITE_TAC[o_fun; e_fan; f_fan; n_fan; i_fan;] THEN REWRITE_TAC[p1; p2; p3; p4] THEN DISCH_TAC THEN ASM_REWRITE_TAC[]);;

let lem_fan412=prove(`o_fun e_fan  e_fan =i_fan`, 
REWRITE_TAC[o_fun; e_fan; i_fan;] THEN REWRITE_TAC[p1; p2; p3; p4]);;

let e_fan_no_fix_point=prove(`!x v w w1. (v=w) <=>(e_fan(x,v,w,(sigma_fan v w))=(x,v,w,(sigma_fan v w)))`, 
REPEAT GEN_TAC THEN REWRITE_TAC[e_fan] THEN MESON_TAC[PAIR_EQ] );;

let f_fan_no_fix_point=prove(`!x v w w1. (f_fan(x,v,w,(sigma_fan v w))=(x,v,w,(sigma_fan v w)))==>(v=w)`, 
REPEAT GEN_TAC THEN REWRITE_TAC[f_fan] THEN MESON_TAC[PAIR_EQ] );;

let lem_fan4131=prove(`w = power_map_point sigma_fan v w m ==> (x,v,power_map_point sigma_fan v w m,
 sigma_fan v (power_map_point sigma_fan v w m) =
 x,v,w,sigma_fan v w)`, MESON_TAC[]);;

let lem_fan413=prove(`!x v w w1 n m. o_fun (power_map n_fan n)  e_fan (x,v,w,w1)=o_fun e_fan (power_map n_fan m) (x,v,w,w1)
==> (power_map n_fan m) (x,v,w,w1) =i_fan (x,v,w,w1)`, 
REWRITE_TAC[node_fan; o_fun; e_fan; power_n_fan; i_fan; p1; p2; p3; p4;] THEN REPEAT GEN_TAC THEN DISCH_TAC THEN 
SUBGOAL_THEN `w=power_map_point sigma_fan v w m` ASSUME_TAC 
THENL [POP_ASSUM MP_TAC THEN MESON_TAC[PAIR_EQ]; 
POP_ASSUM MP_TAC THEN REWRITE_TAC[power_map_point] THEN MESON_TAC[lem_fan4131]]);;


let lem_fan414=prove(`!x v w w1 n. (power_map n_fan n) (x,v,w,w1)=e_fan (x,v,w,w1)==>(v=w)`, 
REWRITE_TAC[node_fan; e_fan; power_n_fan;]  THEN REPEAT GEN_TAC THEN MESON_TAC[PAIR_EQ]);;

(* Proof of Lemma [VBTIKLP] *)


let lemma62=prove(`a IN a_node_fan (x,v,w,w1)==>(?n. a=(x,v,(power_map_point sigma_fan v w n),(power_map_point sigma_fan v w (SUC n))))`, REWRITE_TAC[a_node_fan; IN_ELIM_THM; ] THEN REWRITE_TAC[node_fan] THEN REWRITE_TAC[power_n_fan]);;


let lemfan=new_definition`lemfan x v w n=wedge x v w (power_map_point sigma_fan v w n)`;;

let lemfan1=new_definition`lemfan1 x v w n=(lemfan x v w n) UNION (aff_ge {x,v} {power_map_point sigma_fan v w n})`;;

let complement_set= new_definition`complement_set {x:real^3, v:real^3} = {y:real^3| ~(y IN aff {x,v})} `;;

let subset_aff=prove(`!x v:real^3. (aff{x, v} SUBSET (UNIV:real^3->bool))`, REPEAT GEN_TAC THEN SET_TAC[]);;

let a_lemma = prove(`!x v point. point IN complement_set {x, v} UNION aff 
{x, v}`, REWRITE_TAC[complement_set] THEN SET_TAC[]);; 

let union_aff=prove(`!x v:real^3. (UNIV:real^3->bool) = aff{x, v} UNION  complement_set {x, v}  `,
REPEAT GEN_TAC  THEN REWRITE_TAC[complement_set] THEN SET_TAC[]);;


let f_azim_fan= new_definition` f_azim_fan x v u=
(\i. azim_fan x v u (power_map_point sigma_fan v u i))`;;


let lemma_disjiont_exists_fan1=prove(` !x:real^3 v:real^3 u:real^3 y:real^3 E:real^3->bool n. 
(y IN complement_set {x,v})/\(f_azim_fan x v u (0) <=azim_fan x v u y)/\
(f_azim_fan x v u (0) =azim_fan x v u y)/\
(f_azim_fan x v u (n) >azim_fan x v u y)/\(CARD E=n)
/\(!i. (i IN (0..(n-1)))/\(f_azim_fan x v u (i)<f_azim_fan x v u (i+1)))
==>(?i. (i IN (0..(n-1)))/\
((f_azim_fan x v u (i) =azim_fan x v u y)
\/
((f_azim_fan x v u (i) <azim_fan x v u y)
/\(azim_fan x v u y < f_azim_fan x v u(i+1)))))`, MESON_TAC[]);;





let lemma_disjiont_exists_fan2=prove(`!x v u n. 
azim x v u u = &0 ==> f_azim_fan x v u (0) = &0`, 
REWRITE_TAC[f_azim_fan] THEN REWRITE_TAC[power_map_point] THEN REWRITE_TAC[azim_fan]);;


let lemma_disjiont_exists_fan3=prove(`!x v u y n. 
(azim x v u u = &0)/\ (&0<= azim_fan x v u y) ==> (f_azim_fan x v u (0) <= azim_fan x v u y)`, 
MESON_TAC[lemma_disjiont_exists_fan2]);;



let wedge_fan2=new_definition`wedge_fan2 x v u i =
{y | ( f_azim_fan x v u (i) =azim_fan x v u y)/\( y IN complement_set {x, v})}`;;

(*wedge_fan2=aff_gt*)

let COMPLEMENT_SET_FAN=prove(`!x:real^3 v:real^3 u:real^3 y:real^3 w:real^3 t1:real t2:real t3:real. 
(!x:real^3 v:real^3. aff {x , v} = {y:real^3| ?t1:real t2:real. (t1 + t2 = &1 )/\ (y = t1 % x + t2 % v )}) /\
~( w IN aff {x, v}) /\ ~(t3 = &0) /\ (t1 + t2 + t3 = &1)
==> t1 % x + t2 % v + t3 % w IN
 complement_set {x, v}`,
 REPEAT GEN_TAC THEN STRIP_TAC THEN REWRITE_TAC[complement_set; IN_ELIM_THM] THEN ASM_REWRITE_TAC[] THEN 
REWRITE_TAC[IN_ELIM_THM] THEN STRIP_TAC THEN REPEAT(POP_ASSUM MP_TAC) THEN DISCH_TAC THEN ASM_REWRITE_TAC[]
  THEN REWRITE_TAC[IN_ELIM_THM] THEN REPEAT DISCH_TAC THEN
  SUBGOAL_THEN  ` (t3:real) % w =((t1':real)- (t1:real)) % (x:real^3) + ((t2':real)- (t2:real)) % (v:real^3) ` ASSUME_TAC
 THENL
  [POP_ASSUM MP_TAC THEN VECTOR_ARITH_TAC;
   REPEAT(POP_ASSUM MP_TAC) THEN DISCH_THEN(LABEL_TAC "b") THEN DISCH_THEN(LABEL_TAC "c") THEN DISCH_THEN(LABEL_TAC "d")
     THEN REPEAT STRIP_TAC THEN USE_THEN "c" MP_TAC THEN REWRITE_TAC[CONTRAPOS_THM] THEN
     EXISTS_TAC `((t1':real) - (t1:real))/(t3:real)` THEN EXISTS_TAC `((t2':real) - (t2:real))/(t3:real)`
     THEN SUBGOAL_THEN  `((t1':real) - (t1:real))/(t3:real)+ ((t2':real) - (t2:real))/(t3:real) = &1` ASSUME_TAC  THENL
        [REWRITE_TAC[real_div] THEN REWRITE_TAC[REAL_ARITH `a*b+c*b=(a+c)*b`] THEN
        SUBGOAL_THEN `(t1':real) - (t1:real) + (t2':real) - (t2:real) - (t3:real) = &0` ASSUME_TAC THENL
           [REPEAT (POP_ASSUM MP_TAC) THEN REAL_ARITH_TAC;
            SUBGOAL_THEN `(t1':real) - (t1:real) + (t2':real) - (t2:real) = (t3:real)` ASSUME_TAC THENL
              [POP_ASSUM MP_TAC THEN REAL_ARITH_TAC;
               ASM_MESON_TAC[REAL_MUL_RINV]]]; 
       ASM_REWRITE_TAC[] THEN REWRITE_TAC[real_div] THEN
       REWRITE_TAC[VECTOR_ARITH ` (((t1':real) - (t1:real)) * inv (t3:real)) % (x:real^3) + (((t2':real) - (t2:real)) * inv t3) % (v:real^3) = inv t3 % ((t1' - t1) % x + (t2' - t2) % v)`] THEN 
       SUBGOAL_THEN `(t3:real) % (w:real^3) = t3 %( inv t3 % (((t1':real) - (t1:real)) % (x:real^3) + ((t2':real) - (t2:real)) % (v:real^3)))` ASSUME_TAC  THENL
                  [REWRITE_TAC[VECTOR_ARITH ` (t3:real) % (inv t3 % (((t1':real) - (t1:real)) % (x:real^3) + ((t2':real) - (t2:real)) % (v:real^3)))= (t3 * inv t3) % ((t1' - t1) % x + (t2' - t2)  % v) `] THEN
                   SUBGOAL_THEN `((t3:real) * inv (t3:real) = &1) ` ASSUME_TAC THENL
                                  [ASM_MESON_TAC[REAL_MUL_RINV]; 
                                    ASM_REWRITE_TAC[]  THEN VECTOR_ARITH_TAC];
                 ASM_MESON_TAC[VECTOR_MUL_LCANCEL_IMP]]]]);;
  
 let aff_imp_wedge_fan2a=prove(`!x:real^3 v:real^3 u:real^3 y:real^3 i:num. 
(!x:real^3 v:real^3. aff {x , v} = {y:real^3| ?t1:real t2:real. (t1 + t2 = &1 )/\ (y = t1 % x + t2 % v )}) /\
~( (power_map_point sigma_fan v u i) IN aff {x, v})
/\ (!x:real^3 v:real^3 u:real^3 w:real^3 t1:real t2:real t3:real. ~(t3 = &0) /\ (t1 + t2 + t3 = &1)  ==> azim x v u w =
 azim x v u (t1 % x + t2 % v + t3 % w))
==> 

!y:real^3.  {y:real^3 
| ?t1:real t2:real t3:real. (t3 > &0)/\(t1+t2+t3= &1)/\( y = t1 % x + t2 % v + t3 % (power_map_point sigma_fan v u i))} y
==> wedge_fan2 x v u i y`,
REPEAT GEN_TAC THEN STRIP_TAC THEN GEN_TAC THEN REWRITE_TAC[wedge_fan2; IN_ELIM_THM; LEFT_IMP_EXISTS_THM] THEN 
REPEAT GEN_TAC THEN STRIP_TAC THEN ASM_REWRITE_TAC[] THEN SUBGOAL_THEN `~((t3:real) = &0)` ASSUME_TAC THENL
   [REPEAT (POP_ASSUM MP_TAC) THEN REAL_ARITH_TAC;
    SUBGOAL_THEN `t1 % x + t2 % v + t3 % power_map_point sigma_fan v u i IN
 complement_set {x, v}` ASSUME_TAC THENL
      [ASM_MESON_TAC[COMPLEMENT_SET_FAN];
       ASM_REWRITE_TAC[] THEN REWRITE_TAC[f_azim_fan; azim_fan] THEN ASM_MESON_TAC[]]]);;


let aff_imp_wedge_fan2=prove(`!x:real^3 v:real^3 u:real^3 y:real^3 i:num. 
(!x:real^3 v:real^3. aff {x , v} = {y:real^3| ?t1:real t2:real. (t1 + t2 = &1 )/\ (y = t1 % x + t2 % v )}) /\
~( (power_map_point sigma_fan v u i) IN aff {x, v})
/\ (!x:real^3 v:real^3 u:real^3 w:real^3 t1:real t2:real t3:real. ~(t3 = &0) /\ (t1 + t2 + t3 = &1)  ==> azim x v u w =
 azim x v u (t1 % x + t2 % v + t3 % w))
/\ (!x:real^3 v:real^3 u:real^3 w:real^3. aff_gt {x , v} {w} = {y:real^3 | ?t1:real t2:real t3:real. (t3 > &0) /\ (t1 + t2 + t3 = &1) /\ (y = t1 % x + t2 % v + t3 % w)})
==> 

!y:real^3.  aff_gt {x , v} {power_map_point sigma_fan v u i} y
==> wedge_fan2 x v u i y`,
REPEAT GEN_TAC THEN STRIP_TAC THEN ASM_REWRITE_TAC[] THEN GEN_TAC THEN REWRITE_TAC[wedge_fan2; IN_ELIM_THM; LEFT_IMP_EXISTS_THM] THEN 
REPEAT GEN_TAC THEN STRIP_TAC THEN ASM_REWRITE_TAC[] THEN SUBGOAL_THEN `~((t3:real) = &0)` ASSUME_TAC THENL
   [REPEAT (POP_ASSUM MP_TAC) THEN REAL_ARITH_TAC;
    SUBGOAL_THEN `t1 % x + t2 % v + t3 % power_map_point sigma_fan v u i IN
 complement_set {x, v}` ASSUME_TAC THENL
      [ASM_MESON_TAC[COMPLEMENT_SET_FAN];
       ASM_REWRITE_TAC[] THEN REWRITE_TAC[f_azim_fan; azim_fan] THEN ASM_MESON_TAC[]]]);;

let aff_gt_subset_wedge_fan2=prove(`!x:real^3 v:real^3 u:real^3 y:real^3 i:num. 
(!x:real^3 v:real^3. aff {x , v} = {y:real^3| ?t1:real t2:real. (t1 + t2 = &1 )/\ (y = t1 % x + t2 % v )}) /\
~( (power_map_point sigma_fan v u i) IN aff {x, v})
/\ (!x:real^3 v:real^3 u:real^3 w:real^3 t1:real t2:real t3:real. ~(t3 = &0) /\ (t1 + t2 + t3 = &1)  ==> azim x v u w =
 azim x v u (t1 % x + t2 % v + t3 % w))
/\ (!x:real^3 v:real^3 u:real^3 w:real^3. aff_gt {x , v} {w} = {y:real^3 | ?t1:real t2:real t3:real. (t3 > &0) /\ (t1 + t2 + t3 = &1) /\ (y = t1 % x + t2 % v + t3 % w)})
==> 

 aff_gt {x , v} {power_map_point sigma_fan v u i}  SUBSET wedge_fan2 x v u i `,
REWRITE_TAC[SUBSET] THEN
REPEAT GEN_TAC THEN STRIP_TAC THEN ASM_REWRITE_TAC[] THEN GEN_TAC THEN REWRITE_TAC[wedge_fan2; IN_ELIM_THM; LEFT_IMP_EXISTS_THM] THEN 
REPEAT GEN_TAC THEN STRIP_TAC THEN ASM_REWRITE_TAC[] THEN SUBGOAL_THEN `~((t3:real) = &0)` ASSUME_TAC THENL
   [REPEAT (POP_ASSUM MP_TAC) THEN REAL_ARITH_TAC;
    SUBGOAL_THEN `t1 % x + t2 % v + t3 % power_map_point sigma_fan v u i IN
 complement_set {x, v}` ASSUME_TAC THENL
      [ASM_MESON_TAC[COMPLEMENT_SET_FAN];
       ASM_REWRITE_TAC[] THEN REWRITE_TAC[f_azim_fan; azim_fan] THEN ASM_MESON_TAC[]]]);;


let wedge_fan2_subset_aff_gt=prove(`(!x:real^3 v:real^3. aff {x , v} = {y:real^3| ?t1:real t2:real. (t1 + t2 = &1 )/\ (y = t1 % x + t2 % v )}) /\
~( (power_map_point sigma_fan v u i) IN aff {x, v})
/\ (!x:real^3 v:real^3 u:real^3 w:real^3. aff_gt {x , v} {w} = {y:real^3 | ?t1:real t2:real t3:real. (t3 > &0) /\ (t1 + t2 + t3 = &1) /\ (y = t1 % x + t2 % v + t3 % w)})
/\ (!x:real^3 v:real^3 u:real^3 w:real^3. {y:real^3 |  azim x v u w =
 azim x v u y}=aff_gt {x , v} {w})
==> 
(!x:real^3 v:real^3 u:real^3 y:real^3 i:num. 
 wedge_fan2 x v u i SUBSET aff_gt {x , v} {power_map_point sigma_fan v u i} )   `,
 
STRIP_TAC THEN REPEAT GEN_TAC  THEN REWRITE_TAC[SUBSET] THEN GEN_TAC THEN REWRITE_TAC[wedge_fan2;IN_ELIM_THM] THEN
POP_ASSUM MP_TAC THEN REWRITE_TAC[FUN_EQ_THM] THEN DISCH_TAC THEN
POP_ASSUM (MP_TAC o SPECL [`x':real^3`;`v':real^3`;`u':real^3`;`(power_map_point sigma_fan v' u' (i':num)):real^3`; `x'':real^3`]) THEN
REWRITE_TAC[IN_ELIM_THM] THEN REWRITE_TAC[f_azim_fan; azim_fan] THEN SET_TAC[]);;



let wedge_fan2_equal_aff_gt=prove(` 
(!x:real^3 v:real^3. aff {x , v} = {y:real^3| ?t1:real t2:real. (t1 + t2 = &1 )/\ (y = t1 % x + t2 % v )})

/\ (!x:real^3 v:real^3 u:real^3 w:real^3. aff_gt {x , v} {w} = {y:real^3 | ?t1:real t2:real t3:real. (t3 > &0) /\ (t1 + t2 + t3 = &1) /\ (y = t1 % x + t2 % v + t3 % w)})
/\ (!x:real^3 v:real^3 u:real^3 w:real^3 t1:real t2:real t3:real. ~(t3 = &0) /\ (t1 + t2 + t3 = &1)  ==> azim x v u w =
 azim x v u (t1 % x + t2 % v + t3 % w))
/\ (!x:real^3 v:real^3 u:real^3 w:real^3. {y:real^3 |  azim x v u w =
 azim x v u y}=aff_gt {x , v} {w})
==> 
(!x:real^3 v:real^3 u:real^3 y:real^3 i:num.
~( (power_map_point sigma_fan v u i) IN aff {x, v})
==>
 wedge_fan2 x v u i = aff_gt {x , v} {power_map_point sigma_fan v u i})    `,
  
STRIP_TAC THEN REPEAT GEN_TAC THEN DISCH_TAC THEN
SUBGOAL_THEN `wedge_fan2 x v u i SUBSET aff_gt {x , v} {power_map_point sigma_fan v u i}` ASSUME_TAC
THENL
  [ASM_MESON_TAC[ wedge_fan2_subset_aff_gt];
   SUBGOAL_THEN `
      aff_gt {(x:real^3), (v:real^3)} {power_map_point sigma_fan v u i}  SUBSET wedge_fan2 (x:real^3) (v:real^3) (u:real^3) (i:num)` ASSUME_TAC  THENL
       [REWRITE_TAC[SUBSET] THEN GEN_TAC THEN ASM_REWRITE_TAC[] 
        THEN REWRITE_TAC[wedge_fan2; IN_ELIM_THM; LEFT_IMP_EXISTS_THM] THEN 
        REPEAT GEN_TAC THEN STRIP_TAC THEN ASM_REWRITE_TAC[] THEN 
        SUBGOAL_THEN `~((t3:real) = &0)` ASSUME_TAC  THENL
            [REPEAT (POP_ASSUM MP_TAC) THEN REAL_ARITH_TAC;                
             SUBGOAL_THEN `t1 % x + t2 % v + t3 % power_map_point sigma_fan v u i IN 
                complement_set {x, v}` ASSUME_TAC THENL
                      [ASM_MESON_TAC[COMPLEMENT_SET_FAN];
                       ASM_REWRITE_TAC[] THEN REWRITE_TAC[f_azim_fan; azim_fan] THEN ASM_MESON_TAC[]]];

         SET_TAC[]]]);;


(************)

let wedge_fan3=new_definition`wedge_fan3 x v u i =
{y | ( f_azim_fan x v u (i) <azim_fan x v u y)/\
(azim_fan x v u y < f_azim_fan x v u (i+1))/\( y IN complement_set {x, v})}`;;

let wedge_fan6=new_definition`wedge_fan6 x v u i ={y | (( f_azim_fan x v u (i) =azim_fan x v u y)\/(( f_azim_fan x v u (i) <azim_fan x v u y)/\(azim_fan x v u y < f_azim_fan x v u (i+1))))/\( y IN complement_set {x, v})}`;;


let lemma_disjiont_union=prove(`wedge_fan6 x v u i=wedge_fan2 x v u i UNION wedge_fan3 x v u i`, REWRITE_TAC[wedge_fan2;wedge_fan3;wedge_fan6;FUN_EQ_THM; UNION] THEN GEN_TAC THEN REWRITE_TAC[IN_ELIM_THM]
THEN MESON_TAC[]);;



let wedge_fans= new_recursive_definition num_RECURSION `(wedge_fans x v u 0 = wedge_fan6 x v u (0))/\(wedge_fans x v u (SUC n)=(wedge_fans x v u n) UNION wedge_fan6 x v u (SUC n))`;;

let complement_sets=new_definition`complement_sets x v u n=
{ y|(y IN complement_set {x,v})/\
(f_azim_fan x v u (0) <azim_fan x v u y)/\
(f_azim_fan x v u (0) =azim_fan x v u y)/\
(f_azim_fan x v u (n) >azim_fan x v u y)/\
(!i. (i IN (0..(n-1)))/\(f_azim_fan x v u (i)<f_azim_fan x v u (i+1))) } `;;



let lemma_disjiont_union1=prove(`!x:real^3 v:real^3 u:real^3 y:real^3 E:real^3->bool n. 
(y IN complement_sets x v u n) ==>(?i. (i IN (0..(n-1)))/\( y IN (wedge_fan6 x v u i)))`, REPEAT GEN_TAC THEN
REWRITE_TAC[complement_sets; wedge_fan6] THEN REWRITE_TAC[IN_ELIM_THM] THEN MESON_TAC[]);;


let lemma_disjiont_union2=prove(`!x:real^3 v:real^3 u:real^3 y:real^3 E:real^3->bool n. 
(?i. (i IN (0..(n-1)))/\ (y IN (wedge_fan6 x v u i))) ==> (y IN complement_set {x,v}) `, REPEAT GEN_TAC THEN REWRITE_TAC[complement_set; wedge_fan6] THEN
REWRITE_TAC[IN_ELIM_THM] THEN MESON_TAC[]);;






let lemma_disjiont_unions=prove(`(y IN UNIONS {wedge_fan6 x v u i| i IN (0..(n-1))}) <=> 
(?i. (i IN (0..(n-1)))/\ (y IN (wedge_fan6 x v u i)))  `,
REWRITE_TAC[UNIONS] THEN REWRITE_TAC[IN_ELIM_THM] THEN MESON_TAC[]);;



let lemma_disjiont_unions2=prove(`!x:real^3 v:real^3 u:real^3 y:real^3 E:real^3->bool n. 
(y IN UNIONS {wedge_fan6 x v u i | i IN (0..(n-1))}) ==>(y IN complement_set {x,v}) `,
REPEAT GEN_TAC THEN STRIP_TAC THEN 
SUBGOAL_THEN `(?i. (i IN (0..(n-1)))/\ (y IN (wedge_fan6 x v u i)))` ASSUME_TAC 
THENL
  [POP_ASSUM MP_TAC THEN MESON_TAC[lemma_disjiont_unions];
   POP_ASSUM MP_TAC THEN MESON_TAC[lemma_disjiont_union2]]);;






let lemma_disjiont_unions1= prove(`!x:real^3 v:real^3 u:real^3 y:real^3 E:real^3->bool n.
(y IN complement_sets x v u n) ==> (y IN UNIONS {wedge_fan6 x v u i | i IN (0..(n-1))})`,
REPEAT GEN_TAC THEN STRIP_TAC THEN 
SUBGOAL_THEN `(?i. (i IN (0..(n-1))) /\ (y IN (wedge_fan6 x v u i)))` ASSUME_TAC
THENL 
   [POP_ASSUM MP_TAC THEN MESON_TAC[lemma_disjiont_union1];
     POP_ASSUM MP_TAC THEN MESON_TAC[lemma_disjiont_unions]]);;








let disjiont_union1=prove(`!x:real^3 v:real^3 u:real^3  E:real^3->bool n.
complement_sets x v u n = complement_set {x,v}==>
(!y. ((y IN UNIONS {wedge_fan6 x v u i | i IN (0..(n-1))})<=>(y IN complement_set {x,v})))`,
REPEAT GEN_TAC THEN STRIP_TAC THEN GEN_TAC THEN EQ_TAC 
THENL 
  [MESON_TAC[lemma_disjiont_unions2];
   SUBGOAL_THEN `(y IN complement_sets x v u n) ==> (y IN UNIONS {wedge_fan6 x v u i | i IN (0..(n-1))})` ASSUME_TAC
      THENL 
        [MESON_TAC[lemma_disjiont_unions1]; 
         REPEAT (POP_ASSUM MP_TAC) THEN MESON_TAC[]]]);;


let disjiont_union2=prove(`!x:real^3 v:real^3 u:real^3  E:real^3->bool n.
complement_sets x v u n = complement_set {x,v}==>
(UNIONS {wedge_fan6 x v u i | i IN (0..(n-1))}=complement_set {x,v})`, 
REPEAT GEN_TAC THEN STRIP_TAC THEN REWRITE_TAC[FUN_EQ_THM] THEN
SUBGOAL_THEN `(!y. ((y IN UNIONS {wedge_fan6 x v u i | i IN (0..(n-1))})<=>(y IN complement_set {x,v})))` ASSUME_TAC
THENL 
  [POP_ASSUM MP_TAC THEN MESON_TAC[disjiont_union1]; 
   POP_ASSUM MP_TAC THEN REWRITE_TAC[IN]]);;



let lemma_disjiont1=prove(`!x:real^3 v:real^3 u:real^3  E:real^3->bool n.
(complement_sets x v u n = complement_set {x,v})==>
((UNIV:real^3->bool)=aff {x,v} UNION (UNIONS {wedge_fan6 x v u i | i IN (0..(n-1))}))`, REPEAT GEN_TAC THEN STRIP_TAC THEN
SUBGOAL_THEN `(UNIONS {wedge_fan6 x v u i | i IN (0..(n-1))}=complement_set {x,v})` ASSUME_TAC 
THENL 
 [POP_ASSUM MP_TAC THEN MESON_TAC[disjiont_union2];
 SUBGOAL_THEN `(UNIV:real^3->bool) = aff{x, v} UNION  complement_set {x, v}` ASSUME_TAC
     THENL
       [MESON_TAC[union_aff];
        REPEAT (POP_ASSUM MP_TAC) THEN MESON_TAC[]]]);;




(*****************************************************************)






let lemma_disjiont_union1a=prove(`!x:real^3 v:real^3 u:real^3 y:real^3 E:real^3->bool n. 
(y IN complement_sets x v u n) ==>(?i. (i IN (0..(n-1))) /\ ( y IN (wedge_fan2 x v u i UNION wedge_fan3 x v u i)))`, REPEAT GEN_TAC THEN
REWRITE_TAC[complement_sets; wedge_fan2; wedge_fan3; UNION] THEN REWRITE_TAC[IN_ELIM_THM] THEN MESON_TAC[]);;


let lemma_disjiont_union2a=prove(`!x:real^3 v:real^3 u:real^3 y:real^3 E:real^3->bool n. 
(?i. (i IN (0..(n-1)))/\ (y IN (wedge_fan2 x v u i UNION wedge_fan3 x v u i))) ==> (y IN complement_set {x,v}) `, 
REPEAT GEN_TAC THEN REWRITE_TAC[complement_set; wedge_fan2; wedge_fan3; UNION] THEN
REWRITE_TAC[IN_ELIM_THM] THEN MESON_TAC[]);;


let lemma_disjiont_unionsa=prove(`(y IN UNIONS {wedge_fan2 x v u i UNION wedge_fan3 x v u i | i IN (0..(n-1))}) <=> 
(?i. (i IN (0..(n-1)))/\ (y IN (wedge_fan2 x v u i UNION wedge_fan3 x v u i)))  `,
REWRITE_TAC[UNIONS] THEN REWRITE_TAC[IN_ELIM_THM] THEN MESON_TAC[]);;



let lemma_disjiont_unions2a=prove(`!x:real^3 v:real^3 u:real^3 y:real^3 E:real^3->bool n. 
(y IN UNIONS {wedge_fan2 x v u i UNION wedge_fan3 x v u i| i IN (0..(n-1))}) ==>(y IN complement_set {x,v}) `,
REPEAT GEN_TAC THEN STRIP_TAC THEN 
SUBGOAL_THEN `(?i. (i IN (0..(n-1)))/\ (y IN (wedge_fan2 x v u i UNION wedge_fan3 x v u i)))` ASSUME_TAC 
THENL
  [POP_ASSUM MP_TAC THEN MESON_TAC[lemma_disjiont_unionsa];
   POP_ASSUM MP_TAC THEN MESON_TAC[lemma_disjiont_union2a]]);;


let lemma_disjiont_unions1a= prove(`!x:real^3 v:real^3 u:real^3 y:real^3 E:real^3->bool n.
(y IN complement_sets x v u n) ==> (y IN UNIONS { (wedge_fan2 x v u i UNION wedge_fan3 x v u i) | i IN (0..(n-1))})`,
REPEAT GEN_TAC THEN STRIP_TAC THEN 
 SUBGOAL_THEN `(?i. (i IN (0..(n-1))) /\ (y IN (wedge_fan2 x v u i UNION wedge_fan3 x v u i)))` ASSUME_TAC
THENL 
   [ POP_ASSUM MP_TAC THEN MESON_TAC[lemma_disjiont_union1a];
    POP_ASSUM MP_TAC THEN MESON_TAC[lemma_disjiont_unionsa]]);;


let disjiont_union1a=prove(`!x:real^3 v:real^3 u:real^3  E:real^3->bool n.
complement_sets x v u n = complement_set {x,v}==>
(!y. ((y IN UNIONS {wedge_fan2 x v u i UNION wedge_fan3 x v u i | i IN (0..(n-1))})<=>(y IN complement_set {x,v})))`,
REPEAT GEN_TAC THEN STRIP_TAC THEN GEN_TAC THEN EQ_TAC 
THENL 
  [MESON_TAC[lemma_disjiont_unions2a];
   SUBGOAL_THEN `(y IN complement_sets x v u n) ==> (y IN UNIONS {wedge_fan2 x v u i UNION wedge_fan3 x v u i | i IN (0..(n-1))})` ASSUME_TAC
      THENL 
        [MESON_TAC[lemma_disjiont_unions1a]; 
         REPEAT (POP_ASSUM MP_TAC) THEN MESON_TAC[]]]);;


let disjiont_union2a=prove(`!x:real^3 v:real^3 u:real^3  E:real^3->bool n.
complement_sets x v u n = complement_set {x,v}==>
(UNIONS {wedge_fan2 x v u i UNION wedge_fan3 x v u i | i IN (0..(n-1))}=complement_set {x,v})`, 
REPEAT GEN_TAC THEN STRIP_TAC THEN REWRITE_TAC[FUN_EQ_THM] THEN
SUBGOAL_THEN `(!y. ((y IN UNIONS {wedge_fan2 x v u i UNION wedge_fan3 x v u i | i IN (0..(n-1))})<=>(y IN complement_set {x,v})))` ASSUME_TAC
THENL 
  [POP_ASSUM MP_TAC THEN MESON_TAC[disjiont_union1a]; 
   POP_ASSUM MP_TAC THEN REWRITE_TAC[IN]]);;

let lemma_disjiont1a=prove(`!x:real^3 v:real^3 u:real^3  E:real^3->bool n.
(complement_sets x v u n = complement_set {x,v})==>
((UNIV:real^3->bool)=aff {x,v} UNION (UNIONS {wedge_fan2 x v u i UNION wedge_fan3 x v u i | i IN (0..(n-1))}))`, REPEAT GEN_TAC THEN STRIP_TAC THEN
SUBGOAL_THEN `(UNIONS {wedge_fan2 x v u i UNION wedge_fan3 x v u i | i IN (0..(n-1))}=complement_set {x,v})` ASSUME_TAC 
THENL 
 [POP_ASSUM MP_TAC THEN MESON_TAC[disjiont_union2a];
 SUBGOAL_THEN `(UNIV:real^3->bool) = aff{x, v} UNION  complement_set {x, v}` ASSUME_TAC
     THENL
       [MESON_TAC[union_aff];
        REPEAT (POP_ASSUM MP_TAC) THEN MESON_TAC[]]]);;




(*******************[cor:W]*************************)

let disjiont_cor6dot1=prove(`!x:real^3 v:real^3 u:real^3 i. wedge_fan2 x v u i INTER wedge_fan3 x v u i={}`,
REPEAT GEN_TAC THEN REWRITE_TAC[wedge_fan2;wedge_fan3;FUN_EQ_THM] THEN GEN_TAC THEN 
REWRITE_TAC[INTER; EMPTY; IN_ELIM_THM] THEN
STRIP_TAC THEN REPEAT(POP_ASSUM MP_TAC) THEN DISCH_THEN(LABEL_TAC "a") THEN 
DISCH_THEN(LABEL_TAC "b") THEN
DISCH_THEN(LABEL_TAC "c") THEN
DISCH_THEN(LABEL_TAC "d") THEN
USE_THEN "a" MP_TAC THEN
USE_THEN "c" MP_TAC THEN
REAL_ARITH_TAC);;




let disjiont_cor6dot1a=prove(`!x:real^3 v:real^3 u:real^3 i j. 
(f_azim_fan x v u i<=f_azim_fan x v u j) ==> 
(wedge_fan2 x v u i INTER wedge_fan3 x v u j={})`,
REPEAT GEN_TAC THEN STRIP_TAC THEN REWRITE_TAC[wedge_fan2;wedge_fan3;FUN_EQ_THM] THEN GEN_TAC THEN 
REWRITE_TAC[INTER; EMPTY; IN_ELIM_THM] THEN
STRIP_TAC THEN REPEAT(POP_ASSUM MP_TAC) THEN DISCH_THEN(LABEL_TAC "a") THEN 
DISCH_THEN(LABEL_TAC "b") THEN
DISCH_THEN(LABEL_TAC "c") THEN
DISCH_THEN(LABEL_TAC "d") 
THEN DISCH_THEN(LABEL_TAC "f") THEN
SUBGOAL_THEN `(f_azim_fan x v u j < f_azim_fan x v u i)` ASSUME_TAC
THENL
  [ASM_REWRITE_TAC[];
    POP_ASSUM MP_TAC THEN DISCH_THEN(LABEL_TAC "g") THEN USE_THEN "a" MP_TAC THEN
USE_THEN "g" MP_TAC THEN REAL_ARITH_TAC]);;




let disjiont_cor6dot1b=prove(`!x:real^3 v:real^3 u:real^3 i j. 
(f_azim_fan x v u (j+1) <= f_azim_fan x v u i) ==> 
(wedge_fan2 x v u i INTER wedge_fan3 x v u j={})`,
REPEAT GEN_TAC THEN STRIP_TAC THEN REWRITE_TAC[wedge_fan2;wedge_fan3;FUN_EQ_THM] THEN GEN_TAC THEN 
REWRITE_TAC[INTER; EMPTY; IN_ELIM_THM] THEN
STRIP_TAC THEN REPEAT(POP_ASSUM MP_TAC) THEN DISCH_THEN(LABEL_TAC "a") THEN 
DISCH_THEN(LABEL_TAC "b") THEN
DISCH_THEN(LABEL_TAC "c") THEN
DISCH_THEN(LABEL_TAC "d") 
THEN DISCH_THEN(LABEL_TAC "f") THEN
SUBGOAL_THEN `(f_azim_fan x v u i < f_azim_fan x v u (j+1))` ASSUME_TAC
THENL
  [ASM_REWRITE_TAC[];
    POP_ASSUM MP_TAC THEN DISCH_THEN(LABEL_TAC "g")
      THEN USE_THEN "a" MP_TAC THEN
      USE_THEN "g" MP_TAC THEN REAL_ARITH_TAC]);;



let disjiont_cor6dot1c= prove(`!x:real^3 v:real^3 u:real^3 i j.
(f_azim_fan x v u (j+1) <= f_azim_fan x v u i)\/(f_azim_fan x v u i<=f_azim_fan x v u j) ==> 
(wedge_fan2 x v u i INTER wedge_fan3 x v u j={})`,
REPEAT GEN_TAC THEN STRIP_TAC 
THENL 
     [POP_ASSUM MP_TAC THEN MESON_TAC[disjiont_cor6dot1b];
      POP_ASSUM MP_TAC THEN MESON_TAC[disjiont_cor6dot1a]]);;





let disjiont1_cor6dot1 = prove(`!x:real^3 v:real^3 u:real^3 i. wedge_fan3 x v u i INTER aff {x,v}={}`,
REPEAT GEN_TAC THEN REWRITE_TAC[wedge_fan3; INTER] THEN REWRITE_TAC[complement_set; FUN_EQ_THM; EMPTY] THEN
GEN_TAC THEN REWRITE_TAC[IN_ELIM_THM] THEN STRIP_TAC THEN POP_ASSUM MP_TAC THEN POP_ASSUM MP_TAC
  THEN MESON_TAC[]);;


let disjiont2_cor6dot1=prove(`!x:real^3 v:real^3 u:real^3 i. wedge_fan3 x v u i INTER (aff {x,v} UNION wedge_fan2 x v u i)={}`,
REPEAT GEN_TAC THEN REWRITE_TAC[UNION_OVER_INTER] THEN SUBGOAL_THEN `wedge_fan3 x v u i INTER aff {x,v}={}` ASSUME_TAC
    THENL [MESON_TAC[disjiont1_cor6dot1];
          SUBGOAL_THEN `wedge_fan2 x v u i INTER wedge_fan3 x v u i={}` ASSUME_TAC
          THENL
              [MESON_TAC[disjiont_cor6dot1];
               SET_TAC[]]]);;


let disjiont2_cor6dot1a=prove(`!x:real^3 v:real^3 u:real^3 i. 
((f_azim_fan x v u (j+1) <= f_azim_fan x v u i)\/(f_azim_fan x v u i<=f_azim_fan x v u j))==>
(wedge_fan3 x v u j INTER (aff {x,v} UNION wedge_fan2 x v u i)={})`,
REPEAT GEN_TAC THEN REWRITE_TAC[UNION_OVER_INTER] THEN DISCH_TAC THEN 
SUBGOAL_THEN `wedge_fan3 x v u j INTER aff {x,v}={}` ASSUME_TAC
    THENL 
       [MESON_TAC[disjiont1_cor6dot1];
        SUBGOAL_THEN `wedge_fan2 x v u i INTER wedge_fan3 x v u j={}` ASSUME_TAC
       THENL
          [ REPEAT(POP_ASSUM MP_TAC) THEN 
            DISCH_THEN (LABEL_TAC "a") THEN 
            DISCH_THEN(LABEL_TAC "b")  THEN
            USE_THEN "a" MP_TAC THEN MESON_TAC[disjiont_cor6dot1c];
                SET_TAC[]]]);;








let aff_ge_subset_aff_gt_union_aff=prove(`!x:real^3 v:real^3 w:real^3. 
(!x:real^3 v:real^3. aff {x , v} = {y:real^3| ?t1:real t2:real. (t1 + t2 = &1 )/\ (y = t1 % x + t2 % v )})
/\ (!x:real^3 v:real^3 w:real^3. aff_gt {x , v} {w} = {y:real^3 | ?t1:real t2:real t3:real. (t3 > &0) /\ (t1 + t2 + t3 = &1) /\ (y = t1 % x + t2 % v + t3 % w)})
/\ (!x:real^3 v:real^3 w:real^3. aff_ge {x} {v, w}={y:real^3 |  ?t1:real t2:real t3:real. (t2 >= &0)/\ (t3 >= &0) /\ (t1 + t2 + t3 = &1) /\ (y = t1 % x + t2 % v + t3 % w)})
==> 
 aff_ge {x} {v , w} SUBSET  (aff_gt {x , v} {w}) UNION (aff {x, v})   `,
REPEAT GEN_TAC THEN STRIP_TAC THEN ASM_REWRITE_TAC[] THEN REWRITE_TAC[SUBSET; UNION; IN_ELIM_THM] THEN GEN_TAC THEN
REWRITE_TAC[REAL_ARITH `((t3:real) >= &0) <=> (t3 > &0) \/ ( t3 = &0)`; TAUT `(a \/ b) /\ (c \/ d) /\ e /\ f <=> ((a \/ b)/\ c /\ e /\ f) \/ ((a \/ b) /\ d /\ e /\ f)`; EXISTS_OR_THM] THEN MATCH_MP_TAC MONO_OR THEN
SUBGOAL_THEN `((?t1:real t2:real t3:real.
       (t2 > &0 \/ t2 = &0) /\
       t3 > &0 /\
       t1 + t2 + t3 = &1 /\
       (x':real^3) = t1 % x + t2 % v + t3 % w)
  ==> (?t1 t2 t3.
           t3 > &0 /\ t1 + t2 + t3 = &1 /\ x' = t1 % x + t2 % v + t3 % w))` ASSUME_TAC THENL
    [MESON_TAC[];
     ASM_REWRITE_TAC[] THEN MATCH_MP_TAC MONO_EXISTS THEN GEN_TAC THEN MATCH_MP_TAC MONO_EXISTS THEN GEN_TAC THEN
     REWRITE_TAC[LEFT_IMP_EXISTS_THM] THEN GEN_TAC THEN
     REWRITE_TAC[REAL_ARITH `((t2:real) > &0 \/ (t2 = &0)) <=> (t2 >= &0)`] THEN STRIP_TAC THEN POP_ASSUM MP_TAC THEN
     POP_ASSUM MP_TAC THEN ASM_REWRITE_TAC[] THEN
     REWRITE_TAC [REAL_ARITH `(a:real)+ &0 = a`; VECTOR_ARITH  `&0 % (w:real^3) = vec 0`; 
     VECTOR_ARITH `  ((x':real^3) = (t1:real) % (x:real^3) + (t2:real) % (v:real^3) + vec 0)<=> ( x' = t1 % x + t2 % v )` ]
       THEN MESON_TAC[]]);;







let aff_ge_subset_wedge_fan2_union_aff=prove(`
(!x:real^3 v:real^3. aff {x , v} = {y:real^3| ?t1:real t2:real. (t1 + t2 = &1 )/\ (y = t1 % x + t2 % v )}) 
/\ (!x:real^3 v:real^3 u:real^3 w:real^3. aff_gt {x , v} {w} = {y:real^3 | ?t1:real t2:real t3:real. (t3 > &0) /\ (t1 + t2 + t3 = &1) /\ (y = t1 % x + t2 % v + t3 % w)})
/\ (!x:real^3 v:real^3 u:real^3 w:real^3 t1:real t2:real t3:real. ~(t3 = &0) /\ (t1 + t2 + t3 = &1)  ==> azim x v u w =
 azim x v u (t1 % x + t2 % v + t3 % w))
/\ (!x:real^3 v:real^3 u:real^3 w:real^3. {y:real^3 |  azim x v u w =
 azim x v u y}=aff_gt {x , v} {w})
/\ (!x:real^3 v:real^3 w:real^3. aff_ge {x} {v, w}={y:real^3 |  ?t1:real t2:real t3:real. (t2 >= &0)/\ (t3 >= &0) /\ (t1 + t2 + t3 = &1) /\ (y = t1 % x + t2 % v + t3 % w)})
==> 
(!x:real^3 v:real^3 u:real^3  i:num.  ~( (power_map_point sigma_fan v u i) IN aff {x, v})
==>
 aff_ge {x} {v , (power_map_point sigma_fan v u i)} SUBSET   (wedge_fan2 x v u i)  UNION (aff {x, v}))   `,
DISCH_TAC THEN REPEAT GEN_TAC THEN DISCH_TAC THEN
SUBGOAL_THEN ` wedge_fan2 x v u i = aff_gt {(x:real^3) , (v:real^3)} {power_map_point sigma_fan (v:real^3) (u:real^3) (i:num)}` ASSUME_TAC THENL 
     [ASM_MESON_TAC[ wedge_fan2_equal_aff_gt];
      POP_ASSUM (fun th -> REWRITE_TAC[th] THEN (ASSUME_TAC th)) THEN
      ASM_MESON_TAC[ aff_ge_subset_aff_gt_union_aff]]);;
  



let disjiont_aff_ge_wedge_fan3=prove(`
(!x:real^3 v:real^3. aff {x , v} = {y:real^3| ?t1:real t2:real. (t1 + t2 = &1 )/\ (y = t1 % x + t2 % v )}) 

/\ (!x:real^3 v:real^3 u:real^3 w:real^3. aff_gt {x , v} {w} = {y:real^3 | ?t1:real t2:real t3:real. (t3 > &0) /\ (t1 + t2 + t3 = &1) /\ (y = t1 % x + t2 % v + t3 % w)})
/\ (!x:real^3 v:real^3 u:real^3 w:real^3 t1:real t2:real t3:real. ~(t3 = &0) /\ (t1 + t2 + t3 = &1)  ==> azim x v u w =
 azim x v u (t1 % x + t2 % v + t3 % w))
/\ (!x:real^3 v:real^3 u:real^3 w:real^3. {y:real^3 |  azim x v u w =
 azim x v u y}=aff_gt {x , v} {w})
/\ (!x:real^3 v:real^3 w:real^3. aff_ge {x} {v, w}={y:real^3 |  ?t1:real t2:real t3:real. (t2 >= &0)/\ (t3 >= &0) /\ (t1 + t2 + t3 = &1) /\ (y = t1 % x + t2 % v + t3 % w)})
==> 
(!x:real^3 v:real^3 u:real^3  i:num. ~( (power_map_point sigma_fan v u i) IN aff {x, v})
==>
( aff_ge {x} {v , (power_map_point sigma_fan v u i)})  INTER (wedge_fan3 x v u i) = {} )`,
 
STRIP_TAC THEN REPEAT GEN_TAC THEN STRIP_TAC THEN
SUBGOAL_THEN ` aff_ge {(x:real^3)} {(v:real^3) , (power_map_point sigma_fan v (u:real^3) (i:num))} SUBSET   (wedge_fan2 x v u i)  UNION (aff {x, v})   ` ASSUME_TAC THENL
  [ASM_MESON_TAC[aff_ge_subset_wedge_fan2_union_aff];
   SUBGOAL_THEN `wedge_fan3 x v u i INTER (aff {x,v} UNION wedge_fan2 x v u i)={}` ASSUME_TAC
    THENL
       [MESON_TAC[disjiont2_cor6dot1];
        SET_TAC[]]]);;



let disjiont_aff_ge_wedge_fan3a=prove(`
(!x:real^3 v:real^3. aff {x , v} = {y:real^3| ?t1:real t2:real. (t1 + t2 = &1 )/\ (y = t1 % x + t2 % v )}) 

/\ (!x:real^3 v:real^3 u:real^3 w:real^3. aff_gt {x , v} {w} = {y:real^3 | ?t1:real t2:real t3:real. (t3 > &0) /\ (t1 + t2 + t3 = &1) /\ (y = t1 % x + t2 % v + t3 % w)})
/\ (!x:real^3 v:real^3 u:real^3 w:real^3 t1:real t2:real t3:real. ~(t3 = &0) /\ (t1 + t2 + t3 = &1)  ==> azim x v u w =
 azim x v u (t1 % x + t2 % v + t3 % w))
/\ (!x:real^3 v:real^3 u:real^3 w:real^3. {y:real^3 |  azim x v u w =
 azim x v u y}=aff_gt {x , v} {w})
/\ (!x:real^3 v:real^3 w:real^3. aff_ge {x} {v, w}={y:real^3 |  ?t1:real t2:real t3:real. (t2 >= &0)/\ (t3 >= &0) /\ (t1 + t2 + t3 = &1) /\ (y = t1 % x + t2 % v + t3 % w)})
/\ (!x:real^3 v:real^3 u:real^3 i:num j:num. 
(f_azim_fan x v u (j+1) <= f_azim_fan x v u i)\/(f_azim_fan x v u i<=f_azim_fan x v u j))
==>
(!x:real^3 v:real^3 u:real^3  i:num j:num. ~( (power_map_point sigma_fan v u i) IN aff {x, v})
==>
(( aff_ge {x} {v , (power_map_point sigma_fan v u i)}) INTER (wedge_fan3 x v u j) = {})) `,

STRIP_TAC THEN REPEAT GEN_TAC THEN STRIP_TAC THEN
SUBGOAL_THEN ` aff_ge {(x:real^3)} {(v:real^3) , (power_map_point sigma_fan v (u:real^3) (i:num))} SUBSET   (wedge_fan2 x v u i)  UNION (aff {x, v})   ` ASSUME_TAC THENL
  [ASM_MESON_TAC[aff_ge_subset_wedge_fan2_union_aff];
   SUBGOAL_THEN `wedge_fan3 x v u j INTER (aff {x,v} UNION wedge_fan2 x v u i)={}` ASSUME_TAC
     THENL
       [ASM_MESON_TAC[disjiont2_cor6dot1a];
        SET_TAC[]]]);;






(*************JGIYDLE*******************)

let rcone_fan = new_definition `rcone_fan  x v h = {y:real^3 | (y-x) dot (v-x) >(dist(y,x)*dist(v,x)*h)}`;;


let wedge_fane=new_definition`wedge_fane x v u i h= wedge_fan3 x v u i INTER rcone_fan x v h`;;


let wedge_cap1=new_definition`wedge_cap1 x v u i h r= (normball x r) INTER (wedge_fane x v u i h)`;;



let lemma_4dot31=prove(`(!x:real^3 v:real^3. aff {x , v} = {y:real^3| ?t1:real t2:real. (t1 + t2 = &1 )/\ (y = t1 % x + t2 % v )}) 
/\ (!x:real^3 v:real^3 u:real^3 w:real^3. aff_gt {x , v} {w} = {y:real^3 | ?t1:real t2:real t3:real. (t3 > &0) /\ (t1 + t2 + t3 = &1) /\ (y = t1 % x + t2 % v + t3 % w)})
/\ (!x:real^3 v:real^3 u:real^3 w:real^3 t1:real t2:real t3:real. ~(t3 = &0) /\ (t1 + t2 + t3 = &1)  ==> azim x v u w =
 azim x v u (t1 % x + t2 % v + t3 % w))
/\ (!x:real^3 v:real^3 u:real^3 w:real^3. {y:real^3 |  azim x v u w =
 azim x v u y}=aff_gt {x , v} {w})
/\ (!x:real^3 v:real^3 w:real^3. aff_ge {x} {v, w}={y:real^3 |  ?t1:real t2:real t3:real. (t2 >= &0)/\ (t3 >= &0) /\ (t1 + t2 + t3 = &1) /\ (y = t1 % x + t2 % v + t3 % w)})
/\ (!x:real^3 v:real^3 u:real^3 i:num j:num. 
(f_azim_fan x v u (j+1) <= f_azim_fan x v u i)\/(f_azim_fan x v u i<=f_azim_fan x v u j))
==>
(!x:real^3 v:real^3 u:real^3  i:num j:num h:real. ~( (power_map_point sigma_fan v u i) IN aff {x, v})
==>
(( aff_ge {x} {v , (power_map_point sigma_fan v u i)}) INTER (wedge_fane x v u j h) = {})) `,
STRIP_TAC THEN REPEAT GEN_TAC THEN DISCH_TAC THEN REWRITE_TAC[wedge_fane] THEN
SUBGOAL_THEN `(( aff_ge {(x:real^3)} {(v:real^3) , (power_map_point sigma_fan v (u:real^3) (i:num))}) INTER (wedge_fan3 (x:real^3) v u (j:num)) = {})` ASSUME_TAC  THENL
  [ASM_MESON_TAC[disjiont_aff_ge_wedge_fan3a];
   SET_TAC[]]);;


 
