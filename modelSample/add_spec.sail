$include <prelude.sail>
$include <string.sail>
$include "rflags_spec.sail"
val gpr_add_spec_1 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_add_spec_1 (dst, src, input_rflags) =
let dst = (n_size(8, dst)) : int in
let src = (n_size(8, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let raw_result = ((dst) + (src)) : int in
let signed_raw_result = ((n08_to_i08(dst)) + (n08_to_i08(src))) : int in
let result = (n_size(8, raw_result)) : int in
let cf = (cf_spec8(raw_result)) : int in
let pf = (pf_spec8(result)) : int in
let af = (add_af_spec8(dst, src)) : int in
let zf = (zf_spec(result)) : int in
let sf = (sf_spec8(result)) : int in
let of = (of_spec8(signed_raw_result)) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

val gpr_add_spec_2 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_add_spec_2 (dst, src, input_rflags) =
let dst = (n_size(16, dst)) : int in
let src = (n_size(16, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let raw_result = ((dst) + (src)) : int in
let signed_raw_result = ((n16_to_i16(dst)) + (n16_to_i16(src))) : int in
let result = (n_size(16, raw_result)) : int in
let cf = (cf_spec16(raw_result)) : int in
let pf = (pf_spec16(result)) : int in
let af = (add_af_spec16(dst, src)) : int in
let zf = (zf_spec(result)) : int in
let sf = (sf_spec16(result)) : int in
let of = (of_spec16(signed_raw_result)) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

val gpr_add_spec_4 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_add_spec_4 (dst, src, input_rflags) =
let dst = (n_size(32, dst)) : int in
let src = (n_size(32, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let raw_result = ((dst) + (src)) : int in
let signed_raw_result = ((n32_to_i32(dst)) + (n32_to_i32(src))) : int in
let result = (n_size(32, raw_result)) : int in
let cf = (cf_spec32(raw_result)) : int in
let pf = (pf_spec32(result)) : int in
let af = (add_af_spec32(dst, src)) : int in
let zf = (zf_spec(result)) : int in
let sf = (sf_spec32(result)) : int in
let of = (of_spec32(signed_raw_result)) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

val gpr_add_spec_8 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_add_spec_8 (dst, src, input_rflags) =
let dst = (n_size(64, dst)) : int in
let src = (n_size(64, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let raw_result = ((dst) + (src)) : int in
let signed_raw_result = ((n64_to_i64(dst)) + (n64_to_i64(src))) : int in
let result = (n_size(64, raw_result)) : int in
let cf = (cf_spec64(raw_result)) : int in
let pf = (pf_spec64(result)) : int in
let af = (add_af_spec64(dst, src)) : int in
let zf = (zf_spec(result)) : int in
let sf = (sf_spec64(result)) : int in
let of = (of_spec64(signed_raw_result)) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

val gpr_adc_spec_1 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_adc_spec_1 (dst, src, input_rflags) =
let dst = (n_size(8, dst)) : int in
let src = (n_size(8, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let input_cf = (rflagsbits_get_cf(input_rflags)) : int in
let raw_result = ((dst) + ((src) + (input_cf))) : int in
let signed_raw_result = ((n08_to_i08(dst)) + ((n08_to_i08(src)) + (input_cf))) : int in
let result = (n_size(8, raw_result)) : int in
let cf = (cf_spec8(raw_result)) : int in
let pf = (pf_spec8(result)) : int in
let af = (adc_af_spec8(dst, src, input_cf)) : int in
let zf = (zf_spec(result)) : int in
let sf = (sf_spec8(result)) : int in
let of = (of_spec8(signed_raw_result)) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

val gpr_adc_spec_2 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_adc_spec_2 (dst, src, input_rflags) =
let dst = (n_size(16, dst)) : int in
let src = (n_size(16, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let input_cf = (rflagsbits_get_cf(input_rflags)) : int in
let raw_result = ((dst) + ((src) + (input_cf))) : int in
let signed_raw_result = ((n16_to_i16(dst)) + ((n16_to_i16(src)) + (input_cf))) : int in
let result = (n_size(16, raw_result)) : int in
let cf = (cf_spec16(raw_result)) : int in
let pf = (pf_spec16(result)) : int in
let af = (adc_af_spec16(dst, src, input_cf)) : int in
let zf = (zf_spec(result)) : int in
let sf = (sf_spec16(result)) : int in
let of = (of_spec16(signed_raw_result)) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

val gpr_adc_spec_4 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_adc_spec_4 (dst, src, input_rflags) =
let dst = (n_size(32, dst)) : int in
let src = (n_size(32, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let input_cf = (rflagsbits_get_cf(input_rflags)) : int in
let raw_result = ((dst) + ((src) + (input_cf))) : int in
let signed_raw_result = ((n32_to_i32(dst)) + ((n32_to_i32(src)) + (input_cf))) : int in
let result = (n_size(32, raw_result)) : int in
let cf = (cf_spec32(raw_result)) : int in
let pf = (pf_spec32(result)) : int in
let af = (adc_af_spec32(dst, src, input_cf)) : int in
let zf = (zf_spec(result)) : int in
let sf = (sf_spec32(result)) : int in
let of = (of_spec32(signed_raw_result)) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

val gpr_adc_spec_8 : (int, int, int) -> (int, int, int) effect {escape}
function gpr_adc_spec_8 (dst, src, input_rflags) =
let dst = (n_size(64, dst)) : int in
let src = (n_size(64, src)) : int in
let input_rflags = (n32(input_rflags)) : int in
let input_cf = (rflagsbits_get_cf(input_rflags)) : int in
let raw_result = ((dst) + ((src) + (input_cf))) : int in
let signed_raw_result = ((n64_to_i64(dst)) + ((n64_to_i64(src)) + (input_cf))) : int in
let result = (n_size(64, raw_result)) : int in
let cf = (cf_spec64(raw_result)) : int in
let pf = (pf_spec64(result)) : int in
let af = (adc_af_spec64(dst, src, input_cf)) : int in
let zf = (zf_spec(result)) : int in
let sf = (sf_spec64(result)) : int in
let of = (of_spec64(signed_raw_result)) : int in
let output_rflags = (change_rflagsbits(input_rflags, Some(cf), None(), Some(pf), None(), Some(af), None(), Some(zf), Some(sf), None(), None(), None(), Some(of), None(), None(), None(), None(), None(), None(), None(), None(), None(), None())) : int in
let output_rflags = (n32(output_rflags)) : int in
let undefined_flags = (0) : int in
(result, output_rflags, undefined_flags)

