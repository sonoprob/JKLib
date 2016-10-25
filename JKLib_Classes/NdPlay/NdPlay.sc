/*
*/



Te {
	classvar <all;
	/*
	a = Te(\lk);
	b = Te(\gz);
	Te.all
	*/

	*initClass { all = () }
	*new {|key| ^super.new.init(key) }
	init {|key| all.put(key, this) }

}


NdPlay {

	classvar <all;
	classvar <win, wheight=0, lheight=10, bottom=200, width=400;
	classvar skin, <nk, server, <presetPath, grey0=1, grey1=0.02, widgHeight=16;

	var <>wi, <key, <ndef, <>fadeTime=2, <specz, <preset, <>presetGui, <set;

	*initClass {

		all = ();

		presetPath = "/Users/a/dev/versioned/scwork/Classes_enabled/Classes_JK/2016/NdPlay" +/+ "presets";

		"TODO: preset basename relative".error;

		Class.initClassTree(JITGui);
		skin = (
			fontSpecs:      ["Helvetica", 8],
			fontColor:      Color.grey(grey0,1),
			background:     Color.grey(grey1,1),
			foreground:     Color.grey(grey1,1),
			onColor:        Color.grey(grey1,1),
			onColor2:       Color(0,1,1),
			offColor:       Color.grey(grey1, 0),
			hiliteColor:    Color.green(1.0, 0.5),
			gap:            0 @ 0,
			margin:         2@2,
			buttonHeight:   widgHeight,
			headHeight:     16
		);
		GUI.skins.put(\jit, skin);

		Spec.specs[\ffreq] = \freq.asSpec;

	}

	*new {|server, ndef, set, specs|
		^super.new.init(server, ndef, set, specs)
	}

	*clear {
		all.do(_.clear);
		all.clear;
	}

	// instance methods ////////////////////////////////////////////

	init{| server, ndef, set, specs |

		// grey0 = rrand(0.8, 1.0); // foregrounds / strings
		// grey1 = rrand(0, 0.2);   // backgrounds

		("mkdir -p" + presetPath + "&> /dev/null").unixCmd(postOutput:false);

		server = server ? Server.default;
		server.waitForBoot{

			this.create( server, ndef, set, specs );

			all.put(key, this);

		}
	}

	server { ^ndef.server }
	bus { ^ndef.bus }
	clear { /*all.at(key)*/ ndef.clear }

	create {|server, argNdef, argSet, argSpecs|

		argNdef.notNil.if({
			key = argNdef.key;
			ndef = argNdef;
		},{
			"using default ndef".inform;
			key = \default;
			ndef = Ndef(key,{|freq=220, mspeed=0.01, mdepth=0, pspeed=0, pdepth=0|
				var snd, pos = SinOsc.kr(pspeed, [0, SinOsc.kr(mspeed,0,mdepth*pi)], pdepth);
				snd = SinOsc.ar(freq);
				Pan2.ar(snd, Mix(pos))
			}).play;
			ndef.addSpec(\mspeed, [0, 7, \lin, 0.001, 0.01]);
			ndef.addSpec(\mdepth, [0, 1, \lin, 0.01, 0.5]);
			ndef.addSpec(\pspeed, [0, 7, \lin, 0.001, 0.01]);
			ndef.addSpec(\pdepth, [-1, 1, \lin, 0.01, 0]);
		});

		argSet.notNil.if({ set = argSet },{ set = 0 });
		// set = argSet ?? { 0 };

		argSpecs.notNil.if({
			argSpecs.do{|arr|
				var key, spec;
				#key, spec = arr;
				spec = spec.asSpec;
				ndef.addSpec(key, spec);
				Spec.specs.put(key, spec);
			}
		});


		this.checkSpecs;

		{
			0.2.yield;
			defer{ this.createControl(ndef, argSet) };
		}.r.play;

	}

	// replace ndef, ndefgui, and ktl
	replace {|obj, argSpecs|

		{
			// ndef.fadeTime = fadeTime;
			ndef.end(fadeTime);
			fadeTime.yield;
			ndef.clear;

			case
			{ obj.isKindOf(Function) }{ ndef.source = obj }
			{ obj.isKindOf(Ndef) }{ ndef = obj };

			defer{ this.create(server, ndef, set, argSpecs); ndef.play };
		}.r.play

	}

	createControl {|argNdef, argSet|
		{
			0.1.yield;
			{ this.createNdefGui( argNdef ) }.defer;
			0.1.yield;
			{ this.createMktl( argNdef, argSet ) }.defer;
		}.r.play;
	}

	createNdefGui {|argNdef|

		preset = NdefPreset( argNdef );
		preset.storePath = presetPath +/+ key ++ ".preset.scd";

		// preset.storeToDisk = true;
		// this class method will add a presetGui for this instance to the main window
		this.class.createWindow;


	}

	*createWindow {
		var left, bounds, nextBottom;
		nextBottom = 0;
		left = Window.screenBounds.width - width - 10;

		/*
		all.keysValuesDo{|key, ndplay|
			wheight = wheight + (74 + (ndplay.ndef.controlKeys.size * 20));
		};
		*/

		bounds = Rect( left, bottom, width, wheight );

		// bounds = Rect( left, bottom, width, 800 );

		// if( win.notNil ){ win.close }{
		//
		// 	// win = Window( this.name.asString, bounds: bounds, border: true, scroll: true);
		// 	win = Window( this.name.asString, bounds: bounds, border: true, scroll: false);
		// 	win.addFlowLayout;
		// 	win.alwaysOnTop_(true);
		// 	win.front;
		//
		// };

		// Rect(0,2,3,5).height_(200)

		all.keysValuesDo{|key, ndplay|
			var window;
			if( ndplay.wi.notNil ){ ndplay.wi.close };

			window = Window(
				ndplay.key.asString,
				bounds: bounds
					.top_(nextBottom)
					.height_(ndplay.ndef.controlKeys.size * (widgHeight+4) + 90),
				border: false, scroll: true
			).background_(Color.grey(grey1)).front.alwaysOnTop_(true);

			ndplay.presetGui = NdefPresetGui( ndplay.preset, ndplay.ndef.controlKeys.size + 1, window );
			nextBottom = nextBottom + window.bounds.height;

			// ndplay.presetGui =
			// NdefPresetGui(
			// 	ndplay.preset,
			// 	ndplay.ndef.controlKeys.size + 1,
			// 	win,
			// 	(width-10) @ (ndplay.ndef.controlKeys.size * 20)
			// );

			// presetGui.skipjack.dt = 0.05; // faster updates
			{
				0.5.yield;
				defer{

					ndplay.presetGui.proxyGui.paramGui.widgets.do{|wdg|
						wdg.notNil.if({
							wdg.labelView.stringColor_(Color.grey(grey0)).align_(\center);

							wdg.numberView
							.minDecimals_(0).maxDecimals_(3).align_(\center)
							.background_(Color.grey(grey1))
							.normalColor_(Color.grey(grey0))
						})
					};

					ndplay.presetGui.proxyGui.paramGui.drags.do{|wdg|
						wdg.background_(Color.grey(grey1)).stringColor_(Color.grey(grey0))
					};

					ndplay.presetGui.setLPop.stringColor_(Color.grey(grey0));
					ndplay.presetGui.setRPop.stringColor_(Color.grey(grey0));
					ndplay.presetGui.setLBox.stringColor_(Color.grey(grey0));
					ndplay.presetGui.setRBox.stringColor_(Color.grey(grey0));
					ndplay.presetGui.proxyGui.nameView.font_(Font("Helvetica",10,true,true));
					ndplay.presetGui.proxyGui.fadeBox.numberView.normalColor_(Color.grey(grey0)).align_(\center)

				}
			}.r.play;

			ndplay.wi = window;

		};

		// CmdPeriod.doOnce({
		// 	win.close;
		// 	// this.clear;
		// })


	}

	checkSpecs {

		ndef.controlKeys.do{|control|

			// ndef has halo
			Halo.at(ndef).notNil.if({
				Halo.at(ndef).spec.keys.includes(control).if({
					// spec found in halo, put it in global Spec identitydictionary
					Spec.specs[control] = Halo.at(ndef).spec.at(control)
				},
				{
					// spec not found in halo, look it up global specs
					if(Spec.specs[control].notNil){
						// global specs contains the spec
						ndef.addSpec(control, Spec.specs[control])
					}{
						// spec also not found in global specs
						"no spec found for: % -> %".format(control, Spec.specs[control]).error;

						// this.(autoFill:false, dialog:true)
					}

				})
			},{
				"no spec found for: %".format(control).warn;
			}
			)

		}

	}

	// specsDialog { |keys, specDict|
	//
	// 	var w, loc, name, proxyKeys, specKeys;
	// 	specDict = specDict ? specs;
	//
	// 	loc = loc ?? {400@300};
	// 	w = Window("specs please", Rect(loc.x, loc.y + 40, 300, 200)).front;
	// 	w.addFlowLayout;
	// 	StaticText(w, Rect(0,0,290,50)).align_(\center)
	// 	.string_(
	// 		"Please enter specs for the following\nparameter keys:"
	// 		"\n(min, max, warp, step, default, units)"
	// 	);
	//
	// 	keys.collect { |key|
	// 		var guessedSpec = Spec.guess(key, proxy.get(key)).storeArgs;
	// 		var eztext;
	// 		eztext = EZText(w, Rect(70,0,290,20), key, { |ez|
	// 			var spec = ez.value.asSpec;
	// 			specDict.put(key, spec);
	// 			[key, spec].postcs;
	// 			},
	// 			guessedSpec
	// 		);
	// 	};
	// }

	createMktl { |argNdef, argSet|

		ndef = argNdef ?? { ndef };

		{
			MIDIClient.initialized.not.if({ MIDIClient.init });
			0.5.yield;

			// "todo: detect connected NanoKtl".warn;
			// MIDIIn.connectByUID(0, -346030201)

			MIDIClient.sources
				.collect({|src| src.device })
				.select({|dev| dev == "nanoKONTROL" })
				.notEmpty.if(
				{
					this.createMktl2( ndef, argSet );
				},
				{
					"nanoKONTROL not found, hook it up within 30 seconds !".warn;
					{ Task({ 30.do{|i| (30-i).postln; }}).play; this.createMktl }.r.play;
				}
			)
		}.r.play

	}

	createMktl2 {|argNdef, argSet|
		var mapElemGroupToProxyParams, setNkProxy;

		nk.notNil.if({
			// nk.reset
		},{
			nk = MKtl(\nk1, "korg-nanokontrol");
		});

		set = argSet ?? { 0 };

		nk.elAt(\kn)[set].last.action = { |el|
			ndef.softVol_(
				\amp.asSpec.map(el.value),
				lastVal: \amp.asSpec.map(el.prevValue)
			);
		};

		mapElemGroupToProxyParams = { |group, proxy, keys|
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
					}
				}
			}
		};

		// mapElemGroupToProxyParams.value(
		// 	nk.elAt(\kn)[set].keep(8),
		// 	ndef
		// );

		setNkProxy = { | proxy, set=0|
			if (proxy.notNil) {

				var nkProxy = proxy;

				// use first 8 knobs:
				mapElemGroupToProxyParams.value(
					nk.elAt(\kn)[set].keep(8),
					nkProxy
				);
				// use last knob for volume control:
				nk.elAt(\kn)[set].last.action = { |el|
					nkProxy.vol_(\amp.asSpec.map(el.value));
				};

				// add play and stop buttons
				// q.nk.elAt(\play).action = { |el| q.nkProxy.play; };
				// q.nk.elAt(\stop).action = { |el| q.nkProxy.stop; };
			}
		};

		setNkProxy.value(ndef, set)

	}



}