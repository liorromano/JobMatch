

import UIKit
import Koloda
import pop
import SCLAlertView

private let numberOfCards: Int = 5
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

/*struct employeeMatch {
    var employee: Employee
    var matchScore: Int
}*/


class PerfectMatchKoloda: UIViewController {
    
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    @IBOutlet weak var buttons: UIStackView!
    
    var bg:UIImageView?
    var observerId:Any?
    var spinner: UIActivityIndicatorView?
    var job:Job?
    var employee: Employee?
    
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
        bg?.image = UIImage(named: "pleaseCome Back")
        bg?.alpha = 0.75
        bg?.layer.zPosition = -1
        
        if(employee == nil)
        {

            buttons.isHidden = true
            self.view.addSubview(self.bg!)
        }
        else
        {
            buttons.isHidden = false
        }

    }
    
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
                self.kolodaView?.swipe(.left)
        
    }
    
    @IBAction func rightButtonTapped() {
                self.kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        buttons.isHidden = false
        kolodaView?.revertAction()
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        if direction == SwipeResultDirection.right {
            //need to make function that mark that job already showed
            print("company swiped right")
            Model.instance.saveEmployeeLike(employeeId: (employee?.uID!)!, jobId: (self.job?.jobId)!) { (answer) in
                if(answer == true)
                {
                    Model.instance.getJobLike(employeeId: (self.employee?.uID!)!, jobId: (self.job?.jobId)!, callback: { (jobLike) in
                        if(jobLike != nil)
                        {
                            print("match card!!!!!!!!!!!!")
                            self.alert(name: (self.employee?.fullName)!)
                            Model.instance.saveMatch(jobId: (self.job?.jobId)!, employeeId: (self.employee?.uID!)!, jobName: (self.job?.jobName)!, employeeName: (self.employee?.fullName)!,companyId: (self.job?.uID)!, callback: { (answer) in
                                
                            })
                        }
                    })
                    
                    
                }
            }
        }
        else if direction == SwipeResultDirection.left {
            //need to make function that mark that job already showed
            print("company swiped left")
            Model.instance.deleteEmployeeLike(employeeId: (self.employee?.uID!)!, jobId: (self.job?.jobId)!) { (answer) in
                Model.instance.deleteMatch(jobId: (self.job?.jobId)!, employeeId: (self.employee?.uID!)!, callback: { (answer) in
                    
                })
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "PerfectMatchEmployeeDetailSegue"
        {
            let vc = segue.destination as? EmployeeLargeDetailKoloda
            vc?.employee = self.employee
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
            subTitle: "There are no more employees available right now", // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Done", // Optional button value, default: ""
            style: .error, // Styles - see below.
            colorStyle: 0xff4d4d,
            colorTextButton: 0xFFFFFF
        )
    }
    
    
}

//MARK: KolodaViewDelegate
extension PerfectMatchKoloda: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        //kolodaView.resetCurrentCardIndex()
        //alertNoCards()
        buttons.isHidden = true
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        self.performSegue(withIdentifier: "PerfectMatchEmployeeDetailSegue", sender: nil)
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
extension PerfectMatchKoloda: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        if(employee == nil)
        {
            return 0
        }
        else
        {
            return 1
        }
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let photoView = Bundle.main.loadNibNamed("KolodaCompanyPhotoView", owner: self, options: nil)?[0] as? KolodaCompanyPhotoView
        Model.instance.getImageJob(urlStr: (self.employee?.imageUrl!)!, callback: { (image) in
            photoView?.image.image = image
            photoView?.fullname.text = self.employee?.fullName
            photoView?.education.text = self.employee?.education
            photoView?.gender.text = self.employee?.gender
            photoView?.age.text = self.employee?.age
            photoView?.workExperience.text = self.employee?.workExperience
            photoView?.profession.text = self.employee?.profession
            
        })
        return photoView!
    }
    
}
