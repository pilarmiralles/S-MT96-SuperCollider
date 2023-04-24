//Signals - Tasks

//Modulate the frequency of a sine oscillator from 65 to 3961 Hz using another sine oscillator. The period of the modulating signal should be 11 seconds. Adjust the phase so that the modulation starts at 3961 Hz:
(
{
	SinOsc.ar(
		SinOsc.ar(1/11, 0.5pi, 1948, 2013),
		0,
		0.3)
}.play
)

//Create a sawtooth wave with frequency equal to 1000 Hz. Use a band pass filter to filter the sawtooth wave and stablish a narrow band width. Use a low frequency noise generator with cubic interpolation to slowly modulate the cutoff frequency of the filter. Use the mul / add arguments of the modulating signal so that the modulation moves between the 1st and 11th overtones of the sawtooth wave:
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

//Create a random impulse generator (Dust) with a density equal to 3 and filter the signal using 60 Ringz filters. Use exponential distributions to randomize the frequency and decay time of each filter. Then mix the 60 signals in a single channel:
(
{
	var in, signal;

	in = Dust.ar(3);

	signal = Array.fill(60, {
		Ringz.ar(
			in,
			exprand(200, 3000),
			exprand(0.2, 0.5),
			0.01
		)
	});

	{ Mix(signal) } !2

}.play
)

( //Equivalent option:
{
	var in, signal;

	in = Dust.ar(3);

	signal = Ringz.ar(
		in,
		Array.fill(60, { exprand(200, 3000) }),
		Array.fill(60, { exprand(0.2, 0.5) }),
		0.01
	);

	{ Mix(signal) } !2

}.play
)

( //Though for next exercise we need a simpler mono version so it can be panned:
{
	Mix(
		Ringz.ar(
			Dust.ar(3),
			Array.fill(60, { exprand(200, 3000) }),
			Array.fill(60, { exprand(0.2, 0.5) }),
			0.01
		)
	)
}.play
)

//From the former code: add an independent stereo panoramization for each filter and carry out a slow modulation of the position of each filter using a linear low frequency noise generator. Then mix the 60 signals into a two-channel signal:
(
{
	Mix(
		Pan2.ar( //Pan2 already provokes a two-channel signal for each filter, so Mix will consist on an array of 60 two-channel signals).
			Ringz.ar(
				Dust.ar(3),
				Array.fill(60, { exprand(50, 3000) }),
				Array.fill(60, { exprand(0.5, 5) }),
				0.01
			),
			Array.fill(60, { LFDNoise1.ar(1/5, 1) })
		)
	)
}.play
)

//Deconstruct the following multichannel expansion into an array of signals separated by commas. Make a proper distribution of the different parameters for each signal:

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

//Use a linear low frequency noise generator as the gate of an adsr envelope. Then apply the envelope to a brownian noise generator:
(
{ var gate, env, signal;

	gate = LFDNoise1.ar(1, 1);

	env = EnvGen.ar(Env.adsr(0.1, 0.3, 0.3, 1, 0.8), gate);

	signal = BrownNoise.ar(0.5);

	signal * env

}.play
)
