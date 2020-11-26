# Highlighting the dangers of self driving cars through Agent-Based Modelling
<img src = "https://thumbor.forbes.com/thumbor/fit-in/1200x0/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fimageserve%2F5f3fe895e0243aa68130748d%2F0x0.jpg" width = "650px" >
This was a project I built while at University in the relatively obscure programming language NetLogo. The purpose of this project was to simulate the behaviours of 
self driving cars in the real world in the presence of regular cars and pedestrians. As cars level of autonomy increase they behave more intelligently and avoid obstacles and pedestrians better than regular cars. The results from the simulation were also recorded and are displayed to the user.

# Requirements 

- To be able to display the behaviours of self driving cars through agent based modelling
- To be able to display the behaviours of none self driving cars through agent based modelling
- To be able to mimic the movements of pedestrians in a typical metropolitan setting
- To be able to allow the user to change the level of autonomy of the cars and analyse their changes
- To be able to record results based on the simulation


# The Environment

<img src = "https://i.imgur.com/321ZklF.png" width = "650px" >

The simulation imitates a simple road with a small passage for the pedestrians to pass along, and a taffic light that changes in intervals, as the levels of autonomy change the way the cars behave when faced with a red light change, the model tries to imitate how the self driving cars would behave if they are in a compromised position through hacking, so while a low level autonomous car would drive uncontrollably if compromised a higher level car would still behave erratically but on a lesser scale, the level of autonomy currently ramges from 0 to 5, 5 being the highest.


# Brief run Level 3
<img src = "https://media.giphy.com/media/lPwcUi3kNyBD5wwJt3/giphy.gif" width = "650px" >


# Brief run Level 5

<img src = "https://media.giphy.com/media/kPfU6tHETmNYfk3T2m/giphy.gif" width = "650px" >


# Code Snippets

```
These respective breed commands creates an set of all the breeds used in the simulation, an agentset can be seen as a collection of similar items and each item is known as the breed name.
;For example every item in the trees breed agentset is a tree.
breed [people person]
breed [cars car]
breed[houses house] ;
breed[trees tree]
breed[lights light]
breed[fires fire]
cars-own [
speed ; the current speed of the car
top-speed ; the maximum speed of the car
target-lane ; the desired lane of the car
patience ; the cars current level of patience
current-autonomy-level ; tracks the cars current level of autonomy
autonomous? ; Boolean variable to check if the car is autonomous or not
Law-Abiding? ; Checks if the car stops at a red light
max-patience ;The max patience for the cars, this is 100.
acceleration ;The rate at which cars accelerate
deceleration ;The rate at which cars decelerate
]
```

```
 ask n-of changed-number cars ;The use of n-of here was influence from this suggestion on stack overflow, linked here.
  ;https://stackoverflow.com/questions/60636497/how-to-change-the-colour-of-random-turtles-in-netlogo

 [ if autonomy-level = 0 [set color blue set current-autonomy-level 0  set autonomous? true ]
   if autonomy-level = 1 [set color blue + 1.0 set current-autonomy-level 1 set autonomous? true]
   if autonomy-level = 2 [set color cyan set current-autonomy-level 2 set autonomous? true]
   if autonomy-level = 3 [set color turquoise set current-autonomy-level 3 set autonomous? true]
   if autonomy-level = 4 [set color green  set current-autonomy-level 4 set autonomous? true]
   if autonomy-level = 5 [set color lime   set current-autonomy-level 5 set autonomous? true ]

 ]
end

to set-patience

  ;This procedure sets the patience of the autonomous cars.

 ask cars with [autonomous? = true]
 [
   if autonomy-level = 0 [set current-autonomy-level 0 set patience (30 + random 15)]
   if autonomy-level = 1 [set current-autonomy-level 1 set patience (40 + random 15)]
   if autonomy-level = 2 [set current-autonomy-level 2 set patience (40 + random 15)]
   if autonomy-level = 3 [set current-autonomy-level 3 set patience (45 + random 15)]
   if autonomy-level = 4 [set current-autonomy-level 4 set patience (65 + random 15)]
   if autonomy-level = 5 [set current-autonomy-level 5 set patience (85 + random 15)]


 ]
end
```
