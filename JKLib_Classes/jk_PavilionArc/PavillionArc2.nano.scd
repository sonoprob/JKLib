
(
		Spec.add(\accamt, [1, 256, \lin, 1, 32]);
		Spec.add(\wrap, [0, 1, \lin, 1, 0]);
		Spec.add(\aconst, [0, 0.2, \lin, 0.01, 0.25]);
		Spec.add(\afact, [0.001, 0.1, \lin, 0.0001, 0.001]);
		Spec.add(\bconst, [0, 0.2, \lin, 0.01, 0.25]);
		Spec.add(\bfact, [0.00001, 0.1, \lin, 0.0001, 0.003]);
		Spec.add(\accexp, [0.7, 1.01, \lin, 0.001, 0.98]);
		Spec.add(\accmul, [0.1, 1, \lin, 0.1, 1]);
		Spec.add(\accwait, [0, 60, \lin, 0.1, 4, \sec]);
		Spec.add(\lag, [0.1, 30, \exp, 0.1, 9, \sec]);
		Spec.add(\hiff, [20, 10000, \exp, 1, 500, \Hz]);
		Spec.add(\loff, [900, 19000, \exp, 1, 10000, \Hz]);
		Spec.add(\room, [1, 100, \lin, 1, 10]);
		Spec.add(\damp, [0, 2, \lin, 0.01, 0.4]);
		Spec.add(\mix, [0, 1, \lin, 0.01, 0.4]);
		Spec.add(\thresh, [0, 1, \lin, 0.01, 0.5]);
		Spec.add(\amp, [0, 3, \lin, 0.01, 1]);
		Spec.add(\lag, [0.1, 60, \exp, 1, 1]);
		Spec.add(\doubleAcceleration, [0, 1, \lin, 1, 0]);
		Spec.add(\acceleration, [0, 1, \lin, 0.01, 0]);
		Spec.add(\regular, [0, 1, \lin, 0.01, 0]);
		Spec.add(\decceleration, [0, 1, \lin, 0.01, 0]);

		Spec.add(\dly, [0.0001, 1, \exp, 0.01, 0.4]);

)



n = NanoKontrol.new;

n.fader1.onChanged = {|val|  PavillionArc2.t.set(\accamt, \accamt.asSpec.map(val)) };
n.fader2.onChanged = {|val|  PavillionArc2.t.set(\accexp, \accexp.asSpec.map(val)) };
n.fader3.onChanged = {|val|  PavillionArc2.t.set(\accmul, \accmul.asSpec.map(val)) };
n.fader4.onChanged = {|val|  PavillionArc2.t.set(\accwait, \accwait.asSpec.map(val)) };

n.knob7.onChanged = {|val|  PavillionArc2.verber.set(\loff, \lo.asSpec.map(val)) };
n.knob8.onChanged = {|val|  PavillionArc2.verber.set(\hiff, \lo.asSpec.map(val)) };
n.knob9.onChanged = {|val|  PavillionArc2.fxGroup.set(\thresh, \thresh.asSpec.map(val)) };
n.fader7.onChanged = {|val|  PavillionArc2.group.set(\mix, \mix.asSpec.map(val)) };
n.fader8.onChanged = {|val|  PavillionArc2.fxGroup.set(\lag, \lag.asSpec.map(val)) };
n.fader9.onChanged = {|val|  PavillionArc2.group.set(\amp, \amp.asSpec.map(val)) };


n.topBt1.onPress   = {|val| "top button 1 pressed".postln; val.postln };


n.topBt1.onPress   = {|val|
	PavillionArc2.t.stop.play;
};

n.topBt1.onRelease = {|val| "top button 1 released".postln; val.postln };

n.knob1.onChanged  = {|val| "knob 1 changed".postln; val.postln };

n.knob1.onChanged  = {|val| "knob 1 changed".postln; (val/127).postln };

n.faders.do{|fader, i|
    fader.onChanged= {|val| ("fader"+(i+1)).postln; val.postln }
};
