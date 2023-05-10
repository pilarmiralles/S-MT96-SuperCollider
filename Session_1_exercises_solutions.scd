//SESSION 1 - EXERCISES WITH SOLUTIONS

/////////////////////////////////////////////////////////
//ARRAYS AND METHODS, BASIC TASKS:

//1 - Write an array of 11 elements of different type (heterogeneous) and assign the array to a variable "a":
a = [\hi, 5, 68.midicps, { PinkNoise.ar(0.2) }, 0.1, "hello".scramble, 127, { SinOsc.ar(PinkNoise.ar(180, 270), 0, 0.5) }, 0.00002, { BPF.ar(in: BrownNoise.ar(0.5), rq: 0.05, mul: 1.5) }, \end] //(Very random)

//2 - Assign to the variable "b" the second element of "a":
b = a[1]

//3 - Assign the first element of "a" to the variable "b":
b = a[0]

//4 - Assign to the variable "c" an array containing 24 random values between the range 1 to 12:
c = Array.fill(24, { rrand (1, 12) })

//5 - Assign to the variable "d" an array containing an arithmetic series of 31 numbers, starting by 1000 and going up by steps of 111:
d = Array.series(31, 1000, 111)

//6 - Rotate the former series three slots to the right and reassign the value to "d":
d = d.rotate(3)

//7 - Reassign to "d" the retrograded "d":
d = d.reverse

//8 - Assign to "d" the elements of "d", but changing the order randomly:
d = d.scramble

//9 - Assign to "e" a geometric series of 16 elements, starting by 33 and with a growing factor of 1.5 (series of Pitagoric fifths):
e = Array.geom(16, 33, 1.5)

//10 - Apply to "e" the method .plot and observe:
e.plot

//11 - Assign to "f" an arithmetic series of 16 numbers. The two first numbers of the series must be 24 and 31:
f = Array.series(16, 24, 7)

//12 - Assign to "f" the mirror of "f". Then, apply a plotter to the result:
f = f.mirror
f.plot

//13 - Apply the method .plot to "f", obtaining a discontinuous line in the graph:
f.plot(discrete: true)

//14 - Change the order of the elements in "f" randomly and apply a plotter to its values, obtaining a continuous and a discontinuous line in the graph:
f = f.scramble
f.plot(discrete:true)
f.plot(discrete:false)//The graph would be continuous by default.

//15 - Create an array of 101 random elements chosen from the elements of an array of the numbers 1 to 5. Each element should have a different probability of been chosen (several options):
Array.fill(101, { [1, 2, 3, 4 ,5].wchoose([0.6, 0.01, 0.29, 0.04, 0.06]) }) //First option, directly writing the 1-5 array within the outer array as an argument.

Array.fill(101, { Array.series(5, 1, 1).wchoose([0.6, 0.01, 0.29, 0.04, 0.06]) }) //Second option, the 1-5 array is created using Array.series.

g = [1, 2, 3, 4, 5]
Array.fill(101, { g.wchoose([0.6, 0.01, 0.29, 0.04, 0.06]) }) //Third option, the 1-5 array is assigned to a variable, and then used inside the outer array.


/////////////////////////////////////////////////////////
//FUNCTIONS, BASIC TASKS:

//1 - Create a function that calculates the hypotenuse of a triangle applying the Pythagorean theorem:
(
{ |sideA = 1, sideB = 1|
	var hypotenuse;

	hypotenuse = (sideA.pow(2) + sideB.pow(2)).sqrt

}.value(5, 4) //Example
)

//2 - Create a function in which the frequency in Hz and MIDI value of the overtone number (n) of a given fundamental frequency are calculated:
(
{ |n, fundFrecMidi = 24|
	var hz, midi;

	hz = n * fundFrecMidi.midicps;
	midi = hz.cpsmidi.round(1);

	[hz, midi]

}.value(8) //Example
)

( //Can also do it from fundamental freq in Hz:
{ |n = 1, freq = 50|
	var hz, midi;

	hz = freq * n;
	midi = hz.cpsmidi.round(1);

	[hz, midi]

}.value(3, 50)
)

//3 - Create a function that checks whether a word (string of letters) is a palindrome or not:
(
f = { |word|
	var original, reverse;

	original = word;

	reverse = word.reverse;

	original == reverse;
}
)

f.value("lol") //Boolean result (true / false)
f.value("tacocat")
f.value("dog")

//4 - Given an array of integers, create a function that returns the array from the middle value to the last element (if there are two middle values, take the second. For this last step, a conditional is needed. Skip if no knowledge yet):
(
f = { |array|
	var size, middle;

	size = array.size;

	if (size.odd, {middle = (size / 2).roundUp - 1}, {middle = size / 2}); //The result of this is an INDEX.

	array[middle.asInteger..]

}
)

f.value([1, 2, 3, 4, 5, 6, 7])

( //No conditional (works only for odd-sized arrays):
{ |array|
	var midValue;

	midValue = (array.size / 2).round(1) - 1;
	array[midValue.asInteger..]

}.value([1, 2, 3, 4, 5])
)

//ADVANCED EXERCISE: Symmetric difference algorithm. Create a function that compares two arrays of numbers and gives back an array with all numbers that are present only in one of the arrays. For example, comparing [1, 2, 3, 4] and [2, 3, 4, 5], the result should be [1, 5].
//A possible approach: comparing each element of the first array: asking the second array how many instances are in there of each element of the first array (if no instances, it passes to the final array) + same viceversa + concatenate both results at the end:
(
a = { |array1, array2|
	var result1, result2, finalArray, addition, utmostArray;

	//Comparing the array and obtaining the unique values of each:

	result1 = array1.select({ //The method select receives a collection and features a function and two arguments (item and index). The method answers a collection consisting of all items in the receiver for which its function answers "true".
		|item|
		array2.occurrencesOf(item) == 0 //OccurrencesOf(item) refers to the number of repetitions of the given item within a collection.
	});

	result2 = array2.select({
		|item|
		array1.occurrencesOf(item) == 0
	});

	finalArray = result1 ++ result2;
	"repetitions may occur:".postln;
	finalArray.postln;

	//Filtering repetitions:

	finalArray = finalArray.as(Set); //See Set help file (a Set is s collection of objects, no two of which are equal).
	"repetitions are gone:".postln;
	finalArray = finalArray.as(Array)
}
)

a.value([1, 2, 3, 3, 6, 7, 7], [5, 2, 1, 4, 6, 8, 1]) //--> The solution should contain the numbers 7, 8, 4, 5, 3 into an array.


/////////////////////////////////////////////////////////
//SIGNALS, BASIC TASKS:

//1 - Modulate the frequency of a sine oscillator from 65 to 3961 Hz using another sine oscillator. The period of the modulating signal should be 11 seconds. Adjust the phase so that the modulation starts at 3961 Hz:
(
{
	SinOsc.ar(
		SinOsc.ar(1/11, 0.5pi, 1948, 2013),
		0,
		0.3)
}.play
)

//2 - Create a sawtooth oscillator with frequency equal to 1000 Hz. Use a bandpass filter to filter the sawtooth oscillator and stablish a narrow bandwidth. Use a low frequency noise generator with cubic interpolation to slowly modulate the cutoff frequency of the filter. Use the mul / add arguments of the modulating signal so that the modulation moves between the 1st and 11th overtones of the sawtooth oscillator:
(
{ var freq;

	freq = LFDNoise3.ar(1/3, 5000, 6000); //1st overtone = 1000 Hz, 11th overtone = 1000 * 11. Modulation range between 1000 and 11000 Hz.

	BPF.ar(
		Saw.ar(1000),
		freq,
		0.001,
		5
	)
}.play
)

//3 - Create a random impulse generator (Dust) with a density equal to 3 and filter the signal using 60 Ringz filters. Use exponential distributions to randomize the frequency and decay time of each filter. Then mix the 60 signals into a single channel:
(
{
	var in, signal;

	in = Dust.ar(3); //Beware: if Dust is not put into a variable, when using Array.fill to duplicate the entire Ringz, 60 different Dust will be created.

	signal = Array.fill(60, {
		Ringz.ar(
			in,
			exprand(500, 3000),
			exprand(0.1, 2),
			0.01
		)
	});

	{ Mix(signal) } !2

}.play
)

( //Equivalent option (though now we could place Dust into the Ringz filter without the variable and only one Dust would be created):
{
	var in, signal;

	in = Dust.ar(3);

	signal = Ringz.ar(
		in,
		Array.fill(60, { exprand(500, 3000) }),
		Array.fill(60, { exprand(0.1, 2) }),
		0.01
	);

	{ Mix(signal) } !2

}.play
)

( //Though for next exercise we need a simpler mono version so it can be panned (so this is the proper solution):
{
	Mix(
		Ringz.ar(
			Dust.ar(3),
			Array.fill(60, { exprand(500, 3000) }),
			Array.fill(60, { exprand(0.1, 2) }),
			0.01
		)
	)
}.play
)

//4 - From the former code: add an independent stereo panoramization for each filter and carry out a slow modulation of the position of each filter using a linear low frequency noise generator. Then mix the 60 signals into a two-channel signal:
(
{
	Mix(
		Pan2.ar( //Pan2 already creates a two-channel signal for each filter, so Mix will consist on an array of 60 two-channel signals).
			Ringz.ar(
				Dust.ar(3),
				Array.fill(60, { exprand(500, 3000) }),
				Array.fill(60, { exprand(0.1, 2) }),
				0.01
			),
			Array.fill(60, { LFDNoise1.ar(1/5, 1) })
		)
	)
}.play
)

//5 - Deconstruct the following multichannel expansion into an array of signals separated by commas. Make a proper distribution of the different parameters for each signal:

//Given code:
(
{ var freqVariation, signal, freqs;

	freqVariation = SinOsc.ar(0.125, [0, 1pi], 0.5, 1);

	freqs = Array.geom(6, 100, 7/4) * freqVariation;

	signal = Mix(
		BPF.ar(
			BrownNoise.ar,
			freqs,
			0.05/freqs,
			[18, 24, 30].dbamp
		)
	)
}.play
)

//Possible solution:
(
{ var freqVariation, freqs, noise, amps, rq, signal;

	freqVariation = [SinOsc.ar(0.125, 0, 0.5, 1),
		SinOsc.ar(0.125, 1pi, 0.5, 1)];

	freqs = Array.geom(6, 100, 7/4) * freqVariation;

	noise = BrownNoise.ar;

	amps = [18, 24, 30].dbamp;

	rq = 0.05;

	signal = Mix(
		[
			BPF.ar(noise, freqs[0], rq/freqs[0], amps[0]),
			BPF.ar(noise, freqs[1], rq/freqs[1], amps[1]),
			BPF.ar(noise, freqs[2], rq/freqs[2], amps[2]),
			BPF.ar(noise, freqs[3], rq/freqs[3], amps[0]),
			BPF.ar(noise, freqs[4], rq/freqs[4], amps[1]),
			BPF.ar(noise, freqs[5], rq/freqs[5], amps[2])
		]
	);
}.play
)

//6 - Use a step low frequency noise generator as the gate of an adsr envelope. Then apply the envelope to a brownian noise generator:
(
{ var gate, env, signal;

	gate = LFDNoise0.ar(1, 1);

	env = EnvGen.ar(Env.adsr(0.1, 0.3, 0.3, 1, 0.8), gate);

	signal = BrownNoise.ar(0.2 !2);

	signal * env

}.play
)
