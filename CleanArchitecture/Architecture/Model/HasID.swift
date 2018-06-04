protocol HasID {
    var id: Int { get }
}

extension Hashable where Self: HasID {
    var hashValue: Int {
        return id
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
