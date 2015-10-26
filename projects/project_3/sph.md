---
title: SPH
category: '3'
id: sph
image: ../../assets/project_2_sph.gif

running_status: Running with Macbook pro retina 13 at 60 fps when under a few hundred particles. Framerate significantly drops when particle numbers exceed a few thousand to around 10 fps with ellipse and 30 fps with points.

implementation_details: SPH is inspired by the animation showed during class from <a href="https://www.youtube.com/watch?v=0bL80G1HX9w"> here</a>. We implemented a simple 2D sph with cells of width 10. And we had a particle system that can be turned on and off by pressing "s". And a toggle to show particles as circles or points with hotkey "p". <br> We encountered a lot of problems in this animation. The biggest problem is when we first implemented the math, we observed a stange pattern. The particles at the very bottom does not act as expected. After digesting the equations used, we found out that the particles at the very bottom will only be taking forces from the upper and left or right particles. So it is impossible for them to have a velocity that is towards the top. And as a result every particle that makes to the bottom it will stay in the bottom. This leads to our animation very unstable and every particle that enters the bottom does not leave. To solve this, we considered adding a random offset at each time step that the particle will move up/down/left/right 2 pixels at a possiblity of 20%. After adding this offset everythings looks way better.

key_points_illustrated: Particle system integration with 2D SPH fluid sim<br>User interactive with system (Keybased control particle system)<br>Real-time rendering<br>

download: ../../ProcessingCode/project_2_sph/project_2_sph.pde

---
