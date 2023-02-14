// clang-format off
// Something needs to be adjusted, at least for FDM 3D printing
// I have two printers that I need to adjust some parts for.
function barrel_hinge_get_printer_adjustments(printer) =
  printer == "bambu" ? [ 
    [ "hole_d", 0.35 ], 
    [ "pin_d", 0.05 ], 
    [ "arm_thickness_positive", 0.0 ], 
    [ "arm_thickness_negative", 0.1 ] ] : 
  printer == "enmingdader" ? [ 
    [ "hole_d", 0.0 ], 
    [ "pin_d", 0.0 ], 
    [ "arm_thickness_positive", 0.0 ], 
    [ "arm_thickness_negative", 0.0 ] ] : 
  undef;
// clang-format on
