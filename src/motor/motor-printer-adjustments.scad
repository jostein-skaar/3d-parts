// clang-format off
// Something needs to be adjusted, at least for FDM 3D printing

// I have two printers that I need to adjust some parts for:
function motor_get_printer_adjustments(printer) =
  printer == "bambu" ? [ 
    [ "shaft_width", 0.14 ], 
    [ "shaft_length", 0.3 ]] : 
  printer == "mingda" ? [ 
  [ "shaft_width", 0.0 ], 
    [ "shaft_length", 0.0 ]] : 
  undef;
// clang-format on
