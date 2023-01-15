// clang-format off
// Getting the parts to match on my printer.
// I have two printers that I need to adjust some parts for.
function barrel_hinge_get_printer_adjustments(printer) =
  printer == "bambu" ? [ 
    [ "hole_d", 0.35 ], 
    [ "pin_d", 0.05 ], 
    [ "arm_thickness_positive", 0.0 ], 
    [ "arm_thickness_negative", 0.1 ] ] : 
  printer == "ender" ? [ 
    [ "hole_d", 0.45 ], 
    [ "pin_d", -0.15 ], 
    [ "arm_thickness_positive", 0.0 ], 
    [ "arm_thickness_negative", 0.1 ] ] : 
  undef;
// clang-format on
