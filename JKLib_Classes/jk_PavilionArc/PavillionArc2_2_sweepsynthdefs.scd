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


/////////////////


		SynthDef(\sinesweep1, { arg outBus=0, a=1, b=0, amp=0.2;
			var env, snd, freq = a.linexp(0,1,100,1000);
			var dur = b.linexp(0,1,0.0001,0.1);
			env=XLine.kr(1, 0.0001, dur, doneAction:2);
			// env=EnvGate(1, 1, dur/2, doneAction: 2, curve: 'sin');
			//env = EnvGen.kr( Env.perc(0.1,0.1), 1, 0, dur, 2);
			snd = SinOsc.ar(freq, 0 , env * amp);
			Out.ar(outBus, snd);
		}).add;


		SynthDef(\sinesweep1, { arg outBus=0, a=1, b=0, amp=0.2;
			var env, snd, freq = a.linexp(0,1,100,1000);
			var dur = b.linexp(0,1,0.001,7);
			//env=XLine.kr(1, 0.0001, dur, doneAction:2);
			// env=EnvGate(1, 1, dur/2, doneAction: 2, curve: 'sin');
			env = EnvGen.kr( Env.asr( 0.1, 1.0, 0.5, \welch ), 1, 0, dur, 2);
			snd = SinOsc.ar(env * freq, 0 , env * amp);
			Out.ar(outBus, snd);
		}).add;
