import OrderedSet

struct PagingInfo<T: Hashable> {
    let page: Int
    let items: OrderedSet<T>
}
