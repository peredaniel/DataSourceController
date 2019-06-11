//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import UIKit
import DataSourceController

class TableViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!

    var dataSourceController: DataSourceController?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        tableView.reloadData()
    }

    private func configureTableView() {
        tableView.dataSource = dataSourceController
    }
}
