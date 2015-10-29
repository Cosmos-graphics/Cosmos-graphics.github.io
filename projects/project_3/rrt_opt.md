---
title: RRT Optimal
category: '3'
id: rrt_opt
image: ../../assets/project_3_rrt_opt.gif

running_status: Real-time implementation. FrameRate set to fixed at 60.

implementation_details:
- This animation is created using Optimal Rapidly exploring random tree(Optimal RRT). It works as generating a random vertice in the graph and then generate new vertice according to this random vertice and eta(constant). And detecting whether there is a collision with obstacles. If not, add this new vertice to the graph and generate collection of near vertices according to this new vertice. Next step, optimize edges in the collection of edges of RRT by evaluating the cost of new point and related edges and near vertices one by one. Else, give up this vertice. 

key_points_illustrated: 
- <ul> RRT </ul>
- <ul> Visualization of environment </ul>
- <ul> Visualization of start and goal position (Colored) </ul>
- <ul> Visualization of the roadmap </ul>
- <ul> Animation of agent taking path from start to goal </ul> 

problem_faced:
- <ul>Detect collision between new edge with obstacles</ul>
- <ul>Determine suitable gamma value</ul>
- <ul>Determine suitable initial eta value</ul>


download: ../../ProcessingCode/project_3_RRT_opt/project_3_RRT_opt.pde

---