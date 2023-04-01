//Algorithmic composition: instrument-score and the algorithmic routine (crossfade, overlap, granular)
/////////////////////////////////////////////////////////////////////////////////////////////////////////

//INTRODUCTION (just in case) ITERATIONS AND ROUTINES (.do, Routine):

//METHOD .do:
//Grammar:
[element1, element2, ...].do({ |item, iteration| function })

//Example:
([ 10, 20, 30, 40, 50 ].do({ |num| rrand(0, num).postln }))

//Example using the iteration argument:
(
a = [0, 10, 20, 30, 40, 50];

a[..4].do({ |num, i| rrand(a[i], a[i + 1]).postln }) //As in the former code, it print five random values between the limits imposed by the function.
)

//When receiving a single number:
100.do({ rrand(1, 64).postln })

//Example:
(
a = 0;
100.do({ a = a + rrand(-1.0, 1.0); a.postln })
)


//ROUTINES:
//Difference between "eager" and "lazy" evaluation (function / routine):

//Function (eager):
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

//Routine (lazy):
(
r = Routine({

	1.yield;

	15.yield;

})
)
r.next
r.reset

//More complex example:
(
r = Routine({
	var synth1, synth2, synth3;

	"hello".postln; //Needs .postln because it is not the line of the .yield.
	synth1 = { SinOsc.ar(1000, 0, 0.05) }.play;
	"synth1 created".yield; //As the method .yield is applied to this line, it is not necessary to use .yield.

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

//COMBINING .do AND ROUTINE

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

	inf.do({ options.choose.yield })
})
)
r.next

//USING CLOCKS (automatization)
(
r = Routine({

	inf.do({
		[\paper, \scissors, \rock].choose.postln;
		1.yield
	})
})
)
r.play

//Understanding clocks in SC:
r.clock
r.clock.tempo
r.clock.tempo = 100/60
r.clock.tempo = 1 //= 60/60 //Setting back to 60bpm (second as a referential time unit) the default clock.

//Independent clocks:
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

(
r.play(TempoClock(180/60)); //Three times faster than "z".
z.play(TempoClock(60/60))
)

//First example of the instrument-score relationship (SynthDef-Routine):
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
			{SinOsc.ar(
				exprand(1000, 8000),
				0,
				0.05 !2
			) * EnvGen.ar(Env.sine(1), doneAction: 2)
			}.play;

			1.wait
		})
	})
}).play
)

/////////////////////////////////////////////////////////////

//CROSSFADE AND OVERLAP ROUTINES

//CROSSFADE ROUTINES:
//First example: equal cross and sustain times:
(
SynthDef(
	\filters1,
	{ |freqs = #[0, 0, 0], crossTime, sustTime|
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
				[crossTime1, sustTime, crossTime2],
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

	crossTime1 = rrand(1.0, 8);

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
				Gendy3.ar(
					0, 0, SinOsc.kr(0.1, 0, 0.1, 0.9), 1.0,
					Array.geom(5, freq.midicps, 2) * Array.fill(5, { rrand(0.95, 1.05) }),
					0.011, 0.005, 12, 12, amp)
			),
			0.0);

		env = EnvGen.ar(
			Env(
				[0, 1, 1, 0],
				[crossTime, sustTime, crossTime],
				\sine
			),
			doneAction: 0
		);

		finalSignal = signal * env;

		reverb = FreeVerb.ar(finalSignal,  0.9, 1, 1);
		DetectSilence.ar(reverb, doneAction: 2);

		Out.ar(out, reverb)

	}
).add
)

(
Routine({
	var sustTime, crossTime, freqs;

	sustTime = Pn(Pstutter(3, Pshuf([1, 1, 2, 2, 4], 1)), inf).asStream;
	crossTime = 0.7;

	freqs = [19, 21, 22, 24, 26, 27, 29, 31];

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
//First example:
(
SynthDef(
	\overlapFilter,
	{ |freq, crossTime, sustTime, density|
		var signal, env, individualAmp;

		individualAmp = ((density.log2 + 1) * -3.01).dbamp * 0.5;

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

(
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

//Glissando effect (using the same SynthDef):
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

	CombC.ar(signal, 1/40, 1/40, 1.5, 0.2);
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

    /* Tonal version:
    root = [19, 21, 22, 24, 26, 27, 29, 31].midicps.choose;

    freqs = Array.geom(6, root, 2);
    */

    inf.do({
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

//No sound example of Tdef:
(
Tdef(\tdef, {

	inf.do({
		"hello".scramble.postln;
		1.wait;
	})
}).play
)

//Sound example of Tdef:
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

//Building a granulator:
p = Platform.resourceDir +/+ "sounds/a11wlk01.wav"

b = Buffer.read(s, p)
b.query

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

Synth(\grain, [\bufnum, b.bufnum, \position, 1 * 44100, \rate, 1, \dur, 0.1, \pan, 0]) //Isolated grain.

(
Routine({
	var durBuffer, durGrain, position, rate = 1;

	durBuffer = b.duration;

	inf.do({

		durGrain = rrand(0.0, durBuffer);

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
		//0.1.wait
		rrand(0.01, 0.1).wait
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
	{ |in, mix, room, damp, mul|
	 var input, signal;

		input = In.ar(in, 2);
		signal = FreeVerb.ar(input, mix, room, damp, mul);
		OffsetOut.ar(0, signal)
}).add
*/
)

(
Routine({
	var buffer, durBuffer, durGrain, position, rate = 1, superposition;

	//Synth(\reverb, [\in, 4, \mix, 0.7, \room, 0.7, \damp, 0.5, \mul, 1.5], s, 'addToTail');

	position = 0;

	inf.do({

		buffer = [c, d].choose;

		durBuffer = buffer.duration;
		//durGrain = rrand(0.5, 1.5);
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
					\pan, 0,
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

//EXAMPLES OF MORE COMPLEX ALGORITHMIC SYSTEMS

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

	position = 0;

	Synth(\processing, [\in, 4, \mix, 0.7, \room, 1, \freq, 3000, \amp, 0.7], s, \addToTail);

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

    bufferPattern = Pwrand([c, d], [2, 4].normalizeSum, inf).asStream;

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

//ALGORITHMIC COMPOSITION TOOLD: BOOLEANS AND PATTERNS

//BOOLEAN EXPRESSIONS

4 == 5
4 != 5
4 > 5
4 <= 5
4.odd
4.even
x.isNil
0.6.coin
(2 > 1).and(2.odd)
(2 > 1).or(2.odd)


//"If" method, three syntaxes:

if (1 > 2, { "true".postln }, { "false".postln })

(0.7.coin).if({ "true".postln }, { "false".postln })

if(3.odd) { "true".postln } { "false".postln }

//If applied to a Routine:
if ((i % 3) == 0, { function1 }, { function2 }) //Something happens every three iterations.
if (i.asInt.even, { function1 }, { function2 }) //Alternating between two options.
if (0.5.coin.and(i != 0), { function1 }, { function2 }) //Avoiding applying condition to the first iteration.

//"While" method:
(
while(
    { var value;

        value = (1..10).choose.postln;
        (value == 2).or(value == 5);

    },
    { "success".postln }
)
)

//"Switch" method:
(
var value;

value = rrand(1, 20);

switch
(value % 4)
{ 0 } { "zero" }
{ 1 } { "one" }
{ 2 } { "two" }
{ 3 } { "three" }
{ "error" }
)

//"Case" method:

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

//"Select" method:
[1, 2, 3, 4].select({ |item, i| item.even });


//PATTERNS
//Basic SynthDef:
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

//PSEQ
//Example with numbers:
(
var stream;

stream = Pseq([0, 1, 2, 3, 4], 1).asStream;

15.do({ stream.next.postln })
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

//Operations with patterns: example with sound:
(
var pitches, durations;

pitches = (
	Pseq([60, 63, 67, 70, 72], inf)
	+
	Pseq([0, 0, 12], inf)
).asStream;

durations = Pseq([0.25, 0.5, 0.25], inf).asStream;

Routine({
	inf.do({

		Synth(\sine, [\freq, pitches.next.postln.midicps]);
		durations.next.wait
	})
}).play
)

//Embedded patterns: example with sound:
(
var pitches, durations;

pitches = (
	Pseq([ Pseq([60, 63], 3), 67, 70, Pseq([73, 72], 5)], inf)
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

//PRAND
//Example with numbers:
(
var stream;

stream = Prand([0, 1, 2, 3, 4], 5).asStream;

15.do({ stream.next.postln })
)

//Example with sound:
(
var pitches, durations;

pitches =  Pseq(
	[
		Prand((72..77), 10),
		Prand((72..77) + 12, { rrand(1, 3) })
	],
	inf).asStream;

durations = Prand([0.1, Pseq(Array.geom(8, 0.1, 1.5).mirror)], inf).asStream;

Routine({
	inf.do({

		Synth(\sine, [\freq, pitches.next.postln.midicps]);
		durations.next.wait
	})
}).play
)

//PWRAND
//Example with numbers:
(
var stream;

stream = Pwrand([0, 1, 2], [0.5, 0.375, 0.125], 15).asStream;

15.do({ stream.next.postln })
)

//Example with sound:
(
var pitches, durations;

pitches = Pwrand(
	[
		Pseq(60 + [0, 4, 7, 10], 1),
		Pseq(63 + [0, 4, 7, 10], 1),
		Pseq(66 + [0, 4, 7, 10], 1),
		Pseq(69 + [0, 4, 7, 10], 1),
	],
	[1, 2, 3, 4].normalizeSum,
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

//PSHUF
//Example with numbers:
(
var stream;

stream = Pshuf([0, 1, 2, 3, 4, 5], 2).asStream;

15.do({ stream.next.postln })
)

//Example with sound:
(
var pitches, durations;

pitches =  Pshuf([60, 62, 64, 65, 67, 69, 71], inf).asStream;

durations = 1/8;

Routine({
	inf.do({

		Synth(\sine, [\freq, pitches.next.postln.midicps]);
		durations.wait
	})
}).play
)

//PN
//Example with numbers:
(
var stream;

stream = Pn(Pseq([ 0, 1, 2, 4, 5 ], 1), 2).asStream;

15.do({ stream.next.postln })
)

//Example with sound:
(
var pitches, durations;

pitches = Pn(Pshuf(Array.series(7, 72, 0.5), { rrand(1, 4).postln }), inf).asStream;

durations = 1/8;

Routine({
	inf.do({

		Synth(\sine, [\freq, pitches.next.postln.midicps]);
		durations.wait
	})
}).play
)

//PLAZY
//Example with numbers:
(
var stream;

stream = Pn(
    Plazy({
        var size;

        size = rrand(1, 12);

        Pseq(Array.series(size, 0, 1))
    }),
    inf
).asStream;

50.do({ stream.next.postln })
)

//Example with sound:
(
var durations, thisDur, newArray, pan;

durations = Pn(
    Plazy({
        newArray = Array.geom(
            rrand(1, 29),
            0.01,
            rrand(1.0, 1.15) //Other ranges: 1.2 - 1.25.
        );

        Pseq(newArray.mirror)
    }),
    inf
).asStream;

pan = Pseq([-1, 1], inf).asStream;

Routine({
    inf.do({
        thisDur = durations.next;

        Synth(
            \sine,
            [
                \freq, 4000,
                \durEnv, thisDur,
                \pan, pan.next * (thisDur/newArray.last).postln,
                \amp, 0.1
            ]
        );
        (thisDur * 2).wait
    })
}).play
)

//PATTERNS FOR RANDOM DISTRIBUTIONS

//Uniform distribution (Pwhite):
(
var stream;

stream = Pwhite(0, 100, 10).asStream;

15.do({ stream.next.postln })
)

//Exponential distribution (Pexprand):
(
var stream;

stream = Pexprand(1, 100, 10).asStream;

15.do({ stream.next.postln })
)

//Normal or Gaussian distribution (Pgauss):
(
var stream;

stream = Pgauss(50, 10, 10).asStream;

15.do({ stream.next.postln })
)

//Brownian motion (Pbrown):
(
var stream;

stream = Pbrown(0, 10, 1.0, 10).asStream;

15.do({ stream.next.postln })
)

//Brownian motion model:
a = 1
a = (a + rrand(-1.0, 1.0)).fold(0.0, 10.0)

//PSEG
//Simple SynthDef:
(
SynthDef(
	\saw,
	{ |freq|
		var signal;

		signal = Saw.ar(freq) * EnvGen.ar(Env.sine(0.3, 0.05), doneAction: 2);

		OffsetOut.ar(0, signal !2)

}).add
)

(
var lineA, lineB;

lineA = Pseg( //Bottom line.
	Pseq([85, 100, 10], inf),
	Pseq([10, 10, 0], inf),
);
lineB = Pseg( //Top line.
	Pseq([90, 100, 70], inf),
	Pseq([10, 10, 0], inf),
);

Pbind(
	\instrument, \saw,
	\midinote, Pwhite(lineA, lineB),
	\dur, 0.015
).play
)

//PSWITCH1
(
a = Pswitch1([
	100,
	Pseq([74, 76, 77, 79, 80, 90, 75, 73, 72, 70, 68, 67, 65, 66, 64, 65, 63, 61, 60], inf)
],
Pseq([0, Pn(1, Pseries(1).asStream)], inf)
).asStream
)

a.next
