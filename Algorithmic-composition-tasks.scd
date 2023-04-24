/*
Combine the use of patterns within a Routine (patterns generate values / Routine asks for values to patterns and creates synths) following these instructions:
- Use the following SynthDef \sinePerc.
- Use the following array of MIDI notes: [ 7, 7, 9, 7, 9, 11, 9, 7, 6, 4, 2 ] + 72.
- Use the following array of durations: [1, 1, 1/8, 1/8, 1/2, 1/4, 1/2, 1/4, 1/4, 1/2, 1.5]
- (The combination of notes and durations sounds like the theme of Bach's Goldberg Variations).
- ALGORITHMIC TASK: Each repetition of the complete melody should be played at a different tempo: for this mulriply all durations by a random value.
*/

//Given SynthDef:
(
SynthDef(
	\sinePerc,
	{ |freq, amp = 0.1, durEnv = 1, pan = 0|
		var signal, env;

		signal = SinOsc.ar(freq, 0, amp);

		env = EnvGen.ar(
			Env.perc(0.01, durEnv, 0.2),
			doneAction: 2
		);

		signal = Pan2.ar(signal * env, pan);

		Out.ar(0, signal)

}).add
)

//Possible solution:
(
var pitches, durations;

pitches = Pseq([7, 7, 9, 7, 9, 11, 9, 7, 6, 4, 2] + 72, inf).asStream;

durations = Pseq([1, 1, 1/8, 1/8, 1/2, 1/4, 1/2, 1/4, 1/4, 1/2, 1.5], inf).asStream;

Routine({ var nextDur, newTempo = 1; //I need a default value because of the i != 0 condition.

	inf.do({ |i|;

		if ((i % 11 == 0).and(i != 0), { newTempo = rrand(0.5, 2.5) }); //First melody at original "tempo". The use of the module is the key of this exercise to choose a new tempo product every 11 pitches (complete melody cycle).

		nextDur = durations.next * newTempo; //The tempo product is also applied to durEnv so that the length of the sound is adapted (alongside the wait time of the routine).

		Synth(\sinePerc,
			[\freq, pitches.next.postln.midicps, \durEnv, nextDur]
		);
		nextDur.postln.wait
	})

}).play
)

//Another option, pretty much the same:
(
Routine({
	var freqs, durs, durDev = 1;

	freqs = Pseq([ 7, 7, 9, 7, 9, 11, 9, 7, 6, 4, 2 ] + 72, inf).asStream;
	durs = Pseq([1, 1, 1/8, 1/8, 1/2, 1/4, 1/2, 1/4, 1/4, 1/2, 1.5], inf).asStream;

	inf.do({ |i|
		var thisDur;

		if(((i % 11) == 0).and(i != 0), { durDev = [0.5, 0.75, 1, 1.25, 1.5, 2].choose });

		thisDur = durs.next * durDev;

		Synth(\sinePerc, [
			\freq, freqs.next.midicps,
			\amp, 0.2,
			\durEnv, 1 * thisDur,
			\pan, 0
		]);
		thisDur.wait
	})

}).play
)
