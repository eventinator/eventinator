//
//  ProfileViewController.swift
//  Eventinator
//
//  Created by Jon O'Keefe on 11/9/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import UIKit
import CoreLocation
import AFNetworking

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    var categories = [Category]()
    var userCategories = [Category]()
    
    var locationManager : CLLocationManager!
    var locationName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarLogo()
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        EventbriteClient.shared.categories() { categories in
            self.categories = categories
        }
        fetchUserSavedCategories()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
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
            
            if let locationName = locationName {
                headerView.locationLabel.text = locationName
            }
            
            if let profilePictureURL = AccountManager.shared.current?.profilePictureURL {
                headerView.profileImageView.setImageWith(profilePictureURL)
            }
            
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
        cell.isUserCategory = userCategories.contains(where: { $0.id == category.id })
        cell.delegate = self
        
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
    
    func fetchUserSavedCategories() {
        Category.fetchPersistedCategories(failure: { (error: Error) in
            print(error)
        }, success: { (fetchedCategories: [Category]) in
            print(fetchedCategories)
            self.userCategories = fetchedCategories
        })
    }
}


extension ProfileViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) in
                if let placemarks = placemarks {
                    if placemarks.count != 0 {
                        let placemark = placemarks.first!
                        self.locationName = placemark.subAdministrativeArea! + " " + placemark.administrativeArea!
                        self.categoriesCollectionView.reloadData()
                    }
                }
            })
        }
    }
}

extension ProfileViewController: CategoryCellDelegate {
    func categoryCell(didSelect categoryCell: CategoryCell, category: Category) {
        
        persistCategory(category, categoryCell.isUserCategory)
    }
    
    func persistCategory(_ category: Category, _ add: Bool) {
        CacheManager.shared.invalidateDiscover = true
        if add {
            Category.persist(category)
            userCategories.append(category)
        } else {
            userCategories = userCategories.filter { $0.id != category.id }
            Category.remove(category)
        }
    }

}
