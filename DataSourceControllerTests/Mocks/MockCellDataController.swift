//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import DataSourceController

struct MockCellDataController: CellDataController {
    let reuseIdentifier = "MockCellDataController"
    let populateFunctionHasBeenCalled: Bool
    let title: String

    init(_ populateFunctionHasBeenCalled: Bool, title: String = .init()) {
        self.populateFunctionHasBeenCalled = populateFunctionHasBeenCalled
        self.title = title
    }

    static func populate(with model: Any) -> CellDataController {
        if let product = model as? Product {
            return MockCellDataController(true, title: product.name)
        } else if let sectionData = model as? SectionDataModel {
            return MockCellDataController(true, title: sectionData.header ?? "")
        }
        return MockCellDataController(false)
    }
}

struct SecondaryMockCellDataController: CellDataController {
    let reuseIdentifier = "SecondaryCellDataController"
    let populateFunctionHasBeenCalled: Bool

    init(_ populateFunctionHasBeenCalled: Bool) {
        self.populateFunctionHasBeenCalled = populateFunctionHasBeenCalled
    }

    static func populate(with model: Any) -> CellDataController {
        guard model is Product else {
            return SecondaryMockCellDataController(false)
        }
        return SecondaryMockCellDataController(true)
    }
}
