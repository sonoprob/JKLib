/***
JITLib is a library within SuperCollider that allows creating proxies (placeholders) for sounds (Ndef), tasks and patterns/streams.
"JITLib".openHelpFile
[Ndef, Tdef, Pdef].choose.openHelpFile;
***/



(

q = q ? ();
s.scope;


Ndef(\test, { |freq=250, intv=19, timescale=1, curve=0, loopnode=0, formfact=2, widfact=0.5, spread=1, amp=0.1|
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
		Formant.ar(pitch, pitch.scramble * formfact, pitch.scramble * widfact), spread) * amp;
}).play;
// add specs for all the parameter ranges - required!
Spec.add(\intv, [0, 36, \lin]);
Spec.add(\timescale, [0.001, 10, \exp]);
Spec.add(\curve, [-10, 10]);
Spec.add(\loopnode, [0, 7, \lin, 1]);
Spec.add(\formfact, [0.1, 10, \exp]);
Spec.add(\widfact, [0.1, 10, \exp]);
Spec.add(\spread, \unipolar);



q.nk = MKtl(\nk1, "korg-nanokontrol");
// q.nk.gui;

q.ndgui = NdefGui(Ndef(\test), 9);
q.ndgui.skipjack.dt = 0.05; // faster updates

)






// VARIANT 1 - SOFT TAKEOVER - with softSet and softVol_:
// The direct set and vol_ methods above may cause a big jump
// of the param value or volume to where the fader happens to be;
// the softSet and softVol method avoid this by only
// doing the setting when the value is close enough,
// or when the value is close to the last value of the
// control element.

(

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

)




(
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

)









// now switch to a different proxy - does nothing so far
q.setNkProxy(Ndef(\test2));

// make the new proxy:
(
Spec.add(\slope, [0.1, 1, \exp]);
Spec.add(\formfreq, [50, 5000, \exp]);
Spec.add(\reso, [1, 10, \exp]);

Ndef(\test2, { |freq = 2000, slope = 0.8,
	formfreq = 5000, reso = 10, amp = 0.5|

	var freqscale = (slope ** (0..5));
	var snd = { LFDNoise0.ar(freq * freqscale).product } ! 2;
	RLPF.ar(snd, formfreq, 1/reso) * amp;
}).play;
Ndef(\test2).gui;
)


// ... and set it again now - all controls should be connected.
q.setNkProxy(Ndef(\test2));

// back to first proxy:
q.setNkProxy(Ndef(\test));

// now assign rew and fwd buttons to switch between \test and \test2
q.nk.elAt(\rew).action = { |el| q.setNkProxy(Ndef(\test)); };
q.nk.elAt(\fwd).action = { |el| q.setNkProxy(Ndef(\test2)); };

// continued with more complex guis:
// see mapping-to-proxies-2 !







































// (
// // map group of mktl elements to array of proxy params:
// // uses direct set method,
// // and global specs for proxy params.
// q.mapElemGroupToProxyParams = { |q, group, proxy, keys|
// 	keys = keys ?? { proxy.controlKeys };
// 	group.do { |el, i|
// 		var parKey = keys[i];
// 		if (parKey.notNil) {
// 			el.action = {
// 				proxy.set(parKey,
// 					parKey.asSpec.map(el.value)
// 				)
// 			};
// 		}
// 	}
// };
//
//
// // use first 8 knobs for first seven params:
// q.mapElemGroupToProxyParams(
// 	q.nk.elAt(\kn).keep(8),
// 	Ndef(\test)
// );
// // use last knob for volume control:
// q.nk.elAt(\kn).last.action = { |el|
// 	Ndef(\test).vol_(\amp.asSpec.map(el.value));
// };
//
// )





// add play and stop buttons
// q.nk.elAt(\play).action = { |el| Ndef(\test).play; };
// q.nk.elAt(\stop).action = { |el| Ndef(\test).stop; };


// ... and test that all these work as intended!

q.nk.gui;

//NOTE - you can close the NdefGui, and connections still work,
// because we connected directly to the Ndef itself!

q.ndgui.close;

// make it again ?
q.ndgui = NdefGui(Ndef(\test), 8);
q.ndgui.skipjack.dt = 0.05; // faster updates

q.nk.gui;







