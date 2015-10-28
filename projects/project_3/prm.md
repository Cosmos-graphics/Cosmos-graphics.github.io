---
title: Path Planning PRM
category: '3'
id: prm
image: ../../assets/project_3_prm.gif

running_status: Everything is in real time. FrameRate set to fixed at 60 since nothing is very hard to calculate.

implementation_details:
- This path planning animation is created using PRM and A*. It works as adding a point to the graph and check if the point is valid, then add edges that are less than a constant length and then check if the edge is valid. Repeating this process untill a path to the goal if found by A* search. The user can add obstacles to the graph at any time. When an obstacle is added, edges and vertices that are violated is deleted. The user also have the ability to change the start and end node at any time. The heristics funtion we used is a simple function that returns the distance between the current vertice and the end vertice. 

key_points_illustrated: 
- <ul> PRM </ul>
- <ul> Visualization of environment </ul>
- <ul> Visualization of start and goal position (Colored) </ul>
- <ul> Visualization of the roadmap </ul>
- <ul> Animation of agent taking path from start to goal </ul> 
- <ul> Multiply Obstacles </ul>
- <ul> User interaction (add obstacle and change start and goal) </ul>
- <ul> Animate the agent as a walking virtual character [Misty will change the walk direction as the slope changes. Due to that we could not find a 8 direction sprite sheet, the animation is limited to 4 directions.]</ul>
- <ul> A* search (With A* the route is found instant, UCS are significant slower compared to A*)</ul>

problem_faced:
- We did not face any large problems. But we encoutered a lot of small problem that are most due small errors. However among all of them there are a few that are worth noticing. The first problem we faced was to detect if an edge is colliding with the obstacle. This was quickly fixed after doing some google search and reading some mathematical solutions. The results are satisfiying. Another problem that is worth noticing is details about A* search. We are familiar with A* search in lisp, but we never implemented it in other languages. So a lot of details that in lisp is easily dealed with, java was not. So we spend a lot of time trying to make the code from lisp into java. After numerous trials we finally have a working version. 

download: ../../ProcessingCode/project_3_path_planning/project_3_path_planning.pde

---
<li>
    <div class="collapsible-header"> Controls </div>
    <div class="collapsible-body">
		<p>
			We implemented a mode based control system, after any operation, the mode will be reset to mode 0 which is the default mode. <br>
			<strong> Modes </strong> <br>
			<table>
			<tr> <td> 0 </td>  	<td> Normal mode      		</td>  <td>shortcut: na </td>  </tr>
			<tr> <td> 1 </td>		<td> replace start mode 	</td>  <td>shortcut: s 	</td>  </tr>
			<tr> <td> 2 </td> 	<td> replace end node 		</td>  <td>shortcut: g 	</td>  </tr>
			<tr> <td> 3 </td> 	<td> add vertice 			</td>  <td>shortcut: v 	</td>  </tr>
			<tr> <td> 4 </td> 	<td> agent start to move 	</td>  <td>shortcut: p 	</td>  </tr>
			<tr> <td> 5 </td> 	<td> reset agent location 	</td>  <td>shortcut: r 	</td>  </tr>
			<tr> <td> 6 </td> 	<td> add obstacles 			</td>  <td>shortcut: o 	</td>  </tr>
			<tr> <td> 7 </td>		<td> generate a valid map 	</td>  <td>shortcut: m 	</td>  </tr>
			<tr> <td> 8 </td> 	<td> clear the map 			</td>  <td>shortcut: c 	</td>  </tr>
			</table>
		</p>
	</div>
</li>
<li>
	<div class="collapsible-header"> Resources Used </div>
	<div class="collapsible-body">
		<p>
			Thanks for Lucygirl88 from deviantart for the sprite sheet we used for the animated walking agent.<br>
			<a href="http://luckygirl88.deviantart.com/art/Pokemon-BW-Misty-Sprite-Sheet-268364830"> deviantart</a>
		</p>
	</div>
</li>
<li>
<div class="collapsible-header"> Video </div>
    <div class="collapsible-body">
		<p>
		    <video width="400" controls>
		        <source src="../../assets/project_3_prm.mov" type="video/mp4">
		    Your browser does not support HTML5 video.
			</video>
	</div>
</li>
