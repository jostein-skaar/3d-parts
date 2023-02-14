// clang-format off
include<../../src/pokeball.scad>;
// clang-format on

$fn = $preview ? 64 : 100;

pokeball(d = 70, flat_bottom = 0);