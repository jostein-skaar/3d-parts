// clang-format off
include<common.scad>;
// clang-format on

size_of_belt_percent = 0.1;
button_od_percent = 0.3;
button_id_percent = 0.2;
belt_inset = 1;

module pokeball(d, flat_bottom = 0)
{
  top_half(z = d * size_of_belt_percent / 2) diff() sphere(d = d) { tag("remove") ycyl(d = d * button_od_percent, h = d, anchor = BACK); };

  bottom_half(z = -d * size_of_belt_percent / 2) diff() sphere(d = d)
  {
    tag("remove") ycyl(d = d * button_od_percent, h = d, anchor = BACK);
    if (flat_bottom > 0)
    {
      tag("remove") up(flat_bottom) position(BOT) cuboid(size = d, anchor = TOP);
    }
  }

  sphere(d = d - belt_inset);
}

// diff() sphere(d = d)
//   {
//     tag("remove") cuboid([ d, d, d * size_of_belt ]);
//     tag("keep") color_this("black") sphere(d = d - belt_inset);
//     if (flat_bottom > 0)
//     {
//       tag("remove") up(flat_bottom) position(BOT) cuboid(size = d, anchor = TOP);
//     }
//   }