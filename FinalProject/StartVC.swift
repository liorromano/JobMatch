//
//  StartVC.swift
//  FinalProject
//
//  Created by Romano on 03/01/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import UIKit
import CoreLocation
class StartVC: UIViewController {
    
    var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        usleep(2000000)
        
        Model.instance.loggedIn { (ans) in
            if(ans != nil)
            {
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "profileChooser")
                self.present(newViewController, animated: true, completion: nil)
            }
            else
            {
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC")
                self.present(newViewController, animated: true, completion: nil)
            }
        }
        
    }
}
