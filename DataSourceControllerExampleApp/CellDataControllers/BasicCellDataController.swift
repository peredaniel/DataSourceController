//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import DataSourceController
import Foundation

struct BasicCellDataController: CellDataController {
    let reuseIdentifier = "basicCell"
    let titleText: String
    let image: UIImage?

    static func populate(with model: Any) -> CellDataController {
        switch model {
        case let text as String:
            return BasicCellDataController(titleText: text, image: nil)
        case let product as Product:
            return BasicCellDataController(titleText: product.name, image: UIImage(named: product.imageName))
        default:
            return BasicCellDataController(titleText: "Incorrect data type", image: nil)
        }
    }
}
