// clang-format off
include<../../src/barrel-hinge.scad>;
include<barrel-hinge-printer-adjustments.scad>;
// clang-format on

$fn = 64;

printer = "bambu";
part = "preview"; // preview, arm, barrel, pins
barrel_d = 15;
height = 15;
hole_d = 2;
pin_d = hole_d;
arm_thickness = 2;
number_of_arms = 4;
has_flat_side = true;
is_closed = false;

$barrel_hinge_printer_adjustments = barrel_hinge_get_printer_adjustments(printer);

if (part == "arm")
{
  barrel_hinge_arm(arm_thickness = arm_thickness);
}
else if (part == "barrel")
{
  // barrel_hinge(barrel_d = barrel_d, height = height, hole_d = hole_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness,
  //              has_flat_side = has_flat_side, is_closed = is_closed);

  barrel_hinge(barrel_d = barrel_d, height = height, hole_d = hole_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness,
               has_flat_side = has_flat_side, is_closed = is_closed);
}
else if (part == "pins")
{
  barrel_hinge_pins(barrel_d = barrel_d, pin_d = pin_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness, has_flat_side = has_flat_side);
}
else if (part == "preview")
{
  barrel_hinge_arm(arm_thickness = arm_thickness);

  zrot(0) fwd(23.2) left(38) up(39.2) yrot(90) barrel_hinge_arm(arm_thickness = arm_thickness);

  left(barrel_d + 20) barrel_hinge(barrel_d = barrel_d, height = height, hole_d = hole_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness,
                                   has_flat_side = true, is_closed = true);

  left(barrel_d) fwd(barrel_d + 30) barrel_hinge(barrel_d = barrel_d, height = height, hole_d = hole_d, number_of_arms = number_of_arms,
                                                 arm_thickness = arm_thickness, has_flat_side = false, is_closed = false);

  fwd(barrel_d)
    barrel_hinge_pins(barrel_d = barrel_d, pin_d = pin_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness, has_flat_side = has_flat_side);
}
