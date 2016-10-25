SynthDef(\revchn1,{|mix=0.4, room=1, lo=100, hi=10000, damp=0.1|
	var in = In.ar(0,1);
	in = FreeVerb.ar(in, mix, room, damp);
	in = LPF.ar(HPF.ar(in, lo.lag(0.1)), hi.lag(0.1));
	ReplaceOut.ar(0, in)
}).add;

GVerb


// bathroom
PavillionArc2.verber.set(\roomsize, 5, \revtime, 0.6, \damping, 0.62, \inputbw, 0.48, \drylevel -6, \earlylevel, -11, \taillevel, -13);


//living room
PavillionArc2.verber.set(\roomsize, 16, \revtime, 1.24, \damping, 0.10, \inputbw, 0.95, \drylevel -3, \earlylevel, -15, \taillevel, -17);


//church
PavillionArc2.verber.set(\roomsize, 80, \revtime, 4.85, \damping, 0.41, \inputbw, 0.19, \drylevel -3, \earlylevel, -9, \taillevel, -11);

// cathedral
PavillionArc2.verber.set(\roomsize, 243, \revtime, 1, \damping, 0.1, \inputbw, 0.34, \drylevel -3, \earlylevel, -11, \taillevel, -9);

// canyon
PavillionArc2.verber.set(\roomsize, 300, \revtime, 103, \damping, 0.43, \inputbw, 0.51, \drylevel -5, \earlylevel, -26, \taillevel, -20);

)


PavillionArc2.verber.set(\roomsize, 12, \revtime, 1.6, \damping, 0.02, \inputbw, 0.48, \drylevel -6, \earlylevel, -11, \taillevel, -13);


AdCVerb.ar(in, revTime = 3, hfDamping = 0.1, nOuts = 2, predelay = 0.02,
	numCombs = 8, numAllpasses = 4, inFilter = 0.6, combScale = 1, apScale = 1);
