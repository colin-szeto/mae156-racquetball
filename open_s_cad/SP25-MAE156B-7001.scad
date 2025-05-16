// base shape
outer_radius =31.75/2;
height = 62.865;

module vertical_slot(angle = 0) {
        // variable
        slot_h_off = 5.715; 
        slot_height = 50.80;
        slot_width = 6;
        slot_depth = 2.714;
    
        // longer slot
        rotate([0,0,angle])
            translate([outer_radius-slot_depth/2,0,slot_height/2 +slot_h_off])
                cube([slot_depth ,slot_width,slot_height],center=true);
        
        // bottom slot ( bottom trough)
        s_s_h = 15;
        rotate([0,0,angle])
            translate([outer_radius-slot_depth,0,s_s_h/2 +4])
                cube([5 ,slot_width,10],center=true);
        
        // bottom round slot
        rotate([0,0,angle])
            translate([outer_radius-slot_depth/2,0,slot_h_off])
                rotate([0,90,0])
                    cylinder(8,d=slot_width,center=true,$fn=10);
        
        // upper round slot
        rotate([0,0,angle])
            translate([outer_radius-slot_depth/2,0,slot_h_off+slot_height])
                rotate([0,90,0])
                    cylinder(slot_depth,d=slot_width,center=true);
                    
        // tear drop
        rotate([0,0,angle])
            translate([outer_radius-.5,0,slot_h_off+slot_height+1.05])
                rotate([45,0,0])
                    cube([4.15,4.15,4.25],center=true);
                    
        // bottom  chamfer
        //s_s_h = 15;
        rotate([0,0,angle])
            // put on the surface // left right // up down
            translate([outer_radius-slot_depth+.225,1.5,s_s_h/2 +7])
                rotate([-45/2 +5,0,5])
                    cube([5.5,5.5,10],center=true);
                    
        // bottom  upper chamfer
        //s_s_h = 15;
        rotate([0,0,angle])
            // put on the surface // left right // up down
            translate([outer_radius-2.714+3,4,s_s_h/2 +18])
                rotate([45,0,5])
                    cube([5.5,5.5,10],center=true);
                    
        // upper lower chamfer
        //s_s_h = 15;
        rotate([0,0,angle])
            // put on the surface // left right // up down
            translate([outer_radius-2.714+3.25,-2,s_s_h/2 +35])
                rotate([45,5,-13])
                    cube([5.5,5.5,7],center=true);

}


module a_slot(angle_off = 0) {

    height_ramp = 38.1;// height
    r = outer_radius; // pattern radius
    r0 = outer_radius-2.25;//0.512; // inner radius
    n = 50; // number of cars
    angle = 120;
    step = angle/n;
    h_step = height_ramp/n;
    slot_off = 15.11; // from bottom 
    
    adjust = (3.75)/n; // variable radius for the rotation
    echo("adjust",adjust);

    for (i=[0:step:(angle-1)]) {
        index = i/step;
        angle = i;
        variable_r = r0 + adjust*index;
        echo("variable radius",r+adjust*index);

        dx = (r0+adjust*index)*cos(angle+angle_off);
        dy = (r0+adjust*index)*sin(angle+angle_off);
        r_s_d = 2.714;// radius slot depth
        translate([dx,dy,index*h_step+slot_off])
            rotate([51,0,angle+angle_off])
                cube([6,3,6.5],center=true);
        //echo("slot offset end",index*h_step+slot_off,i);
    }

}

difference(){
    // base shape
    cylinder(h=height,r=outer_radius,$fn=60); 
    
    //cutting out center bore
    translate([0,0,-2.5])
        cylinder(h=height+5,d=6.2,$fn=30); 
    
    //cutting out the nub
    translate([0,0,height])
        cube([16.2,16.2,11.365*2],center=true);
    rotate([0,180,0])
        translate([0,0,-height])
            cylinder(h=14.423,d =8.128,$fn=30); 
    // set screw hole
    rotate([0,90,0])
        translate([-7.865-(height-7.865*2),0,-10])
            cylinder(h=30,d =6,center=true,$fn=10); 

    // cutting out the slot
    vertical_slot(0);
    vertical_slot(120);
    vertical_slot(120*2);
    a_slot(0);
    a_slot(120);
    a_slot(240);
}


