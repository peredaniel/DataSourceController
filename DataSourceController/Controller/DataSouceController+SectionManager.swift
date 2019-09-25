//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

public protocol SectionManager: AnyObject {
    func add(section: Section, at index: Int?, notify: Bool)
    func update(section: Section, at index: Int, notify: Bool)
    func update(sectionData: SectionDataModelType, at index: Int, notify: Bool)
    func update(allSections sections: [Section], notify: Bool)
    func remove(sectionAt index: Int, notify: Bool)
    func removeAllSections(notify: Bool)
}

extension DataSourceController: SectionManager {
    public func add(
        section: Section,
        at index: Int? = nil,
        notify: Bool = true
    ) {
        if let index = index, (0..<sectionCount).contains(index) {
            sections.insert(section, at: index)
        } else {
            sections.append(section)
        }
        if notify { delegate?.dataSourceWasMutated(self) }
    }

    public func update(
        section: Section,
        at index: Int,
        notify: Bool = true
    ) {
        guard (0..<sectionCount).contains(index) else { return }
        sections[index] = section
        if notify { delegate?.dataSourceWasMutated(self, section: index) }
    }

    public func update(
        sectionData: SectionDataModelType,
        at index: Int,
        notify: Bool = true
    ) {
        guard (0..<sectionCount).contains(index) else { return }
        let section = sections[index]
        section.sectionData = sectionData
        update(section: section, at: index, notify: notify)
    }

    public func update(
        allSections sections: [Section],
        notify: Bool = true
    ) {
        self.sections = sections
        if notify { delegate?.dataSourceWasMutated(self) }
    }

    public func remove(
        sectionAt section: Int,
        notify: Bool = true
    ) {
        guard (0..<sectionCount).contains(section) else { return }
        sections.remove(at: section)
        if notify { delegate?.dataSourceWasMutated(self) }
    }

    public func removeAllSections(notify: Bool) {
        sections.removeAll()
        if notify { delegate?.dataSourceWasMutated(self) }
    }
}
