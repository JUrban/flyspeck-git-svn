(* ========================================================================== *)
(* FLYSPECK - BOOK FORMALIZATION                                              *)
(*                                                                            *)
(* Lemma: Easy Linear Programs     *)
(* Chapter: Tame Hypermap                  *)
(* Author: Thomas C. Hales                                                    *)
(* Date: 2009-06-25                 *)
(* ========================================================================== *)

(*

This file treats all but a few "hard" cases (hard_bb).

needs new mktop on platforms that do not support dynamic loading of Str.

ocamlmktop unix.cma nums.cma str.cma -o ocampl
./ocampl

glpk needs to be installed, and glpsol needs to be found in the path.
*)

module Lpproc = struct 

open Glpk_link;;
open List;;


(* external files. graph0.mod is the concatenation of graph0.mod, body.mod, tail.mod. *)
let archiveraw = "/tmp/tame_graph.txt";; (*read only *)
let model = "/tmp/graph0.mod";; (* read only *)
let tmpfile = "/tmp/graph.dat";;  (* temporary output *)
let dumpfile = "/tmp/graph.out";; (* temp output *)

(* conversion to list.  e.g. convert_to_ordered_list pentstring *)

(* 
   The order in which the faces occur is the order of branch n bound.
   The order affects the effectiveness of the branch and bound.
   My heuristic is to branch on hexagons, then quads, then pents, then tris.
   Within faces of a given size, look for nodes that appear frequently.
*)
let order_list (h,xs) = 
  let fl = flatten xs in
  let count k = length (filter ((=) k) fl) in
  let mc rs = maxlist0 (map count rs) in
  let sortfn a b = compare (mc b) (mc a) in
  let r k = filter (fun x -> length x = k) xs in
  let f k = sort sortfn (r k) in
   (h,f 6 @ f 4 @ f 5 @ f 3);;

let convert_to_ordered_list s = order_list (convert_to_list s);;


(* type for holding the parameters for a linear program *)

type branchnbound = 
  { 
    hypermap_id : string;
    mutable lpvalue : float option;
    mutable hints : int list list;  (* hints about branching *) 
    string_rep : string;
    (* std_faces is the disjoint union of std_faces_not_super, std56_flat_free, std4_diag3 *)
    std_faces_not_super: int list list;
    std56_flat_free : int list list;
    std4_diag3 : int list list;
    std3_big : int list list;
    std3_small : int list list;
    (* special dart appears first in next ones *)
    apex_sup_flat : int list list;
    apex_flat : int list list;
    apex_A : int list list;
    apex5 : int list list;
    apex4 : int list list;
    (* edge lists *)
    d_edge_225_252 :  int list list;
    d_edge_200_225 :  int list list;
    (* node lists *)
    node_218_252 : int list;
    node_236_252 : int list;
    node_218_236 : int list;
    node_200_218 : int list;
  };;

let mk_bb s = 
  let (h,face1) = convert_to_ordered_list s in
 {hypermap_id= h;
  lpvalue = None;
  hints = [];
  string_rep=s;
  std_faces_not_super = face1;
  std3_big=[];
  std3_small=[];
  std4_diag3=[];
  std56_flat_free=[];

  apex_flat=[];
  apex_sup_flat=[];
  apex_A=[];
  apex4=[];
  apex5=[];

  d_edge_225_252=[];
  d_edge_200_225=[];

  node_218_252=[];
  node_236_252=[];
  node_218_236=[];
  node_200_218=[];
 };;

let pent_bb = mk_bb pentstring;;

(* conversion to branchnbound.  e.g. mk_bb pentstring  *)

let modify_bb bb drop1std fields vfields = 
  let add key xs t = nub ((get_values key xs) @ t)  in
  let shuffle key xs vs = 
    let ys = get_values key xs in 
    let e = rotation ys in
      nub(ys @ (filter (fun t -> not(mem t e)) vs)) in 
  let std = bb.std_faces_not_super in
  let shuffle_std = shuffle "sh" fields std in 
{
hypermap_id = bb.hypermap_id;
lpvalue = None;
hints = bb.hints;
string_rep = bb.string_rep;

std_faces_not_super = if drop1std then tl std else shuffle_std;
std3_big = add "bt" fields bb.std3_big;
std3_small = add "st" fields bb.std3_small;
std56_flat_free = add "flat_free" fields bb.std56_flat_free;
std4_diag3 = add "diag3" fields bb.std4_diag3;

apex_flat = add "ff" fields bb.apex_flat;
apex_sup_flat = add "sf" fields bb.apex_sup_flat;
apex_A = add "af" fields bb.apex_A;
apex4 = add "apex4" fields bb.apex4;
apex5 = add "apex5" fields bb.apex5;

d_edge_225_252 = add "e_225_252" fields bb.d_edge_225_252;
d_edge_200_225 = add "e_200_225" fields bb.d_edge_200_225;

node_218_252 = add "218_252" vfields bb.node_218_252;
node_236_252 = add "236_252" vfields bb.node_236_252;
node_218_236 = add "218_236" vfields bb.node_218_236;
node_200_218 = add "200_218" vfields bb.node_200_218;
};;

(*
Example: move [8;1;6;9] from std to std56_flat_free.

modify_bb pent_bb true  ["flat_free",[8;1;6;9];"ff",[9;10;11]] ["200_218",8;"218_252",3;"200_218",7];;
pent_bb;;
modify_bb pent_bb false ["sh",[0;3;5;4];"sh",[10;6;4]] [];;
*)

(* functions on branch n bound *)

let std_faces bb = bb.std_faces_not_super @ bb.std56_flat_free @ bb.std4_diag3;;
(*  @ bb.std3_big @ bb.std3_small;; *)

let std_tri_prebranch bb = filter 
   (let r = rotation (bb.std3_big @ bb.std3_small) in
       fun t -> not(mem t r)  && (length t = 3)) bb.std_faces_not_super;;

(* should sort faces, so that numbering doesn't change so much when branching *)

let faces bb = (std_faces bb) @ bb.apex_sup_flat @ bb.apex_flat @ 
  bb.apex_A @ bb.apex5 @ bb.apex4;;

let triples w = 
  let r j = nth w (j mod length w)  in
  let triple i = 
      [r i; r (i+1); r(i+2)] in
    map triple (up (length w));;

let card_node bb =
  1+ maxlist0 (flatten (faces bb));;

let card_face bb = length(faces bb);;

let std_face_of_size bb r= 
  let f = std_faces bb in
  let z = enumerate f in 
    fst(split (filter (function _,y -> length y=r) z));;

(* generate ampl data string of branch n bound *)

let ampl_of_bb outs bb = 
  let fs = faces bb in
  let where3 = wheremod fs in
  let number = map where3 in
  let list_of = unsplit " " string_of_int in
  let mk_faces xs = list_of (number xs) in
  let e_dart_raw  = 
    map triples fs in
  let e_dart =
    let edata_row (i,x) = (sprintf "(*,*,*,%d) " i)^(unsplit ", " list_of x) in
      unsplit "\n" edata_row (enumerate e_dart_raw) in 
  let mk_dart xs = sprintf "%d %d" (hd xs) (where3 xs) in
  let mk_darts xs = (unsplit ", " mk_dart xs) in
  let p = sprintf in
  let j = join_lines [
    p"param card_node := %d;" (card_node bb) ;
    p"param hypermap_id := %s;" bb.hypermap_id ; 
    p"param card_face := %d;\n" (card_face bb);
    p"set std3 := %s;" (list_of (std_face_of_size bb 3)) ;
    p"set std4 := %s;" (list_of (std_face_of_size bb 4) );
    p"set std5 := %s;" (list_of (std_face_of_size bb 5)) ;
    p"set std6 := %s;\n" (list_of (std_face_of_size bb 6));
    p"set e_dart := \n%s;\n"  (e_dart);
    p"set std56_flat_free := %s;" (mk_faces bb.std56_flat_free);
    p"set std4_diag3 := %s;" (mk_faces bb.std4_diag3);
    p"set apex_sup_flat := %s;" (mk_darts bb.apex_sup_flat);
    p"set apex_flat := %s;" (mk_darts bb.apex_flat);
    p"set apex_A := %s;" (mk_darts bb.apex_A);
    p"set apex5 := %s;" (mk_darts bb.apex5);
    p"set apex4 := %s;" (mk_darts bb.apex4);
    p"set d_edge_225_252 := %s;" (mk_darts bb.d_edge_225_252);
    p"set d_edge_200_225 := %s;" (mk_darts bb.d_edge_200_225);
    p"set std3_big := %s;" (mk_faces bb.std3_big);
    p"set std3_small := %s;"  (mk_faces bb.std3_small);
    p"set node_218_252 := %s;" (list_of bb.node_218_252);
    p"set node_236_252 := %s;" (list_of bb.node_236_252);
    p"set node_218_236 := %s;" (list_of bb.node_218_236);
    p"set node_200_218 := %s;" (list_of bb.node_200_218)] in
    Printf.fprintf outs "%s" j;;  

(* running of branch in glpsol *)

let solve_branch_verbose addhints bb = 
  let set_some bb r = (* side effects *)
    if (length r = 1) then bb.lpvalue <- Some (float_of_string(hd r)) else () in
  let inp = solve_branch_f model dumpfile "lnsum" ampl_of_bb bb in
  let _ = addhints bb in (* hints for control flow *)
  let _ = set_some bb inp in
  let r = match bb.lpvalue with
    | None -> -1.0
    | Some r -> r in
  let _ = Sys.command(sprintf "echo %s: %3.3f\n" bb.hypermap_id r) in 
    bb;;

let solve_f f bb = match bb.lpvalue with
  | None -> solve_branch_verbose f bb
  | Some _ -> bb;;

let solve bb = solve_f (fun t -> t) bb;;

(* filtering output *)

let filter_feas_f f bbs = 
  let feasible r = (r > 11.999) in (* relax a bit from 12.0 *)
  let sol = map (fun t -> solve_f f t) bbs in
    let fil ro = match ro.lpvalue with
	None -> true
      | Some r -> feasible r in 
      filter fil sol;;

let filter_feas bbs = filter_feas_f (fun t->t) bbs;;

(* 
branching on face data:
switch_face does all the branching on the leading std face 
*)

let split_flatq xs i =  (* {y1,y3} is the new diagonal *)
  match rotateL i xs with
    | y1::y2::y3::ys  ->  ([y2;y3;y1],rotateR 1 (y1 :: y3 :: ys))
    | _ -> failwith "split_flatq match";;
  
let asplit_pent xs i = match rotateL i xs with
(* y2,y4 darts of flat; y3 is the point of the A, {y1,y3}, {y3,y5} diags *)
  | y1::y2::y3::y4::[y5] ->  ([y2;y3;y1],[y3;y5;y1],[y4;y5;y3])
  | _ -> failwith "asplit_pent match error";;

let switch3 bb = match std_tri_prebranch bb with
  | [] -> failwith ("switch3 empty " ^ bb.hypermap_id)
  | fc::_  ->   [modify_bb bb false ["bt",fc] [];modify_bb bb false ["st",fc] []];;

let switch4 bb = match bb.std_faces_not_super with
  | [] -> failwith ("switch4 empty" ^ bb.hypermap_id)
  | fc::_  ->
  let mo s (a,b) = modify_bb bb true [s,a;s,b] [] in
  let f s i = mo s (split_flatq fc i) in
  let g s = modify_bb bb true [s,fc] [] in
  [f "ff" 0;f "ff" 1; f "sf" 0; f "sf" 1;g "diag3"];;

let switch5 bb = match  bb.std_faces_not_super with
  | [] -> failwith ("switch5 empty" ^ bb.hypermap_id)
  | fc::_ -> 
  let mo (a,b) = modify_bb bb true ["ff",a;"apex4",b] [] in    
  let f i = mo (split_flatq fc i) in
  let bbs = map f (up 5) in
  let mo (a,b,c) = modify_bb bb true ["ff",a;"af",b;"ff",c] [] in
  let f i = mo (asplit_pent fc i) in
  let ccs = map f (up 5) in
   (modify_bb bb true ["flat_free",fc] []) :: bbs @ ccs ;;

let switch6 bb = match bb.std_faces_not_super with
  | [] -> failwith ("switch6 empty" ^ bb.hypermap_id)
  | fc::_ ->
  let mo (a,b) = modify_bb bb true ["ff",a;"apex5",b] [] in
  let f i = mo (split_flatq fc i) in
   (modify_bb bb true ["flat_free",fc] []) :: (map f (up 6));;

let switch_face bb = match bb.std_faces_not_super with
  | [] -> [bb]
  | fc::_ ->
      let j = length fc in
      let fn = (nth [switch3;switch4;switch5;switch6] (j-3)) in
	fn bb;;

let echo bbs = Sys.command (sprintf "echo STACK %d %d" (length bbs) (nextc()));;

let onepass bbs = 
  let branches = flatten (map switch_face bbs) in
  let _ = echo bbs in
    filter_feas branches;;

let rec allpass count bbs = 
   let t = maxlist0 (map (fun b -> length (std_tri_prebranch b)) bbs) in
   if t = 0 or count <= 0 then bbs else allpass (count - 1) (onepass bbs);;

let hardid = 
[
(* {3,3,3,3,3,3} *) "161847242261";
(* {3,3,3,3,3,3} *) "223336279535";
(* {3,3,3,3,3,3} *) "86506100695";
(* one quad {3,3,4} *) "179189825656"; 
(* two quad {3,4,4} *) "154005963125";
(* {4,4,4} *) "65974205892"; 
(* added 2010-06-24 *)
"50803004532";"39599353438";"242652038506";
"88089363170";"75641658977";"34970074286";
];;

(*
tame_bb is the entire archive.
feasible_bb are those that pass the first elementary linear program.
hard_bb are those known to be difficult, and easy_bb is the complement.
remaining_easy_bb should be empty; the easy ones should be entirely treated.
*)

let execute() = (* takes about 2.5 hours to run *)
  let tame = strip_archive archiveraw in
  let tame_bb = map mk_bb tame in
  let feasible_bb =  filter_feas (map solve tame_bb) in
  let (hard_bb,easy_bb) = partition (fun t -> (mem t.hypermap_id hardid)) feasible_bb in
  let remaining_easy_bb = allpass 20 easy_bb in
  (tame_bb,feasible_bb,hard_bb,easy_bb,remaining_easy_bb);;

end;;
