//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import Foundation
import DataSourceController

struct DetailCellData {
    let mainText: String
    let detailText: String
}

struct DetailCellDataController: CellDataController {
    let reuseIdentifier = "detailCell"
    let titleText: String
    let detailText: String?

    static func populate(with model: Any) -> CellDataController {
        guard let model = model as? DetailCellData else {
            return DetailCellDataController(titleText: "Incorrect data type", detailText: nil)
        }
        return DetailCellDataController(titleText: model.mainText, detailText: model.detailText)
    }
}
