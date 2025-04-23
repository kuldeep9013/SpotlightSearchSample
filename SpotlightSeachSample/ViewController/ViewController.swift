//
//  ViewController.swift
//  SpotlightSeachSample
//
//  Created by Kuldeep Solanki on 23/04/25.
//

import UIKit


class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    // MARK: Type Alias
    typealias DataSource = UICollectionViewDiffableDataSource<Section, String>
    typealias DataSourceSnapShot = NSDiffableDataSourceSnapshot<Section, String>
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Variables
    var dataSource: DataSource?
    let dictOfNames: [String: String] = [
        "1B32E65B": "Liam", "3F5E1C4A": "Emma", "A2E53F8E": "Noah",
        "78C2BA85": "Olivia", "8455DFF0": "Aiden", "A13390D3": "Ava",
        "9B442DA4": "Lucas", "2C93E1A2": "Isabella", "3C3F93F4": "Ethan", "2F57A872": "Mia",
        "83D749BD": "James", "1325A08D": "Sophia", "8A7AEDE8": "Benjamin",
        "5B81CB7B": "Charlotte", "2E050105": "Elijah",
        "F8D8F407": "Amelia", "6BA0F5C2": "Logan", "EBC899F1": "Harper",
        "60166F65": "Mason", "2E297112": "Evelyn", "DEFC2CF0": "Aria",
        "5F5B5057": "Mateo", "0A3BE96A": "Luna", "1AD10F3F": "Leo",
        "ED1687DC": "Chloe", "B47A8981": "Zara", "A6C2A932": "Kai",
        "C6CA38AD": "Layla", "FA03B570": "Ezra", "2C01310C": "Nora"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        collectionView
            .register(
                UINib(nibName: "DetailsCell", bundle: .main),
                forCellWithReuseIdentifier: "DetailsCell"
            )
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        makeDataSource()
        applySnapShot()
    }
    
    // MARK: Collection View Methods
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/2),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 16,
            bottom: 24,
            trailing: 16
        )
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func makeDataSource() {
        dataSource = .init(
            collectionView: collectionView,
            cellProvider: { [weak self] (collectionView, indexPath, id ) -> UICollectionViewCell? in
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCell", for: indexPath ) as? DetailsCell {
                    cell.labelTitle.text = self?.dictOfNames[id] ?? ""
                    return cell
                }
                
                return UICollectionViewCell()
                
            })
    }
    
    private func applySnapShot() {
        var snapshot = DataSourceSnapShot()
        snapshot.appendSections([.main])
        snapshot
            .appendItems(dictOfNames.keys.compactMap({$0}), toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: true, completion: { [weak self] in
            guard let self = self else {return}
            let allPersonNames = dictOfNames.map({ id, person in
                SpotlightItem(itemID: id, title: person,
                              feature: .home)
            })
            SpotlightManager().index(items: allPersonNames)
        })
    }
    

   }

extension ViewController: UICollectionViewDelegate {
// MARK: - Context Menu Support

    func collectionView(_ collectionView: UICollectionView,
                                    contextMenuConfigurationForItemAt indexPath: IndexPath,
                                    point: CGPoint) -> UIContextMenuConfiguration? {

           return UIContextMenuConfiguration(
identifier: indexPath as NSCopying,
 previewProvider: {
     return nil
           },
 actionProvider: { _ in
               return self.makeContextMenu(for: indexPath)
           })
       }

       private func makeContextMenu(for indexPath: IndexPath) -> UIMenu {
           let share = UIAction(title: "Delete from Spotlight", image: UIImage(systemName: "trash")) { [weak self] _ in
               if let itemID = self?.dataSource?.itemIdentifier(for: indexPath) {
                   SpotlightManager()
                       .deleteItem(feature: .home, subfeature: .people, itemID: itemID)
               }
           }

           let favorite = UIAction(title: "Delete All items from Spotlight", image: UIImage(systemName: "trash")) { _ in
               SpotlightManager().deleteAllSearchableItems()
           }

           return UIMenu(title: "", children: [share, favorite])
       }
}


