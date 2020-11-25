;These are the global variables for the simulation.
globals [
lanes ;Reports the amount of lanes
y-values ;These are the y cooridantes of the people agents
autonomous-death-toll ;The total amount of deaths recorded by autonomous cars.
regular-death-toll ;The total amount of deaths recorded by regular cars.
totalDeaths ;The sum of the autonomous death toll and the regular death toll
]

;These respective breed commands creates an set of all the breeds used in the simulation, an agentset can be seen as a collection of similar items and each item is known as the breed name.
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


;These are variables specific to the lights breeds are placed here.
lights-own

[
time-passed ;Checks the amount of time elapsed as lights change periodically.
colors-list ;The list of colors the light agent can be, red, yellow and green.
]

;Variables specific to the fire agent are placed here.
fires-own

[
ticksPast ;This keeps track of the amount of ticks past, the fire agent dies after a certain amount of ticks.
]


;The setup procedure is called when the setup button is clicked.
;The setup procedure set the shapes of all the agents, the shape of the cars lights and fires are fixed but the shape of the people trees and houses can be any one of the options listed.
to setup
clear-all
set-default-shape cars "car"
set-default-shape people one-of ["person police" "person police" "person soldier" "person construction"]
set-default-shape houses one-of [ "house bungalow" "house ranch" "house colonial" "house efficiency" "house two story" "factory"]
set-default-shape trees one-of ["tree" "tree pine" "plant"]
set-default-shape lights "lights"
set-default-shape fires "fire"
draw-road ;This procedure draws the road
draw-footpath ;This procedure draws the footpath
create-pedestrians ;This proceudre creates the pedestrians and places them at the bottom right corner
create-or-remove-cars ;This procedure creates or remove car agents.
add-trees-and-houses ;This procedure adds trees and houses to the left and right areas of the simulation
addLights ; This procedure places the light agent on the road
linesAcross ;This procedure draws lines across the road
set-autonomy-level ;This procedure sets the current autonomy level of the car

;The ask command can be used for agentsets or agents, in this case it asks or rather sets the max patience, acceleration and deceleration of the cars.
;It also sets cars to be intially all be law abiding, and then asks 2 cars from both autonomous and non-autonomous cars to not be law abiding.
;After these 4 cars die, 25% of cars available will be randomly picked to not be law abiding
ask cars
[
set max-patience 100
set acceleration 0.0020
set deceleration 0.02]
ask cars [ set Law-Abiding? true ]
ask n-of 2 cars with [autonomous? = true][set Law-Abiding? 0 ]
ask n-of 2 cars with [autonomous? = 0][set Law-Abiding? 0 ]

reset-ticks ;resets the ticks and start.
tick
end

;The go proceudre keeps running until an end condition is reached. It also controls the flow of color change of the traffic lights and the movements of the cars and people.
to go
control-traffic-lights
set-patience
;Asks cars to move forward and choose their target lane when available to them.
ask cars [ move-forward ]
ask cars with [ patience <= 0 ] [ choose-new-lane ]
ask cars with [ ycor != target-lane ] [ move-to-target-lane ]
;After a collision the fires get removed after 60 ticks.
ask fires[ if ticks - ticksPast > 60 [die]]

obeyLights ;This procedure tells cars to stop at the traffic light when its red
speedOnRed ;This sets the speed of the randomly selected non law abiding cars.
walk-forward ;This procedure tells the people to move forward in an upward direction
continue ;This procedure tells the people to move forward in a downward direction
driveSafe ;This procedure regulates the speed of the cars in normal motion
record-accidents ;This proceudre keeps tracks of the accidents that have occured
update-cars ;This sets 25% of the cars available to not be law-abiding.


  ;The end condition, if the total death toll is equal to 15 or ticks goes past 7000 or there's only 1 car available after the inital 4 to be non law abiding the simulation stops.

  set totalDeaths (autonomous-death-toll  + regular-death-toll)

 if (totalDeaths = 15) or (ticks > 7000) or (count cars * 0.25 < 1)

 [print "The simulation has ended" stop ]

tick
end




;This procedure was made available in the original traffic 2 lanes model and is being reused in this simulation.
;This proceudre creates the cars on the road and sets their speed to 0.5
to create-or-remove-cars

; make sure we don't have too many cars for the room we have on the road
let road-patches patches with [ member? pycor lanes ]
if number-of-cars > count road-patches [
set number-of-cars count road-patches

]

create-cars (number-of-cars - count cars) [
set color car-color
move-to one-of free road-patches
set target-lane pycor
set heading 90
set top-speed 0.5 + random-float 0.5
set speed 0.5





]
end


;This procedure sets the colour of the autonomous agents and sets their boolean variable tracker to true, indicating that they are in-fact autonomous.

to set-autonomy-level
 let changed-number number-of-cars / 2


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

;This procedure creates the people on their respective positons.
to create-pedestrians
 set y-values (list -8 -7 -6 -5 -4)
 create-people 5 [insert-people]
end
;This procedure chooses one of the multiple people shapes and sets them as that and places them at the bottom right.
;The idea to make the people agents a breed and making the y-values into a global variable was influenced by this linked here https://stackoverflow.com/questions/60512724/netlogo-code-adding-people-on-the-same-patch
to insert-people
 set shape one-of ["person police" "person police" "person soldier" "person construction"]
 let remove-index random length y-values
 set ycor item remove-index y-values
 set xcor 20
 set y-values remove-item remove-index y-values

end

;This reports when a road patch is free, this proceudre was part of the original procedures in the Traffic 2 lanes model.
to-report free [ road-patches ]
let this-car self
report road-patches with [
not any? turtles-here with [ self != this-car ]
]
end
;This procedure was made available in the original traffic 2 lanes model and is being reused in this simulation.

to draw-road
ask patches [

set pcolor black
]
ask patches
[ if pycor <= -0 ;; patches on the right side
[ set pcolor black ] ] ;; of the view turn green
set lanes n-values number-of-lanes [n -> number-of-lanes - (n * 2) - 1 ]
ask patches with [ abs pycor <= number-of-lanes ] [
; the road itself is varying shades of grey
set pcolor grey - 2.5 + random-float 0.25
]
draw-road-lines
end



;This procedure adds trees and houses to the sides of the simulation, the left side and rigbt side.
to add-trees-and-houses

ask patches with [pcolor != 19] [
   if count neighbors with [pcolor = black] = 8 and not any? turtles in-radius 2 [
     sprout-houses 1 [
       set shape one-of [ "house bungalow" "house ranch" "house colonial" "house efficiency" "house two story" "factory"]
       set size 3
       stamp
     ]
   ]
 ]
ask patches with [pcolor != 19] [
   if count neighbors with [pcolor = black] = 8 and not any? turtles in-radius 1[
       sprout-trees 1 [
         set shape one-of ["tree" "tree pine" "plant"]
         set size 2
         set color green
         stamp
       ]

   ]
 ]
end
;This procedure was made available in the original traffic 2 lanes model and is being reused in this simulation.
;This procedure simply draws lines across the road.
to draw-road-lines
let y (last lanes) - 1 ; start below the "lowest" lane
while [y <= first lanes + 1 ] [
if not member? y lanes [
; draw lines on road patches that are not part of a lane
ifelse abs y = number-of-lanes
[ draw-line y yellow 0 ] ; yellow for the sides of the road
[ draw-line y white 0.5 ] ; dashed white between lanes
]
set y y + 1 ; move up one patch
]
end

to draw-line [ y line-color gap ]
; We use a temporary turtle to draw the line:
; - with a gap of zero, we get a continuous line;
; - with a gap greater than zero, we get a dasshed line.
create-turtles 1 [
setxy (min-pxcor - 0.5) y
hide-turtle
set color line-color
set heading 90
repeat world-width [
pen-up
forward gap
pen-down
forward (1 - gap)
]
die
]
end

;This procedure draws a footpath for the people
to draw-footpath
ask patches
[ if pxcor >= 19 ;; patches on the far right side
[ set pcolor grey - 1.5 ] ]

end

;This procedure draws lines on the road
to linesAcross
 ask patches with [pxcor >= 19 and pycor > -4][
   set pcolor grey - 1.5
   sprout 1[
   set shape "road2"
   set color grey - 1
   set heading 0
 stamp die
 ]
 ]
end

;This adds the traffic light to the simualtion.
to addLights
 ask patches with [(pycor = -4) and pxcor = 19] [
 sprout-lights 1 [
 set color green
 set shape "lights"
 set colors-list [red yellow green]
 set time-passed 0
 ]
 ]
end



;This procedure was made available in the original traffic 2 lanes model and is being reused in this simulation.
;This instructs the cars to move forward
to move-forward

set heading 90
speed-up-car ; we tentatively speed up, but might have to slow down
let blocking-cars other cars in-cone (1 + speed) 180 with [ y-distance <= 1 ]
let blocking-car min-one-of blocking-cars [ distance myself ]
if blocking-car != nobody [
; match the speed of the car ahead of you and then slow
; down so you are driving a bit slower than that car.
set speed [ speed ] of blocking-car
slow-down-car
]

forward speed



end




;This proceudre tells the people to be in constant motion as they move up and down the walkpath, when they reach a certain patch they turn and continue walking till the simulation comes to an end.
to walk-forward
 ask one-of people
 [ if not any? (lights with [color = green or color = yellow]) and (pxcor = 20) or (pxcor = 20 and pycor >= 3)
   [ set heading 0
     forward 1

     rotate-left ]
    ]
end


to rotate-left

  ask one-of people
 [if (pxcor = 20 and pycor = 8)
   [lt 90 forward 1]
   ]
end

to continue
ask one-of people
[if not any? (lights with [color = green or color = yellow]) and (pxcor = 19)
   [set heading 0
     forward -1
     rotate-right
      ]
   ]
end
to rotate-right

 ask one-of people

  [if (pxcor = 19 and pycor = -8 )

   [ rt 90 forward 1]


 ]
end







;This procedure instructs cars to move when the light is green or yellow but stop when the light is red.
to obeyLights

 ask cars

 [ifelse not any? (lights) with [color = red] [move-forward] [set speed 0]

 ]


end


;This procedure gives the respective speeds of the non law abiding cars, this reduces as the autonomy level increases.
to speedOnRed



   ask cars with [Law-Abiding? = 0]

 [



   if (autonomous? =  0   and any?(lights) with [color = red]) [fd 1.2]
   if (autonomy-level = 0 and (autonomous? = True) and any?(lights) with [color = red]) [fd 1.2]
   if (autonomy-level = 1 and any?(lights) with [color = red]) [fd 0.8]
   if (autonomy-level = 2 and any?(lights) with [color = red]) [fd 0.35]
   if (autonomy-level = 3 and any?(lights) with [color = red]) [fd 0.3]
   if (autonomy-level = 4 and any?(lights) with [color = red]) [fd 0.2]
   if (autonomy-level = 5 and any?(lights) with [color = red]) [fd 0.1]



   ]
end


;This procedure keeps track of the collisions between both sets of cars cars and people and sprouts fire on the location of the accident.

to record-accidents

 let collisions patches with [any? cars-here with [speed > 0 or Law-Abiding? = 0] and any? people-here] ;The first 2 lines of this procedure was influenced by the suggestion made here, linked here.
  ;https://stackoverflow.com/questions/61164581/how-to-check-if-2-different-breeds-of-turtles-are-on-the-same-patch
   if any? collisions
[
   ask collisions
 [



     set autonomous-death-toll autonomous-death-toll + count people with [any? cars-here with [autonomous? = true]]
     set regular-death-toll regular-death-toll + count people with [any? cars-here with [autonomous? = 0]]


     sprout-fires 1[
       set shape "fire"
       set size 1
       set ticksPast ticks
     ]

     ask people-here
     [die]

     ask cars-here
     [die]


 ]

   if count people = 0
   [create-pedestrians]


 ]


end


;This procedure updates randomly picks cars whenever there is only 1 law abiding car available to 25% of the total count of cars.

to update-cars

 ask cars
 [
  if count cars with [Law-Abiding? = 0] = 1

  [ ask n-of(count cars * 0.25) cars

   [set Law-Abiding? 0]

 ]]


end

;This procedure controls the speed of the cars as they drive and are in contact with people. This is improved as the autonomy level increases.
 to driveSafe

 ask cars
[

    if(any? people in-cone 1 45) and any? (lights) with [color != red] and autonomous? = 0[


 set speed 0.008

   ]


   if(any? people in-cone 1 45) and any? (lights) with [color != red] and autonomy-level = 1 and autonomous? = true [


 set speed 0.0009

   ]


    if(any? people in-cone 2 45) and any? (lights) with [color != red] and autonomy-level = 2 and autonomous? = true[


      set speed 0.00007

   ]

  if(any? people in-cone 2 45)or (any? people in-cone 2 45) and any? (lights) with [color != red] and autonomy-level = 3 and autonomous? = true[


   set speed 0.00008

   ]

   if(any? people in-cone 2 45) or (any? people in-cone 2 45) and any? (lights) with [color != red] and autonomy-level = 4 and autonomous? = true[


   set speed 0.000007

   ]

    if(any? people in-cone 2 45) or (any? people in-cone 2 45) and any? (lights) with [color != red] and autonomy-level = 5 and autonomous? = true[


   set speed 0.000007

   ]

 ]
end





;This procedure was made available in the original traffic 2 lanes model and is being reused in this simulation.
;This procedure slows down the car
to slow-down-car
set speed (speed - deceleration)
if speed < 0 [ set speed deceleration ]



end
;This procedure was made available in the original traffic 2 lanes model and is being reused in this simulation.
;This procedure speeds up the car
to speed-up-car
set speed (speed + acceleration)
if speed > top-speed [ set speed top-speed ]
end




;This procedure was made available in the original traffic 2 lanes model and is being reused in this simulation.
to choose-new-lane


; Choose a new lane among those with the minimum
; distance to your current lane (i.e., your ycor).
let other-lanes remove ycor lanes
if not empty? other-lanes [
let min-dist min map [ y -> abs (y - ycor) ] other-lanes
let closest-lanes filter [ y -> abs (y - ycor) = min-dist ] other-lanes
set target-lane one-of closest-lanes
set patience max-patience
  ]
end

;This procedure was made available in the original traffic 2 lanes model and is being reused in this simulation.
;This moves cars to their target lane
to move-to-target-lane
 set heading ifelse-value (target-lane < ycor) [ 180 ] [ 0 ]
 let blocking-cars other cars in-cone (1 + abs (ycor - target-lane)) 180 with [ x-distance <= 1 ]
 let blocking-car min-one-of blocking-cars [ distance myself ]
 ifelse blocking-car = nobody [
   forward 0.2
   set ycor precision ycor 1 ; to avoid floating point errors
 ] [
   ; slow down if the car blocking us is behind, otherwise speed up
   ifelse towards blocking-car <= 180 [ slow-down-car ] [ speed-up-car ]
 ]
end

;This procedure was made available in the original traffic 2 lanes model and is being reused in this simulation.
;These two procedures report the x and y coordinate of the agent in question.
to-report x-distance
report distancexy [ xcor ] of myself ycor
end

;This procedure was made available in the original traffic 2 lanes model and is being reused in this simulation.
to-report y-distance
report distancexy xcor [ ycor ] of myself
end





;This procedure sets the time interval between the different colors of the traffic light.
to control-traffic-lights

ask lights
  [
  set time-passed time-passed + 1


   let temp 0
   if item 0 colors-list = green [set temp 105]
   if item 0 colors-list = yellow [set temp 15]
   if item 0 colors-list = red [set temp 75]

   if time-passed = temp
  [
     set time-passed 0
     set colors-list lput first colors-list colors-list
     set colors-list remove-item 0 colors-list
     set color first colors-list
   ]
 ]
 tick


end





;This procedure was made available in the original traffic 2 lanes model and is being reused in this simulation.
;This procedure reports the car color
to-report car-color

report one-of [ orange red yellow ] + 1.5 + random-float 1.0
end
;This procedure was made available in the original traffic 2 lanes model and is being reused in this simulation.
;This proceudre reports the number of lanes
to-report number-of-lanes

report 3
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
1038
359
-1
-1
20.0
1
10
1
1
1
0
1
0
1
-20
20
-8
8
1
1
1
ticks
30.0

BUTTON
-2
16
64
49
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
64
16
145
49
go once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
145
16
203
50
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
-3
48
201
81
number-of-cars
number-of-cars
6
40
22.0
2
1
NIL
HORIZONTAL

SLIDER
-7
80
202
113
autonomy-level
autonomy-level
0
5
3.0
1
1
NIL
HORIZONTAL

MONITOR
-2
128
203
173
Death by self-driving cars
autonomous-death-toll
17
1
11

MONITOR
-1
171
203
216
Death by regular cars
regular-death-toll
17
1
11

TEXTBOX
1152
24
1364
164
To pause the simulation click on the go button while the simulation is running.\n\nThe simulation ends after 7,000 ticks or if the total deaths has reached 15 or if 25% of the total count of cars is less than 1.
11
0.0
1

PLOT
457
404
818
625
Autonomous cars against regular cars
Deaths by Regular cars
Deaths by SDC's
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Autonomous" 1.0 0 -10899396 true "" "plot autonomous-death-toll "
"Regular" 1.0 0 -2674135 true "" "plot regular-death-toll"

@#$#@#$#@
## WHAT IS IT?

Simulation showing the dangers of self driving cars

## HOW IT WORKS

The cars as they increase in level of autonomy behave more intelligent when faced with obstacles, they slow down quicker than regular cars and don't speed too fast when theyre compromised

## HOW TO USE IT

Listed in the appendix of the report

## THINGS TO NOTICE

The colour changes of the cars, the fires agents and the behaviours of the cars.

## THINGS TO TRY

Try a simulation with any number of car on any level of autonomy

## EXTENDING THE MODEL

The end cases can be removed if you want to run the simulation longer

## NETLOGO FEATURES

N/A
## RELATED MODELS

Traffic 2 lanes 

## CREDITS AND REFERENCES

All rights reserved
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

building store
false
0
Rectangle -7500403 true true 30 45 45 240
Rectangle -16777216 false false 30 45 45 165
Rectangle -7500403 true true 15 165 285 255
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 30 180 105 240
Rectangle -16777216 true false 195 180 270 240
Line -16777216 false 0 165 300 165
Polygon -7500403 true true 0 165 45 135 60 90 240 90 255 135 300 165
Rectangle -7500403 true true 0 0 75 45
Rectangle -16777216 false false 0 0 75 45

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

car top
true
0
Polygon -7500403 true true 151 8 119 10 98 25 86 48 82 225 90 270 105 289 150 294 195 291 210 270 219 225 214 47 201 24 181 11
Polygon -16777216 true false 210 195 195 210 195 135 210 105
Polygon -16777216 true false 105 255 120 270 180 270 195 255 195 225 105 225
Polygon -16777216 true false 90 195 105 210 105 135 90 105
Polygon -1 true false 205 29 180 30 181 11
Line -7500403 true 210 165 195 165
Line -7500403 true 90 165 105 165
Polygon -16777216 true false 121 135 180 134 204 97 182 89 153 85 120 89 98 97
Line -16777216 false 210 90 195 30
Line -16777216 false 90 90 105 30
Polygon -1 true false 95 29 120 30 119 11

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

crossing
true
15
Line -16777216 false 150 90 150 210
Line -16777216 false 120 90 120 210
Line -16777216 false 90 90 90 210
Line -16777216 false 240 90 240 210
Line -16777216 false 270 90 270 210
Line -16777216 false 30 90 30 210
Line -16777216 false 60 90 60 210
Line -16777216 false 210 90 210 210
Line -16777216 false 180 90 180 210
Rectangle -1 true true 0 0 30 300
Rectangle -7500403 true false 120 0 150 300
Rectangle -1 true true 180 0 210 300
Rectangle -7500403 true false 240 0 270 300
Rectangle -1 true true 30 0 60 300
Rectangle -7500403 true false 90 0 120 300
Rectangle -1 true true 150 0 180 300
Rectangle -7500403 true false 270 0 300 300
Rectangle -1 true true 60 0 90 300
Rectangle -1 true true 210 0 240 300

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

factory
false
0
Rectangle -7500403 true true 76 194 285 270
Rectangle -7500403 true true 36 95 59 231
Rectangle -16777216 true false 90 210 270 240
Line -7500403 true 90 195 90 255
Line -7500403 true 120 195 120 255
Line -7500403 true 150 195 150 240
Line -7500403 true 180 195 180 255
Line -7500403 true 210 210 210 240
Line -7500403 true 240 210 240 240
Line -7500403 true 90 225 270 225
Circle -1 true false 37 73 32
Circle -1 true false 55 38 54
Circle -1 true false 96 21 42
Circle -1 true false 105 40 32
Circle -1 true false 129 19 42
Rectangle -7500403 true true 14 228 78 270

fire
false
0
Polygon -7500403 true true 151 286 134 282 103 282 59 248 40 210 32 157 37 108 68 146 71 109 83 72 111 27 127 55 148 11 167 41 180 112 195 57 217 91 226 126 227 203 256 156 256 201 238 263 213 278 183 281
Polygon -955883 true false 126 284 91 251 85 212 91 168 103 132 118 153 125 181 135 141 151 96 185 161 195 203 193 253 164 286
Polygon -2674135 true false 155 284 172 268 172 243 162 224 148 201 130 233 131 260 135 282

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

house bungalow
false
0
Rectangle -7500403 true true 210 75 225 255
Rectangle -7500403 true true 90 135 210 255
Rectangle -16777216 true false 165 195 195 255
Line -16777216 false 210 135 210 255
Rectangle -16777216 true false 105 202 135 240
Polygon -7500403 true true 225 150 75 150 150 75
Line -16777216 false 75 150 225 150
Line -16777216 false 195 120 225 150
Polygon -16777216 false false 165 195 150 195 180 165 210 195
Rectangle -16777216 true false 135 105 165 135

house colonial
false
0
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 45 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 60 195 105 240
Rectangle -16777216 true false 60 150 105 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Polygon -7500403 true true 30 135 285 135 240 90 75 90
Line -16777216 false 30 135 285 135
Line -16777216 false 255 105 285 135
Line -7500403 true 154 195 154 255
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 135 150 180 180

house efficiency
false
0
Rectangle -7500403 true true 180 90 195 195
Rectangle -7500403 true true 90 165 210 255
Rectangle -16777216 true false 165 195 195 255
Rectangle -16777216 true false 105 202 135 240
Polygon -7500403 true true 225 165 75 165 150 90
Line -16777216 false 75 165 225 165

house ranch
false
0
Rectangle -7500403 true true 270 120 285 255
Rectangle -7500403 true true 15 180 270 255
Polygon -7500403 true true 0 180 300 180 240 135 60 135 0 180
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 45 195 105 240
Rectangle -16777216 true false 195 195 255 240
Line -7500403 true 75 195 75 240
Line -7500403 true 225 195 225 240
Line -16777216 false 270 180 270 255
Line -16777216 false 0 180 300 180

house two story
false
0
Polygon -7500403 true true 2 180 227 180 152 150 32 150
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 75 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 90 150 135 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Rectangle -7500403 true true 15 180 75 255
Polygon -7500403 true true 60 135 285 135 240 90 105 90
Line -16777216 false 75 135 75 180
Rectangle -16777216 true false 30 195 93 240
Line -16777216 false 60 135 285 135
Line -16777216 false 255 105 285 135
Line -16777216 false 0 180 75 180
Line -7500403 true 60 195 60 240
Line -7500403 true 154 195 154 255

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

lights
false
0
Rectangle -16777216 true false 15 15 285 285
Rectangle -7500403 true true 30 30 270 270

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person business
false
0
Rectangle -1 true false 120 90 180 180
Polygon -13345367 true false 135 90 150 105 135 180 150 195 165 180 150 105 165 90
Polygon -7500403 true true 120 90 105 90 60 195 90 210 116 154 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 183 153 210 210 240 195 195 90 180 90 150 165
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 76 172 91
Line -16777216 false 172 90 161 94
Line -16777216 false 128 90 139 94
Polygon -13345367 true false 195 225 195 300 270 270 270 195
Rectangle -13791810 true false 180 225 195 300
Polygon -14835848 true false 180 226 195 226 270 196 255 196
Polygon -13345367 true false 209 202 209 216 244 202 243 188
Line -16777216 false 180 90 150 165
Line -16777216 false 120 90 150 165

person construction
false
0
Rectangle -7500403 true true 123 76 176 95
Polygon -1 true false 105 90 60 195 90 210 115 162 184 163 210 210 240 195 195 90
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Circle -7500403 true true 110 5 80
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -955883 true false 180 90 195 90 195 165 195 195 150 195 150 120 180 90
Polygon -955883 true false 120 90 105 90 105 165 105 195 150 195 150 120 120 90
Rectangle -16777216 true false 135 114 150 120
Rectangle -16777216 true false 135 144 150 150
Rectangle -16777216 true false 135 174 150 180
Polygon -955883 true false 105 42 111 16 128 2 149 0 178 6 190 18 192 28 220 29 216 34 201 39 167 35
Polygon -6459832 true false 54 253 54 238 219 73 227 78
Polygon -16777216 true false 15 285 15 255 30 225 45 225 75 255 75 270 45 285

person doctor
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -13345367 true false 135 90 150 105 135 135 150 150 165 135 150 105 165 90
Polygon -7500403 true true 105 90 60 195 90 210 135 105
Polygon -7500403 true true 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -1 true false 105 90 60 195 90 210 114 156 120 195 90 270 210 270 180 195 186 155 210 210 240 195 195 90 165 90 150 150 135 90
Line -16777216 false 150 148 150 270
Line -16777216 false 196 90 151 149
Line -16777216 false 104 90 149 149
Circle -1 true false 180 0 30
Line -16777216 false 180 15 120 15
Line -16777216 false 150 195 165 195
Line -16777216 false 150 240 165 240
Line -16777216 false 150 150 165 150

person farmer
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 60 195 90 210 114 154 120 195 180 195 187 157 210 210 240 195 195 90 165 90 150 105 150 150 135 90 105 90
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -13345367 true false 120 90 120 180 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 180 90 172 89 165 135 135 135 127 90
Polygon -6459832 true false 116 4 113 21 71 33 71 40 109 48 117 34 144 27 180 26 188 36 224 23 222 14 178 16 167 0
Line -16777216 false 225 90 270 90
Line -16777216 false 225 15 225 90
Line -16777216 false 270 15 270 90
Line -16777216 false 247 15 247 90
Rectangle -6459832 true false 240 90 255 300

person graduate
false
0
Circle -16777216 false false 39 183 20
Polygon -1 true false 50 203 85 213 118 227 119 207 89 204 52 185
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -8630108 true false 90 19 150 37 210 19 195 4 105 4
Polygon -8630108 true false 120 90 105 90 60 195 90 210 120 165 90 285 105 300 195 300 210 285 180 165 210 210 240 195 195 90
Polygon -1184463 true false 135 90 120 90 150 135 180 90 165 90 150 105
Line -2674135 false 195 90 150 135
Line -2674135 false 105 90 150 135
Polygon -1 true false 135 90 150 105 165 90
Circle -1 true false 104 205 20
Circle -1 true false 41 184 20
Circle -16777216 false false 106 206 18
Line -2674135 false 208 22 208 57

person lumberjack
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -2674135 true false 60 196 90 211 114 155 120 196 180 196 187 158 210 211 240 196 195 91 165 91 150 106 150 135 135 91 105 91
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -6459832 true false 174 90 181 90 180 195 165 195
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -6459832 true false 126 90 119 90 120 195 135 195
Rectangle -6459832 true false 45 180 255 195
Polygon -16777216 true false 255 165 255 195 240 225 255 240 285 240 300 225 285 195 285 165
Line -16777216 false 135 165 165 165
Line -16777216 false 135 135 165 135
Line -16777216 false 90 135 120 135
Line -16777216 false 105 120 120 120
Line -16777216 false 180 120 195 120
Line -16777216 false 180 135 210 135
Line -16777216 false 90 150 105 165
Line -16777216 false 225 165 210 180
Line -16777216 false 75 165 90 180
Line -16777216 false 210 150 195 165
Line -16777216 false 180 105 210 180
Line -16777216 false 120 105 90 180
Line -16777216 false 150 135 150 165
Polygon -2674135 true false 100 30 104 44 189 24 185 10 173 10 166 1 138 -1 111 3 109 28

person police
false
0
Polygon -1 true false 124 91 150 165 178 91
Polygon -13345367 true false 134 91 149 106 134 181 149 196 164 181 149 106 164 91
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -13345367 true false 120 90 105 90 60 195 90 210 116 158 120 195 180 195 184 158 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Rectangle -7500403 true true 123 76 176 92
Circle -7500403 true true 110 5 80
Polygon -13345367 true false 150 26 110 41 97 29 137 -1 158 6 185 0 201 6 196 23 204 34 180 33
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Rectangle -16777216 true false 109 183 124 227
Rectangle -16777216 true false 176 183 195 205
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Polygon -1184463 true false 172 112 191 112 185 133 179 133
Polygon -1184463 true false 175 6 194 6 189 21 180 21
Line -1184463 false 149 24 197 24
Rectangle -16777216 true false 101 177 122 187
Rectangle -16777216 true false 179 164 183 186

person service
false
0
Polygon -7500403 true true 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -1 true false 120 90 105 90 60 195 90 210 120 150 120 195 180 195 180 150 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Polygon -1 true false 123 90 149 141 177 90
Rectangle -7500403 true true 123 76 176 92
Circle -7500403 true true 110 5 80
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -2674135 true false 180 90 195 90 183 160 180 195 150 195 150 135 180 90
Polygon -2674135 true false 120 90 105 90 114 161 120 195 150 195 150 135 120 90
Polygon -2674135 true false 155 91 128 77 128 101
Rectangle -16777216 true false 118 129 141 140
Polygon -2674135 true false 145 91 172 77 172 101

person soldier
false
0
Rectangle -7500403 true true 127 79 172 94
Polygon -10899396 true false 105 90 60 195 90 210 135 105
Polygon -10899396 true false 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Polygon -10899396 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -6459832 true false 120 90 105 90 180 195 180 165
Line -6459832 false 109 105 139 105
Line -6459832 false 122 125 151 117
Line -6459832 false 137 143 159 134
Line -6459832 false 158 179 181 158
Line -6459832 false 146 160 169 146
Rectangle -6459832 true false 120 193 180 201
Polygon -6459832 true false 122 4 107 16 102 39 105 53 148 34 192 27 189 17 172 2 145 0
Polygon -16777216 true false 183 90 240 15 247 22 193 90
Rectangle -6459832 true false 114 187 128 208
Rectangle -6459832 true false 177 187 191 208

person student
false
0
Polygon -13791810 true false 135 90 150 105 135 165 150 180 165 165 150 105 165 90
Polygon -7500403 true true 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 100 210 130 225 145 165 85 135 63 189
Polygon -13791810 true false 90 210 120 225 135 165 67 130 53 189
Polygon -1 true false 120 224 131 225 124 210
Line -16777216 false 139 168 126 225
Line -16777216 false 140 167 76 136
Polygon -7500403 true true 105 90 60 195 90 210 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

road
true
0
Rectangle -7500403 true true 0 0 300 300
Rectangle -1 true false 0 75 300 225

road2
true
0
Rectangle -7500403 true true 0 0 300 300
Rectangle -1 true false 60 255 225 390

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

tree pine
false
0
Rectangle -6459832 true false 120 225 180 300
Polygon -7500403 true true 150 240 240 270 150 135 60 270
Polygon -7500403 true true 150 75 75 210 150 195 225 210
Polygon -7500403 true true 150 7 90 157 150 142 210 157 150 7

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
