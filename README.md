# iOS Clean Architecture (MVVM + RxSwift)

## Installation
```
$ pod install
```

## High Level Overview

<img width="600" alt="High Level Overview" src="images/high_level_overview.png">

* **Domain Layer**: Entities + Use Cases + Gateway Protocols
* **Data Layer**: Gateway Implementations + API (Network) + Database
* **Presentation Layer**: ViewModels + Views  + Navigator + Scene Use Cases

**Dependency Direction**

<img width="500" alt="Dependency Direction" src="images/dependency_direction.png">


## Detail Overview

<img width="800" alt="Detail Overview" src="images/detail_overview.png">


### Domain Layer

<img width="500" alt="Domain Layer" src="images/domain.png">

#### Entities
Entities encapsulate enterprise-wide Critical Business Rules. An entity can be an object with methods, or it can be a set of data structures and functions. It doesn’t matter so long as the entities can be used by many different applications in the enterprise. - _Clean Architecture: A Craftsman's Guide to Software Structure and Design (Robert C. Martin)_

Entities are simple data structures:

```swift
struct Product {
    var id = 0
    var name = ""
    var price = 0.0
}
```

#### Use Cases

The software in the use cases layer contains application-specific business rules. It encapsulates and implements all of the use cases of the system. These use cases orchestrate the flow of data to and from the entities, and direct those entities to use their Critical Business Rules to achieve the goals of the use case. - _Clean Architecture: A Craftsman's Guide to Software Structure and Design (Robert C. Martin)_

UseCases are protocols which do one specific thing:

```swift
protocol GettingProductList {
    var productGateway: ProductGatewayType { get }
}

extension GettingProductList {
    func getProductList(page: Int) -> Observable<PagingInfo<Product>> {
        return productGateway.getProductList(page: page)
    }
}
```

#### Gateway Protocols
Generally gateway is just another abstraction that will hide the actual implementation behind, similarly to the Facade Pattern. It could a Data Store (the Repository pattern), an API gateway, etc. Such as Database gateways will have methods to meet the demands of an application. However do not try to hide complex business rules behind such gateways. All queries to the database should relatively simple like CRUD operations, of course some filtering is also acceptable. - [Source](https://crosp.net/blog/software-architecture/clean-architecture-part-2-the-clean-architecture/)

```swift
protocol ProductGatewayType {
    func getProductList(page: Int) -> Observable<PagingInfo<Product>>
    func deleteProduct(id: Int) -> Observable<Void>
    func update(_ product: Product) -> Observable<Void>
}
```

_Note: For simplicity we put the Gateway protocols and implementations in the same files. In fact, Gateway protocols should be at the Domain Layer and implementations at the Data Layer._

### Data Layer

<img width="500" alt="Data Layer" src="images/data.png">

Data Layer contains Gateway Implementations and one or many Data Stores. Gateways are responsible for coordinating data from different Data Stores. Data Store can be Remote or Local (for example persistent database). Data Layer depends only on the Domain Layer.

#### Gateway Implementations

```swift
struct ProductGateway: ProductGatewayType {
    func getProductList(page: Int) -> Observable<PagingInfo<Product>> {
        return API.shared.getProductList(API.GetProductListInput())
            .map { PagingInfo(page: 1, items: $0) }
    }
    
    func deleteProduct(id: Int) -> Observable<Void> { ... }
    func update(_ product: Product) -> Observable<Void> { ... }
}
```

#### UserDefaults

```swift
enum AppSettings {
    @Storage(key: "didInit", defaultValue: false)
    static var didInit: Bool
}
```

#### APIs

```swift
extension API {
    func getProductList(_ input: GetProductListInput) -> Observable<[Product]> {
        return request(input)
    }
}

// MARK: - GetRepoList
extension API {
    final class GetProductListInput: APIInput {
        init() {
            super.init(urlString: API.Urls.getProductList,
                       parameters: nil,
                       requestType: .get,
                       requireAccessToken: true)
        }
    }
}
```

Map JSON Data to Domain Entities using ObjectMapper:

```swift
import ObjectMapper 

extension Product: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        price <- map["price"]
    }
}
```

_Note: Again, for simplicity we put entities and mappings in the same files and use entities as data models for APIs. You can create data models for APIs and map to entities._

#### CoreData Repositories

Map CoreData Entities to Domain Entities and vice versa:

```swift
import MagicalRecord

protocol UserRepository: CoreDataRepository {
   
}

extension UserRepository where Self.ModelType == User, Self.EntityType == CDUser {
    func getUsers() -> Observable<[User]> {
        return all()
    }

    func add(_ users: [User]) -> Observable<Void> {
        return addAll(users)
    }
    
    static func map(from item: User, to entity: CDUser) {
        entity.id = item.id
        entity.name = item.name
        entity.gender = Int64(item.gender.rawValue)
        entity.birthday = item.birthday
    }
    
    static func item(from entity: CDUser) -> User? {
        guard let id = entity.id else { return nil }
        return User(
            id: id,
            name: entity.name ?? "",
            gender: Gender(rawValue: Int(entity.gender)) ?? Gender.unknown,
            birthday: entity.birthday ?? Date()
        )
    }
}
```

### Presentation Layer

<img width="500" alt="Presentation Layer" src="images/presentation.png">

In the current example, Presentation is implemented with the MVVM pattern and heavy use of RxSwift, which makes binding very easy.

<img width="500" alt="Presentation Layer" src="images/mvvm_pattern.png">

#### ViewModel

* ViewModel is the main point of MVVM application. The primary responsibility of the ViewModel is to provide data to the view, so that view can put that data on the screen.
* It also allows the user to interact with data and change the data.
* The other key responsibility of a ViewModel is to encapsulate the interaction logic for a view, but it does not mean that all of the logic of the application should go into ViewModel.
* It should be able to handle the appropriate sequencing of calls to make the right thing happen based on user or any changes on the view.
* ViewModel should also manage any navigation logic like deciding when it is time to navigate to a different view.
[Source](https://www.tutorialspoint.com/mvvm/mvvm_responsibilities.htm)

ViewModel performs pure transformation of a user Input to the Output:

```swift
public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
```

```swift
struct ProductsViewModel {
    let navigator: ProductsNavigatorType
    let useCase: ProductsUseCaseType
}

// MARK: - ViewModelType
extension ProductsViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void> 
        let loadMoreTrigger: Driver<Void>
        let selectProductTrigger: Driver<IndexPath>
        let editProductTrigger: Driver<IndexPath>
        let deleteProductTrigger: Driver<IndexPath>
    }

    struct Output {
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let isReloading: Driver<Bool>
        let isLoadingMore: Driver<Bool>
        let productList: Driver<[ProductViewModel]>
        let selectedProduct: Driver<Void>
        let editedProduct: Driver<Void>
        let isEmpty: Driver<Bool>
        let deletedProduct: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        ...
        let getPageResult = getPage(
            pageSubject: pageSubject,
            pageActivityIndicator: activityIndicator,
            errorTracker: errorTracker,
            loadTrigger: input.loadTrigger,
            reloadTrigger: input.reloadTrigger,
            loadMoreTrigger: input.loadMoreTrigger,
            getItems: { _, page in
                self.useCase.getProductList(page: page)
            },
            mapper: ProductModel.init(product:)
        )
        
        let page = Driver.merge(
            getPageResult.page,
            updatedProductSubject
                .asDriverOnErrorJustComplete()
                .withLatestFrom(pageSubject.asDriver())
        )

        let productList = page
            .map { $0.items }
        
        let productViewModelList = productList
            .map { $0.map(ProductViewModel.init) }
	    
	let selectedProduct = select(trigger: input.selectProductTrigger, items: productList)
            .do(onNext: { product in
                self.navigator.toProductDetail(product: product.product)
            })
            .mapToVoid()
        ...
    }
}
```

A ViewModel can be injected into a ViewController via property injection or initializer. In the current example, this is done by Assembler.

```swift
protocol ProductsAssembler {
    func resolve(navigationController: UINavigationController) -> ProductsViewController
    ...
}

extension ProductsAssembler {
    func resolve(navigationController: UINavigationController) -> ProductsViewController {
        let vc = ProductsViewController.instantiate()
        let vm: ProductsViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
	   
    ...
}
```

ViewModels provide data and functionality to be used by views:

```swift
struct UserViewModel {
    let user: User
    
    var name: String {
        return user.name
    }
        
    var gender: String {
        return user.gender.name
    }
        
    var birthday: String {
        return user.birthday.dateString()
    }
}
```

#### Scene Use Case
Scene Use Case acts as an intermediary between the Presentation Layer and the Domain Layer. It includes individual use cases for each screen, which makes testing the ViewModel easier.

Scene Use Case uses the Facade pattern.

```swift
protocol ProductsUseCaseType {
    func getProductList(page: Int) -> Observable<PagingInfo<Product>>
    func deleteProduct(id: Int) -> Observable<Void>
}

struct ProductsUseCase: ProductsUseCaseType, GettingProductList, DeletingProduct {
    let productGateway: ProductGatewayType
}
```

## Testing
### What to test?
In this architecture, we can test Use Cases, ViewModels and Entities (if they contain business logic) using RxBlocking or RxTest.

#### Use Case

```swift
import RxTest

final class GettingProductListTests: XCTestCase, GettingProductList {
    ... 

    func test_getProductList() {
        // act
        self.getProductList(page: 1)
            .subscribe(getProductListOutput)
            .disposed(by: disposeBag)

        // assert
        XCTAssert(productGatewayMock.getProductListCalled)
        XCTAssertEqual(getProductListOutput.events.first?.value.element?.items.count, 1)
    }
 
    ...
}
```

#### ViewModel

```swift
import RxBlocking

final class ReposViewModelTests: XCTestCase {
    ...

    func test_loadTriggerInvoked_getRepoList() {
        // act
        loadTrigger.onNext(())
        let repoList = try? output.repoList.toBlocking(timeout: 1).first()
        
        // assert
        XCTAssert(useCase.getRepoListCalled)
        XCTAssertEqual(repoList?.count, 1)
    }

    ...
```

## Project Folder and File Structure

```
- /CleanArchitecture    
    - /Domain
        - /UseCases
            - /Product
                - GettingProductList.swift
                - UpdatingProduct.swift
                - DeletingProduct.swift
                ...
            - /Login
            - /App
            - /User
            - /Repo
        - /Entities
            - Product.swift
            - User.swift
            - Repo.swift
    - /Data
        - /Gateways
            - RepoGateway.swift
            - UserGateway.swift
            - AppGateway.swift
            ...
        - /UserDefaults
            - AppSettings.swift
        - /API
            - API+Product.swift
            - API+Repo.swift
        - /CoreData
            - UserRepository.swift
    - /Scenes
        - /App
        - /Main
        - /Login
        - /UserList
        - /Products
        ...
    - /Config
        - APIUrls.swift
    	- Notifications.swift
    - /Support
        - /Extension
            - UIViewController+.swift
            - UIViewController+Rx.swift
            - UITableView+.swift
            ...
        - Utils.swift
    - /Resources
        - /Assets.xcassets
    - AppDelegate.swift
    - Assembler.swift
    - ...

- /CleanArchitectureTests
    - /Domain
    - /Data
    - /Scenes
```


## Example
<img alt="Example" src="images/example.jpg">

## Skeleton Project

* [Creating a skeleton project](skeleton.md)


## Code Generator
* [GitHub - tuan188/MGiGen: A code generator for iOS app](https://github.com/tuan188/MGiGen)


## Links
* [GitHub - sergdort/CleanArchitectureRxSwift: Example of Clean Architecture of iOS app using RxSwift](https://github.com/sergdort/CleanArchitectureRxSwift)
* [Testing Your RxSwift Code | raywenderlich.com](https://www.raywenderlich.com/7408-testing-your-rxswift-code)
* [Using Clean Architecture in Flutter - codeburst](https://codeburst.io/using-clean-architecture-in-flutter-d0437d0c7f87)
* [MVVM Responsibilities - Tutorialspoint](https://www.tutorialspoint.com/mvvm/mvvm_responsibilities.htm)
* [Dependency Injection in Swift - Making Tuenti - Medium](https://medium.com/makingtuenti/dependency-injection-in-swift-part-1-236fddad144a)
* [RxSwift: Clean Architecture, MVVM và RxSwift (Phần 1) - Viblo](https://viblo.asia/p/rxswift-clean-architecture-mvvm-va-rxswift-phan-1-gAm5yaR85db)
* [RxSwift: Clean Architecture, MVVM và RxSwift (Phần 2) - Viblo](https://viblo.asia/p/rxswift-clean-architecture-mvvm-va-rxswift-phan-2-E375zWR6KGW)
