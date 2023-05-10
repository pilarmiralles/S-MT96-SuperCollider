b//Sound synthesis basics - Presentation (beginner group)
/////////////////////////////////////////////////////////////////////

//DATA TYPES

//Limits of integer numbers:
2 ** 31
2147483647 + 1 //Crossing the limit

//Limits of float representation:
(-1, -0.8..1)
(0, 0.2..1)

(0.1 !10).sum == 1.0 //"False".
(0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1) //But equal to 1.0 in fact.

//Other floats:
1.2e4
1.2e-4 //Exponential notation.
pi
0.5pi //pi constant.
inf //Infinite.

//Strings:
"string"
"string".scramble

//Symbols:
\symbol
'symbol'

//Equality and Identity in SuperCollider (symbols VS strings):
\abc == \abc //True
\abc === \abc //True

"abc" == "abc" //True
"abc" === "abc" //False

//Other special values:
true
false
nil //(empty)

//Examples of variables:
var hello, filter_func

//Examples of methods:
.play, .midicps, .round

//Classes:
Server
SinOsc
HPF


//MATHEMATICAL OPERATIONS

//Basic calculations:
1 + 1 //Addition
1 - 1 //Subtraction
1 * 2 //Multiplication
5 / 2 //Division
5.div(2) //Division, but returning only integers (rounding down)
2 ** 7 //Power
2.pow(7) //Power (applied as method)
9.sqrt //Squared root (3*3 = 9)
27.cbrt //Cubic root (3*3*3 = 27)
7.pow(1/12) //Calculating the "x" root of a number using its power equivalent ("m" root of "a" to the "n" = "a" to the "m / n"). Example = 12th root of 7
21.mod(12) //Module
21 % 12 //Also module
(0..24) % 7 //Demonstration of how module works (keeping 24 values within 0 - 6)

//Operations hierarchy:
//In SC, all operations are calculated from left to right no matter the kind of operations involved:
2 + 3 * 3 //15
2 + (3 * 3) //11 (prioritizing the product)

//Other calculations:
13.nextPowerOfTwo; //Next power of 2 from that number onwards.
44.nextPrime; //Next prime number from that number onwards.
4.nthPrime; //The fourth prime number in the series of prime numbers.
34.61946.round(0.01) //Rounding to two decimals (rounding up from 5, down from 4). The argument defines the number of decimals.
72.round(30) //Keeps number within the multiples of the .round argument value (useful for overtones).
69.midicps //Midi to Hz converter.
440.cpsmidi //Hz to midi converter.
1.57.asInteger //Turns a float into an integer by rounding down (also shortcut .asInt).

//Randomness with numbers:
10.rand //From 0 to 9.
333.rand + 100 //From 100 to 432.
5.xrand //Excludes 0 (from 1 to 5).
5.xrand(1) //Excludes 1.
5.xrand2 //Includes negative values (no 0 by default).
10.rand2 //Includes negative values (including 0).
rrand(0.1, 4) //Random numbers within a range with uniform distribution (both integers = integers only; at least one of them float = all float results) --> Polymorphism: "the ability for different kinds of objects to respond differently to the same message" (different kinds ob object: int / float | same message: rrand).
exprand(1, 4)//Random numbers within a range with exponential distribution (results will always be float regardless of type of input). The lo/hi limit cannot be zero and the range cannot cross zero.


//TYPES OF BRACKETS
SinOsc.ar(440) //Round brackets or parenthesis: arguments and grouping blocks code broken into different lines:

(
var string;

string = "hello";

"hello".scramble
)

[1, 2, 3, 4, 5] //Square brackets: collections (arrays, lists, sets, etc.).

{ SinOsc.ar(440, 0, 0.1) }.play; //Curly brackets: functions.


/////////////////////////////////////////////////////////////////////////////////

//VARIABLES

//Non-declared (global):
a = 1
a + 1

this.dump

//Declared:
(
var value1, value2, power;

value1 = 2;
value2 = 16;
power = value1 ** value2
)

//Non-declared with descriptive name:
~value1


//FUNCTIONS

//Useless example:
a = { 1 + 1 }
a.value

//Less useless example:
(
f = { |value1 = 1, value2 = 5, deviation = 0.9| //Default values.
	var result;

	result = value1 + value2;
	result = result * deviation
}
)

f.value(2, 3, 0.09)
f.value(deviation: 0.99) //Keyword assignment.

//Area of a trapezoid A = ((a + b) / 2) * h:
(
{ |shortBase = 2, longBase = 3, height = 2|
	var area;

	area = shortBase + longBase / 2;
	area = area * height

}.value(1, 2, 2)
)


//METHODS

//Imaginary classes:
Sandwich
Ham

//Imaginary methods:
Sandwich
* prepare //Class method (creates the sandwich)
hitUp //Instance methods (modify the sandwich)
cut

Ham
* marinate
fry

//Syntax object-message: class.method:
Sandwich.prepare

//Real example in SC:
{ SinOsc.ar }.play

//Defining imaginary arguments:
Sandwich{

	*prepare{ arg extraIngredients = ['tomato', 'cheese'], //Class method.
		bread = 'baguette', //Default values for its arguments.
		meat = 'chicken';
		...
		...
	}

	hitUp{ arg temp = 50, time = 120; //Instance methods.
	}

	cut{ arg numPieces = 2;
	}
}

//Applying out imaginary methods to our imaginary classes:

Sandwich.prepare(['tomato'], 'baguette', 'tofu')
Sandwich.prepare(meat: 'tofu') //Keyword assignment.

//Now adding the other class:
a = Sandwich.prepare(
	['pepper'],
	'baguette',

	Ham.marinate.fry(260) //First arg of the method is temp (for instance) --> Help doc should indicate what is the unit of temp.
)

//Applying instance methods:
a = a.hitUp
a = a.cut(4) //Arg of .cut is number of pieces.


//COLLECTIONS: ARRAY

//Homogeneous collection of integers:
[1, 2, 3, 4, 5]

//Heterogemeous collection (symbol, integer, string and sine oscillator function):
[\symbol, 67, "string", { SinOsc.ar(mul: 0.1) }]

//An array assigned to a global variable:
a = [1, 2, 3, 4, "hello", { SinOsc.ar(mul: 0.1) }]

a[0] //= 1
a[4] //= "hello"
a[5].play //Applying the method .play to the function in index 5.

//CLASS METHODS for arrays:
//Array.fill:
Array.fill(6, { rrand(0, 11) }) //Six random numbers from 0 to 11.

Array.fill(6, { |i| i }) //Using the "index" argument: printing the index numbers (0 to 5).

Array.fill(6, { |i| [i, rrand(0, 11)] }) //Array of six arrays containing the index number and a random number each.

//Duplication (!n) is equivalent to Array.fill:
({ |i| [i, rrand(0, 11)] } !6) //equal to:

Array.fill(6, { |i| [i, rrand(0, 11)] })

//Array.series:
Array.series(12, 0, 1) //Series from 0 to 11 with a step of 1.

Array.series(24, 60, 0.5) //Series representing a scale of quarter tones within an octave from 60 MIDI (for instance, if applied to sound).

//Visualizing arrays:
x = Array.series(50, 0, 5)
x.plot(discrete: true) //Discontinuous points.
x.plot(discrete: false) //Continuous line (although the content of the array is still a series of "points"), by default, no need to indicate.

//Array.geom:
Array.geom(5, 220, 2) //Series of five octaves from 220 Hz, if applied to sound.

//Visualizing arrays:
y = Array.geom(10, 1, 2)
y.plot(discrete: true)
y.plot //Continuous by default.

//INSTANCE METHODS for arrays:
z = Array.series(12, 0, 1) //Creating an array assigned to a global variable.
z.reverse //Retrograded series.
z = z.reverse //Reassigned to the variable.
z.scramble //Random change or order of the elements.
z = z.scramble.keep(5) //Reassigning a scrambled series and keeping only the first 5 elements.
z.sort //Values in upward order.
z.sort.reverse //Values in downward order.
z.mirror //Original and retrograded series put together.

z = Array.series(12, 0, 1) //Let's refresh.
z.drop(1) //Deteles the first element.
z = z.drop(1) //Deletes successively from the first element.
z.drop(-1) //Deletes the last element.
z = z.drop(-2) //Deleting two elements successively from the last element.

Array.series(200, 0, 1) //Very long array: cannot see all elements when printed.
Array.series(200, 0, 1).asCompileString //The array will be entirely printed (also shortcut .cs). Need to be careful with this tho, as SC saves memory for a reason.
Array.series(200, 0, 1).last //We can ask to see just the last element.
Array.series(200, 0, 1).lastIndex //Shows the index of the last element (in this case, same value).

[0, 1, 2, 3].choose //Chooses one random element from the collection.
[0, 1, 2, 3].wchoose([0.2, 0.3, 0.49, 0.01]) //Chooses one random element according to the probability shown in the argument "weights" (total sum of 1).
[0, 1, 2, 3].wchoose([5, 8, 4, 2].normalizeSum) //Using the method .normalizeSum to turn any values into ratios between 0 and 1.
h = [0, 1, 2, 3].rotate(1) //Rotate elements one space to the right, assigned to variable "h".
h = h.rotate(-2) //Rotate elements two spaces to the left successively.
[1, 2, 3, 4, 5].sum //Addition of the elements of an homogeneous array. Could be used to sum an array of signals into one channel (beware the amplitude).

//Arithmetic operations between arrays of different sizes:
[1, 2, 3, 4, 5] + [1, 2, 3] //Next line is equal to this one:
[1, 2, 3, 4, 5] + [1, 2, 3, 1, 2]

a = [0, 1, 2, 3, 4]
a = a.add(1000) //Adding a new element at the end of the collection and reassigning the variable.
a[1] = 2000 //Method "put", replaces a new element in the indicated index, removing the previous one.
b = a.removeAt(1) //Removes the element at the indicated index. Now assigned to "b".
b //"b" contains 2000.
a //"a" does not contain 2000 anymore.

//Concatenation of arrays:
k = [1, 2, 3]
l = [100, 200, 300]
k ++ l //Concatenation.

//Nested arrays:
n = [0, [1, 2, 3], 4, [5, 6]]
n[1] //Contains array [1, 2, 3].
n[1][1] //Contains second index (2) of array [1, 2, 3].
n[3][1] //Contains second index (6) of the array [5, 6].
n.flat //Unifies nested arrays into a single array.

m = [0, [1, [3, 4], 2, 3], 4, [5, 6]]
m.flatten(1) //Unifies nested arrays by levels (from outer to inner).
m = m.flatten(2) //All levels cleared. Reassigning the variable.
m.clump(3) //Opposite of .flat: groupes elements of an array into smaller inner arrays (the argument indicates the number of elements per array).
m.stutter(2) //Repeats each element of the array as many times as indicated in its argument.

//Shortcuts for arrays and operations:
(0..20) //Array from 0 to 20 (step of 1).
(60, 60.25..65) //Array from 60 to 65 (step of 0.25).
(rrand(10, 15)..rrand(16, 20)) //Array between a random value between 10 and 15, and a random value between 16 and 20.
pow((0..1000), 2).plot //Applying the power of 2 to an array from 0 to 1000, then visualizing it (exponential curve).
sin((0, 0.1..20)).plot //Applying a sin function (values from -1 to 1)

//Indexes:
j = [1, 2, 3, 4, 5] //Given this array.
j[3..] //Taking indexes from fourth element to the last (including the fourth).
j[..3] //Taking indexes from the first one up to the fourth (including the fourth).


/////////////////////////////////////////////////////////////////////////////////

//UGENS: SINOSC
//Unit Generators or UGens are classes that create or process signals:
UGen

//First UGen: SinOsc, sine wave oscillator:
SinOsc

//Visualization of a sine wave at 440 (one cycle):
{ SinOsc.ar(440) }.plot(1/440)

//Arguments: frequency, phase, mul, add:
SinOsc.ar(67.midicps, 0, 0.2, 0)

//Using keyword assignment: any arguments in any order:
SinOsc.ar(mul: 0.1, freq: 330)

//Comparison: change of mul and change of add:
(
{
	[
		SinOsc.ar(440, 0, 1), //Different mul: the function is flatter/wider.
		SinOsc.ar(440,0, 4),
	]
}.plot(1/440, minval: -5, maxval: 5) //Displaying one cycle of the sine wave within amplitude values -5 to 5.
)

(
{
	[
		SinOsc.ar(440, 0, 1, 0), //Same mul different add: the function moves upward.
		SinOsc.ar(440, 0, 1, 2)
	]
}.plot(1/440, minval: -3, maxval: 3) //Displaying one cycle of the sine wave within amplitude values -3 to 3.
)

//Function.play: in order to obtain sound, we need to apply the method .play to a function containing our UGen:
{ SinOsc.ar(67.midicps, 0, 0.2, 0) }.play

//Modulating (low frequency): a modulation is the periodic or aperiodic modification of a parameter of a signal (normally, by using another signal):
(
{ var modulating, carrier;

	modulating = SinOsc.ar(1, 0, 500, 1500);
	modulating = modulating.round(125);

	carrier = SinOsc.ar(modulating, 0, 0.2, 0)

}.play
)

//Stereo signal two ways:
(
{ var modulating, carrier;

	modulating = SinOsc.ar(1, 0, 500, 1500);
	modulating = modulating.round(125);

	carrier = SinOsc.ar(modulating, 0, 0.2 !2, 0) //Duplicator (applied to the mul argument).

}.play
)

(
{ var modulating, carrier;

	modulating = SinOsc.ar(1, 0, 500, 1500);
	modulating = modulating.round(125);

	carrier = Pan2.ar(SinOsc.ar(modulating, 0, 0.2, 0), 0) //Pan2 (pos argument: 0 = center, -1 = left, 1 = right, and everything in between).

}.play
)

//Calculation of mul / add in modulations (example 440-880 Hz):
/*
mul = high limit - low limit / 2
add = mul + low limit
*/

//Former range applied to signals: observe the numbers printed by .poll to check the low and high limits of the modulation (440-880):
(
{
	SinOsc.ar(
		SinOsc.ar(1/2, 0, 220, 660).poll(10), //Try other phase values: 0.5pi, 1pi, 1.5pi...
		0,
		0.2 !2,
		0
	)
}.play
)

//Alternative: method .range: same result:
(
{
	SinOsc.ar(
		SinOsc.ar(1/2, 0).range(440, 880).poll(10), //Try other phase values: 0.5pi, 1pi, 1.5pi...
		0,
		0.2 !2,
		0
	)
}.play
)

//Amplitude modulation:
(
{
	SinOsc.ar(
		SinOsc.ar(1/10,1.5pi, 100, 400), //Frequency modulation (low freq).
		0,
		SinOsc.ar(2, 0, 0.25 !2, 0.25) //Amplitude modulation (low freq).
	) * 0.5
}.play
)

//Modulating signal over 20 Hz (creates a new spectrum):
{ SinOsc.ar(SinOsc.ar(880, 1.5pi, 100, 400), 0, 0.1 !2) }.play

//Adding more levels of modulation:
(
{
	SinOsc.ar( //Carrier signal.
		SinOsc.ar( //Frequency modulation (440-880 Hz).
			SinOsc.ar(1/5, 0, 2, 3), //Modulating the frequency at which the modulation occurs (1-5 times per second).
			0.5pi,
			220,
			660),
		0,
		0.1 !2,
		0
	)
}.play
)


/////////////////////////////////////////////////////////////////////////////////

//WAVE SHAPES, NOISE AND FILTERS

//Triangle wave:
{ LFTri.ar(440, 0, 0.5) }.plot(1/440) //Graph: of cycle.
{ LFTri.ar(440, 0, 0.1) }.scope //Oscilloscope and sound.

//Building a triangle wave out of sine waves:
(
{ var freq = 440; //Fundamental freq (overtone 1).

	SinOsc.ar (freq * 1, 0, 1/1.squared)
	+
	SinOsc.ar (freq * 3, 0, 1/3.squared)
	+
	SinOsc.ar (freq * 5, 0, 1/5.squared)
	+
	SinOsc.ar (freq * 7, 0, 1/7.squared)
	+
	SinOsc.ar (freq * 9, 0, 1/9.squared)
	+
	SinOsc.ar (freq * 11, 0, 1/11.squared)
	+
	SinOsc.ar (freq * 13, 0, 1/13.squared)
	+
	SinOsc.ar (freq * 15, 0, 1/15.squared)
	+
	SinOsc.ar (freq * 17, 0, 1/17.squared)
	+
	SinOsc.ar (freq * 19, 0, 1/19.squared)
	+
	SinOsc.ar (freq * 21, 0, 1/21.squared)
	+
	SinOsc.ar (freq * 23, 0, 1/23.squared)
	+
	SinOsc.ar (freq * 25, 0, 1/25.squared)
	*
	0.1 //Total amplitude * 0.1 (compensate addition of signals).
}.scope
)

//Modulating with LFTri:
(
{ var modulating, carrier;

	modulating = LFTri.ar(1, 0, 500, 1500);
	modulating = modulating.round(200);

	carrier = SinOsc.ar(modulating, 0, 0.2)

}.play
)


//Square wave:
//Filtered version (normally, for sound):
{ Pulse.ar(440, 0.5, 0.5) }.plot(2/440)
{ Pulse.ar(440, 0.5, 0.1) }.scope

//Raw version (normally, for LFO):
{ LFPulse.ar(440, 0, 0.5, 0.5) }.plot(2/440)
{ LFPulse.ar(440, 0, 0.5, 0.1) }.scope

//Comparing Pulse and LFPulse: aliasing:
{ Pulse.ar(MouseX.kr(20, 22050, \exponential).poll, 0.5, 0.125) }.scope
{ LFPulse.ar(MouseX.kr(20, 22050, \exponential).poll, 0.5, 0.125) }.scope


//Building a square wave out of sine waves:
(
{ var freq = 440; //Fundamental frequency (overtone 1).

	SinOsc.ar (freq * 1, 0, 1/1)
	+
	SinOsc.ar (freq * 3, 0, 1/3)
	+
	SinOsc.ar (freq * 5, 0, 1/5)
	+
	SinOsc.ar (freq * 7, 0, 1/7)
    +
	SinOsc.ar (freq * 9, 0, 1/9)
	+
	SinOsc.ar (freq * 11, 0, 1/11)
	+
	SinOsc.ar (freq * 13, 0, 1/13)
	+
	SinOsc.ar (freq * 15, 0, 1/15)
	+
	SinOsc.ar (freq * 17, 0, 1/17)
	+
	SinOsc.ar (freq * 19, 0, 1/19)
	+
	SinOsc.ar (freq * 21, 0, 1/21)
	+
	SinOsc.ar (freq * 23, 0, 1/23)
	*
	0.1 //Total amplitude * 0.1
}.scope
)

//Modulating with LFPulse:
{ (SinOsc.ar(440) * LFPulse.ar(1)) * 0.2 }.play


//Saw tooth wave:
//Filtered version (normally, for sound):
{ Saw.ar(440, 0.1, 0) }.plot(2/440)
{ Saw.ar(440, 0.1, 0) }.scope

//Raw version (normally, for LFO):
{ LFSaw.ar(440, 0, 0.1, 0) }.plot(2/440)
{ LFSaw.ar(440, 0, 0.1, 0) }.scope

//Comparing Pulse and LFPulse: aliasing:
{ Saw.ar(MouseX.kr(20, 22050, \exponential).poll, 0.5, 0.125) }.scope
{ LFSaw.ar(MouseX.kr(20, 22050, \exponential).poll, 0.5, 0.125) }.scope

//Building a saw tooth wave out of sine waves:
(
{ var freq = 440; //Fundamental frequency (overtone 1).

	SinOsc.ar (freq * 1, 0, 1/1)
	+
	SinOsc.ar (freq * 2, 0, 1/2)
	+
	SinOsc.ar (freq * 3, 0, 1/3)
	+
	SinOsc.ar (freq * 4, 0, 1/4)
	+
	SinOsc.ar (freq * 5, 0, 1/5)
	+
	SinOsc.ar (freq * 6, 0, 1/6)
	+
	SinOsc.ar (freq * 7, 0, 1/7)
	+
	SinOsc.ar (freq * 8, 0, 1/8)
	+
	SinOsc.ar (freq * 9, 0, 1/9)
	+
	SinOsc.ar (freq * 10, 0, 1/10)
	+
	SinOsc.ar (freq * 11, 0, 1/11)
	+
	SinOsc.ar (freq * 12, 0, 1/12)
	+
	SinOsc.ar (freq * 13, 0, 1/13)
	+
	SinOsc.ar (freq * 14, 0, 1/14)
	+
	SinOsc.ar (freq * 15, 0, 1/15)
	*
	0.1 //Total amplitude * 0.1.
}.scope
)

//We would need approx. 50 sine waves to obtain something close to Saw:
(
{ var freq = 440, signal;

	signal = SinOsc.ar(freq * 1, 0, 1/1); //Fundamental frequency (overtone 1).

	//Repeating 49 times the addition of sine waves (+ the fundamental freq = 50 sine waves):
	49.do({ |i| //Argument "i" = number of iteration (from 0 to 48

		signal = signal + SinOsc.ar(freq * (i + 2), 0, 1/(i + 2)); //i + 2 to avoid the overtone 0 and the overtone 1 (already the fundamental freq).
	});

	signal * 0.05 //Balancing the total amplitude.

}.scope
)

//Modulating with LFSaw:
{ SinOsc.ar(LFSaw.ar(1, 0, 400, 1000), 0, 0.1 !2) }.play


//Low frequency noise generators:
{ LFDNoise0.ar(440, 0.2, 0) }.play //Sound at audio rate.
{ LFDNoise1.ar(440, 0.3, 0) }.play
{ LFDNoise3.ar(880, 0.3, 0) }.play

{ SinOsc.ar(LFDNoise0.ar(10, 500, 1000), 0, 0.2) }.play //Applied to a SinOsc's freq: no interpolation.
{ SinOsc.ar(LFDNoise1.ar(10, 500, 1000), 0, 0.3) }.play //Linear interpolation.
{ SinOsc.ar(LFDNoise3.ar(10, 500, 1000), 0, 0.3) }.play //Cubic interpolation.

{ SinOsc.ar(LFDNoise3.ar(10, 12, 60).midicps, 0, LFDNoise3.ar(3, 0.5, 0).max(0)) }.play //Applied to two parameters and using the method .max

{ SinOsc.ar(5000, 0, LFDNoise0.ar(10, 0.3, 0.3)) }.play //Only amplitude modulation (constant freq).

(
{ var times;

	times = LFDNoise0.ar(1, 4.5, 5.5); //Modulation of an LFDNoise0's frequency with another LFDNoise0.

	Mix(
		SinOsc.ar(
			Array.fill(5, { LFDNoise0.ar(times, 220, 660) }),
			0,
			1/20) //Compensating the addition of signals.
	) !2
}.play
)


//Noise generators:
FreqScope.new //Visualization.

{ ClipNoise.ar(0.1) }.play
{ WhiteNoise.ar(0.1) }.play
{ PinkNoise.ar(0.1) }.play
{ BrownNoise.ar(0.1) }.play
{ GrayNoise.ar(0.1) }.play

//Modulations with noise generators:

{ SinOsc.ar(ClipNoise.ar(1980, 2000), 0, 0.1) }.play
{ SinOsc.ar(WhiteNoise.ar(1980, 2000), 0, 0.1) }.play
{ SinOsc.ar(PinkNoise.ar(7620, 8000), 0, 0.1) }.play
{ SinOsc.ar(PinkNoise.ar(54.5, 76.5).midicps, 0, 0.1) }.play
{ SinOsc.ar(BrownNoise.ar(1980, 2000), 0, 0.1) }.play
{ SinOsc.ar(BrownNoise.ar(54.5, 76.5).midicps, 0, 0.1) }.play

//Duplicator when working with randomness:
{ BrownNoise.ar(0.1) !2 }.play //Mono-duplicated signal: same randomness on each side of the stereo.
{ BrownNoise.ar(0.1 !2) }.play //Duplicated function: different function on each side of the stereo, meaning different randomness.
{ { BrownNoise.ar(0.1) } !2 }.play //Equivalent to the former function: useful when applying the duplicator to signals with no mul (such as Mix).
{ Array.fill(2, { BrownNoise.ar(0.1) }) }.play //Yet another example of the former function.


//Impulse generators:
{ Impulse.ar(1, 0, 0.5) }.play
{ Dust.ar(10, 0.5) }.play

{ SinOsc.ar(440, 0, ToggleFF.ar(Dust.ar(3))) * 0.1 }.play


//Butterworth filters:
{ HPF.ar(PinkNoise.ar, 1000, 0.1) }.play //Filtering a PinkNoise.
{ HPF.ar(PinkNoise.ar, LFTri.ar(1/10, 0, 8000, 8020), 0.1) }.play //LFTri modulating the cut-off freq.

{ LPF.ar(PinkNoise.ar, LFTri.ar(1, 0, 54.5, 76.5).midicps, 0.1) }.play //LFTri modulating the cut-off freq.

{ BPF.ar(PinkNoise.ar, 1000, 0.01, 3) }.play //Try other RQ (0.5-0.005): compensate the amplitude!
(
{
	BPF.ar(
		PinkNoise.ar,
		LFTri.ar(1/10, 0, 54.5, 76.5).midicps, //Modulating the frequency with a LFTri.
		0.01,
		3
	)
}.play
)

(
{
	BRF.ar(
		PinkNoise.ar,
		LFTri.ar(1/10, 0, 54.5, 76.5).midicps,
		1,
		0.3
	)
}.play
)

{ RHPF.ar(PinkNoise.ar, 1000, 0.01, 0.2) }.play

(
{
	Resonz.ar(
		PinkNoise.ar,
		LFTri.ar(1, 0, 8000, 8100),
		0.05,
		1
	)
}.play
)

{ Ringz.ar(Impulse.ar(1), 440, 0.5, 0.1) }.play
{ Ringz.ar(WhiteNoise.ar(1), 440, 1, 0.001) }.play


/////////////////////////////////////////////////////////////////////////////////

//MULTICHANNEL EXPANSION, FILTER BANK AND KLANK

//Multichannel expansion:
s.meter

{ SinOsc.ar(440, 0, 0.1) }.scope //Coming out through left channel (index 0).
{ SinOsc.ar(440, 0, 0.1 !2) }.scope //Coming out through L-R channels (indexes 0-1).
{ SinOsc.ar(440, 0, 0.1 !2) }.scope(outbus: 10) //Changing it to channels 10-11 (we can visualize it, but not listen to it as we don't have 12 loudspeakers).
(
{
	[
		SinOsc.ar(440, 0, 0.1), //Two signals with slightly  different frequency (bringing about one beating per second, as they are 1 Hz off).
		SinOsc.ar(441, 0, 0.1)
	]
}.scope
)

{ SinOsc.ar([440, 441], 0, 0.2) }.play

//Using Mix:
(
{
	Mix(
		SinOsc.ar(
			Array.fill(100, { exprand(30, 8000) }),
			0,
			1/200
		)
	)
}.play
)

{ Mix(SinOsc.ar({ exprand(30, 8000) } !100, 0, 1/200)) }.scope //Equivalent using the duplicator.

//Deconstructing multichannel expansion:
{ RLPF.ar(Saw.ar([100, 250], 0.05), LFDNoise3.ar(1, 1000, 1030), 0.005) }.play

(
{ var noise;

	noise = LFDNoise3.ar(1, 1000, 1030); //Same noise, same randomness.

	[
		RLPF.ar(Saw.ar(100, 0.05), noise, 0.005),
		RLPF.ar(Saw.ar(250, 0.05), noise, 0.005)
	]
}.play
)

( //Different noise, different randomness.
{
	[
		RLPF.ar(Saw.ar(100, 0.05), LFDNoise3.ar(1, 1000, 1030), 0.005),
		RLPF.ar(Saw.ar(250, 0.05), LFDNoise3.ar(1, 1000, 1030), 0.005)
	]
}.play
)

//Another example:
{ Pulse.ar([400, 500, 600], [0.5, 0.1], 0.1) }.play

(
{
	[
		Pulse.ar(400, 0.5, 0.1),
		Pulse.ar(500, 0.1, 0.1),
		Pulse.ar(600, 0.5, 0.1)
	]
}.play
)

//Stereo using Mix:
(
{
	Mix(
		[
			[BrownNoise.ar(0.1), SinOsc.ar(220, 0, 0.1)],
			[Dust.ar(50, 0.2), Saw.ar(LFDNoise3.ar(1, 3000, 4000), 0.1)],
		]
	)
}.scope
)

(
{
	Pan2.ar(
		Mix(SinOsc.ar({ exprand(30, 8000) } !100, 0, 1/200)),
		SinOsc.ar(1/2, 0, 1)
	)
}.play
)

{ Mix(SinOsc.ar({ exprand(30, 8000) } !100, 0, 1/200)) !2 }.play //Mono-duplicated (same frequencies on both sides).
{ { Mix(SinOsc.ar({ exprand(30, 8000) } !100, 0, 1/200)) } !2 }.play //Duplicated function (different frequencies on each side, richer sound).

{ Splay.ar(SinOsc.ar({ exprand(30, 8000) } !100, 0, 1/200), 1, 2.5) }.play //Splay: distribution of a mono signal in the stereo field.

//Comparing these two codes:
(
{
	Mix.ar(
		Array.fill(18, { Ringz.ar(WhiteNoise.ar(0.0001), exprand(100, 3000)) })
	) !2
}.play
)

(
{
	Mix.ar(
		Ringz.ar(
			WhiteNoise.ar(0.0001),
			Array.fill(18, { exprand(100, 3000) })
		)
	) !2
}.play
)

//Deconstruction of Mix:
(
{ var freqDeviation;

	freqDeviation = LFNoise2.ar(0.05, 0.2, 1);

	Mix(
		BPF.ar(
			BrownNoise.ar,
			f = Array.geom(5, 440, 3/2) * freqDeviation,
			0.05/f,
			[24, 30].dbamp
		)
	)
}.play
)

(
{ var freqDeviation, noise, amps, freqs;

	freqDeviation = LFNoise2.ar(0.05, 0.2, 1);

	noise = BrownNoise.ar;
	freqs = Array.geom(5, 440, 3/2) * freqDeviation;
	amps = [24, 30].dbamp;

	Mix.ar(
		[
			BPF.ar(noise, freqs[0], 0.05/freqs[0], amps[0]),
			BPF.ar(noise, freqs[1], 0.05/freqs[1], amps[1]),
			BPF.ar(noise, freqs[2], 0.05/freqs[2], amps[0]),
			BPF.ar(noise, freqs[3], 0.05/freqs[3], amps[1]),
			BPF.ar(noise, freqs[4], 0.05/freqs[4], amps[0])
		]
	)
}.play
)

//Filter banks:
(
{
	Mix(
		BPF.ar(
			PinkNoise.ar,
			Array.geom(16, 30, 3/2), //Pitagoric fifths (perfect fifths).
			0.001,
			5
		)
	) !2
}.play
)

(
{
	Mix(
		BPF.ar(
			PinkNoise.ar,
			Array.geom(16, 30, 7.midiratio), //Tempered fifths (equal temperament).
			0.001,
			5
		)
	) !2
}.play
)

(
{
	Mix(
		BPF.ar(
			PinkNoise.ar,
			Array.geom(8, 30, 2), //Octaves.
			0.001,
			3
		)
	) !2
}.play
)

(
{ var freqs;

	freqs = Array.geom(8, 30, 2) //Octaves
	++
	Array.geom(16, 30, 1.5); //Fifths (3/2 = 1.5).

	Mix(
		BPF.ar(
			PinkNoise.ar,
			freqs,
			0.005,
			2
		)
	) !2
}.play
)

(
{ var freqs, amps;

	freqs = Array.geom(10, 30, 2)
	*
	Array.fill(10, { |i| ((i + 1 / 10) * 0.5).midiratio }); //Frequency deviation.

	amps = Array.geom (10, 1, 0.96); //Amplitude deviation.

	Mix(
		BPF.ar(
			PinkNoise.ar,
			freqs,
			0.01,
			amps
		)
	) !2
}.play
)

//Klank filter:
`[
	Array of freqs,
	Array of amps,
	Array of decay times
]

(
{
	Klank.ar(
		`[
			Array.fill(8, { exprand(150, 14000) }),
			1,
			Array.fill(8, { exprand(0.002, 0.02) }) * 32
		],
		{ PinkNoise.ar(0.01) } !2
	)
}.play
)

(
{
	Klank.ar(
		`[
			[178.4, 570.3, 7384, 605, 356.9, 1150.6, 14768, 1210],
			1,
			[0.002, 0.012, 0.018, 0.013, 0.002, 0.012, 0.018, 0.013]
		],
		{ Dust.ar(3, 0.1) } !2
	)
}.play
)

(
{
	Klank.ar(
		`[
			[178.4, 570.3, 7384, 605, 356.9, 1150.6, 14768, 1210],
			1,
			[0.002, 0.012, 0.018, 0.013, 0.002, 0.012, 0.018, 0.013] * 16
		],
		{ Dust.ar(3, 0.1) } !2
	)
}.play
)


/////////////////////////////////////////////////////////////////////////////////

//ENVELOPES, TRIGGER AND GATE

//Basic syntax:
EnvGen.ar(Env(levels, times, curve), gate)

//Linear curve:
Env([0, 0.5, 0.1, 0.5, 0], 1, \linear).plot

(
{ var signal, env, envGen;

	env = Env([0, 0.5, 0.1, 0.5, 0], 1, \linear); //The time from one level to the next will always be 1 in here.
	envGen = EnvGen.ar(env);

	signal = SinOsc.ar;

	signal * envGen
}.play
)

//Exponential curve:
Env([0.001, 0.5, 0.1, 0.5, 0.001], [1, 4, 6, 2], \exponential).plot

(
{ var signal, env, envGen;

	env = Env([0.001, 0.5, 0.1, 0.5, 0.001], 1, \exponential);
	envGen = EnvGen.ar(env);

	signal = SinOsc.ar;

	signal * envGen
}.play
)

//Step curve:
Env([0, 0.5, 0.1, 0.5, 0], 1, \step).plot

(
{ var signal, env, envGen;

	env = Env([0, 0.5, 0.1, 0.5, 0], 1, \step);
	envGen = EnvGen.ar(env);

	signal = SinOsc.ar;

	signal * envGen
}.play
)

//Curve defined by floats:
Env([0, 0.5, 0.1, 0.5, 0], 1, 4).plot //Try -4 and [4, -4].

(
{ var signal, env, envGen;

	env = Env([0, 0.5, 0.1, 0.5, 0], 1, [4, -4]);
	envGen = EnvGen.ar(env);

	signal = SinOsc.ar;

	signal * envGen
}.play
)

//Array of different curves:
Env([0, 0.5, 0.1, 0.5, 0], 1, [8, -4, \exponential, 0]).plot

(
{ var signal, env, envGen;

	env = Env([0, 0.5, 0.1, 0.5, 0], 1, [8, -4, \exponential, 0]);
	envGen = EnvGen.ar(env);

	signal = SinOsc.ar;

	signal * envGen
}.play
)

//Envelope of frequencies:
(
{ var freq;

	freq = EnvGen.ar(Env([39, 61, 50] + 12, 2, \linear)).midicps;

	SinOsc.ar(freq, 0, 0.5)
}.play
)

//Method .circle and randomness:
(
{ var freq;

	freq = EnvGen.ar(
		Env(Array.fill(5, { rrand (60, 104) }),
			Array.fill(4, { rrand(0.2, 1) }),
			\linear
		).circle
	).midicps;

	SinOsc.ar(freq, 0, 0.2)
}.play
)

//Last example: filter bank:
(
{ var grow, freq;

	grow = EnvGen.ar(Env([2/1, 3/2, 7/4], [8, 4], \exponential).circle);
	freq = Array.geom(10, 35, grow);

	{ Mix(
		BPF.ar(
			PinkNoise.ar,
			freq,
			0.01,
			1
		)
	) } !2
}.play
)

//Envelope methods:
Env.triangle(1, 0.3).plot
{ SinOsc.ar * EnvGen.ar(Env.triangle(1, 0.3).circle) }.play

Env.sine(1, 0.3).plot
{ SinOsc.ar * EnvGen.ar(Env.sine(1, 0.3).circle) }.play

Env.perc(0.01, 0.25, 0.3, -4).plot
{ SinOsc.ar * EnvGen.ar(Env.perc(0.01, 0.25, 0.3, -4).circle) }.play


//TRIGGER
(
{ var trigger, signal, env;

	trigger = Impulse.ar(1); //Try with 2 and with Dust.
	signal = SinOsc.ar;
	env = EnvGen.ar(Env.perc(0.01, 0.5, 0.3), trigger);

	signal * env
}.play
)

//Randomness:
(
{ var freq, trigger, times, signal;

	trigger = Impulse.ar(1/4);
	times = [rrand(0.5, 3)];

	freq = Array.fill(5, {
		EnvGen.ar(Env(Array.fill(5, { exprand(60, 78).midicps }), times, \step), trigger)
	});

	/*
	freq = Array.fill(5, {
	EnvGen.ar(Env(Array.fill(5, { exprand(60, 78).midicps }), [rrand(0.5, 3)], \step), trigger)
	});
	*/

	signal = Mix.ar(
		SinOsc.ar(
			freq,
			0,
			0.1
		)
	) !2;

	signal * 0.5

}.play
)


//GATE

//Basic syntax:
Env.adsr(attackTime, decayTime, sustainLevel, releaseTime, peakLevel, curve)

//Graphical representation:
{ EnvGen.ar(Env.adsr, LFPulse.ar(1)) }.plot(2)
{ EnvGen.ar(Env.asr, LFPulse.ar(1)) }.plot(2)

//Applying gate:
(
a = { |gate = 1|
	var env;

	env = EnvGen.ar(Env.adsr(0.1, 0.2, 0.5, 1, 0.6, -4), gate);

	SinOsc.ar !2 * env
}.scope
)

a.set(\gate, 0)
a.set(\gate, 1)

//DoneAction = 2:
(
a = { |gate = 1|
	var env;

	env = EnvGen.ar(Env.adsr(0.1, 0.2, 0.5, 1, 0.6, -4), gate, doneAction: 2);

	SinOsc.ar !2 * env * 0.5
}.scope
)

a.set(\gate, 0)
a.set(\gate, 1)

//Using LFPulse to open / close the gate periodically:
(
{ var gate, signal, env;

	gate = LFPulse.ar(0.5, 0, 0.5);

	signal = SinOsc.ar;

	env = EnvGen.ar(Env.adsr(0.01, 0.1, 0.3, 1, 0.3), gate);

	signal !2 * env
}.play
)

//Extra: Line and XLine:
{ SinOsc.ar(Line.ar(60, 84, 5).midicps, 0, 0.1 !2) }.play
{ SinOsc.ar(XLine.ar(260, 1046, 5), 0, 0.1 !2) }.play


/////////////////////////////////////////////////////////////////////////////////

//MODULATIONS AND DECAY LINES

//Ring modulation:
{ SinOsc.ar(207) !2 * SinOsc.ar(88) * 0.2 }.play

//Amplitude modulation (AM):
{ SinOsc.ar(207) !2 * SinOsc.ar(88, 0, 0.5, 0.5) * 0.2 }.play

//Other examples:
{ BrownNoise.ar(0.3) * SinOsc.ar(LFDNoise3.ar(1, 1000, 2000)) }.play
{ BrownNoise.ar(0.2 !2) * SinOsc.ar(500) }.play //Try out 100, 50, 20, 10 for the SinOsc frequency.
{ Saw.ar(200) * LFDNoise3.ar(200 !2, 0.2) }.play

//Ring modulation applied to an audio sample:
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav")

{ PlayBuf.ar(b.numChannels, b.bufnum, loop: 1) * SinOsc.ar(MouseX.kr(20, 14000, \exponential).poll) !2 }.play

(
{ var signal, mod;

	signal = PlayBuf.ar(b.numChannels, b.bufnum, loop: 1);

	mod = SinOsc.ar(MouseX.kr(20, 14000, \exponential).poll) !2;
	(signal + (signal * mod * 0.5))

}.play
)

//Ring modulation methods:
ring1: //(a * b) + a
ring2: //(a * b) + a + b
ring3: //a * a * b
ring4: //(a * a * b) - (a * b * b)

{ SinOsc.ar(207) ring1: SinOsc.ar(88) !2 * 0.1 }.play

{ SinOsc.ar(207) ring2: SinOsc.ar(88) !2 * 0.1 }.play

{ BrownNoise.ar(0.5) ring3: SinOsc.ar(LFDNoise3.ar(1, 1500, 2000), 0, 0.3 !2) }.play

{ BrownNoise.ar(0.5) ring4: SinOsc.ar(LFDNoise3.ar(1, 1500, 2000), 0, 0.3 !2) }.play

{ SinOsc.ar(7000, 0, 0.2) ring4: SinOsc.ar(LFDNoise3.ar(3, 125, 7000), 0, 0.3 !2) }.play

//Frequency modulation (FM):
//More info in these two tutorials:
//https://www.youtube.com/watch?v=UoXMUQIqFk4&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=22
//https://www.youtube.com/watch?v=dLMSR2Kjq6Y&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=23

{ SinOsc.ar(500 + SinOsc.ar(1)) * 0.1 !2 }.scope
{ SinOsc.ar(500 + SinOsc.ar(1, 0, 20)) * 0.1 !2 }.scope
{ SinOsc.ar(500 + SinOsc.ar(8, 0, 400)) * 0.1 !2 }.scope
{ SinOsc.ar(500 + SinOsc.ar(22, 0, 400)) * 0.1 !2 }.scope //Audio rate limit.
{ SinOsc.ar(500 + SinOsc.ar(80, 0, 400)) * 0.1 !2 }.scope

{ SinOsc.ar(MouseY.kr(500, 5000, 1).poll + SinOsc.ar(MouseX.kr(1, 2000, 1).poll, mul: LFNoise0.kr(8).range(400, 4500))) * 0.1 !2 }.scope

//Decay lines:
{ BrownNoise.ar !2 * Decay.ar(Impulse.ar(0.5), 1, 0.2) }.play

(
{ var impulse;

	impulse = Impulse.ar(0.5);

	{ Mix(
		Ringz.ar(
			impulse,
			[52, 7000, 14550],
			[3, 0.3, 2],
			0.4
		)
	)

	ring1:

	WhiteNoise.ar(Decay.ar(impulse, 0.04))
	} !2 * 0.2

}.scope
)
