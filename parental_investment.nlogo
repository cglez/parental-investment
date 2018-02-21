; Copyright 2018 César González.
; See Info tab for full copyright and license.

;# Breeds
turtles-own [
  ; state
  energy
  age
  nurturing

  ; g-type
  a-nurturing  ; a-class energy spent in offspring
  b-nurturing  ; b-class energy spent in offspring
  ;number-eggs  ; number of eggs spawn
  ;egg-size     ; aka energy provided to each descendent
]

breed [ sex-a a-organism ]
breed [ sex-b b-organism ]

patches-own [
  hatching
]

;# Constants
to-report adult-age      report 80  end  ; age when an organism is mature to reproduce
to-report stride         report 1   end  ; stride length

;# Main functions
to setup
  clear-all

  ; setup the terrain
  ask patches [
    set pcolor green + 1
    set hatching 0
  ]

  ; create the specimens, then initialize their variables
  set-default-shape sex-a "a-shape"
  set-default-shape sex-b "b-shape"
  create-turtles max-population
  ask turtles [
    ; initial state
    ifelse random 2 = 0 [  ; choose sex randomly
      set breed sex-a
      set color gray
    ] [
      set breed sex-b
      set color orange
    ]
    set age adult-age
    set size 3
    set energy random max-energy
    set nurturing 0
    setxy random-xcor random-ycor

    ; initial g-type
    set a-nurturing random hatch-age
    set b-nurturing random hatch-age
    ;set number-eggs 2
    ;set egg-size 50
  ]

  reset-ticks
end

to go
  if not any? sex-a or not any? sex-b [ stop ]
  ; control population
  ; TODO: energy-based population control
  if count turtles > max-population [
    ask max-n-of (count turtles - max-population) turtles [age] [
      die
    ]
  ]
  ask turtles [
    be-born
    grow
    reproduce
    and-die
  ]
  ask patches [
    leave-nest
  ]
  tick
end

;# Procedures and reporters
to be-born ;.turtle
  ; Darwin says someone has done this for you
end

to grow ;.turtle
  metabolize
  move
end

to metabolize ;.turtle
  ; increase age
  set age age + 1
  ; eat
  set energy energy + 2
  ; nurture offspring if any
  nurture
  ; change appearance with age
  if age = hatch-age [ set size 1 ]
  if age = adult-age [ set size 3 ]
end

to nurture ;.turtle
  if nurturing = 0 [ stop ]
  set nurturing nurturing - 1
  let nurturing-energy 0
  ifelse breed = sex-a [
    set nurturing-energy a-nurturing
  ] [
    set nurturing-energy b-nurturing
  ]
  set energy energy - nurturing-energy
  let offspring turtle-set turtles-here with [ size = 0 ]
  ask offspring [
    set energy energy + (nurturing-energy / count offspring)
  ]
end

to move ;.turtle
  ; check movility
  if age < hatch-age or  ; eggs can't move
     nurturing > 0       ; when nurturing stay at home
    [ stop ]
  ; take a step in a random direction
  right random-float 50
  left random-float 50
  forward stride
  ; the bigger the stride the more the energy you spend
  set energy energy - stride
end

to reproduce ;.turtle
  ; check mating conditions
  if breed = sex-b or    ; avoid duplicated couples
     age < adult-age or  ; adults only
     energy < min-energy-reproduce or  ; a mimimun energy is required
     pcolor = white      ; only one nest allowed at a patch
    [ stop ]
  ; find a suitable partner
  let parent-a self
  let parent-b one-of sex-b-here with [ age > adult-age and energy >= min-energy-reproduce ]
  let parents (turtle-set parent-a parent-b)
  ; TODO comment
  if count parents = 2 [
    ; make a nest
    ask patch-here [
      set pcolor white
      set hatching hatch-age
    ]
    ; lay eggs and fecundate them
    set energy (energy - number-eggs * egg-size)
    hatch number-eggs [
      ; set state
      set energy egg-size
      set age 0
      set size 0
      ifelse random 2 = 0 [  ; random sex
        set breed sex-a
        set color gray
      ] [
        set breed sex-b
        set color orange
      ]
      set nurturing 0
      ; inherit mutated g-type
      set a-nurturing mutate ([ a-nurturing ] of one-of parents) drift
      set b-nurturing mutate ([ b-nurturing ] of one-of parents) drift
      ;set number-eggs mutate ([ number-eggs ] of parent-a) drift
      ;set egg-size mutate ([ egg-size ] of parent-a) drift
    ]
    ; start nurturing
    ask parent-a [ set nurturing a-nurturing ]
    ask parent-b [ set nurturing b-nurturing ]
  ]
end

to and-die ;.turtle
  ; when energy reaches zero it's game over
  if energy <= 0 [ die ]
end

to invation [ n x-nurturing y-nurturing ]
  ; check parameter integrity
  if n < 0 or
     x-nurturing < 0 or
     y-nurturing < 0
    [ stop ]

  create-turtles n [
    set a-nurturing x-nurturing
    set b-nurturing y-nurturing
    ifelse random 2 = 0 [ set breed sex-a ] [ set breed sex-b ]
    set color red
    set age adult-age
    set size 3
    set energy random max-energy
    set nurturing 0
    setxy random-xcor random-ycor
  ]
end

to leave-nest ;.patch
  if hatching > 0 [ set hatching hatching - 1 ]
  if pcolor = white and hatching = 0 [
    set pcolor green + 1
  ]
end

to-report mutate [ gene g-drift ] ;.turtle
  let gene' gene + random-float g-drift - random-float g-drift
  if gene < 0 [ report 0 ] ; negative values make no sense
  report gene'
end
@#$#@#$#@
GRAPHICS-WINDOW
55
20
429
395
-1
-1
6.0
1
20
1
1
1
0
1
1
1
-30
30
-30
30
1
1
1
ticks
30.0

SLIDER
50
440
240
473
max-population
max-population
2
200
200.0
1
1
NIL
HORIZONTAL

BUTTON
285
435
354
468
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
355
435
424
468
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

PLOT
450
10
786
130
population
time
pop.
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"sex-a" 1.0 0 -7500403 true "" "plot count sex-a"
"sex-b" 1.0 0 -955883 true "" "plot count sex-b"
"eggs" 1.0 0 -1184463 true "" "plot count patches with [ pcolor = white ]"
"nurturing" 1.0 0 -5825686 true "" "plot count turtles with [ nurturing > 0 ]"

MONITOR
785
25
850
70
sex-a
count sex-a
3
1
11

MONITOR
785
70
850
115
sex-b
count sex-b
3
1
11

MONITOR
850
25
915
70
nests
count patches with [ pcolor = white ]
0
1
11

TEXTBOX
55
420
235
438
Settings
12
0.0
1

PLOT
450
135
786
255
parental investment
time
energy
0.0
100.0
0.0
1.0
true
true
"" ""
PENS
"a-nurturing" 1.0 0 -7500403 true "" "if any? sex-a\n[ plot mean [a-nurturing] of sex-a ]"
"b-nurturing" 1.0 0 -955883 true "" "if any? sex-b\n[ plot mean [b-nurturing] of sex-b ]"

PLOT
690
265
920
385
b-nurturing histogram
energy
number
0.0
60.0
0.0
50.0
true
false
"set-histogram-num-bars 50" "histogram [ b-nurturing ] of sex-b  ; using the default plot pen"
PENS
"default" 1.0 1 -955883 true "" ""

PLOT
452
265
682
385
a-nurturing histogram
energy
number
0.0
60.0
0.0
50.0
true
false
"set-histogram-num-bars 50" "histogram [ a-nurturing ] of sex-a  ; using the default plot pen"
PENS
"default" 1.0 1 -7500403 true "" ""

MONITOR
785
150
860
195
a-nurturing
mean [a-nurturing] of sex-a
2
1
11

MONITOR
785
195
860
240
b-nurturing
mean [b-nurturing] of sex-b
2
1
11

TEXTBOX
790
10
850
28
current
12
0.0
1

TEXTBOX
790
135
855
153
avg.
12
0.0
1

MONITOR
850
70
915
115
nurturing
count turtles with [ nurturing > 0 ]
17
1
11

SLIDER
50
480
240
513
max-energy
max-energy
1
1000
800.0
10
1
NIL
HORIZONTAL

SLIDER
50
520
240
553
min-energy-reproduce
min-energy-reproduce
1
1000
500.0
10
1
NIL
HORIZONTAL

SLIDER
245
480
435
513
hatch-age
hatch-age
1
100
40.0
1
1
NIL
HORIZONTAL

SLIDER
50
560
240
593
drift
drift
0
10
1.0
0.1
1
NIL
HORIZONTAL

SLIDER
245
520
435
553
egg-size
egg-size
0
200
50.0
1
1
NIL
HORIZONTAL

SLIDER
245
560
435
593
number-eggs
number-eggs
1
10
2.0
1
1
NIL
HORIZONTAL

MONITOR
452
390
684
435
(A) mean investement / hatch age
mean [ a-nurturing ] of sex-a / hatch-age
2
1
11

MONITOR
690
390
920
435
(B) mean investment / hatch age
mean [ b-nurturing ] of sex-b / hatch-age
2
1
11

@#$#@#$#@
## What Is It?

This is an ecosystem model for the study of parental investment in sexual reproduction and focused primarily on sexual conflict. In this model, a life form with two sexes reproduce and spend time in their offspring so to increase their chance of survival. The amount of time a parent is to spend on nurturing is determined by its genes. Each sex exhibits differentiated behaviour thanks to genes that are expressed only in their respective sex. These traits are transmitted to the descendants and open to variation through mutation.

This model is based on predator-prey ecosystem with inheritance model called _Wolf-Sheep stride inheritance_ from the NetLogo library. 

## How It Works



At initialization wolves have a stride of INITIAL-WOLF-STRIDE and sheep have a stride of INITIAL-SHEEP-STRIDE. Wolves and sheep wander around the world moving STRIDE-LENGTH in a random direction at each step. Sheep eat grass and wolves eat sheep, as in the Wolf Sheep Predation model. When wolves and sheep reproduce, they pass their stride length down to their young. However, there is a chance that the stride length will mutate, becoming slightly larger or smaller than that of its parent.

## How To Use It

### Parameters

*max-population*: The maximum overall population above of which the oldest specimens start dying
*max-energy*: The maximum amount of energy any specimen can have
*min-energy-reproduce*: The minimum amount of energy a specimen needs to reproduce
*drift*: The largest variation a gene can take from mutation
*hatch-age*: The time it takes to an specimen to hatch from its egg and leave
*egg-size*: The amount of energy an specimen is given by conception
*number-eggs*: The number of offspring produced by mating

Half a unit of energy is deducted from each wolf and sheep at every time step. If STRIDE-LENGTH-PENALTY? is on, additional energy is deducted, scaled to the length of stride the animal takes (e.g., 0.5 stride deducts an additional 0.5 energy units each step).

WOLF-STRIDE-DRIFT and SHEEP-STRIDE-DRIFT: How much variation an offspring of a wolf or a sheep can have in its stride length compared to its parent. For example, if set to 0.4, then an offspring might have a stride length up to 0.4 less than the parent or 0.4 more than the parent.

## Things To Notice

WOLF STRIDE HISTOGRAM and SHEEP STRIDE HISTOGRAM will show how the population distribution of different animal strides is changing.

In general, sheep get faster over time and wolves get slower or move at the same speed. Sheep get faster in part, because remaining on a square with no grass is less advantageous than moving to new locations to consume grass that is not eaten. Sheep typically converge on an average stride length close to 1. Why do you suppose it is not advantageous for sheep stride length to keep increasing far beyond 1?

If you turn STRIDE-LENGTH-PENALTY? off, sheep will become faster over time, but will not stay close to a stride length of 1. Instead they will become faster and faster, effectively jumping over multiple patches with each simulation step.

## Things To Try

Try adjusting the parameters under various settings. How sensitive is the stability of the model to the particular parameters?

Can you find any parameters that generate a stable ecosystem where there are at least two distinct groups of sheep or wolves with different average stride lengths?

## Extending The Model

Add a cone of vision for sheep and wolves that allows them to chase or run away from each other. Make this an inheritable trait.

## Related Models

Wolf Sheep Stride Inheritance

## How To Cite

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## Copyright And License

Copyright 2018 César González.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License. To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

a-shape
false
0
Polygon -7500403 true true 75 150 90 195 210 195 225 150 255 120 255 45 180 0 120 0 45 45 45 120
Circle -16777216 true false 165 60 60
Circle -16777216 true false 75 60 60
Polygon -7500403 true true 225 150 285 195 285 285 255 300 255 210 180 165
Polygon -7500403 true true 75 150 15 195 15 285 45 300 45 210 120 165
Polygon -7500403 true true 210 210 225 285 195 285 165 165
Polygon -7500403 true true 90 210 75 285 105 285 135 165
Rectangle -7500403 true true 135 165 165 270

b-shape
false
0
Polygon -7500403 true true 75 150 90 105 210 105 225 150 255 180 255 255 180 300 120 300 45 255 45 180
Circle -16777216 true false 165 180 60
Circle -16777216 true false 75 180 60
Polygon -7500403 true true 225 150 285 105 285 15 255 0 255 90 180 135
Polygon -7500403 true true 75 150 15 105 15 15 45 0 45 90 120 135
Polygon -7500403 true true 210 90 225 15 195 15 165 135
Polygon -7500403 true true 90 90 75 15 105 15 135 135
Rectangle -7500403 true true 135 30 165 135

egg
false
0
Circle -7500403 true true 96 76 108
Circle -7500403 true true 72 104 156
Polygon -7500403 true true 221 149 195 101 106 99 80 148
@#$#@#$#@
NetLogo 6.0.2
@#$#@#$#@
setup
repeat 75 [ go ]
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
1
@#$#@#$#@
