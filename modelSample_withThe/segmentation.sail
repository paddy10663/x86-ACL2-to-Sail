$include <prelude.sail>
$include <string.sail>
$include "segmentation_structures.sail"
$include "linear_memory.sail"
/*Return a segment ' s base linear address, lower bound, and upper bound.*/
/*<p> 
 The segment is the one in the given segment register. 
 </p> 
 <p> 
 Base addresses coming from segment descriptors are always 32 bits: 
 see Intel manual, Mar ' 17, Vol. 3A, Sec. 3.4.5 
 and AMD manual, Apr ' 16, Vol. 2, Sec. 4.7 and 4.8. 
 However, in 64-bit mode, segment bases for FS and GS are 64 bits: 
 see Intel manual, Mar ' 17, Vol. 3A, Sec. 3.4.4 
 and AMD manual, Apr ' 16, Vol. 2, Sec 4.5.3. 
 As an optimization, in 64-bit mode, 
 since segment bases for CS, DS, SS, and ES are ignored, 
 this function just returns 0 as the base result under these conditions. 
 In 64-bit mode, when the segment register is FS or GS, 
 we read the base address from the MSRs 
 mentioned in Intel manual, Mar ' 17, Vol. 3A, Sec. 3.4.4 
 and AMD manual, Apr ' 16, Vol. 2, Sec 4.5.3; 
 these are physically mapped to the relevant hidden portions of FS and GS, 
 so it should be a state invariant that they are equal to 
 the relevant hidden portions of FS and GS. 
 In 32-bit mode, since the high 32 bits are ignored 
 ( see Intel manual, Mar ' 17, Vol. 3A, Sec. 3.4.4 
 and AMD manual, Apr ' 16, Vol. 2, Sec 4.5.3 ) , 
 we only return the low 32 bits of the base address 
 read from the hidden portion of the segment register. 
 </p> 
 <p> 
 @ ( ' *hidden-segment-register-layout* ' ) uses 32 bits 
 for the segment limit, 
 which is consistent with the 20 bits in segment descriptors 
 when the G ( granularity ) bit is 1: 
 see Intel manual, Mar ' 17, Vol. 3A, Sec. 3.4.5 
 and AMD manual, Apr ' 16, Vol. 2, Sec. 4-7 and 4-8. 
 Thus, the limit is an unsigned 32-bit integer. 
 </p> 
 <p> 
 The lower bound is 0 for code segments, i.e. for the CS register. 
 For data ( including stack ) segments, 
 i.e. for the SS, DS, ES, FS, and GS registers, 
 the lower bound depends on the E bit: 
 if E is 0, the lower bound is 0; 
 if E is 1, the segment is an expand-down data segment 
 and the lower bound is one plus the segment limit. 
 See Intel manual, Mar ' 17, Vol. 3A, Sec. 3.4.5 
 and AMD manual, Apr ' 16, Vol. 2, Sec. 4.7 and 4-8. 
 Since the limit is an unsigned 32-bit ( see above ) , 
 adding 1 may produce an unsigned 33-bit result. 
 Even though this should not actually happen with well-formed segments, 
 this function returns an unsigned 33-bit integer as the lower bound result. 
 As an optimization, in 64-bit mode, 
 since segment limits and bounds are ignored, 
 this function returns 0 as the lower bound; 
 the caller must ignore this result in 64-bit mode. 
 </p> 
 <p> 
 The upper bound is the segment limit for code segments, 
 i.e. for the CS register. 
 For data ( including stack ) segments, 
 i.e. for the SS, DS, ES, FS, and GS registers, 
 the upper bound depends on the E and D/B bits: 
 if E is 0, the upper bound is the segment limit; 
 if E is 1, the segment is an expand-down data segment 
 and the upper bound is 2^32-1 if D/B is 1, 2^16-1 if D/B is 0. 
 See Intel manual, Mar ' 17, Vol. 3A, Sec. 3.4.5 
 and AMD manual, Apr ' 16, Vol. 2, Sec. 4.7 and 4-8. 
 Since the limit is an unsigned 32-bit ( see above ) , 
 this function returns an unsigned 32-bit integer as the upper bound result. 
 As an optimization, in 64-bit mode, 
 since segment limits and bounds are ignored, 
 this function returns 0 as the upper bound; 
 the caller must ignore this result in 64-bit mode. 
 </p>*/
val segment_base_and_bounds : (int, int, int) -> (int, int, int) effect {escape, rreg}
function segment_base_and_bounds (proc_mode, seg_reg, x86) =
(match proc_mode {
0 => if (seg_reg) == (4)
then (msri(1, 0), 0 : int, 0 : int)
else if (seg_reg) == (5)
then (msri(2, 0), 0 : int, 0 : int)
else (0 : int, 0 : int, 0 : int),
1 => let base = (loghead(64, seg_hidden_basei(seg_reg, 0))) : int in
let limit = (loghead(32, seg_hidden_limiti(seg_reg, 0))) : int in
let attr = (loghead(16, seg_hidden_attri(seg_reg, 0))) : int in
let d_b = (if (seg_reg) == (1)
then code_segment_descriptor_attributesbits_get_d(attr)
else data_segment_descriptor_attributesbits_get_d_b(attr)) : int in
let e = (if (seg_reg) == (1)
then 0
else data_segment_descriptor_attributesbits_get_e(attr)) : int in
let lower = (if (e) == (1)
then (1) + (limit)
else 0) : int in
let upper = (if (e) == (1)
then if (d_b) == (1)
then 4294967295
else 65535
else limit) : int in
(n32(base), lower, upper),
_ => (0 : int, 0 : int, 0 : int)
}) : (int, int, int)

/*Translate an effective address to a <i>canonical</i> linear address.*/
/*<p> 
 This translation is illustrated in Intel manual, Mar ' 17, Vol. 3A, Fig. 3-5, 
 as well in AMD mamual, Oct ' 2013, Vol. 1, Fig. 2-3 and 2-4. 
 In addition to the effective address, 
 this function takes as input ( the index of ) a segment register, 
 whose corresponding segment selector, with the effective address, 
 forms the logical address that is turned into the linear address. 
 </p> 
 <p> 
 This translation is used: 
 when fetching instructions, 
 in which case the effective address is in RIP, EIP, or IP; 
 when accessing the stack implicitly, 
 in which case the effective address is in RSP, ESP, or SP; 
 and when accessing data explicitly, 
 in which case the effective address is calculated by instructions 
 via @ ( tsee x86-effective-addr ) . 
 In the formal model, 
 RIP contains a signed 48-bit integer, 
 RSP contains a signed 64-bit integer, 
 and @ ( tsee x86-effective-addr ) returns a signed 64-bit integer: 
 thus, the guard of this function requires @ ( ' eff-addr ' ) 
 to be a signed 64-bit integer. 
 In 64-bit mode, the caller of this function supplies as @ ( ' eff-addr ' ) 
 the content of RIP, 
 the content of RSP, 
 or the result of @ ( tsee x86-effective-addr ) . 
 In 32-bit mode, the caller of this function supplies as @ ( ' eff-addr ' ) 
 the unsigned 32-bit or 16-bit truncation of 
 the content of RIP ( i.e. EIP or IP ) , 
 the content of RSP ( i.e. ESP or SP ) , 
 or the result of @ ( tsee x86-effective-addr ) ; 
 the choice between 32-bit and 16-bit is determined by 
 default address size and override prefixes. 
 </p> 
 <p> 
 This function also takes as input the number of bytes 
 that have to be read or written starting from the effective address; 
 that is, the chunk of bytes to be accessed 
 goes from @ ( ' eff-addr ' ) to @ ( ' eff-addr + nbytes - 1 ' ) , both inclusive. 
 In 32-bit mode, the @ ( ' eff-addr ' ) ( the start of the chunk ) 
 is checked against the lower bound of the segment, 
 and @ ( ' eff-addr + nbytes - 1 ' ) ( the end of the chunk ) 
 is checked against the upper bound of the segment. 
 In 64-bit mode, these checks are skipped. 
 It is not clear from the Intel and AMD manuals 
 whether the calculation @ ( ' eff-addr + nbytes - 1 ' ) should be modular. 
 If it were, the wrap-around would give rise to 
 two separate chunks of bytes to be checked for containment in the segment. 
 According to the article at 
 <a href='https://www.embedded.com/electronics-blogs/significant-bits/4024943/Taming-the-x86-beast'>@ ( ' https://www.embedded.com/electronics-blogs/significant-bits/4024943/Taming-the-x86-beast ' ) </a>, 
 the calculation does not wrap around. 
 This is a paragraph from the article: 
 <blockquote> 
 <i> 
 You also can ' t ` ` wrap around ' ' the end of segment like before. 
 Earlier x86 chips with their 64KB segments allowed pointers 
 to roll over from FFFF to 0000 automatically. 
 Programs that accidentally ( or purposely ) ran off the end of a segment 
 started over at the beginning. 
 Programs that run off the end of a segment 
 now are greeted with a segmentation fault. 
 </i> 
 </blockquote> 
 So for now we make the stricter check 
 by calculating @ ( ' eff-addr + nbytes - 1 ' ) non-modularly 
 and therefore always having one chunk to check. 
 Note that operations like @ ( tsee rme-size ) always access one contiguous chunk 
 because they forward the translated addresses 
 to operations like @ ( tsee rml-size ) ; 
 so if it turned out that @ ( ' eff-addr + nbytes - 1 ' ) can wrap around 
 ( contrary to what the aforementioned article states ) , 
 changes may need to be made 
 in @ ( tsee rme-size ) and similar operations as well. 
 </p> 
 <p> 
 In 32-bit mode, 
 the effective address is added to the base address of the segment; 
 the result is truncated to 32 bits, 
 because the addition should be modulo 2^32, 
 given that the result must be 32 bits 
 ( cf. aforementioned figures in Intel and AMD manuals ) . 
 In 64-bit mode, 
 the addition of the base address of the segment is performed 
 only if the segments are in registers FS and GS; 
 the result is truncated to 64 bits, 
 because the addition should be modulo 2^64, 
 given that the result must be 32 bits 
 ( cf. aforementioned figures in Intel and AMD manuals ) ; 
 since in our model addresses are signed, 
 we use @ ( ' i64 ' ) instead of @ ( ' n64 ' ) to perform this truncation. 
 </p> 
 <p> 
 If the translation is successful, 
 this function returns a signed 64-bit integer 
 that represents a <i>canonical</i> linear address. 
 In 64-bit mode, when the segment register is not FS or GS, the effective 
 address is returned unmodified as a linear address, because segment 
 translation should be a no-op in this case; otherwise, the effective address 
 is translated to a linear address. In both cases, this linear address is 
 checked to be canonical; if not, an error flag is returned, otherwise, a 
 canonical linear address is returned. 
 In 32-bit mode, the 32-bit linear address that results from the translation 
 is always canonical. 
 If the translation fails, 
 including the check that the linear address is canonical, 
 a non-@ ( ' nil ' ) error flag is returned, 
 which provides some information about the failure. 
 </p> 
 <p> 
 As explained in Intel manual, May ' 18, Volume 3, Sections 3.4.2 and 5.4.1, 
 a null segment selector can be loaded into DS, ES, FS, and GS, 
 but then a memory access through these segment registers causes a #GP. 
 According to AMD manual, Dec ' 17, Volume 2, Section 4.5.1, 
 a null segment selector has SI = TI = 0, 
 but no explicit constraint is stated on RPL; 
 Intel manual, May ' 18, Volume 2, POP specification says that 
 a null segment selector has a value from 0 to 3, 
 from which we infer that a null segment selector may have a non-zero RPL. 
 In this function, 
 we return an error if the visible portion of the segment register is 0-3, 
 and the segment register is not CS or SS. 
 Loading a null segment selector into CS and SS is not allowed, 
 so it is a state invariant that 
 CS and SS do not contain null segment selectors. 
 The null segment selector check is skipped in 64-bit mode 
 ( see Intel manual, May ' 18, Volume 3, Section 5.4.1.1 ) . 
 </p>*/
val ea_to_la : (int, int, int, int, int) -> (option(string), int) effect {escape, rreg}
function ea_to_la (proc_mode, eff_addr, seg_reg, nbytes, x86) =
(match proc_mode {
0 => let lin_addr = (if ((seg_reg) == (4)) | ((seg_reg) == (5))
then let (base, _, _) = (segment_base_and_bounds(0, seg_reg, 0)) : (int, int, int) in
let lin_addr = (I64((base) + (n64(eff_addr)))) : int in
lin_addr
else eff_addr) : int in
if not_bool(canonical_address_p(lin_addr))
then (Some(":NON-CANONICAL-ADDRESS"), 0 : int)
else (None() : option(string), lin_addr),
1 => if (not_bool((seg_reg) == (1))) & ((not_bool((seg_reg) == (2))) & ((seg_visiblei(seg_reg, 0)) < (4)))
then (Some(":NULL-SEGMENT-SELECTOR"), 0 : int)
else let (base, lower_bound, upper_bound) = (segment_base_and_bounds(proc_mode, seg_reg, 0)) : (int, int, int) in
let base = (the_range(0, 4294967295, base)) : int in
let lower_bound = (the_range(0, 8589934591, lower_bound)) : int in
let upper_bound = (the_range(0, 4294967295, upper_bound)) : int in
let first_addr = (eff_addr) : int in
let last_addr = ((eff_addr) + ((nbytes) + (-1))) : int in
if not_bool(((lower_bound) <= (first_addr)) & ((last_addr) <= (upper_bound)))
then (Some(":SEGMENT-LIMIT-FAIL"), 0 : int)
else let lin_addr = (the_range(0, 4294967295, n32((the_range(0, 4294967295, base)) + (the_range(0, 4294967295, eff_addr))))) : int in
(None() : option(string), lin_addr),
_ => (Some(":UNIMPLEMENTED-PROC-MODE"), 0 : int)
}) : (option(string), int)

/*Recognizer for a valid code segment descriptor in 64-bit mode*/
val ia32e_valid_code_segment_descriptor_p : (int) -> (bool, (string, (int)))
function ia32e_valid_code_segment_descriptor_p (descriptor) =
if not_bool((code_segment_descriptorbits_get_msb_of_type(descriptor)) == (1))
then (false, (":INVALID-SEGMENT-TYPE", (descriptor)))
else if not_bool((code_segment_descriptorbits_get_s(descriptor)) == (1))
then (false, (":INVALID-SEGMENT-TYPE", (descriptor)))
else if not_bool((code_segment_descriptorbits_get_p(descriptor)) == (1))
then (false, (":SEGMENT-NOT-PRESENT", (descriptor)))
else if not_bool((code_segment_descriptorbits_get_l(descriptor)) == (1))
then (false, (":IA32E-MODE-OFF", (descriptor)))
else if not_bool((code_segment_descriptorbits_get_d(descriptor)) == (0))
then (false, (":IA32E-DEFAULT-OPERAND-SIZE-INCORRECT", (descriptor)))
else (true, ("", (0 : int)))

/*Recognizer for a valid LDT segment descriptor*/
val ia32e_valid_ldt_segment_descriptor_p : (int) -> (bool, (string, (int)))
function ia32e_valid_ldt_segment_descriptor_p (descriptor) =
let sailtype = (system_segment_descriptorbits_get_type(descriptor)) : int in
if not_bool((sailtype) == (2))
then (false, (":INVALID-TYPE", (descriptor)))
else if not_bool((system_segment_descriptorbits_get_s(descriptor)) == (0))
then (false, (":INVALID-SEGMENT-TYPE", (descriptor)))
else if not_bool((system_segment_descriptorbits_get_p(descriptor)) == (1))
then (false, (":SEGMENT-NOT-PRESENT", (descriptor)))
else if not_bool((system_segment_descriptorbits_get_all_zeroes?(descriptor)) == (0))
then (false, (":ALL-ZEROES-ABSENT", (descriptor)))
else (true, ("", (0 : int)))

/*Recognizer for a valid Call Gate segment descriptor*/
val ia32e_valid_call_gate_segment_descriptor_p : (int) -> (bool, (string, (int)))
function ia32e_valid_call_gate_segment_descriptor_p (descriptor) =
let sailtype = (call_gate_descriptorbits_get_type(descriptor)) : int in
if not_bool((sailtype) == (12))
then (false, (":INVALID-TYPE", (descriptor)))
else if not_bool((call_gate_descriptorbits_get_s(descriptor)) == (0))
then (false, (":INVALID-SEGMENT-TYPE", (descriptor)))
else if not_bool((call_gate_descriptorbits_get_p(descriptor)) == (1))
then (false, (":SEGMENT-NOT-PRESENT", (descriptor)))
else if not_bool((call_gate_descriptorbits_get_all_zeroes?(descriptor)) == (0))
then (false, (":ALL-ZEROES-ABSENT", (descriptor)))
else (true, ("", (0 : int)))

/*Constructor for the Code Segment attribute field*/
val make_code_segment_attr_field : (int) -> int
function make_code_segment_attr_field (descriptor) =
let a = (code_segment_descriptorbits_get_a(descriptor)) : int in
let r = (code_segment_descriptorbits_get_r(descriptor)) : int in
let c = (code_segment_descriptorbits_get_c(descriptor)) : int in
let msb_of_type = (code_segment_descriptorbits_get_msb_of_type(descriptor)) : int in
let s = (code_segment_descriptorbits_get_s(descriptor)) : int in
let dpl = (code_segment_descriptorbits_get_dpl(descriptor)) : int in
let p = (code_segment_descriptorbits_get_p(descriptor)) : int in
let avl = (code_segment_descriptorbits_get_avl(descriptor)) : int in
let l = (code_segment_descriptorbits_get_l(descriptor)) : int in
let g = (code_segment_descriptorbits_get_g(descriptor)) : int in
change_code_segment_descriptor_attributesbits(0, Some(a), Some(r), Some(c), Some(msb_of_type), Some(s), Some(dpl), Some(p), Some(avl), Some(l), None(), Some(g), None())

/*Constructor for the System Segment attribute field*/
val make_system_segment_attr_field : (int) -> int
function make_system_segment_attr_field (descriptor) =
let sailtype = (system_segment_descriptorbits_get_type(descriptor)) : int in
let s = (system_segment_descriptorbits_get_s(descriptor)) : int in
let dpl = (system_segment_descriptorbits_get_dpl(descriptor)) : int in
let p = (system_segment_descriptorbits_get_p(descriptor)) : int in
let avl = (system_segment_descriptorbits_get_avl(descriptor)) : int in
let g = (system_segment_descriptorbits_get_g(descriptor)) : int in
change_system_segment_descriptor_attributesbits(0, Some(sailtype), Some(s), Some(dpl), Some(p), Some(avl), Some(g), None())

