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
  b-nurturing  ; b-class " " "
  number-eggs  ; number of eggs spawn
  egg-size     ; aka energy provided to each descendent
]

breed [ sex-a a-organism ]
breed [ sex-b b-organism ]

patches-own [
  hatching
]

;# Constants
to-report max-energy     report 500 end  ; the maximum amount of energy any animal can have
to-report max-population report 200 end  ; the maximum number of turtles allowed
to-report hatch-age      report 50  end  ; the time before an egg hatches
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
  create-turtles initial-population
  ask turtles [
    ; set initial state
    ifelse random 2 = 0 [  ; choose random sex
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

    ; set initial g-type
    set a-nurturing 40
    set b-nurturing 20
    set number-eggs 2
    set egg-size max-energy
  ]

  reset-ticks
end

to go
  if not any? turtles [ stop ]

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
  ; increase age and decrease energy
  set age age + 1
  set energy energy - 0.5

  ; nurture offspring
  nurture

  if age = hatch-age [ set size 1 ]
  if age = adult-age [ set size 3 ]
end

to nurture ;.turtle
  if nurturing <= 0 [ stop ]

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

  rt random-float 50
  lt random-float 50
  fd stride

  set energy energy - stride
end

to reproduce ;.turtle
  ; check conditions
  if breed = sex-b or    ; avoid duplicated couples
     age < adult-age or  ; adults only
     pcolor = white      ; only one nest allowed at a patch
    [ stop ]

  ; find a suitable couple
  let parent-a self
  let parent-b one-of sex-b-here with [ age > adult-age ]
  if parent-b != nobody [

    ; make a nest
    ask patch-here [
      set pcolor white
      set hatching hatch-age
    ]

    ; lay eggs and fecundate them
    hatch number-eggs [
      ; set state
      set energy egg-size
      set age 0
      set size 0
      set nurturing 0
      ifelse random 2 = 0 [  ; random sex
        set breed sex-a
        set color gray
      ] [
        set breed sex-b
        set color orange
      ]

      ; inherit g-type
      ; TODO: mutate
      ; TODO: crossover? mix parent genes?
      ;set a-nurturing  [a-nurturing] of partner-a
      set b-nurturing  [ b-nurturing ] of parent-b
      ;set number-eggs  [number-eggs] of partner-a
      ;set egg-size     [egg-size]    of partner-a
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

to leave-nest ;.patch
  if hatching > 0 [ set hatching hatching - 1 ]

  if pcolor = white and hatching = 0 [
    set pcolor green + 1
  ]
end

to reproduce-old [reproduction-chance drift] ;.turtle
  ; throw "dice" to see if you will reproduce
  if random-float 100 < reproduction-chance [
    set energy (energy / 2)  ; divide energy between parent and offspring
    hatch 1 [
      rt random-float 360
      fd 1
      ; mutate the stride length based on the drift for this breed
      ;set stride mutated-stride drift
    ]
  ]
end

to-report mutated-stride [drift] ;.turtle -> float
  let l stride + random-float drift - random-float drift
  ; keep the stride lengths within the accepted bounds
  if l < 0 [ report 0 ]
  report l
end
@#$#@#$#@
GRAPHICS-WINDOW
500
28
874
403
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
35
34
234
67
initial-population
initial-population
2
250
100.0
2
1
NIL
HORIZONTAL

BUTTON
308
215
377
248
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
378
215
447
248
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
33
265
369
408
populations
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
"nests" 1.0 0 -1184463 true "" "plot count patches with [ pcolor = white ]"
"nurturing" 1.0 0 -5825686 true "" "plot count turtles with [ nurturing > 0 ]"

MONITOR
369
265
446
310
sex-a
count sex-a
3
1
11

MONITOR
369
310
444
355
sex-b
count sex-b
3
1
11

MONITOR
369
354
447
399
nests
count patches with [ pcolor = white ]
0
1
11

TEXTBOX
44
14
184
33
Sheep settings
11
0.0
0

PLOT
34
469
370
612
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
"energy" 1.0 0 -2674135 true "" "if any? turtles [\n  plot mean [energy] of turtles\n]"

PLOT
634
419
896
612
wolf stride histogram
stride
number
0.0
3.0
0.0
10.0
true
false
"set-histogram-num-bars 20" "histogram [ stride ] of wolves    ;; using the default plot pen"
PENS
"default" 1.0 1 -2674135 true "" ""

PLOT
371
419
633
612
sheep stride histogram
stride
number
0.0
3.0
0.0
10.0
true
false
"set-histogram-num-bars 20" "histogram [ stride ] of sheep     ;; using the default plot pen"
PENS
"default" 1.0 1 -13345367 true "" ""

MONITOR
34
418
148
463
avg. a-nurturing
mean [stride] of a-organisms
2
1
11

MONITOR
246
419
369
464
avg. b-nurturing
mean [stride] of b-organisms
2
1
11

@#$#@#$#@
## WHAT IS IT?

This model is a variation on the predator-prey ecosystems model wolf-sheep predation.

This model is a variation on the predator-prey ecosystems model wolf-sheep predation.
In this model, predator and prey can inherit a stride length, which describes how far forward they move in each model time step.  When wolves and sheep reproduce, the children inherit the parent's stride length -- though it may be mutated.

## HOW IT WORKS

At initialization wolves have a stride of INITIAL-WOLF-STRIDE and sheep have a stride of INITIAL-SHEEP-STRIDE.  Wolves and sheep wander around the world moving STRIDE-LENGTH in a random direction at each step.  Sheep eat grass and wolves eat sheep, as in the Wolf Sheep Predation model.  When wolves and sheep reproduce, they pass their stride length down to their young. However, there is a chance that the stride length will mutate, becoming slightly larger or smaller than that of its parent.

## HOW TO USE IT

INITIAL-NUMBER-SHEEP: The initial size of sheep population
INITIAL-NUMBER-WOLVES: The initial size of wolf population

Half a unit of energy is deducted from each wolf and sheep at every time step. If STRIDE-LENGTH-PENALTY? is on, additional energy is deducted, scaled to the length of stride the animal takes (e.g., 0.5 stride deducts an additional 0.5 energy units each step).

WOLF-STRIDE-DRIFT and SHEEP-STRIDE-DRIFT:  How much variation an offspring of a wolf or a sheep can have in its stride length compared to its parent.  For example, if set to 0.4, then an offspring might have a stride length up to 0.4 less than the parent or 0.4 more than the parent.

## THINGS TO NOTICE

WOLF STRIDE HISTOGRAM and SHEEP STRIDE HISTOGRAM will show how the population distribution of different animal strides is changing.

In general, sheep get faster over time and wolves get slower or move at the same speed.  Sheep get faster in part, because remaining on a square with no grass is less advantageous than moving to new locations to consume grass that is not eaten.  Sheep typically converge on an average stride length close to 1.  Why do you suppose it is not advantageous for sheep stride length to keep increasing far beyond 1?

If you turn STRIDE-LENGTH-PENALTY? off, sheep will become faster over time, but will not stay close to a stride length of 1.  Instead they will become faster and faster, effectively jumping over multiple patches with each simulation step.

## THINGS TO TRY

Try adjusting the parameters under various settings. How sensitive is the stability of the model to the particular parameters?

Can you find any parameters that generate a stable ecosystem where there are at least two distinct groups of sheep or wolves with different average stride lengths?

## EXTENDING THE MODEL

Add a cone of vision for sheep and wolves that allows them to chase or run away from each other. Make this an inheritable trait.

## NETLOGO FEATURES

This model uses two breeds of turtle to represent wolves and sheep.

## RELATED MODELS

Wolf Sheep Predation, Bug Hunt Speeds

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 2018 César González.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.
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
