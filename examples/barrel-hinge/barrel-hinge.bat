openscad -D "part=\""barrel\"";printer=\""bambu\""" -o stl/bambu_barrel-hinge-barrel.stl barrel-hinge.scad
openscad -D "part=\""arm\"";printer=\""bambu\""" -o stl/bambu_barrel-hinge-arm.stl barrel-hinge.scad
openscad -D "part=\""pins\"";printer=\""bambu\""" -o stl/bambu_barrel-hinge-pins.stl barrel-hinge.scad

@REM openscad -D "part=\""barrel\"";has_flat_side=true;printer=\""bambu\""" -o stl/bambu_flat-barrel-hinge-barrel.stl barrel-hinge.scad
@REM openscad -D "part=\""arm\"";has_flat_side=true;printer=\""bambu\""" -o stl/bambu_flat-barrel-hinge-arm.stl barrel-hinge.scad
@REM openscad -D "part=\""pins\"";has_flat_side=true;printer=\""bambu\""" -o stl/bambu_flat-barrel-hinge-pins.stl barrel-hinge.scad

@REM openscad -D "part=\""barrel\"";has_flat_side=false;printer=\""ender\""" -o stl/ender_barrel-hinge-barrel.stl barrel-hinge.scad
@REM openscad -D "part=\""arm\"";has_flat_side=false;printer=\""ender\""" -o stl/ender_barrel-hinge-arm.stl barrel-hinge.scad
@REM openscad -D "part=\""pins\"";has_flat_side=false;printer=\""ender\""" -o stl/ender_barrel-hinge-pins.stl barrel-hinge.scad

@REM openscad -D "part=\""barrel\"";has_flat_side=true;printer=\""ender\""" -o stl/ender_flat-barrel-hinge-barrel.stl barrel-hinge.scad
@REM openscad -D "part=\""arm\"";has_flat_side=true;printer=\""ender\""" -o stl/ender_flat-barrel-hinge-arm.stl barrel-hinge.scad
@REM openscad -D "part=\""pins\"";has_flat_side=true;printer=\""ender\""" -o stl/ender_flat-barrel-hinge-pins.stl barrel-hinge.scad

@REM openscad -D "part=\""barrel\"";has_flat_side=false" -o stl/barrel-hinge-barrel.stl barrel-hinge.scad
@REM openscad -D "part=\""arm\"";has_flat_side=false" -o stl/barrel-hinge-arm.stl barrel-hinge.scad
@REM openscad -D "part=\""pins\"";has_flat_side=false" -o stl/barrel-hinge-pins.stl barrel-hinge.scad

@REM openscad -D "part=\""barrel\"";has_flat_side=true" -o stl/flat-barrel-hinge-barrel.stl barrel-hinge.scad
@REM openscad -D "part=\""arm\"";has_flat_side=true" -o stl/flat-barrel-hinge-arm.stl barrel-hinge.scad
@REM openscad -D "part=\""pins\"";has_flat_side=true" -o stl/flat-barrel-hinge-pins.stl barrel-hinge.scad
