$fn = 64;

/* elliptical_cylinder BEGIN */
module elliptical_cylinder(major, minor, height) {
    scale([major / 2, minor / 2, 1])
        cylinder(d = 2, h = height);
}
/* elliptical_cylinder END */

/* elliptical_formwork BEGIN */
module elliptical_formwork(outer_major, outer_minor, wall, height) {
    difference_shape_height = height * 2;

    difference() {
        elliptical_cylinder(outer_major + 2 * wall, outer_minor + 2 * wall, height);
        translate(
            [
            0,
            0,
                -difference_shape_height / 4
            ]
        ) {
            elliptical_cylinder(outer_major, outer_minor, difference_shape_height);
        }
    }
}
/* elliptical_formwork END */

// elliptical_formwork_with_cutouts BEGIN
module elliptical_formwork_with_cutouts(outer_major, outer_minor, wall, height, key) {
    difference() {
        difference() {
            difference_shape_height = height * 2;
            color("green") elliptical_formwork(outer_major, outer_minor, wall, height);

            translate(
                [
                        outer_minor / 2 + key / 2,
                0,
                    difference_shape_height / 4
                ]
            ) {
                cube(
                    [outer_minor, outer_major, difference_shape_height],
                center = true
                );
            }
        }

        translate(
            [
                0,
            0,
                    height / 2 + height / 4
            ]
        ) {
            cube(
                [key, outer_minor + wall * 2, height / 2],
            center = true
            );
        }

        translate(
            [
                key / 4,
                    -outer_minor / 2 - wall / 2,
                height / 4
            ]
        ) {
            #cylinder(
            height,
            1,
            1,
            center = true
            );
        }

        translate(
            [
                    +key / 4 - key / 2,
                    -outer_minor / 2 - wall / 2,
                height / 4
            ]
        ) {
            #cylinder(
            height,
            1,
            1,
            center = true
            );
        }

        translate(
            [
                key / 4,
                    outer_minor / 2 + wall / 2,
                height / 4
            ]
        ) {
            #cylinder(
            height,
            1,
            1,
            center = true
            );
        }

        translate(
            [
                    +key / 4 - key / 2,
                    outer_minor / 2 + wall / 2,
                height / 4
            ]
        ) {
            #cylinder(
            height,
            1,
            1,
            center = true
            );
        }
    }
}
// elliptical_formwork_with_cutouts END
