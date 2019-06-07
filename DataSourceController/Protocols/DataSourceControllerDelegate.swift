//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import Foundation
import UIKit

public protocol DataSourceControllerDelegate: class {
    func backgroundMessageLabel(for view: UIView) -> UILabel?
    func dataSourceWasMutated(_ datasource: DataSourceController)
    func dataSourceWasMutated(_ datasource: DataSourceController, section: Int)
    func dataSourceWasMutated(_ datasource: DataSourceController, indexPaths: [IndexPath])
}

public extension DataSourceControllerDelegate {
    func backgroundMessageLabel(for view: UIView) -> UILabel? { return nil }
    func dataSourceWasMutated(_ datasource: DataSourceController) { }
    func dataSourceWasMutated(_ datasource: DataSourceController, section: Int) { }
    func dataSourceWasMutated(_ datasource: DataSourceController, indexPaths: [IndexPath]) { }
}
