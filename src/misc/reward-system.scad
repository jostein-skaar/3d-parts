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

part = "reward-20x";

age = 9;
letter = "A";

reward_height = 0.823;

size_reward = 1;

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
  height = reward_height;
  is_closed = false;
  is_tile = true;
  physical_size = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  echo(physical_height, BRICK_CALCULATE_PHYSICAL_LENGTH(1));
  up(physical_height) create_letter(letter, physical_size - 1, 1);
  brick(width, length, height, is_closed = is_closed, is_tile = is_tile, anchor = BOT, $tightness = tightness);

  physical_height_extra_studs = BRICK_CALCULATE_PHYSICAL_HEIGHT(0.1);

  back(physical_size / 2 - physical_height_extra_studs / 2) xrot(-90)
    brick(2, 1, 0.1, is_closed = true, is_tile = false, anchor = BACK, $tightness = tightness);
}
else if (part == "reward")
{
  width = 2;
  length = size_reward;
  height = reward_height;
  is_closed = false;
  is_tile = true;
  brick(width, length, height, is_closed = is_closed, is_tile = is_tile, anchor = BOT, $tightness = tightness);
}
else if (part == "reward-extra")
{
  width = 2;
  length = size_reward;
  height = reward_height;
  is_closed = false;
  is_tile = false;
  brick(width, length, height, is_closed = is_closed, is_tile = is_tile, anchor = BOT, $tightness = tightness);
}
else if (part == "reward-10x")
{
  create_reward_brick_with_text("10");
}
else if (part == "reward-20x")
{
  create_reward_brick_with_text("20");
}
else if (part == "reward-cylinder")
{
  // Alternative proposition that is not in use.
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

module create_letter(text, size, height)
{
  // font = "Liberation Mono:style=Bold";
  font = "Arial:style=Bold";
  linear_extrude(height = height) { text(text, size = size, font = font, halign = "center", valign = "center", $fn = 16); }
}

module create_reward_brick_with_text(text)
{
  width = 2;
  length = size_reward;
  height = reward_height * 2;
  is_closed = false;
  is_tile = false;
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  brick(width, length, height, is_closed = is_closed, is_tile = is_tile, anchor = BOT, $tightness = tightness);
  up(physical_height / 2) fwd(physical_length / 2) xrot(90) create_letter(text, 8, 0.4);
}