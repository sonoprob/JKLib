Ndef(\brown, {|loff=500, hiff=1000, amp=0.1| HPF.ar(LPF.ar(BrownNoise.ar(amp * 0.01)!2, hiff), loff) }).play;
Ndef(\white, {|loff=500, hiff=1000, amp=0.1| HPF.ar(LPF.ar(WhiteNoise.ar(amp * 0.01)!2, hiff), loff) }).play;
Ndef(\in, {|amp=0.7| SoundIn.ar(0,1) * amp * 0.1; }).playN([1]);




Tuning filter c groot ? D groot ?


q.fxVerb.set(\dly, 0.1, \dlysp, 0.1);

q.fxVerb.set(\dly, 0.01, \dlysp, 0.1);


s.scope;

q.fxVerb.set(\dly, 0.1, \dlysp, 0.1);


q.fxVerb.set(\dly, 0.01, \dlysp, 0.3);






q.fxVerb.set(\mix,0.3, \room,1, \rsize, 1, \damp,0.9, \lo, 400, \hi, 17000);

s.freqscope
q.fxVerb.set(\mix,0.3)

s.queryAllNodes;

(


Tdef(\auto,{
	// q.verb; replace
	//	q.fxVerb.set(\mix,0.09, \room,20, \rsize, 10, \damp,0.99, \lo, 1000, \hi, 17000);
	q.fxVerb.set(\mix,0.3, \room,0.4, \rsize, 0.3, \damp,0.9, \lo, 400, \hi, 17000);

	// q.sineSweep(0.4, 0.8) // kick

	Ndef(\in, {|amp=0.7| SoundIn.ar(0,1) * amp * 0.1; }).playN([1]);
	Ndef(\brown).playN([0]);
	Ndef(\white).playN([0]);

	Ndef(\brown).fadeTime_(0.1).xset(\amp, 0.001);
	Ndef(\white).fadeTime_(0.1).xset(\amp, 0.001);

	Ndef(\brown).fadeTime_(3).xset(\ffreq, 300);

	/*
,,open


Ndef(\brown).fadeTime_(10).xset(\amp, 0)
Ndef(\white).fadeTime_(10).xset(\amp, 0)

	..close
Ndef(\brown).fadeTime_(3).xset(\ffreq, 300)
Ndef(\white).fadeTime_(3).xset(\ffreq, 1400)

	..open
Ndef(\brown).fadeTime_(3).xset(\ffreq, 3300)
Ndef(\white).fadeTime_(3).xset(\ffreq, 400)

	*/

	// Tuning filter c groot ? D groot ?
	Tdef(\bassaccel).play;

	q.sineSweep(0.36, 1); // kick

	q.accmul = 1;


	Tdef(\auto2,{
		inf.do{
			Ndef(\white).fadeTime_(3).xset(\ffreq, [2000, 4400, 8400, 12000].choose);
			Ndef(\brown).fadeTime_(3).xset(\ffreq, [200, 440, 840, 1200].choose);
			q.accexp = rrand(0.9, 0.99);
			// q.accexp = rrand(0.9, 1.1);
			q.accwait = rrand(1, 9);
			if( 0.2.coin ){ q.fxVerb.set(\mix,[0.04, 0.1, 0.1, 0.6].choose, \lo, [1000,3000,7000].choose ) };
			// (q.accwait * 3)
			(q.accwait / 1.2).wait;
			q.sineSweep(exprand(0.3,0.4), exprand(0.5, 1)); // kick
			(q.accwait / 0.2).wait;

		}
	}).play;




}).play;
)

s.makeWindow;
s.queryAllNodes
// ??
// q.sustainer.set(\keyBus, 0)
// q.sustainer.set(\keyBus, 0)


q.accmul = 0.5;
q.accexp = 0.8;
q.accwait = 9;




q.accexp = 0.98;


q.infft = {|self, fade=1, pos=0, amp=0.1|
	Ndef(\infftcalc).fadeTime_(fade);
	Ndef(\infftcalc, {
		var in, chain, v, from=0, to=250;
		from =[0,5,10,20,30,40].choose.postcln;
		to = (from +[1,3,10,100,200].choose).max(7).postcln;
		in = SoundIn.ar(0);
		in = In.ar(0);


	})
};

(
SynthDef('dynKlank', {|inBus=0, amp=0.1|
    var in, freqs, ringtimes, signal;
	// in = SoundIn.ar(0);
	in = In.ar(inBus);
	// in = Impulse.ar(2, 0, 0.1);
    freqs = Control.names([\freqs]).kr([800, 1071, 1153, 1723]);
    ringtimes = Control.names([\ringtimes]).kr([1, 1, 1, 1]);
    signal = DynKlank.ar(`[freqs, nil, ringtimes ], in );
    ReplaceOut.ar(0, signal * amp * 0.01);
}).add;
)

a = Synth('dynKlank', target:q.fxGroup, addAction:\addToHead);
a.setn(\ringtimes, Array.rand(4, 0.2, 0.01) );
a.setn(\freqs, [36, 51, 67+12, 72].midicps ); // c
a.setn(\freqs, [24, 36, 67, 72].midicps );
a.setn(\ringtimes, Array.rand(4, 0.2, 0.03) );

a.setn(\freqs, [24, 36, 67, 72].midicps );
a.setn(\ringtimes, Array.rand(4, 0.2, 4) );
a.setn(\freqs, [24, 36, 67, 70].midicps );

// a.setn(\freqs, [36, 47, 48, 60].midicps );
a.setn(\freqs, [36, 48, 67, 60.5].midicps ); // c major

// a.setn(\freqs, (-2 + [36, 48, 67, 72]).midicps ); // d

a.set(\inBus, 0, \amp, 0.2); // acc
a.set(\inBus, 2, \amp, 0.00001); // mic in

s.queryAllNodes
a.free;



s.makeWindow
















//////////////////////////////////////////////////////////////////////////////////////
// q.sineSweep(1, 1) //

q.sineSweep(0.5, 0.8) // kick
q.sineSweep(0.1, 0.2) // hi0
q.sineSweep(0.9, 0.002) // hi
q.sineSweep(0.9, 0.02) // hi

q.sineSweep(0.3, 0.9) // kick

// q.verb; replace
q.fxVerb.set(\mix,0.09, \room,20, \rsize, 10, \damp,0.99, \lo, 1000, \hi, 17000)


q.fxVerb.set(\mix,0.2, \room,20, \rsize, 10, \damp,0.99, \lo, 1000, \hi, 17000)



q.sineSweep(0.5, 0.8) // kick
q.sineSweep(0.1, 0.2) // hi0
q.sineSweep(0.9, 0.002) // hi
q.sineSweep(0.3, 0.9) // kick

// // q.fxVerb.set(\mix,0.9, \room,20, \rsize, 10, \damp,0.8, \lo, 1000, \hi, 17000)
//
// q.sineSweep(0.5, 0.8) // kick
//
// // q.fxVerb.set(\mix,0.9, \room,20, \rsize, 15, \damp,0.8, \lo, 1000, \hi, 1470)
// q.sineSweep(0.9, 0.002) // kick
//
// // q.fxVerb.set(\mix,0.9, \room,20, \rsize, 15, \damp,0.8, \lo, 1300, \hi, 1470)
// q.sineSweep(0.9, 0.002) // kick
// // q.fxVerb.set(\mix,0.9, \room,20, \rsize, 15, \damp,0.8, \lo, 3200, \hi, 3270)
// q.sineSweep(0.9, 0.002) // kick

q.fxVerb.set(\mix,0.3, \room,0.4, \rsize, 0.3, \damp,0.9, \lo, 400, \hi, 17000)

q.sineSweep(0.4, 0.8) // kick

Ndef(\in, {|amp=0.7| SoundIn.ar(0,1) * amp; }).playN([1])

// q.sustainer.free; q.sustainer = nil;
// q.sustainer.set(\keyBus, 0)

// q.infft(fade:1, amp:0.1);
// q.infft = {|self, fade=1, amp=0.1|
//
// 	Ndef(\infftcalc).playN([0]);
//
// 	Ndef(\infftcalc).playN([1]);
// 	// Ndef(\infftcalc).clear;
// 	Ndef(\infftcalc).stop


//////////////////////////////////////////////////////////////////////////////////////
Ndef(\brown).playN([0]);
Ndef(\brown).fadeTime_(0.1).xset(\amp, 0.43)
Ndef(\white).playN([0]);
Ndef(\white).fadeTime_(0.1).xset(\amp, 0.01)

..close
Ndef(\brown).fadeTime_(3).xset(\amp, 0, \ffreq, 100)
Ndef(\white).fadeTime_(3).xset(\amp, 0, \ffreq, 14000)




Ndef(\white).fadeTime_(3).xset(\amp, 0.03, \ffreq, 400)
Ndef(\brown).fadeTime_(3).xset(\amp, 0.7, \ffreq, 400)

Ndef(\white).fadeTime_(3).xset(\amp, 0.03, \ffreq, 1400)
Ndef(\brown).fadeTime_(3).xset(\amp, 0.4, \ffreq, 1400)

Ndef(\brown).fadeTime_(3).xset(\amp, 0.7, \ffreq, 700) // open lo
Ndef(\brown).fadeTime_(3).xset(\amp, 0.5, \ffreq, 400) // close

Ndef(\white).fadeTime_(3).xset(\amp, 0.02, \ffreq, 1000) // open hi
Ndef(\white).fadeTime_(3).xset(\amp, 0.03, \ffreq, 4000) // close

Ndef(\brown).fadeTime_(3).xset(\amp, 0, \ffreq, 100)
Ndef(\white).fadeTime_(3).xset(\amp, 0, \ffreq, 14000)

// Ndef(\white).fadeTime_(0.001).xset(\amp, 0)
// Ndef(\brown).fadeTime_(0.001).xset(\amp, 0)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/*Ndef(\white).clear;
Ndef(\brown).clear;*/

Tdef(\bassaccel).play;


Tdef(\bassaccel).stop;

Tuning filter c groot ? D groot ?

q.accmul = 1;
q.accexp = 0.99;
q.accwait = 4;


Tdef(\bassaccel).stop;

///////////// !!!!!!!!!!
// .. ..::<<
// ..::<<
// ..::<<
// !!!!!!!!!!












































////////////////

(
SynthDef("bass", { arg out, freq, attack=0.01, sustain=1, amp=1, pan;
    var env, u=1, snd;
    env = EnvGen.kr(Env.perc(attack, sustain), 1, doneAction:2);
    5.do { var d; d = exprand(0.999, 1.001); u = SinOsc.ar(d * 100, u, rrand(0.1,1.2) * d, 1) };
	snd = SinOsc.ar( u * freq, 0, amp * env);
	// snd = SinOsc.ar(freq, 0, amp * env);
    Out.ar(out, Pan2.ar(snd, pan));
}).add;
)


Pbindef(\a, \instrument, \bass).play;
Pbindef(\a, \instrument, \bass).stop;
Pbindef(\a, \octave, [1,2,3] + Pstutter(8, Prand([0,1],inf)), \note, Pseq([0, 12], inf), \legato, 0.9);
Pbindef(\a, \attack, 0.01)
Pbindef(\a, \attack, 0.1)
Pbindef(\a, \octave, [2,3] + Pstutter(8, Prand([0,1],inf)), \note, Pseq([0, 12], inf), \legato, 0.9);


Pbindef(\a, \dur, Pn(Pgeom(0.25, 0.96, 10)))
Pbindef(\a, \dur, Pn(Pgeom(0.5, 0.96, 16)))


Pbindef(\a, \dur, Pgeom(0.25, Pbrown(0.99, 1.01, 0.01, inf), inf))
Pbindef(\a, \dur, Pgeom(0.25, Pbrown(0.99, 1.01, 0.01, inf), inf))

Pbindef(\a, \dur, Pgeom(0.25, Pbrown(0.99, 1.01, 0.01, inf), inf))

// a = Pn(Pgeom(0.25, 0.99, 200));
// a.asStream.nextN(200).plot;
// Pbindef(\a, \dur, a)


// Pbindef(\a, \octave, [2,3] + Pstutter(8, Pseq([0,1,2],inf)), \note, Pseq([0, 2, 3, 5, 7, 8, 10, 11], inf), \dur, 4);
// Pbindef(\a, \octave, [2,3] + Pstutter(8, Pseq([0,1,2]+2,inf)), \note, Pseq([0, 2,3,4,5, 7, 9,10 ], inf), \dur, 0.5, \legato, 1);
// Pbindef(\a, \octave, [2,3] + Pstutter(8, Pseq([0,1,2]+2,inf)), \note, Pseq([0,1, 3,4,5, 7,8, 10 ], inf), \dur, 0.5, \legato, 1);

//
// Pgeom(0.125, Pbrown(0.99, 1.01, 0.01, inf), inf).asStream.nextN(100).plot;//
// Pn(Pgeom(0.125, 0.95, 100) + 0.01).asStream.nextN(200).plot;
// var a;
// a = Pgeom(1.0, 1.1, inf);
// a.asStream.nextN(100).plot;

// Pbindef(\a, \dur, 0.1);
// Pbindef(\a, \degree, Pseq([1b, 5, 3, 1b, 6, 2, 5, 0, 3, 0, 2], inf));
// Pbindef(\a, \legato, Prand([1.0, 2.4, 0.2], inf), \mtranspose, -3);
// Pbindef(\a, \mtranspose, nil); // remove key

// Pbindef(\a, \degree, Pseq([1, 2, 3, 4, 5, 6], 1));
// Pbindef(\a, \degree, Pseq([1, 2, 3, 4, 5, 6], 3), \dur, 0.02);
// Pbindef(\a, \degree, Pseq([1, 2, 3, 4, 5, 6], 3), \dur, 0.1);
//
// // apart from this Pbindef behaves like Pdef:
//
// Pbindef(\a).quant = 0.0;
// Pbindef(\a, \degree, Pseq([1, 2, 3, 4, 5, 6], 1));
//
// Pbindef(\a).stop;
// Pbindef(\a, \degree, Pseq([1, 2, 3, 4, 5, 6], 1)); // does not resume now
//
// Pbindef(\a).playOnce; // play single instance
