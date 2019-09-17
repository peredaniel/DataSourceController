//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import DataSourceController
import Foundation

struct DetailCellDataController: CellDataController {
    let reuseIdentifier = "detailCell"
    let titleText: String
    let detailText: String?
    let image: UIImage?

    static func populate(with model: Any) -> CellDataController {
        guard let model = model as? Product else {
            return DetailCellDataController(titleText: "Incorrect data type", detailText: nil, image: nil)
        }
        return DetailCellDataController(titleText: model.name, detailText: model.price, image: UIImage(named: model.imageName))
    }
}
