//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

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
        if let modelObject = model(at: indexPath), let viewModel = dataController(for: modelObject) {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: viewModel.reuseIdentifier,
                for: indexPath
            )
            if let cell = cell as? CellView {
                cell.configure(with: viewModel)
            }
            return cell
        }
        return UICollectionViewCell()
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if let sectionData = data(for: indexPath.section), let viewModel = dataController(for: sectionData) {
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: viewModel.reuseIdentifier,
                for: indexPath
            )
            if let viewModelView = view as? CellView {
                viewModelView.configure(with: viewModel)
            }
            return view
        }
        return UICollectionReusableView()
    }
}
