// clang-format off
include<../../src/barrel-hinge.scad>;
// clang-format on

$fn = 64;

printer = "bambu";
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
printer_adjustments_bambu = [ [ "hole_d", 0.4 ], [ "pin_d", 0.05 ], [ "arm_thickness_positive", 0.0 ] , ["arm_thickness_negative", 0.1] ];
printer_adjustments_ender = [ [ "hole_d", 0.45 ], [ "pin_d", 0.0 ], [ "arm_thickness_positive", 0.0 ], ["arm_thickness_negative", 0.1] ];
$printer_adjustments = 
  printer == "bambu" ? printer_adjustments_bambu : 
  printer == "ender" ? printer_adjustments_ender : 
  undef;
// clang-format on

if (part == "arm")
{
  barrel_hinge_arm(arm_thickness = arm_thickness);
}
else if (part == "barrel")
{
  barrel_hinge();
}
else if (part == "pins")
{
  barrel_hinge_pins(barrel_d = barrel_d, pin_d = pin_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness, has_flat_side = has_flat_side);
}
else if (part == "preview")
{
  barrel_hinge_arm(arm_thickness = arm_thickness);

  left(40) barrel_hinge(barrel_d = barrel_d, height = height, hole_d = hole_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness,
                        has_flat_side = true, is_closed = true);

  left(40) fwd(30) barrel_hinge(barrel_d = barrel_d, height = height, hole_d = hole_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness,
                                has_flat_side = false, is_closed = false);

  fwd(20) barrel_hinge_pins(barrel_d = barrel_d, pin_d = pin_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness, has_flat_side = has_flat_side);
}
