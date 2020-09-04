$include <prelude.sail>
$include <string.sail>

val div_spec_8 : (int, int) -> (bool, int, int) effect {escape}
function div_spec_8 (dst, src) =
let dst = (n_size(16, dst)) : int in
let src = (n_size(8, src)) : int in
let quotient = (the_range(0, 65535, floor2(dst, src))) : int in
let remainder = (the_range(0, 255, mod(dst, src))) : int in
let overflow? = ((255) < (quotient)) : bool in
if overflow?
then (true, 0 : int, 0 : int)
else (overflow?, quotient, remainder)

val div_spec_16 : (int, int) -> (bool, int, int) effect {escape}
function div_spec_16 (dst, src) =
let dst = (n_size(32, dst)) : int in
let src = (n_size(16, src)) : int in
let quotient = (the_range(0, 4294967295, floor2(dst, src))) : int in
let remainder = (the_range(0, 65535, mod(dst, src))) : int in
let overflow? = ((65535) < (quotient)) : bool in
if overflow?
then (true, 0 : int, 0 : int)
else (overflow?, quotient, remainder)

val div_spec_32 : (int, int) -> (bool, int, int) effect {escape}
function div_spec_32 (dst, src) =
let dst = (n_size(64, dst)) : int in
let src = (n_size(32, src)) : int in
let quotient = (the_range(0, 18446744073709551615, floor2(dst, src))) : int in
let remainder = (the_range(0, 4294967295, mod(dst, src))) : int in
let overflow? = ((4294967295) < (quotient)) : bool in
if overflow?
then (true, 0 : int, 0 : int)
else (overflow?, quotient, remainder)

val div_spec_64 : (int, int) -> (bool, int, int) effect {escape}
function div_spec_64 (dst, src) =
let dst = (n_size(128, dst)) : int in
let src = (n_size(64, src)) : int in
let quotient = (the_range(0, 340282366920938463463374607431768211455, floor2(dst, src))) : int in
let remainder = (the_range(0, 18446744073709551615, mod(dst, src))) : int in
let overflow? = ((18446744073709551615) < (quotient)) : bool in
if overflow?
then (true, 0 : int, 0 : int)
else (overflow?, quotient, remainder)

/*Specification for the @ ( ' DIV ' ) ( unsigned divide ) instruction*/
val div_spec : (int, int, int) -> (bool, int, int) effect {escape}
function div_spec (size, dst, src) =
(match size {
1 => div_spec_8(dst, src),
2 => div_spec_16(dst, src),
4 => div_spec_32(dst, src),
8 => div_spec_64(dst, src),
_ => (false, 0 : int, 0 : int)
}) : (bool, int, int)

val idiv_spec_8 : (int, int) -> (bool, int, int) effect {escape}
function idiv_spec_8 (dst, src) =
let dst_int = (the_range(-32768, 32767, n16_to_i16(dst))) : int in
let src_int = (the_range(-128, 127, n08_to_i08(src))) : int in
let quotient_int = (the_range(-65536, 65535, tdiv_int(dst_int, src_int))) : int in
let remainder_int = (the_range(-128, 127, tmod_int(dst_int, src_int))) : int in
let overflow? = (((the_range(-65536, 65535, quotient_int)) < (-127)) | ((128) < (the_range(-65536, 65535, quotient_int)))) : bool in
if overflow?
then (true, 0 : int, 0 : int)
else let quotient = (the_range(0, 255, n_size(8, quotient_int))) : int in
let remainder = (the_range(0, 255, n_size(8, remainder_int))) : int in
(overflow?, quotient, remainder)

val idiv_spec_16 : (int, int) -> (bool, int, int) effect {escape}
function idiv_spec_16 (dst, src) =
let dst_int = (the_range(-2147483648, 2147483647, n32_to_i32(dst))) : int in
let src_int = (the_range(-32768, 32767, n16_to_i16(src))) : int in
let quotient_int = (the_range(-4294967296, 4294967295, tdiv_int(dst_int, src_int))) : int in
let remainder_int = (the_range(-32768, 32767, tmod_int(dst_int, src_int))) : int in
let overflow? = (((the_range(-4294967296, 4294967295, quotient_int)) < (-32767)) | ((32768) < (the_range(-4294967296, 4294967295, quotient_int)))) : bool in
if overflow?
then (true, 0 : int, 0 : int)
else let quotient = (the_range(0, 65535, n_size(16, quotient_int))) : int in
let remainder = (the_range(0, 65535, n_size(16, remainder_int))) : int in
(overflow?, quotient, remainder)

val idiv_spec_32 : (int, int) -> (bool, int, int) effect {escape}
function idiv_spec_32 (dst, src) =
let dst_int = (the_range(-9223372036854775808, 9223372036854775807, n64_to_i64(dst))) : int in
let src_int = (the_range(-2147483648, 2147483647, n32_to_i32(src))) : int in
let quotient_int = (the_range(-18446744073709551616, 18446744073709551615, tdiv_int(dst_int, src_int))) : int in
let remainder_int = (the_range(-2147483648, 2147483647, tmod_int(dst_int, src_int))) : int in
let overflow? = (((the_range(-18446744073709551616, 18446744073709551615, quotient_int)) < (-2147483647)) | ((2147483648) < (the_range(-18446744073709551616, 18446744073709551615, quotient_int)))) : bool in
if overflow?
then (true, 0 : int, 0 : int)
else let quotient = (the_range(0, 4294967295, n_size(32, quotient_int))) : int in
let remainder = (the_range(0, 4294967295, n_size(32, remainder_int))) : int in
(overflow?, quotient, remainder)

val idiv_spec_64 : (int, int) -> (bool, int, int) effect {escape}
function idiv_spec_64 (dst, src) =
let dst_int = (the_range(-170141183460469231731687303715884105728, 170141183460469231731687303715884105727, n128_to_i128(dst))) : int in
let src_int = (the_range(-9223372036854775808, 9223372036854775807, n64_to_i64(src))) : int in
let quotient_int = (the_range(-340282366920938463463374607431768211456, 340282366920938463463374607431768211455, tdiv_int(dst_int, src_int))) : int in
let remainder_int = (the_range(-9223372036854775808, 9223372036854775807, tmod_int(dst_int, src_int))) : int in
let overflow? = (((the_range(-340282366920938463463374607431768211456, 340282366920938463463374607431768211455, quotient_int)) < (-9223372036854775807)) | ((9223372036854775808) < (the_range(-340282366920938463463374607431768211456, 340282366920938463463374607431768211455, quotient_int)))) : bool in
if overflow?
then (true, 0 : int, 0 : int)
else let quotient = (the_range(0, 18446744073709551615, n_size(64, quotient_int))) : int in
let remainder = (the_range(0, 18446744073709551615, n_size(64, remainder_int))) : int in
(overflow?, quotient, remainder)

/*Specification for the @ ( ' IDIV ' ) ( unsigned idivide ) instruction*/
val idiv_spec : (int, int, int) -> (bool, int, int) effect {escape}
function idiv_spec (size, dst, src) =
(match size {
1 => idiv_spec_8(dst, src),
2 => idiv_spec_16(dst, src),
4 => idiv_spec_32(dst, src),
8 => idiv_spec_64(dst, src),
_ => (false, 0 : int, 0 : int)
}) : (bool, int, int)

