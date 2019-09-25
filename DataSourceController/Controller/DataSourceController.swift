//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import Foundation
import UIKit

public class Section {
    public var rows: [Any]
    public var sectionData: SectionDataModelType?

    public init(
        sectionData: SectionDataModelType? = nil,
        rows: [Any]
    ) {
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

public class ModelDataControllerMap: NSObject {
    private var modelDataControllerMap: [ModelDataControllerPair] = []

    public func register(
        dataController: CellDataController.Type,
        for model: Any.Type
    ) {
        if let index = modelDataControllerMap.firstIndex(where: { $0.model == model }) {
            modelDataControllerMap.remove(at: index)
        }
        modelDataControllerMap.append(ModelDataControllerPair(model: model, dataController: dataController))
    }

    internal func dataController(for modelObject: Any) -> CellDataController? {
        if let dataController = modelObject as? CellDataController {
            return dataController
        }

        let dataController = modelDataControllerMap.first { $0.modelMatches(modelObject) }?.dataController
        return dataController?.populate(with: modelObject)
    }
}

public class DataSourceController: ModelDataControllerMap {
    public weak var delegate: DataSourceControllerDelegate?

    internal var sections: [Section]

    public init(
        sections: [Section],
        delegate: DataSourceControllerDelegate? = nil
    ) {
        self.sections = sections
        self.delegate = delegate
    }

    public convenience init(
        section: Section,
        delegate: DataSourceControllerDelegate? = nil
    ) {
        self.init(sections: [section], delegate: delegate)
    }

    public convenience init(
        rows: [Any],
        delegate: DataSourceControllerDelegate? = nil
    ) {
        self.init(sections: [Section(rows: rows)], delegate: delegate)
    }

    public func data(for section: Int) -> SectionDataModelType? {
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

    public func modelObject(at indexPath: IndexPath) -> Any? {
        guard (0..<sectionCount).contains(indexPath.section),
            (0..<sections[indexPath.section].rows.count).contains(indexPath.row) else {
            return nil
        }
        return sections[indexPath.section].rows[indexPath.row]
    }
}
