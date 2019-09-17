//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import DataSourceController
import UIKit

class BasicCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
}

extension BasicCollectionViewCell: CellView {
    func configure(with dataController: CellDataController) {
        guard let controller = dataController as? BasicCellDataController else { return }
        titleLabel.text = controller.titleText
        imageView.image = controller.image
    }
}
