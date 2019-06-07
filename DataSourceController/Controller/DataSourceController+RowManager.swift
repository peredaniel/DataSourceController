//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import Foundation

public protocol RowManager: class {
    func add(row modelObject: Any, at indexPath: IndexPath, notify: Bool)
    func update(row modelObject: Any, at indexPath: IndexPath, notify: Bool)
    func update(rows: [IndexPath: Any], notify: Bool)
    func remove(rowAt indexPath: IndexPath, notify: Bool)
}

extension DataSourceController: RowManager {
    public func add(row modelObject: Any, at indexPath: IndexPath, notify: Bool = true) {
        guard (0..<sections.count).contains(indexPath.section) else {
            add(section: Section(rows: [modelObject]), notify: notify)
            return
        }
        var rows = sections[indexPath.section].rows
        if (0..<rowCount(for: indexPath.section)).contains(indexPath.row) {
            rows.insert(modelObject, at: indexPath.row)
        } else {
            rows.append(modelObject)
        }
        sections[indexPath.section].rows = rows
        if notify { delegate?.dataSourceWasMutated(self, section: indexPath.section) }
    }

    public func update(rows: [Any], atSection index: Int, notify: Bool = true) {
        guard (0..<sectionCount).contains(index) else { return }
        let section = sections[index]
        section.rows = rows
        sections[index] = section
        if notify {
            let indexPaths = (0..<rows.count).map { IndexPath(row: $0, section: index) }
            delegate?.dataSourceWasMutated(self, indexPaths: indexPaths)
        }
    }

    public func update(row modelObject: Any, at indexPath: IndexPath, notify: Bool = true) {
        guard (0..<sectionCount).contains(indexPath.section),
            (0..<rowCount(for: indexPath.section)).contains(indexPath.row) else { return }
        sections[indexPath.section].rows[indexPath.row] = modelObject
        if notify { delegate?.dataSourceWasMutated(self, indexPaths: [indexPath]) }
    }

    public func remove(rowAt indexPath: IndexPath, notify: Bool = true) {
        guard (0..<sectionCount).contains(indexPath.section),
            (0..<rowCount(for: indexPath.section)).contains(indexPath.row) else { return }
        sections[indexPath.section].rows.remove(at: indexPath.row)
        if rowCount(for: indexPath.section) == 0 { remove(sectionAt: indexPath.section, notify: false) }
        if notify { delegate?.dataSourceWasMutated(self) }
    }
}
