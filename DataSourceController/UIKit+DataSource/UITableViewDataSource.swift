//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import UIKit

extension DataSourceController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        if totalRowCount == 0 {
            let backgroundView = delegate?.backgroundEmptyView(for: tableView) ?? delegate?.backgroundMessageLabel(for: tableView)
            if backgroundView != nil {
                tableView.backgroundView = backgroundView
                tableView.backgroundView?.isHidden = false
                tableView.separatorStyle = .none
            }
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        return sectionCount
    }

    public func tableView(
        _: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return rowCount(for: section)
    }

    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if let modelObject = modelObject(at: indexPath), let dataController = dataController(for: modelObject) {
            let cell = tableView.dequeueReusableCell(withIdentifier: dataController.reuseIdentifier, for: indexPath)
            if let cell = cell as? CellView {
                cell.configure(with: dataController)
            }
            return cell
        }
        let defaultCell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        defaultCell.textLabel?.numberOfLines = 0
        defaultCell.textLabel?.text = "Error: missing model or data controller at \(indexPath)"
        defaultCell.contentView.backgroundColor = .red
        return defaultCell
    }

    public func tableView(
        _: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        guard let sectionData = data(for: section) else { return nil }
        return SectionDataController(sectionData).headerTitle
    }

    public func tableView(
        _: UITableView,
        titleForFooterInSection section: Int
    ) -> String? {
        guard let sectionData = data(for: section) else { return nil }
        return SectionDataController(sectionData).footerTitle
    }
}
