extension Pitch {
    /// One of the twelve pitch classes of the octave: the pitches a whole number of octaves apart, named by their
    /// semitones above C, from 0 for C to 11 for B.
    public struct Class: Hashable, Sendable {
        /// The semitones above C, from 0 up to 11.
        public let semitones: Int

        /// The class `semitones` above C, counted round the octave: 12 is C again and −1 is B.
        @inlinable
        public init(_ semitones: Int) {
            let remainder = semitones % 12
            self.semitones = remainder < 0 ? remainder + 12 : remainder
        }
    }
}

extension Pitch.Class {
    public static let c = Self(0)
    public static let cSharp = Self(1)
    public static let d = Self(2)
    public static let dSharp = Self(3)
    public static let e = Self(4)
    public static let f = Self(5)
    public static let fSharp = Self(6)
    public static let g = Self(7)
    public static let gSharp = Self(8)
    public static let a = Self(9)
    public static let aSharp = Self(10)
    public static let b = Self(11)

    /// The class `semitones` above this one, round the octave.
    @inlinable
    public func transposed(by semitones: Int) -> Self {
        Self(self.semitones + semitones % 12)
    }
}

extension Pitch.Class: Comparable {
    /// Up the octave from C.
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool { lhs.semitones < rhs.semitones }
}

extension Pitch.Class: CaseIterable {
    /// The twelve classes up the octave from C.
    public static let allCases: [Self] = (0..<12).map(Self.init)
}
