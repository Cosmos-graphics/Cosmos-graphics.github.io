---
title: Fire Simulation
category: '1'
id: fire_simulation
image: ../../assets/project_1_fire_simulation.gif
running_status: Running with Macbook pro retina 13 at around 15~20 fps.
implementation_details:  Fire is a 3D particle system that simulates fire. The spawn rate for particles is 2000 per sec and there are drawn as 2D circles in the animation. The particles are given random velocity at first, but as time pass they eventually come to middle and create a fire that looks like real. The circles drawn are transparent so we can have a 3D feel. After the particle dies, it became a new particle that now simulates smoke. And this creates a smoke like feeling at the top of the fire. This animation has implemented a simpler camera control system then the bouncing ball. It uses keyboard 'WASD' to move camera and arrow keys to move the view angle.
key_points_illustrated: 
download: ../../ProcessingCode/project_1_fire_simulation/project_1_fire_simulation.pde

---
