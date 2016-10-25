/*

TODO:
- preset tdef functions
- extend TdefGui to have sliders (with specs) from env.settings ?


TdefAllGui.new;
// PavillionArc2.play;
// Tdef(\PavillionArc2).stop;
// Tdef(\PavillionArc2).clear;


// nope:
Tdef(\PavillionArc2).set(\amt0, 1, \amt1, 4).play;
Tdef(\PavillionArc2).set(\amt0, 1, \amt1, 14).play;
????? !!!
env.accexp = accexp;
env.accwait = accwait;

PavillionArc2.accexp = 0.9; PavillionArc2.accwait = 2;

*/


PavillionArc2.init;
PavillionArc2.play;

PavillionArc2.t.set(\amt, 4)
PavillionArc2.t.set(\amt, 24)
PavillionArc2.t.set(\amt, 32)
PavillionArc2.t.set(\amt, 64)
PavillionArc2.t.set(\amt, 440)
PavillionArc2.t.set(\amt, 100)


// overwrite routine

(
// infinite
PavillionArc2.tdef_({|env|
	env.amt = 64;
	env.start = 1;
	inf.do{|j|
		env.amt.do{|i|
			PavillionArc2.sineSweep.(
				exprand(0.3,0.4),
				exprand(0.005, 1),
				exprand(4, 20)
			);
			(env.start / (i+1) ).wait
		};
		[0,1,2,4].choose.wait;
	}
})
)


// finite

// dec
PavillionArc2.tdef_({ 128.do{|i| PavillionArc2.sineSweep.( exprand(0.2,0.5), exprand(0.05, 1), 10); (1/(128-i)).wait } });

// loud, acc
PavillionArc2.tdef_({ 340.do{|i| PavillionArc2.sineSweep.( exprand(0.1,0.9), exprand(0.005, 0.3), 10); (1/(i+1)).wait } });

// soft, acc
PavillionArc2.tdef_({ 70.do{|i| PavillionArc2.sineSweep.(exprand(0.03,0.4), exprand(0.04, 0.5), 20); (1/(i+1)).wait } });



(

Ndef(\brown, {|loff=500, hiff=1000, amp=0.1| HPF.ar(LPF.ar(BrownNoise.ar(amp * 0.01)!2, hiff), loff) }).play;
Ndef(\white, {|loff=500, hiff=1000, amp=0.1| HPF.ar(LPF.ar(WhiteNoise.ar(amp * 0.01)!2, hiff), loff) }).play;
Ndef(\in, {|amp=0.7| SoundIn.ar(0,1) * amp * 0.1; }).playN([1]);

Tdef(\auto2,{|env|
	env.accexp = rrand(0.9, 0.99);
	env.accwait = rrand(1, 9);

	inf.do{

		env.accexp = rrand(0.9, 0.99);
		env.accwait = rrand(1, 9);

		Ndef(\white).fadeTime_(1).xset(\ffreq, [2000, 4400, 8400, 12000].choose);
		Ndef(\brown).fadeTime_(1).xset(\ffreq, [200, 440, 840, 1200].choose);

		if( 0.1.coin ){
			PavillionArc2.verber.set(\mix,[0.04, 0.1, 0.1, 0.6].choose, \lo, [1000,3000,7000].choose )
		};
		// (env.accwait * 3)
		(env.accwait / 1.2).wait;
		PavillionArc2.sineSweep.( exprand(0.3,0.4), exprand(0.5, 1));
		(env.accwait / 0.2).wait;
	}
}).play;
)








// ---- conditions

PavillionArc2.t.condition = false;
// switch condition
PavillionArc2.t.condition = true;
// condition = value
Provide a condition under which the pattern is switched when a new one is inserted.
The stream value and a count value is passed into the function.


// Wait for value time, regardless of test. This only works in a Routine.
c = Condition.new;
d = Condition.new;
// c.unhang;

(
Tdef(\testA).clear;
Tdef(\testB).clear;

Tdef(\testA,{
	inf.do{
		exprand(1,5).wait;
		"A waiting ...".post;
		d.unhang;
		// 1.wait;
		c.hang;
		"... A passed.".postln
	};
}).play;

Tdef(\testB,{
	inf.do{
		exprand(1,5).wait;
		"B waiting ...".post;
		c.unhang;
		// 1.wait;
		d.hang;
		"... B passed.".postln
	};
}).play;

)









////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



Tdef(\auto2,{|env|
	env.accexp = rrand(0.9, 0.99);
	env.accwait = rrand(1, 9);
	inf.do{|i|
		// env.accexp = rrand(0.9, 1.1);
		env.accexp = rrand(0.9, 0.99);
		env.accwait = rrand(1, 9);
		if( 0.1.coin ){
			PavillionArc2.verber.set(\mix,[0.04, 0.1, 0.1, 0.6].choose, \lo, [1000,3000,7000].choose )
		};
		// (env.accwait / 1.2).wait;
		i.do{|j|
			PavillionArc2.sineSweep.( exprand(0.3,0.4), exprand(0.5, 1));
			(1/(j+1)).wait
		};
		(env.accwait / 0.2).wait;
	}
}).play;


Tdef(\auto2).stop;

Tdef(\auto2).set(\accexp, 0.9, \accwait, 2);
Tdef(\auto2).set(\accexp, 0.9, \accwait, 2);

///////////////////////////////


Tdef(\orig).set(\aconst, 0.25, \bconst, 1);
Tdef(\orig).set(\afact, 0.001, \bfact, 0.003);

Tdef(\orig).set(\aconst, 0.25, \bconst, 1);

Tdef(\orig).set(\aconst, 1, \bconst, 0.1);
Tdef(\orig).set(\afact, 0.003); // rising pitch
Tdef(\orig).set(\bfact, 0.0001); // length mul


-0.1.wrap(0,1)
a = 0.25 + (i*0.001);
a = 0.25 + (0*0.001);
a = 0.25 + (64*0.001);
b = 1 - (i * 0.003);


rangesliders!for:
 sweep a
 sweep b

 accexp
 accmul
 accwait


t = Tdef(\orig);


t.set(\wrap, true); // wrap / fold (0/1)
t.set(\aconst, 0.5);
t.set(\bconst, 0.7);
t.set(\afact, 0.001)
t.set(\bfact, 0.003);

t.set(\accexp, 0.9, \accwait, 10);






Tdef(\orig).set(\accexp, 0.98, \accwait, 10);
Tdef(\orig).set(\accexp, 0.92, \accwait, 2);
Tdef(\orig).set(\accexp, 0.8, \accwait, 0.5);

Tdef(\orig).set(\accexp, 0.9, \accwait, 4);
Tdef(\orig).set(\accexp, 0.8, \accwait, 0.5);

Tdef(\orig).set(\accexp, 0.8, \accwait, 1);





// ---- acc, dec, accdev etc.


// -- accelerando --
PavillionArc2.tdef_({|env|
	env.amt0 = 3;
	env.amt1 = 64;
	env.amt0.do{|j|
		env.amt1.do{|i|
			PavillionArc2.sineSweep.( exprand(0.3,0.4), exprand(0.5, 1), 10);
			((j + 1)/(i + 1)).wait
		};
		(j+1).wait
	}
});


PavillionArc2.t.set(\amt0, 1, \amt1, 12)
PavillionArc2.t.play




// -- deccelerando --
Tdef(\PavillionArc2,{|env|
	env.amt0 = 3;
	env.amt1 = 64;
	env.amt0.do{|j|
		env.amt1.do{|i|
			PavillionArc2.sineSweep.( exprand(0.3,0.4), exprand(0.5, 1), 10);
			((env.amt0-j)/(env.amt1-i)).wait
		};
		(env.amt0-j).wait
	}
});


// 3 acc, 3 dec
PavillionArc2.tdef_({|env|
	env.amt0 = 3;
	env.amt1 = 64;

	env.amt0.do{|j|
		env.amt1.do{|i|
			PavillionArc2.sineSweep.( exprand(0.3,0.4), exprand(0.5, 1), 10);
			((j+1)/(i+1)).wait
		};
		(env.amt0+1).wait
	};

	env.amt0.do{|j|
		env.amt1.do{|i|
			PavillionArc2.sineSweep.( exprand(0.3,0.4), exprand(0.5, 1), 10);
			((env.amt0-j)/(env.amt1-i)).wait
		};
		(env.amt0-j).wait
	}
});


// acc dec, acc dec, acc dec
PavillionArc2.tdef_({|env|
	env.amt0 = 3;
	env.amt1 = 64;
	env.amt0.do{|j|
		env.amt1.do{|i|
			PavillionArc2.sineSweep.( exprand(0.3,0.4), exprand(0.5, 1), 10);
			((j+1)/(i+1)).wait
		};
		env.amt1.do{|i|
			PavillionArc2.sineSweep.( exprand(0.3,0.4), exprand(0.5, 1), 10);
			((env.amt0-j)/(env.amt1-i)).wait
		};
		// (env.amt0+1).wait;
		(env.amt0-j).wait
	}
});


