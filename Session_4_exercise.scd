//SESSION 4 - EXERCISE

/////////////////////////////////////////////////

/*
Combine the use of patterns within a Routine (patterns generate values / Routine asks for values to patterns and creates synths) following these instructions:
- Use the following SynthDef \sinePerc.
- Use the following array of MIDI notes: [ 7, 7, 9, 7, 9, 11, 9, 7, 6, 4, 2 ] + 72.
- Use the following array of durations: [1, 1, 1/8, 1/8, 1/2, 1/4, 1/2, 1/4, 1/4, 1/2, 1.5]
- (The combination of notes and durations sounds like the theme of Bach's Goldberg Variations).
- ALGORITHMIC TASK: Each repetition of the complete melody should be played at a different tempo (for this multiply all durations by a random value).
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

//Routine template:
(
Routine({

	inf.do({

		Synth(\sinePerc);

		1.wait
	})

}).play
)
