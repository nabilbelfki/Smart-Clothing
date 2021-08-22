//
//  ReadTagController.swift
//  Thesis
//
//  Created by Greek Account on 2/3/21.
//

import UIKit
import CoreNFC
import FirebaseFirestore

class ReadTagController: UIViewController, NFCNDEFReaderSessionDelegate {
    @IBOutlet weak var nfcText: UITextView!
    @IBOutlet weak var beginScan: UIButton!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    var nfcSession: NFCNDEFReaderSession?
    
    @IBAction func tappedOn(_ sender: Any) {
        nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.begin()
        
//        self.db.collection("clothing").whereField("RFID", isEqualTo: "04").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    itemAddedHandler?(ImageModel(name: document.data()["Name"] as? String ?? "", image: document.data()["ImageURL"] as? String ?? "",object: document.data() as [String : AnyObject]))
//                    print("\(document.documentID) => \(document.data())")
//                }
//
//            }
//        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Error if cannot read NFC
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated \(error.localizedDescription)")
    }
    
    //NFC session created, stores NFC message
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var result = ""
        for payload in messages[0].records{
            result += String.init(data: payload.payload.advanced(by: 3),encoding: .utf8) ?? "Format not supported"
        }
        DispatchQueue.main.async {
            self.nfcText.text = result
            //Here compares to firebase RFID value
            self.db.collection("clothing").whereField("RFID", isEqualTo: result).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    //Error Handling
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //Adds item to WardrobeView Controller collection view
                        itemAddedHandler?(ImageModel(name: document.data()["Name"] as? String ?? "", image: document.data()["ImageURL"] as? String ?? "",object: document.data() as [String : AnyObject]))
                        print("\(document.documentID) => \(document.data())")
                    }
                   
                }
            }
        }
    }
}
