//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import UIKit

class MenuViewController: UIViewController {
    private enum Constant {
        static let cellIdentifier = "menuCell"
    }

    private enum Segue {
        static let tableViewController = "showTableViewSegue"
        static let collectionViewController = "showCollectionViewSegue"
    }

    @IBOutlet private var tableView: UITableView!

    private let dataSourceProvider = DataSourceProvider()
    private let menuEntries: [[ListType]] = [[.basic, .details, .fullDetails], [.basic]]

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let type = sender as? ListType else { return }
        switch segue.destination {
        case let tableViewController as TableViewController:
            tableViewController.dataSourceController = dataSourceProvider.dataSourceController(for: type)
        case let collectionViewController as CollectionViewController:
            collectionViewController.dataSourceController = dataSourceProvider.dataSourceController(for: type)
        default:
            break
        }
    }
}

// To emphasize the impact of using the DataSourceController framework on the amount of boilerplate code in a project,
// we implement the usual data source for UITableView in this class.

extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return menuEntries.count
    }

    func tableView(
        _: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        switch section {
        case 0: return "Table view controller examples"
        case 1: return "Collection view controller examples"
        default: return nil
        }
    }

    func tableView(
        _: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return menuEntries[section].count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath)
        cell.textLabel?.text = menuEntries[indexPath.section][indexPath.row].title
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            performSegue(
                withIdentifier: Segue.tableViewController,
                sender: menuEntries[indexPath.section][indexPath.row]
            )
        case 1:
            performSegue(
                withIdentifier: Segue.collectionViewController,
                sender: menuEntries[indexPath.section][indexPath.row]
            )
        default:
            return
        }
    }
}
