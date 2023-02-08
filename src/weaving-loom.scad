// clang-format off
include<common.scad>;
// clang-format on

$fn = 32;

size = 200;
wall = 10;
frame_height = 10;
pin_height = 40;
pin_d = 6;

count = 10;
grid_polygon = difference(square(size = size, anchor = CENTER), square(size = size - wall * 2, anchor = CENTER));

rect_tube(size = size, wall = wall, h = frame_height, rounding = 3)
{
  position(TOP) grid_copies(n = count, size = size - wall, inside = grid_polygon) cyl(d = pin_d, h = pin_height, anchor = BOT);
}

// pin(d = pin_d, h = pin_height + frame_height);
// weaving_loom_v2();

// module pin(d, h) { xcyl(d = d, h = h, anchor = BOT); }

// module weaving_loom_v2()
// {
//   grid_polygon = difference(square(size = size, anchor = CENTER), square(size = size - wall * 2, anchor = CENTER));

//   diff() rect_tube(size = size, wall = wall, h = frame_height, rounding = 3)
//   {
//     tag("remove") up(2) position(BOT) grid_copies(n = count, size = size - wall, inside = grid_polygon)
//       cyl(d = pin_d + d_tightness, h = pin_height, anchor = BOT);
//   }
// }

// weaving_loom_v1();
