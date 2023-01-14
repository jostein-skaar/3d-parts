// clang-format off
include<BOSL2/std.scad>;
include<BOSL2/structs.scad>;
// clang-format on

// $printer_adjustments is a list with key value pairs, like this:
// $printer_adjustments = [ [ "key1", -0.3 ], [ "key2", -0.2 ], [ "key3", 0.05 ] ];
function get_printer_adjustment(key) = is_undef($printer_adjustments) ? 0 : struct_val($printer_adjustments, key, 0.0);