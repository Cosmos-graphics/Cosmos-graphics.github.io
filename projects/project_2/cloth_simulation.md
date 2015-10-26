---
title: 3D Cloth(Mass-spring)
category: '2'
id: cloth_mass_spring
image: ../../assets/project_2_cloth_sim.gif

running_status: Running with GIGABYTE p35k at 105 ~ 145 fps.

implementation_details: Cloth is implemented by Processing 3.0 version. User could control the action of both ball and cloth generated in the scene through keyboard. And the angle of view could also be manipulated by mouse. We chose mass-spring method to implement our cloth. Implemented both cloth's and ball's collision with boundary.

problem_faced: Finding suitable spring constant(ks) and damping factor(kd) which may result in undesirable animation and action of cloth when set those to unfitting values.<br><br>At the start in understanding how to simulate mass-spring system through code. It is hard to convert formula to real code.<br><br>Got confused by which functionality we should implement. There is no specific indication about which functionality we have to implement.<br><br>Tried drag and done with processing calculating air force. However, do not have enough time to put it into actual implementation.<br><br>Tried using spatial-data structure to optimize it but failed to get in actual implementation.

key_points_illustrated: Cloth Simulation(Mass-sping)<br>Two-way coupling object-simulation coupling<br>User interactive with system (Keybased control of adding directional speed to either ball or cloth)<br>3D user controlled camera with freedom of zoom, translate and rotate.<br>Real-time rendering<br>Textured cloth<br>

download: https://github.com/Cosmos-graphics/Cosmos-graphics.github.io/tree/master/ProcessingCode/project_2_cloth_simulation(mass-spring)/cloth_simluation

---
