// clang-format off
include<common.scad>;
// clang-format on

// The following can be adjusted for better fit when 3D printing using $barrel_hinge_printer_adjustments:
// hole_d: To make the hole more narrow or wide (minus makes it more narrow)
// pin_d: To make the pin thinner or thicker (minus makes it thinner)
// arm_thickness_positive: To make the arm thinner or thicker (minus makes it thinner)
// arm_thickness_negative: To make the room for the arm more narrow or wide (minus makes it more narrow)

$fn = 64;

// Default values
barrel_d = 25;
height = 25;
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
  printer_adjust_arm_thickness_negative = barrel_hinge_get_printer_adjustment("arm_thickness_negative");
  printer_adjust_hole_d = barrel_hinge_get_printer_adjustment("hole_d");
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
    arm_space_y = hole_d_adjusted + arm_margin_front + arm_margin_back;

    inset_for_closing_arm_attachments_of_barrel = is_closed ? 2 : 0;
    left(left_arm_position) fwd(barrel_d / 4 - inset_for_closing_arm_attachments_of_barrel) up(height - arm_space_y)
    {
      number_of_holes = number_of_arms / 2;
      for (x = [0:number_of_holes - 1])
      {
        right(x * arm_thickness_adjusted + x * arm_thickness_adjusted) cuboid([ arm_thickness_adjusted, barrel_d / 2, arm_space_y ], anchor = BOT);
      }
    }

    // Spave for arms and sliding them inside the barrel
    // fwd(2.4) xrot(-7)
    space_margin_back = 2;
    back(arm_space_y / 2 - space_margin_back / 2)
    {
      space_y = barrel_d - arm_space_y - space_margin_back;
      down(0) back(0) cuboid([ arm_thickness_adjusted * number_of_arms, space_y, height + 5 ], anchor = BOT);

      // Space for sliding the arms, including some wiggle room
      wiggle_room_x = arm_thickness_adjusted * 2;
      wiggle_room_y = 0.2;
      sliding_space_y = hole_d_adjusted + wiggle_room_y;
      extra_room_for_arm_head = 1;
      sliding_space_fwd_position = space_y / 2 - sliding_space_y / 2 - extra_room_for_arm_head;
      down(0) fwd(sliding_space_fwd_position) cuboid([ arm_thickness_adjusted * number_of_arms + wiggle_room_x, sliding_space_y, height ], anchor = BOT);
    }

    // Hole for pin
    up(height - arm_space_y / 2) fwd(barrel_d / 2 - hole_d_adjusted / 2 - arm_margin_front) xcyl(d = hole_d_adjusted, h = barrel_d);
  }
}

module barrel_hinge_arm(arm_thickness = arm_thickness)
{
  printer_adjust_arm_thickness_positive = barrel_hinge_get_printer_adjustment("arm_thickness_positive");
  printer_adjust_hole_d = barrel_hinge_get_printer_adjustment("hole_d");
  echo("printer_adjust_arm_thickness_positive and printer_adjust_hole_d", printer_adjust_arm_thickness_positive, printer_adjust_hole_d);

  hole_d_adjusted = hole_d + printer_adjust_hole_d;
  thickness_adjusted = arm_thickness + printer_adjust_arm_thickness_positive;
  // The number is 25, so trying to just use 2.5 (1/10th):
  //          0             1               2           3             4
  path = [ [ 0, 0 ], [ -10.0, 2.5 ], [ -10, 15 ], [ -10, 20 ], [ -2.5, 22.5 ] ];
  holes = [ path[0], path[2], path[4] ];

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
  printer_adjust_arm_thickness_positive = barrel_hinge_get_printer_adjustment("arm_thickness_positive");
  printer_adjust_pin_d = barrel_hinge_get_printer_adjustment("pin_d");
  echo("printer_adjust_arm_thickness_positive and printer_adjust_pin_d", printer_adjust_arm_thickness_positive, printer_adjust_pin_d);

  arm_thickness_adjusted = arm_thickness + printer_adjust_arm_thickness_positive;

  length_pin_center = arm_thickness_adjusted * number_of_arms + 0.2;
  length_pin_barrel_inside = arm_thickness * number_of_arms + 3.2;
  length_pin_barrel_outside = has_flat_side ? barrel_d - 0.4 : arm_thickness * number_of_arms + 6;

  pin_d_adjusted = pin_d + printer_adjust_pin_d;

  // One center pin
  xcyl(d = pin_d_adjusted, h = length_pin_center, anchor = BOT);

  // Two pins inside barrel
  for (offset = [ 5, 10 ])
  {
    fwd(offset)
    {
      xcyl(d = pin_d_adjusted, h = length_pin_barrel_inside, anchor = BOT);
      left(arm_thickness_adjusted / 2) up(pin_d_adjusted / 2) cuboid([ arm_thickness_adjusted, pin_d_adjusted, 2 ], anchor = BOT);
    }
  }

  // Two pins outside barrel
  for (offset = [ 15, 20 ])
  {
    fwd(offset) xcyl(d = pin_d_adjusted, h = length_pin_barrel_outside, anchor = BOT);
  }
}

function barrel_hinge_get_printer_adjustment(key) = get_printer_adjustment(key, $barrel_hinge_printer_adjustments);