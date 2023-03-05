// clang-format off
include<../common.scad>;
// clang-format on

$fn = 32;

size = 200;
wall = 10;
frame_height = 10;
pin_height = 40;
pin_d = 6;

count = 10;
grid_polygon = difference(square(size = size, anchor = CENTER), square(size = size - wall * 2, anchor = CENTER));

weaving_loom();
module weaving_loom()
{
  pin_id = 1.6;
  pin_id_bottom = 4;
  pin_bottom_size = 3;
  closed_hole_size = 2;
  diff()
  {

    rect_tube(size = size, wall = wall, h = frame_height, rounding = 3)
    {
      position(TOP) grid_copies(n = count, size = size - wall, inside = grid_polygon) cyl(d = pin_d, h = pin_height, rounding2 = pin_d / 4, anchor = BOT);
    }

    tag("remove") grid_copies(n = count, size = size - wall, inside = grid_polygon)
    {
      cyl(d = pin_id, h = frame_height + pin_height - closed_hole_size, anchor = BOT);
      cyl(d = pin_id_bottom, h = pin_bottom_size, anchor = BOT);
    }
  }
}

// weaving_loom_experiment_cone();
module weaving_loom_experiment_cone()
{
  hole_d = 9;
  cone_start = 5;
  cone_stop = frame_height + 2;
  diff() rect_tube(size = size, wall = wall, h = frame_height, rounding = 3)
  {
    tag("remove") up(cone_start) position(BOT) grid_copies(n = count, size = size - wall, inside = grid_polygon)
      cyl(d = hole_d, h = frame_height, anchor = BOT);
    tag("keep") position(TOP) grid_copies(n = count, size = size - wall, inside = grid_polygon) cyl(d = pin_d, h = pin_height, anchor = BOT);
    tag("keep") up(cone_start) position(BOT) grid_copies(n = count, size = size - wall, inside = grid_polygon)
      cyl(d1 = hole_d, d2 = pin_d, h = cone_stop - cone_start, anchor = BOT);
  }
}

// weaving_loom_frame_wo_pins();
module weaving_loom_frame_wo_pins()
{
  pin_offset = 1.2;
  d_tightness = 0.2;
  grid_polygon = difference(square(size = size, anchor = CENTER), square(size = size - wall * 2, anchor = CENTER));

  diff() rect_tube(size = size, wall = wall, h = frame_height, rounding = 3)
  {
    tag("remove") up(pin_offset) position(BOT) grid_copies(n = count, size = size - wall, inside = grid_polygon)
      cyl(d = pin_d + d_tightness, h = pin_height, anchor = BOT);
  }
}

// weaving_loom_pin();
module weaving_loom_pin()
{
  pin_offset = 1.2;
  d_tightness = 0.0;
  height = pin_height + frame_height - pin_offset;
  xcyl(d = pin_d + d_tightness, h = height, anchor = BOT);
}