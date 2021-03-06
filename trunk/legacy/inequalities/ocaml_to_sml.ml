
(* -------------------------------------------------------------------------- *)
(*  Signature                                                                 *)
(* -------------------------------------------------------------------------- *)

module type Ocaml_sml =
sig

  type const_name = | Dodec_slope
                    | Dd_31
                    | Dd_32
                    | Dd_33
                    | Dd_41
                    | Dd_42
                    | Dd_51
                    | Doct
                    | Dodec_trunc
                    | Pi
                    | Ppa1
                    | Ppa2
                    | Ppd0
                    | Ppm
                    | Ppb
                    | Ppa
                    | Ppbc
                    | Ppc
                    | Ppd
                    | Ppsolt0
                    | Pt
                    | Ss_5
                    | Sqrt2
                    | Sqrt8
                    | Square_2t0
                    | Sqrt_2t0
                    | Square_4t0
                    | Tt_0
                    | Tt_5
                    | Two_dodec_trunc
                    | Two_dodec_trunc_sq
                    | Two_t0
                    | Xi_gamma
                    | Xi'_gamma
                    | Xiv
                    | Zz_32
                    | Zz_33
                    | Zz_41
                    | Zz_42

  type func_name = | Anc
                   | Arclength
                   | Beta
                   | Chi_x
                   | Cross_diag_x
                   | Crown
                   | Delta_x
                   | Dih_x
                   | Dih2_x
                   | Dih3_x
                   | Dihr
                   | Eta_x
                   | Gamma_x
                   | Kappa
                   | Kx
                   | Mu_flat_x
                   | Mu_flipped_x
                   | Mu_upright_x
                   | Nu_gamma_x
                   | Nu_x
                   | Octa_x
                   | Octavor0_x
                   | Octavor_analytic_x
                   | Omega_x
                   | Overlap_f
                   | Quo_x
                   | Rad2_x
                   | Sigma1_qrtet_x
                   | Sigma32_qrtet_x
                   | Sigma_qrtet_x
                   | Sigmahat_x
                   | Sol_x
                   | Squander_x
                   | Taua_x
                   | Tauc0_x
                   | Tauvt_x
                   | Tau_0_x
                   | Tau_analytic_x
                   | Tau_sigma_x
                   | Tauhat_x
                   | Tauhatpi_x
                   | Taumu_flat_x
                   | Taunu_x
                   | Truncated_volume_x
                   | U_x
                   | V0x
                   | V1x
                   | Volume_x
                   | Vora_x
                   | Vorc0_x
                   | Vorc_x
                   | Vor_0_x
                   | Vor_0_x_flipped
                   | Vor_analytic_x
                   | Vor_analytic_x_flipped
                   | Vort_x

  type const = | Decimal of int * int
               | Int of int
               | Named of const_name
               | Sqr of const
               | Sqrt of const
               | Cos of const
               | Acos of const
               | Copp of const
               | Cplus of const * const
               | Cmul of const * const
               | Cdiv of const * const

  type expr = | Const of const
              | Funcall of func_name * expr list
              | Var of string
              | Varsqrt of string
              | Opp of expr
              | Mul of expr * expr
              | Div of expr * expr
              | Pow of expr * int
              | One

  type monom = const * expr

  type lcomb = monom list

  type bounds = {lo : const;
                 hi : const}

  type ineq = {name : string;
               vars : (string * bounds) list;
               rels : lcomb list}

  (* 
     put the hales inequalities in a normal form 

     !x_1 ... x_n. ineq [lower_1,x_1,upper_1;
                         ...;
                         lower_n,x_n,upper_n]
                        c_1_1 f_1 + ... + c_1_m f_m < &0 \/
                        ... \/
                        c_k_1 f_k + ... + c_k_m f_m < &0
   *)
  val normalize : Term.term -> Term.term


  (* Translate HOL Light term to OCaml datatype *)
  val translate : string * Term.term -> ineq

  val translate_list : ignore : string list -> 
                       terms : (string * Term.term) list -> ineq list

  (* Print Ocaml datatype as an SML datatype *)
  val ineq_to_sml : ineq -> unit

  val ineqs_to_sml : file:string -> ineqs:ineq list -> unit

end

(* -------------------------------------------------------------------------- *)
(*  Structure                                                                 *)
(* -------------------------------------------------------------------------- *)

module Ocaml_sml (* : Ocaml_sml *) = 
struct 

  type const_name = | Dodec_slope
                    | Dd_31
                    | Dd_32
                    | Dd_33
                    | Dd_41
                    | Dd_42
                    | Dd_51
                    | Doct
                    | Dodec_trunc
                    | Pi
                    | Ppa1
                    | Ppa2
                    | Ppd0
                    | Ppm
                    | Ppb
                    | Ppa
                    | Ppbc
                    | Ppc
                    | Ppd
                    | Ppsolt0
                    | Pt
                    | Ss_5
                    | Sqrt2
                    | Sqrt8
                    | Square_2t0
                    | Sqrt_2t0
                    | Square_4t0
                    | Tt_0
                    | Tt_5
                    | Two_dodec_trunc
                    | Two_dodec_trunc_sq
                    | Two_t0
                    | Xi_gamma
                    | Xi'_gamma
                    | Xiv
                    | Zz_32
                    | Zz_33
                    | Zz_41
                    | Zz_42

  type func_name = | Anc
                   | Arclength
                   | Beta
                   | Chi_x
                   | Cross_diag_x
                   | Crown
                   | Delta_x
                   | Dih_x
                   | Dih2_x
                   | Dih3_x
                   | Dihr
                   | Eta_x
                   | Gamma_x
                   | Kappa
                   | Kx
                   | Mu_flat_x
                   | Mu_flipped_x
                   | Mu_upright_x
                   | Nu_gamma_x
                   | Nu_x
                   | Octa_x
                   | Octavor0_x
                   | Octavor_analytic_x
                   | Omega_x
                   | Overlap_f
                   | Quo_x
                   | Rad2_x
                   | Sigma1_qrtet_x
                   | Sigma32_qrtet_x
                   | Sigma_qrtet_x
                   | Sigmahat_x
                   | Sol_x
                   | Squander_x
                   | Taua_x
                   | Tauc0_x
                   | Tauvt_x
                   | Tau_0_x
                   | Tau_analytic_x
                   | Tau_sigma_x
                   | Tauhat_x
                   | Tauhatpi_x
                   | Taumu_flat_x
                   | Taunu_x
                   | Truncated_volume_x
                   | U_x
                   | V0x
                   | V1x
                   | Volume_x
                   | Vora_x
                   | Vorc0_x
                   | Vorc_x
                   | Vor_0_x
                   | Vor_0_x_flipped
                   | Vor_analytic_x
                   | Vor_analytic_x_flipped
                   | Vort_x

  type const = | Decimal of int * int
               | Int of int
               | Named of const_name
               | Sqr of const
               | Sqrt of const
               | Cos of const
               | Acos of const
               | Copp of const
               | Cplus of const * const
               | Cmul of const * const
               | Cdiv of const * const

  type expr = | Const of const
              | Funcall of func_name * expr list
              | Var of string
              | Varsqrt of string
              | Opp of expr
              | Mul of expr * expr
              | Div of expr * expr
              | Pow of expr * int
              | One

  type monom = const * expr

  type lcomb = monom list

  type bounds = {lo : const;
                 hi : const}

  type ineq = {name : string;
               vars : (string * bounds) list;
               rels : lcomb list}

  (* -------------------------------------------------------------------------- *)
  (*  Util                                                                      *)
  (* -------------------------------------------------------------------------- *)

  (* remove "kepler'" from the front of a name *)
  let unkepler s = 
    try
      let kep = String.sub s 0 7 in
        if kep = "kepler'" then String.sub s 7 (String.length s - 7)
        else s
    with Invalid_argument _ -> s

  let const_of_string const = match const with
    | "D31" -> Dd_31
    | "D32" -> Dd_32
    | "D33" -> Dd_33
    | "D41" -> Dd_41
    | "D42" -> Dd_42
    | "D51" -> Dd_51
    | "dodecSlope" -> Dodec_slope
    | "dodecTrunc" -> Dodec_trunc
    | "Z32" -> Zz_32
    | "Z33" -> Zz_33
    | "Z41" -> Zz_41
    | "Z42" -> Zz_42
    | "doct" -> Doct
    | "pi" -> Pi
    | "pp_a1" -> Ppa1
    | "pp_a2" -> Ppa2
    | "pp_d0" -> Ppd0
    | "pp_m" -> Ppm
    | "pp_b" -> Ppb
    | "pp_a" -> Ppa
    | "pp_bc" -> Ppbc
    | "pp_c" -> Ppc
    | "pp_d" -> Ppd
    | "pp_solt0" -> Ppsolt0
    | "pt" -> Pt
    | "s5" -> Ss_5
    | "sqrt2" -> Sqrt2
    | "sqrt8" -> Sqrt8
    | "sqrt_2t0" -> Sqrt_2t0
    | "square_2t0" -> Square_2t0
    | "square_4t0" -> Square_4t0
    | "t0" -> Tt_0
    | "t5" -> Tt_5
    | "two_t0" -> Two_t0
    | "twoDodecTrunc" -> Two_dodec_trunc
    | "twoDodecTruncSq" -> Two_dodec_trunc_sq
    | "xi_gamma" -> Xi_gamma
    | "xi'_gamma" -> Xi'_gamma
    | "xiV" -> Xiv
    | _ -> failwith ("not a constant: " ^ const)

  let const_of_string = const_of_string o unkepler 

  let const_to_string const = match const with
    | Dd_31 -> "D31"
    | Dd_32 -> "D32"
    | Dd_33 -> "D33"
    | Dd_41 -> "D41"
    | Dd_42 -> "D42"
    | Dd_51 -> "D51"
    | Dodec_slope -> "DodecSlope"
    | Dodec_trunc -> "DodecTrunc"
    | Zz_32 -> "Z32"
    | Zz_33 -> "Z33"
    | Zz_41 -> "Z41"
    | Zz_42 -> "Z42"
    | Doct -> "Doct"
    | Pi -> "Pi"
    | Ppa1 -> "Ppa1" 
    | Ppa2 -> "Ppa2" 
    | Ppd0 -> "Ppd0" 
    | Ppm -> "Ppm" 
    | Ppb -> "Ppb" 
    | Ppa -> "Ppa" 
    | Ppbc -> "Ppbc" 
    | Ppc -> "Ppc" 
    | Ppd -> "Ppd" 
    | Ppsolt0 -> "Ppsolt0" 
    | Pt -> "Pt"
    | Ss_5 -> "S5"
    | Sqrt2 -> "Sqrt2"
    | Sqrt8 -> "Sqrt8"
    | Sqrt_2t0 -> "Sqrt2t0"
    | Square_2t0 -> "Square2t0"
    | Square_4t0 -> "Square4t0"
    | Tt_0 -> "T0"
    | Tt_5 -> "T5"
    | Two_dodec_trunc -> "TwoDodecTrunc"
    | Two_dodec_trunc_sq -> "TwoDodecTruncSq"
    | Two_t0 -> "TwoT0"
    | Xi_gamma -> "XiGamma"
    | Xi'_gamma -> "Xi'Gamma"
    | XiV -> "XiV"

  let func_of_string func = match func with
    | "anc" -> Anc
    | "arclength" -> Arclength
    | "beta" -> Beta
    | "chi_x" -> Chi_x
    | "cross_diag_x" -> Cross_diag_x
    | "crown" -> Crown
    | "delta_x" -> Delta_x
    | "dih2_x" -> Dih2_x
    | "dih3_x" -> Dih3_x
    | "dihR" -> Dihr
    | "dih_x" -> Dih_x
    | "eta_x" -> Eta_x
    | "gamma_x" -> Gamma_x
    | "kappa" -> Kappa
    | "KX" -> Kx
    | "mu_flat_x" -> Mu_flat_x
    | "mu_flipped_x" -> Mu_flipped_x
    | "mu_upright_x" -> Mu_upright_x
    | "nu_gamma_x" -> Nu_gamma_x
    | "nu_x" -> Nu_x
    | "octa_x" -> Octa_x
    | "octavor0_x" -> Octavor0_x
    | "octavor_analytic_x" -> Octavor_analytic_x
    | "omega_x" -> Omega_x
    | "overlap_f" -> Overlap_f
    | "quo_x" -> Quo_x
    | "rad2_x" -> Rad2_x
    | "sigma1_qrtet_x" -> Sigma1_qrtet_x
    | "sigma32_qrtet_x" -> Sigma32_qrtet_x
    | "sigma_qrtet_x" -> Sigma_qrtet_x
    | "sigmahat_x" -> Sigmahat_x
    | "sol_x" -> Sol_x
    | "squander_x" -> Squander_x
    | "tauA_x" -> Taua_x
    | "tauC0_x" -> Tauc0_x
    | "tauVt_x" -> Tauvt_x
    | "tau_0_x" -> Tau_0_x
    | "tau_analytic_x" -> Tau_analytic_x
    | "tau_sigma_x" -> Tau_sigma_x
    | "tauhat_x" -> Tauhat_x
    | "tauhatpi_x" -> Tauhatpi_x
    | "taumu_flat_x" -> Taumu_flat_x
    | "taunu_x" -> Taunu_x
    | "truncated_volume_x" -> Truncated_volume_x
    | "u_x" -> U_x
    | "v0x" -> V0x
    | "v1x" -> V1x
    | "volume_x" -> Volume_x
    | "vorA_x" -> Vora_x
    | "vorC0_x" -> Vorc0_x
    | "vorC_x" -> Vorc_x
    | "vor_0_x" -> Vor_0_x
    | "vor_0_x_flipped" -> Vor_0_x_flipped
    | "vor_analytic_x" -> Vor_analytic_x
    | "vor_analytic_x_flipped" -> Vor_analytic_x_flipped
    | "vort_x" -> Vort_x
    | _ -> failwith ("no such const: " ^ func) 

  let func_of_string = func_of_string o unkepler

  let func_to_string func = match func with
    | Anc -> "Anc" 
    | Arclength -> "Arclength"
    | Beta -> "Beta"
    | Chi_x -> "ChiX"
    | Cross_diag_x -> "CrossDiagX"
    | Crown -> "Crown"
    | Delta_x -> "DeltaX"
    | Dih2_x -> "Dih2X"
    | Dih3_x -> "Dih3X"
    | Dihr -> "Dihr"
    | Dih_x -> "DihX"
    | Eta_x -> "EtaX"
    | Gamma_x -> "GammaX"
    | Kappa -> "Kappa"
    | Kx -> "Kx"
    | Mu_flat_x -> "MuFlatX"
    | Mu_flipped_x -> "MuFlippedX"
    | Mu_upright_x -> "MuUprightX"
    | Nu_gamma_x -> "NuGammaX"
    | Nu_x -> "NuX"
    | Octa_x -> "OctaX"
    | Octavor0_x -> "Octavor0X"
    | Octavor_analytic_x -> "OctavorAnalyticX"
    | Omega_x -> "OmegaX"
    | Overlap_f -> "OverlapF"
    | Quo_x -> "QuoX"
    | Rad2_x -> "Rad2X"
    | Sigma1_qrtet_x -> "Sigma1QrtetX"
    | Sigma32_qrtet_x -> "Sigma32QrtetX"
    | Sigma_qrtet_x -> "SigmaQrtetX"
    | Sigmahat_x -> "SigmahatX"
    | Sol_x -> "SolX"
    | Squander_x -> "SquanderX"
    | Taua_x -> "TauaX"
    | Tauc0_x -> "Tauc0X"
    | Tauvt_x -> "TauvtX"
    | Tau_0_x -> "Tau0X"
    | Tau_analytic_x -> "TauAnalyticX"
    | Tau_sigma_x -> "TauSigmaX"
    | Tauhat_x -> "TauhatX"
    | Tauhatpi_x -> "TauhatpiX"
    | Taumu_flat_x -> "TaumuFlatX"
    | Taunu_x -> "TaunuX"
    | Truncated_volume_x -> "TruncatedVolumeX"
    | U_x -> "UX"
    | V0x -> "V0x"
    | V1x -> "V1x"
    | Volume_x -> "VolumeX"
    | Vora_x -> "VoraX"
    | Vorc0_x -> "Vorc0X"
    | Vorc_x -> "VorcX"
    | Vor_0_x -> "Vor0X"
    | Vor_0_x_flipped -> "Vor0XFlipped"
    | Vor_analytic_x -> "VorAnalyticX"
    | Vor_analytic_x_flipped -> "VorAnalyticXFlipped"
    | Vort_x -> "VortX"

  let var_to_string v = fst (dest_var v)
  let dest_add t = try Some (dest_binop `(+.)` t) with _ -> None
  let dest_sub t = try Some (dest_binop `(-.)` t) with _ -> None
  let dest_mul t = try Some (dest_binop `( *. )` t) with _ -> None
  let dest_div t = try Some (dest_binop `( / )` t) with _ -> None

  (* -------------------------------------------------------------------------- *)
  (*  Translation                                                               *)
  (* -------------------------------------------------------------------------- *)

  (* `#1.35` *)
  let translate_decimal t : const option =
    try
      let dec,numden = strip_comb t in
      let num,den = match numden with [num;den] -> num,den | _ -> failwith "" in
      if dec = `DECIMAL` then
        match dest_numeral num,dest_numeral den with
            Num.Int num', Num.Int den' -> Some (Decimal (num',den'))
          | _ -> failwith ""
      else None
    with _ -> None

  (* `&5` *)  
  let translate_rint t : const option = 
    try
      let amp,n = dest_comb t in
        if amp = `&.` then 
          match dest_numeral n with
              Num.Int n' -> Some (Int n')
            | _ -> None 
        else None 
    with _ -> None 

  (*  `5` *)
  let translate_int t : int option = 
    try
      match dest_numeral t with
          Num.Int n' -> Some n'
        | _ -> None 
    with _ -> None 

  (* `square_2t0` *)
  let translate_named t : const option =
    try
      let c,_ = dest_const t in
        Some (Named (const_of_string c))
    with _ -> None

  let rec translate_const t : const option =  
    match translate_decimal t with
        Some _ as c -> c
      | None ->
    match translate_rint t with
        Some _ as c -> c
      | None ->
    match translate_named t with
        Some _ as c -> c
      | None ->
    match translate_cos t with
        Some _ as c -> c
      | None ->
    match translate_acos t with
        Some _ as c -> c
      | None ->
    match translate_sqr t with
        Some _ as c -> c
      | None ->
    match translate_sqrt t with
        Some _ as c -> c
      | None ->
    match translate_copp t with
        Some _ as c -> c
      | None ->
    match translate_cplus t with
        Some _ as c -> c
      | None ->
    match translate_cmul t with
        Some _ as c -> c
      | None ->
    match translate_cdiv t with
        Some _ as c -> c
      | None -> None 

  and translate_unop p con t : const option = 
    try
      let p',c = dest_comb t in
        if p = p' then
        match translate_const c with
            Some c -> Some (con c)
          | None -> None 
        else
          None
    with _ -> None 

  and translate_binop p con t : const option = 
    try
      let l,r = dest_binop p t in
      match translate_const l,translate_const r with
          Some l', Some r' -> Some (con(l',r'))
        | _ -> None 
    with _ -> None 

  and translate_cos t = translate_unop `cos` (fun x -> Cos x) t
  and translate_acos t = translate_unop `acs` (fun x -> Acos x) t
  and translate_sqr t = translate_unop `square` (fun x -> Sqr x) t
  and translate_sqrt t = translate_unop `sqrt` (fun x -> Sqrt x) t
  and translate_copp t = translate_unop `(--.)` (fun x -> Copp x) t
  and translate_cplus t = translate_binop `(+.)` (fun x,y -> Cplus (x,y)) t
  and translate_cmul t = translate_binop `( *. )` (fun x,y -> Cmul (x,y)) t
  and translate_cdiv t = translate_binop `( / )` (fun x,y -> Cdiv (x,y)) t

  let translate_var t = 
    if is_var t then Some (Var (fst (dest_var t))) else None 

  let translate_varsqrt t = 
    try
      let sqrt,x = dest_comb t in
      if sqrt = `sqrt` && is_var x then
        Some (Varsqrt (fst (dest_var x))) 
      else None 
    with _ -> None 

  let rec translate_expr t : expr option = 
    match translate_const t with
        Some c -> Some (Const c)
      | None ->
    match translate_funcall t with
        Some _ as c -> c
      | None ->
    match translate_varsqrt t with
        Some _ as c -> c
      | None ->
    match translate_var t with
        Some _ as c -> c
      | None ->
    match translate_opp t with
        Some _ as c -> c
      | None ->
    match translate_mul t with
        Some _ as c -> c
      | None ->
    match translate_div t with
        Some _ as c -> c
      | None ->
    match translate_pow t with
        Some _ as c -> c
      | None -> failwith "translate_expr"

  and translate_funcall t =
    try
      let f,xs = strip_comb t in
      let func_str,_ = dest_const f in
      let func = func_of_string func_str in
      let xs' = map (fun x -> match translate_expr x with Some e -> e | None -> failwith "") xs in
        Some (Funcall(func,xs'))
    with _ -> None 

  and translate_unop p con t : expr option = 
    try
      let p',c = dest_comb t in
        if p = p' then
        match translate_expr c with
            Some c -> Some (con c)
          | None -> None 
        else
          None
    with _ -> None 

  and translate_binop p con t : expr option = 
    try
      let l,r = dest_binop p t in
      match translate_expr l,translate_expr r with
          Some l', Some r' -> Some (con(l',r'))
        | _ -> None 
    with _ -> None 

  and translate_opp t = translate_unop `(--.)` (fun x -> Opp x) t
  and translate_mul t = translate_binop `( *. )` (fun x,y -> Mul (x,y)) t
  and translate_div t = translate_binop `( / )` (fun x,y -> Div (x,y)) t
  and translate_pow t = 
    try
      let f,[x;n] = strip_comb t in
      if not(f = `((pow):real->num->real)`) then None else
      let Some x' = translate_expr x in
      let Some n' = translate_int n in
        Some (Pow(x',n'))
    with _ -> None 

  let translate_monom t : monom option = 
    match translate_const t with
        Some x -> Some (x,One)
      | None -> 
    match dest_mul t with
        Some (c,e) -> 
          (match translate_const c, translate_expr e with
               Some c', Some e' -> Some (c',e')
             | _ -> match translate_expr t with
                   Some e -> Some (Int 1,e)
                 | None -> None)
      | None ->
          match translate_expr t with
              Some e -> Some (Int 1,e)
            | None -> None;;

  let rec translate_lcomb t = 
    match dest_add t with
        Some (l,r) ->
          (match translate_lcomb l ,translate_lcomb r with
              Some l', Some r' -> Some (l' @ r')
             | _ -> None)
      | None -> 
          match translate_monom t with
              Some m -> Some [m]
            | None -> None

  let translate_rel t =
    try
      let lcomb,zero = dest_binop `(<.)` t in
      let _ = if zero <> `(&0)` then failwith "not zero" else () in
        translate_lcomb lcomb 
    with _ -> failwith "translate_rel"

  let translate_ineq t =
    try
      let _,body = strip_forall t in
      let ineq_tm,bounds_rel = strip_comb body in
      let bounds,rel = match bounds_rel with [bounds;rel] -> bounds,rel | _ -> failwith "" in
      let ineqs = disjuncts rel in
      let map_fn q = match translate_rel q with Some l -> l | None -> failwith "" in
      let ineqs = map map_fn ineqs in
      let dest_trip xyz =
        let x,yz = dest_pair xyz in
        let x = match translate_const x with Some x -> x | None -> failwith "" in
        let y,z = dest_pair yz in
        let y,_ = dest_var y in
        let z = match translate_const z with Some x -> x | None -> failwith "" in     
          y,{lo = x; hi = z} in
      let bounds' = map dest_trip (dest_list bounds) in
        (bounds',ineqs)
    with _ -> failwith "translate_ineq"

  (* -------------------------------------------------------------------------- *)
  (*  Normalize                                                                 *)
  (* -------------------------------------------------------------------------- *)

  let normalize =
    let thms = [
                 REAL_ARITH `x *. (y + z) = x * y + x * z`;
                 REAL_ARITH `(x +. y) * z = z * x + z * y`;
                 REAL_ARITH `&0 *. x = &0`;
                 REAL_ARITH `x * -- y = -- x * y`;
                 REAL_ARITH `(x -. y) = x + (-- y)`;
                 REAL_ARITH `(x +. y) + z = x + y + z`;
                 REAL_ARITH `--. (x * y) = (--. x) * y`;
                 REAL_ARITH `-- #0.0 = &0`;
                 REAL_ARITH `-- &0 = &0`;
                 REAL_ARITH `x + &0 = x`;
                 REAL_ARITH `&0 + x = x`;
                 REAL_ARITH `--. (x + y) = (--. x) + (-- y)`;
                 REAL_ARITH `--. (-- x) = x`;
                 REAL_ARITH `!f:real->real->real->real->real->real->real. (-- (f x1 x2 x3 x4 x5 x6)) = (-- (&1) *. (f x1 x2 x3 x4 x5 x6))`;
                 MESON [] `(a \/ (b \/ c)) = (a \/ b \/ c)`;
                 pi_prime_tau;
                 pi_prime_sigma;
                 LET_DEF;
                 LET_END_DEF;
               ] in
    let once_thms = [
                      REAL_ARITH `!x y z:real. (x < y) = x - y < &0`;
                      REAL_ARITH `!x y z:real. (x > y) = y - x < &0`;
                    ] in
      fun x -> 
        snd (dest_eq (concl (
                              (DEPTH_CONV BETA_CONV THENC
                               ONCE_REWRITE_CONV once_thms THENC
                               REWRITE_CONV thms THENC
                               NUM_REDUCE_CONV) x)))

  let translate (name,q) =
    let _ = print_endline ("translating ineq: " ^ name) in
    let bounds,rels = translate_ineq (normalize q) in
      {name = name;
       vars = bounds;
       rels = rels}

  let translate_list ~ignore ~terms = 
    map translate (List.filter (fun x,_ -> not (mem x ignore)) terms)

  (* -------------------------------------------------------------------------- *)
  (*  Pretty Printing                                                           *)
  (* -------------------------------------------------------------------------- *)

  open Format

  let pp_int n = 
    begin 
      open_hbox ();
      print_string (string_of_int n);
      close_box ();
    end

  let pp_pair f (l,r) = 
    begin 
      open_hbox();
      print_string "(";f l;print_string ",";f r;print_string ")";
      close_box();
    end

  let separate = 
    let rec separate x l str = match l with 
      | [] ->  List.rev str
      | [h] ->  List.rev (h::str)
      | h::h'::t -> separate x (h'::t) (x::h::str) in
      fun x l -> separate x l []

  let rec iter_butlast f l = match l with
    | [] | [_] -> ()
    | h::t -> (f h;iter_butlast f t)

  let rec last l = match l with
    | [] -> failwith ""
    | [h] -> h
    | _::t -> last t

  let pp_list_horiz f l = if l = [] then print_string "[]" else
    begin 
      open_hbox();
      print_string "[";
      iter_butlast (fun x -> (f x; print_string ", ")) l;
      f (last l);
      print_string "]";
      close_box();
    end

  let pp_list_vert f l = if l = [] then print_string "[]" else
    begin 
      open_vbox 1;
      print_string "[";
      iter_butlast (fun x -> (f x; print_string ",";print_cut())) l;
      f (last l);
      print_string "]";
      close_box();
    end

  let pp_unop p s c = 
    begin
      open_hbox();
      print_string s;
      print_string "(";
      p c;
      print_string ")";    
      close_box();
    end

  let pp_binop p1 p2 s c1 c2 = 
    begin
      open_hbox();
      print_string s;
      print_string "(";
      p1 c1;
      print_string ",";
      p2 c2;
      print_string ")";    
      close_box();
    end

  let pp_decimal (x,y) = 
    begin 
      open_hbox();
      print_string "Decimal";
      pp_pair pp_int (x,y);
      close_box();
    end

  let pp_named n = print_string (const_to_string n)

  let rec pp_const c = match c with
    | Decimal (x,y) -> pp_decimal(x,y)
    | Int n -> (print_string "Int "; pp_int n)
    | Named n -> (print_string "Named ";pp_named n)
    | Cos c -> pp_cos c
    | Acos c -> pp_acos c
    | Sqr c -> pp_sqr c
    | Sqrt c -> pp_sqrt c
    | Copp c -> pp_copp c
    | Cplus (x,y) -> pp_cplus x y
    | Cmul (x,y) -> pp_cmul x y
    | Cdiv (x,y) -> pp_cdiv x y

  and pp_cos c = pp_unop pp_const "Cos" c
  and pp_acos c = pp_unop pp_const "Acos" c
  and pp_sqr c = pp_unop pp_const "Sqr" c
  and pp_sqrt c = pp_unop pp_const "Sqrt" c
  and pp_copp c = pp_unop pp_const "Copp" c
  and pp_cplus c1 c2 = pp_binop pp_const pp_const "Cplus" c1 c2
  and pp_cmul c1 c2 = pp_binop pp_const pp_const "Cmul" c1 c2
  and pp_cdiv c1 c2 = pp_binop pp_const pp_const "Cdiv" c1 c2

  let rec pp_expr e = match e with
    | Const c -> (print_string "Const (";pp_const c;print_string ")")
    | Funcall (f,xs) -> pp_funcall f xs
    | Var v -> pp_var v
    | Varsqrt v -> pp_varsqrt v
    | Opp e -> pp_opp e
    | Mul(x,y) -> pp_mul x y
    | Div(x,y) -> pp_div x y
    | Pow(x,n) -> pp_pow x n
    | One -> print_string "One"

  and pp_funcall f xs = 
    begin 
      open_hbox();
      print_string "Funcall(";
      print_string (func_to_string f);
      print_string ", ";
      pp_list_horiz pp_expr xs;
      print_string ")";    
      close_box();
    end

  and pp_var v = print_string ("Var \"" ^ v ^ "\"")
  and pp_varsqrt v = print_string ("Varsqrt \"" ^ v ^ "\"")
  and pp_opp e = pp_unop pp_expr "Opp" e 
  and pp_mul e1 e2 = pp_binop pp_expr pp_expr "Mul" e1 e2
  and pp_div e1 e2 = pp_binop pp_expr pp_expr "Div" e1 e2
  and pp_pow e1 e2 = pp_binop pp_expr pp_int "Pow" e1 e2

  let pp_monom (c,e) = 
    begin 
      open_hbox();
      print_string "(";
      pp_const c;
      print_string ",";
      pp_expr e;
      print_string ")";
      close_box();
    end

  let pp_lcomb l = pp_list_horiz pp_monom l

  let pp_bounds (v, {lo=lo;hi=hi}) =
    begin 
      open_vbox 1;
      print_string ("(\"" ^ v ^ "\",");
      print_cut();
       open_hbox();
       print_string "{lo = ";
       pp_const lo;
       close_box();
       print_string ",";
       print_cut();
       open_hbox();
       print_string " hi = ";
       pp_const hi;
       print_string "})";
       close_box();
      close_box(); 
    end

  let ineq_to_sml q = 
    begin
      open_vbox 1;
      print_string "{";
      print_string "name = \"";
      print_string q.name;
      print_string "\",";
      print_cut();
      print_cut();
      print_string "vars = ";
       pp_list_vert pp_bounds q.vars;
       print_string ",";
      print_cut();
      print_cut();
      print_string "rels = ";
       pp_list_vert pp_lcomb q.rels;
       print_string "}";
      close_box();
    end

  let ineqs_to_sml qs =
    let doit q = 
      begin
        ineq_to_sml q;
        print_string ",";
        print_cut();
        print_cut();
      end in
    begin
      open_vbox 4;
      print_cut();
      iter_butlast doit qs;
      ineq_to_sml (last qs);
      close_box();
    end

  let header univ = 
"
(*============================================================================*)
(* THIS FILE IS AUTOGENERATED.  DO NOT EDIT!!!                                *)
(*============================================================================*)

structure " ^ univ ^ "InequalitySyntaxBase:> INEQUALITY_SYNTAX_BASE =
struct 

open FunctionUtil
open InequalityUtil

val unexpandedIneqs = [
"

  let footer = 
"
]

end" 

  let ineqs_to_sml ~file ~ineqs ~univ = 
    let chan = open_out file in
      try
        set_formatter_out_channel chan;
        print_string (header univ);
        ineqs_to_sml ineqs;
        print_string footer;
        set_formatter_out_channel stdout;        
        close_out chan;
      with exn -> 
        set_formatter_out_channel stdout;
        close_out chan;        
        raise exn

end

(* 

needs "Examples/analysis.ml";;
needs "Examples/transc.ml";;
needs "Jordan/lib_ext.ml";;
needs "Jordan/parse_ext_override_interface.ml";;
unambiguous_interface();;

#use "../../kepler/sml/inequalities/holl/definitions_kepler.ml";;
#use "../../kepler/sml/inequalities/holl/kep_inequalities.ml";;
#use "../../kepler/sml/inequalities/holl/ineq_names.ml";;
#use "../../kepler/sml/inequalities/holl/ocaml_to_sml.ml";;
let ocaml_ineqs = Ocaml_sml.translate_list ~ignore:Ineq_names.ignore ~terms:Ineq_names.ineqs;;

Ocaml_sml.ineqs_to_sml 
   ~file:"/Users/seanmcl/save/versioned/projects/kepler/sml/inequalities/inequality-syntax.sml" 
   ~ineqs:ocaml_ineqs;;

let file = "/Users/seanmcl/save/versioned/projects/kepler/sml/inequalities/inequality-syntax.sml"

let q = List.nth ocaml_ineqs 0;;
(print_endline ""; Ocaml_sml.ineq_to_sml q; print_endline "";)

   let t = Ocaml_sml.normalize x;;
   Ocaml_sml.translate_ineq t


   #trace Ocaml_sml.;;
   #trace Ocaml_sml.normalize;;
   #trace Ocaml_sml.translate_const;;
   #trace Ocaml_sml.translate_cdiv;;
   #trace Ocaml_sml.translate_expr;;
   #trace Ocaml_sml.translate_funcall;;
   #trace Ocaml_sml.translate_div;;
   #trace Ocaml_sml.translate_monom;;
   #trace Ocaml_sml.translate_lcomb;;
   #trace Ocaml_sml.translate_rel;;
   #trace Ocaml_sml.translate_ineq;;
   #trace Ocaml_sml.translate_pow;;
   #trace Ocaml_sml.translate;;

   #untrace_all;;

   let x = I_327474205_1
   Ocaml_sml.translate_ineq (Ocaml_sml.normalize x)
   Ocaml_sml.normalize I_327474205_1

   translate_ineq I_867513567_13
   let t = `tau_sigma_x x1 x2 x3 x4 x5 x6 -. #0.2529 *. dih_x x1 x2 x3 x4 x5 x6 >.
   --. #0.3442`


 *) 
