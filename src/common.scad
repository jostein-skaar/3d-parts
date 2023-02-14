// clang-format off
include<BOSL2/std.scad>;
include<BOSL2/structs.scad>;
// clang-format on

function get_printer_adjustment(key, printer_adjustments) = is_undef(printer_adjustments) ? 0 : struct_val(printer_adjustments, key, 0.0);