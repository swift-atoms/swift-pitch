extension Pitch {
    /// A scale: a set of pitch classes, in order up the octave from C, read by degree.
    ///
    /// Degree 0 is the lowest class from C in the octave asked for; each degree up is the next class, and past the
    /// last class the scale goes on in the next octave. Negative degrees go down the same way.
    public struct Scale: Hashable, Sendable {
        /// The scale's classes, each once, in order up from C.
        public let classes: [Class]

        /// The scale of these classes, in order up from C, each once however often it is given. Fails with `.empty`
        /// for no classes.
        @inlinable
        public init(_ classes: some Sequence<Class>) throws(Error) {
            let distinct = Set(classes).sorted()
            guard !distinct.isEmpty else { throw .empty }
            self.classes = distinct
        }
    }
}

extension Pitch.Scale {
    public enum Error: Swift.Error, Hashable, Sendable {
        /// A scale of no classes.
        case empty
    }

    /// The pitch at `degree` of the scale counted from its lowest class in `octave`.
    @inlinable
    public func pitch(at degree: Int, from octave: Int) -> Pitch {
        let (up, remainder) = degree.quotientAndRemainder(dividingBy: classes.count)
        let below = remainder < 0
        return Pitch(classes[below ? remainder + classes.count : remainder], octave: octave + (below ? up - 1 : up))
    }

    /// Whether the class is one of the scale's.
    @inlinable
    public func contains(_ class: Pitch.Class) -> Bool {
        classes.contains(`class`)
    }
}
