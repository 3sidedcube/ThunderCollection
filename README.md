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

Setting up your app to use ThunderCollection is a simple and quick process. You can choose between a manual installation, or use Carthage.

## Carthage

- Add `github "3sidedcube/ThunderCollection" == 2.0.0` to your Cartfile.
- Run `carthage update --platform ios --use-xcframeworks` to fetch the framework.
- Drag `ThunderCollection` into your project's _Frameworks and Libraries_ section from the `Carthage/Build` folder (Embed).
- Add the Build Phases script step as defined [here](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos).

## Manual

- Clone as a submodule, or download this repo
- Import ThunderCollection.xcproject into your project
- Add ThunderCollection.framework to your Embedded Binaries.
- Wherever you want to use ThunderCollection use `import ThunderCollection`.

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

