//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import DataSourceController
import UIKit

class MockTableViewController: UIViewController {
    var dataSourceController: DataSourceController? {
        didSet { dataSourceController?.delegate = self }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(origin: .zero, size: view.bounds.size), style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MockCellDataController")
        tableView.dataSource = dataSourceController
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.reloadData()
    }
}

extension MockTableViewController: DataSourceControllerDelegate {
    func backgroundMessageLabel(for view: UIView) -> UILabel? {
        let label = UILabel(frame: CGRect(origin: .zero, size: view.bounds.size))
        label.text = "Empty collection!"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 27.0)
        return label
    }
}

extension UITableViewCell: CellView {
    public func configure(with dataController: CellDataController) {
        guard let mockController = dataController as? MockCellDataController,
            mockController.populateFunctionHasBeenCalled else { return }
        textLabel?.text = mockController.title
    }
}
