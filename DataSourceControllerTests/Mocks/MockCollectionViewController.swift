//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import DataSourceController
import UIKit

class MockCollectionViewController: UIViewController {
    private enum Constant {
        static let itemsPerRow: CGFloat = 3.0
        static let interItemSpacing: CGFloat = 12.0
    }

    var dataSourceController: DataSourceController? {
        didSet { dataSourceController?.delegate = self }
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeFlowLayout())
        collectionView.contentSize = view.bounds.size
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MockCellDataController")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MockCellDataController")
        collectionView.dataSource = dataSourceController
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.reloadData()
    }

    private func makeFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 12.0
        let itemWidth = (view.bounds.width - Constant.interItemSpacing * (Constant.itemsPerRow - 1)) / Constant.itemsPerRow
        flowLayout.itemSize = CGSize(width: itemWidth, height: 50)
        return flowLayout
    }
}

extension MockCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        guard let _ = dataSourceController?.data(for: section) else {
            return .zero
        }
        return CGSize(width: view.bounds.width, height: 44.0)
    }
}

extension MockCollectionViewController: DataSourceControllerDelegate {
    func backgroundEmptyView(for view: UIView) -> UIView? {
        let label = UILabel(frame: CGRect(origin: .zero, size: view.bounds.size))
        label.text = "Empty collection!"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 27.0)
        return label
    }
}

extension UICollectionReusableView: CellView {
    public func configure(with dataController: CellDataController) {
        guard let mockController = dataController as? MockCellDataController,
              mockController.populateFunctionHasBeenCalled else { return }
        if let cell = self as? UICollectionViewCell {
            for view in cell.contentView.subviews {
                view.removeFromSuperview()
            }
        } else {
            for view in subviews {
                view.removeFromSuperview()
            }
        }

        let titleLabel = UILabel(frame: bounds)
        titleLabel.font = .systemFont(ofSize: 17.0)
        titleLabel.text = mockController.title

        if let cell = self as? UICollectionViewCell {
            titleLabel.textAlignment = .center
            cell.contentView.addSubview(titleLabel)
        } else {
            backgroundColor = .lightGray
            addSubview(titleLabel)
        }
    }
}
