accwait spec 0.01 -> 30
mix spec / 100 0.001 -> 0.1
startup - load from file - fill popmenu items

action - button save
	give name (prepend datestamp)
	popmenu items update

shutdown - write to file


// sustain <> compressor slider !
// s.boot;
// s.queryAllNodes;
// PavillionArc2.init;
PavillionArc2.play; // there's an accelerating rhythm here, ad inf

PavillionArc2.t.set(\accexp , 1.02, \accmul,0.2, \accwait, 0.1, \accamt, 64);

PavillionArc2.leftStrip; // mousebuttonlick on mid scope(x=time/y=amplitude) to toggle fullscreen


PavillionArc2.ascope(style:2); // lissajous scope

PavillionArc2.ascope(style:1);
PavillionArc2.ascope(style:0);
PavillionArc2.scope.fill_(false)
PavillionArc2.scope.scopeView.waveColors_([ Color(1.0, 0, 1.0), Color(1, 0,0)  ])

PavillionArc2.scope.scopeView.waveColors_([ Color.green(1,0.03), Color.blue(1,0.03)  ]);
PavillionArc2.scope.scopeView.waveColors_([ Color.green(1,0.03), Color.blue(1,0.03)  ])


_([ Color.white  ]);



// \accexp , 1.02, \accmul,0.2, \accwait, 0.1,

PavillionArc2.t.set(\accamt, 4);
PavillionArc2.t.set(\accamt, 32,\accwait,0);
PavillionArc2.t.set(\accamt, 64,\accwait,1, \accexp,0.98,\accmul, 0.2);
PavillionArc2.t.set(\accamt, 64,\accwait,1, \accexp,1.02,\accmul, 0.1);
PavillionArc2.t.set(\accamt, 128, \accexp, 1.02,\accmul, 0.03);

PavillionArc2.t.set(\accamt, 256)
PavillionArc2.t.set(\accamt, 1024, \accexp, 1.002,\aconst,0,\bconst,0,\bfact,0)
PavillionArc2.t.set(\accamt, 1024, \accexp, 1.001,\aconst,0.1,\afact,0.01,\bconst,0.1,\bfact,0.0001)

PavillionArc2.t.set(\accwait, 0); // ! continuous

PavillionArc2.t.set(\accamt, 128, \accexp, 0.999, \accmul,0.1)
PavillionArc2.t.set(\accamt, 256, \accexp, 0.999, \accmul,0.1)
PavillionArc2.t.set(\accamt, 256, \accexp, 0.99, \accmul,0.2)
PavillionArc2.t.set(\accamt, 512, \accexp, 0.999, \accmul,0.12, \accwait, 2)

PavillionArc2.w.alwaysOnTop_(true)
PavillionArc2.w.bounds_(Rect(0, Window.screenBounds.height-450, 300, 450))


PavillionArc2.verber.set(\dlysp,0.3,\lag,7,\mix,0.005,\room,20,\damp,0.8,\lo,5000,\hi,18000)
PavillionArc2.verber.set(\dly,0.543, \dlysp,9);
PavillionArc2.verber.set(\dly,0.55);

PavillionArc2.verber.set(\dly,0.001);
PavillionArc2.verber.set(\dly,0.0001);
PavillionArc2.verber.set(\dly,0.00008);
PavillionArc2.verber.set(\dly,0.002);
PavillionArc2.verber.set(\dly,0.004);
PavillionArc2.verber.set(\dly,0.008);
PavillionArc2.verber.set(\dly,0.016);

PavillionArc2.verber.set(\dlysp,0.2)




PavillionArc2.verber.set(\dly,0.13)

PavillionArc2.verber.set(\dly,0.5)




PavillionArc2.verber.set(\dly,0.01,\dlysp,0.3,\lag,7,\mix,0.5,\room,20,\damp,0.1,\lo,500,\hi,18000);

PavillionArc2.ascope(style:1);


PavillionArc2.verber.set(\dly,0.02,\dlysp,0.2)


after free:
.play:
ERROR: Message 'window' not understood.



PavillionArc2.verber.set(\roomsize, 5, \revtime, 0.6, \damping, 0.62, \inputbw, 0.48,
	\drylevel -6, \earlylevel, -11, \taillevel, -13)


PavillionArc2.verber.set()




//////////////////////////////////////////////////////////

todo: tdef <<> function composition ....
PavillionArc2.tdef_( {} );
TODO: both gui and fscope freak out on mouseclick
TODO: delaytime SinOsc.kr(LFNoise0.kr()) modulation built in verb (for stereo image, short delay times)
TODO: better reverb, of choice of different ones
TODO

Condition AB

better specs for sliders


// (
// PavillionArc2.w.close;
// PavillionArc2.scope.window.close;
// PavillionArc2.fscope.window.close;
//
// NOPE:
// PavillionArc2.leftStrip; // gui
// )

// PavillionArc2.scope.cycle_(256).yZoom_(4)
// PavillionArc2.scope.cycle_(2048).yZoom_(0.25)
// PavillionArc2.scope.cycle_(2048*2)


// // // //// // // //// // // //// // // //// // // //// // // //// // // //// // // //

PavillionArc2.ascope(style:0); // L-R stereo scope
PavillionArc2.ascope(style:1); // L-R overlay scope

PavillionArc2.t.set(\accexp , 1.02, \accmul,0.3);
PavillionArc2.t.set(\accexp , 0.97, \accmul,0.3, \accwait, 0);
PavillionArc2.t.set(\accexp , 0.97, \accmul,0.3, \accwait, 3);
PavillionArc2.t.set(\accexp , 1.01, \accmul,0.3, \accwait, 3, \accamt, 12);
PavillionArc2.t.set(\accexp , 1.01, \accmul,0.3, \accwait, 0, \accamt, 8);
PavillionArc2.t.set(\accexp , 1.01, \accmul,0.1, \accwait, 0, \accamt, 8);
PavillionArc2.t.set(\accexp , 1.01, \accmul,1, \accwait, 1, \accamt, 8);
PavillionArc2.t.set(\accexp , 1.02, \accmul,0.2, \accwait, 0.1, \accamt, 64);




// presets
PavillionArc2.loadSliderSettings([ 0, 0, 0.001, 0.17, 0.1, 0.875, 2.4, 0, 9, 1791, 19000, 48, 1, 0.26, 0.06, 9.69 ]);
PavillionArc2.loadSliderSettings([ 1, 0.03, 0.001, 0.17, 0.1, 0.875, 2.4, 2, 9, 2977, 19000, 48, 1, 0.55, 0.06, 9.69 ]);
PavillionArc2.loadSliderSettings([ 1, 0, 0.001, 0.2, 0.0472, 0.956, 0.2, 2, 9, 3096, 19000, 48, 1, 0.55, 0.88, 0.69 ]);
PavillionArc2.loadSliderSettings([ 0, 0.2, 0.001, 0.2, 0.003, 0.98, 1, 0, 9, 1937, 19000, 27, 0.94, 0.4, 0.25, 5.91 ]);
PavillionArc2.loadSliderSettings([ 1, 0.1, 0.0097, 0.16, 0.0101, 0.926, 0.1, 1, 9, 1417, 19000, 16, 1, 0.5, 0.13, 1.19 ]);
PavillionArc2.loadSliderSettings([ 0, 0, 0.001, 0, 0, 0.964, 0.2, 1, 0.1, 1165, 15988, 1, 0, 0, 0.44, 0.28 ]); // dry
PavillionArc2.loadSliderSettings([ 1, 0.03, 0.001, 0.17, 0.1, 0.875, 2.4, 2, 9, 2977, 19000, 48, 1, 0.55, 0.06, 9.69 ]);
PavillionArc2.loadSliderSettings([ 1, 0, 0.001, 0.15, 0.0849, 1.019, 0.2, 0, 23, 5564, 19000, 76, 0.38, 0.35, 0.03, 5.03 ])
PavillionArc2.loadSliderSettings([ 1, 0, 0.001, 0.15, 0.0849, 1.019, 0.2, 0, 23, 3219, 3942, 38, 1, 1, 0.03, 5.03 ])

PavillionArc2.loadSliderSettings([ 0, 0.09, 0.001, 0.2, 0, 0.956, 0.2, 8, 9, 1417, 2487, 24, 1, 0.48, 0.53, 0.69 ])
PavillionArc2.loadSliderSettings([ 0, 0.09, 0.001, 0.2, 0, 0.97, 0.2, 3, 9, 1417, 19000, 5, 1, 0.07, 0.53, 2.69 ])


PavillionArc2.loadSliderSettings([ 1, 0.2, 0.001, 0, 0, 1.034, 0.1, 0, 9, 235, 19000, 30, 1, 0, 0.15, 1 ]);

PavillionArc2.loadSliderSettings([ 0, 0, 0.001, 0, 0, 1.006, 0.3, 14, 9, 500, 16934, 10, 0.4, 0.4, 0.5, 0.5 ])
PavillionArc2.loadSliderSettings([ 1, 0, 0.001, 0, 0.022, 0.991, 0.3, 4, 9, 886, 19000, 10, 0.4, 0.4, 0.5, 0.5 ])


///
PavillionArc2.loadSliderSettings([ 0, 0, 0.001, 0, 0.0107, 1.011, 0.1, 2, 9, 7315, 19000, 98, 1, 0.42, 0.77, 5.97 ]);

PavillionArc2.loadSliderSettings([ 1, 0, 0.0022, 0.09, 0.0063, 0.994, 0.1, 7, 9, 922, 19000, 18, 0.91, 0.18, 0.25, 1.26 ]);

/////// make presets
a = List.new; b = List.new;
// -- wiggle sliders
PavillionArc2.saveSliderSettings(a);
a
// -- wiggle sliders
PavillionArc2.saveSliderSettings(b);
b
PavillionArc2.loadSliderSettings(a);
PavillionArc2.loadSliderSettings(b);

// verb params
PavillionArc2.verber.set(\mix, 0.7, \room, 10, \damp, 0.9);
// dly
PavillionArc2.verber.set(\dly, 0.02, \dlysp,0.3, \lag, 7);
PavillionArc2.verber.set(\dly, 0.06, \dlysp,0.03, \lag, 0.1);
PavillionArc2.verber.set(\dly, 0, \dlysp,0.3, \lag, 7);
PavillionArc2.verber.set(\dly, 0.01, \dlysp,0.3, \lag, 7);

// filter
PavillionArc2.verber.set(\lo, 3000, \hi, 9000);
PavillionArc2.verber.set(\lo, 1000, \hi, 10000, \lag, 20);
PavillionArc2.t.set(\accamt, 64, \accexp , 0.9, \accmul, 0.1, \accwait, 1);
PavillionArc2.verber.set(\lo, 8000, \hi, 12000, \lag, 20);


PavillionArc2.t.set(\doubleAcceleration, false);


/////!!!!!!!!!!
PavillionArc2.t.set(\accamt , 500,\accmul,0.1, \accexp,0.98); // # of triggers per cycle
PavillionArc2.t.set(\accamt , 150,\accmul,0.1, \accexp,0.98); // # of triggers per cycle
PavillionArc2.t.set(\accamt , 300,\accmul,0.1, \accexp,0.98); // # of triggers per cycle

// relative probability of occurence of double dec, acc
PavillionArc2.t.set(\doubleAcceleration, true);
PavillionArc2.t.set(\accelaration, 10, \deccelaration, 2, \regular, 1);
PavillionArc2.t.set(\accelaration, 0, \deccelaration, 0, \regular, 1);
PavillionArc2.t.set(\accelaration, 0, \deccelaration, 1, \regular, 0);

PavillionArc2.t.set(\accamt, 4, \accexp , 0.96, \accmul, 1.02, \accwait, 0);


/////////////////////////////////////////////////////// finalizer

// default compressor
PavillionArc2.finalizer;
// compressor
PavillionArc2.finalize(\compress, 0.7, 1);
PavillionArc2.finalizer.set(\thresh, 0.7, \amp, 7);

// sustainer
PavillionArc2.finalize(\sustain, 0.3, 0.1);
PavillionArc2.w.alwaysOnTop_(true);
PavillionArc2.scope.window.alwaysOnTop_(false);


PavillionArc2.finalizer.set(\thresh, 0.5, \amp, 0.05);
PavillionArc2.finalizer.set(\thresh, 0.09, \amp, 0.5);
PavillionArc2.finalizer.set(\thresh, 0.8, \amp, 0.1);
// limiter
// ?? low volumePavillionArc2.finalize(\limit, amp:100);








PavillionArc2.stop;
PavillionArc2.play;








(
// NOPE:
// ~wBounds = PavillionArc2.w.bounds;
// ~fBounds = PavillionArc2.fscope.window.bounds;
// PavillionArc2.w.view.mouseDownAction = {|a, b, c, d, e|
// 	if( b < (a.bounds.width / 2)){
// 		try{ PavillionArc2.w.close; w=nil; PavillionArc2.gui(~wBounds) };
// 	}{
// 		try{ PavillionArc2.w.close; w=nil; PavillionArc2.gui(~wbounds) };
// 	}
// };

// PavillionArc2.fscope.window.view.mouseDownAction = {|a, b, c, d, e|
// 	if( b < ( a.bounds.width / 2)){
// 		PavillionArc2.fscope.window.close;
// 		// f = s.afreqscope(Window.screenBounds);
//
// 		defer{
// 			f = s.afreqscope(~fBounds);
// 			f.scope.freqMode_(1).dbRange_(96).fill_(false).waveColors_([ Color.white  ]);
// 			// fscope = server.afreqscope(Rect(0, 0, size, size));
// 			// fscope.scope.freqMode_(1).dbRange_(96).fill_(false).waveColors_([ Color.white  ]);
// 		}
//
// 	}{
// 		PavillionArc2.fscope.window.close;
// 		defer{
// 			f = s.afreqscope(Window.screenBounds);
// 			f.scope.freqMode_(1).dbRange_(96).fill_(false).waveColors_([ Color.white  ]);
// 		}
//
// 	}
// }

)






// PavillionArc2.scope.cycle_(4).yZoom_(1)
// PavillionArc2.scope.cycle_(1).yZoom_(1)
// PavillionArc2.scope.cycle_(16).yZoom_(1)
// PavillionArc2.scope.cycle_(256).yZoom_(0.25)

PavillionArc2.fscope.scope.dbRange_(96)
PavillionArc2.fscope.scope.freqMode_(1)



PavillionArc2.t = nil
Tdef(\PavillionArc2).clear;

PavillionArc2.free;


PavillionArc2.fscope.scope.dbRange_(64).freqMode_(0);

PavillionArc2.t.set(\accamt , 10); // # of triggers per cycle

PavillionArc2.t.set(\doubleAcceleration, false);
PavillionArc2.t.set(\doubleAcceleration, true);
PavillionArc2.t.set(\accelaration, 10, \deccelaration, 2, \regular, 1); // relative probability of occurence of double dec, acc

PavillionArc2.t.set(\accamt , 100); // # of triggers per cycle
PavillionArc2.t.set(\accelaration, 4, \deccelaration, 1, \regular, 0);


// min and max for all params to allow for random dev ?
// take care with filters at least
// ??
// PavillionArc2.t.reset;

// control routine's acceleration (waittime shrinking 0.99 = little, 0.8 = much acceleration)
PavillionArc2.t.set(\accexp , 0.99);
PavillionArc2.t.set(\accexp , 0.9);
PavillionArc2.t.set(\accexp , 0.8);
PavillionArc2.t.set(\accexp , 0.1);

// decceleration: growing waittime, using accmul (as a scalar) to speed up (low is less waittime)
PavillionArc2.t.set(\accexp , 1.01, \accmul, 0.5);
PavillionArc2.t.set(\accexp , 1.03, \accmul, 0.2);
PavillionArc2.t.set(\accexp , 1.01, \accmul, 0.5);
PavillionArc2.t.set(\accamt , 54); // # of triggers per cycle
PavillionArc2.t.set(\accexp , 1.06, \accmul, 0.3);
PavillionArc2.t.set(\accexp , 1.00, \accmul, 0.1);
PavillionArc2.t.set(\accexp , 0.9, \accmul, 0.3);
PavillionArc2.t.set(\accexp , 0.99, \accmul, 0.3);
PavillionArc2.t.set(\accexp , 1.4, \accmul, 0.3);
PavillionArc2.t.set(\accexp , 2, \accmul, 0.5);
PavillionArc2.t.set(\accexp , 4, \accmul, 0.05);
PavillionArc2.t.set(\accwait, 0.25);
PavillionArc2.t.set(\accamt , 30); // # of triggers per cycle
PavillionArc2.t.set(\aconst, 0.001.rrand(0.01).postln, \afact, 0.0001.rrand(0.01).postln );
PavillionArc2.t.set(\bconst, 0.1, \bfact, 0.01, \wrap, true);
PavillionArc2.t.set(\bconst, 0.01, \bfact, 0.03, \wrap, false);
PavillionArc2.t.set(\accwait, 1, \accamt, 12);
PavillionArc2.t.set(\accexp , 0.9, \accmul, 0.03);
PavillionArc2.t.set(\accelaration, 0, \deccelaration, 0, \regular, 1);




Tdef(\PavillionArc2).clear;
PavillionArc2.play;










// hear smth ( use cmd-enter within ( ) brackets )
// (
// Tdef(\a).clear;
// Tdef(\a,{ 10.do{|i| PavillionArc2.sineSweep.(exprand(0.1,0.4),exprand(0.005, 0.1), 5); [ (1/(1.618 ** i)), (1/(0.618 ** i)/40) ].wchoose([0.5,0.5]).wait }
// }).play
// )


// dly
// PavillionArc2.verber.set(\dly, 0.1, \dlysp,0.01, \lag, 7)
// PavillionArc2.verber.set(\dly, 0.0125, \dlysp,0.5, \lag, 7)
//
// PavillionArc2.verber.set(\dly, 0.125, \dlysp,7, \lag, 7)
// PavillionArc2.verber.set(\dly, 0.25, \dlysp,7, \lag, 7)
// PavillionArc2.verber.set(\dly, 0.5, \dlysp,9, \lag, 7)
//
// PavillionArc2.verber.set(\dly, 0.01, \dlysp, 1, \lag, 7)



s.latency = 0.1;

// Ndef(\brown, {|loff=50, hiff=2000, amp=1| HPF.ar(LPF.ar(BrownNoise.ar(amp * 0.01)!2, hiff), loff) }).play;
// Spec.add(\hiff, \freq.asSpec)
// Spec.add(\loff, \freq.asSpec)
// n = NdefGui(Ndef(\brown), 3);
// Ndef(\brown).clear;
//
// Ndef(\white, {|loff=1500, hiff=10000, amp=0.5| HPF.ar(LPF.ar(WhiteNoise.ar(amp * 0.01)!2, hiff), loff) }).play;
// n = NdefGui(Ndef(\white), 3);
//
// // Ndef(\in, {|amp=0.7| SoundIn.ar(0,1) * amp * 0.1; }).playN([1]);
// Ndef(\in, {|amp=0.7| SoundIn.ar(0,1) * amp * 0.1; });


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

PavillionArc2.accexp = 0.9; PavillionArc2.accwait = 2;

r = PavillionArc2.play1;

PavillionArc2.verber.set(\mix, 0.8, \room,20, \damp, 0.6, \lo, 350, \hi, 19000);
PavillionArc2.verber.set(\mix, 0.4, \room,20, \damp, 0.9, \lo, 250, \hi, 700);
PavillionArc2.verber.set(\mix,0.6, \room,10, \damp,0.01, \lo, 1500, \hi, 19000);
PavillionArc2.finalizer.set(\thresh, 0.4, \amp, 4);

PavillionArc2.accexp = 0.97;
PavillionArc2.accexp = 0.92;
PavillionArc2.accwait = 9;
PavillionArc2.accexp = 0.96; PavillionArc2.accwait = 2;
PavillionArc2.accexp = 0.9; PavillionArc2.accwait = 2;

//////////////////////////////////////////////////////////////////////////////// verb + compre

// verb
PavillionArc2.verber.set(\lag, 30); // 30 seconds;
PavillionArc2.verber.set(\mix,0.5, \room,20, \damp,0.1, \lo, 500, \hi, 18000);
PavillionArc2.verber.set(\mix,0.5, \room,50, \damp,0.01, \lo, 500, \hi, 19000);
PavillionArc2.verber.set(\mix, 0.8, \room,20, \damp, 0.6, \lo, 350, \hi, 19000);
PavillionArc2.verber.set(\mix,0.6, \room,4, \damp,0.01, \lo, 1500, \hi, 12000);

// compressor
PavillionArc2.finalizer.set(\thresh, 0.4, \amp, 4);
PavillionArc2.finalizer.set(\thresh, 0.09, \amp, 0.1, \lag, 2);
PavillionArc2.finalizer.set(\thresh, 0.5, \amp, 0.9, \lag, 10);


PavillionArc2.verber.set(\lag, 10);
PavillionArc2.verber.set(\mix,0.6, \room,20, \damp,0.1, \lo, 1500, \hi, 19000);
PavillionArc2.verber.set(\mix,0.6, \room,10, \damp,0.5, \lo, 500, \hi, 19000);


//////////////////////////////////////////////////////////////////////////////// scope

PavillionArc2.scope(Window.screenBounds, style:2);
PavillionArc2.scope(Rect(0,0,200,200), style:2);
PavillionArc2.scope(style:0);
PavillionArc2.scope;
PavillionArc2.scope(numChannels:2);
PavillionArc2.scope(Rect(0,0,400,400), style:2); // lissajous
PavillionArc2.scope(Rect(0,0,400,400), style:0);

/////////////////////////////////////////////////////////////////////////////////
*/