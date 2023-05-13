b//Sound synthesis basics - Presentation (beginner group)
/////////////////////////////////////////////////////////////////////

/*
Some usefult links:
https://doc.sccode.org/Help.html (online SC guide)
https://supercollider.github.io/tutorials/
https://doc.sccode.org/Help.html
https://scsynth.org/
https://github.com/madskjeldgaard/awesome-supercollider
http://sccode.org/
https://github.com/supercollider/supercollider/wiki/Code-style-guidelines (these four about code style)
https://blog.alexdevero.com/6-simple-tips-writing-clean-code/
https://medium.com/coding-skills/clean-code-101-meaningful-names-and-functions-bf450456d90c
https://scsynth.org/t/some-notes-on-writing-supercollider-code-for-non-programmers/1940
*/

//SC is an open source: anyone can contribute with the creation of new tools, extensions, etc., and with the enhancement of the existing ones, and there is an active and helpful community of users and contributors (https://supercollider.github.io/#community).
//SC is free to use, light in the computer, easy to get some sound out of it.
//Overwhelming amount of tools and resources, and different ways of doing the same thing (shortcuts, alternative syntax, etc.): stick to the basics, keep consistency, and, after adquiring a solid ground, experiment, seek your own way to attain your objectives.

//OOP
//SC is an OOP (object-oriented programming language), a programming paradigm based on the concept of "object" (a thing that does something or represents something). Two main kinds of objects in SC are classes and methods. Methods are instructions and classes hold information about how to respond to those instructions. Classes are organized within a hierarchy defining their properties. In the class tree, we can see that all classes come from the main branch called "Object". Objects created by classes are called instances (so, all classes are instances of the root class Object).
//Class tree: https://doc.sccode.org/Overviews/ClassTree.html
CombC //Open the Help file (ctrl + D) and observe how, for instance, CombC comes from CombN --> PureUGen --> UGen --> AbstractFunction --> Object (Some info about "inheritance" in the last paragraph of this tutorial: https://doc.sccode.org/Tutorials/Getting-Started/12-Groups.html).

/*
Architecture of SC: https://doc.sccode.org/Guides/ClientVsServer.html
SC application is based on two autonomous components (two different programs): the server and the client; and an IDE:
- The IDE (Integrated Development Environment): is the environment we see here, the text editor, the menu bar, the postwindow, the status bar, etc. https://doc.sccode.org/Guides/SCIde.html
- The language: features a specific syntax, that is to say, a set of rules and symbols to express something in that language.
- The interpreter: if the language is the letter, the interpreter is the mailman. The language and interpreter form the client (sclang). The interpreter translates the language into OSC (Open Sound Control) messages for the server.
- The audio server (scsynth): receives OSC messages from a client and carries out the sound synthesis.
Because of client and server are two different and independent programs, the audio server can receive OSC messages from a client different than sclang (the so-called external applications in the third diagram of the link). Nevertheless, sclang is dessigned to provide with the expressive power of SC language.
*/


//DATA TYPES
//Data types are different ways of representing and interpreting data (information). They are usually represented as Literals: Literals are objects whose value is represented directly in the code (rather than created out of sending a message to an object): https://doc.sccode.org/Reference/Literals.html

//Numbers: can be integers or floating-point numbers (floats):
//Limits of integer numbers: 32 bits:
2 ** 31 //Representation limit (already expressed as a float).
2147483647 + 1 //Crossing the limit (folds into the nevative values).

//Limits of float representation: 64 bits (but limitation regarding the infinite numbers in between two numbers):
(-1, -0.8..1) //0.0 does not exist in this list of numbers, but some number extremely close to it.
(0, 0.2..1) //0.0 does appear in this list nevertheless.

(0.1 !10).sum == 1.0 //"False".
(0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1) //But equal to 1.0 in fact.

//Additional discussion: https://www.sounddevices.com/32-bit-float-files-explained/

//Other floats:
1.2e4
1.2e-4 //Exponential notation.
pi
0.5pi //pi constant.
inf //Infinite.

//Strings: strings are arrays of characters between douple quotes:
"string"
"string".scramble //We can apply methods to strings.

//Symbols: a symbol points to something, that is to say, it represents something. They can be written in two ways:
\symbol
'symbol'

//Equality and Identity in SuperCollider (symbols VS strings):
//Symbols containing the same characters represent the same object:
\abc == \abc //True
\abc === \abc //True

//Strings containing the same characters do not represent the same object:
"abc" == "abc" //True
"abc" === "abc" //False

//Notice that a single "=" is only used to assign data to variables and arguments.

//Other special values:
true
false
nil //(empty)

//Identifiers: they can be variables or methods:
//Examples of variables: variables are data containers.
var hello, filter_func

//Examples of methods: methods send messages to objects called "receivers". There are two kinds of methods: class methods are sent to classes to create objects; instance methods are applied to what a class has created to somehow modify it:
.play, .midicps, .round

//Classes: classes create and modify objects when receiving messages sent by methods and defined by their arguments (parameters that can be modified by specifying their value).
Server
SinOsc
HPF


//MATHEMATICAL OPERATIONS
//Unary operations are applied to single numbers (normally, using methods); binary operations are performed between two or more numbers.
//Here is a list of common unary and binary operators in SC: https://doc.sccode.org/Overviews/Operators.html.

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
69.midicps //Midi to Hz (cycles per second) converter.
440.cpsmidi //Hz to midi converter.
1.57.asInteger //Turns a float into an integer by rounding down (also shortcut .asInt).

//Randomness with numbers:
10.rand //From 0 to 9.
333.rand + 100 //From 100 to 432.
5.xrand //Excludes 0 (from 1 to 5).
5.xrand(1) //Excludes 1.
5.xrand2 //Includes negative values (no 0 by default).
10.rand2 //Includes negative values (including 0).
rrand(0.1, 4) //Random numbers within a range with uniform distribution (both integers = integers only; at least one of them float = all float results) --> Polymorphism: "the ability for different kinds of objects to respond differently to the same message" (different kinds ob object: int / float | same message: rrand): https://doc.sccode.org/Guides/Polymorphism.html
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

//Avoid spaces between before or after [] or (), but allow spaces after { and before }.

/////////////////////////////////////////////////////////////////////////////////

//VARIABLES
//Variables are data containers

//Non-declared (global): variables a-z are non-declared variables or global variables, which can be used wherever in the code (excluding "s", which contains the audio server):
a = 1 //1 is assigned to "a", thus "a" represent a 1.
a + 1 //2

this.dump //Shows the "instance of the interpreter", which includes all global variables and their current values.

//Declared variables: they can only be called within the portion of code within which they are declared:
(
var value1, value2, power;

value1 = 2; //If we try to evaluate this single line, SC will tell us that the variable "value1" is not declared.
value2 = 16;
power = value1 ** value2
)

//Non-declared with descriptive name: they can be used anywhere in the code just like a global variable:
~value1


//FUNCTIONS
//A Function is an expression which defines operations to be performed when it is sent the .value message and a list of arguments in the order they were declared within the function (arguments are the values we can pass to the function as "inputs"). They are written between curly brackets.

//Useless example (no arguments = fixed result):
a = { 1 + 1 }
a.value

//Less useless example: all instructions are interpreted in one shot, one after another in order, and only the last line's result is printed in the postwindow:
(
f = { |value1 = 1, value2 = 5, deviation = 0.9| //List of argument and their default values (to be replaced by those sent from .value).
	var result;

	result = value1 + value2;
	result = result * deviation
}
)

f.value(2, 3, 0.09) //Evaluating the function and sending values to its arguments.
f.value(deviation: 0.99) //Keyword assignment: specifying the arguments in any order.
f.value(3, value2: 6) //You can mix normal arguments (in order) and keyword arguments.

//Area of a trapezoid A = ((a + b) / 2) * h:
(
{ |shortBase = 2, longBase = 3, height = 2|
	var area;

	area = shortBase + longBase / 2; //Remember that there is no hierarchy regarding the operations in SC: they will be performed from left to right.
	area = area * height

}.value(1, 2, 2) //Method .value applied to the block of code directly because there is no global variable.
)


//METHODS
//Methods define the operations that classes can perform when receiving them. A message is the request for an object to perform an operation (is the request itself, the operation and the act of assigning it to an object), and a method is the physical form of the message (the text we write, representing the message, and its arguments, which describe the opertions necessary when sending a message to a particular class):

//Silly example of how classes and methods work together:
//Imaginary classes:
Sandwich
Ham

//Imaginary methods:
Sandwich
* prepare //Class method (creates the sandwich), indicated with an asterisk.
hitUp //Instance methods (modify the sandwich).
cut

Ham
* marinate //Class method (creates the ham).
fry //Instance method (modify the ham).

//Syntax object-message: receiver.method(arguments):
Sandwich.prepare

//Real example in SC: a sine wave receives the method .ar, which makes it create an audio rate signal (class method), with a list of arguments defining the frequency, phase, and amplitude of that signal; then, the signal is placed into a function to which the method .play is applied in order to play the signal (instance method). When playing the signal, we can see in the postwindow that a synth, a signal that actually runs in the audio server (one instance of a synth definition, data about UGens and how they are interconnected, but this does not matter right now) has been created:
{ SinOsc.ar(440, 0, 0.1, 0) }.play

//Defining imaginary arguments:
Sandwich{

	//Class method:
	*prepare{ //List of arguments and default values.
		arg extraIngredients = ['tomato', 'cheese'], bread = 'baguette', meat = 'chicken';
	}

	//Instance methods:
	hitUp{ arg temp = 50, time = 120;
	}

	cut{ arg numPieces = 2;
	}
}

SinOsc //Press ctrl + i (and double click on SinOsc in the list): source code of SinOsc (resembling out imaginary example).

//Applying out imaginary methods to our imaginary classes:

Sandwich.prepare(['tomato'], 'baguette', 'tofu')
Sandwich.prepare(meat: 'tofu') //Keyword assignment.

//Now adding the other class:
a = Sandwich.prepare(
	['pepper'],
	'baguette',

	Ham.marinate.fry(260) //First argument of the method .fry is temp (for instance) --> Help doc should indicate what is the unit of temp (just like in SinOsc.ar it is indicated that the unit of frequency is the Hz).
)

//Applying instance methods:
a = a.hitUp
a = a.cut(4) //Arg of .cut is number of pieces.

//Coming back to polymorphism (https://doc.sccode.org/Guides/Polymorphism.html), this is a very importance feature of SC because, for instance, different classes can receive the same message and will respond differently to it ("a message generally has some underlying meaning and it is the responsibility of each class to respond in a way appropriate to that meaning"). For example, the method .ar is used to create audio rate signals: when applied to SinOsc, it will create a sine wave oscillator at audio rate, and when applied to LFTri, it will create a triangle wave oscillator.


//COLLECTIONS: ARRAY
//A collection is an object containing a group of objects: the elements (or items) of the collection. There are many types of collections, but Array is the most common one. A collection between square brackets is by default an Array. The elements of an array are separated by commas and they are assigned an integer called "index" which represent the position or order of the element within the array.

//Homogeneous collection of integers:
[1, 2, 3, 4, 5]

//Heterogemeous collection (symbol, integer, string and sine oscillator function):
[\symbol, 67, "string", { SinOsc.ar(mul: 0.1) }]

//An array assigned to a global variable:
a = [1, 2, 3, 4, "hello", { SinOsc.ar(mul: 0.1) }]

//We can acceed to each element using their index (the first element is always represented by index = 0):
a[0] //= 1
a[4] //= "hello"
a[5].play //Applying the method .play to the function in index 5.
a.at(0) //Equivalent to a[0].

//CLASS METHODS for arrays: these class methods create arrays:
//Array.fill: creates an array with a specific size by evaluating a function as many times as the size states:
Array.fill(6, { rrand(0, 11) }) //Six random numbers from 0 to 11.

Array.fill(6, { |i| i }) //Using the "index" argument: printing the index numbers (0 to 5).

Array.fill(6, { |i| [i, rrand(0, 11)] }) //Array of six arrays containing the index number and a random number each.

//Duplication (!n) of a function is equivalent to Array.fill:
({ |i| [i, rrand(0, 11)] } !6) //equal to:

Array.fill(6, { |i| [i, rrand(0, 11)] })

//Array.series: creates an arithmetic series within an array: arguments are the size, the starting value and the step (a value added to each element of the series):
Array.series(12, 0, 1) //Series from 0 to 11 with a step of 1.

Array.series(24, 60, 0.5) //Series representing a scale of quarter tones within an octave from 60 MIDI (for instance, if applied to sound).

//Visualizing arrays:
x = Array.series(50, 0, 5)
x.plot(discrete: true) //Discontinuous points.
x.plot(discrete: false) //Continuous line (although the content of the array is still a series of "points"), by default, no need to indicate.

//Array.geom: creates a geometric series within an array: arguments are the size, the starting value and the "grow" (a product by which each element of the series is multiplied):
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
//https://doc.sccode.org/Guides/UGens-and-Synths.html (basic concepts UGen, Synth).
//https://doc.sccode.org/Guides/Tour_of_UGens.html (guide of most common UGens, useful to find resources).
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


//Low frequency noise generators: three different interpolations (how it moves from one value to the next):
//Frequency above the 20 Hz limit (any repetition or iteration performed above 20 Hz of frequency will bring about a frequency spectrum):
{ LFDNoise0.ar(440, 0.2, 0) }.play //Step interpolation.
{ LFDNoise1.ar(440, 0.3, 0) }.play //Linear interpolation.
{ LFDNoise3.ar(880, 0.3, 0) }.play //Cubic interpolation.

//Normally used for aperiodic low frequency modulations:
{ SinOsc.ar(LFDNoise0.ar(10, 500, 1000), 0, 0.2) }.play //Applied to a SinOsc's freq: no interpolation.
{ SinOsc.ar(LFDNoise1.ar(10, 500, 1000), 0, 0.3) }.play //Linear interpolation.
{ SinOsc.ar(LFDNoise3.ar(10, 500, 1000), 0, 0.3) }.play //Cubic interpolation.

{ SinOsc.ar(LFDNoise3.ar(10, 12, 60).midicps, 0, LFDNoise3.ar(3, 0.5, 0).max(0)) }.play //Applied to two parameters and using the method .max (usefult to create random gaps).

{ SinOsc.ar(5000, 0, LFDNoise0.ar(10, 0.3, 0.3)) }.play //Only amplitude modulation (constant freq).

(
{ var times;

	times = LFDNoise0.ar(1, 4.5, 5.5); //Modulation of an LFDNoise0's frequency with another LFDNoise0 (random value each second).

	Mix( //Five sine waves with different random frequencies mixed into a single channel (and then duplicated on both channels).
		SinOsc.ar(
			Array.fill(5, { LFDNoise0.ar(times, 220, 660) }), //Random frequency value each 1 to 10 seconds.
			0,
			1/20) //Compensating the addition of signals.
	) !2
}.play
)


//Noise generators: normally used for generating sound (very useful for filtering as they contain all the spectrum or a wide part of it):
FreqScope.new //Visualization of the spectrum.

{ ClipNoise.ar(0.1) }.play //Brightest (chooses values from the extremes of the spectrum).
{ WhiteNoise.ar(0.1) }.play //Bright (although all frequencies feature the same probability of been chosen).
{ PinkNoise.ar(0.1) }.play //Perceived as "plain" noise, but in fact, spectrum falling 3dB per octave.
{ BrownNoise.ar(0.1) }.play //Darkest because values chosen out of Brownian motion. Also spectrum falling 6dB per octave.
{ GrayNoise.ar(0.1) }.play //Based on digital synthesis: flipping random values in the binary code.

//Modulations with noise generators (although no longer low frequency modulations as the noise runs at 44100 Hz/s):
{ SinOsc.ar(ClipNoise.ar(1980, 4000), 0, 0.1) }.play
{ SinOsc.ar(WhiteNoise.ar(1980, 2000), 0, 0.1) }.play
{ SinOsc.ar(PinkNoise.ar(7620, 8000), 0, 0.1) }.play
{ SinOsc.ar(PinkNoise.ar(54.5, 76.5).midicps, 0, 0.1) }.play
{ SinOsc.ar(BrownNoise.ar(1980, 4000), 0, 0.1) }.play
{ SinOsc.ar(BrownNoise.ar(54.5, 76.5).midicps, 0, 0.1) }.play

//Duplicator when working with randomness:
{ BrownNoise.ar(0.1) !2 }.play //Mono-duplicated signal: same randomness on each side of the stereo.
{ BrownNoise.ar(0.1 !2) }.play //Duplicated function: different function on each side of the stereo, meaning different randomness.
{ { BrownNoise.ar(0.1) } !2 }.play //Equivalent to the former function: useful when applying the duplicator to signals with no mul (such as Mix).
{ Array.fill(2, { BrownNoise.ar(0.1) }) }.play //Yet another example of the former function.


//Impulse generators (commonly used as triggers):
{ Impulse.ar(1, 0, 0.5) }.play //Single impulse (contains all freq spectrum) = click.
{ Dust.ar(10, 0.5) }.play //Random impulse generator (density = average of impulses per second).

//For example, ToggleFF acts as a switch, but needs a trigger: Dust can act as its trigger (applied to the amplitude of the SinOsc):
{ SinOsc.ar(440, 0, ToggleFF.ar(Dust.ar(3))) * 0.1 }.play //Morse code :)


//Butterworth filters (2nd order = -12dB per octave):
//https://en.wikipedia.org/wiki/Butterworth_filter (about Butterworth filters).
//https://depts.washington.edu/dxscdoc/Help/Tutorials/Mark_Polishook_tutorial/14_Subtractive_synthesis.html (some info about filters in this link about subtractive synthesis).

//High-pass filter:
{ HPF.ar(PinkNoise.ar, 1000, 0.1) }.play //Filtering a PinkNoise.
{ HPF.ar(PinkNoise.ar, LFTri.ar(1/10, 0, 8000, 8020), 0.1) }.play //LFTri modulating the cut-off freq.

//Low-pass filter:
{ LPF.ar(PinkNoise.ar, LFTri.ar(1, 0, 54.5, 76.5).midicps, 0.1) }.play //LFTri modulating the cut-off freq.

//Band-pass filter (RQ value, the lower, the narrower the pass band):
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

//Band-reject filter:
(
{
	BRF.ar(
		PinkNoise.ar,
		LFTri.ar(1/10, 0, 54.5, 76.5).midicps,
		1, //If the RQ is too small, the rejected band will no longer be noticeable.
		0.3
	)
}.play
)

//Resonant high-pass filter:
{ RHPF.ar(PinkNoise.ar, 1000, 0.01, 0.2) }.play

//Resonz filter (bwr = RQ):
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

//Ringz filter (decay time):
{ Ringz.ar(Impulse.ar(1), 440, 0.5, 0.1) }.play
{ Ringz.ar(WhiteNoise.ar(1), 440, 1, 0.001) }.play


/////////////////////////////////////////////////////////////////////////////////

//MULTICHANNEL EXPANSION, FILTER BANK AND KLANK

//Multichannel expansion:
//In SC channels are arrays: a single signal will be played by default through channel 0, whereas an array of two signals will be played through channels 0 and 1. Therefore, a stereo signal is an array of two elements (signals).

s.meter //Visualization of the default channels reserved for output and input signals.

{ SinOsc.ar(440, 0, 0.1) }.scope //Coming out through left channel (index 0).
{ SinOsc.ar(440, 0, 0.1 !2) }.scope //Coming out through L-R channels (indexes 0-1).
{ SinOsc.ar(440, 0, 0.1 !2) }.scope(outbus: 10) //Changing it to channels 10-11 (we can visualize it, but not listen to it as channels 10-11 are "private" channels for internal routing).
//More on this topic: https://doc.sccode.org/Tutorials/Getting-Started/11-Busses.html
(
{
	[
		SinOsc.ar(440, 0, 0.1), //Two signals with slightly  different frequency (bringing about one beating per second, as they are 1 Hz off).
		SinOsc.ar(441, 0, 0.1)
	]
}.scope
)

{ SinOsc.ar([440, 441], 0, 0.2) }.play //Equivalent code: an array of two elements in the argument of a signal creates as many instances of that signal as elements present in the array.

//Using Mix: mixing an array of signals into a single channel:
(
{
	Mix(
		SinOsc.ar(
			Array.fill(100, { exprand(30, 8000) }), //An array of 100 frequencies will bring about 100 sine oscillators.
			0,
			1/200 //Compensating the amplitude: total amplitude of 0.5.
		)
	)
}.play
)

{ Mix(SinOsc.ar({ exprand(30, 8000) } !100, 0, 1/200)) }.scope //Equivalent using the duplicator.

//How Mix works:
a + b + c = [a, b, c].sum = Mix([a, b, c])

//Deconstructing multichannel expansion (useful practice to understand how signals are expanded and distributed among channels):
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

//Another example: bigger array gives number of instances, shorter array wraps:
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
//Two levels of arrays of signals (and no more: in Help file "Multichannel Expansion" --> "Reducing channel expansion with Mix": "You cannot use Mix on arrays of arrays of arrays").
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

//Using Pan2: as Mix is a mono signal, we can apply Pan2 to it:
(
{
	Pan2.ar(
		Mix(SinOsc.ar({ exprand(30, 8000) } !100, 0, 1/200)),
		SinOsc.ar(1/2, 0, 1) //Low freq modulation of the position argument.
	)
}.play
)

//Using the duplicator:
{ Mix(SinOsc.ar({ exprand(30, 8000) } !100, 0, 1/200)) !2 }.play //Mono-duplicated (same frequencies on both sides).
{ { Mix(SinOsc.ar({ exprand(30, 8000) } !100, 0, 1/200)) } !2 }.play //Duplicated function (different frequencies on each side, richer sound).

//Using Splay: distribution of a mono signal in the stereo field (instead of 100 different freqs on each side, the 100 freqs will be distributed amond both sides of the stereo):
{ Splay.ar(SinOsc.ar({ exprand(30, 8000) } !100, 0, 1/200), 1, 2.5) }.play //Second argument is "spread" (when = 0, all signals go to the center, when = 1, the distribute among the -1 to 1 stereo field, and everything in between), and third argument is "level" (for amplitude compensation).

//Comparing these two codes:
(
{
	Mix.ar(
		Array.fill(18, { Ringz.ar(WhiteNoise.ar(0.0001), exprand(100, 3000)) }) //There will be 18 different white noises (if put into a variable, equivalent to next code).
	) !2
}.play
)

(
{
	Mix.ar(
		Ringz.ar(
			WhiteNoise.ar(0.0001), //A unique noise is shared among the 18 filters.
			Array.fill(18, { exprand(100, 3000) })
		)
	) !2
}.play
)

//Deconstruction of Mix:
(
{ var freqDeviation;

	freqDeviation = LFNoise2.ar(0.05, 0.2, 1); //A very slow frequency deviation (over 20 seconds).

	Mix(
		BPF.ar(
			BrownNoise.ar,
			f = Array.geom(5, 440, 3/2) * freqDeviation,
			0.05/f, //The higher the frequency, the smaller the RQ value.
			[24, 30].dbamp
		)
	)
}.play
)

(
{ var freqDeviation, noise, amps, freqs;

	freqDeviation = LFNoise2.ar(0.05, 0.2, 1);

	noise = BrownNoise.ar;
	freqs = Array.geom(5, 440, 3/2) * freqDeviation; //Biggest array brings about number of instances.
	amps = [24, 30].dbamp; //Smaller arrays wrap.

	//Obtaining each value through the indexes of each array:
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
2/3
//Filter banks: stacks of filters at a specific intervalic distance (based on overtones rations or equal intervalic ratios):
(
{
	Mix(
		BPF.ar(
			PinkNoise.ar,
			Array.geom(16, 30, 3/2), //Pitagoric fifths (or natural fifths). Reciprocal of the ratio (2/3) = downward series (beware the starting frequency).
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
			Array.geom(16, 30, 7.midiratio), //Tempered fifths (equal temperament), using semitones.midiratio.
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

	//Concatenation of two arrays (all values put into a single array):
	freqs = Array.geom(8, 30, 2) //Octaves.
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
	Array.fill(10, { |i| ((i + 1 / 10) * 0.5).midiratio }); //Frequency deviation: from 0.05.midiratio (to the fundamental freq) up to 0.5.midiratio of deviation (to the last frequency), which is equal to a quarter tone (change the * 0.5 to * 0.1 or * 1 to change the level of deviation.

	amps = Array.geom (10, 1, 0.96); //Amplitude deviation.

	Mix(
		BPF.ar(
			PinkNoise.ar,
			freqs,
			0.001,
			amps
		)
	) !2
}.play
)

//Klank filter: a bank a fixed-frequency resonators:

//Arguments:
//specificationsArrayRef: see Help file "Multichannel expansion" --> "Protecting arrays against expansion" (avoids that the argument is interpreted as an array of arrays):
`[
	Array of freqs,
	Array of amps,
	Array of decay times
]
//input: usually an Impulse, Dust or any noise generator.
//freqscale: scale factor multiplied by all frequencies (as they are fixed, they can be "transposed" using this argument).

//Examples:
(
{
	Klank.ar(
		`[
			//Array.fill(8, { exprand(150, 14000) }), //Random freqs.
			Array.geom(8, 80, 3/2), //Stack of fifths.
			1,
			Array.fill(8, { exprand(0.02, 0.2) }) * 32 //Sort of "lag".
		],
		{ PinkNoise.ar(0.005) } !2 * 0.5,
	)
}.play
)

(
{
	Klank.ar(
		`[
			[178, 570, 7384, 605, 356, 1150, 14768, 1210],
			1,
			[0.002, 0.012, 0.018, 0.013]
		],
		{ Dust.ar(3, 0.1) } !2
	)
}.play
)

(
{
	Klank.ar(
		`[
			[178, 570, 7384, 605, 356, 1150, 14768, 1210],
			1,
			[0.002, 0.012, 0.018, 0.013] * 16 //Ading some greater decay.
		],
		{ Dust.ar(3, 0.1) } !2
	)
}.play
)


/////////////////////////////////////////////////////////////////////////////////

//ENVELOPES, TRIGGER AND GATE
//Envelopes allow us to control parameters over time.

//Basic syntax: we need two classes to create an envelope: EnvGen is the Unit Generator of envelopes, and Env allows us to specify the characteristics of the envelope created by EnvGen:
EnvGen.ar(Env(levels, times, curves), gate)

//Linear curve:
Env([0, 0.5, 0.1, 0.5, 0], 1, \linear).plot

(
{ var signal, env, envGen;

	env = Env([0, 0.5, 0.1, 0.5, 0], 1, \linear); //The time from one level to the next will always be 1 in here.
	envGen = EnvGen.ar(env);

	signal = SinOsc.ar;

	signal * envGen //In order to apply the envelope to the amplitude of a signal, we simply multiply the signal by the envelope.
}.play
)

//Exponential curve:
Env([0.001, 0.5, 0.1, 0.5, 0.001], [1, 4, 6, 2], \exponential).plot //An exponential curve cannot touch nor cross 0.

(
{ var signal, env, envGen;

	env = Env([0.001, 0.5, 0.1, 0.5, 0.001], 1, \exponential);
	envGen = EnvGen.ar(env);

	signal = SinOsc.ar;

	signal * envGen
}.play
)

//Step curve:
Env([0, 0.5, 0.1, 0.5, 0], 1, \step).plot //First level is "lost" as the first step is to directly jump to the second level.

(
{ var signal, env, envGen;

	env = Env([0, 0.5, 0.1, 0.5, 0], 1, \step);
	envGen = EnvGen.ar(env);

	signal = SinOsc.ar;

	signal * envGen
}.play
)

//Curve defined by floats:
Env([0, 0.5, 0.1, 0.5, 0], 1, 8).plot //0 = linear, 4 = sort of exponential, 8 = closer to step. Negative and positive values change the side from which the curve is "pulled".

(
{ var signal, env, envGen;

	env = Env([0, 0.5, 0.1, 0.5, 0], 1, [4, -4]); //Almost equivalent to \exponential, but we can touch or cross 0.
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

//Envelope of frequencies: we can apply envelopes to parameters other than the amplitude, such as the frequency:
(
{ var freq;

	freq = EnvGen.ar(Env([39, 61, 50] + 12, 2, \linear)).midicps; //Linear distribution among midi values, then conversion to Hz (if the conversion happens before, then an exponential distribution would be more convenient.

	SinOsc.ar(freq, 0, 0.2) //The envelope is placed in the frequency argument of the signal.
}.play
)

//Method .circle and randomness:
(
{ var freq;

	freq = EnvGen.ar(
		Env(Array.fill(5, { rrand (60, 104) }),
			Array.fill(4, { rrand(0.2, 1) }),
			\linear
		).circle //Not a real loop, as it jumps to the first value when the envelope is completed.
	).midicps;

	SinOsc.ar(freq, 0, 0.1)
}.play
)

//Last example: filter bank (envelope applied to the grow argument):
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

//Envelope methods: we can use different methods to create specific envelope shapes such as:
Env.triangle(1, 0.3).plot
{ SinOsc.ar * EnvGen.ar(Env.triangle(1, 0.3).circle) }.play

Env.sine(1, 0.3).plot
{ SinOsc.ar * EnvGen.ar(Env.sine(1, 0.3).circle) }.play

Env.perc(0.01, 0.25, 0.3, -4).plot //The curve of a percussive envelope cannot be exponential because it will always touch 0.
{ SinOsc.ar * EnvGen.ar(Env.perc(0.01, 0.5, 0.3, -4).circle) }.play


//TRIGGER
//The second argument of EnvGen is "gate". Gate is 1 by default as, as far as it is 1, it will trigger the envelope and hold it open. Though in order to use the argument gate as a real gate we need a different kind of envelope featuring a sustain section, gate can be used as a trigger for those envelopes without sustain in order to "reboot" the envelope at certain moments:
(
{ var trigger, signal, env;

	trigger = Impulse.ar(1); //Impulse will trigger the envelope 1 time per second (try with freq of 2 and with Dust).
	signal = SinOsc.ar;
	env = EnvGen.ar(Env.perc(0.01, 0.5, 0.3), trigger); //If the release of .perc is longer than the frequency of the impulse, we will never hear silence between the envelopes (try with release = 2).

	signal * env
}.play
)

//Randomness: every time it is triggered, the envelope will feature a different random value (of time, in this case):
(
{ var freq, trigger, time, signal;

	trigger = Impulse.ar(1/4); //It does not matter if the envelope is completed: every four seconds, it is rebooted (if longer than 4 seconds, it is cut, and if shorter than 4 seconds, last value is sustained until next trigger).
	time = [rrand(0.5, 3)]; //Random time chosen between 0.5 and 3 seconds. If the random choice was made directly into the expanded envelope, each envelope will feature a different time value.

	//Array of five envelopes (each envelope features five random levels used as frequencies in the SinOsc), bringing about five sine oscillators.
	freq = Array.fill(5, {
		EnvGen.ar(Env(Array.fill(5, { exprand(60, 78).midicps }), time, \step), trigger)
	});

	signal = Mix.ar(
		SinOsc.ar(
			freq,
			0,
			0.1
		)
	) !2;

	signal * 0.1

}.play
)


//GATE
//In order to use the argument gate as a real gate, we need an envelope with sustain time (which will be sustained as far as gate = 1).

//Basic syntax of method .adsr:
Env.adsr(attackTime, decayTime, sustainLevel, releaseTime, peakLevel, curve)

//Graphical representation (takes some time to render):
{ EnvGen.ar(Env.adsr, LFPulse.ar(1)) }.plot(1)
{ EnvGen.ar(Env.asr, LFPulse.ar(1)) }.plot(1)

//Applying gate:
(
a = { |gate = 1| //Default value.
	var env;

	env = EnvGen.ar(Env.adsr(0.1, 0.2, 0.5, 1, 0.2, -4), gate);

	SinOsc.ar !2 * env
}.scope
)

//We can use the method .set to change the arguments of a signal running in the server:
a.set(\gate, 0) //Gate = 0 triggers the release of the envelope.
a.set(\gate, 1) //Gate = 1 triggers a new attack of the envelope.
//Meanwhile, the envelope continues running in the server even when there is no sound (see node tree).

//DoneAction = 2: see Help file of "EnvGen" --> In the information about the argument "doneAction", open the documentation about "Done": at the end of the document, there is a list of actions that can be implemented with doneAction: doneAction = 0 means "do nothing when the UGen is finished", doneAction = 2 means "free the enclosing synth" (so that the synth stops running in the server).
(
a = { |gate = 1|
	var env;

	env = EnvGen.ar(Env.adsr(0.1, 0.2, 0.5, 1, 0.6, -4), gate, doneAction: 2); //Usually applied using keyword assignment as it is the last argument.

	SinOsc.ar !2 * env * 0.5
}.scope
)

a.set(\gate, 0) //When sending 0 to the gate, the envelope is finished and doneAction 2 frees the synth in the server (check the node tree).s
a.set(\gate, 1) //Sending 1 to the gate again is no longer possible because the synth does not exist anymore.

//Using LFPulse to open / close the gate periodically:
(
{ var gate, signal, env;

	gate = LFPulse.ar(0.5, 0, 0.5); //LFPulse used as a switch to open and close the gate periodically every two seconds (the argument width allows us to shorten or lengthen the sustain within these two seconds (width = 0.5 means one second of attack, decay and sustain, and one second for release and possible silence).

	signal = SinOsc.ar;

	env = EnvGen.ar(Env.adsr(0.01, 0.1, 0.3, 1, 0.3), gate);

	signal !2 * env
}.play
)

//Extra: Line and XLine (similar result in these two examples):
{ SinOsc.ar(Line.ar(60, 84, 2).midicps, 0, 0.1 !2) }.play //Line generator (if applied to frequency, works better with midi values, and converting afterwards).
{ SinOsc.ar(XLine.ar(260, 1046, 2), 0, 0.1 !2) }.play //Exponential line generator (if applied to frequency, works better with Hz).


/////////////////////////////////////////////////////////////////////////////////

//MODULATIONS (Ring, AM, FM) AND DECAY LINES
//When modulating a signal at over 20 Hz of frequency, a new frequency spectrum will be created out of this periodicity:

//Ring modulation: it is a kind of amplitude modulation in which the fundamental frequency disappears. The modulation is performed by multiplying both signals or placing the modulating signal in the amplitude argument of the carrier signal:
{ SinOsc.ar(440) !2 * SinOsc.ar(220) * 0.1}.play //We don't hear 440 nor 220, but the subtraction and addition of both (440 + 220 and 440 - 220).

//Amplitude modulation (AM): whereas the "depth" of the ring modulation was -1 to 1 (regarding the mul/add arguments of the modulating signal), the depth of the AM should be 0 to 1 in order to keep the fundamental frequency:
{ SinOsc.ar(440) !2 * SinOsc.ar(220, 0, 0.5, 0.5) * 0.1 }.play //We hear (car + mod) + (car - mod) + car, as the mul/add arguments of the modulating signal are adjusted to the range 0-1.

//Other examples:
{ BrownNoise.ar(0.1 !2) * SinOsc.ar(5000) }.play //Try out 100, 50, 20, 10 for the SinOsc frequency to see what is happening.
{ BrownNoise.ar(0.1) * SinOsc.ar(LFDNoise3.ar(1, 975, 1025)) }.play //Random value from 50 to 2000 (try with LFDNoise0?).
{ Saw.ar(200) * LFDNoise3.ar(50 !2, 0.1) }.play
{ Saw.ar(2000) * LFDNoise3.ar(200 !2, 0.1) }.play //A different combination of frequencies featured in the former line.

//Ring modulation applied to an audio sample (ugly default SC audio sample):
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav") //Loading an audio file into a buffer (this will be studied later on during the course).

//Applying ring modulation using a sine oscillator, and controlling the frequency using the horizontal movement of the mouse:
{ PlayBuf.ar(b.numChannels, b.bufnum, loop: 1) * SinOsc.ar(MouseX.kr(20, 14000, \exponential).poll) !2 * 0.2 }.play

//Same example, creating our own mix at the end:
(
{ var signal, mod;

	signal = PlayBuf.ar(b.numChannels, b.bufnum, loop: 1);

	mod = SinOsc.ar(MouseX.kr(20, 14000, \exponential).poll) !2;
	(signal + (signal * mod * 0.5) * 0.2) //car + (car * mod * 0.5) * masterVolume.

}.play
)

//Ring modulation methods: these methods represent operations between two signals:
ring1: //(a * b) + a
ring2: //(a * b) + a + b
ring3: //a * a * b
ring4: //(a * a * b) - (a * b * b)

//Examples:
{ SinOsc.ar(440) ring1: SinOsc.ar(220) !2 * 0.1 }.play //Equivalent to our first example of AM.

{ SinOsc.ar(440) ring2: SinOsc.ar(220) !2 * 0.1 }.play

{ BrownNoise.ar(0.5) ring3: SinOsc.ar(LFDNoise3.ar(1, 1500, 2000), 0, 0.3 !2) }.play

{ BrownNoise.ar(0.5) ring4: SinOsc.ar(LFDNoise3.ar(1, 1500, 2000), 0, 0.3 !2) }.play

{ SinOsc.ar(7000, 0, 0.2) ring4: SinOsc.ar(LFDNoise3.ar(3, 125, 7000), 0, 0.3 !2) }.play

//Frequency modulation (FM): consists of adding a signal to the frequency of another signal.
//More info in these two tutorials:
//https://www.youtube.com/watch?v=UoXMUQIqFk4&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=22
//https://www.youtube.com/watch?v=dLMSR2Kjq6Y&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=23

{ SinOsc.ar(500 + SinOsc.ar(1)) * 0.1 !2 }.scope //No perceptible difference, but slight movement from left to right in the graph, meaning that the carrier signal is oscillating (in fact from 499 to 500 Hz every second).
{ SinOsc.ar(500 + SinOsc.ar(1, 0, 20)) * 0.1 !2 }.scope //Oscillation between 480 and 520 Hz every second (mul of modulating signal = range of freq modulation above and below the carrier's frequency).
{ SinOsc.ar(500 + SinOsc.ar(8, 0, 400)) * 0.1 !2 }.scope //Oscillation 8 times per second, between 100 and 900 Hz.
{ SinOsc.ar(500 + SinOsc.ar(22, 0, 400)) * 0.1 !2 }.scope //Crossing the 20 Hz limit = new frequency spectrum.
{ SinOsc.ar(500 + SinOsc.ar(80, 0, 400)) * 0.1 !2 }.scope //Fully new spectrum.

//Example from first linked tutorial (to show a bunch of possible combinations of values): with MouseY, we change the carrier's freq (200-5000 Hz); with MouseX, we change the modulating's freq (1-2000 Hz); lastly, the modulating's mul, which is the range of frequency modulation, is controlled by a LFNoise0, which produces 8 random values per second.
{ SinOsc.ar(MouseY.kr(500, 5000, 1).poll + SinOsc.ar(MouseX.kr(1, 2000, 1).poll, mul: LFNoise0.kr(8).range(400, 4500))) * 0.1 !2 }.scope //Because of its ranges, this code could produce negative frequencies: negative frequencies mean we're asking an oscillator to produce its periodic shape in reverse. This is not a problem in here but I don't know if some other UGens may respong in unexpected ways to negative frequency values, so... maybe avoid them.

//Decay lines:
//A decay line generates an exponential envelope with a certain duration triggered by impulses. Applied to certain sounds, it allows us to enhance the attack of those sounds:
{ BrownNoise.ar !2 * Decay.ar(Impulse.ar(0.5), 1, 0.2) }.play //Applied as an amplitude envelope for the BrownNoise.

//Last example: enhancing attacks:
(
{ var impulse;

	//The impulse acts as input of the filter and as trigger of the decay:
	impulse = Impulse.ar(0.5);

	//Three Ringz filters are created with a different frequency and decay time each, and mixed into a single channel:
	{ Mix(
		Ringz.ar(
			impulse,
			[52, 7000, 14550],
			[3, 0.3, 2],
			0.4
		)
	)

	ring1: //ring: multiplied both signals and adds the filter to the mix.

	//Thanks to the common trigger, the WhiteNoise with the Decay envelope is applied to the attack of each filtered Impulse.
	WhiteNoise.ar(Decay.ar(impulse, 0.04))
	} !2 * 0.2

}.scope
)
