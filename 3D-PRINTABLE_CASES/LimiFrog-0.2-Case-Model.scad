/**************************************************/
/*  This is a model of case for LimiFrog 0.2      */
/*  (the version shipped to Kickstarter backers)  */
/*                                                */
/* It is intended for a stacked configuration,    */
/* the battery lies between the board and the     */
/* display                                        */
/* The user may choose to enable/disable the      */
/* generation of some geometries (typically,      */
/* openings for connectors) by commenting out some*/
/* sections of this code.                         */
/* Wall thickness can also be configured.         */
/**************************************************/

/**************************************************/
/* The XY plane is parallel to the display,       */
/* Z axis is normal to the display.               */
/*                                                */
/* Code does the following:                       */
/* - describe 7 stacked "slices" along XY plane   */
/*   Each slice is described in 2D then extruded  */
/*    along Z axis                                */
/* - then add openings for the VL6180X sensor,    */
/*   for the microphone, for the extension port,  */
/*   for the program & debug connectros etc.      */
/* - finally lid is described                     */
/**************************************************/


/* == Construction Parameters  ===================*/ 

// You may want to change the following
Twall = 1;      // Wall thickness
Twall_lid = 1;  // Lid wall thickness 


// Better not change this unless you know what 
// you're doing

epsilon = 0.5;

Xboard=42.4; // real size 42.4 , will add some margin when computing Xin
Yboard=35;   // real size 34.6 + some margin

Yflex = 3;   // to accomodate curve of flexible connector from board to display

// Internal dimensions of the case :
Xin = Xboard + 0.6;  
Yin = Yboard + Yflex;

// Screen (i.e. display) dimensions + slight margin
// (real dimensions @ no margin = 35.8x30.8)
Xscreen = 36; 
Yscreen=31; 

// (X-)Margin that allows display to slide within the guide
ScreenMargin = 0.8;

// Distance between holes for extension port
// and holes for STM32/BME SWD ports
LR_Connectors_Dist = 15*2.54;


// Slice 1 parameters
h1 = 1; // = thickness of box bottom

// Slice 2 parameters
h2 = 1+0.8; // = thickness of PCB + bottom-side components

// Slice 3 parameters
h3 = 2; // = max thickness of top components

// Slice 4 parameters
h4 = 4.6; // = max battery thickness
// Side battery blockers suppressed

// Slice 5 parameters
h5 = 1.2; // = thickness of OLED supports (rails) - also allows to squeeze battery wires

// Dimesion of the rails over which the OLED display
// is expected to slide
X_OledSupport = 1.3;
Y_OledSupport_left = Yscreen;
Y_OledSupport_right = Yscreen*0.7;

// Slice 6 parameters
h6 = 1.7+0.3; // = thickness of OLED + slight margin
Ybutee = 5; Xbutee = 1; //dimensions of stop part that prevents OLED to slide too far inside the case
 
// Slice 7 parameters
h7 = Twall; // = thickness of box top
// dimensions of active region of the display:
Xdisplay_active = 28.6; 
Ydisplay_active = 22.7; 
// Translation factors to get the case opening to match the position of the display's active region
Display_LeftMargin = 3.9; 
Display_TopMargin = 5.9; 

// Parameters for openings for VL6180X and mic
Y_VL6180X_CornerOpen= 9.5+Yflex; 
Mic_opening_Xleft = 2.9;
Mic_opening_Xright =6.9;
Mic_opening_Z = 2;



/* == Now actually describe the case =============*/ 

// Generic module re-used multiple times below
module shell_TopView()
{
    difference()
    {
        translate([-Twall,0,0])
        square([Xin+2*Twall, Yin+Twall]);
        
        square([Xin, Yin]);
    }
}


// ----------------------------------------------
// Slice 1 (bottom of box)
module slice1_TopView()
{
        translate([-Twall,0,0])
        square([Xin+2*Twall, Yin+Twall]);
}
    
module slice1()
{
    linear_extrude(height=h1)slice1_TopView();
}
    

// ----------------------------------------------
// Slice 2 -- PCB + bottom components padding
module slice2_TopView()
{
    difference()
    {
        translate([-Twall,0,0])
        square([Xin+2*Twall, Yin+Twall]);
        
        square([Xin, Yboard]);
    }
}
module slice2()
{
    linear_extrude(height=h2)
        slice2_TopView();
}
    

// ----------------------------------------------
// Slice 3 -- Top components + some margin
module slice3_TopView()
{
    shell_TopView();
}
module slice3()
{
    linear_extrude(height=h3)
        slice3_TopView();
}
    

// ----------------------------------------------
// Slice 4 -- Battery side 
module slice4_TopView()
{
    shell_TopView();
 // no side blockers anymore
}
module slice4()
{
    linear_extrude(height=h4)
        slice4_TopView();
}
    

// ----------------------------------------------
// Slice 5 -- OLED support (rails)
module slice5_TopView()
{
    shell_TopView();
    square([X_OledSupport, Y_OledSupport_left]); 
    translate([Xscreen-X_OledSupport,0,0])
      square([Xin-Xscreen+X_OledSupport, Y_OledSupport_right]);
}
module slice5()
{
    linear_extrude(height=h5)
        slice5_TopView();
}
    
// ----------------------------------------------
// Slice 6 -- OLED guide (rails)
module slice6_TopView()
{
    difference()
    {
        translate([-Twall,0,0])
        square([Xin+2*Twall, Yin+Twall]);
        
        square([Xscreen+ScreenMargin, Yin]);
     /* ONLY IF NO TOP OPENING ON EXT PORT :   
        //Also,  remove material for cost optimisation :
        translate([Xscreen+ScreenMargin, 3, 0])
            square([Xin-(Xscreen+ScreenMargin),3]);
        translate([Xscreen+ScreenMargin, 9, 0])
            square([Xin-(Xscreen+ScreenMargin),3]);
        translate([Xscreen+ScreenMargin, 15, 0])
            square([Xin-(Xscreen+ScreenMargin),3]);
     */
    }
    
  translate([0, Yin-Ybutee, 0])
    square([Xbutee, Ybutee]);
    
}
module slice6()
{
    linear_extrude(height=h6)
        slice6_TopView();
}
    

// ----------------------------------------------
// Slice 7 -- box top with opening
module slice7_TopView()
{
    difference()
    {
        translate([-Twall,0,0])
        square([Xin+2*Twall, Yin+Twall]);
        
        translate([Display_LeftMargin, 
        Yin-(Ybutee+Display_TopMargin+Ydisplay_active),0])
        square([Xdisplay_active, Ydisplay_active]);
    }
    
    // "Fill" 2 opposite corners for aesthetic & robustness
    Screen_TopRightX = Display_LeftMargin+Xdisplay_active;
    Screen_TopRightY = Yin-(Ybutee+Display_TopMargin);
    Screen_BotLeftX = Display_LeftMargin;
    Screen_BotLeftY = Yin-(Ybutee+Display_TopMargin+Ydisplay_active);

    polygon(points=[ [Screen_TopRightX,Screen_TopRightY],
                     [Screen_TopRightX-2,Screen_TopRightY],
                     [Screen_TopRightX,Screen_TopRightY-2] 
                    ]);
    polygon(points=[ [Screen_BotLeftX,Screen_BotLeftY],
                     [Screen_BotLeftX+2,Screen_BotLeftY],
                     [Screen_BotLeftX,Screen_BotLeftY+2] 
                    ]);

}
module slice7()
{
    linear_extrude(height=h7)
        slice7_TopView();
}
    

// ----------------------------------------------
// Assemble the above slices into complete case :

module box_tmp()
{
  union()
  {
    slice1();
    
    translate([0, 0, h1])
    slice2();

    translate([0, 0, h1+h2])
    slice3();
    
    translate([0, 0, h1+h2+h3])
    slice4();

    translate([0, 0, h1+h2+h3+h4])
    slice5();

    translate([0, 0, h1+h2+h3+h4+h5])
    slice6();

    translate([0, 0, h1+h2+h3+h4+h5+h6])
    slice7();
  }
}



/* == Add various openings to the case   ==========*/ 


module VL6180X_CornerCut()
{
    translate([Xscreen+ScreenMargin-0.01, Yin-Y_VL6180X_CornerOpen, h1+h2+h3]) 
      cube([Xin+Twall-(Xscreen+ScreenMargin)+epsilon, Y_VL6180X_CornerOpen+Twall+epsilon, h7+h6+h5+h4]);
}



module Mic_Opening()
{
  translate([Mic_opening_Xleft, Yin-epsilon, h1+h2])
     cube([Mic_opening_Xright-Mic_opening_Xleft, Twall+2*epsilon , Mic_opening_Z]);
}


module stm32SWD_Opening() //but posn5 (Boot0) not accessible
{
   X_hole = 3;
   Y_hole = 5*2.54 + 2.54/4;  // header pitch=2.54 mm
   translate([0,0,-2])
      cube([X_hole,Y_hole,5]);
    
   // Mark position 1
   translate([6, Y_hole-2.54/2, -2]) 
     linear_extrude(height=5)
      circle(d=1.5, $fn=16);
      
}

module bleSWD_Opening()
{
   X_hole = 3;
   Y_hole = 4*2.54+2.54/4;  // header pitch=2.54 mm
   translate([0,2+8*2.54,-2])
      cube([X_hole,Y_hole,5]);
}

module ExtensionPins_Opening() 
{
   X_hole = 3;
   Y_hole = 10*2.54 + 2.54 + 2.54/2;  // header pitch=2.54 mm
   translate([LR_Connectors_Dist, 0, -2]) 
     cube([X_hole,Y_hole,5]);
}

module ResetButton_Opening() 
{
   X_RstBut = 5;
   Y_RstBut = 5;  
   translate([LR_Connectors_Dist-X_RstBut, 9*2.54, -2])
     cube([X_RstBut,Y_RstBut,5]);
}

module ExtensionPins_TopOpening() 
{
   X_hole = 3;
   Y_hole = 10*2.54 + 2.54 + 2.54/2 -2;  
    
    translate([LR_Connectors_Dist, 2, h1+h2+h3+h4])
   cube([X_hole,Y_hole,5]);

}

module SideOfTopOpening()
{
    SideThickness = 1.5;
    
    translate([Xscreen+ScreenMargin, Yin-Y_VL6180X_CornerOpen-SideThickness, h1+h2+h3+h4])
    cube([ Xin+Twall-(Xscreen+ScreenMargin), SideThickness, h7+h6+h5 ]);
}
SideOfTopOpening();


// We are doing the actual openings here
// You may comment out those you don't want

module box()
{
union()
{
  difference()
  {
    box_tmp();
    
    VL6180X_CornerCut();
    Mic_Opening();
    stm32SWD_Opening();
    bleSWD_Opening();
    ExtensionPins_Opening();
    ExtensionPins_TopOpening();
    ResetButton_Opening();
  }  
  
  }
}

box();


/* == Now the LID  ============================*/ 

small_delta=0.25; //was 0.3
Xlid_in = Xin+2*Twall + small_delta;
Ylid_in = 5;
Zlid_in = h1+h2+h3+h4+h5+h6+h7 + small_delta;

Xlid_out = Xlid_in+2*Twall_lid;
Ylid_out = Ylid_in +Twall_lid;
Zlid_out = Zlid_in+2*Twall_lid;


lid_shift = 1;
module lid()
{
difference()
    {
      translate( [-Twall-Twall_lid, -Twall_lid, -Twall_lid] )
        cube([Xlid_out, Ylid_out, Zlid_out]);   
       
      translate( [-Twall, 0, 0] )
        cube([Xlid_in, Ylid_in, Zlid_in]);   
    }
}


translate([-small_delta/2,-(Ylid_in+lid_shift),0])
  lid();


/* The following code joins the lid and the box   */
/* by a thin part that would be cut off after 3D  */
/* printing. This is only to allow the box and    */
/* the lid to be printed as a single part at      */
/* e.g Sculpteo                                   */
/* This option is OFF by default                  */

/*

Tlink=0.8; // minimum thickness for 3D printer
Wlink = h2+h3+h4+h5+h6;
module link()
{
  translate([0,0,h1])
    linear_extrude (height=Wlink)
      polygon(points=[
       [-Twall,0],
       [-Twall-Twall_lid,-lid_shift],
       [-Twall-Twall_lid+Tlink, -lid_shift], 
       [-Twall+Tlink,0] ] );
}

link();
translate([-Twall+Xin+Twall ,0,0])
  mirror([1,0,0]) link();

*/
