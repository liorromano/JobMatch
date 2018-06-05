//
//  profileChooser.swift
//  FinalProject
//
//  Created by Koral Shmueli on 04/01/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import UIKit

class profileChooser: UIViewController {

    
    var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
        //spinner configuration
        spinner = UIActivityIndicatorView()
        spinner?.center = self.view.center
        spinner?.hidesWhenStopped = true
        spinner?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(spinner!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        spinner?.startAnimating()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        Model.instance.loggedIn { (uID) in
            Model.instance.getCompanyById(id: uID!, callback: { (company) in
                if( company != nil ){
                    print("profile chooser --- employer != nil")
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarEmployer")
                    self.spinner?.stopAnimating()
                    self.present(newViewController, animated: true, completion: nil)
                }
                else{
                     print("profile chooser --- employee = nil")
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarEmployee")
                    self.spinner?.stopAnimating()
                    self.present(newViewController, animated: true, completion: nil)
                }
            })
        }

    
    }


}
