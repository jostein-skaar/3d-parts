// clang-format off
include<../common.scad>;
// clang-format on

$fn = 64;

width = 30;
length = 20;
height = 120;
wall = 1.2;
h_magnet = 1.6;
d_magnet = 6.1;
rounding = 0.6;
diff() rect_tube(h = height - wall, size = [ width, length ], wall = wall, rounding = rounding)
{
  tag("remove") up(height / 2 - 10) attach(BACK) cyl(d = d_magnet, h = h_magnet, anchor = UP);
  attach(BOT) cuboid([ width, length, wall ], rounding = rounding);
}

//   width = 2;
//   length = age * size_reward + 2;
//   height = 1 / 3;
//   is_closed = true;
//   is_tile = false;
//   h_magnet = 1.6;
//   d_magnet = 6.1;
//   physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
//   difference()
//   {
//     brick(width, length, height, is_closed = is_closed, is_tile = is_tile, anchor = BOT, $tightness = tightness);
//     ycopies(spacing = physical_length - d_magnet - 4) { cyl(d = d_magnet, h = h_magnet, anchor = BOT); }
//   }