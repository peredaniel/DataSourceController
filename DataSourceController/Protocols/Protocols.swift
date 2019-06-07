//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import Foundation

public protocol CellDataController {
    var reuseIdentifier: String { get }
    static func populate(with model: Any) -> CellDataController
}

public protocol CellView {
    func configure(with dataController: CellDataController)
}
