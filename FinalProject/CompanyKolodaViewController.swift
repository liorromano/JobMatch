

import UIKit
import Koloda
import pop
import SCLAlertView

private let numberOfCards: Int = 5
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

struct employeeMatch {
    var employee: Employee
    var matchScore: Int
}


class CompanyKolodaViewController: UIViewController {
    
    var bg:UIImageView?
    var employeeArray = [employeeMatch]()
    var sortEmployeeArray = [employeeMatch]()
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    @IBOutlet weak var buttons: UIStackView!
    
    var showedList = [Show]()
    var employeeList = [Employee]()
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
        bg?.image = UIImage(named: "backgroundEmpty")
        bg?.alpha = 0.75
        bg?.layer.zPosition = -1
        
        /*ModelNotification.EmployeeList.observe{(list) in
            
            print("enter in comapny koloda")
            
            
            
            if(list != nil)
            {
                self.employeeList.removeAll()
            self.sortEmployeeArray.removeAll()
            self.showedList.removeAll()
            self.employeeArray.removeAll()
                let employees = list! as [Employee]
                
                for employee in employees
                {
                    if(employee.profession == self.job?.jobType)
                    {
                        self.employeeList.append(employee)
                    }
                }
                
                Model.instance.getAllShow(id: (self.job?.jobId)!) { (showes) in
                    self.showedList = showes
                    for show in self.showedList
                    {
                        self.employeeList = self.employeeList.filter({ (value:Employee) -> Bool in
                            return value.uID != show.showedId
                        })
                    }
                    
                    if(self.employeeList.isEmpty)
                    {
                        self.buttons.isHidden = true
                        self.view.addSubview(self.bg!)
                    }
                    else
                    {
                        self.bg?.removeFromSuperview()
                        self.buttons.isHidden = false
                        for employee in self.employeeList
                        {
                            let answer = Model.instance.FitEmployee(job: self.job!, employee: employee)
                            let employeeScore = employeeMatch(employee: employee, matchScore: answer)
                            self.employeeArray.append(employeeScore)
                            print(answer)
                        }
                        
                        self.sortEmployeeArray = self.employeeArray.sorted{ $0.matchScore < $1.matchScore }
                        
                    }
                    self.spinner?.stopAnimating()
                    self.kolodaView.reloadData()
                }
                
            }
           
        }
        buttons.isHidden = false
        spinner?.startAnimating()
        */
        
        Model.instance.getAllEmployeesAndObserve { (list) in
            print("enter in comapny koloda")
            
            
            
            if(list != nil)
            {
                self.employeeList.removeAll()
                self.sortEmployeeArray.removeAll()
                self.showedList.removeAll()
                self.employeeArray.removeAll()
                let employees = list! as [Employee]
                
                for employee in employees
                {
                    if(employee.profession == self.job?.jobType)
                    {
                        self.employeeList.append(employee)
                    }
                }
                
                Model.instance.getAllShow(id: (self.job?.jobId)!) { (showes) in
                    self.showedList = showes
                    for show in self.showedList
                    {
                        self.employeeList = self.employeeList.filter({ (value:Employee) -> Bool in
                            return value.uID != show.showedId
                        })
                    }
                    
                    if(self.employeeList.isEmpty)
                    {
                        self.buttons.isHidden = true
                        self.view.addSubview(self.bg!)
                    }
                    else
                    {
                        self.bg?.removeFromSuperview()
                        self.buttons.isHidden = false
                        for employee in self.employeeList
                        {
                            let answer = Model.instance.FitEmployee(job: self.job!, employee: employee)
                            let employeeScore = employeeMatch(employee: employee, matchScore: answer)
                            self.employeeArray.append(employeeScore)
                            print(answer)
                        }
                        
                        self.sortEmployeeArray = self.employeeArray.sorted{ $0.matchScore < $1.matchScore }
                        
                    }
                    self.spinner?.stopAnimating()
                    self.kolodaView.reloadData()
                }
                
            }
            
        }
        buttons.isHidden = false
        spinner?.startAnimating()
        
        
    }
    

    deinit{
        if (observerId != nil){
            ModelNotification.removeObserver(observer: observerId!)
        }
    }
    
    func postsListDidUpdate(notification:NSNotification){
        self.employeeList = notification.userInfo?["employee"] as! [Employee]
        self.kolodaView?.reloadData()
    }
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        //need to make function that mark that job already showed
        
        /*Model.instance.deleteEmployeeLike(employeeId: employeeList[kolodaView.currentCardIndex].uID!, jobId: (self.job?.jobId)!) { (answer) in
         if(answer == true)
         {
         self.kolodaView?.swipe(.left)
         }
         }*/
        self.kolodaView?.swipe(.left)
        
    }
    
    @IBAction func rightButtonTapped() {
        //need to make function that mark that job already showed
        
        /*Model.instance.saveEmployeeLike(employeeId: employeeList[kolodaView.currentCardIndex].uID!, jobId: (self.job?.jobId)!) { (answer) in
         if(answer == true)
         {
         Model.instance.getJobLike(employeeId: self.employeeList[self.kolodaView.currentCardIndex].uID!, jobId: (self.job?.jobId)!, callback: { (jobLike) in
         if(jobLike != nil)
         {
         print("match!!!!!!!!!!!!")
         //self.alert(name: self.employeeList[self.kolodaView.currentCardIndex].fullName)
         }
         self.kolodaView?.swipe(.right)
         })
         
         
         }
         }*/
        self.kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        if(!(sortEmployeeArray.isEmpty))
        {
            self.bg?.removeFromSuperview()
            buttons.isHidden = false
        }
        kolodaView?.revertAction()
        
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        if direction == SwipeResultDirection.right {
            Model.instance.saveShowed(uID: (job?.jobId)!,showedId: sortEmployeeArray[index].employee.uID!)
            //need to make function that mark that job already showed
            print("company swiped right")
            Model.instance.saveEmployeeLike(employeeId: sortEmployeeArray[index].employee.uID!, jobId: (self.job?.jobId)!) { (answer) in
                if(answer == true)
                {
                    Model.instance.getJobLike(employeeId: self.sortEmployeeArray[index].employee.uID!, jobId: (self.job?.jobId)!, callback: { (jobLike) in
                        if(jobLike != nil)
                        {
                            print("match card!!!!!!!!!!!!")
                            self.alert(name: self.sortEmployeeArray[index].employee.fullName)
                            Model.instance.saveMatch(jobId: (self.job?.jobId)!, employeeId: self.sortEmployeeArray[index].employee.uID!, jobName: (self.job?.jobName)!, employeeName: self.sortEmployeeArray[index].employee.fullName,companyId: (self.job?.uID)!, callback: { (answer) in
                                
                            })
                        }
                    })
                    
                    
                }
            }
        } else if direction == SwipeResultDirection.left {
            Model.instance.saveShowed(uID: (job?.jobId)!,showedId: self.sortEmployeeArray[index].employee.uID!)
            //need to make function that mark that job already showed
            print("company swiped left")
            Model.instance.deleteEmployeeLike(employeeId: self.sortEmployeeArray[index].employee.uID!, jobId: (self.job?.jobId)!) { (answer) in
                Model.instance.deleteMatch(jobId: (self.job?.jobId)!, employeeId: self.sortEmployeeArray[index].employee.uID!, callback: { (answer) in
                    
                })
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "employeeDetailKolodaSegue"
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
extension CompanyKolodaViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        buttons.isHidden = true
        self.view.addSubview(bg!)
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        self.employee = self.sortEmployeeArray[index].employee
        self.performSegue(withIdentifier: "employeeDetailKolodaSegue", sender: nil)
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
extension CompanyKolodaViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return self.sortEmployeeArray.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let photoView = Bundle.main.loadNibNamed("KolodaCompanyPhotoView", owner: self, options: nil)?[0] as? KolodaCompanyPhotoView
        Model.instance.getImageJob(urlStr: self.sortEmployeeArray[index].employee.imageUrl!, callback: { (image) in
            photoView?.image.image = image
            photoView?.fullname.text = self.sortEmployeeArray[index].employee.fullName
            photoView?.education.text = self.sortEmployeeArray[index].employee.education
            photoView?.gender.text = self.sortEmployeeArray[index].employee.gender
            photoView?.age.text = self.sortEmployeeArray[index].employee.age
            photoView?.workExperience.text = self.sortEmployeeArray[index].employee.workExperience
            photoView?.profession.text = self.sortEmployeeArray[index].employee.profession
        })
        return photoView!
    }
    
}
