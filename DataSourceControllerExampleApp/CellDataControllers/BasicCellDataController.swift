//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import Foundation
import DataSourceController

struct BasicCellData {
    let text: String
    let imageName: String?
}

struct BasicCellDataController: CellDataController {
    let reuseIdentifier = "basicCell"
    let titleText: String
    let image: UIImage?

    static func populate(with model: Any) -> CellDataController {
        guard let model = model as? BasicCellData else {
            return BasicCellDataController(titleText: "Incorrect data type", image: nil)
        }
        return BasicCellDataController(titleText: model.text, image: UIImage(named: model.imageName ?? ""))
    }
}
