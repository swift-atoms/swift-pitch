# swift-pitch

Use this package when you need musical pitch as a value: which note a sound is, which notes a scale holds, and how many cycles a second a note is. Start from `Pitch`, a `Pitch.Class` (one of the twelve, C to B) in an octave, in scientific pitch notation, so middle C is `Pitch(.c, octave: 4)`. Ask a pitch for its `frequency(in:)` a `Pitch.Tuning`, twelve-tone equal temperament from one reference pitch at one frequency, the standard tuning being A in octave 4 at 440 cycles a second. Read a `Pitch.Scale`, a set of classes, by degree from an octave. The package knows nothing about sound or samples: frequencies are numbers in cycles per unit of time, and measuring a pitch in a signal is the signal's business.

## Laws

- A frequency is a `Frequency.Value<Double>` of swift-frequency, a quantity in hertz, which this package re-exports: a tuning's reference frequency and `frequency(in:)` both are one.

- A class is its semitones above C counted round the octave: `Pitch.Class(12)` is C and `Pitch.Class(-1)` is B. Its `semitones` lie in 0 to 11, and the classes order up from C.
- A pitch's `semitones` count from C in octave 0, twelve to the octave; the octave goes up at each C, so B in octave 3 is one semitone under middle C. `Pitch(semitones:)` is its inverse for every whole number, negative ones included, and `transposed(by:)` is moving that count.
- `frequency(in:)` is the tuning's frequency times 2 to the power of the semitones from the tuning's reference over 12: an octave doubles it, each semitone multiplies it by the twelfth root of two, and changing the reference frequency scales every pitch by the same ratio. A tuning's frequency is positive and finite, or `Pitch.Tuning(_:at:)` fails with `.frequency`. `Pitch.Tuning.ratio(semitones:)` is the ratio of an interval in that temperament, 2 to the power of its semitones over 12, whatever the reference; `frequency(in:)` is the reference frequency times the ratio of the interval up from the reference.
- A scale holds each of its classes once, in order up from C; a scale of no classes fails with `.empty`. `pitch(at:from:)` is degree 0 at the scale's lowest class in the given octave, each degree up the next class, on into the next octave after the last; negative degrees go down the same way. So a scale of n classes gives the same pitch an octave up n degrees on, and its pitches rise with the degree.
