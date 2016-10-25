schreck
4 channels
bells
delays
detuning
spinning

leap motion / multitouch



Ndef(\b).set(\freq,1200)
Ndef(\b,{|freq=440, ms=0.01,md=0, pos=0,amp=0.5|
	var snd = SinOsc.ar(freq, [0, SinOsc.kr(ms,0,md*pi)], amp);
	snd
}).playN([0,1]);

// q.scopeSynth.set(\inBus, 0, \buffer, 0)

q.style_(2)
q.style_(1); q.scopeView.waveColors_([Color.blue(0.4,0.7), Color.blue(1,0.3)])
p.scopeView.waveColors_([Color.grey(1,0.4), Color.grey(1,0.4)])
q.scopeView.waveColors_([Color.grey(1,0.3), Color.grey(1,0.3)])
q.scopeView.xZoom_(0.2).yZoom_(0.3)

p.scopeView.xZoom_(1).yZoom_(1)

q.scopeSynth
q.scopeSynth.set(\inBus, 3)

q.scopeView.dump
q.scopeSynth.dump
known issue, see e.g.
https://www.listarc.bham.ac.uk/lists/sc-dev/msg55658.html

my fault, still no time to sync jitlib extensions to updates in current master.
//
easiest temp fix:
copy JITLib/GUI folder from 3.7.1 and put it in SCClassLibrary of 3.7.2.

sorry for the inconvenience, it is high on my guilt list already,
adc




// Ndef(\a,{|freq=440, ms=0.01,md=0, pos=0,amp=0.5| var snd = SinOsc.ar(freq);
// 	pos = SinOsc.kr(ms,0,md) * pos;
// 	Pan2.ar(snd, pos, amp);
// }).play;


		// morph between its current and target setting:
b.morph(1.0.rand);
b.morph(1.0.rand);

		// morph between two named settings:
b.morph(1.0.rand, \ada, \coco);

		// xfade to a given setting from current setting:
b.xfadeTo(\coco, 3, { "xfade doneFunc done.".postln; });
b.xfadeTo(b.getSetNames.choose.postln, exprand(0.3, 10));


/////////////////////////////////

// check if all specs are present:
b.checkSpecsMissing;
// get a dialog if any are missing:
b.checkSpecsMissing(dialog: true);
check if again all specs are present:
b.checkSpecsMissing; // quiet means all fine


// the param names for which settings are stored
b.namesToStore;
(
// make a ParamGui to read along changes to the settings
d = ParamGui(a.envir).moveTo(10, 10);
// and connect it to the proxy's halo,
// so it will use the orderedNames used there
d.useHalo(a);
)

a.envir;
a.controlKeys;


b.setRand(0.25); b.addSet(\coco);
b.someRand(0.25, 0.5); b.addSet(\dad);
)

// print them all
b.settings.printcsAll;"";
b.getSetNames;

// and set current and target to two random choices
b.setCurr(b.getSetNames.choose.postln);
b.setTarg(b.getSetNames.choose.postln);


*/
//////////////////////////////////////////////////////////////////////

// ~lb = Rect(0,0,~bo.width/2,~bo.height/2);
// ~rb = Rect(~bo.width/2,0,~bo.width/2,~bo.height/2);
// p = PhaseScope.new(s, bounds:~lb);
// q = PhaseScope.new(s, bounds:~rb);
NdefMixer(s)
s.boot;

p = PhaseScope.new(s, bounds: Window.screenBounds);
q = PhaseScope.new(s, bounds: Window.screenBounds);

p.waveClrs_([Color.blue, Color.blue])

p.scopeView.style_(2).xZoom_(1).yZoom_(1);


(

CmdPeriod.doOnce({ p.win.close; q.win.close; ~win.close });

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

GUI.skins.put(\jit, ~skin);
GUI.skins.put(\jitsmall, ~skin);

// ~skin = (
// 	'background': Color.grey(0,0),
// 	'gap': Point( 0, 0 ), 'margin': Point( 2, 2 ),
// 	'fontColor': Color.white(1,1),
// 	'foreground': Color(0.95, 0.95, 0.95),
// 	'offColor': Color(0.0, 0.0, 0.0, 0.0),
// 	'buttonHeight': 16,
// 	'fontSpecs': [ "Helvetica Light", 10 ],
// 	'onColor': Color(0.5, 1, 0.5)
// );
//
// GUI.skins.put(\jitSmall, ~skin);
// GUI.skins.put(\jit, ~skin);
/// Set[ default, jitSmall, redFrik, jit, crucial, dewdrop, jkdark ]

GUI.setSkin(\jit);

s.waitForBoot{
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
			Ndef(\a).set(\freq, env[\freq] / 2);
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

	Ndef(\a,{|freq=440, ms=0.01,md=0, pos=0,amp=0.5|
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


	c = Ndef(\a);
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

};
)

/*


// do recursive crossfading
(
f = {
	    "next xfade: ".post;
	    b.xfadeTo(b.getSetNames.choose.postln, exprand(0.3, 10), f)
};

f.value;
		)
f = nil; // stop


*/