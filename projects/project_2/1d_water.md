---
title: 1D Water
category: '2'
id: 1d_water
image: ../../assets/project_2_1D_water.gif

running_status: Running with Macbook pro retina 13 at 180 ~ 185 fps.

implementation_details: 1D water is implemented in 2D in processing. The animation will start after the user clicks in the screen. And after that clicking in the screen will result in a water drop with height of the mouse at the location. The initial water status is a s-function(Sigmoid function) that is configured to shape perfectly for the screen and for better illustration. The shallow water equation is inspired from the website mentioned above. <br>The main difficulty when we faced this problem was that the equations are in partial differential forms and we did not have the knowlege of such equations. We googled online for better understanding and found the paper mentioned before and after hours of trying and test, it now works pretty good. We are satisfied with the results except for the waved created by the water drop. We looked into a lot of things that could effect this but due to time limit we did not suceed in fixing it.

key_points_illustrated: 1D Shallow Water Equation<br>Semi Implicit Integrator<br>User interactive with system<br> Real time sound effect based on event<br>

download: ../../ProcessingCode/project_2_1D_water/project_2_1D_water.pde

---
