//
//  DetailImageViewController.swift
//  STUnitasImageSearcher
//
//  Created by 강진석 on 11/08/2019.
//  Copyright © 2019 jskang. All rights reserved.
//

import UIKit
import Kingfisher

class DetailImageViewController: UIViewController {
    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var detailImageView: UIImageView!
    
    @IBOutlet var collectionLabel: UILabel!
    
    @IBOutlet var siteLabel: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    
    var imageDocument:ImageDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.imageDocument != nil) {
            let url = URL(string:self.imageDocument!.imageUrl!)
            let processor = RoundCornerImageProcessor(cornerRadius: 40)
            detailImageView.kf.setImage(with: url, options:[.processor(processor)])
            
            collectionLabel.text = NSLocalizedString("image_description_collection", comment: "") + " : " + imageDocument!.collection
            
            if (imageDocument!.siteName == nil || imageDocument!.siteName == "") {
                siteLabel.text = NSLocalizedString("image_description_site", comment: "") + " : " + NSLocalizedString("image_description_unknown", comment: "")
            }
            else {
                siteLabel.text = NSLocalizedString("image_description_site", comment: "") + " : " + imageDocument!.siteName
            }
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let date = dateFormatterGet.date(from: imageDocument!.dateTime) {
                dateLabel.text = NSLocalizedString("image_description_modification_date", comment: "") + " : " + dateFormatterPrint.string(from: date)
                print(dateFormatterPrint.string(from: date))
            } else {
                print("There was an error decoding the string")
            }
        
        }
        
        
    }
    
    @IBAction func onBackButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
