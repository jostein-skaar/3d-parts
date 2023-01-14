// clang-format off
include<../../src/barrel-hinge.scad>;
// clang-format on

$fn = 64;

printer = "default";
part = "preview"; // preview, arm, barrel, pins
barrel_d = 25;
height = 20;
hole_d = 3;
pin_d = hole_d;
arm_thickness = 2;
number_of_arms = 4;
has_flat_side = false;
is_closed = true;

// clang-format off
// Getting the parts to match on my printer.
// I have two printers that I need to adjust some parts for.
printer_adjustments_bambu = [ [ "pin_d", -0.3 ], [ "arm_thickness", -0.2 ] ];
printer_adjustments_ender = [ [ "pin_d", -0.6 ], [ "arm_thickness", -0.2 ] ];
$printer_adjustments = 
  printer == "bambu" ? printer_adjustments_bambu : 
  printer == "ender" ? printer_adjustments_ender : 
  undef;
// clang-format on

if (part == "arm")
{
  arm(arm_thickness = arm_thickness);
}
else if (part == "barrel")
{
  barrel();
}
else if (part == "pins")
{
  pins(barrel_d = barrel_d, pin_d = pin_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness, has_flat_side = has_flat_side);
}
else if (part == "preview")
{
  arm(arm_thickness = arm_thickness);

  left(40) barrel(barrel_d = barrel_d, height = height, hole_d = hole_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness, has_flat_side = true,
                  is_closed = true);

  left(40) fwd(30) barrel(barrel_d = barrel_d, height = height, hole_d = hole_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness,
                          has_flat_side = false, is_closed = false);

  fwd(20) pins(barrel_d = barrel_d, pin_d = pin_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness, has_flat_side = has_flat_side);
}
