---
title: RRT
category: '3'
id: rrt
image: ../../assets/project_3_rrt.gif

running_status: Real-time implementation. FrameRate set to fixed at 60.

implementation_details:
- This animation is created using Optimal Rapidly exploring random tree(RRT). It works as generating a random vertice in the graph and then generate new vertice according to this random vertice and eta(constant). And detecting whether there is a collision with obstacles and boundary. If not, add this new vertice to the graph and add edge from nearest to this new vertice to the collection of edges. Else, give up this vertice. Add vertice and optimize graph until find the path from start to the final. Finally, animate agent.

key_points_illustrated: 
- <ul> RRT </ul>
- <ul> Visualization of environment </ul>
- <ul> Visualization of start and goal position (Colored) </ul>
- <ul> Visualization of the roadmap </ul>
- <ul> Animation of agent taking path from start to goal </ul> 

problem_faced:
- <ul>Detect collision between new edge with obstacles</ul>
- <ul>Determine suitable initial eta value</ul>


download: ../../ProcessingCode/project_3_RRT/project_3_RRT.pde

---


