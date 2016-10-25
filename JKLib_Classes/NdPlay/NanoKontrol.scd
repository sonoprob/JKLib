NanoKontrol

a=Search()
a.find("nano")
a.findFilenames("nano")



"open /Applications/Pd-extended.app/Contents/Resources/extra/Pd_leapmotion_0.1_mac/leap_osc_jk3.pd".unixCmdGetStdOut;

a={1.0.rand}!8
b
ArrayedCollection

SCDoc.indexAllDocuments

interpolation (size, start: 0, end: 1)

Menu

NanoKontrol

the values that ProxyMixer sends to proxies are not smoothed;
the NanoKtl class uses the softSet method to avoid control jumps
when the physical controls are far away from the current control values.
(like in MIDI apps, soft takeover)

Maybe useful to know here: I just added a new scheme for handling specs
for proxies to JITLibExtensions, which keeps separate for each proxy.
This avoids accidental overrriding of specs when using the same control name.

p = ProxySpace.push;
~a = { | goesToEleven  = 2| Blip.ar(goesToEleven) };
~a.addSpec(\goesToEleven, [1, 11, \lin]);



Actually it would be worth writing a TouchOSC quark that can send proxymixer
info to touchosc for display - and likely setting values from touchosc should be
in normalized range, mapped in SC, and sent back to TouchOSC for numerical
display ...


the easiest is to lag the proxy controls:

Ndef(\a, { |freq = 200| Pulse.ar(freq, 0.62) * 0.1 }).play;

	// simulate fader move - steps
fork {
	loop {
	(20..100).do { |val|
		Ndef(\a).set(\freq, \freq.asSpec.map(val/127));
		0.1.wait;
	} }
};
	// lag as much as needed
Ndef(\a).lag(\freq, 0.1);

===
in the current version of JITLibExtensions, you can also addSpecs to a proxy,
and change them on the fly:

Ndef(\a).lag(\freq, 0.1);

fork {
	loop {
	(20..100).do { |val|
		Ndef(\a).setu(\freq, val/127);
		0.1.wait;
	} }
};
	// change at any time
Ndef(\a).addSpec(\freq, [200, 2000]);

Ndef(\a).addSpec(\freq, [50, 5000]);



Ok, I'm already doing it...

For the proxycontrols coming from the rotary controls on the nanokontrol.

But I'd like to lag the volume in proxymixer...

ok, I see. That synthdef lives in SystemSynthDefs:initClass,
and by default, it has a lag time of 0.05 on the vol parameter.

You could replace those with your own system SynthDefs,
and set their default to a value you like:

 (1..SystemSynthDefs.numChannels).do { arg i;
	 SynthDef("system_link_audio_" ++ i, { arg out=0, in=16, vol=1, doneAction=2;
		 var env; env = EnvGate( doneAction:doneAction, curve:'sin') * Lag.kr(vol, 0.25);
		 Out.ar(out, InFeedback.ar(in, i) * env)
	 }, [\kr, \ir, \kr, \kr, \ir]).add;
 };

Making lag changeable while playing would require adding methods to Monitor,
which you could also do if you like.
