

import UIKit
import Koloda
import pop
import SCLAlertView

private let numberOfCards: Int = 5
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

struct companyMatch {
    var job: Job
    var matchScore: Int
}

class EmployeeKolodaViewController: UIViewController {
    
    var bg:UIImageView?
    @IBOutlet weak var buttons: UIStackView!
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    var scores = [Int]()
    var showedList = [Show]()
    var jobList = [Job]()
    var observerId:Any?
    var spinner: UIActivityIndicatorView?
    var job: Job?
    var uid: String?
    
    
    
    
    var companyArray = [companyMatch]()
    var sortCompanyArray = [companyMatch]()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        //spinner configuration
        spinner = UIActivityIndicatorView()
        spinner?.center = (self.kolodaView?.center)!
        spinner?.hidesWhenStopped = true
        spinner?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        kolodaView?.addSubview(spinner!)
        

        bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg?.image = UIImage(named: "backgroundEmpty")
        bg?.alpha = 0.75
        bg?.layer.zPosition = -1

        /*ModelNotification.JobList.observe{(list) in
            if(list != nil)
            {
                
            self.sortCompanyArray.removeAll()
            self.showedList.removeAll()
            self.companyArray.removeAll()
                self.jobList.removeAll()
                let jobs = list! as [Job]
                Model.instance.loggedIn { (uid) in
                    self.uid = uid
                    Model.instance.getEmployeeById(id: self.uid!, callback: { (employee) in
                        for job in jobs
                        {
                            if((job.jobType == employee?.profession) && (job.deleted == "false"))
                            {
                                
                                self.jobList.append(job)
                            }
                        }
                        Model.instance.getAllShow(id: uid!){ (showes) in
                            self.showedList = showes
                            for show in self.showedList
                            {
                                self.jobList = self.jobList.filter({ (value:Job) -> Bool in
                                    return value.jobId != show.showedId
                                })
                            }
                            
                            if(self.jobList.isEmpty)
                            {
                                
                                self.buttons.isHidden = true
                                self.view.addSubview(self.bg!)
                            }
                            else
                            {
                                self.bg?.removeFromSuperview()
                                self.buttons.isHidden = false
                                for job in self.jobList
                                {
                                    let answer = Model.instance.FitEmployee(job: job, employee: employee!)
                                    let companyScore = companyMatch(job: job, matchScore: answer)
                                    self.companyArray.append(companyScore)
                                    print(answer)
                                }
                                
                                self.sortCompanyArray = self.companyArray.sorted{ $0.matchScore < $1.matchScore }
                                
                            }
                            
                            self.spinner?.stopAnimating()
                            self.kolodaView.reloadData()
                            
                        }
                        
                        
                    })
                }
                
                
                
                
            }
        }*/
        


        
        
        buttons.isHidden = false
        spinner?.startAnimating()
        
        
        
    }
    
    deinit{
        if (observerId != nil){
            ModelNotification.removeObserver(observer: observerId!)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        Model.instance.getAllJobsAndObserve {(list) in
            if(list != nil)
            {
                
                self.sortCompanyArray.removeAll()
                self.showedList.removeAll()
                self.companyArray.removeAll()
                self.jobList.removeAll()
                let jobs = list! as [Job]
                Model.instance.loggedIn { (uid) in
                    self.uid = uid
                    Model.instance.getEmployeeById(id: self.uid!, callback: { (employee) in
                        for job in jobs
                        {
                            if((job.jobType == employee?.profession) && (job.deleted == "false"))
                            {
                                
                                self.jobList.append(job)
                            }
                        }
                        Model.instance.getAllShow(id: uid!){ (showes) in
                            self.showedList = showes
                            for show in self.showedList
                            {
                                self.jobList = self.jobList.filter({ (value:Job) -> Bool in
                                    return value.jobId != show.showedId
                                })
                            }
                            
                            if(self.jobList.isEmpty)
                            {
                                
                                self.buttons.isHidden = true
                                self.view.addSubview(self.bg!)
                            }
                            else
                            {
                                self.bg?.removeFromSuperview()
                                self.buttons.isHidden = false
                                for job in self.jobList
                                {
                                    let answer = Model.instance.FitEmployee(job: job, employee: employee!)
                                    let companyScore = companyMatch(job: job, matchScore: answer)
                                    self.companyArray.append(companyScore)
                                    print(answer)
                                }
                                
                                self.sortCompanyArray = self.companyArray.sorted{ $0.matchScore < $1.matchScore }
                                
                            }
                            
                            self.spinner?.stopAnimating()
                            self.kolodaView.reloadData()
                            
                        }
                        
                        
                    })
                }
                
                
                
                
            }
        }
    }
    
    func postsListDidUpdate(notification:NSNotification){
        self.jobList = notification.userInfo?["job"] as! [Job]
        //self.kolodaView?.reloadData()
    }
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        //need to make function that mark that job already showed
        

        self.kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        //need to make function that mark that job already showed
 
        self.kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        if(!(jobList.isEmpty))
        {
            self.bg?.removeFromSuperview()
            buttons.isHidden = false
        }
        kolodaView?.revertAction()
    }
    
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        if direction == SwipeResultDirection.right {
            Model.instance.saveShowed(uID: uid!,showedId: (self.sortCompanyArray[index].job.jobId)!)
            // implement your functions or whatever here
            print("user swiped right")
            Model.instance.saveJobLike(jobId: (self.sortCompanyArray[index].job.jobId)!) { (answer) in
                if(answer == true)
                {
                    Model.instance.getEmployeeLike(jobId: (self.sortCompanyArray[index].job.jobId)!, callback: { (employeeLike) in
                        if(employeeLike != nil)
                        {
                            print("match!!!!!!!!!!!!")
                            self.alert(name: self.sortCompanyArray[index].job.companyName!)
                            Model.instance.loggedIn(callback: { (uId) in
                                Model.instance.getEmployeeById(id: uId!, callback: { (employee) in
                                    Model.instance.saveMatch(jobId: self.sortCompanyArray[index].job.jobId!, employeeId: uId!, jobName: self.sortCompanyArray[index].job.jobName, employeeName: (employee?.fullName)!, companyId: self.sortCompanyArray[index].job.uID, callback: { (answer) in
                                        
                                    })
                                })
                            })
                        }
                    })
                    
                    
                }
            }
        }
        else if direction == SwipeResultDirection.left {
            Model.instance.saveShowed(uID: uid!,showedId: (self.sortCompanyArray[index].job.jobId)!)
            // implement your functions or whatever here
            print("user swiped left")
            Model.instance.deleteJobLike(jobId: (self.sortCompanyArray[index].job.jobId)!) { (answer) in
                Model.instance.loggedIn(callback: { (uId) in
                    Model.instance.getEmployeeById(id: uId!, callback: { (employee) in
                        Model.instance.deleteMatch(jobId: (self.jobList[index].jobId)!, employeeId: uId!, callback: { (answer) in
                            
                        })
                    })
                })
                
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "jobDetailKolodaSegue"
        {
            let vc = segue.destination as? JobLargeDetailKoloda
            vc?.job = self.job
        }
        
    }
    
    func alert(name:String)
    {
        SCLAlertView().showTitle(
            "Congratulations", // Title of view
            subTitle: "You have a match with " + name, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Done", // Optional button value, default: ""
            style: .success, // Styles - see below.
            colorStyle: 0x6DE082,
            colorTextButton: 0xFFFFFF
        )
    }
    
    func alertNoCards()
    {
        
        SCLAlertView().showTitle(
            "Oops...", // Title of view
            subTitle: "There are no more jobs available right now", // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Done", // Optional button value, default: ""
            style: .error, // Styles - see below.
            colorStyle: 0xff4d4d,
            colorTextButton: 0xFFFFFF
        )
        
    }
    
    
}

//MARK: KolodaViewDelegate
extension EmployeeKolodaViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        buttons.isHidden = true
        self.view.addSubview(bg!)
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        job = self.sortCompanyArray[index].job
        self.performSegue(withIdentifier: "jobDetailKolodaSegue", sender: nil)
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }
}

// MARK: KolodaViewDataSource
extension EmployeeKolodaViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return self.sortCompanyArray.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let photoView = Bundle.main.loadNibNamed("KolodaPhotoView", owner: self, options: nil)?[0] as? KolodaPhotoView
        Model.instance.getImageJob(urlStr: self.sortCompanyArray[index].job.imageUrl, callback: { (image) in
            photoView?.image.image = image
            photoView?.address.text = self.sortCompanyArray[index].job.jobLocation
            photoView?.descriptionText.text = self.sortCompanyArray[index].job.description
            photoView?.jobName.text = self.sortCompanyArray[index].job.jobName
            photoView?.jobType.text = self.sortCompanyArray[index].job.jobType
            photoView?.companyName.text = self.sortCompanyArray[index].job.companyName
            
            
        })
        return photoView!
    }
    
}
