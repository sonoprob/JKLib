/*

s.boot;

PavillionArc15.free;PavillionArc15.play;

PavillionArc15.leftStrip;

PavillionArc15.ascope(style:2);

PavillionArc15.loadSliderSettings([ 0, 0.09, 0.001, 0.2, 0, 0.97, 0.2, 3, 9, 1417, 19000, 5, 1, 0.07, 0.53, 1 ]);

PavillionArc15.w.bounds_(Rect(300,0,300,600)
PavillionArc15.w.front

// click on mid scope to toggle fullscreen;
PavillionArc15.leftStrip;
PavillionArc15.ascope(style:2); // lissajous
PavillionArc15.ascope(style:0); // lissajous


PavillionArc15.w.bounds_(Rect(300, 600, 0, 0))

PavillionArc15.w.front;

PavillionArc15.free;


*/

/*

// Server.killAll;
s.boot;


PavillionArc15.free;PavillionArc15.play;

// interface
PavillionArc15.leftStrip;

PavillionArc15.loadSliderSettings([ 0, 0.09, 0.001, 0.2, 0, 0.97, 0.2, 3, 9, 1417, 19000, 5, 1, 0.07, 0.53, 1 ]);


PavillionArc15.ascope(style:2); //

// sustainer
PavillionArc15.finalize(\sustain, 0.3, 0.9);

*/

PavillionArc15 {

	classvar server, loaded=false, scoping=false, inited=false;
	classvar <group, <fxGroup, <verber, <finalizer;
	classvar <sineSweep, <sineSweepLong;
	classvar <tdef;
	classvar <>accmul=1, <>accexp=0.99, <>accwait=4;
	classvar <>verbose=false, <w, <sliders, <t;
	classvar <scope, <fscope;

	*init {|serv|
		var cond = Condition.new();
		server = serv ? Server.default;
		this.free;
		{
			server.waitForBoot{
				this.loadDefs(); server.sync(cond);
				this.load(); server.sync(cond);
				// snd group
				group = Group.new(1, \addToTail); server.sync(cond);
				// add verb and sustainer at end of the chain
				fxGroup = Group.new(group, \addToTail);
				this.verb();
				// this.finalize(type: \sustain, thresh: 0.9);
				this.finalize(type: \compress, thresh: 0.8, amp: 3);
				server.sync(cond);
				if( verbose ){ server.queryAllNodes };
				inited = true;
			}
		}.r.play;
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	*load {

		CmdPeriod.add{ this.free; };

		server.waitForBoot{
			// sine functions
			sineSweep = { |a=1, b=1, amp=0.2| Synth(\sinesweep1,[\a, a, \b, b, \amp, amp], target:group) };
			sineSweepLong = { |a=1, b=1, amp=0.2| Synth(\sinesweeplong,[\a, a, \b, b, \amp, amp], target:group) };
			loaded = true;
		};

		t = Tdef(this.asSymbol,{|env|
			var a, b, amp, delta;
			env.accamt = 64;
			env.accexp = rrand(0.9, 0.99);
			env.accwait = rrand(1, 9);
			env.accmul = 1;
			env.aconst = 0.25;
			env.bconst = 1;
			env.afact = 0.001;
			env.bfact = 0.003;
			env.wrap = true;
			env.accelaration = 0;
			env.deccelaration = 0;
			env.regular = 1;
			env.doubleAcceleration = false;

			inf.do{
				env.accamt.do{| i |
					a = env.aconst + (i * env.afact);
					b = env.bconst - (i * env.bfact);

					if(env.wrap){
						a = a.wrap(0,1);
						b = b.wrap(0,1);
					}{
						a = a.fold(0,1);
						b = b.fold(0,1);
					};

					amp = exprand(0.3,8);
					// Synth(\sinesweep1,[\a, a, \b, b, \amp, amp ], target:PavillionArc15.group);
					Synth.grain(\sinesweep1,[\a, a, \b, b, \amp, amp ], target: PavillionArc15.group, addAction: \addToHead);

					amp = exprand(0.3,8);
					// Synth(\sinesweeplong,[\a, a, \b, b, \amp, amp/2], target:PavillionArc15.group);
					// Synth(\sinesweeprev,[\a, a, \b, b, \amp, amp ], target:PavillionArc15.group);
					// Synth(\sinesweep2,[\a, a, \b, b, \amp, amp ], target:PavillionArc15.group);
					Synth.grain(\sinesweep2,[\a, a, \b, b, \amp, amp ], target: PavillionArc15.group, addAction: \addToHead);

					delta = (env.accmul * (0.5 * ( env.accexp ** i)));

					if( env.doubleAcceleration == true ){
						delta = delta *
						[ (1/(1.618 ** i)), (1/(0.618 ** i)/40), 1]
						.wchoose(
							[ env.acceleration, env.deccelaration, env.regular].normalizeSum
						);
						delta.wait
					}{
						delta.wait
					};

					// delta.wait


				};

				(env.accwait * [0.5,1,1,2,3].choose).wait;
			}
		});

	}

	*free {
		try{
			w.close;
			scope.window.close;
			// server.scopeWindow.window.close;
			fscope.window.close;
			t.stop; t.clear;
			// fxGroup.free;
			group.free;
		};
		fxGroup = nil; verber = nil; finalizer = nil;
		loaded=false; inited=false; scoping=false;
		if( verbose ){ server.queryAllNodes };

	}

	// routines

	*tdef_{|func| t = Tdef(this.asSymbol, func ); }

	// returns tdef
	*play {
		if ( inited == false ){ this.init; };
		if ( loaded == false ){ this.load; t.play }{ t.play };
		^t
	}

	*stop { t.stop }


	// scoping ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	*smallGuiScope {|size=300|
		this.ascope(Rect(0,0,size,size), style:2);
		this.gui(Rect(0, size, size, Window.screenBounds.height - size));
	}

	*leftStrip{|size=300|

		{
			defer{
				// this.smallGuiScope;
				this.gui(Rect(0, size*2, size, Window.screenBounds.height - (size*2) ));
				// PavillionArc15.w.bounds_(Rect(0, 600, 300, 450))

				this.ascope(Rect(0, size, size, size));
				// scope.window.bounds_(Rect(0, size*2, size, size));

				fscope = server.afreqscope(Rect(0, 0, size, size));
				fscope.scope.dbRange_(96).fill_(false).waveColors_([ Color.white  ]);
				// .freqMode_(1)
				// fscope.scope.dbRange_(128).freqMode_(0);

				// w.alwaysOnTop_(true);
				// scope.window.alwaysOnTop_(true);
				// fscope.window.alwaysOnTop_(true);

				~aBounds = scope.view.bounds;
				scope.view.view.mouseDownAction = {|a, b, c, d, e|
					if( b < (a.bounds.width / 2)){
						this.ascope(~aBounds)
					}{
						this.ascope(Window.screenBounds)
					}
				};

				~fBounds = fscope.window.bounds;

				fscope.window.view.mouseDownAction = {|a, b, c, d, e|
					defer{
						try { fscope.window.close };
						if( b < 150 ){
							fscope = server.afreqscope(~fBounds)
						}{
							fscope = server.afreqscope(Window.screenBounds)
						};

						// fscope.scope.dbRange_(96).fill_(false).waveColors_([ Color.white  ]);

					}
				}

			}
		}.r.play

	}


	*lissajous {
		var b = Window.screenBounds;
		this.ascope(Rect(0,0,b.height,b.height), style:2);
		server.scopeWindow.window.alwaysOnTop_(false);
	}
	*lissajousFs {
		var b = Window.screenBounds;
		this.ascope(b, style:2);
		server.scopeWindow.window.alwaysOnTop_(false);
	}


	// toggle scoping, no arguments is close, except the first time its called
	*ascope {|bounds, numChannels, index, style|
		// if(){  scoping };

		if(scoping){
			if(bounds.isNil && numChannels.isNil && index.isNil && style.isNil && scope.isActive.not)
			{
				server.scopeWindow.window.close;
				scoping = false;
				this.ascope;
			}{
				if( bounds.notNil ){ server.scopeWindow.window.bounds_( bounds ) };
				if( numChannels.notNil ){ server.scopeWindow.scope.numChannels_( numChannels ) };
				if( index.notNil ){ server.scopeWindow.index_( index ) };
				if( style.notNil ){ server.scopeWindow.style_( style ) };
			};


		}{

			var b = Window.screenBounds;
			scope = server.ascope(numChannels: numChannels ? 2, index: index ? 0, bufsize: 4096*2);
			server.scopeWindow.window.bounds_( bounds ?
				Rect(0, 0, b.width, b.height/4)
			);
			// .alwaysOnTop_(true);

			server.scopeWindow.style_( style ? 0);
			scoping = true;
			^scope;
		}

	}





	///////////////////////////////////////////// efx
	/// verb + level control

	*verb {
		if( verber.notNil ){ verber.free };
		// bathroom
		// verber = Synth(\revchn,[
		// 	\roomsize, 5, \revtime, 0.6, \damping, 0.62, \inputbw, 0.48,
		// 	\drylevel -6, \earlylevel, -11, \taillevel, -13
		// 	],
		// 	// 	[ \mix, 0.2, \room, 20, \damp,0.2, \lo, 3000, \hi, 10000],
		// 	target: fxGroup,
		// 	addAction:\addToTail
		// );

		verber = Synth(\revchnB,[ \mix, 0.2, \room, 20, \damp,0.2, \lo, 3000, \hi, 10000],
		 	target: fxGroup,
		 	addAction:\addToTail
		);

		// verber.set(\mix,0.2, \room,20, \damp,0.1, \lo, 50, \hi, 300)
		// verber.set(\mix,0.5, \room,20, \damp,0.1, \lo, 1500, \hi, 12000)


	}

	*finalize {|type=\compress, thresh=0.5, amp=1.0|

		if ( finalizer.notNil ){ finalizer.free; finalizer = nil };

		switch( type,
			\sustain,{ finalizer = Synth.after(fxGroup, \sustain,[\thresh, thresh, \amp, amp]) },
			\compress, { finalizer = Synth.after(fxGroup, \compress,[\thresh, thresh,\amp, amp]) },
			\limit,{ finalizer = Synth.after(fxGroup, \limit,[\dur, 0.02, \amp, amp]) }
		)

	}

	///////////////////////////////////////


	*gui {|bounds|
		var font, sheight= 30, b, sl;

		var wrapsl, aconstsl, afactsl, bconstsl, bfactsl,
		accexpsl, accmulsl, accwaitsl,
		revlagsl,losl, hisl, roomsl, dampsl, mixsl, threshsl, ampsl;

		try{ w.close };

		b = Window.screenBounds;

		bounds = bounds ? Rect(b.height, 0, b.width-b.height, b.height); // default left

		font = Font("Helvetica", 9);
		// w.close;

		if( w.isNil) { w = Window(bounds: bounds, border:false).onClose_({ w = nil }) }
		{
			w.bounds_(bounds)
		};

		w.background_(Color(0,0,0));
		w.view.decorator=FlowLayout(w.view.bounds);
		w.view.decorator.gap=2@4;

		w.view.decorator.nextLine;
		w.view.decorator.nextLine;
		w.view.decorator.nextLine;


		// EZSlider(w, (w.bounds.width - 10) @ sheight," Freq ", \freq, unitWidth:0, initVal:6000.rand, numberWidth:45, layout:\horz)
		// .setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		// .font_(font);
		//
		// EZSlider(w, (w.bounds.width - 10) @ sheight, "Cutoff ",  \ffreq, controlSpec:ControlSpec(200, 5000, \exp, 0.01, 1000, \Hz), action:{|ez| /*node.set( "fc", ez.value )*/ }, unitWidth:0, numberWidth:45 )
		// .setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		// .font_(font);
		//
		// EZSlider(w, (w.bounds.width - 10) @ sheight," Amp ", \amp, unitWidth:0, initVal: 0.1, numberWidth:45, layout:\horz)
		// .setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		// .font_(font);


		sliders = List.new;

		wrapsl = EZSlider(w, (w.bounds.width - 10) @ 20," wrap/fold ",
			controlSpec:ControlSpec(0, 1, \lin, 1, 0), action:{|ez| t.set(\wrap, ez.value.asBoolean)},
			initVal:0,
			unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		aconstsl = EZSlider(w, (w.bounds.width - 10) @ 20," aconst ",
			controlSpec:ControlSpec(0, 0.2, \lin, 0.01, 0.25), action:{|ez| t.set(\aconst, ez.value)},
			initVal:0.25,
			unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		afactsl = EZSlider(w, (w.bounds.width - 10) @ 20," afact ",
			controlSpec:ControlSpec(0.001, 0.1, \lin, 0.0001, 0.001), action:{|ez| t.set(\afact, ez.value)},
			initVal:0.001,
			unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		bconstsl = EZSlider(w, (w.bounds.width - 10) @ 20," bconst ",
			controlSpec:ControlSpec(0, 0.2, \lin, 0.01, 0.25), action:{|ez| t.set(\bconst, ez.value)},
			initVal:0.25,
			unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		bfactsl = EZSlider(w, (w.bounds.width - 10) @ 20," bfact ",
			controlSpec:ControlSpec(0.00001, 0.1, \lin, 0.0001, 0.003), action:{|ez| t.set(\bfact, ez.value)},
			initVal:0.003,
			unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		accexpsl = EZSlider(w, (w.bounds.width - 10) @ 20," accexp ",
			controlSpec:ControlSpec(0.8, 1.2, \lin, 0.001, 0.98), action:{|ez| t.set(\accexp, ez.value)},
			initVal:0.98, unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		accmulsl = EZSlider(w, (w.bounds.width - 10) @ 20," accmul ",
			controlSpec:ControlSpec(0.1, 5, \lin, 0.1, 1), action:{|ez| t.set(\accmul, ez.value)},
			initVal:0.98,
			unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		accwaitsl = EZSlider(w, (w.bounds.width - 10) @ 20," accwait ",
			controlSpec:ControlSpec(0, 60, \lin, 1, 14, \sec), action:{|ez| t.set(\accwait, ez.value)},
			initVal: 14,
			unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		w.view.decorator.nextLine;

		revlagsl = EZSlider(w, (w.bounds.width - 10) @ 20," revlag ", \freq,
			controlSpec:ControlSpec(0.1, 120, \exp, 0.1, 9, \sec), action:{|ez| PavillionArc15.verber.set(\lag, ez.value)},
			initVal:9,
			unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		losl = EZSlider(w, (w.bounds.width - 10) @ 20," loff ", \freq,
			controlSpec:ControlSpec(20, 10000, \exp, 1, 500, \Hz), action:{|ez| PavillionArc15.verber.set(\lo, ez.value)}, initVal:500,
			unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		hisl = EZSlider(w, (w.bounds.width - 10) @ 20," hiff ", \freq,
			controlSpec:ControlSpec(900, 19000, \exp, 1, 10000, \Hz), action:{|ez| PavillionArc15.verber.set(\hi, ez.value)}, initVal:500,
			unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		roomsl = EZSlider(w, (w.bounds.width - 10) @ 20," roomsize ", \freq,
			controlSpec:ControlSpec(1, 100, \lin, 1, 10), action:{|ez| PavillionArc15.verber.set(\room, ez.value)}, initVal:10,
			unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		dampsl = EZSlider(w, (w.bounds.width - 10) @ 20," damp ", \amp,
			controlSpec:ControlSpec(0, 1, \lin, 0.01, 0.4), action:{|ez| PavillionArc15.verber.set(\damp, ez.value)}, initVal: 0.4,
			unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		mixsl = EZSlider(w, (w.bounds.width - 10) @ 20," mix ", \amp,
			controlSpec:ControlSpec(0, 1, \lin, 0.01, 0.4), action:{|ez| PavillionArc15.verber.set(\mix, ez.value)}, initVal: 0.4,
			unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		w.view.decorator.nextLine;

		threshsl = EZSlider(w, (w.bounds.width - 10) @ 20," thresh ", \amp,
			controlSpec:ControlSpec(0, 1, \lin, 0.01, 0.5), action:{|ez| PavillionArc15.finalizer.set(\thresh, ez.value)}, initVal: 0.5,
			unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		ampsl = EZSlider(w, (w.bounds.width - 10) @ 20," amp ", \amp,
			controlSpec:ControlSpec(0, 10, \lin, 0.01, 4), action:{|ez| PavillionArc15.finalizer.set(\amp, ez.value)}, initVal: 4,
			unitWidth:0, numberWidth:45, layout:\horz)
		.setColors( Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black)
		.font_(Font("Helvetica", 11));

		sliders.addAll( [
			wrapsl, aconstsl, afactsl, bconstsl, bfactsl,
			accexpsl, accmulsl, accwaitsl,
			revlagsl,losl, hisl, roomsl, dampsl, mixsl, threshsl, ampsl
		] );

		w.front;

	}

	*saveSliderSettings {|list|	list.clear; sliders.do{|slid| list.add(slid.value) } }

	*loadSliderSettings {|list|
		sliders.do{|slid, i| slid.value = list.at(i); slid.doAction }
	}



	///////////////////////////////////


	*loadDefs {

		// SynthDef(\sinesweep1, { arg outBus=0, a=1, b=0, amp=0.2;
		// 	var snd, freq = a.linexp(0,1,20,1000);
		// 	var dur = b.linexp(0,1,0.001,20);
		// 	var env=XLine.kr(1, 0.0001, dur,doneAction:2);
		// 	snd = SinOsc.ar(env * freq, 0 , env * amp);
		// 	Out.ar(outBus, snd);
		// }).add;
		//
		// SynthDef(\sinesweep, { arg outBus=0, a=1, b=0, amp=0.2;
		// 	var snd, freq = a.linexp(0,1,20,1000);
		// 	var dur = b.linexp(0,1,0.001,20);
		// 	var env=XLine.kr(1, 0.0001, dur,doneAction:2);
		// 	snd = SinOsc.ar(env * freq, 0 , env * amp) ! 2;
		// 	Out.ar(outBus, snd);
		// }).add;
		//
		// // not yet
		// // SynthDef(\sinesweep, { arg outBus=0, a=1, b=0, amp=0.2;
		// // 	var snd, freq, dur, fenv, aenv;
		// // 	freq = a.abs.linexp(0,1,20,1000);
		// // 	dur = b.abs.linexp(0,1,0.001,20);
		// // 	fenv = (XLine.kr(1, 0.0001, dur, doneAction:2) - a).fold(0,1);
		// // 	aenv = (XLine.kr(1, 0.0001, dur, doneAction:2) - b).fold(0,1);
		// // 	snd = SinOsc.ar(fenv * freq, 0 , aenv * amp) ! 2;
		// // 	Out.ar(outBus, snd);
		// // }).add;
		// //
		// // Synth(\sinesweep,[\a,-0.9, \b,-0.8, \amp,0.2])
		//
		// SynthDef(\sinesweeplong, { arg outBus=0, a=1, b=0, amp=0.2;
		// 	var snd, freq = a.linexp(0,1,20,1000);
		// 	var dur = b.linexp(0,1,0.001,60);
		// 	var env=XLine.kr(1, 0.0001, dur,doneAction:2);
		// 	snd = SinOsc.ar(env * freq, 0 , env * amp) ! 2;
		// 	Out.ar(outBus, snd);
		// }).add;





		SynthDef(\sinesweep1, { arg outBus=0, a=1, b=0, amp=0.2;
			var snd, freq = a.linexp(0,1,100,1000);
			var dur = b.linexp(0,1,0.001,7);
			var env=XLine.kr(1, 0.0001, dur, doneAction:2);
			snd = SinOsc.ar(env * freq, 0 , env * amp);
			Out.ar(outBus, snd);
		}).add;

		SynthDef(\sinesweep2, { arg outBus=0, a=1, b=0, amp=0.2;
			var snd, freq = a.linexp(0,1,1000,100);
			var dur = b.linexp(0,1,0.1,0.001);
			var env=XLine.kr(1, 0.0001, dur, doneAction:2);
			snd = SinOsc.ar(env * freq, 0 , env * amp);
			Out.ar(outBus, snd);
		}).add;

		SynthDef(\sinesweeprev, { arg outBus=0, a=1, b=0, amp=0.2;
			var snd, freq = a.linexp(0,1,100,1000);
			var dur = b.linexp(0,1,0.001,7);
			var env=XLine.kr(0.0001, 1, dur, doneAction:2);
			snd = SinOsc.ar(env * freq, 0 , env * amp);
			Out.ar(outBus, snd);
		}).add;

		SynthDef(\sinesweeplong, { arg outBus=0, a=1, b=0, amp=0.2;
			var snd, freq = a.linexp(0,1,10,1000);
			var dur = b.linexp(0,1,0.001,60);
			var env=XLine.kr(1, 0.0001, dur,doneAction:2);
			snd = SinOsc.ar(env * freq, 0 , env * amp) ! 2;
			Out.ar(outBus, snd);
		}).add;










		SynthDef(\dlychn,{|mix=0.4, lo=100, hi=10000, dly=0.1, dlysp=0.01, lag=7|
			var in = In.ar(0,1);
			// in = FreeVerb.ar(in, mix.lag3(lag), room.lag(lag), damp.lag(lag));
			in = LPF.ar(HPF.ar(in, lo.lag(lag)), hi.lag(lag));
			dly = SinOsc.kr(dlysp, mul: dly).abs;
			// ReplaceOut.ar(0, in, DelayC.ar(in, delaytime:dly+0.000001) )
			Out.ar(0, [in, DelayC.ar(in, delaytime: (dly + 0.000001).lag3(lag) )] )
		}).add;


		SynthDef(\revchn,{|lo=100, hi=10000, dly=0.1, dlysp=0.01, mix=0.3, room=10, damp=0.9, lag=7|
			var in = In.ar(0,1);
			in = FreeVerb.ar(in, mix.lag3(lag), room.lag(lag), damp.lag(lag));
			in = LPF.ar(HPF.ar(in, lo.lag(lag)), hi.lag(lag));
			dly = SinOsc.kr(dlysp, mul: dly).abs;
			// Out.ar(0, in, DelayC.ar(in, delaytime:dly+0.000001) )
			ReplaceOut.ar(0, [in, DelayC.ar(in, delaytime: (dly + 0.000001).lag3(lag) )] )
		}).add;

		SynthDef(\revchnB,{|lo=100, hi=10000, dly=0.1, dlysp=0.01, mix=0.3, room=10, damp=0.9, lag=7|
			var in = In.ar(0,1);
			in = LPF.ar(HPF.ar(in, lo.lag(lag)), hi.lag(lag));
			dly = SinOsc.kr(dlysp, mul: dly).abs;
			in = [in, DelayC.ar(in, delaytime: (dly + 0.000001).lag3(lag))];
			in = FreeVerb.ar(in, mix.lag3(lag), room.lag(lag), damp.lag(lag));
			ReplaceOut.ar(0, in )
		}).add;


		// SynthDef(\revchn, {arg roomsize, revtime, damping, inputbw, spread = 15, drylevel, earlylevel,
		// 	taillevel;
		// 	var a = In.ar(0,1);
		// 	// var a = Resonz.ar(
		// 	// Array.fill(4, {Dust.ar(2)}), 1760 * [1, 2, 4, 8], 0.01).sum * 10;
		//
		// 	//    var a = SoundIn.ar(0);
		// 	//    var a = PlayBuf.ar(1, 0);
		//
		// 	Out.ar(0, GVerb.ar(
		// 		a,
		// 		roomsize,
		// 		revtime,
		// 		damping,
		// 		inputbw,
		// 		spread,
		// 		drylevel.dbamp,
		// 		earlylevel.dbamp,
		// 		taillevel.dbamp,
		// 	roomsize, 0.3) + a)
		// }).add;

		SynthDef(\revchn2,{|mix=0.4, room=1, lo=100, hi=10000, damp=0.1, dly=0.1, dlysp=0.01, lag=7|
			var in = In.ar(0,2);
			in = FreeVerb.ar(in, mix.lag(lag), room.lag(lag), damp.lag(lag));
			// in = LPF.ar(HPF.ar([in, in], lo.lag(0.1)), hi.lag(0.1));
			in = LPF.ar(HPF.ar(in, lo.lag(lag)), hi.lag(lag));
			// Out.ar(0, in)
			dly = SinOsc.kr(dlysp, mul:dly).abs;
			// ReplaceOut.ar(0, in, DelayC.ar(in, delaytime:dly+0.000001) )
			ReplaceOut.ar(0, [in, DelayC.ar(in, delaytime:dly+0.000001)] )
		}).add;


		SynthDef(\compress, { arg outBus=0, thresh=0.7, lag=3, amp=1;
			var out;
			out = In.ar(outBus, 2);
			// sustainer
			out = Compander.ar(out, out,
				thresh: thresh.lag3(lag),
				slopeBelow: 1,
				slopeAbove: 0.5,
				clampTime: 0.01,
				relaxTime: 0.01
			);
			ReplaceOut.ar(outBus, out * amp.lag3(lag));
		}).add;


		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////





		SynthDef(\duck2,{ arg
			out=0,
			freq = 25,
			gate = 1,
			pwmspeed=0.125,
			sf=0.25, sm=0.02, sa=1,
			rlo=20, rhi=3000, rq=1,
			rsize = 10, rtime = 20, damp = 0.2, wet=2,
			lag=7, pgain=3,
			attack=0.01, release=4, amp=1
			;

			var snd, vrb, env, fmod;

			fmod = LFNoise0.kr(sf, sm, sa).range(0,2);
			// fmod = 1 - LFNoise0.kr(sf, sm, sa).range(0,1);

			// pwmspeed = XLine.kr(Rand(0.001, pwmspeed), Rand(0.001, pwmspeed), release * 0.75);

			snd = VarSaw.ar(
				// freq * fmod.lag3(lag),
				// LFPulse.kr(freq * fmod.lag3(lag), 0, 0.25, [100,50], [100,50]),
				freq.lag3(lag) * fmod,
				0,
				LFTri.kr( [0.99,1.01] * pwmspeed.lag3(lag) ).range(0,1),
				// 0.1
			);

			snd = RLPF.ar(snd, rhi.lag(lag), rq.lag(lag));
			snd = RHPF.ar(snd, rlo.lag(lag), rq.lag(lag));

			vrb = GVerb.ar(snd,
				roomsize: rsize, revtime: rtime, damping: damp,
				drylevel: 0, earlyreflevel: 0.6, taillevel: 0.5,
				inputbw: 0.5, spread: 20,
				maxroomsize: 300,
				mul: 1, add: 0
			);

			wet = wet.lag(lag);
			snd = Mix([snd * (1-wet), vrb*wet]);
			snd = CompanderD.ar (in: snd,
				thresh: 0.1, slopeBelow: 1, slopeAbove: 0, clampTime: 0.01, relaxTime: 0.01
			);

			snd = (snd * (pgain.lag(lag))).softclip;

			snd = LPF.ar(snd, rhi.lag(lag));
			snd = HPF.ar(snd, rlo.lag(lag));

			env = EnvGen.ar(Env.adsr(attack, releaseTime:release), gate, doneAction:2);
			Out.ar(out, LeakDC.ar(snd) * env * amp.lag3(lag));

		}).add;

		SynthDef(\revchn1,{|mix=0.4, room=1, lo=100, hi=10000, damp=0.1|
			var in = In.ar(0,1);
			in = FreeVerb.ar(in, mix, room, damp);
			in = LPF.ar(HPF.ar(in, lo.lag(0.1)), hi.lag(0.1));
			ReplaceOut.ar(0, in)
		}).add;

		// SynthDef(\revchn,{|mix=0.4, room=1, lo=100, hi=10000, damp=0.1, dly=0.1, dlysp=0.01|
		// 	var in = In.ar(0,1);
		// 	in = FreeVerb.ar(in, mix, room, damp);
		// 	// in = LPF.ar(HPF.ar([in, in], lo.lag(0.1)), hi.lag(0.1));
		// 	in = LPF.ar(HPF.ar(in, lo.lag(0.1)), hi.lag(0.1));
		// 	// Out.ar(0, in)
		// 	dly = SinOsc.kr(dlysp, mul:dly).abs;
		// 	ReplaceOut.ar(0, in, DelayC.ar(in, delaytime:dly+0.000001) )
		// }).add;


		SynthDef(\verb2, {
			arg outBus=0, gate=0, room=0.95, mix=1.0;
			var out;
			out = In.ar(outBus, 2);
			out = FreeVerb2.ar(
				BPF.ar(out[0], 3500, 1.5),
				BPF.ar(out[1], 3500, 1.5), mix, room, 0.15) * EnvGen.kr(Env.new([0.02, 0.3, 0.02], [0.4, 0.01], [3, -4], 1),
				1-Trig.kr(gate, 0.01)
			) + out;
			out = HPF.ar(out * 1.2, 40);
			ReplaceOut.ar(outBus, out);
		}).add;

		SynthDef(\delay, {
			arg outBus=0, dly=0.75, rel=4, amp=0.5;
			var out;
			out = In.ar(outBus, 2);
			out = HPF.ar(out + CombC.ar(out, 2, dly, rel) * 1.2, 40);
			Out.ar(outBus, out * amp);
		}).add;

		SynthDef(\sustain, {
			arg outBus=0, thresh=0.7, amp=1, lag=3;
			var out;
			out = In.ar(outBus, 2);
			// sustainer
			out = Compander.ar(out, out, thresh: thresh,
				slopeBelow: 0.1, slopeAbove: 1,
				clampTime: 0.01, relaxTime: 0.01
			);
			ReplaceOut.ar(outBus, out.softclip * amp.lag3(lag));
		}).add;

		SynthDef(\sustain1, {
			arg outBus=0, thresh=0.7, keyBus=0, amp=1, lag=3;
			var out;
			out = In.ar(outBus, 1);
			keyBus = In.ar(keyBus, 1);
			// sustainer
			out = Compander.ar(out, keyBus, thresh: thresh,
				slopeBelow: 0.1, slopeAbove: 1,
				clampTime: 0.01, relaxTime: 0.01
			);
			ReplaceOut.ar(outBus, out.softclip * amp.lag3(lag));
		}).add;

		SynthDef(\limit, { arg outBus=0, dur=0.02, amp=1, lag=3;
			var out = In.ar(outBus, 2);
			out = Limiter.ar(out, amp.lag3(lag), dur);
			ReplaceOut.ar(outBus, out);
		}).add;

	}



	/*
	*play1 {|tdef|
	if ( loaded == false ){ this.load };
	this.stop;
	tdef.stop;
	tdef.clear;
	tdef = TaskProxy({
	var a, b, amp;
	inf.do{
	64.do{| i |
	a = 0.25 + (i*0.001);
	// b = 1 - (i * 0.003);
	b = (i * 0.003);
	amp = exprand(0.3,1);
	Synth(\sinesweep1,[\a, a, \b, b, \amp, amp], target:group);
	Synth(\sinesweeplong,[\a, a, \b, b, \amp, amp/2], target:group);
	(accmul * (0.5 * ( accexp ** i))).wait;

	};
	(accwait * [0.5,1,1,2,3].choose) .wait;
	}
	});

	^tdef.play;
	}

	*play2 {|tdef|
	if ( loaded == false ){ this.load };
	this.stop;
	tdef.stop;
	tdef.clear;
	tdef = TaskProxy({
	var a, b, amp;

	inf.do{

	128.do{| i |

	if( i < 64 ){
	a = 0.25 + (i*0.001);
	b = 1 - (i * 0.003);
	amp = exprand(0.3,1);
	Synth(\sinesweep1,[\a, a, \b, b, \amp, amp], target:group);
	Synth(\sinesweeplong,[\a, a, \b, b, \amp, amp/2], target:group);
	(accmul * (0.5 * ( accexp ** i))).wait;
	}{
	a = 0.25 + (i*0.001);
	b = (i * 0.003);
	amp = exprand(0.3,1);
	Synth(\sinesweep1,[\a, a, \b, b, \amp, amp], target:group);
	Synth(\sinesweeplong,[\a, a, \b, b, \amp, amp/2], target:group);
	(accmul * (0.5 * ( accexp ** i))).wait;
	};

	};

	(accwait * [0.5,1,1,2,3].choose) .wait;
	}
	});

	^tdef.play;
	}
	*/



}