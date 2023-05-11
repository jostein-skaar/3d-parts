// clang-format off
include<../common.scad>;
include <../../../brick/src/bricklib.scad>;
include <../../../brick/src/brick-printer-adjustments.scad>;
include<BOSL2\threading.scad>;

// clang-format on

$fn = $preview ? 32 : 200;
multiplier = 10;

d = 10.11 * multiplier;
h = 8.36 * multiplier;
rounding_r = 1.75 * multiplier;
wall = 3;

slot_x = 30;
slot_y = 3;

top_od = (3.08 + 0.9 * 2) * multiplier;
top_id = 3.08 * multiplier;
top_h = 1.21 * multiplier;

bottom_od = 6.52 * multiplier;
bottom_id = top_od;
bottom_h = 1.21 * multiplier;

face_template_thickness = 2;
face_template_h = 6 * multiplier;
face_template_d = d + face_template_thickness;

pitch = 3.5;

// tube(od = bottom_od, id = bottom_id, h = 5, anchor = BOT);

// lid();
hair();
// head();
module hair()
{
  hair_scale = 10.1;
  difference()
  {
    xrot(90) scale([ hair_scale, hair_scale, hair_scale ]) import("brick-head-hair-kai.stl");
    down(5) cyl(d = bottom_od + 10, h = top_h * 3 + 10, anchor = BOT);
  }
  tube(od = bottom_od, id = bottom_id + 0.5, h = bottom_h * 3 + 7, anchor = BOT);
}

module lid()
{

  diff() threaded_rod(d = bottom_id - 0.8, l = bottom_h, pitch = pitch, anchor = BOTTOM)
  {
    tag("remove") attach(TOP) cuboid([ slot_x, slot_y, 9 ], anchor = TOP);
  }
}
module head()
{

  opening_on_top = "slot"; // "hole"

  diff() cyl(d = d, h = h, rounding = rounding_r)
  {
    attach(TOP) tube(od = top_od, id = top_id, h = top_h, anchor = BOT);
    //   attach(BOT) tube(od = bottom_od, id = bottom_id, h = bottom_h, anchor = BOT);
    attach(BOT) cyl(d = bottom_od, h = bottom_h, anchor = BOT)
    {
      tag("remove") attach(CENTER) threaded_rod(d = bottom_id, l = bottom_h + 2, pitch = pitch, anchor = CENTER, internal = true);
    }
    tag("remove") cyl(d = d - wall * 2, h = h - wall * 2, rounding = rounding_r);
    tag("remove") attach(BOT) cyl(d = bottom_id, h = wall, anchor = TOP);

    // Opening on top:
    if (opening_on_top == "hole")
    {
      tag("remove") attach(TOP) cyl(d = top_id, h = wall, anchor = TOP);
    }
    else if (opening_on_top == "slot")
    {
      tag("remove") attach(TOP) cuboid([ slot_x, slot_y, wall ], anchor = TOP);
    }
  }
}

module face_template()
{
  $fn = $preview ? 32 : 100;

  eyes_spacing = 2.8 * multiplier;
  eyes_d = 1.2 * multiplier;
  mouth_width = eyes_spacing + eyes_d;
  mouth_height = mouth_width / 4;

  svg_width = 6;

  difference()
  {
    diff() tube(od = face_template_d, id = d, h = face_template_h, anchor = BOT)
    {
      tag("remove") left(d / 6) cuboid([ face_template_d, face_template_d, face_template_h ]);
      // #tag("remove") up(1 * multiplier) ycopies(spacing = eyes_spacing) attach(RIGHT) cyl(d = eyes_d, h = face_template_thickness * 5, anchor = UP);
    }

#zrot(90) xrot(90) back(multiplier / 2) up(face_template_d / 2 - multiplier * 2) left(svg_width *multiplier / 2)
    scale([ multiplier, multiplier, multiplier * 2 ]) linear_extrude(height = 2) import("brick-head-face-kai.svg");
  }
}