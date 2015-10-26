---
title: 2D Water
category: '2'
id: 2d_water
image: ../../assets/project_2_2D_water.gif

running_status: Running with Macbook pro retina 13 at 180 ~ 185 fps.

implementation_details: 2D water is implemented in 3D in processing. Pressing 's' will start and pause the animation. Pressing 'd' will release a water drop at the middle of the water surface. The inital configuration is a function that is based on the position of x and z coordinates.<br>We incountered many problems in this animation. We managed to fix some, however, we lack the time and energy to do something more awesome. One of the problems we faced was transforming the 1D shallow water equation into 2D. We tried many fancy version of the equations, but they did not look good. So we went with a easier way for just considering the 4 points near by and the results were good. Another problem we had and we did not have the time to fix it was when adding lights and fill the quads with color, every will look super bad. The lights are very confused so each cell will either be dark or light. And since we only have a limited number of cells the lights looked like we have mosaic all over the place and it is kind of gross. 

key_points_illustrated: 2D Shallow Water Equation<br>Eulerian Integrator<br>User interactive with system (Keybased control of start, pause and water drop)<br>3D user controlled camera with freedom of zoom, translate and rotate.<br>	Real-time rendering<br>

download: ../../ProcessingCode/project_2_2D_water/project_2_2D_water.pde

---
