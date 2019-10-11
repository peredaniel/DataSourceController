# DataSourceController framework

[![Build Status](https://travis-ci.com/peredaniel/DataSourceController.svg?branch=master)](https://travis-ci.com/peredaniel/DataSourceController)
[![Coverage Status](https://coveralls.io/repos/github/peredaniel/DataSourceController/badge.svg?branch=master)](https://coveralls.io/github/peredaniel/DataSourceController?branch=master)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/DataSourceController.svg?style=flat)](http://cocoapods.org/pods/DataSourceController)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![License](https://img.shields.io/github/license/peredaniel/DataSourceController)](https://github.com/peredaniel/DataSourceController/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/DataSourceController.svg?style=flat)](http://cocoapods.org/pods/DataSourceController)
[![Language: Swift 4.2](https://img.shields.io/badge/Swift-4.2-green.svg)](https://swift.org/)
[![Language: Swift 5.0](https://img.shields.io/badge/Swift-5.0-green.svg)](https://swift.org/)

DataSourceController is a framework providing an implementation of `UITableViewDataSource` and `UICollectionViewDataSource` protocols, along with a more declarative API by means of `Section` instances. This enables to remove some boilerplate code from our view controllers, thus ending in a much cleaner code base.

## Requirements

| Version | Requirements                           |
|:--------|:---------------------------------------|
| 1.0.0   | Xcode 10.0+<br>Swift 4.2+<br>iOS 10.0+ |

The framework is written using **Swift 5.0**, but there is no code specific to that Swift version. Therefore, it should work with projects using Swift 4.2.

## Installation

You may install the framework through a dependency manager.

### Using CocoaPods

To use CocoaPods, first make sure you have installed it and updated it to the latest version by following their instructions on [cocoapods.org](https://cocoapods.org). Then, you should complete the following steps

1. Add DataSourceController to your `Podfile`:

```ruby
pod 'DataSourceController', '~>1.0.0'
```

2. Update your pod sources and install the new pod by executing the following command in command line:

```
$ pod install --repo-update
```

### Using Carthage

To use Carthage, first make sure you have installed it and updated it to the latest version by following their instructions on [their repo](https://github.com/Carthage/Carthage).

1. Add DataSourceController to your `Cartfile`:

```ruby
github "peredaniel/DataSourceController" ~> 1.0.0
```

2. Install the new framework by running Carthage:

```
$ carthage update
```

### Using Swift Package Manager

To install using Swift Package Manager, add this to the `dependencies` section in your `Package.swift` file:

```swift
.package(url: "https://github.com/peredaniel/DataSourceController.git", .upToNextMinor(from: "1.0.0")),
```

## Getting started

After installing the framework by any means of the above described, we can import the module by adding the following line in the "header" of any Swift file as follows:
```swift
import DataSourceController
```

First step is to implement our data controllers. A "data controller" is an object conforming to the `CellDataController` protocol:
```swift
protocol CellDataController {
    var reuseIdentifier: String { get }
    static func populate(with model: Any) -> CellDataController
}
```
A data controller is responsible for taking the data from the model object and convert it (if necessary) to data structures that can be displayed on screen by a `UITableViewCell` or `UICollectionViewCell`. Note that a data controller is tied to an identifier, not to a class. In particular, this implies that you can use the same controller on different cell classes that share the same reuse identifier.

A simple example of data controller is the following:
```swift
struct BasicCellDataController: CellDataController {
    let reuseIdentifier = "basicCell"
    let titleText: String

    static func populate(with model: Any) -> CellDataController {
    	guard let model = model as? String else {
    		return BasicCellDataController(titleText: "Incorrect data type")
    	}
        return BasicCellDataController(titleText: model)
    }
}
```
This is the most basic data controller that we can implement: it takes a `String` instance as model object and simply stores it until it's necessary. Of course, if we consider that a basic cell is a cell capable of displaying only the title, then the actual font, alignment, background or any other UI specific decorator of the cell is cell-specific, but the data model behind all of those is the same: a `String`. As a consequence, it makes sense to use the same data controller too, which justifies tying the controller to the identifier and not the class itself. 

Next step is to enable cells to retrieve data from the data controllers. To do so, we must conform our cell classes to the `CellView` protocol:
```swift
public protocol CellView {
    func configure(with dataController: CellDataController)
}
```
To follow the previous example, we could extend `UITableViewCell` to conform to the `CellView` protocol as follows:
```swift
extension UITableViewCell: CellView {
    public func configure(with dataController: CellDataController) {
    	guard let basicController = dataController as? BasicCellDataController else { return }
        textLabel?.text = basicController.titleText
    }
}
```
This sets the text in the `textLabel` property of a `UITableViewCell` if the data controller is a `BasicCellDataController`. Note that if we have more data controllers, this function needs to distinguish all of them.

Now that we have our data controller and our cells ready for action, we may create an instance of a `DataSourceController` using one of the following initializers:
```swift
init(rows: [Any], delegate: DataSourceControllerDelegate?)

init(section: Section, delegate: DataSourceControllerDelegate?)

init(sections: [Section], delegate: DataSourceControllerDelegate?)
```
These initializers cover every possible situation that you may need:
1. The objects to be listed are contained in an array and we require no header or footer.
2. We require a single section with either header, footer or both. We can also omit both, thus returning to the previous case.
3. We require several sections in the order given by the array, with one or more having either header, footer or both. We can also omit all the headers and footers.

*Note:* The `delegate` is optional and, in fact, can be omitted. It can also be assigned after the creation. We will describe it later.

Once we have the instance `dataSourceControllerInstance`, we need to register our data controller to use a specific data model as follows:
```swift
dataSourceControllerInstance.register(dataController: BasicCellDataController.self, for: String.self)
```

Finally, it only remains to assign the `dataSource` property of our `UITableView` or `UICollectionView` as follows:
```swift
myTableView.dataSource = dataSourceControllerInstance

...

myCollectionView.dataSource = dataSourceControllerInstance
```

A complete simple example is the following:

```swift
import DataSourceController
import UIKit

class TableViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    private var rowEntries: [String] = ["First row", "Second row", "Third row", "Fourth row"]

    private lazy var dataSourceController: DataSourceController = {
    	let controller = DataSourceController(sections: rowEntries)
        controller.register(dataController: BasicCellDataController.self, for: String.self)
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSourceController
        tableView.reloadData()
    }
}
```
where `BasicCellDataController` is described above.

That's it! The `DataSourceController` will automatically render the table view when the screen is loaded.

### Section model

In the `DataSourceController` implementation, a `Section` is the main model object under use. Even the initializer taking an array of `Any` does create an instance of `Section` underneath. A `Section` is simply an instance of the following class:

```swift
class Section {
    var rows: [Any]
    var sectionData: SectionDataModelType?
    init(sectionData: SectionDataModelType? = nil, rows: [Any])
}
```
Note that the `sectionData` parameter is optional and may be omitted when initializing a `Section` instance. The `SectionDataModelType` is any object conforming to the following protocol:
```swift
protocol SectionDataModelType {
    var header: String? { get }
    var footer: String? { get }
}
```
That is, the data with the header and the footer *of the particular section*.

For most use cases, the default implementation of this protocol provided by the framework will suffice:
```swift
struct SectionDataModel: SectionDataModelType {
    private(set) var header: String?
    private(set) var footer: String?
    init(header: String? = nil, footer: String? = nil)
}
```

### DataSourceControllerDelegate

The `delegate` parameter passed in the initializer of the `DataSourceController` is any object conforming to the following protocol:
```swift
protocol DataSourceControllerDelegate: AnyObject {
    func backgroundMessageLabel(for view: UIView) -> UILabel?
    func backgroundEmptyView(for view: UIView) -> UIView?
    func dataSourceWasMutated(_: DataSourceController)
    func dataSourceWasMutated(_: DataSourceController, section: Int)
    func dataSourceWasMutated(_: DataSourceController, rows: [IndexPath])
}
```
All functions have a default empty implementation to make them optional protocol requirements.

That is, the delegate mainly notifies of changes in the `DataSourceController` instance triggered by the mutating functions available in the API (see [API Reference](#api-reference) below for details). The delegate will usually be the object with the `UITableView` or `UICollectionView` instance, since most likely a part of the displayed list will need to be reloaded.

In addition, in case the `totalRowCount` property of the `DataSourceController` instance is 0 (meaning that there are no rows), the controller will try to display either the `UIView` or the `UILabel` instances provided by the functions
```swift
func backgroundMessageLabel(for view: UIView) -> UILabel?
func backgroundEmptyView(for view: UIView) -> UIView?
```
as the background. Note that both these functions are optional, and therefore it may be omitted. If both functions are implemented, the framework will prioritize the `backgroundEmptyView(for:)` function. The parameter `view` is either the `UITableView` or `UICollectionView` instance whose `dataSource` is the `DataSourceController`.

### UITableView header and footer

Section headers and footers in `UITableView` instances are automatically managed by the framework using a specific controller conforming to the protocol:
```swift
protocol SectionDataControllerType {
    var headerTitle: String? { get }
    var footerTitle: String? { get }
}
```
For now, the framework does use a built-in implementation of this protocol:
```swift
class SectionDataController: SectionDataControllerType {
    private(set) var headerTitle: String?
    private(set) var footerTitle: String?

    init(header: String?, footer: String?)
    convenience init(_ model: SectionDataModelType)
}
```
Although the `SectionDataController` is an open class, thus enabling subclassing outside the framework, the current implementation of `DataSourceController` does not allow for using any other class for `UITableView` header/footer display. A way of providing this level of customization is being developed at the moment.

### UICollectionView header and footer

Headers and footers for `UICollectionView` instances must be implemented differently on any app. Because of this, the framework does consider headers and footers for `UICollectionView` instances as regular cells. Therefore, a data controller must be implemented and registered for a model object conforming to `SectionDataModelType` protocol. Note that, in this case, a custom section data model may be used.

The [example app](#example-app) contains an example of the implementation of a `UICollectionView` header class and its usage with `DataSourceController`.

### API reference

The complete API reference can be found here [API Reference](Documentation/ApiReference.md).

## Example app

This repository includes an example app for iOS. The example app includes an implementation example for both `UITableView` and `UICollectionView`. In addition, for the sake of comparison, the `MenuViewController` class does not use a `DataSourceController` to display the content of its `UITableView`.

## Contributing

This framework has been developed using [MVVMDataSource](https://bitbucket.org/wearemobilefirst/mvvmdatasource) as a basis. The main differences with its "parent" framework are a simpler approach, the removal of the MVVM design pattern (making it architecture-free), the CoreData sections (although you can use them) and the actions. The aim of this simpler approach is to cover the needs of our own projects and the ability of using it outside of the MVVM design pattern, but we stopped once the needs were covered (adding appropriate documentation). If you have any idea on how to improve it, we'll be happy to hear/read it. Just open a new issue to discuss it further, or open a pull request with your idea.

### Code styling guide and formatter

We follow the [Ray Wenderlich Swift Style Guide](https://github.com/raywenderlich/swift-style-guide), except for the [Spacing](https://github.com/raywenderlich/swift-style-guide#spacing) section: we use **4 spaces** instead of 2 to indent.

To enforce the guidelines in the aforementioned code style guide, we use [SwiftFormat](https://github.com/nicklockwood/SwiftFormat). The set of rules is checked into this repository in the file `.swiftformat`. Before pushing any code, please follow the instructions in [How do I install it?](https://github.com/nicklockwood/SwiftFormat/#how-do-i-install-it) of the aforementioned repository to install `SwiftFormat` and execute the following command in the root directory of the project:
```
swiftformat . --config .swiftformat --swiftversion 5.0 --exclude Package.swift
```

This will re-format every `*.swift` file inside the project folder to follow the guidelines, except the `Package.swift` manifest file.

### Continuous Integration and Deployment

We use [Travis CI](https://travis-ci.com/) as our continuous integration solution to run builds and tests on open pull requests and merges to `master`. Tests are required to pass in order to merge any pull request to `master`. Travis CI is also responsible for deploying the library to Cocoapods' Trunk repository when a new tag is pushed.
