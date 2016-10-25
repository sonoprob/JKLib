s.reboot
Server.killAll

//////////////
TODO:
• example tdef
• example tdef help (tdef as time pattern for pdef/pbind)


// defaults
a = NdtPlay();

a.clear;

// a.replace(Ndef(\default,{ SinOsc.ar }))
a.replace(Ndef(\default,{|freq=200| SinOsc.ar(freq) }))
BUG:
- FAILURE IN SERVER /s_new duplicate node ID
- freq slider not visible

a.tdef.envir = (waittime0: 2);
a.replace(Tdef(\default,{|env| inf.do{|i| i.postln; env.waittime0.wait } }))


NdtPlay.all
NdtPlay.createWindow;


(
b = NdtPlay(s,
	ndef: Ndef(\test, {
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
	set:1
))


