//Basic tasks on arrays and methods

//1 - Write an array of 11 elements of different type (heterogeneous) and assign the array to a variable "a":

a = [\hi, 5, 68.midicps, {PinkNoise.ar(0.2)}, 0.1, "hello".scramble, 127, {SinOsc.ar(PinkNoise.ar(180, 270), 0, 0.5)}, 0.00002, {BPF.ar(in: BrownNoise.ar(0.5), rq: 0.05, mul: 1.5)}, \end] //(Very random)

//2 - Assign to the variable "b" the second element of "a":

b = a[1]

//3 - Assign the first element of "a" to the variable "b":

b = a[0]

//4 - Assign to the variable "c" an array containing 24 random values between the range 1 to 12:

c = Array.fill(24, { rrand (1, 12)})

//5 - Assign to the variable "d" an array containing an arithmetic series of 31 numbers, starting by 1000 and growing by 111 steps.

d = Array.series(31, 1000, 111)

//6 - Rotate the former series three slots to the right and reassign the value of "d":

d = d.rotate(3)

//7 - Reassign to "d" the retrograded "d":

d = d.reverse

//8 - Assign to "d" the elements of "d", but changing the order randomly:

d = d.scramble

//9 - Assign to "e" a geometric series of 16 elements, starting by 33, and with a growing factor of 1.5 (series of Pitagoric fifths):

e = Array.geom(16, 33, 1.5)

//10 - Apply to "e" the method .plot (exponential graph):

e.plot

//11 - Assign to "f" an arithmetic series of 16 numbers. The two first numbers of the series must be 24 and 31:

f = Array.series(16, 24, 7)

//12 - Assign to "f" the mirror of "f" and apply a plotter to the result:

f = f.mirror
f.plot

//13 - Apply the method .plot to "f", obtaining a discontinuous line in the graph:

f.plot(discrete: true)

//14 - Change the order of the elements in "f" randomly and apply a plotter to its values, obtaining a continuous and a discontinuous line in the graph:

f = f.scramble
f.plot(discrete:true)
f.plot(discrete:false)//The graph would be continuous by default.

//15 - Create an array of 101 random elements chosen from the elements of an array of the numbers 1 to 5. Each element should have a different probability of been chosen (several options):

Array.fill(101, {[1, 2, 3, 4 ,5].wchoose([0.6, 0.01, 0.29, 0.04, 0.06])}) //First option, directly writing the 1-5 array inside the bigger array as an argument.

Array.fill(101, {Array.series(5, 1, 1).wchoose([0.6, 0.01, 0.29, 0.04, 0.06])}) //Second option, the 1-5 array is created using Array.series.

g = [1, 2, 3, 4, 5]
Array.fill(101, {g.wchoose([0.6, 0.01, 0.29, 0.04, 0.06])}) //Third option, the 1-5 array is written inside a variable, and then used inside the bigger array.
