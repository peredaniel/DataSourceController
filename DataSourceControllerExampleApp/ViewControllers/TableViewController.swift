//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import DataSourceController
import UIKit

class TableViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    var dataSourceController: DataSourceController?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        tableView.reloadData()
    }

    private func configureTableView() {
        FullProductDetailsCell.register(in: tableView)
        tableView.dataSource = dataSourceController
    }
}
