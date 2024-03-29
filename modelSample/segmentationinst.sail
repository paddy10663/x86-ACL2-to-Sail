$include <prelude.sail>
$include <string.sail>

/*<h3>Op/En = M: [OP m16@ ( ' & ' ) m32]</h3> 
 <h3>Op/En = M: [OP m16@ ( ' & ' ) m64]</h3> 
 
 <p>In 64-bit mode, the instruction ' s operand size is fixed at 8+2 
 bytes ( an 8-byte base and a 2-byte limit ) .</p> 
 
 <p>[OP M]<br/> 
 0F 01/2: LGDT m16@ ( ' & ' ) 32<br/> 
 0F 01/2: LGDT m16@ ( ' & ' ) 64</p> 
 
 <p><b>TO-DO:</b> If a memory address referencing the SS segment is in 
 a non-canonical form, raise the SS exception.</p>*/
val x86_lgdt : (int, int, int, int, int, int, int, int, int) -> int effect {escape, rmem, rreg, wreg}
function x86_lgdt (proc_mode, start_rip, temp_rip, prefixes, rex_byte, opcode, modr_m, sib, x86) =
let ctx = ("X86-LGDT") : string in
let r_m = (modr_m_get_r_m(modr_m)) : int in
let mod_var = (modr_m_get_mod(modr_m)) : int in
let reg = (modr_m_get_reg(modr_m)) : int in
if app_view(0)
then throw(Emsg("Model state error: :LGDT-UNIMPLEMENTED-IN-APP-VIEW"))
else let p2 = (prefixes_get_seg(prefixes)) : int in
let p4? = ((103) == (prefixes_get_adr(prefixes))) : bool in
let seg_reg = (select_segment_register(proc_mode, p2, p4?, mod_var, r_m, sib, 0)) : int in
let base_size = (if n64_bit_modep(0)
then 8
else 4) : int in
let base_size_plus_2 = ((2) + (base_size)) : int in
let inst_ac? = (false) : bool in
let (flg0, mem, increment_rip_by, addr, x86) = (x86_operand_from_modr_m_and_sib_bytes(proc_mode, 0, base_size_plus_2, inst_ac?, true, seg_reg, p4?, temp_rip, rex_byte, r_m, mod_var, sib, 0, 0)) : (option(string), int, int, int, int) in
if is_some(flg0)
then throw(Emsg("Model state error: :X86-OPERAND-FROM-MODR/M-AND-SIB-BYTES"))
else let (flg, temp_rip) = (add_to_iptr(proc_mode, temp_rip, increment_rip_by, 0)) : (option(string), int) in
if is_some(flg)
then throw(Emsg("Model state error: :RIP-INCREMENT-ERROR"))
else let badlength? = (check_instruction_length(start_rip, temp_rip, 0)) : option(int) in
if is_some(badlength?)
then throw(Emsg("A fault occurred.  Original ACL2 AST:
['!!FAULT-FRESH', ':GP', '0', ':INSTRUCTION-LENGTH', 'BADLENGTH?']"))
else let p3? = ((102) == (prefixes_get_opr(prefixes))) : bool in
let operand_size = (if (base_size) == (8)
then 8
else let cs_attr = (seg_hidden_attri(1, 0)) : int in
let cs_d = (code_segment_descriptor_attributesbits_get_d(cs_attr)) : int in
if (cs_d) == (1)
then if p3?
then 2
else 4
else if p3?
then 4
else 2) : int in
let base_bits = ((match operand_size {
8 => 64,
4 => 32,
_ => 24
}) : int) : int in
let gdtr_limit = (set_gdtr_idtrbits_get_limit(unsigned(get_slice_int(16, mem, 0)), 0)) : int in
let gdtr = (set_gdtr_idtrbits_get_base_addr(unsigned(get_slice_int(base_bits, mem, 16)), gdtr_limit)) : int in
let x86 = (write_stri(0, gdtr, 0)) : int in
let x86 = (write_iptr(proc_mode, temp_rip, 0)) : int in
0

/*<h3>Op/En = M: [OP m16@ ( ' & ' ) m32]</h3> 
 <h3>Op/En = M: [OP m16@ ( ' & ' ) m64]</h3> 
 
 <p>In 64-bit mode, the instruction ' s operand size is fixed at 8+2 
 bytes ( an 8-byte base and a 2-byte limit ) .</p> 
 
 <p>[OP M]<br/> 
 0F 01/3: LIDT m16@ ( ' & ' ) 32<br/> 
 0F 01/3: LIDT m16@ ( ' & ' ) 64</p> 
 
 <p><b>TO-DO:</b> If a memory address referencing the SS segment is in 
 a non-canonical form, raise the SS exception.</p>*/
val x86_lidt : (int, int, int, int, int, int, int, int, int) -> int effect {escape, rmem, rreg, wreg}
function x86_lidt (proc_mode, start_rip, temp_rip, prefixes, rex_byte, opcode, modr_m, sib, x86) =
let ctx = ("X86-LIDT") : string in
let r_m = (modr_m_get_r_m(modr_m)) : int in
let mod_var = (modr_m_get_mod(modr_m)) : int in
let reg = (modr_m_get_reg(modr_m)) : int in
if app_view(0)
then throw(Emsg("Model state error: :LIDT-UNIMPLEMENTED"))
else let p2 = (prefixes_get_seg(prefixes)) : int in
let p4? = ((103) == (prefixes_get_adr(prefixes))) : bool in
let seg_reg = (select_segment_register(proc_mode, p2, p4?, mod_var, r_m, sib, 0)) : int in
let base_size = (if n64_bit_modep(0)
then 8
else 4) : int in
let base_size_plus_2 = ((2) + (base_size)) : int in
let inst_ac? = (false) : bool in
let (flg0, mem, increment_rip_by, addr, x86) = (x86_operand_from_modr_m_and_sib_bytes(proc_mode, 0, base_size_plus_2, inst_ac?, true, seg_reg, p4?, temp_rip, rex_byte, r_m, mod_var, sib, 0, 0)) : (option(string), int, int, int, int) in
if is_some(flg0)
then throw(Emsg("Model state error: :X86-OPERAND-FROM-MODR/M-AND-SIB-BYTES"))
else let (flg, temp_rip) = (add_to_iptr(proc_mode, temp_rip, increment_rip_by, 0)) : (option(string), int) in
if is_some(flg)
then throw(Emsg("Model state error: :RIP-INCREMENT-ERROR"))
else let badlength? = (check_instruction_length(start_rip, temp_rip, 0)) : option(int) in
if is_some(badlength?)
then throw(Emsg("A fault occurred.  Original ACL2 AST:
['!!FAULT-FRESH', ':GP', '0', ':INSTRUCTION-LENGTH', 'BADLENGTH?']"))
else let p3? = ((102) == (prefixes_get_opr(prefixes))) : bool in
let operand_size = (if (base_size) == (8)
then 8
else let cs_attr = (seg_hidden_attri(1, 0)) : int in
let cs_d = (code_segment_descriptor_attributesbits_get_d(cs_attr)) : int in
if (cs_d) == (1)
then if p3?
then 2
else 4
else if p3?
then 4
else 2) : int in
let base_bits = ((match operand_size {
8 => 64,
4 => 32,
_ => 24
}) : int) : int in
let idtr_limit = (set_gdtr_idtrbits_get_limit(unsigned(get_slice_int(16, mem, 0)), 0)) : int in
let idtr = (set_gdtr_idtrbits_get_base_addr(unsigned(get_slice_int(base_bits, mem, 16)), idtr_limit)) : int in
let x86 = (write_stri(1, idtr, 0)) : int in
let x86 = (write_iptr(proc_mode, temp_rip, 0)) : int in
0

/*<h3>Op/En = M: [OP r/m16]</h3> 
 [OP M]<br/> 
 0F 00/2: LLDT r/m16<br/> 
 
 <p>If bits 2-15 of the source operand are 0, LDTR is marked invalid 
 and the LLDT instruction completes silently. However, all subsequent 
 references to descriptors in the LDT ( except by the LAR, VERR, VERW or 
 LSL instructions ) cause a general protection exception.</p> 
 
 <p>The operand-size attribute has no effect on this instruction. In 
 64-bit mode, the operand size is fixed at 16 bits.</p> 
 
 <p><b>TO-DO:</b> If a memory address referencing the SS segment is in 
 a non-canonical form, raise the SS exception.</p>*/
val x86_lldt : (int, int, int, int, int, int, int, int, int) -> int effect {escape, rmem, rreg, wreg}
function x86_lldt (proc_mode, start_rip, temp_rip, prefixes, rex_byte, opcode, modr_m, sib, x86) =
let ctx = ("X86-LLDT") : string in
let r_m = (modr_m_get_r_m(modr_m)) : int in
let mod_var = (modr_m_get_mod(modr_m)) : int in
let reg = (modr_m_get_reg(modr_m)) : int in
if app_view(0)
then throw(Emsg("Model state error: :LLDT-UNIMPLEMENTED"))
else let p2 = (prefixes_get_seg(prefixes)) : int in
let p4? = ((103) == (prefixes_get_adr(prefixes))) : bool in
let seg_reg = (select_segment_register(proc_mode, p2, p4?, mod_var, r_m, sib, 0)) : int in
let inst_ac? = (false) : bool in
let (flg0, selector, increment_rip_by, addr, x86) = (x86_operand_from_modr_m_and_sib_bytes(proc_mode, 0, 2, inst_ac?, false, seg_reg, p4?, temp_rip, rex_byte, r_m, mod_var, sib, 0, 0)) : (option(string), int, int, int, int) in
if is_some(flg0)
then throw(Emsg("Model state error: :X86-OPERAND-FROM-MODR/M-AND-SIB-BYTES"))
else let (flg, temp_rip) = (add_to_iptr(proc_mode, temp_rip, increment_rip_by, 0)) : (option(string), int) in
if is_some(flg)
then throw(Emsg("Model state error: :RIP-INCREMENT-ERROR"))
else let badlength? = (check_instruction_length(start_rip, temp_rip, 0)) : option(int) in
if is_some(badlength?)
then throw(Emsg("A fault occurred.  Original ACL2 AST:
['!!FAULT-FRESH', ':GP', '0', ':INSTRUCTION-LENGTH', 'BADLENGTH?']"))
else let sel_index = (segment_selectorbits_get_index(selector)) : int in
let sel_ti = (segment_selectorbits_get_ti(selector)) : int in
let sel_rpl = (segment_selectorbits_get_rpl(selector)) : int in
if (sel_ti) == (1)
then throw(Emsg("Model state error: :GP-SELECTOR-DOES-NOT-POINT-TO-GDT"))
else let gdtr = (stri(0, 0)) : int in
let gdtr_base = (if (proc_mode) == (0)
then gdtr_idtrbits_get_base_addr(gdtr)
else n32(gdtr_idtrbits_get_base_addr(gdtr))) : int in
let gdtr_limit = (gdtr_idtrbits_get_limit(gdtr)) : int in
let largest_address = ((ash(sel_index, 3)) + (if (proc_mode) == (0)
then 15
else 7)) : int in
if (gdtr_limit) < (largest_address)
then throw(Emsg("Model state error: :GP-SELECTOR-LIMIT-CHECK-FAILED"))
else if (sel_index) == (0)
then let x86 = (write_ssr_visiblei(0, selector, 0)) : int in
0
else let descriptor_addr = ((gdtr_base) + (ash(sel_index, 3))) : int in
if not_bool(canonical_address_p(descriptor_addr))
then throw(Emsg("Model state error: :DESCRIPTOR-ADDR-VIRTUAL-MEMORY-ERROR"))
else let descriptor_size = (if (proc_mode) == (0)
then 16
else 8) : int in
let (flg, descriptor, x86) = (rml_size(descriptor_size, descriptor_addr, ":X", 0)) : (option(string), int, int) in
if is_some(flg)
then throw(Emsg("Model state error: :RML-SIZE-ERROR"))
else let (descriptor_valid?, reason) = (ia32e_valid_ldt_segment_descriptor_p(descriptor)) : (bool, (string, (int))) in
if not_bool(descriptor_valid?)
then throw(Emsg("Model state error: :INVALID-SEGMENT-DESCRIPTOR"))
else let ldtr_base15_0 = (system_segment_descriptorbits_get_base15_0(descriptor)) : int in
let ldtr_base23_16 = (system_segment_descriptorbits_get_base23_16(descriptor)) : int in
let ldtr_base31_24 = (system_segment_descriptorbits_get_base31_24(descriptor)) : int in
let ldtr_base63_32 = (system_segment_descriptorbits_get_base63_32(descriptor)) : int in
let ldtr_base63_24 = (changeBits(ash(ldtr_base63_32, 8), 0, 8, ldtr_base31_24)) : int in
let ldtr_base23_0 = (changeBits(ash(ldtr_base23_16, 16), 0, 16, ldtr_base15_0)) : int in
let ldtr_base = (changeBits(ash(ldtr_base63_24, 24), 0, 24, ldtr_base23_0)) : int in
let ldtr_limit15_0 = (system_segment_descriptorbits_get_limit15_0(descriptor)) : int in
let ldtr_limit19_16 = (system_segment_descriptorbits_get_limit19_16(descriptor)) : int in
let ldtr_limit = (changeBits(ash(ldtr_limit19_16, 16), 0, 16, ldtr_limit15_0)) : int in
let ldtr_attr = (make_system_segment_attr_field(descriptor)) : int in
let x86 = (write_ssr_visiblei(0, selector, 0)) : int in
let x86 = (write_ssr_hidden_basei(0, ldtr_base, 0)) : int in
let x86 = (write_ssr_hidden_limiti(0, ldtr_limit, 0)) : int in
let x86 = (write_ssr_hidden_attri(0, ldtr_attr, 0)) : int in
let x86 = (write_iptr(proc_mode, temp_rip, 0)) : int in
0

