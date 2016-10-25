/*

// Server.killAll;
s.boot;

PavillionArc2.free;PavillionArc2.play;

// interface
PavillionArc2.leftStrip;

PavillionArc2.loadSliderSettings([ 0, 0.09, 0.001, 0.2, 0, 0.97, 0.2, 3, 9, 1417, 19000, 5, 1, 0.07, 0.53, 1 ]);

PavillionArc2.ascope(style:2); //

// sustainer
PavillionArc2.finalize(\sustain, 0.3, 0.9);

[Window.screenBounds, PavillionArc2.w.bounds, PavillionArc2.scope.window.bounds, PavillionArc2.fscope.window.bounds ].postln;

*/

PavillionArc2 {

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

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
					// Synth(\sinesweep1,[\a, a, \b, b, \amp, amp ], target:PavillionArc2.group);
					Synth.grain(\sinesweep1,[\a, a, \b, b, \amp, amp ], target: PavillionArc2.group, addAction: \addToHead);

					amp = exprand(0.3,8);
					// Synth(\sinesweeplong,[\a, a, \b, b, \amp, amp/2], target:PavillionArc2.group);
					// Synth(\sinesweeprev,[\a, a, \b, b, \amp, amp ], target:PavillionArc2.group);
					// Synth(\sinesweep2,[\a, a, \b, b, \amp, amp ], target:PavillionArc2.group);
					Synth.grain(\sinesweep2,[\a, a, \b, b, \amp, amp ], target: PavillionArc2.group, addAction: \addToHead);

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

		if( Window.screenBounds.height < 1000 ){ size = 200 };

		{

			defer{
				// this.smallGuiScope;

				this.gui( Rect(0, size*2, size, Window.screenBounds.height - (size*2) ) );

				// w.bounds_(Rect(1050, 0, 630, 1050))

				// PavillionArc2.w.bounds_(Rect(0, 600, 300, 450))

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

				// ~fBounds = fscope.window.bounds;

				// fscope.window.view.mouseDownAction = {|a, b, c, d, e|
				//
				// 	[a,b].postln;
				// 	[ a TopView, 239 ]
				//
				// 	try { fscope.window.close };
				//
				// 	defer{
				//
				// 		{
				// 			1.wait;
				// 			if( b < 150 ){
				// 				fscope = server.afreqscope(~fBounds);
				// 			}{
				// 				fscope = server.afreqscope(
				// 					Window.screenBounds
				// 				)
				// 			};
				// 			1.wait;
				// 			fscope.scope.dbRange_(96).fill_(false).waveColors_([ Color.white  ]);
				// 		}.r.play;
				//
				// 	}
				//
				// };




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


	// slider
	// *saveSliderSettings {|list|	list.clear; sliders.do{|slid| list.add(slid.value) } }
	// ranger, take lo value

	*saveSliderSettings {|list|	list.clear; sliders.do{|slid| list.add(slid.lo) } }

	*loadSliderSettings {|list|

		// PavillionArc2.loadSliderSettings2([

		// PavillionArc2.t.play;
		//
		// PavillionArc2.t.set(\wrap, false)
		// PavillionArc2.t.set(\accwait, 0)
		// PavillionArc2.t.set(\accexp, 0.98)

		PavillionArc2.t.set(

		\aconst, list[0] ? 0.09,
		\afact, list[1] ? 0.001,
		\bconst, list[2] ? 0.2,
		\bfact, list[3] ? 0,
		\accexp, list[4] ? 0.97,
		\accmul, list[5] ? 0.2,
		\accwait, list[6] ? 3,

		\lag, list[7] ? 9,
		\lo, list[8]? 1417,
		\hi, list[9] ? 19000,
		\room, list[10] ? 5,
		\damp, list[11] ? 1,
		\mix, list[12] ? 0.07,

		\thresh, list[13] ? 0.53,
		\amp, list[14] ? 1
		)



		// ?deviation

		// sliders.do{|slid, i|
		//
		// 	if(slid.class == "EZSlider"){ slid.value = list.at(i) };
		//
		// 	if(slid.class == "EZRanger"){ slid.lo = list.at(i); slid.hi = list.at(i) };
		//
		// 	slid.doAction
		//
		// }


	}

	*gui {| bounds|

		// tdef env
		// verb set
		// finalize set

		var font, sw, sh=12, specs, sheight= 30, b, sl;
		var params, fxParams;
		var fwidth, fheight, width, height;
		var e,f,g;


		e = PavillionArc2.t.envir;
		fxParams = [\lag, \lo, \hi, \room, \damp, \dly, \mix, \thresh, \amp];
		params = e.keys.asArray.sort ++ fxParams;


		/////////////////////

		b = bounds ? Window.screenBounds;
		// b = Rect(300, 0, Window.screenBounds.width-400, Window.screenBounds.height);


		// b = Rect(300,0, b.width-300, b.height);

		// bounds = bounds ? Rect(b.height, 0, b.width-b.height, b.height); // default left

		bounds = b;

		// fwidth = ((width - 36)/ e.keys.size).round;
		// fheight = ((height - 36) / (e.keys.size * 2.5) ).round;
		// sw = (w.bounds.width - 10);
		sheight = (b.bounds.height / (e.keys.size * 2.5)).round;

		// fwidth = ((b.width - 36)/ params.size).round;
		// fheight = ((b.height - 36) / (params.size * 2.5) ).round;



		sw = bounds.width - 36;

		font = Font("Verdana", 9);

		// width = w.bounds.width;
		// height = w.bounds.height - 100;


		try{ w.close };
		if( w.isNil) { w = Window(bounds: bounds, border:false).onClose_({ w = nil }) }{ w.bounds_(bounds) };
		w.background_(Color(0,0,0));
		w.view.decorator=FlowLayout(w.view.bounds);
		w.view.decorator.margin=0@0;
		w.view.decorator.gap=2@4;

		Spec.add(\accamt, [1, 1024, \exp, 1, 32]);
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
		Spec.add(\doubleAcceleration, [0, 1, \lin, 1, 0]);
		Spec.add(\acceleration, [0, 1, \lin, 0.01, 0]);
		Spec.add(\regular, [0, 1, \lin, 0.01, 0]);
		Spec.add(\decceleration, [0, 1, \lin, 0.01, 0]);

		Spec.add(\wrap, [0, 1, \lin, 1, 0]);
		Spec.add(\aconst, [0, 0.2, \lin, 0.01, 0.25]);
		Spec.add(\afact, [0.001, 0.1, \lin, 0.0001, 0.001]);
		Spec.add(\bconst, [0, 0.2, \lin, 0.01, 0.25]);
		Spec.add(\bfact, [0.001, 0.1, \lin, 0.0001, 0.001]);
		Spec.add(\lag, [0.1, 120, \exp, 0.1, 9, \sec]);
		Spec.add(\lo, [20, 10000, \exp, 1, 500, \Hz]);
		Spec.add(\hi, [900, 19000, \exp, 1, 10000, \Hz]);
		Spec.add(\room, [1, 100, \lin, 1, 10]);
		Spec.add(\damp, [0, 1, \lin, 0.01, 0.4]);
		Spec.add(\dly, [0.0001, 1, \exp, 0.01, 0.4]);
		Spec.add(\mix, [0, 1, \lin, 0.01, 0.4]);
		Spec.add(\thresh, [0, 1, \lin, 0.01, 0.5]);
		Spec.add(\amp, [0, 10, \lin, 0.01, 4]);

		// ~actions = ();
		// ~actions.putAll([
		// 	\wrap, {|ez| ez.value.post },
		// 	\aconst, {|ez| ez.value.post },
		// 	\afact, {|ez| ez.value.post },
		// 	\bconst, {|ez| ez.value.post },
		// 	\bfact, {|ez| ez.value.post },
		// 	\accexp, {|ez| ez.value.post },
		// 	\accmul, {|ez| ez.value.post },
		// 	\accwait,{|ez| ez.value.post },
		// 	\lag, {|ez| ez.value.post },
		// 	\hiff,{|ez| ez.value.post },
		// 	\loff,{|ez| ez.value.post },
		// 	\room,{|ez| ez.value.post },
		// 	\damp,{|ez| ez.value.post },
		// 	\mix,{|ez| ez.value.post },
		// 	\thresh,{|ez| ez.value.post },
		// 	\amp,{|ez| ez.value.post },
		// 	\accamt,{|ez| ez.value.post },
		// 	\doubleAcceleration,{|ez| ez.value.post },
		// 	\acceleration,{|ez| ez.value.post },
		// 	\regular,{|ez| ez.value.post },
		// 	\decceleration,{|ez| ez.value.post }
		// ]);

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
			Button(w,  20 @ 20 )
			.states_([[ key.asString, Color.red, Color.black]])
			.action_({|but|
				// but.string.asSymbol.postln;
				PavillionArc2.loadSliderSettings(~presets.at(but.string.asSymbol));
			});
		};

		f = params.collect{|key, i|
			// [key, i].postln;
			// var initval = Spec.specs.at( key ).default ? nil;
			// Spec.specs.at(\accmul).default
			// ControlSpec(\accmul).dump

			// [ accamt, 0 ]
			// [ accelaration, 1 ]
			// [ accexp, 2 ]
			// [ accmul, 3 ]
			// [ accwait, 4 ]
			// [ aconst, 5 ]
			// [ afact, 6 ]
			// [ bconst, 7 ]
			// [ bfact, 8 ]
			// [ deccelaration, 9 ]
			// [ doubleAcceleration, 10 ]
			// [ regular, 11 ]
			// [ wrap, 12 ]
			// [ lag, 13 ]
			// [ lo, 14 ]
			// [ hi, 15 ]
			// [ room, 16 ]
			// [ damp, 17 ]
			// [ mix, 18 ]
			// [ thresh, 19 ]
			// [ amp, 20 ]

			// g = EZRanger(w,
			// 	// fwidth @ height,
			// 	// (width - 36) @ fheight,
			// 	// (width - 30) @ 20,
			// 	sw @ sh,
			// 	key.asString, Spec.specs.at(key),
			//
			// 	labelWidth:50, numberWidth: 30, unitWidth:0,
			// 	// initVal: initval,
			// 	layout:\horz, margin:0@0
			// );

			// if( i < e.keys.size ){
			// 	g.lo_(PavillionArc2.t.envir.at(key)).hi_(PavillionArc2.t.envir.at(key))
			// }{
			// 	// PavillionArc2.fxGroup.set(key, val)
			// 	// PavillionArc2.fxGroup
			//
			// };

			g = EZSlider(w,
				sw @ sheight,
				key.asString,
				controlSpec: Spec.specs.at(key),
				// action: actions[key],
				labelWidth:100,
				numberWidth: 50,
				unitWidth:0,
				layout:\horz,
				margin:0@0
			);

			g.action_({|view|
				var val;
				val = view.value;

				// if(view.lo == view.hi){ view.hi = view.hi+0.02; view.lo = view.lo-0.02; };
				// val = rrand(view.lo, view.hi);
				// [key, val].postln;

				if( i < e.keys.size ){
					PavillionArc2.t.envir.put(key, val)
				}{
					PavillionArc2.fxGroup.set(key, val)
				}
			});
			g.font_(font);

			// g.setColors(Color. black, Color.white, Color.black,Color.black, Color.white, Color.white, nil, Color.black, Color.black);

			g.setColors(
				Color.black,Color.grey(0.8), Color.black,Color.black, Color.grey(0.1), Color.white,
				background:Color.grey(0,0),
				knobColor: Color.black
			);

			// g.loBox.align_(\center);
			// g.hiBox.align_(\center);

			// g.lo_(initval).hi_(initval)

		};


		w.front;

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

		SynthDef(\dlychn,{|dmix=0.4, lo=100, hi=10000, dly=0.1, dlysp=0.01, lag=7|
			var flt, in = In.ar(0,1);
			// in = FreeVerb.ar(in, mix.lag3(lag), room.lag(lag), damp.lag(lag));
			dly = SinOsc.kr(dlysp, mul: dly).abs;
			// ReplaceOut.ar(0, in, DelayC.ar(in, delaytime:dly+0.000001) )
			flt = LPF.ar(HPF.ar(in, lo.lag(lag)), hi.lag(lag));
			Out.ar(0, Mix([in,  DelayC.ar(flt, delaytime: (dly + 0.000001).lag3(lag)) ]))
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