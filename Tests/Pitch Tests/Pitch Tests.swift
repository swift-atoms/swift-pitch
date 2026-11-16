import Pitch
import Testing

@Suite
struct `Pitch Tests` {
    @Test(arguments: -30...30)
    func `A class counts round the octave, so twelve semitones more is the same class`(semitones: Int) {
        #expect(Pitch.Class(semitones) == Pitch.Class(semitones + 12))
        #expect((0..<12).contains(Pitch.Class(semitones).semitones))
    }

    @Test
    func `The twelve classes run up from C to B`() {
        #expect(Pitch.Class.allCases.map(\.semitones) == Array(0..<12))
        #expect(Pitch.Class.allCases.first == .c && Pitch.Class.allCases.last == .b)
        #expect(Pitch.Class.b.transposed(by: 1) == .c && Pitch.Class.c.transposed(by: -1) == .b)
    }

    @Test(arguments: -40...40)
    func `A pitch read from its semitones is the same pitch`(semitones: Int) {
        let pitch = Pitch(semitones: semitones)
        #expect(pitch.semitones == semitones)
        #expect(Pitch(pitch.class, octave: pitch.octave) == pitch)
    }

    @Test
    func `The octave goes up at C, so B in octave 3 is a semitone under middle C`() {
        let middle = Pitch(.c, octave: 4)
        #expect(middle.transposed(by: -1) == Pitch(.b, octave: 3))
        #expect(Pitch(.b, octave: 3) < middle)
        #expect(middle.semitones(from: Pitch(.a, octave: 3)) == 3)
        #expect(Pitch(semitones: -1) == Pitch(.b, octave: -1))
    }

    @Test
    func `A in octave 4 is 440 cycles a second in the standard tuning`() {
        #expect(Pitch(.a, octave: 4).frequency() == 440)
        #expect(Pitch(.a, octave: 5).frequency() == 880)
        #expect(Pitch(.a, octave: 3).frequency() == 220)
    }

    @Test(arguments: -24...24)
    func `Each semitone is the twelfth root of two above the one under it`(semitones: Int) {
        let pitch = Pitch(.a, octave: 4).transposed(by: semitones)
        let ratio = pitch.transposed(by: 1).frequency() / pitch.frequency()
        #expect(abs(ratio - 1.059_463_094_359_295_3) < 1e-12)
    }

    @Test
    func `Middle C in the standard tuning is about 261.63 cycles a second`() {
        #expect(abs(Pitch(.c, octave: 4).frequency() - 261.625_565_300_598_6) < 1e-9)
    }

    @Test
    func `Another tuning moves every pitch by the same ratio`() throws {
        let baroque = try Pitch.Tuning(Pitch(.a, octave: 4), at: 415)
        for semitones in -12...12 {
            let pitch = Pitch(.a, octave: 4).transposed(by: semitones)
            #expect(abs(pitch.frequency(in: baroque) / pitch.frequency() - 415.0 / 440) < 1e-12)
        }
        #expect(throws: Pitch.Tuning.Error.frequency) { try Pitch.Tuning(Pitch(.a, octave: 4), at: 0) }
        #expect(throws: Pitch.Tuning.Error.frequency) { try Pitch.Tuning(Pitch(.a, octave: 4), at: .infinity) }
    }

    @Test
    func `A scale keeps its classes once each, in order up from C`() throws {
        let scale = try Pitch.Scale([.a, .c, .e, .c, .g, .d])
        #expect(scale.classes == [.c, .d, .e, .g, .a])
        #expect(scale.contains(.g) && !scale.contains(.f))
        #expect(throws: Pitch.Scale.Error.empty) { try Pitch.Scale([]) }
    }

    @Test
    func `A scale's degrees go on into the next octave and down into the one below`() throws {
        let scale = try Pitch.Scale([.c, .d, .e, .g, .a])
        #expect(scale.pitch(at: 0, from: 4) == Pitch(.c, octave: 4))
        #expect(scale.pitch(at: 4, from: 4) == Pitch(.a, octave: 4))
        #expect(scale.pitch(at: 5, from: 4) == Pitch(.c, octave: 5))
        #expect(scale.pitch(at: -1, from: 4) == Pitch(.a, octave: 3))
        #expect(scale.pitch(at: -5, from: 4) == Pitch(.c, octave: 3))
        #expect(scale.pitch(at: -6, from: 4) == Pitch(.a, octave: 2))
    }

    @Test(arguments: -20...20)
    func `A scale's pitches rise with the degree`(degree: Int) throws {
        let scale = try Pitch.Scale([.d, .f, .a])
        #expect(scale.pitch(at: degree, from: 4) < scale.pitch(at: degree + 1, from: 4))
        #expect(scale.pitch(at: degree + 3, from: 4) == scale.pitch(at: degree, from: 5))
    }
}
