// base shape
outer_radius =31.75/2;
height = 62.865;

module vertical_slot(angle = 0) {
        // slot
        slot_h_off = 5.715; 
        slot_height = 50.80;
        slot_width = 6;
        slot_depth = 2.714;
        rotate([0,0,angle])
            translate([outer_radius-slot_depth/2,0,slot_height/2 +slot_h_off])
                cube([slot_depth ,slot_width,slot_height],center=true);
        
        // bottom round slot
        rotate([0,0,angle])
            translate([outer_radius-slot_depth/2,0,slot_h_off])
                rotate([0,90,0])
                    cylinder(slot_depth,d=slot_width,center=true);
        
        // upper round slot
        rotate([0,0,angle])
            translate([outer_radius-slot_depth/2,0,slot_h_off+slot_height])
                rotate([0,90,0])
                    cylinder(slot_depth,d=slot_width,center=true);

}


module a_slot(angle_off = 0) {

    height_ramp = 38.1;// height
    r = outer_radius; // pattern radius
    r0 = outer_radius-2;//0.512; // inner radius
    n = 50; // number of cars
    angle = 120;
    step = angle/n;
    h_step = height_ramp/n;
    slot_off = 15.11; // from bottom 
    
    adjust = (r-r0)/n; // variable radius for the rotation
    echo("adjust",adjust);

    for (i=[0:step:(angle-1)]) {
        index = i/step;
        angle = i;
        variable_r = r0 + adjust*index;
        echo("variable_r",variable_r);

        dx = r*cos(angle+angle_off);
        dy = r*sin(angle+angle_off);
        r_s_d = 2.7;// radius slot depth
        translate([dx,dy,index*h_step+slot_off])
            rotate([45,0,angle+angle_off])
                cube([2.714,2,6],center=true);
        //echo("slot offset end",index*h_step+slot_off,i);
    }

}

difference(){
    // base shape
    cylinder(h=height,r=outer_radius); 
    vertical_slot(0);
    vertical_slot(120);
    vertical_slot(120*2);
    a_slot(0);
    a_slot(120);
    a_slot(240);
}


