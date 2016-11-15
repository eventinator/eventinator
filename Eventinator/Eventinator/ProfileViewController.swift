//
//  ProfileViewController.swift
//  Eventinator
//
//  Created by Jon O'Keefe on 11/9/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    var categories = [Category]()
    var userCategories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarLogo()
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categories = getCategories()
        userCategories = getUserCategories()
    }
    
    private func setNavigationBarLogo() {
        let logo = UIImage(named: "lineup-logo.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = categoriesCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeaderView", for: indexPath) as! ProfileHeaderView
            // Set the profile info once we have the model
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = categories[indexPath.item]
        cell.category = category
        if userCategories.contains(where: { $0.id == category.id }) {
            cell.isUserCategory = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func markEventAsSavedForUser(category: Category) {
        Category.persistCategory(category: category)
    }
    
    func fetchUserSavedCategories() {
        Category.fetchPersistedCategories(failure: { (error: Error) in
            print(error)
        }, success: { (fetchedCategories: [Category]) in
            for category in fetchedCategories {
                print(category)
            }
        })
    }
    
    private func getCategories() -> [Category] {
        return [Category(id: "music", name: "Live Music"),
                Category(id: "fairs", name: "Fairs & Festivals"),
                Category(id: "sports", name: "Sports & Fitness"),
                Category(id: "eating", name: "Eating & Drinking"),
                Category(id: "shopping", name: "Shopping & Fashion"),
                Category(id: "charity", name: "Charity & Volunteering"),
                Category(id: "movies", name: "Movies"),
                Category(id: "fun", name: "Fun & Games")]
    }
    
    private func getUserCategories() -> [Category] {
        return [Category(id: "music", name: "Live Music"),
                Category(id: "eating", name: "Eating & Drinking"),
                Category(id: "movies", name: "Movies"),
                Category(id: "fun", name: "Fun & Games")]
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
