$include <prelude.sail>
$include <string.sail>
$include "rflags_spec.sail"
val gpr_add_spec_1 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_add_spec_1 (dst, src, input_rflags) =
let dst = (n_size(8, dst)) : int in
let src = (n_size(8, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let raw_result = (the_range(0, 511, (the_range(0, 255, dst)) + (the_range(0, 255, src)))) : int in
let signed_raw_result = (the_range(-256, 255, (the_range(-128, 127, n08_to_i08(dst))) + (the_range(-128, 127, n08_to_i08(src))))) : int in
let result = (the_range(0, 255, n_size(8, raw_result))) : int in
let cf = (the_range(0, 1, cf_spec8(raw_result))) : int in
let pf = (the_range(0, 1, pf_spec8(result))) : int in
let af = (the_range(0, 1, add_af_spec8(dst, src))) : int in
let zf = (the_range(0, 1, zf_spec(result))) : int in
let sf = (the_range(0, 1, sf_spec8(result))) : int in
let of = (the_range(0, 1, of_spec8(signed_raw_result))) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

val gpr_add_spec_2 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_add_spec_2 (dst, src, input_rflags) =
let dst = (n_size(16, dst)) : int in
let src = (n_size(16, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let raw_result = (the_range(0, 131071, (the_range(0, 65535, dst)) + (the_range(0, 65535, src)))) : int in
let signed_raw_result = (the_range(-65536, 65535, (the_range(-32768, 32767, n16_to_i16(dst))) + (the_range(-32768, 32767, n16_to_i16(src))))) : int in
let result = (the_range(0, 65535, n_size(16, raw_result))) : int in
let cf = (the_range(0, 1, cf_spec16(raw_result))) : int in
let pf = (the_range(0, 1, pf_spec16(result))) : int in
let af = (the_range(0, 1, add_af_spec16(dst, src))) : int in
let zf = (the_range(0, 1, zf_spec(result))) : int in
let sf = (the_range(0, 1, sf_spec16(result))) : int in
let of = (the_range(0, 1, of_spec16(signed_raw_result))) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

val gpr_add_spec_4 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_add_spec_4 (dst, src, input_rflags) =
let dst = (n_size(32, dst)) : int in
let src = (n_size(32, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let raw_result = (the_range(0, 8589934591, (the_range(0, 4294967295, dst)) + (the_range(0, 4294967295, src)))) : int in
let signed_raw_result = (the_range(-4294967296, 4294967295, (the_range(-2147483648, 2147483647, n32_to_i32(dst))) + (the_range(-2147483648, 2147483647, n32_to_i32(src))))) : int in
let result = (the_range(0, 4294967295, n_size(32, raw_result))) : int in
let cf = (the_range(0, 1, cf_spec32(raw_result))) : int in
let pf = (the_range(0, 1, pf_spec32(result))) : int in
let af = (the_range(0, 1, add_af_spec32(dst, src))) : int in
let zf = (the_range(0, 1, zf_spec(result))) : int in
let sf = (the_range(0, 1, sf_spec32(result))) : int in
let of = (the_range(0, 1, of_spec32(signed_raw_result))) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

val gpr_add_spec_8 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_add_spec_8 (dst, src, input_rflags) =
let dst = (n_size(64, dst)) : int in
let src = (n_size(64, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let raw_result = (the_range(0, 36893488147419103231, (the_range(0, 18446744073709551615, dst)) + (the_range(0, 18446744073709551615, src)))) : int in
let signed_raw_result = (the_range(-18446744073709551616, 18446744073709551615, (the_range(-9223372036854775808, 9223372036854775807, n64_to_i64(dst))) + (the_range(-9223372036854775808, 9223372036854775807, n64_to_i64(src))))) : int in
let result = (the_range(0, 18446744073709551615, n_size(64, raw_result))) : int in
let cf = (the_range(0, 1, cf_spec64(raw_result))) : int in
let pf = (the_range(0, 1, pf_spec64(result))) : int in
let af = (the_range(0, 1, add_af_spec64(dst, src))) : int in
let zf = (the_range(0, 1, zf_spec(result))) : int in
let sf = (the_range(0, 1, sf_spec64(result))) : int in
let of = (the_range(0, 1, of_spec64(signed_raw_result))) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

val gpr_adc_spec_1 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_adc_spec_1 (dst, src, input_rflags) =
let dst = (n_size(8, dst)) : int in
let src = (n_size(8, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let input_cf = (the_range(0, 1, rflagsbits_get_cf(input_rflags))) : int in
let raw_result = (the_range(0, 511, (the_range(0, 255, dst)) + ((the_range(0, 255, src)) + (the_range(0, 1, input_cf))))) : int in
let signed_raw_result = (the_range(-256, 255, (the_range(-128, 127, n08_to_i08(dst))) + ((the_range(-128, 127, n08_to_i08(src))) + (the_range(0, 1, input_cf))))) : int in
let result = (the_range(0, 255, n_size(8, raw_result))) : int in
let cf = (the_range(0, 1, cf_spec8(raw_result))) : int in
let pf = (the_range(0, 1, pf_spec8(result))) : int in
let af = (the_range(0, 1, adc_af_spec8(dst, src, input_cf))) : int in
let zf = (the_range(0, 1, zf_spec(result))) : int in
let sf = (the_range(0, 1, sf_spec8(result))) : int in
let of = (the_range(0, 1, of_spec8(signed_raw_result))) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

val gpr_adc_spec_2 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_adc_spec_2 (dst, src, input_rflags) =
let dst = (n_size(16, dst)) : int in
let src = (n_size(16, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let input_cf = (the_range(0, 1, rflagsbits_get_cf(input_rflags))) : int in
let raw_result = (the_range(0, 131071, (the_range(0, 65535, dst)) + ((the_range(0, 65535, src)) + (the_range(0, 1, input_cf))))) : int in
let signed_raw_result = (the_range(-65536, 65535, (the_range(-32768, 32767, n16_to_i16(dst))) + ((the_range(-32768, 32767, n16_to_i16(src))) + (the_range(0, 1, input_cf))))) : int in
let result = (the_range(0, 65535, n_size(16, raw_result))) : int in
let cf = (the_range(0, 1, cf_spec16(raw_result))) : int in
let pf = (the_range(0, 1, pf_spec16(result))) : int in
let af = (the_range(0, 1, adc_af_spec16(dst, src, input_cf))) : int in
let zf = (the_range(0, 1, zf_spec(result))) : int in
let sf = (the_range(0, 1, sf_spec16(result))) : int in
let of = (the_range(0, 1, of_spec16(signed_raw_result))) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

val gpr_adc_spec_4 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_adc_spec_4 (dst, src, input_rflags) =
let dst = (n_size(32, dst)) : int in
let src = (n_size(32, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let input_cf = (the_range(0, 1, rflagsbits_get_cf(input_rflags))) : int in
let raw_result = (the_range(0, 8589934591, (the_range(0, 4294967295, dst)) + ((the_range(0, 4294967295, src)) + (the_range(0, 1, input_cf))))) : int in
let signed_raw_result = (the_range(-4294967296, 4294967295, (the_range(-2147483648, 2147483647, n32_to_i32(dst))) + ((the_range(-2147483648, 2147483647, n32_to_i32(src))) + (the_range(0, 1, input_cf))))) : int in
let result = (the_range(0, 4294967295, n_size(32, raw_result))) : int in
let cf = (the_range(0, 1, cf_spec32(raw_result))) : int in
let pf = (the_range(0, 1, pf_spec32(result))) : int in
let af = (the_range(0, 1, adc_af_spec32(dst, src, input_cf))) : int in
let zf = (the_range(0, 1, zf_spec(result))) : int in
let sf = (the_range(0, 1, sf_spec32(result))) : int in
let of = (the_range(0, 1, of_spec32(signed_raw_result))) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

val gpr_adc_spec_8 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_adc_spec_8 (dst, src, input_rflags) =
let dst = (n_size(64, dst)) : int in
let src = (n_size(64, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let input_cf = (the_range(0, 1, rflagsbits_get_cf(input_rflags))) : int in
let raw_result = (the_range(0, 36893488147419103231, (the_range(0, 18446744073709551615, dst)) + ((the_range(0, 18446744073709551615, src)) + (the_range(0, 1, input_cf))))) : int in
let signed_raw_result = (the_range(-18446744073709551616, 18446744073709551615, (the_range(-9223372036854775808, 9223372036854775807, n64_to_i64(dst))) + ((the_range(-9223372036854775808, 9223372036854775807, n64_to_i64(src))) + (the_range(0, 1, input_cf))))) : int in
let result = (the_range(0, 18446744073709551615, n_size(64, raw_result))) : int in
let cf = (the_range(0, 1, cf_spec64(raw_result))) : int in
let pf = (the_range(0, 1, pf_spec64(result))) : int in
let af = (the_range(0, 1, adc_af_spec64(dst, src, input_cf))) : int in
let zf = (the_range(0, 1, zf_spec(result))) : int in
let sf = (the_range(0, 1, sf_spec64(result))) : int in
let of = (the_range(0, 1, of_spec64(signed_raw_result))) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

