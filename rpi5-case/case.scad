use <../libs/Round-Anything/MinkowskiRound.scad>;

// ### CONFIG ###

$fn = 16;

// ### CONSTANTS ###

board_depth          = 85;
board_width          = 56;
board_mount_diameter = 2.7;

box_tolerance      = 1;
box_wall_thickness = 0.25;
box_walls          = box_wall_thickness + box_tolerance;
box_depth          = board_depth + box_walls;
box_width          = board_width + box_walls;
box_height         = 20;

mount_tolerance       = 0.5;
mount_height          = 3;
mount_inner_diameter  = board_mount_diameter + mount_tolerance;
mount_wall_thickness  = 1.5;
mount_outer_diameter  = mount_inner_diameter + mount_wall_thickness * 2;
mount_offset_start    = 3.5;
mount_offset_end      = 23.5;
mount_offset_vertical = - box_height / 2 + mount_height / 2 + box_wall_thickness;
screw_mount_matrix = [
    [-1, 1, 1, -1],
    [-1, 1, -1, 1],
    [1, -1, 1, -1],
    [1, -1, -1, 1]
];
    
sd_card_minkowski_radius = 1.25;
sd_card_tolerance        = 0.5;
sd_card_width            = 12 + sd_card_tolerance * 2;
sd_card_thickness        = 1.5 + sd_card_tolerance * 2;

usb_cutout_minkowski_radius = 2;
usb_cutout_tolerance        = 1;
usb_cutout_width            = 38 + sd_card_tolerance * 2;
usb_cutout_height           = 5 + sd_card_tolerance * 2;

vent_slot_width  = 4;
vent_slot_height = box_height / 1.5;

// ###  GEOMETRY ###

union() {
    difference() {
        // walls_begin
        difference() {
          minkowski() {
                cube(
                    [box_width, box_depth, box_height],
                    center = true
                );
                
                sphere(2);
            }
            
            translate(
                [
                    0,
                    0,
                    box_wall_thickness + box_height / 2
                ]
            ) {
                cube(
                    [box_width + box_tolerance - box_walls, box_depth + box_tolerance - box_walls, box_height * 2],
                    center = true
                );
            }
        }
        // walls_end
        
        // io_cutout_begin
        translate(
            [
                0,
                -board_depth / 2 - box_wall_thickness * 8,
                box_wall_thickness + mount_height
            ]
        ) {
            
            cube(
                [board_width - box_wall_thickness * 14, box_wall_thickness * 16, box_height],
                center = true
            );
        }
        // io_cutout_end
        
        // sd_card_cutout_begin
        translate(
            [
                0,
                box_depth / 2, 
                -box_height / 2 + mount_height + sd_card_tolerance
            ]
        ) {
            minkowskiOutsideRound(r = sd_card_minkowski_radius) {
                cube(
                    [sd_card_width, box_wall_thickness * 32, sd_card_thickness],
                    center = true
                );
            }
        }
        // sd_card_cutout_end
        
        
        usb_cutout_raw_position = box_depth / 2 - usb_cutout_width / 2 - box_wall_thickness;
        mount_full_thickness = mount_outer_diameter + box_tolerance;
        // usb_cutout_begin
        translate(
            [
                -box_width / 2,
                usb_cutout_raw_position - mount_full_thickness + usb_cutout_tolerance * 2,
                -box_height / 2 + usb_cutout_height / 2 + mount_height + usb_cutout_tolerance / 2
            ]
        ) {
            minkowskiOutsideRound(r = usb_cutout_minkowski_radius) {
                cube(
                    [box_wall_thickness * 32, usb_cutout_width, usb_cutout_height],
                    center = true
                );
            }
            
        }
        // usb_cutout_end
        
        // vent_begin
        for ( i = [-board_width / 2 + vent_slot_width : vent_slot_width * 1.5: board_width  / 2 - vent_slot_width ] ) {
            vent_slot(
                [i, box_depth / 2, box_height / 2 - vent_slot_height / 2]
            );
        }
        // vent_end
    }

    // screw_mounts_begin
    for (i = [ 0 : len(screw_mount_matrix) - 1 ]) {
        s = screw_mount_matrix[i];
        
        screw_mount(
            [
                s[0] * board_width / 2 + s[1] * mount_offset_start,
                s[2] * board_depth / 2 + s[3] * (s[3] > 0 ? mount_offset_end : mount_offset_start),
                mount_offset_vertical
            ]
        );
    }
   // screw_mounts_end
}

// ### CUSTOM MODULES ###

module vent_slot(c) {
        translate(c) {
            minkowskiOutsideRound() {
                cube(
                    [vent_slot_width, 5, vent_slot_height],
                    center = true
                );
            }
        }   
}

module screw_mount(t) {
    translate(t) {
         difference() {
                cylinder(
                    mount_height,
                    d = mount_outer_diameter,
                    center = true
                );
                
                translate(
                    [0, 0, mount_height / 2]
                ) {
                     cylinder(
                        mount_height * 2,
                        d = mount_inner_diameter,
                        center = true
                    );
               }
         }
    }
}
