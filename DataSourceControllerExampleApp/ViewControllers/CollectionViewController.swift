//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import UIKit
import DataSourceController

class CollectionViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView!

    var dataSourceController: DataSourceController?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        collectionView.reloadData()
    }

    private func configureCollectionView() {
        collectionView.dataSource = dataSourceController
    }
}
