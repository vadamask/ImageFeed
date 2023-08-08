//
//  ViewController.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 26.05.2023.
//

import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get }
    func updateTableViewAnimated(at indexPaths: [IndexPath])
    func showSingleImageVC(_ vc: SingleImageViewController)
    func reloadRows(at indexPaths: [IndexPath])
    func showProgressHUD()
    func dismissProgressHUD()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    var presenter: ImagesListPresenterProtocol?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .ypBlack
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        return tableView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = presenter
        tableView.dataSource = presenter
        presenter?.addObserver()
        presenter?.fetchPhotosNextPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }
    
    func updateTableViewAnimated(at indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func showSingleImageVC(_ vc: SingleImageViewController) {
        present(vc, animated: true)
    }
    
    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .none)
    }
    
    func showProgressHUD() {
        UIBlockingProgressHUD.show()
    }
    
    func dismissProgressHUD() {
        UIBlockingProgressHUD.dismiss()
    }

    private func setupViews() {
        view.backgroundColor = .ypBlack
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
