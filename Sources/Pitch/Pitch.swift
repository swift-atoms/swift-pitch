/// A pitch: a pitch class in an octave, in scientific pitch notation, where middle C is C in octave 4 and the
/// octave number goes up at each C.
public struct Pitch: Hashable, Sendable {
    /// The pitch's class: which of the twelve it is, whatever its octave.
    public let `class`: Class
    /// The octave, counted up from C: C in octave 4 is middle C, and B in octave 3 is a semitone under it.
    public let octave: Int

    @inlinable
    public init(_ class: Class, octave: Int) {
        self.class = `class`
        self.octave = octave
    }
}

extension Pitch {
    /// The semitones from C in octave 0 up to this pitch, negative below it: twelve to the octave.
    @inlinable
    public var semitones: Int { octave * 12 + `class`.semitones }

    /// The pitch that many semitones from C in octave 0, below it for a negative number.
    @inlinable
    public init(semitones: Int) {
        let (octave, remainder) = semitones.quotientAndRemainder(dividingBy: 12)
        self.init(Class(remainder), octave: remainder < 0 ? octave - 1 : octave)
    }

    /// The pitch `semitones` above this one, or below it for a negative number.
    @inlinable
    public func transposed(by semitones: Int) -> Self {
        Self(semitones: self.semitones + semitones)
    }

    /// The semitones from `other` up to this pitch, negative when this pitch is lower.
    @inlinable
    public func semitones(from other: Self) -> Int {
        semitones - other.semitones
    }
}

extension Pitch: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool { lhs.semitones < rhs.semitones }
}
