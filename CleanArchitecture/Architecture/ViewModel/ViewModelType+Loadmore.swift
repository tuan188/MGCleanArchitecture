import RxSwift
import RxCocoa
import OrderedSet

extension ViewModelType {
    func setupLoadMorePaging<T>(loadTrigger: Driver<Void>,
                                getItems: @escaping () -> Observable<PagingInfo<T>>,
                                refreshTrigger: Driver<Void>,
                                refreshItems: @escaping () -> Observable<PagingInfo<T>>,
                                loadMoreTrigger: Driver<Void>,
                                loadMoreItems: @escaping (Int) -> Observable<PagingInfo<T>>)
        -> (page: BehaviorRelay<PagingInfo<T>>,
            fetchItems: Driver<Void>,
            error: Driver<Error>,
            loading: Driver<Bool>,
            refreshing: Driver<Bool>,
            loadingMore: Driver<Bool>) {
            
            let pageSubject = BehaviorRelay<PagingInfo<T>>(value: PagingInfo<T>(page: 1, items: []))
            let errorTracker = ErrorTracker()
            let loadingActivityIndicator = ActivityIndicator()
            let refreshingActivityIndicator = ActivityIndicator()
            let loadingMoreActivityIndicator = ActivityIndicator()
            
            let loading = loadingActivityIndicator.asDriver()
            let refreshing = refreshingActivityIndicator.asDriver()
            let loadingMore = loadingMoreActivityIndicator.asDriver()
            
            let loadingOrLoadingMore = Driver.merge(loading, refreshing, loadingMore)
                .startWith(false)
            
            let loadItems = loadTrigger
                .withLatestFrom(loadingOrLoadingMore)
                .filter { !$0 }
                .flatMapLatest { _ in
                    getItems()
                        .trackError(errorTracker)
                        .trackActivity(loadingActivityIndicator)
                        .asDriverOnErrorJustComplete()
                }
                .do(onNext: { page in
                    pageSubject.accept(page)
                })
                .mapToVoid()
            
            let refreshItems = refreshTrigger
                .withLatestFrom(loadingOrLoadingMore)
                .filter { !$0 }
                .flatMapLatest { _ in
                    refreshItems()
                        .trackError(errorTracker)
                        .trackActivity(refreshingActivityIndicator)
                        .asDriverOnErrorJustComplete()
                }
                .do(onNext: { page in
                    pageSubject.accept(page)
                })
                .mapToVoid()
            
            let loadMoreItems = loadMoreTrigger
                .withLatestFrom(loadingOrLoadingMore)
                .filter { !$0 }
                .withLatestFrom(pageSubject.asDriverOnErrorJustComplete())
                .filter { !$0.items.isEmpty }
                .map { $0.page }
                .flatMapLatest { page in
                    loadMoreItems(page + 1)
                        .trackError(errorTracker)
                        .trackActivity(loadingMoreActivityIndicator)
                        .asDriverOnErrorJustComplete()
                }
                .filter { !$0.items.isEmpty }
                .withLatestFrom(pageSubject.asDriverOnErrorJustComplete()) {
                    ($0, $1)
                }
                .do(onNext: { page, currentPage in
                    let items: OrderedSet<T> = currentPage.items + page.items
                    let newPage = PagingInfo<T>(page: page.page, items: items)
                    pageSubject.accept(newPage)
                })
                .mapToVoid()    
            
            let fetchItems = Driver.merge(loadItems, refreshItems, loadMoreItems)
            return (pageSubject,
                    fetchItems,
                    errorTracker.asDriver(),
                    loading,
                    refreshing,
                    loadingMore)
    }
}
