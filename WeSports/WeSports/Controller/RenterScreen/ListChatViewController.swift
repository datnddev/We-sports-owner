//
//  ListChatViewController.swift
//  WeSports
//
//  Created by datNguyem on 13/12/2021.
//

import UIKit

class ListChatViewController: UIViewController {
    let searchBar = UISearchController()
    @IBOutlet private weak var listChatCollectionView: UICollectionView!
    private var listUser = [ListChat]() {
        didSet {
            dispatchGroup.notify(queue: .main) {
                self.listChatCollectionView.reloadData()
            }
        }
    }
    private let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchBar
        setupCollectionView()
        getRenterData()
        getOwnerData()
    }
    
    private func getRenterData() {
        dispatchGroup.enter()
        APIManager.shared.getRequest(
            url: GetUrl.baseUrl(endPoint: .getListRenter)) { result in
            defer {
                self.dispatchGroup.leave()
            }
            switch result {
            case .success(let data):
                do {
                    let renterResponse = try JSONDecoder().decode(ListRenterResponse.self, from: data)
                    if let userListChat = renterResponse.data {
                        var listChat = [ListChat]()
                        for i in 0..<userListChat.count {
                            let chat = ListChat(
                                id: userListChat[i].id!,
                                name: userListChat[i].name)
                            listChat.append(chat)
                        }
                        self.listUser.append(contentsOf: listChat)
                    }
                } catch {
                  print(String(describing: error))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    private func getOwnerData() {
        dispatchGroup.enter()
        APIManager.shared.getRequest(
            url: GetUrl.baseUrl(endPoint: .getListOwner)) { result in
            defer {
                self.dispatchGroup.leave()
            }
            switch result {
            case .success(let data):
                do {
                    let ownerResponse = try JSONDecoder().decode(ListOwnerResponse.self, from: data)
                    if let userListChat = ownerResponse.data {
                        var listChat = [ListChat]()
                        for i in 0..<userListChat.count {
                            let chat = ListChat(
                                id: userListChat[i].id!,
                                name: userListChat[i].name)
                            listChat.append(chat)
                        }
                        self.listUser.append(contentsOf: listChat)
                    }
                } catch {
                  print(String(describing: error))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupCollectionView() {
        listChatCollectionView.delegate = self
        listChatCollectionView.dataSource = self
        listChatCollectionView.register(
            ListChatCollectionViewCell.nib,
            forCellWithReuseIdentifier: ListChatCollectionViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Nhắn tin"
    }
}

extension ListChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ListChatCollectionViewCell.identifier,
            for: indexPath) as! ListChatCollectionViewCell
        cell.configure(listChat: listUser[indexPath.item])
        return cell
    }
}

extension ListChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                      height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(listUser[indexPath.item])
    }
}
