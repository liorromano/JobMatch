//
//  EmptyKoloda.swift
//  FinalProject
//
//  Created by Romano on 10/05/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import UIKit
import SCLAlertView

class EmptyKoloda: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

          //alertNoCards()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        alertNoCards()
    }
    
    func alertNoCards()
    {
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false// hide default button
            
        )
        let alert = SCLAlertView(appearance: appearance) // create alert with appearance
        alert.addButton("OK", action: { // create button on alert
            self.dismiss(animated: true, completion: nil)
        })
        alert.showError("Oops...", subTitle: "Nothing to show right now...", colorStyle: 0xff4d4d)
      
        
    }

}
