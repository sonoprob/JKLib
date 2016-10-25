/*

*/


(

var fwidth, fheight, width, height;
try { w.close };
b = Window.screenBounds;
b = Rect(300,0, b.width-300, b.height);
w = Window.new(bounds:b, border:false);
width = w.bounds.width;
height = w.bounds.height - 100;
w.background_(Color(0,0,0));
w.view.decorator=FlowLayout(w.view.bounds);
w.view.decorator.gap=2@4;
e = PavillionArc2.t.envir;
fwidth = ((width - 36)/ e.keys.size).round;
fheight = ((height - 36) / (e.keys.size * 2.5) ).round;

Spec.add(\wrap, [0, 1, \lin, 1, 0]);
Spec.add(\aconst, [0, 0.2, \lin, 0.01, 0.25]);
Spec.add(\afact, [0.001, 0.1, \lin, 0.0001, 0.001]);
Spec.add(\bconst, [0, 0.2, \lin, 0.01, 0.25]);
Spec.add(\bfact, [0.00001, 0.1, \lin, 0.0001, 0.003]);
Spec.add(\accexp, [0.8, 1.2, \lin, 0.001, 0.98]);
Spec.add(\accmul, [0.1, 5, \lin, 0.1, 1]);
Spec.add(\accwait, [0.1, 60, \lin, 0.1, 14, \sec]);
Spec.add(\lag, [0.1, 30, \exp, 0.1, 9, \sec]);
Spec.add(\hiff, [20, 10000, \exp, 1, 500, \Hz]);
Spec.add(\loff, [900, 19000, \exp, 1, 10000, \Hz]);
Spec.add(\room, [1, 100, \lin, 1, 10]);
Spec.add(\damp, [0, 2, \lin, 0.01, 0.4]);
Spec.add(\mix, [0, 1, \lin, 0.01, 0.4]);
Spec.add(\thresh, [0, 1, \lin, 0.01, 0.5]);
Spec.add(\amp, [0, 10, \lin, 0.01, 4]);
Spec.add(\accamt, [0, 10, \lin, 0.01, 4]);

Spec.add(\doubleAcceleration, [0, 1, \lin, 1, 0]);
Spec.add(\acceleration, [0, 1, \lin, 0.01, 0]);
Spec.add(\regular, [0, 1, \lin, 0.01, 0]);
Spec.add(\decceleration, [0, 1, \lin, 0.01, 0]);

~presets = (
	\a: [ 1, 0.2, 0.001, 0, 0, 1.034, 0.1, 0, 9, 235, 19000, 30, 1, 0, 0.15, 1 ],
	\b: [ 0, 0, 0.0639, 0.05, 0.0497, 0.805, 0.6, 9, 9, 500, 9525, 10, 0.4, 0, 0.5, 4.28 ],
	\c: [ 0, 0, 0.0272, 0.03, 0.0044, 0.946, 0.1, 3, 9, 3764, 6875, 38, 1, 0.01, 0.95, 0.94 ],
	\d: [ 0, 0, 0.0919, 0, 0, 0.994, 0.3, 3, 0.1, 3764, 19000, 88, 0.32, 0.48, 0.84, 0.94 ],
	\e: [ 0, 0, 0.001, 0.17, 0.1, 0.875, 2.4, 0, 9, 1791, 19000, 48, 1, 0.26, 0.06, 9.69 ],
	\f: [ 1, 0.03, 0.001, 0.17, 0.1, 0.875, 2.4, 2, 9, 2977, 19000, 48, 1, 0.55, 0.06, 9.69 ],
	\g: [ 1, 0, 0.001, 0.2, 0.0472, 0.956, 0.2, 2, 9, 3096, 19000, 48, 1, 0.55, 0.88, 0.69 ],
	\h: [ 0, 0.2, 0.001, 0.2, 0.003, 0.98, 1, 0, 9, 1937, 19000, 27, 0.94, 0.4, 0.25, 5.91 ],
	\i: [ 1, 0.1, 0.0097, 0.16, 0.0101, 0.926, 0.1, 1, 9, 1417, 19000, 16, 1, 0.5, 0.13, 1.19 ],
	\j: [ 0, 0, 0.001, 0, 0, 0.964, 0.2, 1, 0.1, 1165, 15988, 1, 0, 0, 0.44, 0.28 ], // dry
	\k: [ 1, 0.03, 0.001, 0.17, 0.1, 0.875, 2.4, 2, 9, 2977, 19000, 48, 1, 0.55, 0.06, 9.69 ],
	\l: [ 1, 0, 0.001, 0.15, 0.0849, 1.019, 0.2, 0, 23, 5564, 19000, 76, 0.38, 0.35, 0.03, 5.03 ],
	\m: [ 1, 0, 0.001, 0.15, 0.0849, 1.019, 0.2, 0, 23, 3219, 3942, 38, 1, 1, 0.03, 5.03 ],
	\n: [ 0, 0.09, 0.001, 0.2, 0, 0.956, 0.2, 8, 9, 1417, 2487, 24, 1, 0.48, 0.53, 0.69 ],
	\o: [ 0, 0.09, 0.001, 0.2, 0, 0.97, 0.2, 3, 9, 1417, 19000, 5, 1, 0.07, 0.53, 2.69 ],
	\p: [ 1, 0.2, 0.001, 0, 0, 1.034, 0.1, 0, 9, 235, 19000, 30, 1, 0, 0.15, 1 ],
	\q: [ 0, 0, 0.001, 0, 0, 1.006, 0.3, 14, 9, 500, 16934, 10, 0.4, 0.4, 0.5, 0.5 ],
	\r: [ 1, 0, 0.001, 0, 0.022, 0.991, 0.3, 4, 9, 886, 19000, 10, 0.4, 0.4, 0.5, 0.5 ],
	\s: [ 0, 0, 0.001, 0, 0.0107, 1.011, 0.1, 2, 9, 7315, 19000, 98, 1, 0.42, 0.77, 5.97 ],
	\t: [ 1, 0, 0.0022, 0.09, 0.0063, 0.994, 0.1, 7, 9, 922, 19000, 18, 0.91, 0.18, 0.25, 1.26 ]
);



~presNames = ~presets.keys.asArray.sort;

~presButs = ~presNames.collect{| key |
	Button(w,  ( (width - 36) / (~presNames.size * 1.016) ) @ 20 )
	.states_([[ key.asString, Color.red, Color.black]])
	.action_({|but|
		but.string.asSymbol.postln;
		PavillionArc2.loadSliderSettings(~presets.at(but.string.asSymbol));
	});
};



f = e.keys.collect{|key|
	g = EZRanger(w,
		// fwidth @ height,
		// (width - 36)@ fheight,
		(width - 30) @ 20,
		key.asString,
		Spec.specs.at(key),
		labelWidth:100,
		numberWidth: 50,
		unitWidth:0,
		layout:\horz,
		margin:0@0
	)
	.setColors(
		Color.black,Color.grey(0.8), Color.black,Color.black, Color.grey(0.1), Color.white,
		background:Color.black,
		knobColor: Color.black
	)
	.font_(Font("Helvetica",11));
	g.loBox.align_(\center);
	g.hiBox.align_(\center);

	g.action_({|view|
		var val;
		[view.lo, view.hi].postln;
		if(view.lo == view.hi){ view.hi = view.hi+0.02; view.lo = view.lo-0.02; };
		val = rrand(view.lo, view.hi);
		[key, val].postln;
		PavillionArc2.t.envir.put(key, val)
	});

};

w.front;

)

(
g.view.mouseUpAction_({
	\mu.postln;
	PavillionArc2.t.set(exprand(g.lo, g.hi))
})
)

action:{|ez| t.set(\wrap, ez.value.asBoolean)}
action:{|ez| t.set(\aconst, ez.value)}
action:{|ez| t.set(\afact, ez.value)}
action:{|ez| t.set(\bconst, ez.value)}
action:{|ez| t.set(\bfact, ez.value)}
action:{|ez| t.set(\accexp, ez.value)}
action:{|ez| t.set(\accmul, ez.value)}
action:{|ez| t.set(\accwait, ez.value)}
action:{|ez| PavillionArc2.verber.set(\lag, ez.value)}
action:{|ez| PavillionArc2.verber.set(\room, ez.value)},
action:{|ez| PavillionArc2.verber.set(\damp, ez.value)}
action:{|ez| PavillionArc2.verber.set(\mix, ez.value)}
action:{|ez| PavillionArc2.finalizer.set(\thresh, ez.value)}
action:{|ez| PavillionArc2.finalizer.set(\amp, ez.value)},
