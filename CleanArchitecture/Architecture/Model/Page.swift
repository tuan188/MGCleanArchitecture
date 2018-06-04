import OrderedSet

protocol Pageable {
    var id: Int { get }
}

struct PagingInfo<T: Hashable> {
    let page: Int
    let items: OrderedSet<T>
}
