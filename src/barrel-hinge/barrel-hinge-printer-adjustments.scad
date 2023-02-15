// clang-format off
// Something needs to be adjusted, at least for FDM 3D printing

// The following can be adjusted for better fit when 3D printing using $barrel_hinge_printer_adjustments:
// hole_d: To make the hole more narrow or wide (minus makes it more narrow)
// pin_d: To make the pin thinner or thicker (minus makes it thinner)
// arm_thickness_positive: To make the arm thinner or thicker (minus makes it thinner)
// arm_thickness_negative: To make the room for the arm more narrow or wide (minus makes it more narrow)

// I have two printers that I need to adjust some parts for:
function barrel_hinge_get_printer_adjustments(printer) =
  printer == "bambu" ? [ 
    [ "hole_d", 0.35 ], 
    [ "pin_d", 0.05 ], 
    [ "arm_thickness_positive", 0.0 ], 
    [ "arm_thickness_negative", 0.1 ] ] : 
  printer == "mingda" ? [ 
    [ "hole_d", 0.3 ], 
    [ "pin_d", 0.0 ], 
    [ "arm_thickness_positive", 0.0 ], 
    [ "arm_thickness_negative", 0.0 ] ] : 
  undef;
// clang-format on
