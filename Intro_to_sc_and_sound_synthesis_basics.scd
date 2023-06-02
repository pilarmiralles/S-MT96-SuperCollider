//Introduction to SuperCollider and sound synthesis basics
/////////////////////////////////////////////////////////////////////

//Download the SuperCollider application here: https://supercollider.github.io/downloads.html
//SuperCollider plugins (extensions for the SC audio server) and how to install: https://supercollider.github.io/sc3-plugins/
//SuperCollider quarks (packages of classes, extension methods and server UGen plugins) and how to install: https://github.com/supercollider-quarks/quarks

/*
Some usefult links:
https://doc.sccode.org/Tutorials/Getting-Started/00-Getting-Started-With-SC.html (wondrous introduction)
https://doc.sccode.org/Help.html (online SC guide)
https://supercollider.github.io/tutorials/
https://doc.sccode.org/Help.html
https://scsynth.org/ (new community forum)
https://github.com/madskjeldgaard/awesome-supercollider
http://sccode.org/
https://github.com/supercollider/supercollider/wiki/Code-style-guidelines (these four about code style):
https://blog.alexdevero.com/6-simple-tips-writing-clean-code/
https://medium.com/coding-skills/clean-code-101-meaningful-names-and-functions-bf450456d90c
https://scsynth.org/t/some-notes-on-writing-supercollider-code-for-non-programmers/1940
*/

//SC is an open source: anyone can contribute with the creation of new tools, extensions, etc., and with the enhancement of the existing ones, and there is an active and helpful community of users and contributors (https://supercollider.github.io/#community).
//SC is free to use, light in the computer, easy to get some sound out of it.
//Overwhelming amount of tools and resources, and different ways of doing the same thing (shortcuts, alternative syntax, etc.): stick to the basics, keep consistency, and, after adquiring a solid ground, experiment, seek your own way to attain your objectives.
//Learning curve can be quite exponential (slow at the beginning, faster later on). The order in which things are learnt can be really different from a course to another, from a series of tutorials to another, and this affects how things are understood in different ways and in different moments throughout the journey, as many things are intertwined and intermingled.

//OOP
//SC is an OOP (object-oriented programming language), a programming paradigm based on the concept of "object" (a thing that does something or represents something). Two main kinds of objects in SC are classes and methods. Methods are instructions and classes hold information about how to respond to those instructions. Classes are organized within a hierarchy defining their properties. In the class tree, we can see that all classes come from the main branch called "Object". Objects created by classes are called instances (so, all classes are instances of the root class Object) More information here: https://doc.sccode.org/Guides/WritingClasses.html. A number or a string are also classes, but they can be expressed as literals (String --> "" in literal notation): see literals below.
//Class tree: https://doc.sccode.org/Overviews/ClassTree.html
CombC //Open the Help file (ctrl + D) and observe how, for instance, CombC comes from CombN --> PureUGen --> UGen --> AbstractFunction --> Object (Some info about "inheritance" in the last paragraph of this tutorial: https://doc.sccode.org/Tutorials/Getting-Started/12-Groups.html).

/*
Architecture of SC: https://doc.sccode.org/Guides/ClientVsServer.html
SC application is based on two autonomous components (two different programs): the server and the client; and an IDE:
- The IDE (Integrated Development Environment): is the environment we see here, the text editor, the menu bar, the postwindow, the status bar, etc. https://doc.sccode.org/Guides/SCIde.html
- The language: features a specific syntax, that is to say, a set of rules and symbols to express something in that language.
- The interpreter: if the language is the letter, the interpreter is the mailman. The language and interpreter form the client (sclang). The interpreter translates the language into OSC (Open Sound Control) messages for the server.
- The audio server (scsynth): receives OSC messages from a client and carries out the sound synthesis. The server is booted by pressing ctrl + b or executing the line s.boot. SuperNova is an alternative audio server which allows to parallelize the synthesis and spread the load of the sound work over several cores (computers). More here: https://madskjeldgaard.dk/posts/supernova-intro/
Because of client and server are two different and independent programs, the audio server can receive OSC messages from a client different than sclang (the so-called external applications in the third diagram of the link). Nevertheless, sclang is dessigned to provide with the expressive power of SC language.
*/

//Additional recommendations:
/*
- The Help window on the right side can be "detached" by choosing that option in the little square on the left on the window. I like detaching the Help window to have the full-size post-window on the right. The Help window can be called from anywhere in the code by pressing ctrl + d (over the part of the code to inspect).
- The "implementations" (source code) can be accessed by pressing ctrl + i (over the part of the code to inspect). For a better understance of source codes: https://doc.sccode.org/Guides/WritingClasses.html
- Sometimes, when a block of code gets messy, the option "Autoindent line or region" in the "Edti" menu can be helpful.
- The semicolon ";" is used to separate each instruction to be interpreted by SC. This might be the reason for the majority of the syntax error at the beginning.
- Comments are written using "//" for single lines and "/*...*/ for blocks of code (such as the one these recommendations are being written into).
- It is possible to record the output of the audio server at any moment: click the status bar bellow and select "Start recording". The recording can be concluded by pressing "Pause recording" or ctrl + period.  The recordings will be saved in AIFF format by default, in a folder called "Recordings" somewhere in the SuperCollider folder in your computer.
*/

//########################################################
//The startup file ("File" menu --> "Open startup file": https://doc.sccode.org/Reference/StartupFile.html (about).
//When SC is run, the first thing the application does is to compile the "class library", where all classes and possible extentions are located. Then SC's interpreter looks for a file called "startup" and executes all code within it. The file is, at first, empty, but writing code within it allows us to make user specific customizations of the SC application, such as changing the number of default input and output channels, use specific soundcards by default, increase the block size, sampling rate or number of buffers by default, etc.

//Some examples of startup options (all options here: https://doc.sccode.org/Classes/ServerOpts.options.memSize = 2 ** 16; //Number of kilobytes of real time memory allocated to the server (for synths and UGens such as delays, which do not use buffers). Default is 2 ** 13 (8192).
s.options.numWireBufs = 256; //Number of buffers allocated to interconnect UGens (default is 64).
s.options.numBuffers = 1024 * 10; //Number of global sample buffers available (default is 1024).


Server.local.latency = 0.05; //Setting a new latency value (default is 0.2). Setting a lower value can lead to errors such as multiple "late" messages in the postwindow.
Server.local.sampleRate_(48000); //Default sample rate is 44100. It could be raised to even 192000.
Server.local.blockSize_(64); //Block size (number of samples in one control period). This is the default value. When blockSize = 1, then control rate is equal to audio rate.

Server.local.numPrivateAudioBusChannels_(1040); //Increasing the number of private audio bus channels (default is channels 4 to 127). Only needed if the following two options are greatly enlarged:
Server.local.numInputBusChannels_(32); //Numer of hardware input channels. Default is 2.
Server.local.numOutputBusChannels_(64); //Number of hardware output channels. Default is 2.
//For both of those, when executing s.meter, it sould show the level of the indicated number of input and output channels.


s.recSampleFormat = "int24"; //Sets the bit depth (number of possible amplitude values, or definition on the "y" axis) of the audio recording to 24-bit, which is compatible with flac format (lossless compression).
s.recHeaderFormat_("wav"); //Set the recording audio format to .wav (also possible "flac", for instance). _("wav") is equal to = "wav", just different syntax.

Safety(s).enable; //An extension for limiting and clipping, protecting against dangeous signals. Could be useful at the beginning and when performing wild experiments. Though limiters can colour the sound synthesis.

Server.local.zeroConf_(false); //True by default. Setting it to false might help with delays upon server boot.
Server.local.maxNodes_(5120); //Maximum number of nodes. Default is 1024.

Server.local.options.device_("MADIface USB (24012536)") //Connecting to an output device other than the default (example: MADIface of Erkki studio).

//########################################################

//DATA TYPES
//Data types are different ways of representing and interpreting data (information). They are usually represented as Literals: Literals are objects whose value is represented directly in the code (rather than created out of sending a message to an object): https://doc.sccode.org/Reference/Literals.html

//Numbers: can be integers or floating-point numbers (floats):
//Limits of integer numbers: 32 bits (2 ** 31 - 1):
2147483647 + 1 //Crossing upper limit (folds into negative range).
-2147483648 - 2 //Crossing the lower limit (folds into the positive range). The representation of certain numbers around the limits depends on each computer.

//Limits of float representation: 64 bits (2 ** 63 - 1), execpt for FloatArray, in which floats are 32-bit:
(-1, -0.8..1) //0.0 does not exist in this list of numbers, but some number extremely close to it (the difference between that number and zero is not significant for our perception).
(0, 0.2..1) //0.0 does appear in this list, nevertheless.

//Another example:
(0.1 !10).sum == 1.0 //"False".
(0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1) //But equal to 1.0 in fact.

//Additional discussion on floats representation: https://www.sounddevices.com/32-bit-float-files-explained/

//Other floats:
1.2e4 //Exponential notation (scientific notation: for very big and very small numbers).
1.2e-4
pi //pi constant.
0.5pi
inf //Keyword for "infinity".
-inf //There is also negative infinity.

//Radix notation: different base (base 10 numbers range 0-10, while, for instance, binary -base 2- numbers range 0-1 only).
16rF //Base 16, 1-9 and then letters (hexagesimal).
2r000100 //Base 2 (binary).
//Those are printed in the postwindow as base 10 numbers.

//Musical notation: accidentals (expressed as floats, though this might not be as useful as using actual numbers):
2s //Sharp (scale degree 2, for instance).
2b //Flat.
2ss //Double sharp.
2bb //Double flat.

//Strings: strings are sequences of characters between double quotes:
"string"
"string".scramble //We can apply methods to strings, such as scramble or size.
"string".size
//The dollar sign before a character is used for single characters (go to the Literals help file for more examples):
$a //Letter "a".
$\n //New line:
(
$\n;
"Hi".postln;
$\n
)

//Symbols: a symbol is also a sequence of characters. However, unlike strings, two symbols with exactly the same characters will be the exact same object. Symbols are best used as constant values and Dictionary keys (see: https://doc.sccode.org/Classes/Dictionary.html):
\symbol
'symbol'

//Equality and Identity in SuperCollider (symbols VS strings):
//Symbols containing the same characters represent the same object:
\abc == \abc //True (== means equality in SC)
\abc === \abc //True (=== means identity in SC)

//Strings containing the same characters do not represent the same object:
"abc" == "abc" //True
"abc" === "abc" //False

//Notice that a single "=" in SC is only used to assign data to variables and arguments.

//Other special values:
true
false
nil //(empty)

//Identifiers: they can be variables or methods. They always start by lower-case letters and can only contain alphanumeric characters and the underscore:
//Examples of variables: variables are data containers (more on variables later on in this document):
var hello, filter_func //Declared.
a //Global.
~variable_a //Global, with descriptive name.

//Examples of methods: methods send messages to objects called "receivers". There are two kinds of methods: class methods are sent to classes to create objects (instances); instance methods are applied to what a class has created (an instance of the class) to somehow modify it:
.play, .midicps, .round

//Classes: classes create and modify objects when receiving messages sent by methods and defined by their arguments (parameters that can be modified by specifying their value):
Server
SinOsc
HPF
//All classes are contained as .sc files in the SC Class Library folder in your computer. Each class' sc file contains all the information about how a class responds to each message and the input parameters (arguments) of each message when sent to that specific class.


//MATHEMATICAL OPERATIONS
//Unary operations are applied to single numbers (normally, using methods); binary operations are performed between two or more numbers (can be also applied through methods).s
//Here is a list of common unary and binary operators in SC: https://doc.sccode.org/Overviews/Operators.html.

//Basic calculations:
1 + 1 //Addition
1 - 1 //Subtraction
1 * 2 //Multiplication
5 / 2 //Division
4 / 0 // = inf (it is not a number, but the cumputer needs to express it somehow. Even a nan - not a number - is a number in the computer).
5.div(2) //Division, but returning only integers (rounding down)
2 ** 7 //Power
2.pow(7) //Power (applied as method)
9.sqrt //Squared root (3*3 = 9)
27.cbrt //Cubic root (3*3*3 = 27)
7.pow(1/12) //Calculating the "x" root of a number using its power equivalent ("m" root of "a" to the "n" = "a" to the "m / n"). Example = 12th root of 7
2 ** (1/12) //Frequency ratio for an equal temperament semitone (to be multiplied by the departure frequency).
2 ** (7/12) //Idem (of a fifth).
7.midiratio //Equivalent in method form.
21.mod(12) //Module
21 % 12 //Also module
(0..24) % 7 //Demonstration of how module works (keeping 24 values within 0 - 6)

1+-2 //Spaces matter here as we cannot know if the (-) is a subtraction operation or a minus sign for the 2. Then 1 + -2 is understandable.

//Operations hierarchy:
//In SC, all operations are calculated from left to right no matter the kind of operations involved:
2 + 3 * 3 //15
2 + (3 * 3) //11 (prioritizing the product by using parenthesis).

//Other calculations:
13.nextPowerOfTwo; //Next power of 2 from that number onwards.
44.nextPrime; //Next prime number from that number onwards.
4.nthPrime; //The fourth prime number in the series of prime numbers.
34.61946.round(0.01) //Rounding to two decimals (rounding up from 5, down from 4). The argument defines the number of decimals.
72.round(30) //Keeps number within the multiples of the .round argument value (useful for overtones).
69.midicps //Midi to Hz (cycles per second) converter.
440.cpsmidi //Hz to midi converter.
1.57.asInteger //Turns a float into an integer by rounding down (also shortcut .asInt).

//Randomness with numbers (examples of methods):
10.rand //From 0 to 9.
333.rand + 100 //From 100 to 432.
5.xrand //Excludes 0 (from 1 to 5).
5.xrand(1) //Excludes 1.
5.xrand2 //Includes negative values (no 0 by default).
10.rand2 //Includes negative values (including 0).
rrand(0.1, 4) //Random numbers within a range with uniform distribution (both integers = integers only; at least one of them float = all float results) --> Polymorphism: "the ability for different kinds of objects to respond differently to the same message" (different kinds ob object: int / float | same message: rrand): https://doc.sccode.org/Guides/Polymorphism.html
exprand(1, 4)//Random numbers within a range with exponential distribution (results will always be float regardless of type of input). The lo/hi limit cannot be zero and the range cannot cross zero.


//TYPES OF BRACKETS
//Round brackets or parenthesis: they are used for sending arguments to their method and grouping blocks code broken into different lines:
SinOsc.ar(440) //This signal does not sound yet because the sound function hasn't been created.

( //This entire block of code can be selected at once by double-clicking on the first or last parenthesis:
var string;

string = "hello";

"hello".scramble
)

//Square brackets: they are used for collections (arrays, lists, sets, etc.):
[1, 2, 3, 4, 5]

//Curly brackets: they are used for functions:
{ SinOsc.ar(440, 0, 0.1) }.play; //Now we obtain sound thanks to the function.play.

//Avoid spaces between before or after [] or (), but allow spaces after { and before } (as recommended in the code style guidelines: https://github.com/supercollider/supercollider/wiki/Code-style-guidelines).

/////////////////////////////////////////////////////////////////////////////////

//VARIABLES
//Variables are data containers. They represent the data that is assigned to them.

//Non-declared (global): variables a-z are non-declared variables or global variables, which can be used wherever in the code (excluding "s", which contains the audio server):
a = 1 //1 is assigned to "a", thus "a" represents a 1.
a //"a" returns a 1.
a + 1 //2

this.dump //Prints the "instance of the interpreter": "this" is the keyword normally used for the current instance of something (in instance methods, it refers to the instance itself, in class methods, it refers to the class itself, and here -out of context- it refers to the current instance of the interpreter); the method .dump "prints a detailed low level representation of the receiver to the post window". What is important from this is that the current instance of the interpreter includes all global variables and the values currently assigned to them.

//Declared variables: they can only be called within the portion of code within which they are declared:
(
var value1, value2, power;

value1 = 2; //If we try to evaluate this single line, SC will tell us that the variable "value1" is not defined.
value2 = 16;
power = value1 ** value2
)

//Non-declared variables with descriptive name. These variables are freed when recompiling the class library (in the menu "language"):
~value1 = 1 //In my keyboard: alt gr + 4 + space, to write ~.
//Those variables can be used anywhere in the code just like a global variable (they are understood within the default environment as far as it is not "recompiled"). It is possible to create different environments as pairs of keys and definitions (key -> value associations), and those can be stored in the start-up file. See the help file of Environment (a dictionary which can serve as a "name space" for functions).

Post << currentEnvironment; //This line prints the current content of the environment were all global variables defined using ~. After executing the previous variable assignemnt "~value1 = 1", the association "value1 -> 1" will be shown in the postwindow by executing this line. If there are other key -> value associations set by default, they will be also shown by executing this line (but by default, the default environment is empty).


//FUNCTIONS
//A Function is an expression which defines operations to be performed when it is sent the .value message and a list of arguments in the order they were declared within the function (arguments are the values we can pass to the function as "inputs"). Functions are written between curly brackets.

//Useless example (no arguments = fixed result):
a = { 1 + 1 }
a.value

//Less useless example: all instructions are interpreted in one shot, one after another in order, and only the last line's result is printed in the postwindow:
(
f = { |value1 = 1, value2 = 5, deviation = 0.9| //List of argument and their default values (to be replaced by those sent from .value).
	//arg value1 = 1, value2 = 5, deviation = 0.9; //Arguments can also be defined in this other way (outdated syntax, but widely used still).
	var result;

	result = value1 + value2;
	result.postln; //We can return the previous line only if applying printing methods, like .postln, which prints and introduces a new line afterwards.
	result = result * deviation //The semicolon is often avoided in the last line of a function, as this is indicating that this line is the last instruction.
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

//Silly example of how classes and methods work together (this example may be better understood by reading from this link: https://doc.sccode.org/Guides/WritingClasses.html, already mentioned twice, but worthwhile):
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

//Real example in SC: a sine wave receives the method .ar, which asks it to create an audio rate signal (class method), with a list of arguments defining the frequency, phase, and amplitude of that signal; then, the signal is placed into a function to which the method .play is applied in order to play the signal (instance method). When playing the signal, we can see in the postwindow that a synth (an instance of a synth definition), a signal that actually runs in the audio server, has been created:
s.boot //Remember to boot the server in order to perform any sound synthesis.
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

SinOsc //Press ctrl + i (and double click on SinOsc in the list): source code of SinOsc (resembling our imaginary example).

//Applying out imaginary methods to our imaginary classes:

Sandwich.prepare(['tomato'], 'baguette', 'tofu')
Sandwich.prepare(meat: 'tofu') //Keyword assignment: any argument in any order can be sent using the keyword assignment (name of the arg: value), so that, for instance, we don't have to define the previos arguments because we are happy with their default value.

//Now adding the other class:
a = Sandwich.prepare(
	['pepper'],
	'baguette',

	Ham.marinate.fry(260) //First argument of the method .fry is temp (for instance) --> Help file should indicate what is the unit of temp (just like in SinOsc.ar it is indicated that the unit of frequency is the Hz).
)

//Applying instance methods:
a = a.hitUp
a = a.cut(4) //Arg of .cut is number of pieces.

//Coming back to polymorphism (https://doc.sccode.org/Guides/Polymorphism.html), this is a very importants feature of SC because, for instance, different classes can receive the same message and will respond differently to it ("a message generally has some underlying meaning and it is the responsibility of each class to respond in a way appropriate to that meaning"). For example, the method .ar is used to create audio rate signals: when applied to SinOsc, it will create a sine wave oscillator at audio rate, and when applied to LFTri, it will create a triangle wave oscillator at audio rate.

//Three ways of applying methods (it is important to be coherent with the syntax, but also to know several options as it will be helpful when analyzing code that hasn't been written by us):
2.pow(3)
2 pow: 3
pow(2, 3)

//COLLECTIONS: ARRAY
//A collection is an object containing a group of objects: the elements (or items) of the collection. There are many types of collections, but Array is the most common one and therefore it is not necessary to write the name of the class Array. A collection between square brackets is by default an Array (other collection classes such as Set or List need to be specified before the brackets). The elements of an array are separated by commas and they are assigned an integer called "index" which represent the position or order of the element within the array.

//Homogeneous array of integers:
[1, 2, 3, 4, 5]

//Heterogemeous array (symbol, integer, string and sine oscillator function):
[\symbol, 67, "string", { SinOsc.ar(mul: 0.1) }]

//An array assigned to a global variable:
a = [1, 2, 3, 4, "hello", { SinOsc.ar(mul: 0.1) }]

//We can access to each element using their index (the first element is always represented by index 0):
a[0] //= 1
a[4] //= "hello"
a[5].play //Applying the method .play to the function in index 5.
a.at(0) //Method .at: equivalent to a[0].

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
//Key "m" in the keyboard changes the type of graph between the available options.

//Array.geom: creates a geometric series within an array: arguments are the size, the starting value and the "grow" (a product by which each element of the series is multiplied):
Array.geom(5, 220, 2) //Series of five octaves from 220 Hz, if applied to sound.

//Visualizing arrays:
y = Array.geom(10, 1, 2)
y.plot(discrete: true)
y.plot //Continuous by default.

//Other class methods (see the complete list at https://doc.sccode.org/Classes/Array.html):
Array.interpolation(5, 3.2, 20.5) //Size, start, end: covers the given range in the indicated number of steps (interpolated values between start and end).
Array.rand(8, 1, 100) //Size, minVal, maxVal: creates an array with a number (size) of random values (uniform distribution) between the minVal and maxVal.
Array.rand2(8, 100) //Size, val: random values from -val to val.
Array.linrand(8, 1, 100) //Size, minVal, maxVal: linear distribution.
Array.exprand(8, 1, 100) //Size, minVal, maxVal: exponential distribution.
Array.fib(5) //Array of fibonacci series: size, a, b, where "b" is the starting value and "a" is the starting step value so that the second value will be a + b.

//INSTANCE METHODS for arrays (examples):
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
a.put(1, 2000) //Another option for the method .put (arguments are the index and the new element).
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
//Unit Generators or UGens are classes that create or process signals. There are many classes of unit generators, all of which derive from the class UGen. A Unit generator is created y sending the message .ar (for audio rate signals) or .kr (control rate signals). The input parameters of a UGen (arguments) are given in the documentation of that class (help file).
//https://doc.sccode.org/Guides/UGens-and-Synths.html (basic concepts UGen, Synth).
//https://doc.sccode.org/Guides/Tour_of_UGens.html (guide of most common UGens, useful to find resources).
UGen

//First UGen: SinOsc, sine wave oscillator (simplest oscillatory pattern, equivalent to a spring or a pendulum):
SinOsc

//Visualization of a sine wave at 440 (one cycle: try out different numbers of cycles). For now, this is a mono signal:
{ SinOsc.ar(440) }.plot(1/440) //The period is the time occupied by a cycle of a periodic wave.

//.ar and .kr: audio rate signals run by default at 44100 samples per second (sampling rate), whereas control rate signals generate one sample value for every 64 values made by an audio rate signals (they use fewer computational resources than audio rate):
{[SinOsc.ar(1000), SinOsc.kr(1000)]}.plot(0.01) //The .kr signal suffers from "downsampling".

//Arguments of .ar method, that is to say, the parameters of the instance created by sending that method that we can modify: frequency, phase, mul, add:
SinOsc.ar(67.midicps, 0, 0.2, 0) //Freq is 440 Hz by default. It is calculated in Hz, so in case of using, for instance, a MIDI value, we need to convert it using the method .midicps. The second argument is the phase, which is measured in radians (0 = center, 0.5pi = 90º = top, 1pi = 180º = center, half period, 1.5pi = 270º = bottom, 2pi = 360º = back to center, and everything in between). The phase is normally only significant when using the signal as an LFO. The third and fourth arguments are the mul (1 by default), a value multiplied by the amplitude of the signal, which affects how narrow or wide is the soundwave in the "y" axis; and the add (0 by default), a value that is added to the output, affects the position of the soundwave in the "y" axis. Normally, when using the signal to produce sound, the mul value should be somewher between 0 and 1 (although 1 is, in normal conditions, the limit of the saturation), and the add value will be 0 (as no DC offset, related to the mean amplitude value, is desirable).

//Using keyword assignment: any arguments in any order:
SinOsc.ar(mul: 0.1, freq: 330)

//Comparison: change of mul and change of add:
(
{
	[
		SinOsc.ar(440, 0, 1), //Different mul: the function is narrower/wider.
		SinOsc.ar(440,0, 4),
	]
}.plot(1/440, minval: -5, maxval: 5) //Displaying one cycle of the sine wave within amplitude values -5 to 5.
)

(
{
	[
		SinOsc.ar(440, 0, 1, 0), //Same mul different add: the function moves upward (DC offset).
		SinOsc.ar(440, 0, 1, 2)
	]
}.plot(1/440, minval: -3, maxval: 3) //Displaying one cycle of the sine wave within amplitude values -3 to 3.
)


//Calculating the phase in degrees rather than radians:
2pi.magnitude.raddeg //0 to 6.28 with magnitude (0-2pi) which is the value itself (2 * 3.14...), then converting it to degrees (360 degrees).
360.degrad //And vice-versa, degrees to floats (we won't obtain "2pi", but the magnitude float is equivalent).

//Function.play: in order to produce sound, we need to apply the method .play to a function containing our UGen ({}.play creates a synthesizer, as the help file explains: the method .play, when applied to a function, "plays a Synth from UGens returned by the function. The function arguments become controls that can be set afterwards"). See information about the arguments of .play in the Funcion help file --> .play:
{ SinOsc.ar(67.midicps, 0, 0.2, 0) }.play

//Low frequency modulation (below 20 Hz): a modulation is the periodic or aperiodic modification of a parameter of a signal, the carrier signal (normally, by using another signal, the modulating signal):
(
{ var modulating, carrier;

	modulating = SinOsc.ar(1, 0, 500, 1500); //If the center (add) is 1500, the range of the modulation will be 1000 to 2000 (1500 - 500 and 1500 + 500). The modulation between this range is produced 1 time per second (for a 2-second long modulation, the frequency should be 1/2, which means 1 cycle in 2 seconds).
	modulating = modulating.round(125); //Splitting the range of modulation into "steps" of 125 using .round (when this method's argument is above 1, it rounds to the multiples of this number). This will produce 8 steps (peak-to-peak amplitude = 1000, 1000/125 when being round = 8).

	carrier = SinOsc.ar(modulating, 0, 0.2, 0) //The modulating signal is applied to the frequency of the carrier, thus its values are frequency in Hz (one octave of range).

}.play
)
//The duration of each step is not equal because of the curve of the sine wave that is the modulating signal. If we used a triangle wave, the wave shape would be completely linear and each step would feature the same duration. In addition to this, steps of equal number of Hz mean that in higher frequencies there is a smaller freq difference between steps and in lower frequencies there is a larger difference (as frequency in Hz behaves exponentially: for instance, each octave is calculating by multiplying the current frequency by 2).

//Stereo signal two ways: these are a couple of quick solutions for now in order to get a stereo signal:
(
{ var modulating, carrier;

	modulating = SinOsc.ar(1, 0, 500, 1500);
	modulating = modulating.round(125);

	carrier = SinOsc.ar(modulating, 0, 0.2 !2, 0) //Duplicator (applied to the mul argument).
	//carrier = SinOsc.ar(modulating, 0, 0.2, 0).dup(2) //The method .dup would be equal to the previous option.

}.play
)

(
{ var modulating, carrier;

	modulating = SinOsc.ar(1, 0, 500, 1500);
	modulating = modulating.round(125);

	carrier = Pan2.ar(SinOsc.ar(modulating, 0, 0.2, 0), 0) //Pan2, "a two channel equal power pan" (arguments: "in" is the input signal, "pos" is the position within the stereo field: 0 = center, -1 = left, 1 = right, and everything in between).

}.play
)

//Calculation of mul / add for modulations (example 440-880 Hz):
/*
mul = high limit - low limit / 2 (in our example, = 220).
add = mul + low limit (in our example, = 660).
*/
//There are methods that calculate the range (method .range), but understanding how it is actually calculated is very useful to understand how signals work.

//Former range calculation applied to signals: observe the numbers printed by .poll to check the low and high limits of the modulation (440-880):
(
{
	SinOsc.ar(
		SinOsc.ar(1/2, 0, 220, 660).poll(10), //As this is a low frequency modulation, we can perceive differences when changing the phase value (offset of the modulation9: 0.5pi will start the modulation at 880 Hz, 1pi will start at 660, but going downwards first, 1.5pi will start the modulation at 440 Hz, etc.).
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
		SinOsc.ar(1/2, 0).range(440, 880).poll(10),
		0,
		0.2 !2,
		0
	)
}.play
)

//Amplitude modulation (at low frequency):
(
{
	SinOsc.ar(
		SinOsc.ar(1/10,1.5pi, 100, 400), //Low frequency modulation applied to frequency (between 300 and 500 Hz).
		0,
		SinOsc.ar(2, 0, 0.25 !2, 0.25) //Low frequency modulation applied to amplitude (values should be still between 0 and 1, here between 0 and 0.5).
	) * 0.5
}.play
)

//In a low frequency modulation, the objective is not to create new frequency spectrums. When modulating a signal at a frequency of over 20 Hz, a new spectrum starts to be perceptible (in FM, AM, ring modulation, etc.):
{ SinOsc.ar(SinOsc.ar(80, 0, 1200, 1000), 0, 0.1 !2) }.play //Frequency modulation (FM performed at 80 Hz).
{ SinOsc.ar(1000 + SinOsc.ar(80, 0, 1200), 0, 0.1 !2) }.play //Equal to the previous expression (we will study frequency modulation later on in this document).

//Adding more levels of modulation:
(
{
	SinOsc.ar( //Carrier signal.
		SinOsc.ar( //Low frequency modulation of the frequency (between 440-880 Hz).
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
//The other basic periodic waveforms are the triangle, square and sawtooth oscillators. These UGens have a non-filtered and a filtered (band-limited) version (the non-filtered marked in its name by the LF of low frequency, as they are usually used as LFO). The triangle oscillator, LFTri only exist as non-filtered because it does not pose an aliasing problem, but if LFPulse of LFSaw are used to produce sound, they can produce aliasing. Instead, when producing sound, the UGens Pulse or Saw, the filtered version of the oscillators, might be advisable (although aliasing effects could be desirable according to the artistic objectives).

//Triangle wave:
{ LFTri.ar(440, 0, 0.5) }.plot(1/440) //Graph: of cycle.
{ LFTri.ar(440, 0, 0.1) }.scope //Oscilloscope and sound.
//The iphase argument refers to the "initial" phase (this argument also exists in LFSaw and LFPulse, but not in the band-limited versions, as there is no point in changing the phase value. For some reason in this case it is indicated in values 0-4 (0 = 0 radians, 1 = 0.5pi, and so forth, see the examples of the help file). In LFSaw and LFPulse is measured in different ways (see the respective help files).

//Building a triangle wave out of sine waves (useful to understand how the spectrum is built):
(
{ var freq = 440; //Fundamental freq (overtone 1).

	//Sum of odd overtones (when summing up a bunch of signals, they are added to a single channel, thus the amplitude should be compensated).
	SinOsc.ar (freq * 1, 0, 1/1.squared) //The amplitude of each overtone is the power of 2 of the overtone reciprocal.
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
}.scope //Close, but not like a triangle wave (need more overtones to be closer to it). The more overtones, the more definition of the wave shape.
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
//Filtered version (normally, for sound). It does not feature an iphase argument:
{ Pulse.ar(440, 0.5, 0.5) }.plot(2/440)
{ Pulse.ar(440, 0.5, 0.1) }.scope

//Raw version, non-band-limited (normally, for LFO):
{ LFPulse.ar(440, 0, 0.5, 0.5) }.plot(2/440)
{ LFPulse.ar(440, 0, 0.5, 0.1) }.scope

//Both versions include a new argument, the "width", which represents with a ratio from 0 to 1 the percentage of time that the wave spends at 0 and 1 in each cycle. By default, is it 0.5 (half of the time in 0, half in 1). With a "width" equal to 0.8, the wave will spend 80% of the time at 1, and 20% at 0, for instance.

//Comparing Pulse and LFPulse: moving, especially through higher frequencies will produce aliasing when using LFPulse:
{ Pulse.ar(MouseX.kr(20, 22050, \exponential).poll, 0.5, 0.125) }.scope
{ LFPulse.ar(MouseX.kr(20, 22050, \exponential).poll, 0.5, 0.125) }.scope

//The square wave is unipolar, meaning that its amplitude range or depth goes from 0 to 1 instead of from -1 to 1 (as it happens in bipolar signals). Compare these two signals:
(
{
	[
		SinOsc.ar(440, 0, 1, 0), //Sine wave is bipolar: with mul 1 and add 0, the amplitude range will go from -1 to 1 (so add represents the center).
		LFPulse.ar(440, 0, 0.5, 1, 0) //Pulse wave is unipolar: with mul 1 and add 0, the amplitude range will go from 0 to 1 (so add represents to lower limit).
	]
}.plot(5/440, minval: -3, maxval: 3) //Displaying 5 cycles of the periodic waves within amplitude values -3 to 3.
)

//Unipolar signals can be turned into bipolar and vice-versa by using the methods .bipolar and .unipolar:
(
{
	[
		SinOsc.ar(440, 0, 1, 0).unipolar, //Sine wave turned into a unipolar signal.
		LFPulse.ar(440, 0, 0.5, 1, 0).bipolar //Pulse wave turned into a bipolar signal.
	]
}.plot(5/440, minval: -3, maxval: 3)
)

//The band-limited version is, on the other hand, bipolar (because it is prepared to generate sound):
(
{
	[
		SinOsc.ar(440, 0, 1, 0), //Both signals are bipolar.
		Pulse.ar(440, 0.5, 1, 0) //Because of the band limitation, the amplitude of the Pulse wave seems to be lower than the one indicated in its "mul".
	]
}.plot(5/440, minval: -3, maxval: 3)
)

//Building a square wave out of sine waves:
(
{ var freq = 440; //Fundamental frequency (overtone 1).

	//Sum of odd overtones (as in the triangle wave):
	SinOsc.ar (freq * 1, 0, 1/1) //The amplitude of each overtone is the overtone reciprocal (overtones are more present than in a triangle wave).
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
}.scope //Close, but not a real square (need more overtones to sharp the definition of the spectrum).
)

//Modulating with LFPulse (useful as a switch): when multiplying a signal by another signal, the modulation is applied to the amplitude of the first (just like when multiplying a number by a signal, which applied equally to its "mul"):
{ (SinOsc.ar(440) * LFPulse.ar(1)) * 0.2 }.play


//Saw tooth wave:
//Filtered version (normally, for sound). It does not feature an iphase argument:
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

	//Sum of both odd and even overtones (this is why we might need even more overtones to sharp the spectrum towards a real sawtooth wave):
	SinOsc.ar (freq * 1, 0, 1/1) //The amplitude of each overtone is, again, the overtone reciprocal.
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
}.scope //Very poor sawtooth with just 15 overtones, not convincing:
)

//We would need approx. 50 sine waves to obtain something closer to Saw:
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


//Low frequency noise generators: three different interpolations (how they move from one random value to the next):
//Frequency above the 20 Hz limit (any repetition or iteration performed above 20 Hz of frequency (producing more than 20 random values per second) will bring about a new frequency spectrum):
{ LFDNoise0.ar(440, 0.2, 0) }.play //No interpolation or step interpolation (leaps between values).
{ LFDNoise1.ar(440, 0.3, 0) }.play //Linear interpolation (straight lines between values).
{ LFDNoise3.ar(880, 0.3, 0) }.play //Cubic interpolation (curved lines between values).

//Other kinds of low frequency noise generators: LFNoise0, LFNoise1, LFNoise2, LFClipNoise, LFDClipNoise, etc. (they simply feature different randomness).

//Normally used for aperiodic low frequency modulations (examples of modulation applied to a sine wave's frequency):
{ SinOsc.ar(LFDNoise0.ar(10, 500, 1000), 0, 0.2) }.play //No interpolation.
{ SinOsc.ar(LFDNoise1.ar(10, 500, 1000), 0, 0.3) }.play //Linear interpolation.
{ SinOsc.ar(LFDNoise3.ar(10, 500, 1000), 0, 0.3) }.play //Cubic interpolation.

{ SinOsc.ar(LFDNoise3.ar(10, 12, 60).midicps, 0, LFDNoise3.ar(3, 0.5, 0).max(0)) }.play //Applied to two parameters and using the method .max (usefult to create random gaps, as .max only passes what's above 0, and the amplitude range is -0.5 to 0.5).

//Methods .min and .max are useful to limit ranges of parameters:
20.max(60) //Passes only whats above the argument (here, 60): so, if lower than the argument, it passes the argument --> FOR LOW LIMIT.
20.min(10) //Passes only what's below the argument (here, 10): so, if higher than the argument, it passes the argument --> FOR HIGH LIMIT.

{ SinOsc.ar(5000, 0, LFDNoise0.ar(10, 0.3, 0.3)) }.play //Another example, only amplitude modulation (constant freq, quite effective).

(
{ var times;

	times = LFDNoise0.ar(1, 4.5, 5.5); //Modulation of an LFDNoise0's frequency with another LFDNoise0 (random value each second). As this LFDNoise is assigned to a variable, the same random value is shared among all the signals (unlike the LFDNoise applied to the frequencies, which produces different random frequencies for each signal, but let's deepen into this later on).

	Mix( //Five sine waves with different random frequencies mixed into a single channel (and then duplicated on both channels). This will be studied later on when dealing with multichannel expansion.
		SinOsc.ar(
			Array.fill(5, { LFDNoise0.ar(times, 220, 660) }), //Random frequency value between 1 to 10 times per second (every second, new value for the frequency of the modulation).
			0,
			1/20) //Compensating the addition of signals.
	) !2
}.play
)


//Noise generators (broad spectrum noise gerators): normally used for generating sound (very useful for filtering as they contain all the spectrum or a wide part of it):
FreqScope.new //Visualization of the spectrum. Compare the different broad spectrum noise generators with this.

//Noise generators have only two arguments: mul and add. They produce 44100 random frequency values per second (by default, according to the sampling rate), and this is why we perceive them as "noise" (aperiodic signal). The random frequencies are chosen among the whole frequency spectrum (although some kind of noises such as PinkNoise or BrownNoise are filtered). These are the main noise generators, from the brightest to the darkest.
{ ClipNoise.ar(0.1) }.play //Brightest (chooses values from the extremes of the spectrum).
{ WhiteNoise.ar(0.1) }.play //Bright (although all frequencies feature the same probability of been chosen).
{ PinkNoise.ar(0.1) }.play //Perceived as "plain" noise but, in fact, spectrum falling 3dB per octave.
{ BrownNoise.ar(0.1) }.play //Darkest because values chosen out of Brownian motion or random walk (that is to say, there is a maximum deviation for going from one random value to the next). Also spectrum falling 6dB per octave.
{ GrayNoise.ar(0.1) }.play //Based on digital synthesis: flipping random values in the binary code.

//Modulations with noise generators: as the frequency of the noise is changing randomly at sampling rate, the result is another aperiodic signal, although the spectrum is perceptibly defined by the mul and add parameters of the modulating signal. FM modulation with noise:
{ SinOsc.ar(ClipNoise.ar(1980, 4000), 0, 0.1) }.play
{ SinOsc.ar(WhiteNoise.ar(1980, 2000), 0, 0.1) }.play
{ SinOsc.ar(PinkNoise.ar(7620, 8000), 0, 0.1) }.play
{ SinOsc.ar(PinkNoise.ar(54.5, 76.5).midicps, 0, 0.1) }.play
{ SinOsc.ar(BrownNoise.ar(1980, 4000), 0, 0.1) }.play
{ SinOsc.ar(BrownNoise.ar(54.5, 76.5).midicps, 0, 0.1) }.play

//Experimenting with different combinations of mul and add (with the mouse).
{ SinOsc.ar(PinkNoise.ar(MouseY.kr(100, 9000), MouseX.kr(200, 10000)), 0, 0.1) }.play
{ SinOsc.ar(GrayNoise.ar(MouseY.kr(100, 9000), MouseX.kr(200, 10000)), 0, 0.1) }.play
{ SinOsc.ar(BrownNoise.ar(MouseY.kr(100, 9000), MouseX.kr(200, 10000)), 0, 0.1) }.play

//Duplicator when working with randomness: difference between mono-duplicated signals and different instances of a function (different randomness on each side). Note that the use of one or another of these options depends on our objectives:
{ BrownNoise.ar(0.1) !2 }.play //Mono-duplicated signal: same randomness on each side of the stereo.
{ BrownNoise.ar(0.1 !2) }.play //Creating two different instances of the function (applying !2 to the mul argument of the UGen): different function on each side of the stereo, meaning different randomness (the difference between mono-duplicated and different instances of the function is obviously perceptible only when a signal involves some kind of randomness).
{ { BrownNoise.ar(0.1) } !2 }.play //Equivalent to the former function (when a function receives a duplicator, the contents of the function are executed as many times as it is duplicated, therefore creating different instances of it): useful when applying the duplicator to signals with no mul (such as Mix).
{ Array.fill(2, { BrownNoise.ar(0.1) }) }.play //Yet another example of the former line using Array.fill to duplicate the function.
{ { BrownNoise.ar(0.1) }.dup(2) }.play //Yet another option using the method .dup(2).

//Little example to demonstrate how functions respond to duplication:
rrand(50, 1000) !4 //Same result repeated 4 times.
{ rrand(50, 1000) } !4 //Four different results.

//Chaotic noise generator (based on a chaotic function): its arguments are chaosParam, mul and add. About the first argument: "A parameter of the chaotic function with useful values from just below 1.0 to just above 2.0. Towards 2.0 the sound crackles". Some more information about the chaotic function here: https://github.com/supercollider/supercollider/blob/608bb981162c2c26f0a32c09d82557b29774a32e/server/plugins/NoiseUGens.cpp#L379 and here (where I got the previous link from) https://scsynth.org/t/are-crackle-and-dust-repetitive/3087:
{ Crackle.ar(MouseX.kr(1,2), 0.5) }.scope(1)

//Impulse generators (commonly used as triggers):
{ Impulse.ar(1, 0, 0.5) }.play //Single impulse (contains the full freq spectrum) = click.
{ Dust.ar(10, 0.5) }.play //Random impulse generator (density = average of impulses per second), also called impulse noise generator.

//For example, ToggleFF acts as a switch, like LFPulse, but it is not an oscillator and therefore needs a trigger: Dust can act as its trigger (applied to the amplitude of the SinOsc):
{ SinOsc.ar(440, 0, ToggleFF.ar(Dust.ar(3))) * 0.1 }.play //Morse code :) (if only using Dust, the signal wouldn't be longer than a click).

//Butterworth filters: they receive a signal and a cutoff frequency from which the sepctrum will fall gradually (in SC they are 2nd order filters, which means that the spectrum falls 12dB per octave). It is good to try out the filter with noises as input signals, as they contain all the frequency spectrum.
//https://en.wikipedia.org/wiki/Butterworth_filter (about Butterworth filters).
//https://depts.washington.edu/dxscdoc/Help/Tutorials/Mark_Polishook_tutorial/14_Subtractive_synthesis.html (some info about filters in this link about subtractive synthesis).

//High-pass filter. Arguments are the input signal, cutoff frequency, mul and add:
{ HPF.ar(PinkNoise.ar, 1000, 0.1) }.play //Filtering a PinkNoise.
{ HPF.ar(PinkNoise.ar, LFTri.ar(1/10, 0, 8000, 8020), 0.1) }.play //LFTri modulating the cut-off freq from 20 to 16020 Hz every 10 seconds.

//Low-pass filter. Same arguments as in a HPF:
{ LPF.ar(PinkNoise.ar, LFTri.ar(1, 0, 54.5, 76.5).midicps, 0.1) }.play //LFTri modulating the cut-off freq, now using midi values and modulating every second.

//Band-pass filter. The new argument here is "rq" or "reciprocal or q", being q = bandwidth/cutoff freq. The lower the "rq" value, the narrower the passed band of frequencies ("cleaner" sound). But also, the lowet the "rq", the more we need to increase the amplitude to compensate, so that we could need mul values even well over 1:
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

//Band-reject filter. Same arguments as in a BPF:
(
{
	BRF.ar(
		PinkNoise.ar,
		LFTri.ar(1/10, 0, 54.5, 76.5).midicps,
		1, //RQ: the closer to 1, the more noticeable is the rejected band (try out 0.1 for a less clear result). Going over 1 can result in sonic artifacts.
		0.3
	)
}.play
)

//Resonant high-pass and low-pass filters:
{ RHPF.ar(PinkNoise.ar, 1000, 0.01, 0.2) }.play
{ RLPF.ar(PinkNoise.ar, 1000, 0.01, 0.2) }.play

//Resonz filter (the "bwr" argument is equivalent to the "RQ" value), another kind of resonant filter:
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

//Ringz filter or "ringing filter". It includes a "decay time" instead of an "rq" value. Beware the amplitude when using a Ringz filter: unlike filters with rq value, which might need an amplitude above 1, Ringz filter will require to decrease the amplitude quite a bit as the decay time argument increases:
{ Ringz.ar(Impulse.ar(1), 440, 0.5, 0.1) }.play //Clear example of how the Ringz's decay works, here resonating a click at 440 Hz with a decay time of 0.5 seconds.
{ Ringz.ar(WhiteNoise.ar(1), 440, 1, 0.001) }.play //Here applied to a noise.


/////////////////////////////////////////////////////////////////////////////////

//MULTICHANNEL EXPANSION, FILTER BANK AND KLANK

//Multichannel expansion:
//In SC channels (busses) are arrays: a single signal will be played by default through channel 0 (left), whereas an array of two signals will be played through channels 0 and 1 (left and right). Therefore, a stereo signal is an array of two elements (two signals). By default, there are 128 audio channels and 4096 control channels: regarding the audio channels, by default channels 0, 1 are reserved for hardware outputs and 2, 3 for hardware inputs:
s.meter //Visualization of the default channels reserved for output and input signals.
//This can be changed by using these methods (we would need to reboot the server to apply these changes and, afterwards, s.meter will show the new hardware in/out channels):
Server.local.numInputBusChannels_(32); //32 input channels, for example.
Server.local.numOutputBusChannels_(64); //64 output channles, for instance.
//The rest of the channels will be private channels used for internal routing of signals (by default, channels 4 to 127).
//More on this topic: https://doc.sccode.org/Tutorials/Getting-Started/11-Busses.html

{ SinOsc.ar(440, 0, 0.1) }.scope //Coming out through left channel (index 0).
{ SinOsc.ar(440, 0, 0.1 !2) }.scope //Coming out through L-R channels (indexes 0-1).
{ SinOsc.ar(440, 0, 0.1 !2) }.scope(outbus: 10) //Changing it to channels 10-11 (we can visualize it, but can't hear it as channels 10-11 are "private" channels for internal routing).

//Multichannel expansion works this way:
//Array of two signals with different frequency (the are summed up in a single channel):
(
{
	[
		SinOsc.ar(440, 0, 0.1), //Two signals with slightly  different frequency (bringing about one beating per second, as they are 1 Hz off).
		SinOsc.ar(441, 0, 0.1)
	]
}.scope
)

{ SinOsc.ar([440, 441], 0, 0.2) }.play //Equivalent code: an array of two elements in the argument of a signal creates as many instances of that signal as elements present in the array. The rest of the arguments are shared by all signals.

//Using the class Mix (Mix.new, although the method .new can be omitted as it is the most common. It basically creates a new instance of the class): mixing an array of signals into a single channel:
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

{ Mix(SinOsc.ar({ exprand(30, 8000) } !100, 0, 1/200)) }.scope //Equivalent function using the duplicator.

//How Mix works (being a, b and c signals):
a + b + c = [a, b, c].sum = Mix([a, b, c])

//Deconstructing multichannel expansion (useful practice to understand how signals are expanded and distributed among channels):
{ RLPF.ar(Saw.ar([100, 250], 0.05), LFDNoise3.ar(1, 1000, 1030), 0.005) }.play //A resonant low-pass filter is filtering a Saw oscillator and its cutoff frequency is being modulated by a LFDNoise3.

//Equivalent to the previous line:
(
{ var noise;

	noise = LFDNoise3.ar(1, 1000, 1030); //Same noise shared by both signals, same randomness.

	//An array of two frequencies brings about two instances of the Saw oscillator, bringing about at the same time two instances of the RLPF:
	[
		RLPF.ar(Saw.ar(100, 0.05), noise, 0.005),
		RLPF.ar(Saw.ar(250, 0.05), noise, 0.005)
	]
}.play
)

( //Different noise, different randomness: this is what happens if the modulating signal involving randomness is not shared by both signals (not equivalent to the first example):
{
	[
		RLPF.ar(Saw.ar(100, 0.05), LFDNoise3.ar(1, 1000, 1030), 0.005),
		RLPF.ar(Saw.ar(250, 0.05), LFDNoise3.ar(1, 1000, 1030), 0.005)
	]
}.play
)

//Another example: when more than one argument features an array of values, the biggest array indicates the number of instances, and the values of shorter arrays will wrap:
{ Pulse.ar([400, 500, 600], [0.5, 0.1], 0.1) }.play

( //Equivalent to the previous line:
{
	[
		Pulse.ar(400, 0.5, 0.1),
		Pulse.ar(500, 0.1, 0.1),
		Pulse.ar(600, 0.5, 0.1)
	]
}.play
)

//Stereo using Mix:
//First, let's understand what happens when there are several levels of nested arrays when using Mix: two levels of arrays of signals --> In each array, signals will mix in each available output channel (here, we can only have two arrays of signals). A third level of arrays wouldn't be cleared by Mix (in Help file "Multichannel Expansion" --> "Reducing channel expansion with Mix": "You cannot use Mix on arrays of arrays of arrays"). In conclusion, Mix only clear one level of arrays:
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
//Now, in order to get some stereo sound out of a single array of signals, there are several options:
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
{ { Mix(SinOsc.ar({ exprand(30, 8000) } !100, 0, 1/200)) }.dup(2) }.play //As already seen, .dup(2) fulfills the same function as !2.

//Using Splay: distribution of a mono signal in the stereo field (instead of 100 different freqs on each side, the 100 freqs will be distributed among both sides of the stereo):
{ Splay.ar(SinOsc.ar({ exprand(30, 8000) } !100, 0, 1/200), 1, 2.5) }.play //Second argument is "spread" (when = 0, all signals go to the center, when = 1, they distribute among the -1 to 1 stereo field, and everything in between), and third argument is "level" (for amplitude compensation).

//Other examples of multichannel expansion:
//Comparing these two codes:
(
{
	Mix.ar(
		Array.fill(18, { Ringz.ar(WhiteNoise.ar(0.0001), exprand(100, 3000)) }) //There will be 18 different white noises, as the Array.fill includes the entire filter function into it (if put into a variable, equivalent to next code).
	) !2
}.play
)

(
{
	Mix.ar(
		Ringz.ar(
			WhiteNoise.ar(0.0001), //A unique noise is shared among the 18 filters (the Array.fill affects only the function for the random choice of frequencies within the filter).
			Array.fill(18, { exprand(100, 3000) })
		)
	) !2
}.play
)

//Deconstruction of Mix:
( //Given code presenting arrays in several arguments:
{ var freqDeviation;

	freqDeviation = LFNoise2.ar(0.05, 0.2, 1); //A very slow frequency deviation (over 20 seconds).

	Mix(
		BPF.ar(
			BrownNoise.ar,
			f = Array.geom(5, 440, 3/2) * freqDeviation, //Array of five frequencies (with a fifth of separation between each) multiplied by the freq deviation.
			0.05/f, //The higher the frequency, the smaller the RQ value.
			[24, 30].dbamp //Array of two amplitude values in db.
		)
	)
}.play
)

( //Equivalent code showing the multichannel expansion:
{ var freqDeviation, noise, amps, freqs;

	freqDeviation = LFNoise2.ar(0.05, 0.2, 1);

	noise = BrownNoise.ar; //The noise is shared by all signals.
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

//Filter banks: stacks of filters at a specific intervalic distance (based on overtones rations or equal intervalic ratios):
(
{
	Mix(
		BPF.ar(
			PinkNoise.ar,
			Array.geom(16, 30, 3/2), //Pitagoric fifths (or natural fifths), ascending from the given fundamental frequency (30 Hz). Reciprocal of the ratio (2/3) = downward series (beware the starting frequency). Remember that reciprocal = 1/x; here 1/(3/2) = (1*2)/3 = 2/3.
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
			Array.geom(16, 30, 7.midiratio), //Tempered fifths (equal temperament), using semitones.midiratio. Compare with the previous code (here, less bright).
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
			Array.geom(8, 30, 2), //Octaves (it is advisable to always check the highest frequency given by the array according to its size, start and grow arguments).
			0.001, //Try out other "rq" values to obtain a "cleaner" or "dertier" sound.
			3
		)
	) !2
}.play
)

//Little reminder of overtone ratios for each (approximate) interval. Examples for ascending series:
/*
unison - 1
min 2nd - 17/16 (still too open compared to 1.midiratio).
maj 2nd - 9/8 (still too open compared to 2.midiratio, but 10/9 is already too little).
min 3rd - 6/5 (same problem...)
maj 3rd - 5/4 (same problem...)
P 4th - 4/3
tritone - 7/5 (not even close to a tritone, not really present in the overtone series).
P 5th - 3/2
min 6th - 8/5 (same problem...)
maj 6th - 5/3 (same problem...)
min 7th - 7/4 (uffffff)
maj 7th - 17/9 (surprisingle close!)
octave - 2
*/

//Other examples of filter banks:
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
	Array.fill(10, { |i| ((i + 1 / 10) * 0.5).midiratio }); //Frequency deviation: from 0.05.midiratio (applied to the fundamental freq) up to 0.5.midiratio of deviation (applied to the last frequency), which is equal to a quarter tone (change the * 0.5 -to * 0.1 or * 1, for instance- to change the level of deviation. This value will be multiplied by values from 0.1 to 1 according to the function).

	amps = Array.geom (10, 2, 0.96); //Amplitude deviation.

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

//Klank filter: a bank a fixed-frequency resonators (that is to say, a bank of Ringz filters):

//Arguments:
//specificationsArrayRef: see Help file "Multichannel expansion" --> "Protecting arrays against expansion" (the little inverted comma avoids that the argument is interpreted as an array of arrays):
`[
	Array of freqs,
	Array of amps,
	Array of decay times
]
//input: usually an Impulse, Dust or any noise generator, but it can be any kind of signal.
//freqscale: scale factor multiplied by all frequencies (as they are fixed (cannot be modulated), they can be "transposed" using this argument).
//The rest of the arguments are rarely used (see help file of Klank).

//Examples:
(
{
	Klank.ar(
		`[
			//Array.fill(8, { exprand(150, 14000) }), //Random freqs.
			Array.geom(8, 80, 3/2), //Stack of fifths.
			1,
			Array.fill(8, { exprand(0.02, 0.2) }) * 32 //The factor value is just lengthening the ringing times.
		],
		{ PinkNoise.ar(0.005) } !2 * 0.5, //Applied to a PinkNoise.
	)
}.play
)

(
{
	Klank.ar(
		`[
			[178, 570, 7384, 605, 356, 1150, 14768, 1210],
			1,
			[0.002, 0.012, 0.018, 0.013] //Smaller array wraps.
		],
		{ Dust.ar(3, 0.1) } !2 //Applied to a Dust (quite realistic tapping).
	)
}.play
)

(
{
	Klank.ar(
		`[
			[178, 570, 7384, 605, 356, 1150, 14768, 1210],
			1,
			[0.002, 0.012, 0.018, 0.013] * 16 //Ading some greater decay (now it seems that we are tapping some sort of glass).
		],
		{ Dust.ar(3, 0.1) } !2
	)
}.play
)


/////////////////////////////////////////////////////////////////////////////////

//ENVELOPES, TRIGGER AND GATE
//Envelopes describe events over time.

//Basic syntax: we need two classes to create an envelope: EnvGen is the Unit Generator of envelopes, and Env allows us to specify the characteristics of the envelope generated by EnvGen:
EnvGen.ar(Env(levels, times, curves), gate) //Env receives by default the method .new (which can be omitted). The arguments of Env.new are levels (an array of values in the "y" axis, defining frequencies, amplitudes or any kind of parameter the envelope is applied to), times (an array of times in seconds to go from one level to another, meaning that there will always be one less value of times than values of levels), and curves (an array of symbols or numbers indicating the way the envelope moves from one value to the next).

//Let's see some options for the curves of the envelope:
//Linear curve:
Env([0, 0.5, 0.1, 0.5, 0], 1, \linear).plot //Graphical representation (straight lines).

( //Sonic result (applied to the amplitude of a sine oscillator):
{ var signal, env, envGen;

	env = Env([0, 0.5, 0.1, 0.5, 0], 1, \linear); //The time from one level to the next will always be 1 in here.
	envGen = EnvGen.ar(env);

	signal = SinOsc.ar;

	signal * envGen //In order to apply the envelope to the amplitude of a signal, we simply multiply the signal by the envelope.
}.play
)
s.plotTree //As the last value of the envelope is 0, we don't hear the sine oscillator anymore, but the synth is still running in the server, holding the last level of the envelope until we free the synth. We will talk later about possible solutions for this in case we need the synth to go away when the envelope is done.

//Exponential curve:
Env([0.001, 0.5, 0.1, 0.5, 0.001], [1, 4, 6, 2], \exponential).plot //Graphical representation (curved lines). An exponential curve cannot touch nor cross 0.

( //Sonic result:
{ var signal, env, envGen;

	env = Env([0.001, 0.5, 0.1, 0.5, 0.001], 1, \exponential);
	envGen = EnvGen.ar(env);

	signal = SinOsc.ar;

	signal * envGen
}.play
)

//Step curve:
Env([0, 0.5, 0.1, 0.5, 0], 1, \step).plot //Graphical representation (leaps). sFirst level is "lost" as the first step is to directly jump to the second level. When working with, for example, frequencies, it would make sense to repeat the first frequency in order to hear it.

( //Sonic result:
{ var signal, env, envGen;

	env = Env([0, 0.5, 0.1, 0.5, 0], 1, \step);
	envGen = EnvGen.ar(env);

	signal = SinOsc.ar;

	signal * envGen
}.play
)

//Curve defined by floats:
Env([0, 0.5, 0.1, 0.5, 0], 1, 8).plot //Graphical representation: 0 = linear, 4 = sort of exponential, 8 = closer to step, and upwards every time sharper, although it also depends on the speed of the segment (the corresponding value from the times array or value). Negative and positive values change the side from which the curve is "pulled".

( //Sonic result:
{ var signal, env, envGen;

	env = Env([0, 0.5, 0.1, 0.5, 0], 1, [4, -4]); //Almost equivalent to \exponential, but we can touch or cross 0.
	envGen = EnvGen.ar(env);

	signal = SinOsc.ar;

	signal * envGen
}.play
)

//Array of different curves:
Env([0, 0.5, 0.1, 0.5, 0], 1, [8, -4, \exponential, 0]).plot //Graphical representation, one kind of curve for each segment (also one less value than in the levels array).

( //Sonic result:
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

	freq = EnvGen.ar(Env([39, 61, 50] + 12, 2, \linear)).midicps; //Linear distribution among midi values, then conversion to Hz (if the conversion happens before, an exponential distribution would be more convenient to work with Hz.

	SinOsc.ar(freq, 0, 0.2) //The envelope is placed in the frequency argument of the signal. When the envelope is done, the signal holds its last level as frequency value.
}.play
)

//Method .circle and randomness. We can "loop" the envelope by applying the method .circle to the Env class, although it just jumps to the first value from the last one (no interpolation between last and first value). In addition to this, the possible randomly chosen values will be maintained instead of being refreshed:
(
{ var freq;

	freq = EnvGen.ar(
		Env(Array.fill(5, { rrand (60, 104) }),
			Array.fill(4, { rrand(0.2, 1) }),
			\linear
		).circle //Method .circle.
	).midicps;

	SinOsc.ar(freq, 0, 0.1)
}.play
)

//Last example: filter bank (envelope applied to the grow argument):
(
{ var grow, freq;

	//grow = EnvGen.ar(Env([2/1, 3/2, 7/4], [8, 4], \exponential).circle);
	grow = EnvGen.ar(Env([2/1, 3/2, 7/4, 2/1], [2, 3, 2], \exponential).circle); //If the envelope finishes in the same value as it starts, the method .circle will seem to include an interpolation between both values.
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

//"Standard shape envelope creation methods" (these are also class methods): we can use different methods to create specific envelope shapes such as:
//Triangle envelope:
Env.triangle(1, 0.3).plot //Graphical representation.
{ SinOsc.ar * EnvGen.ar(Env.triangle(1, 0.3).circle) }.play //Sonic result.

//Sine envelope (usually used for granular synthesis):
Env.sine(1, 0.3).plot
{ SinOsc.ar * EnvGen.ar(Env.sine(1, 0.3).circle) }.play

//Percussive envelope:
Env.perc(0.01, 0.25, 0.3, -4).plot //The curve of a percussive envelope cannot be exponential because it will always touch 0.
{ SinOsc.ar * EnvGen.ar(Env.perc(0.01, 0.5, 0.3, -4).circle) }.play

//Trapezoidal envelope:
Env.linen(0.01, 1, 0.3, 1, \linear).plot //Includes an attack, sustain and release time.
{ SinOsc.ar * EnvGen.ar(Env.linen(0.01, 1, 0.5, 0.3, \linear).circle) }.play

//Nice "punchy" bass XD (only for good loudspeakers): a very sharp envelope is applied to the frequency, and a percussive envelope is applied to the amplitude:
{ SinOsc.ar(EnvGen.ar(Env([400, 40], 0.05)), 0, EnvGen.ar(Env.perc(0, 4))).dup(2) * 0.5 }.play


//TRIGGER
//The second argument of EnvGen is "gate". Gate is 1 by default as, as far as it is 1, it will trigger the envelope and hold it open. Though in order to use the argument gate as a real gate we need a different kind of envelope that can be sustained. Gate can be used as a trigger for those envelopes that cannot be sustained in order to "reboot" the envelope every certain amount of time (this is equivalent to the method .circle, but now we don't depend on the duration of the envelope, but on the frequency of the trigger, which we can control independently of the duration of the envelope):
(
{ var trigger, signal, env;

	trigger = Impulse.ar(1); //Impulse will trigger the envelope 1 time per second (try with freq of 2 and with Dust).
	signal = SinOsc.ar;
	env = EnvGen.ar(Env.perc(0.01, 0.5, 0.3), trigger); //If the release of .perc is longer than the frequency of the impulse, we will never hear silence between the envelopes (try with release = 2).

	signal * env
}.play
)

//Randomness: same random values (times and freqs) will be kept every time the envelope is retriggered:
(
{ var freq, trigger, time, signal;

	trigger = Impulse.ar(1/4); //It does not matter if the envelope is completed: every four seconds, it is rebooted (if longer than 4 seconds, it is cut, and if shorter than 4 seconds, last value is sustained until next trigger).
	time = [rrand(0.5, 3)]; //Random time chosen between 0.5 and 3 seconds. If the random choice was made directly into the expanded envelope, each envelope will feature a different time value. This will also happens if the rrand is sent within a function (between curly brackets), as several instances of the function will be executed (instead of duplicating an array).

	//Array of five envelopes (each envelope features five random levels used as frequencies in the SinOsc), bringing about five sine oscillators:
	freq = Array.fill(5, {
		EnvGen.ar(Env(Array.fill(5, { exprand(60, 78).midicps }), time, \step), trigger) //Because of the step curve, we only hear four frequencies.
	});

	signal = Mix.ar(
		SinOsc.ar(
			freq,
			0,
			0.1
		)
	) !2;

	signal * 0.3

}.play
)

//Next example uses the SoundIn signal from the mic as a trigger (including a threshold of amplitude, here 0.05). Try clapping or speaking close to the computer's mic:
(
{ var trigger = SoundIn.ar(0) > 0.05; //Amplitude coming through the mic has to be over 0.05 (change this threshold as needed).

	SinOsc.ar(
		//TChoose.ar(trigger, K2A.ar(Scale.minor.ratios * 72.midicps)), //Another possibility (using K2A to turn control to audio signals, as the postwindow tells us that the "Select input was not audio rate". TChoose expects an array of signals, that is why it complains when receiving numbers. There is also A2K object). Using random frequencies from a minor scale within the octave of C5.
		TRand.ar(262, 1200, trigger), //Random frequency produced by TRand every time it receives a trigger.
		0,
		EnvGen.ar(Env.perc(0.01, 1), trigger) //Percussive envelope sharing the same trigger as the random frequency choice.
	).dup(2) * 0.4 //Multichannel expansion and amplitude balance.

}.play
)


//GATE
//In order to use the argument gate as a real gate, we need an envelope with sustain time (which will be sustained as far as gate = 1), that is to say, any of the so-called sustained envelope creation methods (.adsr, .asr, .dadsr, etc., see Help file of Env for more). When gate receives a 1, the attack (and possible decay) of the envelope is triggered and the envelope hold at its sustain level, and when gate receives a 0, the release segment of the envelope is triggered.

//Basic syntax of method .adsr:
Env.adsr(attackTime, decayTime, sustainLevel, releaseTime, peakLevel, curve) //Arguments are the attack time (from silence to peak level), decay time (from peak level to sustain level), sustain level (ratio of level depending on the peak level: if sustain level = 1, then it will be equal to the peak level and the decay segment won't be heard), release time (from sustain level to silence), peak level (maximum amplitude peak), and curve (excluding exponential as it will touch 0, but which can be imitated with floats [4, -4], for example).

//Graphical representation (takes 1 sec to render, as plotting occurs at real time):
{ EnvGen.ar(Env.adsr, LFPulse.ar(1)) }.plot(1) //When LFPulse's width = 0.5, and freq = 1, the envelope will feature 0.5 seconds of ads and 0.5 seconds of release (and possible silence depending on the release time).
{ EnvGen.ar(Env.asr, LFPulse.ar(1)) }.plot(1) //Same here (using method .asr), although there is no decay time.

//Applying gate:
(
a = { |gate = 1| //Default value (envelope is immediately triggered by default when executing the function).
	var env;

	env = EnvGen.ar(Env.adsr(0.1, 0.2, 0.5, 1, 0.2, -4), gate);

	SinOsc.ar !2 * env
}.scope
)

//We can use the method .set to change the arguments of a signal running in the server (the arguments are called through symbols):
a.set(\gate, 0) //Gate = 0 triggers the release of the envelope.
a.set(\gate, 1) //Gate = 1 triggers a new attack, decay and sustain of the envelope.
//Meanwhile, the envelope continues running in the server even when there is no sound (see node tree). The synth is the same, gate = 1 does not produce a new instance of the envelope, it just retriggers the one already running in the server.

//DoneAction = 2 (last argument of EnvGen): see Help file of "EnvGen" --> In the information about the argument "doneAction", open the documentation about "Done": at the end of the document, there is a list of actions that can be implemented with doneAction: doneAction = 0 means "do nothing when the UGen is finished", doneAction = 2 means "free the enclosing synth" (so that the synth stops running in the server). In the same document, there is a list of the classes concerned with the doneAction argument:
(
a = { |gate = 1|
	var env;

	env = EnvGen.ar(Env.adsr(0.1, 0.2, 0.5, 1, 0.6, -4), gate, doneAction: 2); //Usually applied using keyword assignment as it is the last argument.

	SinOsc.ar !2 * env * 0.5
}.scope
)

a.set(\gate, 0) //When sending 0 to the gate, the envelope is finished and doneAction 2 frees the synth in the server (check the node tree: the synth is gone).
a.set(\gate, 1) //Sending 1 to the gate again is no longer possible because the synth does not exist anymore.
//This will be beneficial when creating several instances of a SynthDef (synth definition) later on, so that those instances do not silently accumulate in the server.

//Using LFPulse to open / close the gate periodically:
(
{ var gate, signal, env;

	gate = LFPulse.ar(0.5, 0, 0.5); //LFPulse used as a switch to open and close the gate periodically every two seconds (remember: the argument "width" allows us to shorten or lengthen the sustain within these two seconds (width = 0.5 means one second of attack, decay and sustain, and one second for release and possible silence according to the release time).

	signal = SinOsc.ar;

	env = EnvGen.ar(Env.adsr(0.01, 0.1, 0.3, 1, 0.3), gate);

	signal !2 * env
}.play
)

//Extra: Line and XLine (similar result in the following two examples). The arguments are the starting value, end value and time in seconds:
{ SinOsc.ar(Line.ar(60, 84, 2).midicps, 0, 0.1 !2) }.play //Line generator (if applied to frequency, works better with midi values, and converting afterwards).
{ SinOsc.ar(XLine.ar(260, 1046, 2), 0, 0.1 !2) }.play //Exponential line generator (if applied to frequency, works better with Hz).

{ LPF.ar(LFSaw.ar(40), XLine.ar(600, 40, 2)).dup(2) * 0.1 }.play //Example: nice bass beat, but the sound does not go at the end (Line sustains the last value, just like any other envelope).
{ LPF.ar(LFSaw.ar(40), XLine.ar(600, 40, 2, doneAction: 2)).dup(2) * 0.1 }.play //Now the signal is gone after the line, but causing a click.
{ LPF.ar(LFSaw.ar(40), XLine.ar(600, 40, 2, doneAction: 0)).dup(2) * Line.ar(0.2, 0, 2, doneAction: 2) }.play //Another line is applied to the amplitude and doneAction is applied to the amplitude envelope to cut the filter properly with no clicks.

/////////////////////////////////////////////////////////////////////////////////

//MODULATIONS (Ring, AM, FM) AND DECAY LINES
//When modulating a signal at over 20 Hz of frequency, a new frequency spectrum will be created out of this periodicity:

//Ring modulation: it is a kind of amplitude modulation in which the fundamental frequency disappears. The modulation is performed by multiplying both signals or placing the modulating signal in the amplitude argument of the carrier signal:
{ SinOsc.ar(440) !2 * SinOsc.ar(220) * 0.1}.play //We don't hear 440 nor 220, but the subtraction and addition of both (440 + 220 and 440 - 220).

//Amplitude modulation (AM): whereas the "depth" of the ring modulation was -1 to 1 (regarding the mul/add arguments of the modulating signal), the depth of the AM should be 0 to 1 in order to keep the fundamental frequency:
{ SinOsc.ar(440) !2 * SinOsc.ar(220, 0, 0.5, 0.5) * 0.1 }.play //We hear (car + mod) + (car - mod) + car, as the mul/add arguments of the modulating signal are adjusted to the range 0-1.

//Other examples:
{ BrownNoise.ar(0.1 !2) * SinOsc.ar(5000) }.play //Try out 100, 50, 20, 10 for the SinOsc frequency to see what is happening.
{ BrownNoise.ar(0.1) * SinOsc.ar(LFDNoise3.ar(1, 975, 1025)) }.play //Random value from 50 to 2000 (try with LFDNoise0).
{ Saw.ar(200) * LFDNoise3.ar(50 !2, 0.1) }.play //Using an LDFNoise with frequency over 20 Hz (try with freq = 10 to see what is happening).
{ Saw.ar(2000) * LFDNoise3.ar(200 !2, 0.1) }.play //A different combination of frequencies featured in the former line (but same signals).

//Ring modulation applied to an audio sample (ugly default SC audio sample):
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav") //Loading an audio file into a buffer (this won't be studied in this document, but if needing to go ahead, read this introduction to buffers: https://depts.washington.edu/dxscdoc/Help/Tutorials/Getting-Started/13-Buffers.html).

//Applying ring modulation to the recording using a sine oscillator, and controlling the frequency using the horizontal movement of the mouse:
{ PlayBuf.ar(b.numChannels, b.bufnum, loop: 1) * SinOsc.ar(MouseX.kr(20, 14000, \exponential).poll) !2 * 0.2 }.play //Range of frequencies from 20 to 14000 Hz.

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

//Examples (they respond very differently depending on the signals they receive):
{ SinOsc.ar(440) ring1: SinOsc.ar(220) !2 * 0.1 }.play //Equivalent to our first example of AM.

{ SinOsc.ar(440) ring2: SinOsc.ar(220) !2 * 0.1 }.play

{ BrownNoise.ar(0.5) ring3: SinOsc.ar(LFDNoise3.ar(1, 1500, 2000), 0, 0.3 !2) }.play

{ BrownNoise.ar(0.5) ring4: SinOsc.ar(LFDNoise3.ar(1, 1500, 2000), 0, 0.3 !2) }.play

{ SinOsc.ar(7000, 0, 0.2) ring4: SinOsc.ar(LFDNoise3.ar(3, 125, 7000), 0, 0.3 !2) }.play

//Frequency modulation (FM): consists of adding a signal to the frequency of another signal.
//More info in these two tutorials:
//https://www.youtube.com/watch?v=UoXMUQIqFk4&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=22
//https://www.youtube.com/watch?v=dLMSR2Kjq6Y&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=23

{ SinOsc.ar(500 + SinOsc.ar(1)) * 0.1 !2 }.scope //No perceptible difference, but slight movement from left to right in the oscilloscope, meaning that the carrier signal is oscillating (in fact from 499 to 500 Hz every second).
{ SinOsc.ar(500 + SinOsc.ar(1, 0, 20)) * 0.1 !2 }.scope //Oscillation between 480 and 520 Hz every second (mul of modulating signal = range of freq modulation by adding and subtracting to the carrier's frequency).
{ SinOsc.ar(500 + SinOsc.ar(8, 0, 400)) * 0.1 !2 }.scope //Oscillation 8 times per second, between 100 and 900 Hz.
{ SinOsc.ar(500 + SinOsc.ar(22, 0, 400)) * 0.1 !2 }.scope //Crossing the 20 Hz limit = new frequency spectrum.
{ SinOsc.ar(500 + SinOsc.ar(80, 0, 400)) * 0.1 !2 }.scope //Fully new spectrum.
//By the way, equivalent to (using the add argument instead of literally adding to the frequency of the carrier):
{ SinOsc.ar(SinOsc.ar(80, 0, 400, 500)) * 0.1 !2 }.scope

//Example from first linked tutorial (to show a bunch of possible combinations of values): with MouseY, we change the carrier's freq (500-5000 Hz); with MouseX, we change the modulating's freq (1-2000 Hz); lastly, the modulating's mul, which is the range of frequency modulation, is controlled by a LFNoise0, which produces 8 random values per second.
{ SinOsc.ar((MouseY.kr(500, 5000, 1) + SinOsc.ar(MouseX.kr(1, 2000, 1), mul: LFNoise0.kr(8).range(400, 4500))).poll) * 0.1 !2 }.scope //Because of its ranges, this code could produce negative frequencies (see postwindow): negative frequencies mean we're asking an oscillator to produce its periodic shape in reverse (they don't exist in real life though, as time cannot go backwards, but in the digital domain, they translate into that).

//Decay lines:
//A decay line generates an exponential envelope with a certain duration triggered by impulses. Applied to certain sounds, it allows us to enhance the attack of those sounds:
{ BrownNoise.ar !2 * Decay.ar(Impulse.ar(0.5), 0.5, 0.2) }.play //Applied as an amplitude envelope for the BrownNoise. The arguments are the input (a trigger, in this case, an Impulse), the decay time, and the mul and add). The envelope is triggered every two seconds here.

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

	ring1: //ring: multiplies both signals and adds the filter to the mix.

	//Thanks to the common trigger, the WhiteNoise with the Decay envelope is applied to the attack of each filtered Impulse.
	WhiteNoise.ar(Decay.ar(impulse, 0.04))
	} !2 * 0.2

}.scope
)
