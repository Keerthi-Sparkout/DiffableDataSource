//
//  ViewController.swift
//  DiffableDataSource
//
//  Created by Keerthi on 19/07/21.
//

import UIKit

enum Section {
    case main
}

struct Book {
    let uuid = UUID()
    let title: String
}

extension Book: Hashable {
    static func ==(lhs: Book, rhs: Book) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

class ViewController: UIViewController {

    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var dataSource: UITableViewDiffableDataSource<Section, Book>!
    
    var books = [Book]()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = view.frame
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = model.title
            return cell
        })
        
        title = "My Books"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapAdd))
    }
    
    @objc func didTapAdd() {
        let actionSheet = UIAlertController(title: "Select Book", message: nil, preferredStyle: .actionSheet)
        for i in 1...100 {
            actionSheet.addAction(UIAlertAction(title: "Book\(i)", style: .default, handler: { [weak self] _ in
                let book = Book(title: "Book\(i)")
                self?.books.append(book)
                self?.updateDataSource()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func updateDataSource() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Book>()
        snapShot.appendSections([.main])
        snapShot.appendItems(books)
        dataSource.apply(snapShot, animatingDifferences: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let book = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        print(book.title)
    }
}
