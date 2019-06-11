//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import UIKit
import DataSourceController

class MenuViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let tableViewController as TableViewController:
            tableViewController.dataSourceController = DataSourceController(rows: [])
        case let collectionViewController as CollectionViewController:
            collectionViewController.dataSourceController = DataSourceController(rows: [])
        default:
            break
        }
    }
}
