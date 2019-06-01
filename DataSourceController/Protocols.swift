//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import Foundation
import UIKit

public protocol DataSourceObjectManager: class {
    func add(section: Section, at index: Int?, notify: Bool)
    func add(object: Any, at indexPath: IndexPath, notify: Bool)
    func update(allSections sections: [Section], notify: Bool)
    func update(section: Section, at index: Int, notify: Bool)
    func update(sectionData: SectionDataModel, at index: Int, notify: Bool)
    func update(row modelObject: Any, at indexPath: IndexPath, notify: Bool)
    func update(rows: [IndexPath: Any], notify: Bool)
    func remove(sectionAt index: Int, notify: Bool)
    func remove(objectAt indexPath: IndexPath, notify: Bool)
}

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

public protocol CellDataController {
    var reuseIdentifier: String { get }
    static func populate(with model: Any) -> CellDataController
}

public protocol CellView {
    func configure(with dataController: CellDataController)
}
