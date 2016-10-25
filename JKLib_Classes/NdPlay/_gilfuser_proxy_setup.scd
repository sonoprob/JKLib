GIL FUSER

I would like to ask:
1 - is it possible to have the control proxies like I have parameters in a
NdefGui? So I could see, move and map them to a physical midi controller. In
the ProxyMixer I can see and control just one at a time, and I think is not
possible to map anything.
Would be better for that to transform the SynthDef in a Ndef? If so, Is
there a way to make it work with a Pbind?

2- how to change the way the way the faders in the ProxyMixer behave? limit
the minimum and maximum values, or make them change in integer values? Well,
if the answer for the first question is a "yes", this may be not needed.



To start the conversation here is what I have:


SETUP:
// I took out what seemed not the minimum needed to make it work.

(

b = AllGui(12);

s.waitForBoot({
	q.postServerOptions;
	ProxyMeter.addMixer(q.pxmix);
});

p = Ndef.dictFor(s); p.push;
q = q ? ();

~kaos = 0.125.explin(0.00625, 2.5, 0.00625, 2.5);
~bpm = 120.0;
~bpm.fadeTime = 1;
~div = 4;

p.makeTempoClock(~bpm.source/60); p.quant = (60/~bpm.source *4);
q.pxmix = NdefMixer(s, 12);
q.pxmix.skipjack.dt = 0.05;
q.pxmix.moveTo(5, 5)
);

(
//////////-----------------------  THE PROCESSES. (In the original is in
another file)  ----------//////////////////////////////

// "2_processes/tambores*".loadRelative;


(
SynthDef(\tambores, {
	arg out=0, /*gate=1,*/ atk=0.001, freq=440, nharms=10,amp=0.5, pan=0,
sustain=0.2, bwR=0.1, rin=4;
	var sig, env, sigRin;
	sig = PinkNoise.ar(amp);
	env = EnvGen.kr(Env([0,amp,0],[atk, sustain], [8,-8]), /*gate,*/
doneAction:2);
	sig = Pan2.ar(sig, pan);
	sigRin = Ringz.ar(sig, freq, 1/bwR);
	sig = sig * env;
	sigRin = sigRin * env;
	sig = (sig * rin)*3 + (sigRin * rin.reciprocal)/2;
	OffsetOut.ar(out, sig)
}).add;
);

// scale
a = Scale.choose(7, 12).tuning_(Tuning.choose(12));
// this values here are to be used as degrees in the Pbinds.
n =
Pseq(#[[[0,-5],[5,-5]],[[-3,7],3.2,-3],-5,11,[0,9],[7,-9,[-3,3]],[11,0,3],-3,[5,-5,0,-7],
5,11,0,-3], inf);

Pdefn(\stretch, Pfunc({ 60/~bpm.source *4 / ~div.source}, inf));
Pdefn(\sustain, Pexprand(0.075, 3));
Pdefn(\strum,
Pwrand([1/6,1/12,1/24,1/4,2/5,-1/12],[6,8,1,3/2,1,2].normalizeSum, inf) /
(Pfunc({ ~kaos.source.reciprocal}, inf) * Pwhite(0.95,1.05)));
Pdefn(\dur, Pseq([Pn((1),1)/Pwhite(0.95,1.05),
Pn((1/2),6)/Pwhite(0.95,1.05)],inf));

Pdefn(\degree, n);
Pdefn(\scale, Pfunc({ a.source }, inf));
Pdefn(\detune, Pwhite(-12.0, 12.0));

(
Ndef(\tambN,
	Pbind(
	\instrument, \tambores,
	\bwR, Pwhite(1.1, 6.0),
	\rin, Pwhite(0.4, 3.0),
	\atk, Pseq( [Pwhite(0.002,0.01,2), Pn(Pswitch1( [Pwhite(0.002,0.02),
Pwhite(0.2,4)], Pfunc{ 0.1.coin.binaryValue }),6)] , inf),
//// rhythm
	\stretch, Pdefn(\stretch),
	\sustain, Pdefn(\sustain),
	\strum, Pdefn(\strum),
	\legato,1,
	\dur, Pdefn(\dur),
//// melody
	\scale, Pdefn(\scale),
	\degree, Pdefn(\degree),
	\detune, Pdefn(\detune),

	\amp, Pseq([0.2, Pwhite(0.05, 0.1,7)], inf),
	\pan, Pwhite(-0.8, 0.8)
)
).quant_(60/~bpm.source *4).fadeTime = 0.2;
);


///////////--------------------- END of the process part
----------//////////////////////

// get the 4 ndefs by name
q.ndefs = q.getNdefs.sort { |px1, px2| px1.key < px2.key }
);

// make 4 NdefGuis for them
// these show changes for all of them
(
q.ndgwin = Window("The 4 Ndefs", Rect(600, 0, 400, 800),scroll:true).front;
q.ndgwin.addFlowLayout;
q.ndefGuis = q.ndefs.keep(8).collect { |px, i|
	var gui = NdefGui(px, 8, q.ndgwin);
	q.ndgwin.view.decorator.nextLine.shift(0, 10);
	gui.skipjack.dt = 0.03;
	gui;
};
q.ndgwin.bounds = q.ndgwin.bounds.moveTo(450, 500);
);