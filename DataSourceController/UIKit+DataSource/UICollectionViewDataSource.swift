//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import UIKit

extension DataSourceController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if totalRowCount == 0 {
            if collectionView.backgroundView == nil || !(collectionView.backgroundView is UILabel) {
                collectionView.backgroundView = delegate?.backgroundMessageLabel(for: collectionView)
            }
            collectionView.backgroundView?.isHidden = false
        } else {
            collectionView.backgroundView?.isHidden = true
        }
        return sectionCount
    }

    public func collectionView(
        _: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return rowCount(for: section)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if let modelObject = modelObject(at: indexPath), let dataController = dataController(for: modelObject) {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: dataController.reuseIdentifier,
                for: indexPath
            )
            if let cell = cell as? CellView {
                cell.configure(with: dataController)
            }
            return cell
        }
        return errorCell(for: collectionView, at: indexPath)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if let sectionData = data(for: indexPath.section), let dataController = dataController(for: sectionData) {
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: dataController.reuseIdentifier,
                for: indexPath
            )
            if let viewModelView = view as? CellView {
                viewModelView.configure(with: dataController)
            }
            return view
        }
        return errorView(for: collectionView, forSupplementaryElementOfKind: kind, at: indexPath)
    }
}

private extension DataSourceController {
    private enum ReuseIdentifier {
        static let errorCell = "DataSourceController.UICollectionViewDataSource.ErrorCell"
        static let errorSupplementaryView = "DataSourceController.UICollectionViewDataSource.ErrorSupplementary"
    }

    func errorCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: ReuseIdentifier.errorCell
        )
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReuseIdentifier.errorCell,
            for: indexPath
        )
        let titleLabel = cell.contentView.subviews.compactMap { $0 as? UILabel }.first ?? UILabel(frame: cell.contentView.bounds)
        titleLabel.font = .systemFont(ofSize: 12.0)
        titleLabel.numberOfLines = 0
        titleLabel.text = "Error: missing model or data controller at \(indexPath)"
        titleLabel.backgroundColor = .clear
        titleLabel.removeFromSuperview()
        cell.contentView.addSubview(titleLabel)
        cell.contentView.backgroundColor = .red
        return cell
    }

    func errorView(
        for collectionView: UICollectionView,
        forSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: ReuseIdentifier.errorSupplementaryView
        )
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ReuseIdentifier.errorSupplementaryView,
            for: indexPath
        )
        let titleLabel = view.subviews.compactMap { $0 as? UILabel }.first ?? UILabel(frame: view.bounds)
        titleLabel.font = .systemFont(ofSize: 14.0)
        titleLabel.numberOfLines = 0
        titleLabel.text = "Error: missing model or data controller for section data at \(indexPath)"
        titleLabel.backgroundColor = .clear
        titleLabel.removeFromSuperview()
        view.addSubview(titleLabel)
        view.backgroundColor = .red
        return view
    }
}
