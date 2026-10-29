# Thunder Collection

[![Build Status](https://travis-ci.org/3sidedcube/ThunderCollection.svg)](https://travis-ci.org/3sidedcube/ThunderCollection) [![Swift 5.5](http://img.shields.io/badge/swift-5.5-brightgreen.svg)](https://swift.org/blog/swift-5-5-released/) [![Apache 2](https://img.shields.io/badge/license-Apache%202-brightgreen.svg)](LICENSE.md)

Thunder Collection is a useful framework which enables quick and easy creation of collection views in iOS using a declarative approach. It makes the process of creating complex collection views as simple as a few lines of code; and removes the necessity for having long chains of index paths and if statements.

## How It Works

Thunder Collection comprises of two main types of objects:

### Items

Collection items are objects that conform to the `CollectionItemDisplayable` protocol, this protocol has properties such as: `cellClass`, `selectionHandler` which are responsible for defining how the cell is configured. As this is a protocol any object can conform to it, which allows you to simply send an array of model objects to the collection view to display your content.

### Sections

Collection sections are objects that conform to the `CollectionSectionDisplayable` protocol, most of the time you won't need to implement this protocol yourself as Thunder Collection has a convenience class `CollectionSection` which can be used in most circumstances. However you can implement more complex layouts using this protocol on your own classes.

# Installation

Add the package with Swift Package Manager, either in Xcode (File › Add Package Dependencies…) or in a `Package.swift`:

```swift
.package(url: "https://github.com/3sidedcube/ThunderCollection.git", from: "27.1.0")
```

`ThunderCollection` is a dynamic library product. Add it to your app target with **Embed & Sign**; other targets that use it (frameworks, app extensions, test bundles) link it without embedding, so the app loads a single copy.

# Code Example
## A Simple Collection View Controller

Setting up a collection view is massively simplified using thunder collection, in fact, we can get a simple collection view running with just a few lines of code. To create a custom collection view we subclass from `CollectionViewController`. We then set up our collection view in the `viewDidLoad:` method. In contrast to [ThunderCollection](https://github.com/3sidedcube/iOS-ThunderCollection) no default implementations of `CollectionItemDisplayable` are provided, as there is no standard implementation of `UICollectionViewCell` like there is with `UITableViewCell`.

```swift
import ThunderCollection

class MyCollectionViewController: CollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ImageRow not provided by framework!
        let imageRow = ImageRow(image: someImage)
        
        let section = CollectionSection(rows: [imageRow])
        data = [section]
    }
}
```

# License
See [LICENSE.md](LICENSE.md)

