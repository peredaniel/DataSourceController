//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import Foundation
import DataSourceController

extension UITableViewCell: CellView {
    public func configure(with dataController: CellDataController) {
        switch dataController {
        case let basicController as BasicCellDataController:
            textLabel?.text = basicController.titleText
            imageView?.image = basicController.image
        case let detailController as DetailCellDataController:
            textLabel?.text = detailController.titleText
            detailTextLabel?.text = detailController.detailText
        default:
            break
        }
    }
}
