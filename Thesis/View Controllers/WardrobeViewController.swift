//
//  WardrobeViewController.swift
//  Thesis
//
//  Created by Greek Account on 7/3/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SDWebImage
import FirebaseUI

var itemAddedHandler:((ImageModel)->Void)?
class WardrobeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
    @IBOutlet weak var collection: UICollectionView!
    var itemList:[ImageModel] = []
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Loads the Collection view once the view loads
        self.itemList = []
        itemAddedHandler = { t in
            self.itemList.append(t)
            self.collection.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        //Reloads everytime transitioned to view
        super.viewWillAppear(animated)
        self.collection.reloadData()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Mandatory number of items count
        return self.itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Sets the cell image and label
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.lblName.text = self.itemList[indexPath.item].name
        if self.itemList[indexPath.item].image != ""{
            cell.img.sd_setImage(with: Storage.storage().reference(forURL: self.itemList[indexPath.item].image), maxImageSize: 100000, placeholderImage: nil, options: [.progressiveLoad]) { (image, error, catch, url) in
                
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //If cell is clicked on transitions user to detail view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        vc.item = self.itemList[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
        print(indexPath.item)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Specifications for collection view layout, width and height constraints
        return CGSize(width: (collectionView.frame.size.width-20)/3, height: (collectionView.frame.size.width-20)/3)
    }
}

