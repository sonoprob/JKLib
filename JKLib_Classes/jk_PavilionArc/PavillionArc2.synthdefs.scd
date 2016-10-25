/*

"/Users/a/dev/versioned/scwork/Classes_enabled/jk/PavillionArc2.synthdefs.scd"


s.boot
Synth(\sinesweep1,[\a, 0.9, \b, 0.3, \amp, 1]);
Synth(\sinesweep1,[\a, 0.3, \b, 0.8, \amp, 1]);

Synth(\sinesweeplong,[\a, 0.3, \b, 0.9, \amp, 1]);
Synth(\sinesweeplong,[\a, 1, \b, 0.3, \amp, 1]);

Synth(\sinesweeprev,[\a, 0.9, \b, 0.18, \amp, 1]);

// Synth(\sinesweeplong, target:PavillionArc2.group);

*/

(


// not yet
/*
SynthDef(\sinesweep, { arg outBus=0, a=1, b=0, amp=0.2;
	var snd, freq, dur, fenv, aenv;
	freq = a.abs.linexp(0,1,20,1000);
	dur = b.abs.linexp(0,1,0.001,20);
	fenv = (XLine.kr(1, 0.0001, dur, doneAction:2) - a).fold(0,1);
	aenv = (XLine.kr(1, 0.0001, dur, doneAction:2) - b).fold(0,1);
	snd = SinOsc.ar(fenv * freq, 0 , aenv * amp) ! 2;
	Out.ar(outBus, snd);
}).add;

Synth(\sinesweep,[\a,-0.9, \b,-0.8, \amp,0.2])
*/


SynthDef(\sinesweep1, { arg outBus=0, a=1, b=0, amp=0.2;
	var snd, freq = a.linexp(0,1,100,1000);
	var dur = b.linexp(0,1,0.001,7);
	var env=XLine.kr(1, 0.0001, dur, doneAction:2);
	snd = SinOsc.ar(env * freq, 0 , env * amp);
	Out.ar(outBus, snd);
}).add;

SynthDef(\sinesweep2, { arg outBus=0, a=1, b=0, amp=0.2;
	var snd, freq = a.linexp(0,1,1000,100);
	var dur = b.linexp(0,1,0.1,0.001);
	var env=XLine.kr(1, 0.0001, dur, doneAction:2);
	snd = SinOsc.ar(env * freq, 0 , env * amp);
	Out.ar(outBus, snd);
}).add;

SynthDef(\sinesweeprev, { arg outBus=0, a=1, b=0, amp=0.2;
	var snd, freq = a.linexp(0,1,100,1000);
	var dur = b.linexp(0,1,0.001,7);
	var env=XLine.kr(0.0001, 1, dur, doneAction:2);
	snd = SinOsc.ar(env * freq, 0 , env * amp);
	Out.ar(outBus, snd);
}).add;

SynthDef(\sinesweeplong, { arg outBus=0, a=1, b=0, amp=0.2;
	var snd, freq = a.linexp(0,1,10,1000);
	var dur = b.linexp(0,1,0.001,60);
	var env=XLine.kr(1, 0.0001, dur,doneAction:2);
	snd = SinOsc.ar(env * freq, 0 , env * amp) ! 2;
	Out.ar(outBus, snd);
}).add;



)
