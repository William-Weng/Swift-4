//
//  ViewController.swift
//  TableViewPuttingCollectionView
//
//  Created by William-Weng on 2018/10/19.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// [Putting a UICollectionView in a UITableViewCell in Swift](https://ashfurrow.com/blog/putting-a-uicollectionview-in-a-uitableviewcell-in-swift/)
/// [Collection-View-in-a-Table-View-Cell](https://github.com/ashfurrow/Collection-View-in-a-Table-View-Cell)
/// [UITableView設置全屏分隔線的幾種方法比較](https://www.jianshu.com/p/4e9619483035)

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let model: [[UIColor]] = generateRandomData()
    let reuseIdentifier = (tableViewCell: "TableViewCell", collectionViewCell: "CollectionViewCell")
    
    /* 記錄各Cell的Offset */
    var storedOffsets = [Int: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier.tableViewCell) else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TableViewCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier.collectionViewCell, for: indexPath)
        cell.backgroundColor = model[collectionView.tag][indexPath.item]
        
        return cell
    }
}




