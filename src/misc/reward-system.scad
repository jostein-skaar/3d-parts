// clang-format off
include<../common.scad>;
include <../../../brick/src/bricklib.scad>;
include <../../../brick/src/brick-printer-adjustments.scad>;
// clang-format on

$fn = 64;

printer = "bambu";
$brick_printer_adjustments = brick_get_printer_adjustments(printer);
echo("$brick_printer_adjustments", printer, $brick_printer_adjustments);

tightness = BRICK_TIGHTNESS_DEFAULT;

part = "name";

size_reward = 1;
age = 9;

if (part == "plate")
{
  width = 2;
  length = age * size_reward + 2;
  height = 1 / 3;
  is_closed = true;
  is_tile = false;
  h_magnet = 1.6;
  d_magnet = 6.1;
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
  difference()
  {
    brick(width, length, height, is_closed = is_closed, is_tile = is_tile, anchor = BOT, $tightness = tightness);
    ycopies(spacing = physical_length - d_magnet - 4) { cyl(d = d_magnet, h = h_magnet, anchor = BOT); }
  }
}
else if (part == "name")
{
  width = 2;
  length = 2;
  height = 1 / 2;
  is_closed = false;
  is_tile = true;
  brick(width, length, height, is_closed = is_closed, is_tile = is_tile, anchor = BOT, $tightness = tightness);
}
else if (part == "reward")
{
  width = 2;
  length = size_reward;
  height = 1 / 2;
  is_closed = false;
  is_tile = true;
  brick(width, length, height, is_closed = is_closed, is_tile = is_tile, anchor = BOT, $tightness = tightness);
}
else if (part == "reward-extra")
{
  tightness = BRICK_TIGHTNESS_LOOSE;
  width = 2;
  length = size_reward;
  height = 1 / 2;
  is_closed = false;
  is_tile = false;
  brick(width, length, height, is_closed = is_closed, is_tile = is_tile, anchor = BOT, $tightness = tightness);
}
else if (part == "reward-cylinder")
{
  width = 2;
  length = 2;
  height = 1;

  physical_size = BRICK_CALCULATE_PHYSICAL_LENGTH(2);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(1);
  id = brick_calculate_adjusted_antistud_d();
  diff()
  {
    cyl(d = physical_size, h = physical_height, anchor = BOT)
    {
      attach(TOP) brick_studs(width = 1, length = 1);
      tag("remove") position(BOT) cyl(d = id, h = 5, anchor = BOT);
    }
  }
}