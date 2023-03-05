// clang-format off
include <../common.scad>;
include <motor-printer-adjustments.scad>;
include <../../../brick/src/bricklib.scad>;
include <../../../brick/src/brick-printer-adjustments.scad>;
// clang-format on

$fn = 64;

extra_size_for_better_remove = 0.001;

// printer = "mingda";
printer = "bambu";
// printer = "default";
$motor_printer_adjustments = motor_get_printer_adjustments(printer);
echo("$motor_printer_adjustments", printer, $motor_printer_adjustments);

$brick_printer_adjustments = brick_get_printer_adjustments(printer);
echo("$brick_printer_adjustments", printer, $brick_printer_adjustments);

part = "adafruit_3777_lid";

if (part == "adafruit_3777_lid")
{
  motor_adafruit_3777_house(is_lid = true);
}
else if (part == "adafruit_3777_house")
{
  motor_adafruit_3777_house(is_lid = false);
}
else if (part == "adafruit_3777_shaft")
{
  motor_adafruit_3777_shaft(5);
}
else if (part == "adafruit_3801_inlay")
{
  motor_adafruit_3801_inlay();
}
else if (part == "battery_4xAA")
{
  motor_battery_4xAA();
}
// height = 5;
// diff() cuboid([ 10, 10, height ]) { tag("remove") position(CENTER) motor_adafruit_3777_shaft(height + 0.001); }

module motor_adafruit_3777_shaft(height, anchor = CENTER, spin = 0, orient = UP)
{
  printer_adjust_shaft_width = motor_get_printer_adjustment("shaft_width");
  printer_adjust_shaft_length = motor_get_printer_adjustment("shaft_length");

  width = 3.6 + printer_adjust_shaft_width;
  length = 5.3 + printer_adjust_shaft_length;

  size = [ width, length, height ];
  attachable(anchor, spin, orient, size = size)
  {
    cuboid(size, rounding = 1, edges = "Z");
    children();
  }
}

module motor_adafruit_3777_house(is_lid = false)
{
  brick_width = 4;
  brick_length = 10;
  brick_height = 2 + 1 / 3;
  brick_lid_height = 1 / 3;
  physical_width = BRICK_CALCULATE_PHYSICAL_LENGTH(brick_width);
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(brick_length);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(brick_height);
  physical_lid_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(brick_lid_height);

  echo("brick sizes", physical_width, physical_length, physical_height, physical_lid_height);

  gearbox_size = [ 22.5, 65.2, 18.8 ];

  outher_height = 37;
  box_h = 19.2;
  bottom = 3;
  box_bottom = 2;
  wall = 2;

  // This is kind of a hacky way to adjust for fitting a brick size,
  // but I don't have time to rewrite for now.
  extra_wall_x = 5.4;
  extra_wall_y = 2.5;
  extra_wall_z = -1.4;

  extra_wall_motor_pin = 3 + extra_wall_y / 2;
  extra_wall_ext_w_hole = 5.2 + extra_wall_y / 2;
  lid_thickness = physical_lid_height;

  box_size = [
    gearbox_size[0] + wall * 2 + extra_wall_x, gearbox_size[1] + wall * 2 + extra_wall_motor_pin + extra_wall_ext_w_hole,
    gearbox_size[2] + bottom + box_bottom +
    extra_wall_z
  ];
  lid_size = [ box_size[0], box_size[1], lid_thickness ];

  echo("box_size", box_size);

  height_for_ext_w_hole = box_size[2];
  height_for_motor_pin_hole = box_size[2];

  ext_w_hole_size = [ 5.2, 5.2 + extra_size_for_better_remove * 2, height_for_ext_w_hole ];
  motor_pin_hole_size = [ 5.2, 3 + extra_size_for_better_remove * 2, height_for_motor_pin_hole ];
  shaft_d = 5.8;
  shaft_h = 9.2;
  shaft_bottom_h = 3;
  ext_w_hole_z = 7;

  if (is_lid)
  {
    up(physical_lid_height) xrot(180) difference()
    {
      brick(brick_width, brick_length, brick_lid_height, is_tile = true, anchor = BOT);

      diff() cuboid(lid_size, anchor = BOT)
      {
        tag("remove") position(TOP) cuboid(lid_size, anchor = TOP);
        tag("keep") down(1) back(11.3 + wall + extra_wall_ext_w_hole) position(BOT + FWD) zcyl(d = shaft_d + 8, h = lid_thickness + 10, anchor = DOWN);
        tag("keep") back(11.3 + wall + extra_wall_ext_w_hole + 11) position(BOT + FWD) zcyl(d = 5, h = 2, anchor = BOT);
        tag("keep") back(11.3 + wall + extra_wall_ext_w_hole + 32) position(BOT + FWD) cuboid([ 14, 8, 2 ], anchor = BOT);
        tag("keep") down(1) back(11.3 + wall + extra_wall_ext_w_hole + 42) position(BOT + FWD) zcyl(d = 7, h = lid_thickness + 10, anchor = DOWN);
      }
    }
  }
  else
  {
    up(BRICK_CALCULATE_PHYSICAL_HEIGHT(1 / 3)) diff() cuboid(box_size, anchor = BOT)
    {
      // We make it 10 taller to remove studs in the void
      tag("remove") up(bottom + box_bottom + extra_size_for_better_remove + extra_wall_z) fwd(extra_wall_motor_pin / 2) back(extra_wall_ext_w_hole / 2)
        position(BOT) cuboid([ gearbox_size[0], gearbox_size[1], gearbox_size[2] + 10 ], anchor = BOT, rounding = 5, edges = "Z")
      {
        // ext_w_hole
        up(ext_w_hole_z) back(extra_size_for_better_remove) position(FWD + BOT) cuboid(ext_w_hole_size, anchor = BACK + BOT);
        // motor_pin_hole
        up(ext_w_hole_z) fwd(extra_size_for_better_remove) position(BACK + BOT) cuboid(motor_pin_hole_size, anchor = FWD + BOT);
        // shaft up
        back(11.3) position(UP + FWD) zcyl(d = shaft_d, h = shaft_h, anchor = DOWN);
        // shaft bottom (for 3777, not 3801 and 3802)
        back(11.3) up(extra_size_for_better_remove) position(DOWN + FWD) zcyl(d = shaft_d, h = shaft_bottom_h + extra_size_for_better_remove, anchor = UP);

        // extra space for motor
        position(DOWN + BACK) up(extra_size_for_better_remove) cuboid([ 16, 26, bottom + 1 ], anchor = UP + BACK);
      }

      // Brick studs
      // limit_studs_polygon = difference(rect([ outer[0], outer[1] ]), rect([ inner[0], inner[1] ]));
      limit_studs_polygon = undef;
      position(TOP) brick_studs(width = brick_width, length = brick_length, inside = limit_studs_polygon, $tightness = 0.1);

      // breathing holes
      tag("remove") down(1) position(TOP) ycopies(n = 6, spacing = 10) xcyl(d = 2, h = physical_width + extra_size_for_better_remove * 2, anchor = TOP);
    }

    brick(brick_width, brick_length, 1 / 3, is_tile = true, anchor = BOT, $tightness = -0.05);
  }
}

module motor_adafruit_3801_inlay()
{
  thickness = 2;
  diff() cuboid([ 12, 16, thickness ], rounding = 1, edges = "Z") { tag("remove") zcyl(d = 10, h = thickness + extra_size_for_better_remove * 2); }
}

module motor_battery_4xAA()
{
  inner = [ 58.2, 63.2, 17.2 ];

  brick_width = 8;
  brick_length = 10;
  brick_height = 2 + 1 / 3;
  physical_width = BRICK_CALCULATE_PHYSICAL_LENGTH(brick_width);
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(brick_length);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(brick_height);
  echo("brick sizes", physical_width, physical_length, physical_height);
  outer = [ physical_width, physical_length, physical_height ];

  up(BRICK_CALCULATE_PHYSICAL_HEIGHT(1 / 3)) diff() cuboid(outer, anchor = BOT)
  {

    tag("remove") attach(TOP) up(extra_size_for_better_remove) cuboid(inner, anchor = TOP)
    {
      attach(BOT) down(extra_size_for_better_remove) rect_tube(size = [ inner[0], inner[1] ], h = 1.2, wall = 10, anchor = BOT);

      // battery cable
      up(3) right(extra_size_for_better_remove) fwd(5) position(BACK + BOT + LEFT) xcyl(d = 7, h = 10, anchor = RIGHT);
    }

    // breathing holes
    tag("remove") down(1) position(TOP) ycopies(n = 6, spacing = 10) xcyl(d = 2, h = physical_width + extra_size_for_better_remove * 2, anchor = TOP);

    // Brick studs
    limit_studs_polygon = difference(rect([ outer[0], outer[1] ]), rect([ inner[0], inner[1] ]));
    position(TOP) brick_studs(width = brick_width, length = brick_length, inside = limit_studs_polygon);
  }

  brick(brick_width, brick_length, 1 / 3, is_tile = true, anchor = BOT, $tightness = -0.05);
}

// clang-format off
function motor_get_printer_adjustment(key) = 
  get_printer_adjustment(key, $motor_printer_adjustments);
// clang-format on