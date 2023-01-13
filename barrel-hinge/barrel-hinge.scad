include<BOSL2\std.scad>;
include<BOSL2\structs.scad>;

$fn = 64;
printer = "default";
part = "preview"; // preview, arm, barrel, pins
barrel_d = 25;
height = 20;
hole_d = 3;
pin_d = hole_d;
arm_svg = "barrel-hinge-arm-25.svg";
arm_thickness = 2.0;
number_of_arms = 4;
has_flat_side = false;
is_closed = true;

// TODO: Find a way to resize arms and barrel in a way that works.

// Getting the parts to match on your printer (calibrating flow etc may also help).
// I have two printers that I need to adjust some parts for.
// Setting printer to bambu og ender gets the corresponding values. 0.0 is used as default.
PRINTER_ADJUSTMENTS_PIN_D = [ [ "bambu", -0.3 ], [ "ender", -0.5 ] ];
PRINTER_ADJUSTMENTS_ARM_THICKNESS = [ [ "bambu", -0.2 ], [ "ender", -0.2 ] ];
PRINTER_ADJUSTMENTS = [ [ "pin_d", PRINTER_ADJUSTMENTS_PIN_D ], [ "arm_thickness", PRINTER_ADJUSTMENTS_ARM_THICKNESS ] ];
function ADJUSTMENTS_FOR_PRINTER(key, printer, default_value = 0.0) = struct_val(struct_val(PRINTER_ADJUSTMENTS, key), printer, default_value);

$printer_adjust_pin_d = ADJUSTMENTS_FOR_PRINTER("pin_d", printer);
$printer_adjust_arm_thickness = ADJUSTMENTS_FOR_PRINTER("arm_thickness", printer);
// echo_struct(PRINTER_ADJUSTMENTS);
echo("Adjustments", printer, $printer_adjust_pin_d, $printer_adjust_arm_thickness);

if (part == "arm")
{
  arm(thickness = arm_thickness, svg = arm_svg);
}
else if (part == "barrel")
{
  barrel(barrel_d = barrel_d, height = height, hole_d = hole_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness, has_flat_side = has_flat_side,
         is_closed = is_closed);
}
else if (part == "pins")
{
  pins(barrel_d = barrel_d, pin_d = pin_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness, has_flat_side = has_flat_side);
}
else if (part == "preview")
{
  left(20) arm(thickness = arm_thickness, svg = arm_svg);

  barrel(barrel_d = barrel_d, height = height, hole_d = hole_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness, has_flat_side = has_flat_side,
         is_closed = is_closed);

  fwd(20) pins(barrel_d = barrel_d, pin_d = pin_d, number_of_arms = number_of_arms, arm_thickness = arm_thickness, has_flat_side = has_flat_side);
}

module barrel(barrel_d, height, hole_d, number_of_arms, arm_thickness, has_flat_side = false, is_closed = false)
{
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
    left_arm_position = arm_thickness * number_of_arms / 2 - arm_thickness / 2;
    arm_margin_front = 3;
    arm_margin_back = 1;
    arm_space = hole_d + arm_margin_front + arm_margin_back;

    inset_for_closing_arm_attachments_of_barrel = is_closed ? 2 : 0;
    left(left_arm_position) fwd(barrel_d / 4 - inset_for_closing_arm_attachments_of_barrel) up(height - arm_space)
    {
      number_of_holes = number_of_arms / 2;
      for (x = [0:number_of_holes - 1])
      {
        right(x * arm_thickness + x * arm_thickness) cuboid([ arm_thickness, barrel_d / 2, arm_space ], anchor = BOT);
      }
    }

    // This fwd and xrot are just trial and error to make good room for the arm when in closed position
    // #fwd(2) xrot(-6)
    fwd(2.4) xrot(-7)
    {

      // Space for arms
      extra_room_back = 3;
      space_y = barrel_d - arm_space * 2 + extra_room_back;
      down(5) back(extra_room_back / 2) cuboid([ arm_thickness * number_of_arms, space_y, height + 10 ], anchor = BOT);

      // Space for sliding the arms inside the barrel. Adding some wiggle room
      wiggle_room_x = arm_thickness * 2;
      wiggle_room_y = 0.2;
      sliding_space_y = hole_d + wiggle_room_y;
      extra_room_for_arm_head = 1;
      sliding_space_fwd_position = space_y / 2 - sliding_space_y / 2 - extra_room_back / 2 - extra_room_for_arm_head;
      down(5) fwd(sliding_space_fwd_position) cuboid([ arm_thickness * number_of_arms + wiggle_room_x, sliding_space_y, height + 10 ], anchor = BOT);
    }

    // Hole for pin
    up(height - arm_space / 2) fwd(barrel_d / 2 - hole_d / 2 - arm_margin_front) xcyl(d = hole_d, h = barrel_d);
  }
}

module arm(thickness, svg)
{
  thickness_adjusted = thickness + $printer_adjust_arm_thickness;

  path = [ [ 0, 0 ], [ -11, 2 ], [ -11, 10 ], [ -8, 15 ], [ -6, 20 ], [ 0, 20 ] ];
  holes = [ path[0], path[3], path[5] ];

  difference()
  {
    union()
    {
      linear_extrude(height = thickness_adjusted, $fn = 16) stroke(path, width = 3, joints = "dot", joint_width = 1);
      for (hole = holes)
      {
        right(hole[0]) back(hole[1]) arm_hole(thickness);
      }
    }

    for (hole = holes)
    {
      right(hole[0]) back(hole[1]) arm_hole(thickness, is_mask = true);
    }
  }
}

module arm_hole(thickness, is_mask = false)
{
  thickness_adjusted = thickness + $printer_adjust_arm_thickness;

  if (is_mask)
  {

    cyl(d = hole_d, h = thickness_adjusted, anchor = BOT, $fn = 16);
  }
  else
  {
    cyl(d = hole_d + 0.8 * 2, h = thickness_adjusted, anchor = BOT, $fn = 16);
  }
}

module pins(barrel_d, pin_d, number_of_arms, arm_thickness, has_flat_side = false)
{
  arm_thickness_adjusted = arm_thickness + $printer_adjust_arm_thickness;

  length_pin_center = arm_thickness_adjusted * number_of_arms + 0.2;
  length_pin_barrel_inside = arm_thickness * number_of_arms + 3.5;
  length_pin_barrel_outside = has_flat_side ? barrel_d - 0.4 : arm_thickness * number_of_arms + 6;

  pin_d_adjusted = pin_d + $printer_adjust_pin_d;

  // One center pin
  xcyl(d = pin_d_adjusted, h = length_pin_center, anchor = BOT);

  // Two inside barrel
  for (offset = [ 5, 10 ])
  {
    fwd(offset)
    {
      xcyl(d = pin_d_adjusted, h = length_pin_barrel_inside, anchor = BOT);
      left(arm_thickness / 2) up(pin_d_adjusted / 2) cuboid([ arm_thickness, pin_d_adjusted, 2 ], anchor = BOT);
    }
  }

  // Two outside barrel
  for (offset = [ 15, 20 ])
  {
    fwd(offset) xcyl(d = pin_d_adjusted, h = length_pin_barrel_outside, anchor = BOT);
  }
}
