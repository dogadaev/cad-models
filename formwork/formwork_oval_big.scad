use <formwork_oval.scad>;

$fn = 256;

/* render BEGIN */
key_width = 15;
radius_small = 167.25;
wall_thickness = 5;
radius_big = 215;
wall_height = 20;

elliptical_formwork_with_cutouts(radius_big, radius_small, wall_thickness, wall_height, key_width);
/* render END */