//SOUND SYNTHESIS EXERCISES

/////////////////////////////////////////////////
//Specific exercise: synthesizing a bell (different approaches):

//1 - Using an array of specific frequencies (and amplitudes), which have been copied from a chart of values from a real bell's spectrum analysis, and iterating with .do (or .collect) the addition of overtones to the fundamental frequency (all at once):
(
{
	var fundamental = 222, overtones, signal, amps, durs;

	signal = SinOsc.ar(fundamental, 0, Line.ar(-18.35.dbamp, 0, 2.5, doneAction: 0)); //Fundamental frequency (overtone 1).

	overtones = [438, 520.5, 706.5, 781, 879, 1178, 1315, 1522, 1813, 2033, 2155]; //Another 11 overtones.
	//amps = Array.geom(11, 1, 0.96); //(should apply without the factor in the Line.
	amps = [0, -10.20, -17.01, -34.08, -9.26, -16.52, -13.60, -23.25, -9.64, -26.22, -28.54].dbamp;
	durs = overtones.linlin(400, 2200, 1.5, 3); //Different durations for each line (the higher the overtone, the longer the duration, although the fundamental frequency has a rather long duration too in its own Line). The array of durations could also be randomized perhaps.

	overtones.do({ |item, i| //.collect would return the same exact result in this case.

		//Reassigning the value of signal (addition).
		signal = signal + SinOsc.ar(item, 0, 1 * Line.ar(1 * amps[i], 0, durs[i], doneAction: 0)); //Using doneAction 0 to assign doneAction 2 with DetectSilence.

		//Using DetectSilence to avoid the longer lines to get cut after the shorter line is done, if doneAction 2 is applied to the lines. In this case, DetectSilence needs to be placed within the loop (it does not work outside):
		DetectSilence.ar(signal, doneAction: 2)

		//Another option to apply doneAction 2 to the whole bunch of lines is to use a dummy line with a duration equal to the longest possible duration of the signal lines. This signal does not sound, but it will apply doneAction when done, killing all synths anyway (0.1 seconds longer than the longest duration just to allow possible higher partials to ring):
		//Line.ar(0, 100, 3.1, doneAction: 2);

	});

	signal = signal !2 * (0.3/12); //Balancing the total amplitude and getting a mono-duplicated signal (stereo).



}.scope
)

//2 - Creating several instances of the same signal by sending an array to its frequency and amplitude arguments, and mixing the result in a single channel (although by applying Pan2 within Mix and assigning an array to its position argument, we create 7 panned signals, so Mix is already a two-channel signal):
(
{ var signal;

	Line.ar(0, 100, 6.1, doneAction: 2); //Dummy line following the one in example 1.

	signal = Mix(
		Pan2.ar(
			SinOsc.ar(
				[222, 438, 520.5, 706.5, 781, 879, 1178] * rrand(0.5, 2), //Specific frequencies, with a random transposition (different each time it the function is executed).
				0, //Phase.
				Line.ar(
					[-18.35, 0, -10.2, -17.01, -34.08, -9.26, -16.52].dbamp, //Starting amplitude values.
					0, //Target points (all going to silence).
					Array.fill(7, { rrand(2.0, 6) }), //Random durations.
					doneAction: 0 //DoneAction 0 as doneAction 2 will be applied through DetectSilence or a dummy Line.
				)
			),
			Array.fill(7, { |i| (i + (2.5/7)) }).linlin(0, 7, -1, 1.0), //Distribute the partials among the stereo field: with the little deviation within the function of Array.fill, the panning occurs between -0.89 and 0.81 (it is kind of compensated in both sides) so that it does not reach the exact extremes of the stereo field.
			level: 0.08
		)
	);

	//DetectSilence.ar(signal, doneAction: 2) //Another option is to use DetectSilence, affecting the whole Mix.

}.scope
)

[-18.35, 0, -10.2, -17.01, -34.08, -9.26, -16.52].dbamp.plot //Plotting the graph (the lines are clearer to see the kind of envelope of amplitudes).
[-18.35, 0, -10.2, -17.01, -34.08, -9.26, -16.52].dbamp.plot(discrete:true) //Plotting the graph (discrete points).

//3 - Creating a function and iterating the method .value in order to execute it multiple times with different value for its arguments in each instance:

~partial = { |freq = 220, amp = 0.08| { SinOsc.ar(freq, 0, Line.ar(amp, 0, 5.rand, doneAction: 2)).dup(2) }.play } //Beware the difference between the outer function, the one iterated by .do in the next line, and the function.play applied to the signal only. The method .value is applied to the outer function, thus the arguments need to be outside the function.play in order to receive the values sent by the .value message. Ringing times are randomly chosen within Line.

[220, 555, 733, 1440].do{ |freq| ~partial.value(freq)} //Sending four specific frequencies, which will be added (other possible values sent as arguments for each instance could be the amplitude or the duration).

//Another option (creating a function to calculate random frequencies and durations (fixed amp though), instead of feeding .do with specific frequencies):
~partial = { |freq = 220, amp = 0.01, dur = 2.0| { Pan2.ar(SinOsc.ar(freq, 0 , Line.ar(amp, 0, dur, doneAction: 2)), 0) }.play }

15.do{ |i| ~partial.value(80 * (i + 1 * exprand(1.001, 1.2)), 0.01, fold(3 * (i + 1 * 0.1 * (rrand(1.001, 1.4))), 0, 5.5)) }
//Regarding the frequencies, the highest possible is 80 * (16 * 1.2) = 1536, and the lowest possible is 80 * (1 * 1.001) = 80.08. This function seeks the overtones series of the fundamental freq = 80, but applying a little deviation to it. I need i + 1 so that the first value is not 0 (15 overtones, from overtone 1 to 16, being 1 the fundamental). Regarding the durations argument, it is kind of calculated so that the duration is not over 6-ish (3 * (16 * 0.1 * 1.2) = 5.76, maximum possible value), but anyway, there is the fold method to avoid exeeding 5.5 although it shouldn't be needed if calculating this maximum value (and, again, i + 1 so that the first value is not 0). Method fold applied this way: fold(in value, lo, hi), although it could have been applied in this other way in value.fold(lo, hi).

//Extra example from a student (same principle as in example 1). Still think it would work the same with FreeVerb and just one iteration function, although in this one, the values in signal1 and 2 could be different:
(
{
	var pitch, amps, signal1, signal2;

	pitch = [98, 146.83, 174.61, 164.81, 233.08].choose; //G dorian randomness
	amps = [1, 0.3090, 0.1410, 0.0197, 0.3441, 0.1492, 0.2089, 0.0688, 0.3295, 0.0488, 0.0374, 0.0321];

	signal1 = SinOsc.ar(pitch * 1, 0, 0.1209) * EnvGen.ar(Env.perc, doneAction: 2, timeScale: 4);
	signal2 = SinOsc.ar(pitch * 1, 0, 0.1209) * EnvGen.ar(Env.perc, doneAction: 2, timeScale: 4);

	[1.97, 2.34, 3.1, 3.52, 3.96, 5.31, 5.92, 6.86, 8.17, 9.16, 9.71, 16.03].do({ |item, i|  signal1 = signal1 + SinOsc.ar(pitch * item, 0, amps[i]) * EnvGen.ar(Env.perc, doneAction: 2, timeScale: 4) });


	[1.97, 2.34, 3.1, 3.52, 3.96, 5.31, 5.92, 6.86, 8.17, 9.16, 9.71, 16.03].do({ |item, i|  signal2 = signal2 + SinOsc.ar(pitch * item, 0, amps[i]) * EnvGen.ar(Env.perc, doneAction: 2, timeScale: 4) });

	//[signal1, signal2] * 0.1

	FreeVerb2.ar(signal1 * 0.1, signal2 * 0.1, 0.7, 0.4, 0);

}.play;
)


/////////////////////////////////////////////////
//Put into practice all your sound synthesis tools in order to imitate certain sounds. Let's all approach the same list, so that we can share different approaches to the same sounds:

//1 - Tapping on wood with fingernails or/and tapping on glass with fingernails.
//2 - A very bad radio signal.
//3 - A water drop from a fauset.
//4 - A ventilation machine.
//5 - Oldschool rain.


/////////////////////////////////////////////////
//My approached (and extra sounds at the end):

//1 - Tapping on wood with fingernails or/and tapping on glass with fingernails:
( //This is more like wood, I guess:
{
	Klank.ar(
		`[
			[78, 270, 1384, 405, 156, 850, 1768, 510], //This seems to be totally random.
			1,
			[0.002, 0.012, 0.018, 0.013] * 2
		],
		{ Dust.ar(3, 0.1) } !2 //Using Dust: tapping sound, quite realistic.
)}.play
)

( //This is more like a non-resonant glass:
{
	Klank.ar(
		`[
			[178, 570, 7384, 605, 356, 1150, 14768, 1210],
			1,
			[0.002, 0.012, 0.018, 0.013]
		],
		{ Dust.ar(3, 0.1) } !2 //Using Dust: tapping sound, quite realistic.
)}.play
)

( //Maybe this is more like a resonant glass:
{
    Klank.ar(
        `[
            [278, 670, 7384, 705, 456, 1250, 14768, 1510],
            1,
            [0.002, 0.012, 0.018, 0.013, 0.002, 0.012, 0.018, 0.013] * 12 //The product in here works as a lag for each decay time.
        ],
        { Dust.ar(3, 0.1) } !2
)}.play
)

//2 - A very bad radio signal.
(
{ var trigger, signal, env, finalSignal, masterVolume = 0.3;

	trigger = Dust.ar(Array.fill(20, { rrand(3, 7) }));

	signal = LFPulse.ar(
		Array.fill(20, { exprand(90, 300) }), //Lower freqs version, for instance 70-130 Hz.
		0,
		LFDNoise0.ar(600, 0.3, 0.5),
		0.1 !2
	);

	env = EnvGen.ar(Env.perc(0.05, 0.05, 0.3), trigger);

	finalSignal = { Mix(signal * env) } !2;

	finalSignal * masterVolume;

}.play
)

//3 - A water drop from a fauset (a single one, you can also evaluate multiple times in a row, but be careful because of the lack of doneAction 2: see routine option at the end of the document):
//(I'm sure there is no need for an entire Schroeder filter, but...). Also maybe I am lacking some attack.
(
{ |start, end, amp = 0.5, envTime = 0.3, pos = 0, time = 0.3, masterVolume = 0.7|
	var signal1, signal2, input, wet, finalSignal;

	input = SinOsc.ar(
		XLine.ar(exprand(100, 250), exprand(800, 1050), envTime),
		0,
		XLine.ar(0.2, 0.001, envTime)
	);

	input = Pan2.ar(input, pos) * amp;

	wet = Mix(
		{ CombC.ar(
			input,
			0.035,
			rrand(0.025, 0.035),
			time,
			rrand(0.25, 0.5)
		)
		} !12
	);

	wet = LeakDC.ar(wet);

	4.do({wet = AllpassN.ar(wet, 0.05, { rrand(0.005, 0.05)} !2, time) });

	//DetectSilence.ar(wet, doneAction: 2); //I guess I can't apply this here because "wet" does not have a place for doneAction.

	finalSignal = input + (LPF.ar(wet, 3000) * -6.dbamp) * masterVolume;

}.play
)

//4 - A ventilation machine.
(
{ var signal;

	signal = FreeVerb.ar(
		Klank.ar(

		`[
			Array.fill(8, { exprand(80, 1000)}),
			0.4,
			Array.fill(8, { exprand(0.002, 0.02)}) * 20],

		{ Pulse.ar(
			80,
			PinkNoise.ar(0.1),
			0.1
		) } !2
		),
		1,
		1
	).clip2(0.2);

	CombC.ar(signal, 1/50, 1/50, 1, 0.1)

}.play
)

//5 - Oldschool rain.
(
{ var signal;

	signal = { Mix.ar(
		Pulse.ar(
			Array.fill(6, { exprand (80, 150) }),
			LFDNoise1.ar(800, 0.3, 0.5).lag(0.005),
			0.025
		)
	) } !2;

	//Not sure which option is better:
	//FreeVerb.ar(signal, 0.6, 0.8)
	GVerb.ar(signal, 20, 1, mul: 0.1)

}.play
)

( //Trying with Schroeder filter: harsher, but not sure if better:
{
	var dry, wet, time;

	time = 0.5;

	dry = { Mix.ar(
		Pulse.ar(
			Array.fill(6, { exprand (60, 100) }),
			LFDNoise1.ar(800, 0.3, 0.5).lag(0.001),
			0.025
		)
	) } !2;

	wet = Mix(
		{ CombC.ar(
			dry,
			0.035,
			rrand(0.025, 0.035),
			time,
			rrand(0.25, 0.5)
		)
		} !8
	);

	wet = LeakDC.ar(wet);

	4.do({wet = AllpassN.ar(wet, 0.05, { rrand(0.005, 0.05)} !2, time) });

	dry + (LPF.ar(wet, 3000) * -6.dbamp)

}.play
)


/////////////////////////////////////////////////////
//Extra sounds of mine (that I didn't dare list):

//Two ballons rubbed against each other (this sound was too specific):
(
{ var signal, resonators, freqs;

	freqs = Array.fill(10, { exprand(100, 200) }); //Array of 10 random frequencies from 100 to 200 Hz.
	signal = Saw.ar(LFDNoise3.ar(10, 30, 70), LFDNoise3.ar(10).max(0)); //A Sawtooth wave with a frequency modulation and an amplitude modulation which is sent out only when above 0 (using .max).

	resonators = Mix(CombC.ar(signal, 1/freqs, 1/freqs, 0.4, 1/freqs.size)); //.size adapts the compensation of the amplitude according to the number of frequencies in the array of freqs, as this is the amount of comb filters that will be mixed into a single channel.

	LeakDC.ar(resonators) !2 //LeakDC is a filter commonly used when working with comb filters. It is a high pass filter which avoids the DC offset.

}.play
)

//Low bells (they lack a bit of attack):
(
{ var signal;

	signal = { Klank.ar(
		`[
			[84, 107, 223, 257, 464, 727, 1002, 1236],
			Array.fill(8, { rrand(0.02, 0.1) }) * 0.5,
			Array.fill(8, { exprand (0.1, 0.8) * 16 })
		],

		LPF.ar(Dust.ar(1, 0.5), 800)
	)
	}!2;

	signal * 2

}.play
)

//Some sort of hammer on a piece of metal (maybe too high):
(
{ var impulse;

	impulse = Impulse.ar(0.5); //One impulse every two seconds: when used in Ringz, the impulse acts as input signal / when used in Decay, the impulse works as a trigger of the "envelope".

	{ Mix(
		Ringz.ar(
			impulse,
			[1250, 1290, 1310, 3000, 3070, 5550], //Original [52, 7000, 14550].
			[0.7, 0.7, 0.6, 0.5, 0.4, 1], //Original [3, 0.3, 2].
			0.2
		)
	)

	ring1:

	WhiteNoise.ar(Decay.ar(impulse, 0.04)) //Using a product of the two signals would bring about the lack of fundamental signal, but ring1 adds the fundamental signal back again within its internal operation.
	} !2

}.play
)

//Worst and cheapest Bach imitation ever:
(
{ var freqEnv, durEnv, freqs, amps, trigger = 1, signal, envPerc;

	freqEnv = EnvGen.ar(Env([33, 33, 31, 33, 31, 29, 28, 26, 25, 26], [0.125, 0.125, 2.2, 0.125, 0.125, 0.125, 0.125, 1, 2], \step).circle);
	durEnv = EnvGen.ar(Env([0.125, 0.125, 0.125, 2.2, 0.125, 0.125, 0.125, 0.125, 1, 2], [0.125, 0.125, 2.2, 0.125, 0.125, 0.125, 0.125, 1, 2], \step).circle);

	trigger = Impulse.ar(1/durEnv);

	freqs = Array.geom(7, freqEnv.midicps, 2) ++ Array.geom(2, (freqEnv + 43).midicps, 2) ++ (freqEnv + 53).midicps; //Upper 4th is a nice subtle addition.
	amps = Array.geom(10, 1, 0.92);

	signal = Mix(
		BPF.ar(
			PinkNoise.ar,
			freqs,
			0.002,
			amps * 10)
	)!2;

	envPerc = EnvGen.ar(Env.perc(0.02, 1.7), trigger); //Release time = 1.5 * durEnv --> Too short (now with 1.7 more legato).

	FreeVerb.ar(signal * envPerc, 0.7, 0.8, 0.5, 2.5)

}.play
)

//Water drops from a faucet, but continuous:
(
SynthDef(
	\stupidGliss,
	{ arg out, start, end, masterVolume, envTime, pos = 0;
		var signal;

		signal = Pan2.ar(
			SinOsc.ar(
				XLine.ar(start, end, envTime, doneAction:2), //If both of them sharing the same time, doneAction is just needed for one.
				0,
				XLine.ar(0.2, 0.001, envTime)
			),
			pos
		) * masterVolume;

		Out.ar(out, signal)
}).add;
SynthDef(
	\reverb,
	{ arg in, time = 0.5, masterVolume = 1;
		var input, wet, finalSignal;

		input = In.ar(in, 2);

		wet = Mix(
			{ CombC.ar(
				input,
				0.035,
				rrand(0.025, 0.035),
				time,
				rrand(0.25, 0.5)
			)
			} !12
		);

		wet = LeakDC.ar(wet);

		4.do({wet = AllpassN.ar(wet, 0.05, { rrand(0.005, 0.05)} !2, time) });

		finalSignal = input + (LPF.ar(wet, 3000) * -6.dbamp); //Can change the balance between both signals.

		OffsetOut.ar(0, finalSignal * masterVolume)
}).add
)

(
Routine({
	var start, end, pos;

	Synth(\reverb, [\in, 4, \time, 0.2, \masterVolume, 0.7], s, 'addToTail'); //Can increase / decrease the time of the reverb.

	start = Pexprand(100, 250, inf).asStream; //Can change the ranges of frequencies.
	end = Pexprand(800, 1050, inf).asStream;

	pos = Pwhite(-0.8, 0.8, inf).asStream;

	inf.do({

		Synth(\stupidGliss, [\out, 4, \start, start.next, \end, end.next, \envTime, 0.3, \masterVolume, 0.4, \pos, pos.next]);

		rrand(0.3, 1.7).wait //Can change waiting time.
	})
}).play
)
