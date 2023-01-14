// clang-format off
include<common.scad>;
// clang-format on

// The following can be adjusted for better fit when 3D printing using $printer_adjustments:
// hole_d: To make the hole more narrow or wide (minus makes it more narrow)
// pin_d: To make the pin thinner or thicker (minus makes it thinner)
// arm_thickness_positive: To make the arm thinner or thicker (minus makes it thinner)
// arm_thickness_negative: To make the room for the arm more narrow or wide (minus makes it more narrow)

$fn = 64;

// Default values
barrel_d = 25;
height = 20;
hole_d = 3;
pin_d = hole_d;
arm_thickness = 2;
number_of_arms = 4;
has_flat_side = false;
is_closed = true;

// TODO: Find a way to resize arms and barrel in a way that works for multiple sizes.

module barrel_hinge(barrel_d = barrel_d, height = height, hole_d = hole_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness,
                    has_flat_side = false, is_closed = false)
{
  printer_adjust_arm_thickness_negative = get_printer_adjustment("arm_thickness_negative");
  printer_adjust_hole_d = get_printer_adjustment("hole_d");
  echo("printer_adjust_arm_thickness_negative and printer_adjust_hole_d", printer_adjust_arm_thickness_negative, printer_adjust_hole_d);
  hole_d_adjusted = hole_d + printer_adjust_hole_d;
  arm_thickness_adjusted = arm_thickness + printer_adjust_arm_thickness_negative;

  difference()
  {
    union()
    {
      cyl(d = barrel_d, h = height, anchor = BOT);
      if (has_flat_side)
      {
        fwd(barrel_d / 4) cuboid([ barrel_d, barrel_d / 2, height ], anchor = BOT);
      }
    }

    // Space for arm attachments
    left_arm_position = arm_thickness_adjusted * number_of_arms / 2 - arm_thickness_adjusted / 2;
    arm_margin_front = 4;
    arm_margin_back = 1;
    arm_space = hole_d_adjusted + arm_margin_front + arm_margin_back;

    inset_for_closing_arm_attachments_of_barrel = is_closed ? 1.2 : 0;
    left(left_arm_position) fwd(barrel_d / 4 - inset_for_closing_arm_attachments_of_barrel) up(height - arm_space)
    {
      number_of_holes = number_of_arms / 2;
      for (x = [0:number_of_holes - 1])
      {
        right(x * arm_thickness_adjusted + x * arm_thickness_adjusted) cuboid([ arm_thickness_adjusted, barrel_d / 2, arm_space ], anchor = BOT);
      }
    }

    // This fwd and xrot are just trial and error to make good room for the arm when in closed position
    fwd(2.4) xrot(-7)
    {

      // Space for arms
      extra_room_back = 4;
      space_y = barrel_d - arm_space * 2 + extra_room_back;
      down(5) back(extra_room_back / 2) cuboid([ arm_thickness_adjusted * number_of_arms, space_y, height + 10 ], anchor = BOT);

      // Space for sliding the arms inside the barrel. Adding some wiggle room
      wiggle_room_x = arm_thickness_adjusted * 2;
      wiggle_room_y = 0.2;
      sliding_space_y = hole_d_adjusted + wiggle_room_y;
      extra_room_for_arm_head = 1;
      sliding_space_fwd_position = space_y / 2 - sliding_space_y / 2 - extra_room_back / 2 - extra_room_for_arm_head;
      down(5) fwd(sliding_space_fwd_position) cuboid([ arm_thickness_adjusted * number_of_arms + wiggle_room_x, sliding_space_y, height + 10 ], anchor = BOT);
    }

    // Hole for pin
    up(height - arm_space / 2) fwd(barrel_d / 2 - hole_d_adjusted / 2 - arm_margin_front) xcyl(d = hole_d_adjusted, h = barrel_d);
  }
}

module barrel_hinge_arm(arm_thickness = arm_thickness)
{
  printer_adjust_arm_thickness_positive = get_printer_adjustment("arm_thickness_positive");
  printer_adjust_hole_d = get_printer_adjustment("hole_d");
  echo("printer_adjust_arm_thickness_positive and printer_adjust_hole_d", printer_adjust_arm_thickness_positive, printer_adjust_hole_d);

  hole_d_adjusted = hole_d + printer_adjust_hole_d;
  thickness_adjusted = arm_thickness + printer_adjust_arm_thickness_positive;

  path = [ [ 0, 0 ], [ -10, 0 ], [ -13, 10 ], [ -8, 15 ], [ -8, 22 ], [ 0, 20.1 ] ];
  holes = [ path[0], path[3], path[5] ];

  difference()
  {
    union()
    {
      linear_extrude(height = thickness_adjusted, $fn = 16) stroke(path, width = 3, joints = "dot", joint_width = 1);
      for (hole = holes)
      {
        right(hole[0]) back(hole[1]) _barrel_hinge_arm_hole(arm_thickness);
      }
    }

    for (hole = holes)
    {
      right(hole[0]) back(hole[1]) _barrel_hinge_arm_hole(arm_thickness, is_mask = true);
    }
  }

  module _barrel_hinge_arm_hole(arm_thickness = arm_thickness, is_mask = false)
  {
    hole_wall_width = 1.2;

    if (is_mask)
    {
      cyl(d = hole_d_adjusted, h = thickness_adjusted, anchor = BOT, $fn = 16);
    }
    else
    {
      cyl(d = hole_d_adjusted + hole_wall_width * 2, h = thickness_adjusted, anchor = BOT, $fn = 16);
    }
  }
}

module barrel_hinge_pins(barrel_d = barrel_d, pin_d = pin_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness, has_flat_side = false)
{
  printer_adjust_arm_thickness_positive = get_printer_adjustment("arm_thickness_positive");
  printer_adjust_pin_d = get_printer_adjustment("pin_d");
  echo("printer_adjust_arm_thickness_positive and printer_adjust_pin_d", printer_adjust_arm_thickness_positive, printer_adjust_pin_d);

  arm_thickness_adjusted = arm_thickness + printer_adjust_arm_thickness_positive;

  length_pin_center = arm_thickness_adjusted * number_of_arms + 0.2;
  length_pin_barrel_inside = arm_thickness * number_of_arms + 3;
  length_pin_barrel_outside = has_flat_side ? barrel_d - 0.4 : arm_thickness * number_of_arms + 6;

  pin_d_adjusted = pin_d + printer_adjust_pin_d;

  // One center pin
  xcyl(d = pin_d_adjusted, h = length_pin_center, anchor = BOT);

  // Two inside barrel
  for (offset = [ 5, 10 ])
  {
    fwd(offset)
    {
      xcyl(d = pin_d_adjusted, h = length_pin_barrel_inside, anchor = BOT);
      left(arm_thickness_adjusted / 2) up(pin_d_adjusted / 2) cuboid([ arm_thickness_adjusted, pin_d_adjusted, 2 ], anchor = BOT);
    }
  }

  // Two outside barrel
  for (offset = [ 15, 20 ])
  {
    fwd(offset) xcyl(d = pin_d_adjusted, h = length_pin_barrel_outside, anchor = BOT);
  }
}
