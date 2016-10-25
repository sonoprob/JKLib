(
// Ndef(\sinesweep1).clear;
// Ndef(\sinesweep2).clear;
Ndef(\sinesweep1).group = PavillionArc2.group;
Ndef(\sinesweep2).group = PavillionArc2.group;
Ndef(\sinesweep1).play;
Ndef(\sinesweep2).play;

Ndef(\sinesweep1,{|t_trig=1, a=1, b=0, amp=0.2|
	var env, att=0.0001, rls=0.001, snd;
	var freq = a.linexp(0,1,100,1000);
	var dur = b.linexp(0,1,0.0001,0.1);
	// var env=XLine.kr(1, 0.0001, dur, doneAction:2);
	env = EnvGen.kr( Env.perc, t_trig, timeScale:dur, doneAction:0);
	SinOsc.ar(env * freq, 0 , env * amp);
});

Ndef(\sinesweep2,{|t_trig=1, a=1, b=0, amp=0.2|
	var env, att=0.0001, rls=0.001, snd;
	var freq = a.linexp(0,1,1000,100);
	var dur = b.linexp(0,1,0.1,0.001);
	// var env=XLine.kr(1, 0.0001, dur, doneAction:2);
	env = EnvGen.kr( Env.perc, t_trig, timeScale:dur, doneAction:0);
	SinOsc.ar(env * freq, 0 , env * amp);
});

)

Ndef(\sinesweep1).set(\t_trig, 1, \a, 0.3, \b, 0.099, \amp, 1);

// s.scope
// s.queryAllNodes;

// SynthDef(\sinesweep2, { arg outBus=0, a=1, b=0, amp=0.2;
//
// 	Out.ar(outBus, snd);
// }).add;
//
// SynthDef(\sinesweeprev, { arg outBus=0, a=1, b=0, amp=0.2;
// 	var snd, freq = a.linexp(0,1,100,1000);
// 	var dur = b.linexp(0,1,0.001,7);
// 	var env=XLine.kr(0.0001, 1, dur, doneAction:2);
// 	snd = SinOsc.ar(env * freq, 0 , env * amp);
// 	Out.ar(outBus, snd);
// }).add;
//
// SynthDef(\sinesweeplong, { arg outBus=0, a=1, b=0, amp=0.2;
// 	var snd, freq = a.linexp(0,1,10,1000);
// 	var dur = b.linexp(0,1,0.001,60);
// 	var env=XLine.kr(1, 0.0001, dur,doneAction:2);
// 	snd = SinOsc.ar(env * freq, 0 , env * amp) ! 2;
// 	Out.ar(outBus, snd);
// }).add;



PavillionArc2.t.set( 'deccelaration', 0, 'accwait', 8, 'aconst', 0.25, 'accmul', 1,
	'accexp', 0.90742604970932, 'wrap', true, 'accamt', 64, 'regular', 1, 'doubleAcceleration', false,
	'bconst', 1, 'accelaration', 0, 'bfact', 0.003, 'afact', 0.001
)

;

(
// Tdef(\PavillionArc2)
PavillionArc2.t.set(
	\accamt, 64,
	\accexp, rrand(0.9, 0.99),
	\accwait, 1,
	\accmul, 1,
	\aconst, 0.25,
	\bconst, 1,
	\afact, 0.001,
	\bfact, 0.003,
	\wrap, true,
	\accelaration, 0,
	\deccelaration, 0,
	\regular, 1,
	\doubleAcceleration, false,

	\accamt, 64,
	\accexp, rrand(0.9, 0.99),
	\accwait, rrand(1, 9),
	\accmul, 1,
	\aconst, 0.25,
	\bconst, 1,
	\afact, 0.001,
	\bfact, 0.003,

	\accamtd, 0.1,
	\accexpd, 0.1,
	\accwaitd, 0.1,
	\accmuld, 0.1,
	\aconstd, 0.1,
	\bconstd, 0.1,
	\afactd, 0.1,
	\bfactd, 0.1,

	\wrap, true,
	\accelaration, 0,
	\deccelaration, 0,
	\regular, 1,
	\doubleAcceleration, false
)
)

;

(
Tdef(\PavillionArc2,{|env|
	var a, b, amp, delta;
	env.accamt = 4;
	env.accexp = rrand(0.9, 0.99);
	env.accwait = rrand(1, 9);
	env.accmul = 1;
	env.aconst = 0.25;
	env.bconst = 1;
	env.afact = 0.001;
	env.bfact = 0.003;
	env.wrap = true;
	env.accelaration = 0;
	env.deccelaration = 0;
	env.regular = 1;
	env.doubleAcceleration = false;

	inf.do{
		env.accamt.do{| i |
			a = env.aconst + (i * env.afact);
			b = env.bconst - (i * env.bfact);

			if(env.wrap){
				a = a.wrap(0,1);
				b = b.wrap(0,1);
			}{
				a = a.fold(0,1);
				b = b.fold(0,1);
			};

			amp = exprand(0.3,8);
			// Synth(\sinesweep1,[\a, a, \b, b, \amp, amp ], target:PavillionArc2.group);
			// Synth.grain(\sinesweep1,[\a, a, \b, b, \amp, amp ], target: PavillionArc2.group, addAction: \addToHead);

			Ndef(\sinesweep1).set(\t_trig, 1, \a, a, \b, b, \amp, amp);

			amp = exprand(0.3,8);
			// Synth(\sinesweeplong,[\a, a, \b, b, \amp, amp/2], target:PavillionArc2.group);
			// Synth(\sinesweeprev,[\a, a, \b, b, \amp, amp ], target:PavillionArc2.group);
			// Synth(\sinesweep2,[\a, a, \b, b, \amp, amp ], target:PavillionArc2.group);
			// Synth.grain(\sinesweep2,[\a, a, \b, b, \amp, amp ], target: PavillionArc2.group, addAction: \addToHead);

			Ndef(\sinesweep2).set(\t_trig, 1, \a, a, \b, b, \amp, amp);

			delta = (env.accmul * (0.5 * ( env.accexp ** i)));

			if( env.doubleAcceleration == true ){
				delta = delta *
				[ (1/(1.618 ** i)), (1/(0.618 ** i)/40), 1]
				.wchoose(
					[ env.acceleration, env.deccelaration, env.regular].normalizeSum
				);
				delta.wait
			}{
				delta.wait
			};

			// delta.wait


		};

		(env.accwait * [0.5,1,1,2,3].choose).wait;
	}
});
)