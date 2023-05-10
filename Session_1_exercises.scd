//SESSION 1 - EXERCISES

/////////////////////////////////////////////////////////
//ARRAYS AND METHODS, BASIC TASKS:

//1 - Write an array of 11 elements of different type (heterogeneous) and assign the array to a variable "a":


//2 - Assign to the variable "b" the second element of "a":


//3 - Assign the first element of "a" to the variable "b":


//4 - Assign to the variable "c" an array containing 24 random values between the range 1 to 12:


//5 - Assign to the variable "d" an array containing an arithmetic series of 31 numbers, starting by 1000 and going up by steps of 111:


//6 - Rotate the former series three slots to the right and reassign the value to "d":


//7 - Reassign to "d" the retrograded "d":


//8 - Assign to "d" the elements of "d", but changing the order randomly:


//9 - Assign to "e" a geometric series of 16 elements, starting by 33 and with a growing factor of 1.5 (series of Pitagoric fifths):


//10 - Apply to "e" the method .plot and observe:


//11 - Assign to "f" an arithmetic series of 16 numbers. The two first numbers of the series must be 24 and 31:


//12 - Assign to "f" the mirror of "f". Then, apply a plotter to the result:


//13 - Apply the method .plot to "f", obtaining a discontinuous line in the graph:


//14 - Change the order of the elements in "f" randomly and apply a plotter to its values, obtaining a continuous and a discontinuous line in the graph:


//15 - Create an array of 101 random elements chosen from the elements of an array of the numbers 1 to 5. Each element should have a different probability of been chosen:


/////////////////////////////////////////////////////////
//FUNCTIONS, BASIC TASKS:

//1 - Create a function that calculates the hypotenuse of a triangle applying the Pythagorean theorem:

//2 - Create a function in which the frequency in Hz and MIDI value of the overtone number (n) of a given fundamental frequency are calculated:

//3 - Create a function that checks whether a word (string of letters) is a palindrome or not:

//4 - Given an array of integers, create a function that returns the array from the middle value to the last element (if there are two middle values, that is to say, if the size of the array is even, take the second middle value onward. For this last step, a boolean expression is needed. If there is no knowledge of booleans yet, build the function for odd-sized arrays only, that is to say, disregarding that second instruction):

//ADVANCED EXERCISE: Symmetric difference algorithm. Create a function that compares two arrays of numbers and gives back an array with all numbers that are present only in one of the arrays (for instance, comparing [1, 2, 3, 4] and [2, 3, 4, 5], the result should be [1, 5]):


/////////////////////////////////////////////////////////
//SIGNALS, BASIC TASKS:

//1 - Modulate the frequency of a sine oscillator from 65 to 3961 Hz using another sine oscillator. The period of the modulating signal should be 11 seconds. Adjust the phase so that the modulation starts at 3961 Hz:

//2 - Create a sawtooth oscillator with frequency equal to 1000 Hz. Use a bandpass filter to filter the sawtooth oscillator and stablish a narrow bandwidth. Use a low frequency noise generator with cubic interpolation to slowly modulate the cutoff frequency of the filter. Use the mul / add arguments of the modulating signal so that the modulation moves between the 1st and 11th overtones of the sawtooth oscillator:

//3 - Create a random impulse generator (Dust) with a density equal to 3 and filter the signal using 60 Ringz filters. Use exponential distributions to randomize the frequency and decay time of each filter. Then mix the 60 signals into a single channel:

//4 - From the former code: add an independent stereo panoramization for each filter and carry out a slow modulation of the position of each filter using a linear low frequency noise generator. Then mix the 60 signals into a two-channel signal:

//5 - Deconstruct the following multichannel expansion into an array of signals separated by commas. Make a proper distribution of the different parameters for each signal:
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

//6 - Use a step low frequency noise generator as the gate of an adsr envelope. Then apply the envelope to a brownian noise generator:
