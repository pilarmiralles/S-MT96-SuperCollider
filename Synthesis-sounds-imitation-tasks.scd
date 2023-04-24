//Additive / Substractive synthesis - Task: imitation of sounds:

//1 - Some sort of hammer on a piece of metal? (a very soft digging in the mine with a pickaxe):
(
{ var impulse;

	impulse = Impulse.ar(0.5); //One impulse every two seconds: when used in Ringz, the impulse acts as input signal / when used in Decay, the impulse works as a trigger of the "envelope".

	{ Mix(
		Ringz.ar(
			impulse,
			[60, 3000, 3070, 6550], //Original [52, 7000, 14550], maybe closer to a coin sound.
			[0.7, 0.5, 0.6, 1], //The Ringz filter has three frequencies and three decay times (so there are three filters mixed to a single channel and then the whole modulation is duplicated using !2 AFTER the ring modulation). Original [3, 0.3, 2].
			0.2
		)
	)

	ring1:

	WhiteNoise.ar(Decay.ar(impulse, 0.04)) //Using a product of the two signals would bring about the lack of fundamental signal, but ring1 add the fundamental signal back again within its internal operation. Very subtle detail, but makes the synthesis more realistic.
	} !2

}.play
)

//2 - Realistic tapping sounds: hard glass / wood? + more resonant glass:
(
{
	Klank.ar(
		`[
			[178.4, 570.3, 7384, 605, 356.9, 1150.6, 14768, 1210],
			1,
			[0.002, 0.012, 0.018, 0.013, 0.002, 0.012, 0.018, 0.013]
		],
		{ Dust.ar(3, 0.1) } !2 //Using Dust: tapping sound, quite realistic.
)}.play
)

(
{
    Klank.ar(
        `[
            [178.4, 570.3, 7384, 605, 356.9, 1150.6, 14768, 1210],
            1,
            [0.002, 0.012, 0.018, 0.013, 0.002, 0.012, 0.018, 0.013] * 12 //The product in here works as a lag for each decay time.
        ],
        { Dust.ar(3, 0.1) } !2
)}.play
)

//3 - Two ballons rubbed against each other:
(
{ var signal, resonators, freqs;

	freqs = Array.fill(10, { exprand(100, 200) }); //Array of 10 random frequencies from 100 to 200 Hz.
	signal = Saw.ar(LFDNoise3.ar(10, 30, 70).poll(5), LFDNoise3.ar(10).max(0)); //A Sawtooth wave with a frequency modulation and an amplitude modulation which is sent out only when above 0 (using .max).

	resonators = Mix(CombC.ar(signal, 1/freqs, 1/freqs, 0.4, 1/freqs.size)); //.size adapts the compensation of the amplitude according to the number of frequencies in the array of freqs, as this is the amount of comb filters that will be mixed into a single channel.

	LeakDC.ar(resonators) !2 //LeakDC is a filter commonly used when working with comb filters. It is a high pass filter which avoids the DC offset.

}.play
)

//4 - Radio interferences:
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

//5 - Ventilation machine:
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

//6 - Bells (low version):
(
{ var signal;

	signal = { Klank.ar(
		`[
			[117, 223, 257, 464, 727, 1002],
			[0.04, 0.08, 0.07, 0.08, 0.1, 0.07],
			Array.fill(6, { exprand (0.1, 0.8) * 16 })
		],

		LPF.ar(Dust.ar(3, 0.5), 300)
	)
	}!2;

	signal * 2

}.play
)

//7 - Rain:
(
{ var signal;

	signal = { Mix.ar(
		Pulse.ar(
			Array.fill(6, { exprand (60, 100) }),
			LFDNoise1.ar(800, 0.3, 0.5).lag(0.001),
			0.025
		)
	) } !2;

	FreeVerb.ar(signal, 0.5, 0.7) //Not clear whether the reverb helps.

}.play
)

//(trying with Schroeder filter), hmmmm Idk:
(
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

//8 - Organ synthesizer (cheap Bach XD):
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

//9 - Water drops from a tap:
(
SynthDef(
	\stupidGliss,
	{ arg out, start, end, masterVolume, envTime;
		var signal;

		signal = { Mix(
			Array.fill(100, {

				SinOsc.ar(
					XLine.ar(start, end, envTime, doneAction:2),
					0,
					XLine.ar(0.2, 0.001, envTime, doneAction:2)
				) * masterVolume
			})
		) } !2;

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
	var start, end;

	Synth(\reverb, [\in, 4, \time, 0.2, \masterVolume, 0.7], s, 'addToTail'); //Can increase / decrease the time of the reverb.

	start = Prand((200..500), inf).asStream; //Can change the ranges of frequencies.
	end = Prand((900..1300), inf).asStream;

	inf.do({

		Synth(\stupidGliss, [\out, 4, \start, start.next, \end, end.next, \envTime, 0.3, \masterVolume, 0.01]);

		rrand(0.3, 1.7).wait //Can change waiting time.
	})
}).play
)