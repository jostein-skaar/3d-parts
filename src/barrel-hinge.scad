// clang-format off
include<common.scad>;
include<../examples/barrel-hinge/barrel-hinge-printer-adjustments.scad>;
// clang-format on

// The following can be adjusted for better fit when 3D printing using $barrel_hinge_printer_adjustments:
// hole_d: To make the hole more narrow or wide (minus makes it more narrow)
// pin_d: To make the pin thinner or thicker (minus makes it thinner)
// arm_thickness_positive: To make the arm thinner or thicker (minus makes it thinner)
// arm_thickness_negative: To make the room for the arm more narrow or wide (minus makes it more narrow)

$fn = 64;

printer = "default";

// Parameterized variables
hole_d = 3;
number_of_arms = 4;
arm_thickness = 2;
arm_width = 3;
arm_hole_wall = 1.2;

extra_margin_front = 5;
extra_arm_length = 0;

// More "set" variables
// arm_margin_to_edge = 2; // Must be larger than or equal to arm_hole_wall

// // Default values
// barrel_d = 25;
// height = 25;
// hole_d = 3;
// pin_d = hole_d;
// arm_thickness = 2;

// is_closed = false;

// // Position the arm
// extra_outer_barrel_margin_needed = 0;
// arm_margin_front = 2;
// raise_center_hole = 0;
// arm_width = 2;

$barrel_hinge_printer_adjustments = barrel_hinge_get_printer_adjustments(printer);

// TODO: Find a way to resize arms and barrel in a way that works for multiple sizes.

// barrel_hinge_arm(hole_d = hole_d, arm_thickness = arm_thickness, arm_width = arm_width, arm_hole_wall = arm_hole_wall);

// barrel_hinge_mask(number_of_arms = number_of_arms, hole_d = hole_d, arm_thickness = arm_thickness, arm_width = arm_width, arm_hole_wall = arm_hole_wall,
//                   anchor = BOT);
// right(30) barrel_hinge_mask(number_of_arms = number_of_arms, hole_d = hole_d, arm_thickness = arm_thickness, arm_width = arm_width,
//                             arm_hole_wall = arm_hole_wall, anchor = TOP);

// left(50) barrel_hinge(number_of_arms = number_of_arms, hole_d = hole_d, arm_thickness = arm_thickness, arm_width = arm_width, arm_hole_wall = arm_hole_wall);

// zrot(0) fwd(23.2) left(38) up(39.2) yrot(90) barrel_hinge_arm(arm_thickness = arm_thickness);

// left(barrel_d) fwd(barrel_d + 30)
//   barrel_hinge(barrel_d = barrel_d, height = height, hole_d = hole_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness, is_closed = false);

// fwd(barrel_d) barrel_hinge_pins(barrel_d = barrel_d, pin_d = pin_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness);

// clang-format off
function barrel_hinge_get_printer_adjustment(key) = 
  get_printer_adjustment(key, $barrel_hinge_printer_adjustments);

function barrel_hinge_calculate_barrel_d(hole_d_adjusted, arm_hole_wall) = 
  barrel_hinge_calculate_space(hole_d_adjusted, arm_hole_wall) 
  + barrel_hinge_calculate_arm_space(hole_d_adjusted, arm_hole_wall);

// TODO: This needs a drawing :S
function barrel_hinge_calculate_barrel_height(hole_d_adjusted, arm_hole_wall) = 
  sqrt(barrel_hinge_calculate_left_part_of_arm_length(hole_d_adjusted, arm_hole_wall)^2 
  + barrel_hinge_calculate_right_part_of_arm_length(hole_d_adjusted, arm_hole_wall)^2)
  + barrel_hinge_calculate_arm_hole_including_wall_d(hole_d_adjusted, arm_hole_wall)/2;

function barrel_hinge_calculate_arm_space(hole_d_adjusted, arm_hole_wall) = 
  hole_d_adjusted + arm_hole_wall * 2 + extra_margin_front;

function barrel_hinge_calculate_arm_space_height(hole_d_adjusted, arm_hole_wall) = 
  hole_d_adjusted + arm_hole_wall * 2 + extra_margin_front;

function barrel_hinge_calculate_space(hole_d_adjusted, arm_hole_wall) = 
  barrel_hinge_calculate_left_part_of_arm_length(hole_d_adjusted, arm_hole_wall);

function barrel_hinge_calculate_arm_hole_including_wall_d(hole_d_adjusted, arm_hole_wall) = 
  hole_d_adjusted + arm_hole_wall * 2;

function barrel_hinge_calculate_right_part_of_arm_length(hole_d_adjusted, arm_hole_wall) = 
  hole_d_adjusted / 2 + arm_hole_wall 
  + barrel_hinge_calculate_arm_hole_including_wall_d(hole_d_adjusted, arm_hole_wall) / 2
  +extra_margin_front;

function barrel_hinge_calculate_left_part_of_arm_length(hole_d_adjusted, arm_hole_wall) = 
  barrel_hinge_calculate_right_part_of_arm_length(hole_d_adjusted, arm_hole_wall) 
  + barrel_hinge_calculate_arm_hole_including_wall_d(hole_d_adjusted, arm_hole_wall);
// clang-format on

module barrel_hinge(barrel_d = undef, height = undef, number_of_arms = number_of_arms, hole_d = hole_d, arm_thickness = arm_thickness, arm_width = arm_width,
                    arm_hole_wall = arm_hole_wall)
{
  printer_adjust_hole_d = barrel_hinge_get_printer_adjustment("hole_d");
  hole_d_adjusted = hole_d + printer_adjust_hole_d;

  calculated_barrel_d = barrel_hinge_calculate_barrel_d(hole_d_adjusted, arm_hole_wall);
  echo("calculated_barrel_d", calculated_barrel_d);
  wanted_barrel_d = is_def(barrel_d) ? barrel_d : calculated_barrel_d;
  diff_d = wanted_barrel_d - calculated_barrel_d;

  calculated_height = barrel_hinge_calculate_barrel_height(hole_d_adjusted, arm_hole_wall);
  echo("calculated_height", calculated_height);
  wanted_height = is_def(height) ? height : calculated_height;
  diff_height = wanted_height - calculated_height;

  down(diff_height) diff() cyl(d = wanted_barrel_d, h = wanted_height, anchor = BOT)
  {
    fwd(diff_d / 2) tag("remove") attach(CENTER) barrel_hinge_mask(height = height, number_of_arms = number_of_arms, hole_d = hole_d,
                                                                   arm_thickness = arm_thickness, arm_width = arm_width, arm_hole_wall = arm_hole_wall);
  }
}

module barrel_hinge_mask(height = undef, number_of_arms = number_of_arms, hole_d = hole_d, arm_thickness = arm_thickness, arm_width = arm_width,
                         arm_hole_wall = arm_hole_wall, anchor = CENTER, spin = 0, orient = UP)
{
  printer_adjust_arm_thickness_negative = barrel_hinge_get_printer_adjustment("arm_thickness_negative");
  printer_adjust_hole_d = barrel_hinge_get_printer_adjustment("hole_d");
  echo("barrel_hinge_mask: printer_adjust_arm_thickness_negative and printer_adjust_hole_d", printer_adjust_arm_thickness_negative, printer_adjust_hole_d);
  hole_d_adjusted = hole_d + printer_adjust_hole_d;
  arm_thickness_adjusted = arm_thickness + printer_adjust_arm_thickness_negative;

  calculated_height = barrel_hinge_calculate_barrel_height(hole_d_adjusted, arm_hole_wall);
  wanted_height = is_def(height) ? height : calculated_height;
  diff_height = wanted_height - calculated_height;

  space_width = arm_thickness_adjusted * number_of_arms;
  space_length = barrel_hinge_calculate_space(hole_d_adjusted, arm_hole_wall);
  space_height = wanted_height;
  hole_length = 30;

  slider_space_width = space_width + arm_thickness_adjusted * 2 + 0.2;
  slider_space_length = hole_d_adjusted + 0.2;

  arms_space_length = barrel_hinge_calculate_arm_space(hole_d_adjusted, arm_hole_wall);
  arms_space_height = barrel_hinge_calculate_arm_space_height(hole_d_adjusted, arm_hole_wall);

  left_arm_position = arm_thickness_adjusted * number_of_arms / 2 - arm_thickness_adjusted / 2;

  // This is perfect for opened position, but not for closed
  slider_position_all_the_way_in_front = space_length / 2 - slider_space_length / 2 - arm_hole_wall;
  // Don't really know what this should be. It seems to be about 1.2 mm, so using arm_hole_wall for now.
  extra_fwd_to_make_it_close_properly = arm_hole_wall - 0.2;
  slider_fwd_position = slider_position_all_the_way_in_front - extra_fwd_to_make_it_close_properly;

  echo("space_length + arms_space_length", space_length, arms_space_length);

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ space_width, space_length + arms_space_length, space_height ])
  {
    fwd(space_length / 2) back((space_length + arms_space_length) / 2) union()
    {
      cuboid([ space_width, space_length, space_height ]);

      fwd(slider_position_all_the_way_in_front) up(space_height / 2 - 6 / 2) cuboid([ slider_space_width, slider_space_length, 6 ]);
      fwd(slider_fwd_position) cuboid([ slider_space_width, slider_space_length, space_height ]);
      fwd(slider_fwd_position - extra_margin_front) cuboid([ slider_space_width, slider_space_length, space_height ]);

      up(space_height / 2 - arms_space_height / 2) fwd(space_length / 2 + arms_space_length / 2)
      {
        left(left_arm_position)
        {
          number_of_holes = number_of_arms / 2;
          for (x = [0:number_of_holes - 1])
          {
            right(x * arm_thickness_adjusted + x * arm_thickness_adjusted) cuboid([ arm_thickness_adjusted, arms_space_length, arms_space_height ]);
          }
        }
      }
#up(space_height / 2 - arms_space_height + hole_d_adjusted / 2 + arm_hole_wall)
      fwd(space_length / 2 + arms_space_length - hole_d_adjusted / 2 - arm_hole_wall - extra_margin_front) xcyl(d = hole_d_adjusted, h = hole_length);
#up(space_height / 2 - arms_space_height + hole_d_adjusted / 2 + arm_hole_wall)
      fwd(space_length / 2 + arms_space_length - hole_d_adjusted / 2 - arm_hole_wall) xcyl(d = hole_d_adjusted, h = hole_length);
    }

    children();
  }
}

module barrel_hinge_old(barrel_d = barrel_d, height = height, hole_d = hole_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness,
                        is_closed = false)
{
  printer_adjust_arm_thickness_negative = barrel_hinge_get_printer_adjustment("arm_thickness_negative");
  printer_adjust_hole_d = barrel_hinge_get_printer_adjustment("hole_d");
  echo("printer_adjust_arm_thickness_negative and printer_adjust_hole_d", printer_adjust_arm_thickness_negative, printer_adjust_hole_d);
  hole_d_adjusted = hole_d + printer_adjust_hole_d;
  arm_thickness_adjusted = arm_thickness + printer_adjust_arm_thickness_negative;

  difference()
  {
    cyl(d = barrel_d, h = height, anchor = BOT);

    // Space for arm attachments
    left_arm_position = arm_thickness_adjusted * number_of_arms / 2 - arm_thickness_adjusted / 2;
    arm_margin_back = 1;
    arm_space_y = hole_d_adjusted + arm_margin_front + arm_margin_back;
    // We add 1 for some extra room
    hole_wall_width = 1.2;
    arm_space_z = hole_d_adjusted + arm_margin_front + extra_outer_barrel_margin_needed + hole_wall_width + 1;

    inset_for_closing_arm_attachments_of_barrel = is_closed ? 2 : 0;
    left(left_arm_position) fwd(barrel_d / 4 - inset_for_closing_arm_attachments_of_barrel) up(height - arm_space_z)
    {
      number_of_holes = number_of_arms / 2;
      for (x = [0:number_of_holes - 1])
      {
        right(x * arm_thickness_adjusted + x * arm_thickness_adjusted) cuboid([ arm_thickness_adjusted, barrel_d / 2, arm_space_z + 5 ], anchor = BOT);
      }
    }

    // Space for arms and sliding them inside the barrel
    // fwd(2.4) xrot(-7)
    space_margin_back = 2;
    back(arm_space_y / 2 - space_margin_back / 2)
    {
      space_y = barrel_d - arm_space_y - space_margin_back;
#down(0) back(0) cuboid([ arm_thickness_adjusted * number_of_arms, space_y, height ], anchor = BOT);

      // Space for sliding the arms, including some wiggle room
      wiggle_room_x = arm_thickness_adjusted * 2;
      wiggle_room_y = 0.2;
      sliding_space_y = hole_d_adjusted + wiggle_room_y;
      extra_room_for_arm_head = 1;
      sliding_space_fwd_position = space_y / 2 - sliding_space_y / 2 - extra_room_for_arm_head;
      sliding_space_fwd_position2 = arm_space_y / 2 - space_margin_back / 2;
      sliding_space_fwd_position3 = sliding_space_fwd_position2 - 5;
      sliding_space_fwd_position4 = sliding_space_fwd_position2 - 10;
      echo("sliding_space_fwd_position", sliding_space_fwd_position);
      // #down(3) fwd(sliding_space_fwd_position) cuboid([ arm_thickness_adjusted * number_of_arms + wiggle_room_x, sliding_space_y, height + 5 ], anchor =
      // BOT); #down(5) fwd(sliding_space_fwd_position2)
      //       cuboid([ arm_thickness_adjusted * number_of_arms + wiggle_room_x, sliding_space_y, height + 10 ], anchor = BOT);
      // #xrot(-15) down(5) fwd(sliding_space_fwd_position2 + 5)
      // #fwd(sliding_space_fwd_position2 - raise_center_hole / 2)
      fwd(sliding_space_fwd_position2) cuboid([ arm_thickness_adjusted * number_of_arms + wiggle_room_x, sliding_space_y, height + 5 ], anchor = BOT);
      // #down(0) fwd(sliding_space_fwd_position3) cuboid([ arm_thickness_adjusted * number_of_arms + wiggle_room_x, sliding_space_y, height ], anchor = BOT);
      // #down(0) fwd(sliding_space_fwd_position4) cuboid([ arm_thickness_adjusted * number_of_arms + wiggle_room_x, sliding_space_y, height ], anchor = BOT);
    }

// Hole for pin
// up(height - arm_space_y / 2) fwd(barrel_d / 2 - hole_d_adjusted / 2 - arm_margin_front) xcyl(d = hole_d_adjusted, h = barrel_d);
#up(height - hole_d_adjusted / 2 - arm_margin_front - extra_outer_barrel_margin_needed) fwd(barrel_d / 2 - hole_d_adjusted / 2 - arm_margin_front)
    xcyl(d = hole_d_adjusted, h = barrel_d + 20);

    // #up(height - hole_d_adjusted / 2 - arm_margin_front) fwd(barrel_d / 2 - hole_d_adjusted / 2 - arm_margin_front)
    //     xcyl(d = hole_d_adjusted, h = barrel_d + 10);
  }
}

module barrel_hinge_arm(hole_d = hole_d, arm_thickness = arm_thickness, arm_width = arm_width, arm_hole_wall = arm_hole_wall)
{
  printer_adjust_arm_thickness_positive = barrel_hinge_get_printer_adjustment("arm_thickness_positive");
  printer_adjust_hole_d = barrel_hinge_get_printer_adjustment("hole_d");
  echo("barrel_hinge_arm: printer_adjust_arm_thickness_positive and printer_adjust_hole_d", printer_adjust_arm_thickness_positive, printer_adjust_hole_d);

  hole_d_adjusted = hole_d + printer_adjust_hole_d;
  thickness_adjusted = arm_thickness + printer_adjust_arm_thickness_positive;

  d_of_arm_hole_including_wall = hole_d_adjusted + arm_hole_wall * 2;

  least_length_needed_left_part = barrel_hinge_calculate_left_part_of_arm_length(hole_d_adjusted, arm_hole_wall);
  least_length_needed_right_part = barrel_hinge_calculate_right_part_of_arm_length(hole_d_adjusted, arm_hole_wall);

  center_point_height = least_length_needed_right_part;
  left_point_x = -least_length_needed_left_part;
  right_point_x = least_length_needed_right_part;

  path = [[left_point_x, -center_point_height], [left_point_x, 0], [0, 0], [right_point_x, 0], [right_point_x, -center_point_height]];
  holes = [ path[0], path[2], path[4] ];

  difference()
  {
    union()
    {
      path_extrude2d(path, $fn = 16) { square([ arm_width, thickness_adjusted ], anchor = BOT); }
      // linear_extrude(height = thickness_adjusted, $fn = 16) stroke(path, width = arm_width, joints = "dot", joint_width = 1);
      for (hole = holes)
      {
        right(hole[0]) back(hole[1]) arm_hole(arm_thickness);
      }
    }

    for (hole = holes)
    {
      right(hole[0]) back(hole[1]) arm_hole(arm_thickness, is_mask = true);
    }
  }

  module arm_hole(arm_thickness = arm_thickness, is_mask = false)
  {
    if (is_mask)
    {
      cyl(d = hole_d_adjusted, h = thickness_adjusted, anchor = BOT, $fn = 16);
    }
    else
    {
      cyl(d = hole_d_adjusted + arm_hole_wall * 2, h = thickness_adjusted, anchor = BOT, $fn = 16);
    }
  }
}

module barrel_hinge_pins(barrel_d = barrel_d, pin_d = pin_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness)
{
  printer_adjust_arm_thickness_positive = barrel_hinge_get_printer_adjustment("arm_thickness_positive");
  printer_adjust_pin_d = barrel_hinge_get_printer_adjustment("pin_d");
  echo("printer_adjust_arm_thickness_positive and printer_adjust_pin_d", printer_adjust_arm_thickness_positive, printer_adjust_pin_d);

  arm_thickness_adjusted = arm_thickness + printer_adjust_arm_thickness_positive;

  length_pin_center = arm_thickness_adjusted * number_of_arms + 0.2;
  length_pin_barrel_inside = arm_thickness * number_of_arms + 3.2;
  length_pin_barrel_outside = arm_thickness * number_of_arms + 6;

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
