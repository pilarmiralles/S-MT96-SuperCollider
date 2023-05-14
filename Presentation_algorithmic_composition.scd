//Algorithmic composition: instrument-score and the algorithmic routine (crossfade, overlap, granular)
/////////////////////////////////////////////////////////////////////////////////////////////////////////

//INTRODUCTION (just in case) TO ITERATIONS AND ROUTINES (.do, Routine):
//There are many methods for iteration. Some of them can be found in the Collection help file --> Iteration paragraph: https://depts.washington.edu/dxscdoc/Help/Classes/Collection.html
//Iteration will eventually allow us to automatize the creation of multiple or successive instances (synths) of a SynthDef.

//METHOD .do:
//The method .do runs a function for each element of the collection to which the method is applied (it's receiver). The function passes two arguments: the item of the correction, and the iteration number (from 0 to the last index of the collection):

//Syntax:
[element1, element2, ...].do({ |item, iteration| function })

//Example using the item argument:
[10, 20, 30, 40, 50].do({ |num| rrand(0, num).postln }) //We need to print the results using .postln (otherwise, the only thing that will be printed is the receiver of .do).

//Example using the iteration argument:
(
a = [0, 10, 20, 30, 40, 50];

a[..4].do({ |num, i| rrand(a[i], a[i + 1]).postln }) //As in the former code, it prints five random values between the limits defined by the function.
)

//When receiving a single number (an integer), .do evaluates the function as many times as the number indicates, that is to say, it actually iterates from 0 up to such a number (thus, the receiver is equivalent to a collection of integers from 0 to the last index (that number): for this reason, the item argument and the iteration argument are equal, so we only use one argument in this case):
100.do({ rrand(1, 64).postln })

//Example: Brownian movement model:
(
a = 0; //Initial value.
100.do({ a = a + rrand(-1.0, 1.0); a.postln }) //In each iteration, the value of "a" is reassigned.
)


//ROUTINES:
//More on Routines (and an alternative called "Task") here: https://doc.sccode.org/Tutorials/Getting-Started/15-Sequencing-with-Routines-and-Tasks.html
//In order to automatize the iteration process of .do, we need a Routine:
//Difference between "eager" and "lazy" evaluation (function / routine):

//Function (eager): all instructions are run at once (in order). The postwindow only shows the result of the last line of the function:
(
f = {
	var result;

	result = 1 + 1;
	result = result * 1000;
	result = rrand(0, result);
	"hi"
}
)
f.value

//Routine (lazy): the class Routine allows the lazy evaluation of a function: each instruction is run when asked to:
(
r = Routine({

	1.yield; //The method .yield indicates each instruction or group of instructions to be evaluated at a time (= "last line of a function").

	15.yield;
})
)
r.next //The method .next asks the Routine to evaluate instructions up to each .yield (in order). When all instructions are evaluated, the Routine returns "nil".
r.reset //Reset allows us to come back to the beginning of the function, so that we can run it again directly by using .next.

//More complex example:
(
r = Routine({
	var synth1, synth2, synth3;

	"hello".postln; //Needs .postln because it is not the line of the .yield.
	synth1 = { SinOsc.ar(1000, 0, 0.05) }.play;
	"synth1 created".yield; //No need for .postln as this is the "last line of the function".

	synth2 = { BrownNoise.ar(0.1) }.play;
	"synth2 created".yield;

	synth3 = { Ringz.ar(Impulse.ar(1), 1500, 0.2, 0.1) }.play;
	"synth3 created".yield;

	synth1.release;
	"synth1 turned off".yield;

	synth2.release;
	"synth2 turned off".yield;

	synth3.release;
	"synth3 turned off".yield;

})
)
r.next
r.reset

//COMBINING .do AND ROUTINE
//Automatization of iteration processes:

//Without .do:
(
r = Routine({
	var options;

	options = [\green, \black, \white];

	//5.do({ opciones.choose.yield })
	options.choose.yield;
	options.choose.yield;
	options.choose.yield;
	options.choose.yield;
	options.choose.yield;
})
)
r.next

//Using .do:
(
r = Routine({
	var options;

	options = [\green, \black, \white];

	5.do({ options.choose.yield })
})
)
r.next

//Creating an infinite loop:
(
r = Routine({
	var options;

	options = [\green, \black, \white];

	inf.do({ options.choose.yield }) //inf as the receiver of .do: method .yield is essential not to make the interpreter crash.
})
)
r.next

//USING CLOCKS (the actual automatization):
//As this topic is quite heavy and I will just touch the surface, the following link might be useful to deepen in thiss: https://depts.washington.edu/dxscdoc/Help/Tutorials/Getting-Started/14-Scheduling-Events.html

//Until now, we had to evaluate .next every time we wanted an output from a Routine. In order to avoid that and actually automatize this evaluation, we need to let the Routine be controlled by a clock. We can do this by applying the method .play to the Routine:
(
r = Routine({

	inf.do({
		[\paper, \scissors, \rock].choose.postln;
		1.yield //The receiver of .yield is the time between each evaluation of the Routine (by default: 1 = 1 sec, or 1 beat at 60bpm).
	})
})
)
r.play

//Understanding clocks in SC:
r.clock //The clock of "r" is "a TempoClock" (the clock by default in SC, measured in beats according to a specific tempo, 60 bpm by default).
r.clock.tempo //The tempo of "r" is 1.
r.clock.tempo = 100/60 //We can ask "r" to change it's tempo to 100 bpm.
r.clock.tempo //Now the tempo of "r" has changed (try out the previous Routine and compare its pace).
r.clock.tempo = 1 //= 60/60 //Setting the tempo back to 60bpm (second as a referential time unit).
//By changing the "tempo" in this way, we are changing the default TempoClock of SC, so that all Routines would be subjected to this change.

//Independent clocks: in order to avoid changing the default clock, we can create our own independent clock for a specific Routine:
(
r = Routine({
	inf.do({
		[\paper, \scissors, \rock].choose.postln;
		1.yield //Number 1 is understood as one unit within the 180 bpm set below in the clock.
	})
});

z = Routine({
	inf.do({
		"hello".postln;
		1.yield
	})
});
)

( //Setting different clocks for each Routine by using the class TempoClock (the method .new is not necessary):
r.play(TempoClock(180/60)); //Three times faster than "z".
z.play(TempoClock(60/60))
)

//If we run the previous "r" routine (line 141), then we can check that its "tempo" hasn't been affected by these clocks.

TempoClock.tempo = 1 //Let's reset this for the rest of the session (just in case).


//First example of the instrument-score relationship (SynthDef-Routine): the automatized iteration process will consists of the successive creation of instances (synths) of a SynthDef:
(
SynthDef(
	\sawtooth,
	{ |freq|
		var signal;

		signal = Saw.ar(freq * [1, 1.1], 0.1)
		*
		EnvGen.ar(Env.sine(0.1), doneAction: 2);

		Out.ar(0, signal)
}).add
)

(
Routine({
	var overtones;

	overtones = 400 * (1..11);

	//Outer .do:
	inf.do({

		//First inner .do:
		([5, 7, 10, 3].choose).do({
			Synth(\sawtooth,
				[\freq, overtones.choose.postln]
			);
			0.1.wait;
		});

		//Second inner .do:
		4.do({
			{ SinOsc.ar(
				exprand(1000, 8000),
				0,
				0.05 !2
			) * EnvGen.ar(Env.sine(1), doneAction: 2)
			}.play;

			1.wait //When using .play wit Routines, it is common to use the method .wait instead of .yield (although they are equivalent).
		})
	})
}).play
)

/////////////////////////////////////////////////////////////

//CROSSFADE AND OVERLAP ROUTINES
//These are a couple of strategies in order to work with the SynthDef-Routine combo by creating continuous textures that can change over time:

//CROSSFADE ROUTINES:
//The idea is to create synths wit a time of fade-in and fade-out: when the fade-out of a synth is initiated, the fade-in of the next synth is triggered, bringing about a continuous cross-fade of synths (constant flow). Therefore, we need the fade-out time of a synth to be shared as fade-in time of the next (and this is the iteration process we need to program alongside the creation of synths):

//First example, simplest case: equal cross and sustain times:
(
SynthDef(
	\filters1,
	{ |freqs = #[0, 0, 0], crossTime, sustTime| //Sending an array of literals to an argument.
		var signal, env;

		signal = {
			Mix(
				BPF.ar(
					BrownNoise.ar,
					freqs,
					0.5/freqs,
					2
				)
			)
		} !2;

		env = EnvGen.ar(
			Env(
				[0, 1, 1, 0],
				[crossTime, sustTime, crossTime],
				\sine
			),
			doneAction: 2
		);

		Out.ar(0, signal * env)
}).add
)

(
Routine({
	var freqs;

	freqs = (100 * Array.series(30, 1));

	inf.do({
		Synth(\filters1, [
			\freqs, { freqs.choose } !3, //Array of three random frequencies.
			\crossTime, 3,
			\sustTime, 3,
		]);

		(3 + 3).wait
	})
}).play
)

//Second example: different cross and sustain times:
(
SynthDef(
	\filters2,
	{ |freqs = #[0, 0, 0], crossTime1, sustTime, crossTime2|
		var signal, env;

		signal = {
			Mix(
				BPF.ar(
					BrownNoise.ar,
					freqs,
					0.5/freqs,
					2
				)
			)
		} !2;

		env = EnvGen.ar(
			Env(
				[0, 1, 1, 0],
				[crossTime1, sustTime, crossTime2], //Different argument for fade-in and fade-out times.
				\sine
			),
			doneAction: 2
		);
		Out.ar(0, signal * env)
}).add
)

(
Routine({
	var freqs, crossTime1, sustTime, crossTime2;

	freqs = (100 * Array.series(30, 1));

	crossTime1 = rrand(1.0, 8); //Initial fade-in time.

	inf.do({

		sustTime = rrand(1.0, 8);
		crossTime2 = rrand(1.0, 8);

		Synth(\filters2, [
			\freqs, { freqs.choose } !3,
			\crossTime1, crossTime1,
			\sustTime, sustTime,
			\crossTime2, crossTime2
		]);

		[crossTime1, sustTime, crossTime2].round(0.1).postln; //For testing.

		(crossTime1 + sustTime).wait;

		crossTime1 = crossTime2;

	})
}).play
)

//More advanced example: construction of melodies:
(
SynthDef(
	\gendy3,
	{ |out = 0, freq = 24, gate = 1, amp = #[0, 0, 0, 0, 0], crossTime, sustTime|
		var signal, env, finalSignal, reverb;

		signal = Pan2.ar(
			Mix(
				Gendy3.ar( //I am still looking into this UGen lately, so don't worry about it (it is just something I am trying out).
					0, 0, SinOsc.kr(0.1, 0, 0.1, 0.9), 1.0,
					Array.geom(5, freq.midicps, 2) * Array.fill(5, { Rand(0.95, 1.05) }), //rrand can be used instead of Rand to maintain the same deviation value.
					0.011, 0.005, 12, 12, amp)
			),
			0.0);

		env = EnvGen.ar(
			Env(
				[0, 1, 1, 0],
				[crossTime, sustTime, crossTime],
				\sine
			),
			doneAction: 0 //DoneAction 0 in here, as doneAction 2 is applied in DetectSilence.
		);

		finalSignal = signal * env;

		reverb = FreeVerb.ar(finalSignal,  0.9, 1, 1);
		DetectSilence.ar(reverb, doneAction: 2); //This class allows us to kill the synth after the reverb is done, instead of killing it from the envelope, which would cause a sudden cut of the reverberation. It is useful for processes such as reverb or delays, which usually end a bit after the envelope of the synth has ended.

		Out.ar(out, reverb)
	}
).add
)

(
Routine({
	var sustTime, crossTime, freqs;

	sustTime = Pn(Pstutter(3, Pshuf([1, 1, 2, 2, 4], 1)), inf).asStream; //As we haven't talked about patterns yet, you just need to know that this creates a sequence of sustTime values (a "stream") called from .do by using the method .next.
	crossTime = 0.7;

	freqs = [19, 21, 22, 24, 26, 27, 29, 31]; //Minor scale from G.

	inf.do({ var thisSustTime;

		thisSustTime = sustTime.next;

		Synth(\gendy3,
			[
				\freq, freqs.choose,
				\crossTime, crossTime,
				\sustTime, thisSustTime,
				\out, 0,
				\amp, [0.3, 0.2, 0.2, 0.6, 0.4] * 0.2,
			]
		);

		(crossTime + thisSustTime).wait;

	})
}).play
)

//OVERLAP ROUTINES:
//The idea is to create several synths at the same time, being this number of synths controlled by us through an argument "density". The synths will replace each other continuously in the server: for this, we need the waiting time to be equal to the entire duration of each synth divided by the number of synths (density).

//First example:
(
SynthDef(
	\overlapFilter,
	{ |freq, crossTime = 5, sustTime = 5, density = 5|
		var signal, env, individualAmp;

		individualAmp = ((density.log2 + 1) * -3.01).dbamp * 0.5; //Amplitude balance based on the number of synths at the same time (applied to the levels of the envelope to lower the amplitude accordingly).

		signal = BPF.ar(
			BrownNoise.ar(1 !2),
			freq,
			0.5/freq,
			10
		);

		env = EnvGen.ar(
			Env(
				[0, 1, 1, 0] * individualAmp,
				[crossTime, sustTime, crossTime],
				\sine
			),
			doneAction: 2
		);

		Out.ar(0, signal * env)
}).add
)

( //Open the node tree when evaluating the Routine to observe how the synth appear and replace each other at a regular pace of (crossTime + sustTime + crossTime) / density (in this case, every 3 seconds), and keeping a constant flow of 5 synths at the same time:
Routine({
	var density, crossTime, sustTime, freqs;

	density = 5;

	crossTime = 5;
	sustTime = 5;

	freqs = Array.geom(10, 100, 3/2);

	inf.do({
		Synth(\overlapFilter,
			[
				\freq, freqs.choose,
				\crossTime, crossTime,
				\sustTime, sustTime,
				\density, density,
		]);
		((crossTime + sustTime + crossTime) / density).wait
	})
}).play
)

//Glissando effect (using the same SynthDef): try out the four possible combinations:
(
Routine({
	var density, crossTime, sustTime, freqs, line;

	density = 100;
	crossTime = 2;
	sustTime = 2;

	freqs = Array.geom(200, 35, 0.5.midiratio);
	line = Env([0, freqs.lastIndex], 6).asStream; //[freqs.lastIndex, 0] downward opetion.

	inf.do({
		Synth(\overlapFilter,
			[
				\freq, freqs[line.next.asInt.postln..].choose, //[..line.next.asInt.postln] opposite option.
				\crossTime, crossTime,
				\sustTime, sustTime,
				\density, density,
		]);
		((crossTime + sustTime + crossTime) / density).wait
	})
}).play
)

//Last example: more continuous texture:
(
SynthDef(
	\machinesComb,
	{ |transitionTime, sustainTime, density, out = 0, rq = 0.01, mulNoise = 0.1, mul = 0.1, freqPulse = 80, freq, combFreq = 30, decayTime = 1, mulComb = 0.4|
		var individualAmp, signal, comb, signalOut, env;

		individualAmp = ((density.log2 + 1) * -3.01).dbamp;

		signal = BPF.ar(
			Pulse.ar(freqPulse, PinkNoise.ar(mulNoise !2), 0.2),
			freq,
			rq,
			mul
		);

		comb = CombC.ar(signal, 1/combFreq, 1/combFreq, decayTime, mulComb);

		signalOut = signal + comb;

		env = EnvGen.ar(
			Env(
				[0, 1, 1, 0] * individualAmp,
				[transitionTime, sustainTime, transitionTime],
				\sine
			),
			doneAction: 2
		);

		Out.ar(out, signalOut * env)
}).add
)

//All synthesis process separated:
(
{
	BPF.ar(
		Pulse.ar(30, PinkNoise.ar(1 !2), 0.2),
		560,
		0.02,
		10
	)
}.play
)

(
{ var signal;

	signal = BPF.ar(
		Pulse.ar(30, PinkNoise.ar(1 !2), 0.2),
		560,
		0.02,
		10
	);

	CombC.ar(signal, 1/40, 1/40, 1.5, 0.2); //Resonator.
}.play
)

(
{ var signal, comb;

	signal = BPF.ar(
		Pulse.ar(30, PinkNoise.ar(1 !2), 0.2),
		560,
		0.02,
		10
	);

	comb = CombC.ar(signal, 1/40, 1/40, 1.5, 0.2);

	(signal + comb) * 0.5
}.play
)

//Routine:
(
Tdef(\underTheSea, {
	var density, transitionTime, sustainTime, root, freqs;

	density = 50;

	transitionTime = rrand(1, 3.5);
	sustainTime = rrand(1, 3.5);

	freqs = Array.fill(100, { exprand(60, 2500) });

	inf.do({

		/* Tonal version:
		root = [19, 21, 22, 24, 26, 27, 29, 31].midicps.choose;

		freqs = Array.geom(6, root, 2);
		*/

		Synth(\machinesComb,
			[
				\freq, freqs.choose,
				\transitionTime, transitionTime,
				\sustainTime, sustainTime,
				\density, density,
				\out, 0,
				\rq, 0.02,
				\mulNoise, 1,
				\mul, 10,
				\freqPulse, 30,
				\combFreq, 40,
				\decayTime, 1.5,
				\mulComb, 0.2
		]);
		((transitionTime + sustainTime + transitionTime) / density).wait
	})
}).play
)

//No sound example of Tdef (try out adding or deleting characters in the string, changing the wait time, etc.):
(
Tdef(\tdef, {

	inf.do({
		"hello".scramble.postln;
		1.wait;
	})
}).play
)

//Sound example of Tdef (try out different values for the freq of SinOsc, duration of the envelope, wait time, etc.):
(
Tdef(\tdef, {

	inf.do({
		{ SinOsc.ar(1040) !2 * EnvGen.ar(Env.sine(0.25), doneAction: 2) * 0.1 }.play;
		0.3.wait;
	})
}).play
)

/////////////////////////////////////////////////////////////

//"FAKE GRANULAR" SYNTHESIS (work with buffers)
//The idea is to implement the SynthDef-Routine combo while using audio samples as input instead of audio synthesis processes. The audio samples are cut into pieces and different parameters are randomized in order to create different textures that can change over time. I call this strategy "fake granular" because I usually cut the audio samples into chunks that are bigger than the "conventional" size of a grain in granular synthesis. Nonetheless, this model of granulator can be used for conventional granular synthesis as well.

//Building a granulator:
p = Platform.resourceDir +/+ "sounds/a11wlk01.wav" //Default audio sample from SC.

b = Buffer.read(s, p) //Allocating the buffer and reading the sample into it.
b.query //Information about the buffer "b".
b.duration //Duration of the buffer ( = numFrames / sampleRate).

(
SynthDef(
	\grain,
	{ |bufnum, position, rate, dur, pan, amp = 0.1|
		var signal, env;

		signal = PlayBuf.ar(1, bufnum, rate, 1, position);
		//signal = signal[0];
		signal = Pan2.ar(signal, pan);

		env = EnvGen.ar(
			Env.sine(dur, amp),
			doneAction: 2
		);

		OffsetOut.ar(0, signal * env)

}).add
)

Synth(\grain, [\bufnum, b.bufnum, \position, 2 * 44100, \rate, 1, \dur, 0.1, \pan, 0]) //Isolated grain.

(
Routine({
	var durBuffer, durGrain, position, rate = 1;

	durBuffer = b.duration;

	inf.do({

		durGrain = rrand(0.0, durBuffer);
		//durGrain = rrand(0.01, 0.2); //Alternative for the durGrain (short grains).

		position = rrand(0, durBuffer - durGrain) * 44100;

		s.bind({
			Synth(
				\grain,
				[
					\bufnum, b.bufnum,
					\position, position,
					\rate, rate, //rrand(0.5, 2) / rrand(1.midiratio, 7.midiratio).
					\dur, durGrain,
					\pan, rrand(-1.0, 1.0),
					\amp, 0.1
			]);
		});
		//0.1.wait //"Synchronous granular synthesis".
		rrand(0.01, 0.1).wait //"Asynchronous granular synthesis".
	});
}).play
)

//Another example (same SynthDef):
(
c = Buffer.read(s, "F:/DOCUMENTOS/1 Year 2022-2023/SUPERCOLLIDER/S-MT96-SuperCollider/Algorithmic composition presentation/Audio-for-granular-examples-1.wav");
d = Buffer.read(s, "F:/DOCUMENTOS/1 Year 2022-2023/SUPERCOLLIDER/S-MT96-SuperCollider/Algorithmic composition presentation/Audio-for-granular-examples-2.wav")
)

(
SynthDef(
	\grain2,
	{ |out = 0, bufnum, position, rate, dur, pan, amp = 0.1|
		var signal, env;

		signal = PlayBuf.ar(2, bufnum, rate, 1, position);
		signal = signal[0];
		signal = Pan2.ar(signal, pan);

		env = EnvGen.ar(
			Env.sine(dur, amp),
			doneAction: 2
		);

		OffsetOut.ar(out, signal * env)

}).add;
/*
SynthDef(
	\reverb,
	{ |in, room, rev, mul|
	 var input, signal;

		input = In.ar(in, 2);
		signal = GVerb2.ar(input, room, rev, mul: mul);
		OffsetOut.ar(0, signal)
}).add
*/
)

(
Routine({
	var buffer, durBuffer, durGrain, position, rate = 1, superposition;

	position = 0;

	//Synth(\reverb, [\in, 4, \room, 15, \rev, 3, \mul, 0.2], s, 'addToTail'); //Info on order of execution here: https://doc.sccode.org/Guides/Order-of-execution.html

	inf.do({

		buffer = [c, d].choose;

		durBuffer = buffer.duration;
		durGrain = rrand(0.5, 2.5);
		superposition = 3;

		s.bind({
			Synth(
				\grain2,
				[
					\bufnum, buffer.bufnum,
					\position, position * 44100,
					\rate, (0.9, 0.95..1.1).wchoose((0.9, 0.95..1.1).normalizeSum),
					\dur, durGrain,
					//\pan, rrand(-0.8, 0.8),
					\pan, 0, //I like it better with no random pos when no reverb.
					\amp, 0.5,
					\out, 0 //reverb = 4, no reverb = 0.

			],
				s, 'addToHead'
			);
		});
		position = (position + 1) % durBuffer;
		//position = (position + durGrain) % durBuffer;

		(durGrain / superposition).wait
		//durGrain.wait
	});
}).play
)

/////////////////////////////////////////////////////////////

//EXAMPLES OF CODES USED IN ACTUAL PIECES
//These two combos os SynthDef-Routine and some of the audio samples used for them are based on the processes we have been talking about. I thought it would be interesting to show some blocks of code whose output was directly used in a composition. Both of them are actually based on the "fake granular" model. The actual key of these codes is the pattern they use. We haven't study the patterns yet, but you just need to know that they create a sequence of values (a stream) that can be asked one by one later on using the method .next.

//THE WORN-OUT FACTORY
(
b = Buffer.read(s, "F:/DOCUMENTOS/1 Year 2022-2023/SUPERCOLLIDER/S-MT96-SuperCollider/Algorithmic composition presentation/Pum.wav");
c = Buffer.read(s, "F:/DOCUMENTOS/1 Year 2022-2023/SUPERCOLLIDER/S-MT96-SuperCollider/Algorithmic composition presentation/Tras.wav");
d = Buffer.read(s, "F:/DOCUMENTOS/1 Year 2022-2023/SUPERCOLLIDER/S-MT96-SuperCollider/Algorithmic composition presentation/Warn.wav")
)

(
SynthDef(
	\grainFactory,
	{ |out = 4, bufnum, position, speed, dur, amp = 0.5, pan = 0|
		var signal, env;

		signal = PlayBuf.ar(2, bufnum, speed, 1, position);
		signal = signal[0];

		env = EnvGen.ar(
			Env.sine(dur, amp),
			doneAction: 2
		);

		OffsetOut.ar(out, Pan2.ar(signal * env, pan))
}).add;
SynthDef(
	\processing,
	{ |in, freq = 1000, amp = 0.1, mix = 0.5, room = 0.5|
		var input, signal, signalOut;

		input = In.ar(in, 2);

		signal = LPF.ar(
			input,
			freq,
			amp
		);

		signalOut = FreeVerb.ar(signal, mix, room, 0.7);

		OffsetOut.ar(0, signalOut)

}).add
)

(
Routine({
	var buffer, durBuffer, durGrain = 2, position, speedMin, speedMax;

	Synth(\processing, [\in, 4, \mix, 0.7, \room, 1, \freq, 3000, \amp, 0.7], s, \addToTail);

	position = 0;

	durGrain = Pseg([3.0, 0.01], [60, 10], \lin, inf).asStream;

	speedMin = Pseg([0.125, 2.5], [40, 20], \lin, inf).asStream;
	speedMax = Pseg([0.5, 6.0], [40, 20], \lin, inf).asStream;

	inf.do({

		buffer = [b, c, d].wchoose([2, 2, 7].normalizeSum);

		durBuffer = buffer.duration;
		position = (rrand(0.0, durBuffer - durGrain));

		s.bind({
			Synth(
				\grainFactory,
				[
					\bufnum, buffer.bufnum,
					\position, position * 44100,
					\speed, rrand(speedMin.next, speedMax.next),
					\dur, durGrain.next,
					\amp, 0.5,
					\out, 4,
					\pan, rrand(-1.0, 1.0)

			]);

		});

		rrand(0.05, 0.1).wait

	});
}).play
)


//CARESSING YOU TILL MY FINGERS BLEED
(
c = Buffer.read(s, "F:/DOCUMENTOS/1 Year 2022-2023/SUPERCOLLIDER/S-MT96-SuperCollider/Algorithmic composition presentation/High-synthetic-sounds.wav");
d = Buffer.read(s, "F:/DOCUMENTOS/1 Year 2022-2023/SUPERCOLLIDER/S-MT96-SuperCollider/Algorithmic composition presentation/Low-comb-sound.wav")
)

(
SynthDef(
    \grainCaress,
    { |out, bufnum, position, speed, dur, amp = 0.1, pan = 0|
        var signal, env;

        signal = PlayBuf.ar(2, bufnum, speed, 1, position, 1);
        signal = signal[0];

        env = EnvGen.ar(Env.sine(dur, amp), doneAction: 2);
        signal = Pan2.ar(signal * env, pan);

        OffsetOut.ar(out, signal)

}).add;
SynthDef(
    \reverb,
    { |out = 0, in, time|
        var input, dry, wet, signalOut;

        input = In.ar(in, 2);

        dry = input;

        wet = Mix({
            CombC.ar(
                dry,
                0.035,
                rrand(0.025, 0.035),
                time,
                rrand(0.25, 0.5)
            )
        } !12
        );

        wet = LeakDC.ar(wet);

        4.do({ wet = AllpassN.ar(wet, 0.05, { rrand(0.005, 0.05) } !2, time) });

        signalOut = dry + LPF.ar(wet, 3000);

        OffsetOut.ar(out, signalOut)

}).add
)

(
Routine({
    var durBuffer, durGrain, position = 0, speed, waitTime, superposition, bufferPattern, buffer, speedPattern;

    Synth(\reverb, [\in, 4, \time, 3], s, \addToTail);

    superposition = 3;

    speedPattern = Pn(
        Plazy({
            var array;

            array = Array.series(
                rrand(5, 12),
                0.5,
                rrand(0.1, 0.5)
            );
            Pseq(array.mirror)
        }),
        inf
    ).asStream;

    bufferPattern = Pwrand([c, d], [2, 5].normalizeSum, inf).asStream;

    inf.do({ |i|

        if (i == 0, { buffer = d }, { buffer = bufferPattern.next });

        durBuffer = buffer.duration;

        waitTime = rrand(0.5, 3);
        durGrain = waitTime * superposition;

        speed = speedPattern.next;
		speed.round(0.1).postln; //For testing.

        position = (position + waitTime) % durBuffer;

        s.bind({
            Synth(\grainCaress,
                [
                    \bufnum, buffer.bufnum,
                    \dur, durGrain,
                    \speed, speed,
                    \position, position * 44100,
                    \amp, 0.2,
                    \out, 4
                ],
                s, \addToHead
            )
        });
        (waitTime * rrand(0.975, 1.025)).wait;
    });
}).play
)

/////////////////////////////////////////////////////////////

//ALGORITHMIC COMPOSITION TOOLS: BOOLEANS AND PATTERNS
//Some other tools that might be useful in these kind of algoritmic systems are booleans, control structures and patterns.

//BOOLEAN EXPRESSIONS
//Boolean expressions return the literals "true" or "false". Therefore, they are useful for making an operation or process depend on something (such as a "condition"):

4 == 5 //Equal to
4 != 5 //Different from
4 > 5 //Higher than
4 <= 5 //Lower or equal to
4.odd //Is an odd number
4.even //Is an even number
x.isNil //Is empty
0.6.coin //Returns true or false depending on the given probability (from 0 to 1)
(2 > 1).and(2.odd) //Both conditions need to be met to return true
(2 > 1).or(2.odd) //At least one of the conditions need to be met to return true

//Control structures: control structures are normally based on boolean expressions (in order to express conditions, for example). Control structures are tools that choose directions in which to go or output to be returned based on given parameters and conditions. Some of these control structures are explained here: https://doc.sccode.org/Reference/Control-Structures.html

//"If", three syntaxes: if the boolean expression returns true, the first function is evaluated, and if not, the second function is evaluated:

if (1 > 2, { "true".postln }, { "false".postln }) //The one I normally use.

(0.7.coin).if({ "true".postln }, { "false".postln })

if(3.odd) { "true".postln } { "false".postln } //The one recommended by the style guide.

//If applied to a Routine with .do (using the "i" argument of .do):
if ((i % 3) == 0, { function1 }, { function2 }) //Something happens every three iterations.
if (i.asInteger.even, { function1 }, { function2 }) //Alternating between two options.
if (0.5.coin.and(i != 0), { function1 }, { function2 }) //Avoiding applying condition to the first iteration.

//"While": it only executes the second function if the first function returns true (and re-evaluates again as far as it returns true, so it is a conditional loop):
(
while(
    { var value;

        value = (1..10).choose.postln;
        (value == 2).or(value == 5);

    },
    { "success".postln }
)
)

//"Switch": given an initial operation, and some pairs of result-function, it evaluate a different function according to the result of the operation each time. There is an "else case" at the end of the pairs:
(
var value;

value = rrand(0, 20);

switch
(value % 4)
{ 0 } { "zero" }
{ 1 } { "one" }
{ 2 } { "two" }
{ "error" } //When the result is 3, for instance.
)

//"Case": similar to switch, but not based on a common initial operation or condition: each pair features its own input condition and output function. I think that, if two of the cases are met with the same value, the first one in order is the one returned:

(
var value;

value = rrand(1, 10);

case
{ value == 2 } { "two" }
{ (value % 3) == 0 } { "module" }
{ value.odd } { "odd" }
{ value >= 7 } { "high" }
{ "error" }
)

//"Select": it creates a collection consisting of all items from the receiver for which the function returns true. The function passes two arguments, the item and the index:
[1, 2, 3, 4].select({ |item, i| item.even });


//PATTERNS
//I really recommend the "practical guide" for patterns in SC Help files: https://doc.sccode.org/Tutorials/A-Practical-Guide/PG_01_Introduction.html
//Patterns are one of the most powerful features of SC, but they can be difficult to approach and sometimes their specific Help file doesn't help. Patterns define calculations or tasks to fulfill and normally suppose a shortcut to those operations. Thus, they are quite efficient to use whenever they suit for the specific calculation that is needed.
//We normally use patterns to create sequences or "streams" of values (often numbers, although they may even stream synths or any kind of object). When used as streams, we apply to them the method .asStream, and later on, we call them to return one value at a time using the method .next. There are over 120 patterns in SC, so we will just mention some of the most usual ones (you might look into the guide to find other patterns to suit your own needs):

//In order to test the patterns with sound, we will be using this very simple SynthDef:
(
SynthDef(
	\sine,
	{ |freq = 440, amp = 0.1, durEnv = 1, pan = 0|
		var signal, env;

		signal = SinOsc.ar(freq, 0, amp);
		env = EnvGen.ar(Env.perc(0.005, durEnv, 0.2), doneAction: 2);
		signal = Pan2.ar(signal * env, pan);

		Out.ar(0, signal)

}).add
)

//PSEQ: reads an array of values as many times as indicated in "repeats", and from the index of the array specified in "offset".
//Example with numbers:
(
var stream;

stream = Pseq([0, 1, 2, 3, 4], 1).asStream; //Try out 2 in the number of repeats.

15.do({ stream.next.postln }) //The rest of the values will be filled up with "nil".
)

//Example with sound:
(
var pitches;

pitches = Pseq([60, 63, 67, 70, 72], inf).asStream;

Routine({
	inf.do({

		Synth(\sine, [\freq, pitches.next.postln.midicps]);
		(1/8).wait
	})
}).play
)

//Operations with patterns: example with sound: they work as the operations between arrays of different size (the smaller array wraps):
(
var pitches, durations;

pitches = (
	Pseq([60, 63, 67, 70, 72], inf)
	+
	Pseq([0, 0, 12], inf) //The octave is going to be raised every three pitches.
).asStream;

durations = Pseq([0.25, 0.5, 0.25], inf).asStream; //Pseq also applied to durations.

Routine({
	inf.do({

		Synth(\sine, [\freq, pitches.next.postln.midicps]);
		durations.next.wait
	})
}).play
)

//Embedded (nested) patterns: example with sound (the method .asStream is only applied to the outer pattern):
(
var pitches, durations;

pitches = (
	Pseq([ Pseq([60, 63], 3), 67, 70, Pseq([73, 72], 5)], inf) //Two Pseq are used to shorten an array featuring repetitions. This would be the array without inner patterns: [60, 63, 60, 63, 60, 63, 67, 70, 73, 72, 73, 72, 73, 72, 73, 72, 73, 72]
	+
	Pseq([0, 0, 12], inf)
).asStream;

durations = (1/8); //Stable durations now so we can focus on the pattern of pitches.

Routine({
	inf.do({

		Synth(\sine, [\freq, pitches.next.postln.midicps]);
		durations.next.wait
	})
}).play
)

//PRAND: returns a number of random values from a collection according to "repeats".
//Example with numbers:
(
var stream;

stream = Prand([0, 1, 2, 3, 4], 5).asStream;

15.do({ stream.next.postln })
)

//Example with sound:
(
var pitches, durations;

pitches =  Pseq( //Nested pattern (alternation between the two Prand):
	[
		Prand((72..77), 10),
		Prand((72..77) + 12, { rrand(1, 3) }) //Random number of repeats (rrand needs the curly brackets to be refreshed each time).
	],
	inf).asStream;

durations = Prand([0.1, Pseq(Array.geom(8, 0.1, 1.5).mirror)], inf).asStream; //Random duration between 0.1 and a Pseq with a mirrored Array.geom (deccel-accel).

Routine({
	inf.do({

		Synth(\sine, [\freq, pitches.next.postln.midicps]);
		durations.next.wait
	})
}).play
)

//There is also Pxrand, which is a Prand which never repeats the same value twice in a row:
(
var stream;

stream = Pxrand([0, 1, 2, 3, 4], 15).asStream;

15.do({ stream.next.postln })
)

//PWRAND: similar to Prand, but including a list of weights (a list of probabilities which should sum 1.0, or alternatively, by applied the method .normalizeSum):
//Example with numbers:
(
var stream;

stream = Pwrand([0, 1, 2], [0.5, 0.375, 0.125], 15).asStream;

15.do({ stream.next.postln })
)

//Example with sound:
(
var pitches, durations;

pitches = Pwrand( //A list of four possible arpeggios (of dominant seventh, separated by minor thirds):
	[
		Pseq(60 + [0, 4, 7, 10], 1),
		Pseq(63 + [0, 4, 7, 10], 1),
		Pseq(66 + [0, 4, 7, 10], 1),
		Pseq(69 + [0, 4, 7, 10], 1),
	],
	[1, 2, 3, 4].normalizeSum, //Probability for each arpeggio.
	inf
).asStream;

durations = 1/8;

Routine({
	inf.do({

		Synth(\sine, [\freq, pitches.next.postln.midicps]);
		durations.wait
	})
}).play
)

//PSHUF: scrambles randomly the elements of a list and read the list as many times as indicated in "repeats":
//Example with numbers:
(
var stream;

stream = Pshuf([0, 1, 2, 3, 4, 5], 2).asStream; //The random order remains the same in both repetitions of the list.s

15.do({ stream.next.postln })
)

//Example with sound:
(
var pitches, durations;

pitches =  Pshuf([60, 62, 64, 65, 67, 69, 71], inf).asStream; //Fixed order once the list is scrambled.

durations = 1/8;

Routine({
	inf.do({

		Synth(\sine, [\freq, pitches.next.postln.midicps]);
		durations.wait
	})
}).play
)

//PN: in order to, for example, refresh Pshuf to obtain different orders of its list, we can use Pn. Pn simply runs a pattern as many times as indicated in "repeats":
//Example with numbers:
(
var stream;

stream = Pn(Pseq([ 0, 1, 2, 4, 5 ], 1), 2).asStream; //Simply repeating twice the list of Pseq, which according to its arguments, only reads the list once.

15.do({ stream.next.postln })
)

//Example with sound:
(
var pitches, durations;

pitches = Pn(Pshuf(Array.series(7, 72, 0.5), { rrand(1, 4).postln }), inf).asStream; //The order chosen by Pshuf is refreshed after 1 to 4 repetitions (being this number randomly chosen). The pitches are a quarter-tone appart (0.5 MIDI).

durations = 1/8;

Routine({
	inf.do({

		Synth(\sine, [\freq, pitches.next.postln.midicps]);
		durations.wait
	})
}).play
)

//PLAZY: runs a function that returns (as its last line) another pattern. That means that Plazy allows us to "customize" the pattern it returns. It is usually used in combination with Pn, so that the function can be evaluated as many times as needed and its possible randomness is refreshed, returning different results:
//Example with numbers:
(
var stream;

stream = Pn(
    Plazy({
        var size;

        size = rrand(1, 12);

		Pseq(Array.series(size, 0, 1)) //The size of the array in Pseq is randomized within Plazy's function.
    }),
    inf
).asStream;

50.do({ stream.next.postln })
)

//Example with sound:
(
var durations, thisDur, newArray, pan;

//Pattern for the duration:
durations = Pn(
    Plazy({
        newArray = Array.geom(
            rrand(1, 29), //Random size.
            0.01,
            rrand(1.0, 1.15) //Random grow. Other ranges to try: 1.2 - 1.25.
        );

        Pseq(newArray.mirror) //The randomized geometric series is mirrored.
    }),
    inf
).asStream;

pan = Pseq([-1, 1], inf).asStream; //The pattern for pan alternates between -1 and 1.

Routine({
    inf.do({
        thisDur = durations.next;

        Synth(
            \sine,
            [
                \freq, 4000,
                \durEnv, thisDur,
				\pan, (pan.next * (thisDur/newArray.last)).postln, //The position of the panner depends on the duration: (current duration value / last value of the current array of durations) --> The longer the duration, the closer the division is equal to 1, and the shorter the duration, the closer the division is to 0. Then, multiplied by -1 or 1 from the pan, the longer the duration, the more extreme the position of the panner, and the shorter the duration, the closer to the center the position is (and, thanks to the Pseq in pan, the position will always alternate from left to right).
                \amp, 0.1
            ]
        );
        (thisDur * 2).wait
    })
}).play
)

//PATTERNS FOR RANDOM DISTRIBUTIONS

//Uniform distribution (Pwhite): all values feature the same probability. Arguments are low and high limits, and number of values to be created (it is different from Pwhite as it chooses values from a range, instead of from a list). If both inputs are integers, all outputs will be integers, but if at least one input is float, all outputs will be floats:
(
var stream;

stream = Pwhite(0, 100.0, 10).asStream;

15.do({ stream.next.postln })
)

//Exponential distribution (Pexprand): lower values are more likely to be chosen. Arguments are low and high limits and number of values to be created. All outputs will be floats no matter what inputs the pattern receives. Also the range should not touch nor cross zero:
(
var stream;

stream = Pexprand(1, 100, 10).asStream;

15.do({ stream.next.postln })
)

//Normal or Gaussian distribution (Pgauss): values closer to the "mean" value are more likely to be chosen. The deviation argument refers to the "width" of the Gaussian bell: the higher the deviation, the more probable extreme values will be. It outputs floats as well:
(
var stream;

stream = Pgauss(50, 10, 10).asStream;

15.do({ stream.next.postln })
)

//Brownian motion (Pbrown): its arguments are low and high limits, the step and the number of values to be created. The step represents the maximum deviation from one value to the next (either + or -). It outputs floats whenever any of its arguments is a float (except for the length argument). If going beyond the low or high limits, the values fold (are added instead of subtracted and vice-versa):
(
var stream;

stream = Pbrown(0, 10, 1, 10).asStream;

15.do({ stream.next.postln })
)

//Brownian motion model:
a = 1 //Initial value.
a = (a + rrand(-1.0, 1.0)).fold(0.0, 10.0) //If going above 10, it folds (same if going below 0).

//PSEG: creates envelopes of values. Its arguments are a list of levels, a list of durations, a list of curves and the number of repetitions:
//We are going to use this simple sawtooth SynthDef to illustrate one possible use of Pseg: it consists of creating parallel envelopes applied as low and high limits of random choices for a parameter. In this example, the frequency is chosen randomly among the values of a range controlled by two Psegs. In this case, the two envelopes are synchronized, but they don't have to. Pseg is different from an envelope because it actually includes a time value for coming back to the first level value (although in this example, I am using 0, so it actually jumps towards the first value):
(
SynthDef(
	\saw,
	{ |freq|
		var signal;

		signal = Saw.ar(freq, 0.2) * EnvGen.ar(Env.sine(0.3, 0.05), doneAction: 2);

		OffsetOut.ar(0, signal !2)

}).add
)

(
var lineA, lineB;

lineA = Pseg( //Bottom line.
	Pseq([85, 100, 10], inf), //Values
	Pseq([10, 10, 0], inf), //Times
);
lineB = Pseg( //Top line.
	Pseq([90, 100, 70], inf),
	Pseq([10, 10, 0], inf),
);

//We haven't mentioned Pbind yet, but it does not matter: just think of it as a Routine shortcut:
Pbind(
	\instrument, \saw,
	\midinote, Pwhite(lineA, lineB),
	\dur, 0.015
).play
)

//PSWITCH1: Pswitch receives a list of values or patterns (or both) and a "which" argument, which refers to the index of the elements of that list. Pswitch1 is different from Pswitch: if Pswitch receives a pattern, the entire output of the pattern is returned when asking for its index, whereas in Pswitch1, only one element of the pattern's output is returned each time:
(
a = Pswitch1([
	100,
	Pseq([74, 76, 77, 79, 80, 90, 75, 73, 72, 70, 68, 67, 65, 66, 64, 65, 63, 61, 60], inf)
],

//Using a Pseq as "which" argument in Pswitch1: the output list should be [0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1...] and so forth:
Pseq([0, Pn(1, Pseries(1).asStream)], inf) //Exception for applying .asStream only to the outer pattern in nested patterns (only way it works).
).asStream
)

a.next

//PLACE: Place takes one value from each item in the main array in succession (the smaller arrays wrap):
l = Place([0, [1, 2], [3, 4, 5]], inf).asStream
l.next

//PPATLACE: Ppatlace takes one value from each subpattern in succession:
(
t = Ppatlace(
	[
		Pseries(0, 1, inf),  //start, step, size (there is also Pgeom, for the creation of a geometric series).
		Pseries(2, 1, inf)
	], inf
).asStream
)

t.next
