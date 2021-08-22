//
//  DetailViewController.swift
//  Thesis
//
//  Created by Greek Account on 21/4/21.
//

import UIKit
import Firebase
class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    @IBOutlet var imageDetail: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblMaterial: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    var itemList:[ImageModel] = []
    var allItem:[ImageModel] = []
    //Here creates two arrays for storing clothing document and recommendation document
    //Connection to database made
    let db = Firestore.firestore()
    var item:ImageModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db.collection("recommendations").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.allItem.append((ImageModel(name: document.data()["Name"] as? String ?? "", image: document.data()["ImageURL"] as? String ?? "", object: document.data() as [String:AnyObject])))
                    self.setupData()
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        //Calls function
        setupData()
        // Do any additional setup after loading the view.
    }
    func setupData(){
        //Creates Image for collection view
        if self.item!.image != ""{
            imageDetail.sd_setImage(with: Storage.storage().reference(forURL: self.item!.image), maxImageSize: 100000, placeholderImage: nil, options: [.progressiveLoad]) { (image, error, catch, url) in
                
            }
        }
        //Takes data from database and casts to string
        self.title = (self.item!.object["Name"] as? String ?? "")
        self.lblName.text = "Name: "+(self.item!.object["Name"] as? String ?? "")
        self.lblBrand.text = "Brand: "+(self.item!.object["Brand"] as? String ?? "")
        self.lblColor.text = "Color: "+(self.item!.object["Color"] as? String ?? "")
        self.lblMaterial.text = "Material: "+(self.item!.object["Material"] as? String ?? "")
        self.lblType.text = "Type: "+(self.item!.object["Type"] as? String ?? "")
        
        //Basic Algorithm to recommend clothing, with a scoring system
        for i in 0..<self.allItem.count{
            var score = 0
            if (self.item!.object["Brand"] as? String ?? "") == (self.allItem[i].object["Brand"] as? String ?? ""){
                score += 1
            }
            if (self.item!.object["Material"] as? String ?? "") == (self.allItem[i].object["Material"] as? String ?? ""){
                score += 1
            }
            if (self.item!.object["Score"] as? String ?? "") == (self.allItem[i].object["Score"] as? String ?? ""){
                score += 1
            }
            if (self.item!.object["Type"] as? String ?? "") == (self.allItem[i].object["Type"] as? String ?? ""){
                score += 1
            }
            self.allItem[i].score = score
        }
        self.itemList = self.allItem.sorted { $0.score > $1.score }
        self.collection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Mandatory Collection View cell count
        return self.itemList.count >= 3 ? 3 : self.itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Stores label and image
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.lblName.text = self.itemList[indexPath.item].name
        if self.itemList[indexPath.item].image != ""{
            cell.img.sd_setImage(with: Storage.storage().reference(forURL: self.itemList[indexPath.item].image), maxImageSize: 100000, placeholderImage: nil, options: [.progressiveLoad]) { (image, error, catch, url) in
                
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Calls function on this specific iteration
        self.item = self.itemList[indexPath.item]
        self.setupData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Specifications for collection view layout, width and height constraints
        return CGSize(width: (collectionView.frame.size.width-20)/3, height: (collectionView.frame.size.width-20)/3)
    }
    @IBAction func recommendItems(_ sender: Any) {
        
    }
}
