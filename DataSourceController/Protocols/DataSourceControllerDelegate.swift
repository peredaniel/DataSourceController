//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import UIKit

public protocol DataSourceControllerDelegate: AnyObject {
    @available(*, deprecated, message: "Use 'backgroundEmptyView(for:)' instead")
    func backgroundMessageLabel(for view: UIView) -> UILabel?
    func backgroundEmptyView(for view: UIView) -> UIView?
    func dataSourceWasMutated(_ datasource: DataSourceController)
    func dataSourceWasMutated(_ datasource: DataSourceController, section: Int)
    func dataSourceWasMutated(_ datasource: DataSourceController, rows: [IndexPath])
}

public extension DataSourceControllerDelegate {
    func backgroundMessageLabel(for _: UIView) -> UILabel? { return nil }
    func backgroundEmptyView(for _: UIView) -> UIView? { return nil }
    func dataSourceWasMutated(_: DataSourceController) {}
    func dataSourceWasMutated(_: DataSourceController, section _: Int) {}
    func dataSourceWasMutated(_: DataSourceController, rows _: [IndexPath]) {}
}
