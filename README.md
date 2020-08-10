# Carsales Challenge iOS App  

### Architecture  
  

MVVM-C (Coordinator)  
  

- Model represents the data  
- ViewModel provides the data  
- ViewController/View displays the data  
- Coordinator coordinates the navigation  
  

### Development plan  

#### Requirement 1
- An API to pull/decode date from the REST endpoint  

##### Fulfilment
- Created the CarsalesAPI Swift Package that handles the above.  
- Why a package?  
- Because the plan was the create two apps, one with auto-layout and another in SwiftUI. Hence, a shared library was the best approach.  
- Why two apps and not just add a SwiftUI version of the UI in the same app?  
- For SwiftUI 2.0. It has a few extra APIs that helped in developing the required app. e.g. `LazyVStack` to display a grid of items.  


#### Requirement 2
- Display a list of items with an image and some text.  
- Display a single row on an iPhone. 2 or 3 rows on an iPad depending upon the orientation.  

##### Fulfilment
- A `UICollectionView` is the obvious choice to display a grid of items.  
- UI for the collection view and the cells is created using auto-layout with programmatic constraints.  

##### Issues
My first approach for the list screen was to use `UICollectionViewCompositionalLayout`. It worked great in all areas except when trying to change the number of items on an iPad in landscape orientation.  

The main reason is that the item size in `UICollectionViewCompositionalLayout` is static, whereas in a custom `UICollectionViewFlowLayout` item size can be changed when the bounds of the collection view change.  

#### Requirement 3  
- Display the details of an item with multiple images scrolling horizontally at the top and some text items to follow.  

##### Fulfilment
- There are two options to choose from when you want to display a vertical stack of views i.e. `UITableView` or `UIStackView`  
- I decided to use a `UIStackView` embedded in a `UIScrollView` as the complexity of creating cells for each view type in a `UITableView` would've been overkill for this task.  
- For the image carousel, it was again a job for `UICollectionView` as it supports horizontal scrolling. And, it also supports `paging` which was absolutely required to make the carousel work as it should.  

#### Requirements  
- Xcode 11.6  
- A device running iOS 13 or above (Optional)  
##### Dependencies  
[CarsalesAPI](https://github.com/ggndpsinghgit/CarsalesAPI)

#### Installation  
- Clone the repo  
- Open the .xcproject file in Xcode  
- The CarsalesAPI Swift Package should automatically update when the project loads. If it does not, you can manually do it by going to File -> Swift Packages -> Update to Latest Package Versions.
