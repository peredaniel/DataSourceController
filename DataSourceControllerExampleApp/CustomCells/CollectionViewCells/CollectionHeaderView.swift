//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import DataSourceController
import UIKit

class CollectionHeaderView: UICollectionReusableView {
    @IBOutlet private var titleLabel: UILabel!
}

extension CollectionHeaderView: CellView {
    func configure(with dataController: CellDataController) {
        guard let controller = dataController as? CollectionHeaderDataController else { return }
        titleLabel.text = controller.titleText
    }
}
