$include <prelude.sail>
$include <string.sail>

val mul_spec_8 : (int, int) -> (int, int, int) effect {escape}
function mul_spec_8 (dst, src) =
let dst = (n_size(8, dst)) : int in
let src = (n_size(8, src)) : int in
let product = (the_range(0, 65535, (dst) * (src))) : int in
let product_high = (unsigned(get_slice_int(8, product, 8))) : int in
let product_low = (unsigned(get_slice_int(8, product, 0))) : int in
(product_high, product_low, product)

val mul_spec_16 : (int, int) -> (int, int, int) effect {escape}
function mul_spec_16 (dst, src) =
let dst = (n_size(16, dst)) : int in
let src = (n_size(16, src)) : int in
let product = (the_range(0, 4294967295, (dst) * (src))) : int in
let product_high = (unsigned(get_slice_int(16, product, 16))) : int in
let product_low = (unsigned(get_slice_int(16, product, 0))) : int in
(product_high, product_low, product)

val mul_spec_32 : (int, int) -> (int, int, int) effect {escape}
function mul_spec_32 (dst, src) =
let dst = (n_size(32, dst)) : int in
let src = (n_size(32, src)) : int in
let product = (the_range(0, 18446744073709551615, (dst) * (src))) : int in
let product_high = (unsigned(get_slice_int(32, product, 32))) : int in
let product_low = (unsigned(get_slice_int(32, product, 0))) : int in
(product_high, product_low, product)

val mul_spec_64 : (int, int) -> (int, int, int) effect {escape}
function mul_spec_64 (dst, src) =
let dst = (n_size(64, dst)) : int in
let src = (n_size(64, src)) : int in
let product = (the_range(0, 340282366920938463463374607431768211455, (dst) * (src))) : int in
let product_high = (unsigned(get_slice_int(64, product, 64))) : int in
let product_low = (unsigned(get_slice_int(64, product, 0))) : int in
(product_high, product_low, product)

/*Specification for the @ ( ' MUL ' ) ( unsigned multiply ) instruction*/
val mul_spec : (int, int, int) -> (int, int, int) effect {escape}
function mul_spec (size, dst, src) =
(match size {
1 => mul_spec_8(dst, src),
2 => mul_spec_16(dst, src),
4 => mul_spec_32(dst, src),
8 => mul_spec_64(dst, src),
_ => (0 : int, 0 : int, 0 : int)
}) : (int, int, int)

val imul_spec_8 : (int, int) -> (int, int, int, int) effect {escape}
function imul_spec_8 (dst, src) =
let dst_int = (the_range(-128, 127, n08_to_i08(dst))) : int in
let src_int = (the_range(-128, 127, n08_to_i08(src))) : int in
let product_int = (the_range(-32768, 32767, (the_range(-128, 127, dst_int)) * (the_range(-128, 127, src_int)))) : int in
let product = (the_range(0, 65535, n_size(16, product_int))) : int in
let product_high = (unsigned(get_slice_int(8, product, 8))) : int in
let product_low = (unsigned(get_slice_int(8, product, 0))) : int in
let product_low_int = (the_range(-128, 127, n08_to_i08(product_low))) : int in
let cf_and_of = (the_range(0, 1, bool_to_bit(not_bool((the_range(-128, 127, product_low_int)) == (the_range(-32768, 32767, product_int)))))) : int in
(product_high, product_low, product, cf_and_of)

val imul_spec_16 : (int, int) -> (int, int, int, int) effect {escape}
function imul_spec_16 (dst, src) =
let dst_int = (the_range(-32768, 32767, n16_to_i16(dst))) : int in
let src_int = (the_range(-32768, 32767, n16_to_i16(src))) : int in
let product_int = (the_range(-2147483648, 2147483647, (the_range(-32768, 32767, dst_int)) * (the_range(-32768, 32767, src_int)))) : int in
let product = (the_range(0, 4294967295, n_size(32, product_int))) : int in
let product_high = (unsigned(get_slice_int(16, product, 16))) : int in
let product_low = (unsigned(get_slice_int(16, product, 0))) : int in
let product_low_int = (the_range(-32768, 32767, n16_to_i16(product_low))) : int in
let cf_and_of = (the_range(0, 1, bool_to_bit(not_bool((the_range(-32768, 32767, product_low_int)) == (the_range(-2147483648, 2147483647, product_int)))))) : int in
(product_high, product_low, product, cf_and_of)

val imul_spec_32 : (int, int) -> (int, int, int, int) effect {escape}
function imul_spec_32 (dst, src) =
let dst_int = (the_range(-2147483648, 2147483647, n32_to_i32(dst))) : int in
let src_int = (the_range(-2147483648, 2147483647, n32_to_i32(src))) : int in
let product_int = (the_range(-9223372036854775808, 9223372036854775807, (the_range(-2147483648, 2147483647, dst_int)) * (the_range(-2147483648, 2147483647, src_int)))) : int in
let product = (the_range(0, 18446744073709551615, n_size(64, product_int))) : int in
let product_high = (unsigned(get_slice_int(32, product, 32))) : int in
let product_low = (unsigned(get_slice_int(32, product, 0))) : int in
let product_low_int = (the_range(-2147483648, 2147483647, n32_to_i32(product_low))) : int in
let cf_and_of = (the_range(0, 1, bool_to_bit(not_bool((the_range(-2147483648, 2147483647, product_low_int)) == (the_range(-9223372036854775808, 9223372036854775807, product_int)))))) : int in
(product_high, product_low, product, cf_and_of)

val imul_spec_64 : (int, int) -> (int, int, int, int) effect {escape}
function imul_spec_64 (dst, src) =
let dst_int = (the_range(-9223372036854775808, 9223372036854775807, n64_to_i64(dst))) : int in
let src_int = (the_range(-9223372036854775808, 9223372036854775807, n64_to_i64(src))) : int in
let product_int = (the_range(-170141183460469231731687303715884105728, 170141183460469231731687303715884105727, (the_range(-9223372036854775808, 9223372036854775807, dst_int)) * (the_range(-9223372036854775808, 9223372036854775807, src_int)))) : int in
let product = (the_range(0, 340282366920938463463374607431768211455, n_size(128, product_int))) : int in
let product_high = (unsigned(get_slice_int(64, product, 64))) : int in
let product_low = (unsigned(get_slice_int(64, product, 0))) : int in
let product_low_int = (the_range(-9223372036854775808, 9223372036854775807, n64_to_i64(product_low))) : int in
let cf_and_of = (the_range(0, 1, bool_to_bit(not_bool((the_range(-9223372036854775808, 9223372036854775807, product_low_int)) == (the_range(-170141183460469231731687303715884105728, 170141183460469231731687303715884105727, product_int)))))) : int in
(product_high, product_low, product, cf_and_of)

/*Specification for the @ ( ' IMUL ' ) ( unsigned imultiply ) instruction*/
val imul_spec : (int, int, int) -> (int, int, int, int) effect {escape}
function imul_spec (size, dst, src) =
(match size {
1 => imul_spec_8(dst, src),
2 => imul_spec_16(dst, src),
4 => imul_spec_32(dst, src),
8 => imul_spec_64(dst, src),
_ => (0 : int, 0 : int, 0 : int, 0 : int)
}) : (int, int, int, int)

