Ndef -> filter
Ndef -> fx/out/post

schreck
4 channels
bells
delays
detuning
spinning

// s.boot;


// filtering: the first argument is the previous bus content. more args can be used as usual.


Ndef(\test)[1] = \filter -> { arg in; in * MouseY.kr(0,1) };
Ndef(\test)[2] = \filter -> { arg in; in * SinOsc.ar(Rand(100,1000)) };
Ndef(\test)[2] = \filter -> { arg in; in * SinOsc.ar(ExpRand(1,5)).max(0) };


// setting controls
a.fadeTime = 2.0;
a.source = { arg f=400; SinOsc.ar(f * [1,1.2] * rrand(0.9, 1.1), 0, 0.1) };
a.set(\f, rrand(900, 300));
a.set(\f, rrand(1500, 700));
a.xset(\f, rrand(1500, 700)); // crossfaded setting
a.source = { arg f=400; RLPF.ar(Pulse.ar(f * [1,1.02] * 0.05, 0.5, 0.2), f * 0.58, 0.2) };

// control lags
a.lag(\f, 0.5); // the objects are built again internally and sent to the server.
a.set(\f, rrand(1500, 700));
a.lag(\f, nil);
a.set(\f, rrand(1500, 700));



(

CmdPeriod.doOnce({ p.win.close; g.parent.close; h.parent.close; /*~win.close*/ });

s.queryAllNodes;
// try{  /*~ps.close;*/ ~win.close; };

~skin = (
	fontSpecs:         ["Helvetica", 10],
	fontColor:         Color(1),
	background:     Color.grey(0.4,0.5),
	foreground:     Color.black(1,1),
	onColor:        Color.grey(0.5, 1),
	onColor2:       Color(0.0, 0.5, 0.5),
	offColor:        Color.grey(0, 0),
	hiliteColor:    Color.green(1.0, 0.5),
	gap:            0 @ 0,
	margin:         2@2,
	buttonHeight:   16,
	headHeight:     16
);

// GUI.skins.put(\jit, ~skin);
// GUI.skins.put(\jitsmall, ~skin);
// GUI.setSkin(\jit);

GUI.setSkin(\redFrik);

/// Set[ default, jitSmall, redFrik, jit, crucial, dewdrop, jkdark ]

s.waitForBoot{


	p = PhaseScope.new(s, bounds: Window.screenBounds);
	// p.scopeView.style_(2).xZoom_(1).yZoom_(1);

	// ~winbounds = Rect(10,10,400,800);
	~winbounds = Rect(1280, 228, 400, 800);
	~win = Window.new(bounds: ~winbounds, border:true);
	~win.background_(Color.grey(0,0));
	~win.alwaysOnTop_(true);
	~win.addFlowLayout;

	SynthDef(\pingbend,{ arg out=0, freq=440, bend = 4, sustain=0.05, phMul=0, panMul=0, amp=1;
		var env = EnvGen.ar(Env.perc(0.001, sustain, 0.3), doneAction:2);
		freq = freq * XLine.kr(1, bend.midiratio, sustain);
		Out.ar(out,
			Pan2.ar(
				SinOsc.ar(freq, [0,phMul*Rand(pi.neg,pi)], env),
				panMul*Rand(-1,1).round(0.25),
				amp
			)
		)
	}).add;

	Tdef(\a, { |env|
		loop({
			// Ndef(\test).set(\freq, env[\freq] / 2);
			(
				instrument: \pingbend,
				freq:  env[\freq],
				bend: env[\bend] + env[\bendVar].rand2,
				sustain: env[\sustain],
				pan: 1.0.rand2,
				amp: env[\amp]
			).play;
			env[\dt].wait;
		})
	}).play;

	Ndef(\test,{|freq=440, ms=0.01,md=0, pos=0,amp=0.5|
		var snd = SinOsc.ar(freq, [0, SinOsc.kr(ms,0,md*pi)], amp);
		snd
	}).play;

	//////////////////////////////

	a = Tdef(\a);
	a.set(\dt, 0.1, \freq, 440, \bend, 4, \bendVar, 4, \sustain, 0.05, \amp,1);
	a.addSpec(\dt, [0.03, 3, \exp]);
	a.addSpec(\bend, [-24, 24, \lin]);
	a.addSpec(\bendVar, [-24, 24, \lin]);
	a.addSpec(\sustain, [0.003, 3, \exp]);
	a.addSpec(\phMul, [-1, 1, \lin]);
	a.addSpec(\panMul, [-1, 1, \lin]);
	a.addSpec(\amp, [0, 1, \lin]);
	b = ProxyPreset(a);
	b.setRand(0.25); b.addSet(\bobo);


	c = Ndef(\test);
	c.addSpec(\ms, [0, 4, \lin, 0.001, 0]);
	c.addSpec(\md, [-1, 1, \lin, 0.1, 0]);
	c.addSpec(\pos, [-1, 1, \lin, 0.1, 0]);
	//	*new { |key, namesToStore, settings, specs, morphFuncs|
	d = NdefPreset(c);

	//////////////////////////////


	// *new { |object, numItems = (0), parent, bounds, makeSkip = true, options = #[]|
	g = TdefPresetGui(b, 8, ~win); // .moveTo(0, 400);
	h = NdefPresetGui(d, 8, ~win);

	~win.front;
	g.parent.background_(Color.grey(0,0));
	g.proxyGui.parent.background_(Color.grey(0,0));
	g.proxyGui.envirGui.parent.background_(Color.grey(0,0));
	// g.proxyGui.envirGui.zone.background_(Color.grey(0,0));


	h.parent.background_(Color.grey(0,0));
	h.proxyGui.parent.background_(Color.grey(0,0));
	h.proxyGui.zone.background_(Color.grey(0,0));


	s.queryAllNodes;

	h.skipjack.dt = 0.05; // faster updates


	Spec.add(\ms, [0, 4, \lin, 0.001, 0]);
	Spec.add(\md, [-1, 1, \lin, 0.1, 0]);
	Spec.add(\pos, [-1, 1, \lin, 0.1, 0]);
	Spec.add(\dt, [0.03, 3, \exp]);
	Spec.add(\bend, [-24, 24, \lin]);
	Spec.add(\bendVar, [-24, 24, \lin]);
	Spec.add(\sustain, [0.003, 3, \exp]);
	Spec.add(\phMul, [-1, 1, \lin]);
	Spec.add(\panMul, [-1, 1, \lin]);

	Spec.add(\ms, [0, 4, \lin, 0.001, 0]);
	Spec.add(\md, [-1, 1, \lin, 0.1, 0]);
	Spec.add(\pos, [-1, 1, \lin, 0.1, 0]);

	q = q ? ();
	q.nk = MKtl(\nk1, "korg-nanokontrol");


	// q = q ? ();
	// q.nk = MKtl(\nk1, "korg-nanokontrol");
	// q.nk.gui;
	// q.ndgui = NdefGui(Ndef(\test), 5);
	// // h = NdefPresetGui(d, 8, ~win);
	// q.ndgui.skipjack.dt = 0.05; // faster updates



	// use last knob for volume control:
	q.nk.elAt(\kn)[0].last.action = { |el|
		Ndef(\test).softVol_(
			\amp.asSpec.map(el.value),
			lastVal: \amp.asSpec.map(el.prevValue)
		);
	};

	q.mapElemGroupToProxyParams = { |q, group, proxy, keys|
		keys = keys ?? { proxy.controlKeys };
		group.do { |el, i|
			var parKey = keys[i];
			if (parKey.notNil) {
				el.action = {
					var spec = parKey.asSpec;
					// "val: % prev: % diff: %\n.".postf(el.value, el.prevValue);
					proxy.softSet(parKey,
						spec.map(el.value),
						within: 0.025,
						lastVal: spec.map(el.prevValue)
					)
				};
			}
		}
	};

	// and again, use first 7 knobs for first seven params,
	// now with softSet:
	q.mapElemGroupToProxyParams(
		q.nk.elAt(\kn)[0].keep(8),
		Ndef(\test);
	);

	// Tdef???
	// ???
	// q.mapElemGroupToProxyParams(
	// 	q.nk.elAt(\kn)[1].keep(8),
	// 	Tdef(\a),
	// 	[\amp, \bend, \bendVar, \dt, \freq, \sustain]
	// );
	//

	// a.checkSpecsMissing(dialog: true);

	// ADD Modality / flexibility:
	// make a single function that does all this in one step,
	// so you can easily switch between proxies:

	q.setNkProxy = { |q, proxy|
		if (proxy.notNil) {
			q.nkProxy = proxy;

			// use first 7 knobs for first seven params:
			q.mapElemGroupToProxyParams(
				q.nk.elAt(\kn)[0].keep(8),
				q.nkProxy
			);
			// use last knob for volume control:
			q.nk.elAt(\kn)[0].last.action = { |el|
				q.nkProxy.vol_(\amp.asSpec.map(el.value));
			};

			// add play and stop buttons
			// q.nk.elAt(\play).action = { |el| q.nkProxy.play; };
			// q.nk.elAt(\stop).action = { |el| q.nkProxy.stop; };
		};
	};

	q.setNkProxy(Ndef(\test)); // as before

};

)
