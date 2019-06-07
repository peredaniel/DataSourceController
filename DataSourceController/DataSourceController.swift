//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import Foundation
import UIKit

public class Section {
    public var rows: [Any]
    public var sectionData: SectionDataModelType?

    public init(sectionData: SectionDataModelType? = nil, rows: [Any]) {
        self.sectionData = sectionData
        self.rows = rows
    }
}

struct ModelDataControllerPair {
    let model: Any.Type
    let dataController: CellDataController.Type

    func modelMatches(_ modelInstance: Any) -> Bool {
        return model == type(of: modelInstance)
    }
}

open class ModelDataControllerMap: NSObject {
    private var modelControllerMap: [ModelDataControllerPair] = []

    public func register(dataController: CellDataController.Type, for model: Any.Type) {
        let pair = ModelDataControllerPair(model: model, dataController: dataController)
        modelControllerMap.append(pair)
    }

    public func dataController(for modelObject: Any) -> CellDataController? {
        if let dataController = modelObject as? CellDataController {
            return dataController
        }

        let dataController = modelControllerMap.first { $0.modelMatches(modelObject) }?.dataController
        return dataController?.populate(with: modelObject)
    }
}

public class DataSourceController: ModelDataControllerMap {
    public weak var delegate: DataSourceControllerDelegate?

    private var sections: [Section]

    public init(sections: [Section], delegate: DataSourceControllerDelegate? = nil) {
        self.sections = sections
        self.delegate = delegate
    }

    public convenience init(rows: [Any], delegate: DataSourceControllerDelegate? = nil) {
        self.init(sections: [Section(rows: rows)], delegate: delegate)
    }

    func data(for section: Int) -> SectionDataModelType? {
        guard (0..<sectionCount).contains(section) else { return nil }
        return sections[section].sectionData
    }

    var sectionCount: Int {
        return sections.count
    }

    func rowCount(for section: Int) -> Int {
        guard (0..<sectionCount).contains(section) else { return 0 }
        return sections[section].rows.count
    }

    public var totalRowCount: Int {
        return sections.flatMap { $0.rows }.count
    }

    func model(at indexPath: IndexPath) -> Any? {
        guard (0..<sectionCount).contains(indexPath.section),
            (0..<sections[indexPath.section].rows.count).contains(indexPath.row) else {
                return nil
        }
        return sections[indexPath.section].rows[indexPath.row]
    }
}

extension DataSourceController: DataSourceObjectManager {
    public func add(section: Section, at index: Int? = nil, notify: Bool = true) {
        if let index = index, (0..<sectionCount).contains(index) {
            sections.insert(section, at: index)
        } else {
            sections.append(section)
        }
        if notify { delegate?.dataSourceWasMutated(self) }
    }

    public func add(object: Any, at indexPath: IndexPath, notify: Bool = true) {
        guard (0..<sections.count).contains(indexPath.section) else {
            add(section: Section(rows: [object]), notify: notify)
            return
        }
        var rows = sections[indexPath.section].rows
        if (0..<rowCount(for: indexPath.section)).contains(indexPath.row) {
            rows.insert(object, at: indexPath.row)
        } else {
            rows.append(object)
        }
        sections[indexPath.section].rows = rows
        if notify { delegate?.dataSourceWasMutated(self, section: indexPath.section) }
    }

    public func update(allSections sections: [Section], notify: Bool = true) {
        self.sections = sections
        if notify { delegate?.dataSourceWasMutated(self) }
    }

    public func update(section: Section, at index: Int, notify: Bool = true) {
        guard (0..<sectionCount).contains(index) else { return }
        sections[index] = section
        if notify { delegate?.dataSourceWasMutated(self, section: index) }
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

    public func update(sectionData: SectionDataModel, at index: Int, notify: Bool = true) {
        guard (0..<sectionCount).contains(index) else { return }
        let section = sections[index]
        section.sectionData = sectionData
        update(section: section, at: index, notify: notify)
    }

    public func update(row modelObject: Any, at indexPath: IndexPath, notify: Bool = true) {
        guard (0..<sectionCount).contains(indexPath.section),
            (0..<rowCount(for: indexPath.section)).contains(indexPath.row) else { return }
        sections[indexPath.section].rows[indexPath.row] = modelObject
        if notify { delegate?.dataSourceWasMutated(self, indexPaths: [indexPath]) }
    }

    public func update(rows: [IndexPath: Any], notify: Bool = true) {
        guard (0..<sectionCount).contains(rows.keys.map { $0.section }.max() ?? 0) else { return }
        var mutatedIndexPaths: [IndexPath] = []
        for (indexPath, modelObject) in rows {
            guard (0..<rowCount(for: indexPath.section)).contains(indexPath.row) else { continue }
            sections[indexPath.section].rows[indexPath.row] = modelObject
            mutatedIndexPaths.append(indexPath)
        }
        if notify { delegate?.dataSourceWasMutated(self, indexPaths: mutatedIndexPaths) }
    }

    public func remove(sectionAt section: Int, notify: Bool = true) {
        guard (0..<sectionCount).contains(section) else { return }
        sections.remove(at: section)
        if notify { delegate?.dataSourceWasMutated(self) }
    }

    public func remove(objectAt indexPath: IndexPath, notify: Bool = true) {
        guard (0..<sectionCount).contains(indexPath.section),
            (0..<rowCount(for: indexPath.section)).contains(indexPath.row) else { return }
        sections[indexPath.section].rows.remove(at: indexPath.row)
        if rowCount(for: indexPath.section) == 0 { remove(sectionAt: indexPath.section, notify: false) }
        if notify { delegate?.dataSourceWasMutated(self) }
    }
}
