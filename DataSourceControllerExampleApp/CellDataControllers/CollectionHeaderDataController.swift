//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import DataSourceController

struct CollectionHeaderDataController: CellDataController {
    let reuseIdentifier = "collectionHeaderView"
    let titleText: String

    static func populate(with model: Any) -> CellDataController {
        guard let sectionData = model as? SectionDataModel, let headerTitle = sectionData.header else {
            return CollectionHeaderDataController(titleText: "Incorrect data type")
        }
        return CollectionHeaderDataController(titleText: headerTitle)
    }
}
