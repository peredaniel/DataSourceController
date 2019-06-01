//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import Foundation
import UIKit

extension DataSourceController: UITableViewDataSource {
    public func updateVisibleCells(_ tableView: UITableView) {
        for cell in tableView.visibleCells {
            guard let indexPath = tableView.indexPath(for: cell), let cell = cell as? CellView else { continue }
            update(view: cell, indexPath: indexPath)
        }
    }

    public func update(view: CellView, indexPath: IndexPath) {
        if let modelObject: Any = model(at: indexPath), let dataController = dataController(for: modelObject) {
            view.configure(with: dataController)
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = rowCount(for: section)
        return numberOfRows
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let modelObject = model(at: indexPath), let dataController = dataController(for: modelObject) {
            let cell = tableView.dequeueReusableCell(withIdentifier: dataController.reuseIdentifier, for: indexPath)
            if let cell = cell as? CellView {
	            cell.configure(with: dataController)
            }
            return cell
        }
        let defaultCell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        defaultCell.textLabel?.text = "Unable to render"
        defaultCell.backgroundView?.backgroundColor = .red
        return defaultCell
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        if sectionCount == 0 {
            if tableView.backgroundView == nil || !(tableView.backgroundView is UILabel) {
                tableView.backgroundView = delegate?.backgroundMessageLabel(for: tableView)
            }
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        return sectionCount
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionData = data(for: section) else { return nil }
        return SectionDataController(sectionData).headerTitle
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let sectionData = data(for: section) else { return nil }
        return SectionDataController(sectionData).footerTitle
    }
}
