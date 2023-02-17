// clang-format off
include<../common.scad>;
// clang-format on

$fn = 64;
extra_size_for_better_remove = 0.001;

// Modules:
// barrel_hinge
// barrel_hinge_arm
// barrel_hinge_pins: All the pins needed
// barrel_hinge_mask: can be used to make a barrel hinge other places

module barrel_hinge(barrel_d, height, number_of_arms, hole_d, arm_thickness, arm_width, arm_hole_wall, extra_margin_front, extra_arm_length)
{
  printer_adjust_hole_d = barrel_hinge_get_printer_adjustment("hole_d");
  hole_d_adjusted = hole_d + printer_adjust_hole_d;

  calculated_barrel_d = barrel_hinge_calculate_barrel_d(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length);
  echo("calculated_barrel_d", calculated_barrel_d);
  assert(barrel_d > calculated_barrel_d, str("barrel_d must be larger than calculated_barrel_d: ", calculated_barrel_d));
  diff_d = barrel_d - calculated_barrel_d;

  calculated_height = barrel_hinge_calculate_barrel_height(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length);
  echo("calculated_height", calculated_height);
  assert(height > calculated_height, str("height must be larger than calculated_height: ", calculated_height));
  diff_height = height - calculated_height;

  diff() cyl(d = barrel_d, h = height, anchor = BOT)
  {
    fwd(diff_d / 2) tag("remove") attach(CENTER)
      barrel_hinge_mask(height = height, number_of_arms = number_of_arms, hole_d = hole_d, arm_thickness = arm_thickness, arm_width = arm_width,
                        arm_hole_wall = arm_hole_wall, extra_margin_front = extra_margin_front, extra_arm_length = extra_arm_length, hole_length = barrel_d);
  }
}

module barrel_hinge_mask(height, number_of_arms, hole_d, arm_thickness, arm_width, arm_hole_wall, extra_margin_front, extra_arm_length, hole_length = 50,
                         anchor = CENTER, spin = 0, orient = UP)
{
  printer_adjust_arm_thickness_negative = barrel_hinge_get_printer_adjustment("arm_thickness_negative");
  printer_adjust_hole_d = barrel_hinge_get_printer_adjustment("hole_d");
  echo("barrel_hinge_mask: printer_adjust_arm_thickness_negative and printer_adjust_hole_d", printer_adjust_arm_thickness_negative, printer_adjust_hole_d);
  hole_d_adjusted = hole_d + printer_adjust_hole_d;
  arm_thickness_adjusted = arm_thickness + printer_adjust_arm_thickness_negative;

  calculated_height = barrel_hinge_calculate_barrel_height(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length);
  wanted_height = is_def(height) ? height : calculated_height;
  diff_height = wanted_height - calculated_height;

  space_width = arm_thickness_adjusted * number_of_arms;
  space_length = barrel_hinge_calculate_space(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length);
  space_height = wanted_height;

  slider_wiggle_room_width = 0.2;
  slider_wiggle_room_length = 0.0;
  slider_space_width = space_width + arm_thickness_adjusted * 2 + slider_wiggle_room_width;
  slider_space_length = hole_d_adjusted + slider_wiggle_room_length;

  arms_space_length = barrel_hinge_calculate_arm_space(hole_d_adjusted, arm_hole_wall, extra_margin_front);
  arms_space_height = barrel_hinge_calculate_arm_space_height(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length);

  left_arm_position = arm_thickness_adjusted * number_of_arms / 2 - arm_thickness_adjusted / 2;

  relative_position_hole_for_pin = space_length / 2 + arms_space_length - hole_d_adjusted / 2 - arm_hole_wall - extra_margin_front;
  arm_left_part = barrel_hinge_calculate_left_part_of_arm_length(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length);
  arm_right_part = barrel_hinge_calculate_right_part_of_arm_length(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length);
  diff_left_to_right = arm_left_part - arm_right_part;
  slider_position_top = relative_position_hole_for_pin - diff_left_to_right;
  // This seems to work for multiple sizes
  slider_position_bottom = slider_position_top - arm_width / 2;

  attachable(anchor = anchor, spin = spin, orient = orient, size = [ space_width, space_length + arms_space_length, space_height ])
  {
    fwd(space_length / 2) back((space_length + arms_space_length) / 2) union()
    {
      // Space for arms
      cuboid([ space_width, space_length, space_height + extra_size_for_better_remove * 2 ]);

      // Sliding space
      hull()
      {
        fwd(slider_position_top) up(space_height / 2) cuboid([ slider_space_width, slider_space_length, extra_size_for_better_remove * 2 ]);
        fwd(slider_position_bottom) down(space_height / 2) cuboid([ slider_space_width, slider_space_length, extra_size_for_better_remove * 2 ]);
      }

      // Slots for arms
      up(space_height / 2 - arms_space_height / 2) fwd(space_length / 2 + arms_space_length / 2)
      {
        left(left_arm_position)
        {
          number_of_holes = number_of_arms / 2;
          for (x = [0:number_of_holes - 1])
          {
            up(extra_size_for_better_remove / 2) right(x * arm_thickness_adjusted + x * arm_thickness_adjusted)
              cuboid([ arm_thickness_adjusted, arms_space_length + extra_size_for_better_remove * 2, arms_space_height + extra_size_for_better_remove ]);
          }
        }
      }

      // Hole for pin
      up(space_height / 2 - arms_space_height + hole_d_adjusted / 2 + arm_hole_wall)
        fwd(space_length / 2 + arms_space_length - hole_d_adjusted / 2 - arm_hole_wall - extra_margin_front) xcyl(d = hole_d_adjusted, h = hole_length);
    }

    children();
  }
}

module barrel_hinge_arm(hole_d, arm_thickness, arm_width, arm_hole_wall, extra_margin_front, extra_arm_length)
{
  printer_adjust_arm_thickness_positive = barrel_hinge_get_printer_adjustment("arm_thickness_positive");
  printer_adjust_hole_d = barrel_hinge_get_printer_adjustment("hole_d");
  echo("barrel_hinge_arm: printer_adjust_arm_thickness_positive and printer_adjust_hole_d", printer_adjust_arm_thickness_positive, printer_adjust_hole_d);

  hole_d_adjusted = hole_d + printer_adjust_hole_d;
  thickness_adjusted = arm_thickness + printer_adjust_arm_thickness_positive;

  d_of_arm_hole_including_wall = hole_d_adjusted + arm_hole_wall * 2;

  least_length_needed_left_part = barrel_hinge_calculate_left_part_of_arm_length(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length);
  least_length_needed_right_part = barrel_hinge_calculate_right_part_of_arm_length(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length);

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
      down(extra_size_for_better_remove) cyl(d = hole_d_adjusted, h = thickness_adjusted + extra_size_for_better_remove * 2, anchor = BOT, $fn = 16);
    }
    else
    {
      cyl(d = hole_d_adjusted + arm_hole_wall * 2, h = thickness_adjusted, anchor = BOT, $fn = 16);
    }
  }
}

module barrel_hinge_pins(hole_d, number_of_arms, arm_thickness)
{
  printer_adjust_arm_thickness_positive = barrel_hinge_get_printer_adjustment("arm_thickness_positive");
  printer_adjust_pin_d = barrel_hinge_get_printer_adjustment("pin_d");
  echo("printer_adjust_arm_thickness_positive and printer_adjust_pin_d", printer_adjust_arm_thickness_positive, printer_adjust_pin_d);

  arm_thickness_adjusted = arm_thickness + printer_adjust_arm_thickness_positive;

  length_pin_center = arm_thickness_adjusted * number_of_arms + 0.2;
  length_pin_barrel_inside = arm_thickness * number_of_arms + 3.2;
  length_pin_barrel_outside = arm_thickness * number_of_arms + 6;

  pin_d_adjusted = hole_d + printer_adjust_pin_d;

  // One center pin
  xcyl(d = pin_d_adjusted, h = length_pin_center, anchor = BOT);

  // Two pins inside barrel
  for (offset = [ 2 * pin_d_adjusted, 4 * pin_d_adjusted ])
  {
    back(offset)
    {
      xcyl(d = pin_d_adjusted, h = length_pin_barrel_inside, anchor = BOT);
      if (number_of_arms == 4)
      {
        // It is very practical to have a "stopper" when the arm count is 4
        left(arm_thickness_adjusted / 2) up(pin_d_adjusted / 2) cuboid([ arm_thickness_adjusted, pin_d_adjusted, pin_d_adjusted / 2 ], anchor = BOT);
      }
    }
  }

  // Two pins outside barrel
  for (offset = [ 6 * pin_d_adjusted, 8 * pin_d_adjusted ])
  {
    back(offset) xcyl(d = pin_d_adjusted, h = length_pin_barrel_outside, anchor = BOT);
  }
}

// clang-format off
function barrel_hinge_get_printer_adjustment(key) = 
  get_printer_adjustment(key, $barrel_hinge_printer_adjustments);

function barrel_hinge_calculate_barrel_d(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length) = 
  barrel_hinge_calculate_space(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length) 
  + barrel_hinge_calculate_arm_space(hole_d_adjusted, arm_hole_wall, extra_margin_front);

// TODO: This needs a drawing :S
function barrel_hinge_calculate_barrel_height(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length) = 
  sqrt(barrel_hinge_calculate_left_part_of_arm_length(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length)^2 
  + barrel_hinge_calculate_right_part_of_arm_length(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length)^2)
  + barrel_hinge_calculate_arm_hole_including_wall_d(hole_d_adjusted, arm_hole_wall)/2;

function barrel_hinge_calculate_arm_space(hole_d_adjusted, arm_hole_wall, extra_margin_front) = 
  hole_d_adjusted + arm_hole_wall * 2 + extra_margin_front;

function barrel_hinge_calculate_arm_space_height(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length) = 
  hole_d_adjusted + arm_hole_wall * 2 + extra_margin_front + extra_arm_length;

function barrel_hinge_calculate_space(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length) = 
  barrel_hinge_calculate_left_part_of_arm_length(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length);

function barrel_hinge_calculate_arm_hole_including_wall_d(hole_d_adjusted, arm_hole_wall) = 
  hole_d_adjusted + arm_hole_wall * 2;

function barrel_hinge_calculate_right_part_of_arm_length(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length) = 
  hole_d_adjusted / 2 + arm_hole_wall 
  + barrel_hinge_calculate_arm_hole_including_wall_d(hole_d_adjusted, arm_hole_wall) / 2
  + extra_margin_front + extra_arm_length;

function barrel_hinge_calculate_left_part_of_arm_length(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length) = 
  barrel_hinge_calculate_right_part_of_arm_length(hole_d_adjusted, arm_hole_wall, extra_margin_front, extra_arm_length) 
  + barrel_hinge_calculate_arm_hole_including_wall_d(hole_d_adjusted, arm_hole_wall);
// clang-format on