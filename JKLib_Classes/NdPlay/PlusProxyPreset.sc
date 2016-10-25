// storeDialog(name, loc, size)
// deleteDialog(loc, size)
// buttons:

// scope
//
a.presetGui.proxyGui.paramGui

// sto, del
proxyGui.storeBtn.action_({ object.storeDialog(loc:
	(parent.bounds.left @ parent.bounds.top))
});

proxyGui.delBtn.action_({ object.deleteDialog(loc:
	(parent.bounds.left - 100 @ parent.bounds.bottom))
});

// + ProxyPresetGui



+ ProxyPreset {

	storeDialog { |name, loc, size| 		// check before overwriting a setting?
		var w;
		loc = loc ?? {400@300};
		if (name.isNil, { count = count + 1; name = "set" ++ count; });
		w = Window("", Rect(loc.x, loc.y + 40, size.x ? 150, size.y ? 40), false, border: false).alwaysOnTop_(true);
		w.background_(Color.black);
		StaticText(w, Rect(0,0,70,20)).align_(\center).string_("name set:");
		TextField(w, Rect(70,0,70,20)).align_(\center)
		.string_(name)
		.action_({ arg field;
			this.addSet(field.value.asSymbol, toDisk: storeToDisk);
			w.close;
		})
		.focus(true);
		w.front;
	}

	deleteDialog { |loc, size|
		var win, names, ezlist;
		var winOrigin, winSize = size ? (150@200);

		names = this.getSetNames;
		names.remove(\curr);
		loc = loc ?? { (100@400) };
		winOrigin = loc - winSize;

		win = Window("delete", Rect(winOrigin.x, winOrigin.y, 150,200), border: false).front;
		win.background_(Color.black);
		win.addFlowLayout;
		ezlist = EZListView(win, win.bounds.insetBy(4, 4),
			"DELETE presets from\n%:"
			"\nselect and backspace".format(this),
			names, nil, labelHeight: 50);
		ezlist.labelView.align_(\center);
		ezlist.view.resize_(5);
		ezlist.widget.resize_(5);
		ezlist.widget.keyDownAction_({ |view, char|
			if(char == 8.asAscii) {
				this.removeSet(view.items[view.value].postln);
				view.items = this.getSetNames;
			};
		});
		^win
	}

	specsDialog { |keys, specDict|

		var w, loc, name, proxyKeys, specKeys;
		specDict = specDict ? specs;

		loc = loc ?? {400@300};
		w = Window("specs please", Rect(loc.x, loc.y + 40, 300, 200)).front;
		w.addFlowLayout;
		StaticText(w, Rect(0,0,290,50)).align_(\center)
		.string_(
			"Please enter specs for the following\nparameter keys:"
			"\n(min, max, warp, step, default, units)"
		);

		keys.collect { |key|
			var guessedSpec = Spec.guess(key, proxy.get(key)).storeArgs;
			var eztext;
			eztext = EZText(w, Rect(70,0,290,20), key, { |ez|
				var spec = ez.value.asSpec;
				specDict.put(key, spec);
				[key, spec].postcs;
			},
			guessedSpec
			);
		};
	}

}