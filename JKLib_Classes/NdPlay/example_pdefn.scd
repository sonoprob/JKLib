(
Pdefn(\midi, Pseq([59, 61, 66, 68, 69, 61,
   59, 68, 66, 61, 69, 68], inf));
Pdefn(\sawWidth, Pseq([0.1, 0.5, 0.2, 0.5, 0.5, 0.5,
   0.1, 0.5, 0.5, 0.1, 0.5, 0.5], inf));

Tdef(\reich, {
   var midi = Pdefn(\midi).asStream,
   sawWidth = Pdefn(\sawWidth).asStream;
   loop {
      ~out.set(
         \t_trig, 1,
         \freq, midi.next.midicps,
         \width, sawWidth.next
      );
      0.15.wait;
   }
}).play;
)