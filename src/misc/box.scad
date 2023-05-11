// clang-format off
include<../common.scad>;
// clang-format on

$fn = 64;

width = 90;
length = 180;
height = 20;
wall = 2;
rounding = 1;
diff() rect_tube(h = height - wall, size = [ width, length ], wall = wall, rounding = rounding)
{
  attach(BOT) cuboid([ width, length, wall ], rounding = rounding);
}