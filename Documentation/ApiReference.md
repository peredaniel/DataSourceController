# API Reference

The `DataSourceController` provides an API to dinamically insert, update or remove individual rows and sections. Most of this API is declared by the protocols `RowManager` and `SectionManager`. In addition, there are several additional helper functions and properties implemented in the main class.

## Helper functions and properties

```swift
weak var delegate: DataSourceControllerDelegate? { get set }
```

Returns or sets the `DataSourceController` delegate property, as described in the [DataSourceControllerDelegate](README.md#datasourcecontrollerdelegate) section of the README, which is notified of the changes in rows and sections of the controller. It's optional, and can be set either during or after the initialization.

--------------------------------------------------

```swift
var totalRowCount: Int { get }
```

Returns the total number of rows currently present in all the `Section` instances of this `DataSourceController` instance. Note that the number of sections is usually not 0 as per implementation, since every initializer does create at least one `Section` instance and the only way to reduce this number to 0 is to manually call functions to remove them. Therefore this is the property to check for "emptyness".

--------------------------------------------------

```swift
func modelObject(at indexPath: IndexPath) -> Any?
```

Returns the model object instance at the selected `indexPath`. If the `indexPath` is out of bounds on either the `section` or the `row` properties, this function returns `nil` without crashing.

--------------------------------------------------

```swift
func data(for section: Int) -> SectionDataModelType?
```

Returns the `SectionDataModelType` conforming object for the selected `section` index. If no section data has been provided or `section` is out of bounds, this function returns `nil` without crashing.

--------------------------------------------------

```swift
func register(dataController: CellDataController.Type, for model: Any.Type)
```

Registers the `CellDataController` conforming type to be used with the `model` specific type. A few notes on this:
* The same controller can be used safely with different model objects.
* Only a single controller type may be registered to a given model object type. Successive calls to this function with the same model object type will result in any previous registered controller type being overwritten.

## RowManager protocol

```swift
func add(row modelObject: Any, at indexPath: IndexPath, notify: Bool)
```

Inserts a new row at the given `indexPath`. There are several different outcomes depending on the `indexPath` passed as a parameter.
* If `indexPath.section` is out of bounds, a new `Section` with a single row is inserted at the end of the `Section` array.
* If `indexPath.section` is within bounds, but `indexPath.row` is out of bounds, a new row is inserted at the end of the given `Section`.
* If both `indexPath.section` and `indexPath.row` are within bounds, the new row is inserted at the specified position of the given `Section`, moving "down" the rows behind the newly inserted one.

If `notify` is `true`, the following code is executed:
```swift
delegate?.dataSourceWasMutated(self, section: indexPath.section)
```

--------------------------------------------------

```swift
func update(row modelObject: Any, at indexPath: IndexPath, notify: Bool)
```

Updates the model object at the given `indexPath`. There are several different outcomes depending on the `indexPath` passed as a parameter.
* If either `indexPath.section` or `indexPath.row` are out of bounds, the function returns without performing any further action. No notification function in the delegate will be called.
* If both `indexPath.section` and `indexPath.row` are within bounds, the model object at the given `indexPath` is replaced by the new instance `modelObject` passed as a parameter.

If `notify` is `true`, the following code is executed:
```swift
delegate?.dataSourceWasMutated(self, rows: [indexPath])
```

--------------------------------------------------

```swift
func update(rows: [Any], atSection index: Int, notify: Bool)
```

Replaces all the model objects at the `Section` at position `index` by the `rows` passed as a parameter.
* If `atSection` is out of bounds, the function returns without performing any further action. No notification function in the delegate will be called.
* If `atSection` is within bounds, the value in the `rows` property of that `Section` instance is replaced by the new value `rows` passed to the function.

**Note:** Only the model objects in the rows are replaced, whilst section data remains unmodified.

If `notify` is `true`, the following code is executed:
```swift
delegate?.dataSourceWasMutated(self, rows: (0..<rows.count).map { IndexPath(row: $0, section: index) })
```

--------------------------------------------------

```swift
func update(rows: [IndexPath: Any], notify: Bool)
```

Replaces the model objects at the `IndexPath`'s provided by the keys of the dictionary `rows` by the new model objects provided by its values.
* If the maximum `indexPath.section` index in the keys of `rows` is out of bounds, the function returns without performing any further action. No notification in the delegate will be called.
* If `indexPath.row` of a given object is out of bounds in that specific `Section` rows, that model object is not updated but the implementation will continue with the remaining model objects.
* If `indexPath.row` of a given object is within bounds, that model object is replaced by the new instance.

If `notify` is `true`, the following code is executed:
```swift
delegate?.dataSourceWasMutated(self, rows: mutatedIndexPaths)
```
where `mutatedIndexPaths` are the `indexPath`s of the rows that have been updated (that is, the one that are not skipped due to an out of bounds row index)

--------------------------------------------------

```swift
func remove(rowAt indexPath: IndexPath, notify: Bool)
```

Removes the model object at the given `indexPath`. There are several different outcomes depending on the `indexPath` passed as a parameter.
* If either `indexPath.section` or `indexPath.row` are out of bounds, the function returns without performing any further action. No notification function in the delegate will be called.
* If both `indexPath.section` and `indexPath.row` are within bounds, the model object at the given `indexPath` is removed. If the `Section` instance containing the model object that has been removed is reduced to 0 elements, then the entire `Section` is removed.

If `notify` is `true`, the following code is executed:
```swift
delegate?.dataSourceWasMutated(self)
```

## SectionManager protocol

```swift
func add(section: Section, at index: Int?, notify: Bool)
```

Inserts a new `section` at the given `index`. There are several different outcomes depending on the `index` passed as a parameter.
* If `index` is `nil` or out of bounds, the `section` is inserted at the end of the `Section` array.
* If `index` is not nil and within bounds, the `section` is inserted at the position given by `index`
Note that may be omitted when calling the function, in which case its value defaults to `nil`.

If `notify` is `true`, the following code is executed:
```swift
delegate?.dataSourceWasMutated(self)
```

--------------------------------------------------

```swift
func update(sectionData: SectionDataModelType, at index: Int, notify: Bool)
```

Updates the `sectionData` of the `Section` instance at the given `index`. There are several different outcomes depending on the `index` passed as a parameter.
* If `index` is out of bounds, the function returns without performing any further action. No notification function in the delegate will be called.
* If `index` is within bounds, the `sectionData` property of the section object at the given `index` is replaced by the new instance `sectionData` passed as a parameter.

**Note:** Only the section data is updated, whilst the model objects in the rows remain unmodified.

If `notify` is `true`, the following code is executed:
```swift
delegate?.dataSourceWasMutated(self, section: index)
```


--------------------------------------------------

```swift
func update(section: Section, at index: Int, notify: Bool)
```

Updates the `section` at the given `index`. There are several different outcomes depending on the `index` passed as a parameter.
* If `index` is out of bounds, the function returns without performing any further action. No notification function in the delegate will be called.
* If `index` is within bounds, the section object at the given `index` is replaced by the new instance `section` passed as a parameter.

**Note:** This function replaces both the section data and the rows, and may be considered as calling the following two functions:
```swift
let dataSourceController: DataSourceController

...

let newSection = createNewSection()
dataSourceController.update(rows: newSection.rows, atSection: index, notify: false)
dataSourceController.update(sectionData: newSection.sectionData, at: index, notify: true)
```

If `notify` is `true`, the following code is executed:
```swift
delegate?.dataSourceWasMutated(self, section: index)
```

--------------------------------------------------

```swift
func update(allSections sections: [Section], notify: Bool)
```

Replaces all the section objects in the `DataSourceController` instance by the `sections` array passed as a parameter.

If `notify` is `true`, the following code is executed:
```swift
delegate?.dataSourceWasMutated(self)
```

--------------------------------------------------

```swift
func remove(sectionAt index: Int, notify: Bool)
```

Removes the section object at the given `index`. There are several different outcomes depending on the `index` passed as a parameter.
* If `index` is out of bounds, the function returns without performing any further action. No notification function in the delegate will be called.
* If `index` is within bounds, the section object at the given `index` is removed.

If `notify` is `true`, the following code is executed:
```swift
delegate?.dataSourceWasMutated(self)
```

--------------------------------------------------

```swift
func removeAllSections(notify: Bool)
```

Removes all the section objects in the `DataSourceController` instance.

If `notify` is `true`, the following code is executed:
```swift
delegate?.dataSourceWasMutated(self)
```
