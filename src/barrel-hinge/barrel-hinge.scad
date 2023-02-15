// clang-format off
include<barrel-hinge-lib.scad>;
include<barrel-hinge-printer-adjustments.scad>;
// clang-format on

$fn = 64;

// printer = "mingda";
printer = "bambu";
// printer = "default";
$barrel_hinge_printer_adjustments = barrel_hinge_get_printer_adjustments(printer);
echo("$barrel_hinge_printer_adjustments", printer, $barrel_hinge_printer_adjustments);

part = "preview"; // preview, arm, barrel, pins

// Small
barrel_d = 24;
height = 20;
hole_d = 3;
number_of_arms = 4;
arm_thickness = 2;
arm_width = 3;
arm_hole_wall = 1.2;
extra_margin_front = 2;
extra_arm_length = 0;

// Large
// barrel_d = 55;
// height = 45;
// hole_d = 8;
// number_of_arms = 6;
// arm_thickness = 4;
// arm_width = 6;
// arm_hole_wall = 3;
// extra_margin_front = 3;
// extra_arm_length = 0;

if (part == "barrel")
{
  barrel_hinge(barrel_d = barrel_d, height = height, number_of_arms = number_of_arms, hole_d = hole_d, arm_thickness = arm_thickness, arm_width = arm_width,
               arm_hole_wall = arm_hole_wall, extra_margin_front = extra_margin_front, extra_arm_length = extra_arm_length);
}
else if (part == "arm")
{
  barrel_hinge_arm(hole_d = hole_d, arm_thickness = arm_thickness, arm_width = arm_width, arm_hole_wall = arm_hole_wall,
                   extra_margin_front = extra_margin_front, extra_arm_length = extra_arm_length);
}
else if (part == "pins")
{
  // barrel_hinge(barrel_d = barrel_d, height = height, hole_d = hole_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness,
  //              has_flat_side = has_flat_side, is_closed = is_closed);
  barrel_hinge_pins(hole_d = hole_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness);
}
else if (part == "special")
{
  barrel_hinge_special();
}
else if (part == "preview")
{
  barrel_hinge_arm(hole_d = hole_d, arm_thickness = arm_thickness, arm_width = arm_width, arm_hole_wall = arm_hole_wall,
                   extra_margin_front = extra_margin_front, extra_arm_length = extra_arm_length);

  fwd(40) barrel_hinge(barrel_d = barrel_d, height = height, number_of_arms = number_of_arms, hole_d = hole_d, arm_thickness = arm_thickness,
                       arm_width = arm_width, arm_hole_wall = arm_hole_wall, extra_margin_front = extra_margin_front, extra_arm_length = extra_arm_length);

  back(20) barrel_hinge_pins(hole_d = hole_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness);

  fwd(80) barrel_hinge_special();
}

module barrel_hinge_special()
{
  width = 20;
  length = 25;
  height = 20;

  printer_adjust_hole_d = barrel_hinge_get_printer_adjustment("hole_d");
  hole_d_adjusted = hole_d + printer_adjust_hole_d;

  calculated_barrel_d = barrel_hinge_calculate_barrel_d(hole_d_adjusted, arm_hole_wall, 0, extra_arm_length);
  diff_d = length - calculated_barrel_d;

  calculated_height = barrel_hinge_calculate_barrel_height(hole_d_adjusted, arm_hole_wall, 0, extra_arm_length);
  diff_height = height - calculated_height;

  diff() cuboid([ width, length, height ], anchor = BOT)
  {
    fwd(diff_d / 2) tag("remove") attach(CENTER)
      barrel_hinge_mask(height = height, number_of_arms = number_of_arms, hole_d = hole_d, arm_thickness = arm_thickness, arm_width = arm_width,
                        arm_hole_wall = arm_hole_wall, extra_margin_front = 0, extra_arm_length = extra_arm_length, hole_length = width + 1);
  }
}