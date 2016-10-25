DocuServer.killAll;
"/Users/a/dev/versioned/scwork/_lastfiles.scd".load;
TODO_:

BUGS:

FEATURES:

• preset
	postSettings
	storeDialog |name, loc| 		// check before overwriting a setting?
	deleteDialog |loc|
	specsDialog |keys, specDict|
	preset autoread ?

• guess specs from Specs.spec[key]
• set bus / out
• store/recall presets
• KtlLoop
• Pbindefs !
• ? Influx


* PhaseScope
* fs text

///////////////////////////////////////

NdPlay.nk.elementGroup
NdPlay.nk.elementsDict.keys
• fullscreen
• scope

Server.killAll;
s.quit;

fullscreen
phasescope



PavillionArc2.free; PavillionArc2.init; PavillionArc2.play;

p = PhaseScope.new(s, bounds: Window.screenBounds);

PavillionArc2.t.set(\aconst,0, \afact,0,\bconst,0, \bfact,0);


PavillionArc2.t


////////////////////////////////////////////////

a = NdPlay.new; // default sine


a.tdef
a.ndef





a.replace(
	{|freq=110, pmspeed=0.01,pmdepth=0| SinOsc.ar(freq*[1,0.5], SinOsc.ar(pmspeed.lag3(1)*[1,0.5],0,pmdepth*[pi, pi.neg])) },
	[
	[\pmspeed, [0.0001, 100, \exp, 0.001, 0.0001]],
	[\pmdepth, [-1, 1, \lin, 0.01, 0]]
	]
)

////////////////////////////////////////////////

(
c = NdPlay(s,
	Ndef(\test, {
		|freq=250, intv=19, timescale=1, curve=0, loopnode=0, formfact=2, widfact=0.5, spread=1|
		var env = EnvGen.kr(
			Env(
				{ 1.0.rand2 }!11,
				{1.0.rand}!10 * timescale,
				curve,
				releaseNode: 9,
				loopNode: loopnode)
		);
		var pitch = (env * [1, 0.33, -1] * intv).midiratio * freq;
		Splay.ar(
			Formant.ar(pitch, pitch.scramble * formfact, pitch.scramble * widfact), spread);
	}).play,
	specs:[
		[\intv, [0, 36, \lin].asSpec],
		[\timescale, [0.001, 10, \exp].asSpec],
		[\curve, [-10, 10].asSpec],
		[\loopnode, [0, 7, \lin, 1].asSpec],
		[\formfact, [0.1, 10, \exp].asSpec],
		[\widfact, [0.1, 10, \exp].asSpec],
		[\spread, \unipolar.asSpec]
	],
	set:0
));






////////////////////////////////////////////////






Ndef(\best,{|freq=440, pmspeed=0.01,pmwidth=0.5, amp=0.5| Pulse.ar(freq, [0, SinOsc.kr(pmspeed,0, pmwidth)], amp) });
Ndef(\best).addSpec(\pmwidth, [0, 1, \lin, 0.01, 0.5]);
Ndef(\best).addSpec(\pmspeed, [0, 4, \lin, 0.001, 0]);
b = NdPlay(s, Ndef(\best), 1)

(
b.replace(
	obj:{|freq=440, pmspeed=0.01, pmwidth=0.5, ffreq=1000, amp=0.5|
		LPF.ar(
			Pulse.ar(freq, [0, SinOsc.kr(pmspeed,0, pmwidth)], amp),
			ffreq
		)

	},
	argSpecs:[
		[\pmspeed, [0.001, 2, \exp, 0.001, 0.1]],
		[\pmwidth, [0, 1, \lin, 0.01, 0.5]]
	]
))


b.presetGui.proxyGui.paramGui.drags[0].background_(Color.black)


b.ndef.set( \freq, 120 )
b.preset.addSet( \set2 )
b.preset.addSet( \set3 )

b.preset.setCurr( \set1 )

b.preset.xfadeTo( \set2, 20 )
b.preset.xfadeTo( \set1, 20 )
b.preset.xfadeTo( \set3, 20 )


///////////////////////////////////////

// default sine
a = NdPlay.new;

a.bus;

/////////////////////

(
b = NdPlay(
	s,
	ndef: Ndef(\best,{|freq=440, pmspeed=0.01,pmwidth=0.5|
		Pulse.ar(freq, [0, SinOsc.kr(pmspeed,0, pmwidth)])
	}),
	set:1,
	specs:[[\pmwidth, [0, 0.5, \lin, 0.01, 0.5]], [\pmspeed, [0.001, 100, \exp, 0.001, 0.01]]]
)
)

/////////////////////

(
c = NdPlay(s,
	Ndef(\test, {
		|freq=250, intv=19, timescale=1, curve=0, loopnode=0, formfact=2, widfact=0.5, spread=1|
		var env = EnvGen.kr(
			Env(
				{ 1.0.rand2 }!11,
				{1.0.rand}!10 * timescale,
				curve,
				releaseNode: 9,
				loopNode: loopnode)
		);
		var pitch = (env * [1, 0.33, -1] * intv).midiratio * freq;
		Splay.ar(
			Formant.ar(pitch, pitch.scramble * formfact, pitch.scramble * widfact), spread);
	}).play,
	specs:[
		[\intv, [0, 36, \lin].asSpec],
		[\timescale, [0.001, 10, \exp].asSpec],
		[\curve, [-10, 10].asSpec],
		[\loopnode, [0, 7, \lin, 1].asSpec],
		[\formfact, [0.1, 10, \exp].asSpec],
		[\widfact, [0.1, 10, \exp].asSpec],
		[\spread, \unipolar.asSpec]
	],
	set:2
));

// c.createControl(c.ndef, c.set);




////------------

Spec.add(\pos, [-1, 1, \lin, 0, 0]);
Ndef(\well,{|freq=440, pos=0, amp=0.1| Pan2.ar(SinOsc.ar(freq), pos, amp) })
c = NdPlay(s, Ndef(\well), 1);



////------------

(
Tdef(\test).set( \waittime, 1);
Tdef(\test).addSpec(\waittime, [0.125, 1]);
Tdef(\test,{|env|
	inf.do{|i|
		i.postln;
		env.waittime.wait;
	}
}).play
)

Tdef(\test).set( \waittime, 2);

c.nk.elAt(\sl, 0).action = { |sl|
	Tdef(\test).set(\waittime, sl.value.linlin(0, 1, 0, 2)); // equal distribution of buffer indices
};

MKtl('mynk').elAt(\sl, 0).action = { |sl|
	// every step of a 128 value MIDI device (typical) reads one buffer.
	Tdef(\lindsey).set(\buf, sl.value.linlin(0, 1, 0, 127) % 12);
};
