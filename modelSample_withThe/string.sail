$include <prelude.sail>
$include <string.sail>


val x86_movs : (int, int, int, int, int, int, int, int, int) -> int effect {eamem, escape, rmem, rreg, wmv, wreg}
function x86_movs (proc_mode, start_rip, temp_rip, prefixes, rex_byte, opcode, modr_m, sib, x86) =
let ctx = ("X86-MOVS") : string in
let r_m = (the_range(0, 7, modr_m_get_r_m(modr_m))) : int in
let mod_var = (the_range(0, 3, modr_m_get_mod(modr_m))) : int in
let reg = (the_range(0, 7, modr_m_get_reg(modr_m))) : int in
let group_1_prefix = (the_range(0, 255, prefixes_get_rep(prefixes))) : int in
let badlength? = (check_instruction_length(start_rip, temp_rip, 0)) : option(int) in
if is_some(badlength?)
then throw(Emsg("A fault occurred.  Original ACL2 AST:
['!!FAULT-FRESH', ':GP', '0', ':INSTRUCTION-LENGTH', 'BADLENGTH?']"))
else let p2 = (the_range(0, 255, prefixes_get_seg(prefixes))) : int in
let p4? = ((103) == (the_range(0, 255, prefixes_get_adr(prefixes)))) : bool in
let df = (the_range(0, 1, let rflags_var = (the_range(0, 4294967295, r_rflags(0))) : int in
rflagsbits_get_df(rflags_var))) : int in
let counter_addr_size = (the_range(2, 8, select_address_size(proc_mode, p4?, 0))) : int in
let select_byte_operand = ((164) == (opcode)) : bool in
let operand_size = (the_range(1, 8, select_operand_size(proc_mode, select_byte_operand, rex_byte, false, prefixes, false, false, false, 0))) : int in
let counter_addr_size_2_4? = (((counter_addr_size) == (2)) | ((counter_addr_size) == (4))) : bool in
let src_addr = (if counter_addr_size_2_4?
then rgfi_size(counter_addr_size, 6, rex_byte, 0)
else rgfi(6, 0)) : int in
if (not_bool(counter_addr_size_2_4?)) & (not_bool(canonical_address_p(src_addr)))
then throw(Emsg("Model state error: :SRC-ADDR-NOT-CANONICAL"))
else let inst_ac? = (alignment_checking_enabled_p(0)) : bool in
let seg_reg = (select_segment_register(proc_mode, p2, p4?, mod_var, r_m, sib, 0)) : int in
let (flg0, src, x86) = (rme_size(proc_mode, operand_size, the_range(-9223372036854775808, 9223372036854775807, src_addr), seg_reg, ":R", inst_ac?, 0, struct {mem_ptr? = false})) : (option(string), int, int) in
if is_some(flg0)
then throw(Emsg("Model state error: :SRC-RME-SIZE-ERROR"))
else let dst_addr = (if counter_addr_size_2_4?
then rgfi_size(counter_addr_size, 7, rex_byte, 0)
else rgfi(7, 0)) : int in
if (not_bool(counter_addr_size_2_4?)) & (not_bool(canonical_address_p(dst_addr)))
then throw(Emsg("Model state error: :DST-ADDR-NOT-CANONICAL"))
else let original_dst_addr = (the_range(-140737488355328, 140737488355327, dst_addr)) : int in
let (src_addr, dst_addr) = ((match operand_size {
1 => if (df) == (0)
then ((1) + (the_range(-140737488355328, 140737488355327, src_addr)), (1) + (the_range(-140737488355328, 140737488355327, dst_addr)))
else ((-1) + (the_range(-140737488355328, 140737488355327, src_addr)), (-1) + (the_range(-140737488355328, 140737488355327, dst_addr))),
2 => if (df) == (0)
then ((2) + (the_range(-140737488355328, 140737488355327, src_addr)), (2) + (the_range(-140737488355328, 140737488355327, dst_addr)))
else ((-2) + (the_range(-140737488355328, 140737488355327, src_addr)), (-2) + (the_range(-140737488355328, 140737488355327, dst_addr))),
4 => if (df) == (0)
then ((4) + (the_range(-140737488355328, 140737488355327, src_addr)), (4) + (the_range(-140737488355328, 140737488355327, dst_addr)))
else ((-4) + (the_range(-140737488355328, 140737488355327, src_addr)), (-4) + (the_range(-140737488355328, 140737488355327, dst_addr))),
_ => if (df) == (0)
then ((8) + (the_range(-140737488355328, 140737488355327, src_addr)), (8) + (the_range(-140737488355328, 140737488355327, dst_addr)))
else ((-8) + (the_range(-140737488355328, 140737488355327, src_addr)), (-8) + (the_range(-140737488355328, 140737488355327, dst_addr)))
}) : (int, int)) : (int, int) in
let src_addr = (the_range(-281474976710656, 281474976710655, src_addr)) : int in
let dst_addr = (the_range(-281474976710656, 281474976710655, dst_addr)) : int in
let (flg1, x86) = (wme_size(proc_mode, operand_size, original_dst_addr, 0, src, inst_ac?, 0, struct {mem_ptr? = false})) : (option(string), int) in
if is_some(flg1)
then throw(Emsg("Model state error: :WME-SIZE-ERROR"))
else let x86 = ((match group_1_prefix {
243 => let counter = (rgfi_size(counter_addr_size, 1, rex_byte, 0)) : int in
let counter = (trunc(counter_addr_size, (counter) - (1))) : int in
if ((counter) == (0)) | ((the_range(0, 1, let rflags_var = (the_range(0, 4294967295, r_rflags(0))) : int in
rflagsbits_get_zf(rflags_var))) == (0))
then let x86 = (write_rgfi_size(counter_addr_size, 1, counter, rex_byte, 0)) : int in
0
else let x86 = (write_rgfi_size(counter_addr_size, 1, counter, rex_byte, 0)) : int in
let x86 = (write_iptr(proc_mode, temp_rip, 0)) : int in
0,
242 => let counter = (rgfi_size(counter_addr_size, 1, rex_byte, 0)) : int in
let counter = (trunc(counter_addr_size, (counter) - (1))) : int in
if ((counter) == (0)) | ((the_range(0, 1, let rflags_var = (the_range(0, 4294967295, r_rflags(0))) : int in
rflagsbits_get_zf(rflags_var))) == (1))
then let x86 = (write_rgfi_size(counter_addr_size, 1, counter, rex_byte, 0)) : int in
let x86 = (write_iptr(proc_mode, temp_rip, 0)) : int in
0
else let x86 = (write_rgfi_size(counter_addr_size, 1, counter, rex_byte, 0)) : int in
0,
_ => write_iptr(proc_mode, temp_rip, 0)
}) : int) : int in
let x86 = ((match counter_addr_size {
2 => write_rgfi_size(2, 6, n16(the_range(-281474976710656, 281474976710655, src_addr)), rex_byte, 0),
4 => write_rgfi_size(4, 6, n32(the_range(-281474976710656, 281474976710655, src_addr)), rex_byte, 0),
_ => write_rgfi(6, the_range(-281474976710656, 281474976710655, src_addr), 0)
}) : int) : int in
let x86 = ((match counter_addr_size {
2 => write_rgfi_size(2, 7, n16(the_range(-281474976710656, 281474976710655, dst_addr)), rex_byte, 0),
4 => write_rgfi_size(4, 7, n32(the_range(-281474976710656, 281474976710655, dst_addr)), rex_byte, 0),
_ => write_rgfi(7, the_range(-281474976710656, 281474976710655, dst_addr), 0)
}) : int) : int in
0

val x86_cmps : (int, int, int, int, int, int, int, int, int) -> int effect {escape, rmem, rreg, undef, wreg}
function x86_cmps (proc_mode, start_rip, temp_rip, prefixes, rex_byte, opcode, modr_m, sib, x86) =
let ctx = ("X86-CMPS") : string in
let r_m = (the_range(0, 7, modr_m_get_r_m(modr_m))) : int in
let mod_var = (the_range(0, 3, modr_m_get_mod(modr_m))) : int in
let reg = (the_range(0, 7, modr_m_get_reg(modr_m))) : int in
let group_1_prefix = (the_range(0, 255, prefixes_get_rep(prefixes))) : int in
let badlength? = (check_instruction_length(start_rip, temp_rip, 0)) : option(int) in
if is_some(badlength?)
then throw(Emsg("A fault occurred.  Original ACL2 AST:
['!!FAULT-FRESH', ':GP', '0', ':INSTRUCTION-LENGTH', 'BADLENGTH?']"))
else let p2 = (the_range(0, 255, prefixes_get_seg(prefixes))) : int in
let p4? = ((103) == (the_range(0, 255, prefixes_get_adr(prefixes)))) : bool in
let df = (the_range(0, 1, let rflags_var = (the_range(0, 4294967295, r_rflags(0))) : int in
rflagsbits_get_df(rflags_var))) : int in
let counter_addr_size = (the_range(2, 8, select_address_size(proc_mode, p4?, 0))) : int in
let select_byte_operand = ((166) == (opcode)) : bool in
let operand_size = (the_range(1, 8, select_operand_size(proc_mode, select_byte_operand, rex_byte, false, prefixes, false, false, false, 0))) : int in
let counter_addr_size_2_4? = (((counter_addr_size) == (2)) | ((counter_addr_size) == (4))) : bool in
let src_addr = (if counter_addr_size_2_4?
then rgfi_size(counter_addr_size, 6, rex_byte, 0)
else rgfi(6, 0)) : int in
if (not_bool(counter_addr_size_2_4?)) & (not_bool(canonical_address_p(src_addr)))
then throw(Emsg("Model state error: :SRC-ADDR-NOT-CANONICAL"))
else let inst_ac? = (alignment_checking_enabled_p(0)) : bool in
let seg_reg = (select_segment_register(proc_mode, p2, p4?, mod_var, r_m, sib, 0)) : int in
let (flg0, src, x86) = (rme_size(proc_mode, operand_size, src_addr, seg_reg, ":R", inst_ac?, 0, struct {mem_ptr? = false})) : (option(string), int, int) in
if is_some(flg0)
then throw(Emsg("Model state error: :SRC-RME-SIZE-ERROR"))
else let dst_addr = (if counter_addr_size_2_4?
then rgfi_size(counter_addr_size, 7, rex_byte, 0)
else rgfi(7, 0)) : int in
if (not_bool(counter_addr_size_2_4?)) & (not_bool(canonical_address_p(dst_addr)))
then throw(Emsg("Model state error: :DST-ADDR-NOT-CANONICAL"))
else let (flg0, dst, x86) = (rme_size(proc_mode, operand_size, dst_addr, 0, ":R", inst_ac?, 0, struct {mem_ptr? = false})) : (option(string), int, int) in
if is_some(flg0)
then throw(Emsg("Model state error: :DST-RME-SIZE-ERROR"))
else let input_rflags = (the_range(0, 4294967295, r_rflags(0))) : int in
let (result, output_rflags, undefined_flags) = ((match operand_size {
1 => gpr_arith_logic_spec_1(4, dst, src, input_rflags),
2 => gpr_arith_logic_spec_2(4, dst, src, input_rflags),
4 => gpr_arith_logic_spec_4(4, dst, src, input_rflags),
_ => gpr_arith_logic_spec_8(4, dst, src, input_rflags)
}) : (int, int, int)) : (int, int, int) in
let output_rflags = (the_range(0, 4294967295, output_rflags)) : int in
let undefined_flags = (the_range(0, 4294967295, undefined_flags)) : int in
let x86 = (write_user_rflags(output_rflags, undefined_flags, 0)) : int in
let (src_addr, dst_addr) = ((match operand_size {
1 => if (df) == (0)
then ((the_range(-140737488355328, 140737488355327, src_addr)) + (1), (the_range(-140737488355328, 140737488355327, dst_addr)) + (1))
else ((the_range(-140737488355328, 140737488355327, src_addr)) - (1), (the_range(-140737488355328, 140737488355327, dst_addr)) - (1)),
2 => if (df) == (0)
then ((the_range(-140737488355328, 140737488355327, src_addr)) + (2), (the_range(-140737488355328, 140737488355327, dst_addr)) + (2))
else ((the_range(-140737488355328, 140737488355327, src_addr)) - (2), (the_range(-140737488355328, 140737488355327, dst_addr)) - (2)),
4 => if (df) == (0)
then ((the_range(-140737488355328, 140737488355327, src_addr)) + (4), (the_range(-140737488355328, 140737488355327, dst_addr)) + (4))
else ((the_range(-140737488355328, 140737488355327, src_addr)) - (4), (the_range(-140737488355328, 140737488355327, dst_addr)) - (4)),
_ => if (df) == (0)
then ((the_range(-140737488355328, 140737488355327, src_addr)) + (8), (the_range(-140737488355328, 140737488355327, dst_addr)) + (8))
else ((the_range(-140737488355328, 140737488355327, src_addr)) - (8), (the_range(-140737488355328, 140737488355327, dst_addr)) - (8))
}) : (int, int)) : (int, int) in
let src_addr = (the_range(-281474976710656, 281474976710655, src_addr)) : int in
let dst_addr = (the_range(-281474976710656, 281474976710655, dst_addr)) : int in
let x86 = ((match group_1_prefix {
243 => let counter = (rgfi_size(counter_addr_size, 1, rex_byte, 0)) : int in
let counter = (trunc(counter_addr_size, (counter) - (1))) : int in
if ((counter) == (0)) | ((the_range(0, 1, let rflags_var = (the_range(0, 4294967295, r_rflags(0))) : int in
rflagsbits_get_zf(rflags_var))) == (0))
then let x86 = (write_rgfi_size(counter_addr_size, 1, counter, rex_byte, 0)) : int in
0
else let x86 = (write_rgfi_size(counter_addr_size, 1, counter, rex_byte, 0)) : int in
let x86 = (write_iptr(proc_mode, temp_rip, 0)) : int in
0,
242 => let counter = (rgfi_size(counter_addr_size, 1, rex_byte, 0)) : int in
let counter = (trunc(counter_addr_size, (counter) - (1))) : int in
if ((counter) == (0)) | ((the_range(0, 1, let rflags_var = (the_range(0, 4294967295, r_rflags(0))) : int in
rflagsbits_get_zf(rflags_var))) == (1))
then let x86 = (write_rgfi_size(counter_addr_size, 1, counter, rex_byte, 0)) : int in
let x86 = (write_iptr(proc_mode, temp_rip, 0)) : int in
0
else let x86 = (write_rgfi_size(counter_addr_size, 1, counter, rex_byte, 0)) : int in
0,
_ => write_iptr(proc_mode, temp_rip, 0)
}) : int) : int in
let x86 = ((match counter_addr_size {
2 => write_rgfi_size(2, 6, n16(the_range(-281474976710656, 281474976710655, src_addr)), rex_byte, 0),
4 => write_rgfi_size(4, 6, n32(the_range(-281474976710656, 281474976710655, src_addr)), rex_byte, 0),
_ => write_rgfi(6, the_range(-281474976710656, 281474976710655, src_addr), 0)
}) : int) : int in
let x86 = ((match counter_addr_size {
2 => write_rgfi_size(2, 7, n16(the_range(-281474976710656, 281474976710655, dst_addr)), rex_byte, 0),
4 => write_rgfi_size(4, 7, n32(the_range(-281474976710656, 281474976710655, dst_addr)), rex_byte, 0),
_ => write_rgfi(7, the_range(-281474976710656, 281474976710655, dst_addr), 0)
}) : int) : int in
0

val x86_stos : (int, int, int, int, int, int, int, int, int) -> int effect {eamem, escape, rreg, wmv, wreg}
function x86_stos (proc_mode, start_rip, temp_rip, prefixes, rex_byte, opcode, modr_m, sib, x86) =
let ctx = ("X86-STOS") : string in
let group_1_prefix = (the_range(0, 255, prefixes_get_seg(prefixes))) : int in
let badlength? = (check_instruction_length(start_rip, temp_rip, 0)) : option(int) in
if is_some(badlength?)
then throw(Emsg("A fault occurred.  Original ACL2 AST:
['!!FAULT-FRESH', ':GP', '0', ':INSTRUCTION-LENGTH', 'BADLENGTH?']"))
else let p4? = ((103) == (the_range(0, 255, prefixes_get_adr(prefixes)))) : bool in
let df = (the_range(0, 1, let rflags_var = (the_range(0, 4294967295, r_rflags(0))) : int in
rflagsbits_get_df(rflags_var))) : int in
let counter_addr_size = (the_range(2, 8, select_address_size(proc_mode, p4?, 0))) : int in
let counter_addr_size_2_4? = (((counter_addr_size) == (2)) | ((counter_addr_size) == (4))) : bool in
let dst_addr = (if counter_addr_size_2_4?
then rgfi_size(counter_addr_size, 7, rex_byte, 0)
else rgfi(7, 0)) : int in
if (not_bool(counter_addr_size_2_4?)) & (not_bool(canonical_address_p(dst_addr)))
then throw(Emsg("Model state error: :DST-ADDR-NOT-CANONICAL"))
else let select_byte_operand = ((170) == (opcode)) : bool in
let operand_size = (the_range(1, 8, select_operand_size(proc_mode, select_byte_operand, rex_byte, false, prefixes, false, false, false, 0))) : int in
let rax_var = (rgfi_size(operand_size, 0, rex_byte, 0)) : int in
let inst_ac? = (alignment_checking_enabled_p(0)) : bool in
let (flg0, x86) = (wme_size(proc_mode, operand_size, dst_addr, 0, rax_var, inst_ac?, 0, struct {mem_ptr? = false})) : (option(string), int) in
if is_some(flg0)
then throw(Emsg("Model state error: :WME-SIZE-ERROR"))
else let dst_addr = (the_range(-281474976710656, 281474976710655, (match operand_size {
1 => if (df) == (0)
then (1) + (the_range(-140737488355328, 140737488355327, dst_addr))
else (-1) + (the_range(-140737488355328, 140737488355327, dst_addr)),
2 => if (df) == (0)
then (2) + (the_range(-140737488355328, 140737488355327, dst_addr))
else (-2) + (the_range(-140737488355328, 140737488355327, dst_addr)),
4 => if (df) == (0)
then (4) + (the_range(-140737488355328, 140737488355327, dst_addr))
else (-4) + (the_range(-140737488355328, 140737488355327, dst_addr)),
_ => if (df) == (0)
then (8) + (the_range(-140737488355328, 140737488355327, dst_addr))
else (-8) + (the_range(-140737488355328, 140737488355327, dst_addr))
}) : int)) : int in
let x86 = ((match group_1_prefix {
243 => let counter = (rgfi_size(counter_addr_size, 1, rex_byte, 0)) : int in
let counter = (trunc(counter_addr_size, (counter) - (1))) : int in
if ((counter) == (0)) | ((the_range(0, 1, let rflags_var = (the_range(0, 4294967295, r_rflags(0))) : int in
rflagsbits_get_zf(rflags_var))) == (0))
then let x86 = (write_rgfi_size(counter_addr_size, 1, counter, rex_byte, 0)) : int in
0
else let x86 = (write_rgfi_size(counter_addr_size, 1, counter, rex_byte, 0)) : int in
let x86 = (write_iptr(proc_mode, temp_rip, 0)) : int in
0,
242 => let counter = (rgfi_size(counter_addr_size, 1, rex_byte, 0)) : int in
let counter = (trunc(counter_addr_size, (counter) - (1))) : int in
if ((counter) == (0)) | ((the_range(0, 1, let rflags_var = (the_range(0, 4294967295, r_rflags(0))) : int in
rflagsbits_get_zf(rflags_var))) == (1))
then let x86 = (write_rgfi_size(counter_addr_size, 1, counter, rex_byte, 0)) : int in
let x86 = (write_iptr(proc_mode, temp_rip, 0)) : int in
0
else let x86 = (write_rgfi_size(counter_addr_size, 1, counter, rex_byte, 0)) : int in
0,
_ => write_iptr(proc_mode, temp_rip, 0)
}) : int) : int in
let x86 = ((match counter_addr_size {
2 => write_rgfi_size(2, 7, n16(the_range(-281474976710656, 281474976710655, dst_addr)), rex_byte, 0),
4 => write_rgfi_size(4, 7, n32(the_range(-281474976710656, 281474976710655, dst_addr)), rex_byte, 0),
_ => write_rgfi(7, the_range(-281474976710656, 281474976710655, dst_addr), 0)
}) : int) : int in
0

