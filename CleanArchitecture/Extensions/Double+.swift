extension Double {
    var currency: String {
        return String(format: "$%.02f", self)
    }
}
