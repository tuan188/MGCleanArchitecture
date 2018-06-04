import Foundation
import RxSwift
import RxCocoa

extension ObservableType where E == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
}

extension ObservableType {
    public func unwrap<T>() -> Observable<T> where E == T? {
        return self
            .filter { value in
                if case .some = value {
                    return true
                }
                return false
            }.map { $0! }
    }
}

extension SharedSequenceConvertibleType {
    
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
    
    func mapToOptional() -> SharedSequence<SharingStrategy, E?> {
        return map { value -> E? in value }
    }
    
    public func unwrap<T>() -> SharedSequence<SharingStrategy, T> where E == T? {
        return self
            .filter { value in
                if case .some = value {
                    return true
                }
                return false
            }.map { $0! }
    }
}

extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func mapToOptional() -> Observable<E?> {
        return map { value -> E? in value }
    }
}

fileprivate func getThreadName() -> String {
    if Thread.current.isMainThread {
        return "Main Thread"
    } else if let name = Thread.current.name {
        if name == "" {
            return "Anonymous Thread"
        }
        return name
    } else {
        return "Unknown Thread"
    }
}

extension ObservableType {
    func dump() -> Observable<Self.E> {
        return self.do(onNext: { element in
            let threadName = getThreadName()
            print("[D] \(element) received on \(threadName)")
        })
    }
    
    func dumpingSubscription() -> Disposable {
        return self.subscribe(onNext: { element in
            let threadName = getThreadName()
            print("[S] \(element) received on \(threadName)")
        })
    }
}

