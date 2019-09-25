//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import DataSourceController
import Foundation

extension UITableViewCell: CellView {
    public func configure(with dataController: CellDataController) {
        switch dataController {
        case let product as Product:
            textLabel?.text = product.name
            imageView?.image = UIImage(named: product.imageName)
        case let basicController as BasicCellDataController:
            textLabel?.text = basicController.titleText
            imageView?.image = basicController.image
        case let detailController as DetailCellDataController:
            textLabel?.text = detailController.titleText
            detailTextLabel?.text = detailController.detailText
            imageView?.image = detailController.image
        case let fullDetailsController as FullProductDetailsCellDataController:
            (self as? FullProductDetailsCell)?.configure(controller: fullDetailsController)
        default:
            break
        }
    }
}
