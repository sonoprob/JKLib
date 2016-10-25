/*
*/

NdtPlay {

	classvar <all;
	classvar <win, wheight=0, lheight=10, bottom=200, width=400;
	classvar skin, <nk, server, <presetPath, grey0=1, grey1=0.02, widgHeight=16;

	var <>wi, <key, <ndef, <>fadeTime=2, <tdef, /*<specz,*/ <preset, <>presetGui, <tpreset, <>tpresetGui, <set=0;

	*initClass {

		all = ();

		presetPath = "/Users/a/dev/versioned/scwork/Classes_enabled/Classes_JK/2016/ndtplay" +/+ "presets";

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

	*new {|server, ndef, tdef, set, specs|
		^super.new.init(server, ndef, tdef, set, specs)
	}

	*clear {
		all.do(_.clear);
		all.clear;
	}

	// instance methods ////////////////////////////////////////////

	init{| server, ndef, tdef, set, specs |

		// grey0 = rrand(0.8, 1.0); // foregrounds / strings
		// grey1 = rrand(0, 0.2);   // backgrounds

		("mkdir -p" + presetPath + "&> /dev/null").unixCmd(postOutput:false);

		server = server ? Server.default;
		server.waitForBoot{

			this.create( ndef, tdef, set, specs );
			all.put(key, this);

		}
	}

	server { ^ndef.server }
	bus { ^ndef.bus }
	clear { /*all.at(key)*/ tdef.clear; tdef.envir.clear; ndef.clear }

	create {|argNdef, argTdef, argSet, argSpecs|

		case
		{ argTdef.notNil and: argNdef.isNil }
		{
			this.create_t(argTdef, argSet, argSpecs)
		}
		{ argNdef.notNil and: argTdef.isNil }
		{
			this.create_n(argNdef, argSet, argSpecs)
		}
		{ (argNdef.notNil and: argTdef.notNil) or: (argTdef.isNil and: argNdef.isNil) }
		{
			this.create_t(argTdef, argSet, argSpecs);
			this.create_n(argNdef, argSet, argSpecs)
		};

	}

	create_t {|argTdef, argSet, argSpecs|

		argTdef.notNil.if({
			key = argTdef.key;
			tdef = argTdef;
		},{
			"using default tdef".inform;
			key = \default;

			tdef = Tdef(key);
			tdef.envir = (verbose: 0, amt: 4, waittime0: 2, waittime1: 0.5);
			tdef.source = {|env|
				// env.amt = 4;
				// env.waittime0 = 2;
				// env.waittime1 = 0.5;
				// env.verbose = 0;
				inf.do{|i|
					env.amt.do{|j|
						if( env.verbose == 1 ){ [ key, i, j ].postcln };
						env.waittime1.wait;
					};
					env.waittime0.wait;
				}
			};

			tdef.addSpec(\verbose, [0, 1, \lin, 1, 1]);
			tdef.addSpec(\amt, [0, 32, \lin, 1, 4]);
			tdef.addSpec(\waittime0, [0, 16, \lin, 1, 2]);
			tdef.addSpec(\waittime1, [0, 2, \lin, 0.125, 0.5]);

			tdef.play;

		});

		argSpecs.notNil.if({
			argSpecs.do{|arr|
				var key, spec;
				#key, spec = arr;
				spec = spec.asSpec;
				tdef.addSpec(key, spec);
				Spec.specs.put(key, spec);
			}
		});

		this.checkSpecs(tdef);

		argSet.notNil.if({ set = argSet });

		{ 0.2.yield; defer{ this.createControl(tdef, set) } }.r.play

	}

	create_n {|argNdef, argSet, argSpecs|

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


		argSpecs.notNil.if({
			argSpecs.do{|arr|
				var key, spec;
				#key, spec = arr;
				spec = spec.asSpec;
				ndef.addSpec(key, spec);
				Spec.specs.put(key, spec);
			}
		});

		this.checkSpecs(ndef);

		argSet.notNil.if({ set = argSet });

		{ 0.2.yield; defer{ this.createControl(ndef, set) } }.r.play


	}

	//////////////

	createControl {|obj, argSet|
		case
		//		{ obj.isKindOf(Function) }{ ndef.source = obj }
		{ obj.isKindOf(Tdef) }{
			{
				0.1.yield;
				{ this.createTdefGui( obj ) }.defer;
				0.1.yield;
				{ this.createMktl( obj, argSet ) }.defer;
			}.r.play;
		}
		{ obj.isKindOf(Ndef) }{
			{
				0.1.yield;
				{ this.createNdefGui( obj ) }.defer;
				0.1.yield;
				{ this.createMktl( obj, argSet ) }.defer;
			}.r.play
		};

		// preset.storeToDisk = true;
		// this class method will add a presetGui for this instance to the main window
		{
			1.yield;
			{ this.class.createWindow }.defer;
		}.r.play

	}

	// replace ndef/tdef  it's gui, and ktl
	replace {|obj, argSpecs|

		{
			// ndef.fadeTime = fadeTime;

			case
			// { obj.isKindOf(Function) }{ ndef.source = obj }
			{ obj.isKindOf(Tdef) }{
				tdef.clear;
				tdef.envir.clear;
				tdef = obj;
				// source : nil
				// .quant_
				// .reset_(true)
				defer{
					this.create(argTdef:obj, argSet:set, argSpecs:argSpecs); tdef.play
				};
			}

			{ obj.isKindOf(Ndef) }{
				ndef.end(fadeTime);
				fadeTime.yield;
				ndef.clear;
				ndef = obj;
				defer{
					this.create(argNdef:obj, argSet:set, argSpecs:argSpecs); tdef.play
				};

			}
			;


		}.r.play

	}


	createNdefGui {|argNdef|

		preset = NdefPreset( argNdef );
		preset.storePath = presetPath +/+ key ++ ".preset.scd";


	}

	createTdefGui {|argTdef|

		// *new { |key, namesToStore, settings, specs, morphFuncs|

		tpreset = TdefPreset( argTdef.key );
		tpreset.storePath = presetPath +/+ key ++ ".tpreset.scd";

	}


	*createWindow {
		var left, bounds, nextBottom;

		nextBottom = 0;
		left = Window.screenBounds.width - width - 10;
		bounds = Rect( left, bottom, width, wheight );

		all.keysValuesDo{|key, ndtplay|
			var window, height;

			ndtplay.tpreset.notNil.if({ height = (ndtplay.tdef.envir.keys.size * (widgHeight+4) + 90) });
			ndtplay.preset.notNil.if({ height = height + (ndtplay.ndef.controlKeys.size * (widgHeight+4) + 90) });

			if( ndtplay.wi.notNil ){ ndtplay.wi.close };
			window = Window( ndtplay.key.asString, bounds: bounds.top_(nextBottom).height_( height ), border: false, scroll: false)
			.background_(Color.grey(grey1))
			.alwaysOnTop_(true)
			.front;

			window.addFlowLayout;

			// *new { |object, numItems = (0), parent, bounds, makeSkip = true, options = #[]|
			ndtplay.tpreset.notNil.if({
				ndtplay.tpresetGui = TdefPresetGui( ndtplay.tpreset, ndtplay.tdef.envir.keys.size + 1, window );
				// tpresetGui.skipjack.dt = 0.05; // faster updates
			});

			ndtplay.preset.notNil.if({
				ndtplay.presetGui = NdefPresetGui( ndtplay.preset, ndtplay.ndef.controlKeys.size + 1, window );
				// presetGui.skipjack.dt = 0.05; // faster updates
			});

			nextBottom = nextBottom + window.bounds.height;

			{

				0.5.yield;

				defer{
					ndtplay.tpreset.notNil.if({
						ndtplay.tpresetGui.proxyGui.envirGui.widgets.do{|wdg|
							wdg.notNil.if({
								wdg.labelView.stringColor_(Color.grey(grey0)).align_(\center);
								wdg.numberView
								.minDecimals_(0).maxDecimals_(3).align_(\center)
								.background_(Color.grey(grey1))
								.normalColor_(Color.grey(grey0))
							})
						};
						ndtplay.tpresetGui.setLPop.stringColor_(Color.grey(grey0));
						ndtplay.tpresetGui.setRPop.stringColor_(Color.grey(grey0));
						ndtplay.tpresetGui.setLBox.stringColor_(Color.grey(grey0));
						ndtplay.tpresetGui.setRBox.stringColor_(Color.grey(grey0));
						ndtplay.tpresetGui.proxyGui.nameBut.font_(Font("Helvetica",10,true,true));
					});

					ndtplay.preset.notNil.if({
						ndtplay.presetGui.proxyGui.paramGui.widgets.do{|wdg|
							wdg.notNil.if({
								wdg.labelView.stringColor_(Color.grey(grey0)).align_(\center);
								wdg.numberView
								.minDecimals_(0).maxDecimals_(3).align_(\center)
								.background_(Color.grey(grey1))
								.normalColor_(Color.grey(grey0))
							})
						};
						ndtplay.presetGui.proxyGui.paramGui.drags.do{|wdg|
							wdg.background_(Color.grey(grey1)).stringColor_(Color.grey(grey0))
						};
						ndtplay.presetGui.setLPop.stringColor_(Color.grey(grey0));
						ndtplay.presetGui.setRPop.stringColor_(Color.grey(grey0));
						ndtplay.presetGui.setLBox.stringColor_(Color.grey(grey0));
						ndtplay.presetGui.setRBox.stringColor_(Color.grey(grey0));
						ndtplay.presetGui.proxyGui.nameView.font_(Font("Helvetica",10,true,true));
						ndtplay.presetGui.proxyGui.fadeBox.numberView.normalColor_(Color.grey(grey0)).align_(\center)

					});
				}
			}.r.play;

			ndtplay.wi = window;

		};

		// CmdPeriod.doOnce({
		// 	win.close;
		// 	// this.clear;
		// })


	}

	checkSpecs {|obj|

		case
		{ obj.isKindOf(Tdef) }{

			obj.envir.keys.do{|control|
				control.postcln;

				// tdef has halo
				Halo.at(obj).notNil.if({

					Halo.at(obj).spec.keys.includes(control).if({
						// spec found in halo, put it in global Spec identitydictionary
						Spec.specs[control] = Halo.at(obj).spec.at(control)
						},
						{
							// spec not found in halo, look it up global specs
							if(Spec.specs[control].notNil){
								// global specs contains the spec
								obj.addSpec(control, Spec.specs[control])
							}{
								// spec also not found in global specs
								"no spec found for: % -> %".format(control, Spec.specs[control]).error;

								// this.(autoFill:false, dialog:true)
							}

					})


					},{
						"no spec found for: %".format(control).warn;
				})

			}

		}
		{ obj.isKindOf(Ndef) }{
			obj.controlKeys.do{|control|

				// ndef has halo
				Halo.at(obj).notNil.if({
					Halo.at(obj).spec.keys.includes(control).if({
						// spec found in halo, put it in global Spec identitydictionary
						Spec.specs[control] = Halo.at(obj).spec.at(control)
					},
					{
						// spec not found in halo, look it up global specs
						if(Spec.specs[control].notNil){
							// global specs contains the spec
							obj.addSpec(control, Spec.specs[control])
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

			};
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



	createMktl { |obj, argSet|

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
					this.createMktl2( obj, argSet )

				},
				// {
				// 	"nanoKONTROL not found, hook it up within 30 seconds !".warn;
				// 	{
				// 		Task({
				// 			30.do{|i|
				// 				(30-i).postln
				// 			};
				// 			this.createMktl
				// 		}).play;
				// 	}.r.play;
				// }
			)
		}.r.play

	}

	createMktl2 {|obj, argSet|
		var mapElemGroupToProxyParams, setNkProxy;

		nk.notNil.if({},{ nk = MKtl(\nk1, "korg-nanokontrol") });

		set = argSet ? set;

		set.postcln;

		case
		{obj.isKindOf(Ndef)}{

			nk.elAt(\kn)[set].last.action = { |el|
				ndef.softVol_( \amp.asSpec.map(el.value), lastVal: \amp.asSpec.map(el.prevValue) );
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

					mapElemGroupToProxyParams.value(
						nk.elAt(\kn)[set].keep(8),
						nkProxy
					);

					nk.elAt(\kn)[set].last.action = { |el|
						nkProxy.vol_(\amp.asSpec.map(el.value));
					};

					// nk.elAt(\play)[set].action = { |el| nkProxy.play; };
					// nk.elAt(\stop)[set].action = { |el| nkProxy.stop; };
				}
			};

			setNkProxy.value(ndef, set)

		}
		{obj.isKindOf(Tdef)}{

			"todo: impl tdef ktl".inform

		}

	}




}