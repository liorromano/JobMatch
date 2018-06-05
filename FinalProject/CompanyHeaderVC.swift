//
//  ProfileHeaderVC.swift
//  FinalProject
//
//  Created by Romano on 13/12/2017.
//  Copyright © 2017 Romano. All rights reserved.
//

import UIKit

class CompanyHeaderVC: UICollectionReusableView {
    
    //Image
    @IBOutlet weak var HeaderAvaImg: UIImageView!
    
    //labels
    @IBOutlet weak var HeaderFullNameLbl: UILabel!
    
    @IBOutlet weak var AdressLabel: UILabel!
    
    @IBOutlet weak var PhoneLabel: UILabel!
    //edit profile
    @IBOutlet weak var EditButton: UIButton!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //round ava
        HeaderAvaImg.layer.cornerRadius = HeaderAvaImg.frame.size.width / 2
        HeaderAvaImg.clipsToBounds = true
    }
}
