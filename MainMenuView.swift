import UIKit

class MainMenuView: UIViewController {
    let UpLoadLogOut = "http://learningexpressapp.com/Application/up/sendLogOut.php"
    @IBOutlet weak var Statstics: UIButton!
    @IBOutlet weak var Genetics: UIButton!
    @IBOutlet weak var Physiology: UIButton!
    @IBOutlet weak var ExButtonOne: UIButton!
    @IBOutlet weak var ExButtonTwo: UIButton!
    @IBOutlet weak var ExButtonThree: UIButton!
    
   
    
    var Choice = [String]()
    var firstClick = false
    var secondClick = false
    var thirdClick = false
    var fourthClick = false
    var USER = String()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //var isUserLoggedIn : ViewController = ViewController()
        //if isUserLoggedIn.GetLoginBol() != 1   { self.performSegue(withIdentifier: "LoginView", sender: self) }

        Statstics.setTitle("Statistics", for: .normal)
        Genetics.setTitle("Genetics", for: .normal)
        Physiology.setTitle("Physiology", for: .normal)
        ExButtonOne.setTitle("Settings", for: .normal)
        ExButtonTwo.isHidden = true
        ExButtonThree.isHidden = true
        self.firstClick = false
        self.secondClick = false
        self.thirdClick = false
        self.fourthClick = false
        self.Choice = [String]()
        self.Statstics.layer.cornerRadius = 23
        self.Genetics.layer.cornerRadius = 23
        self.Physiology.layer.cornerRadius = 23
        self.ExButtonOne.layer.cornerRadius = 23
        self.ExButtonTwo.layer.cornerRadius = 23
        self.ExButtonThree.layer.cornerRadius = 23
        //LogUserOut
        let logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonTapped))
        self.navigationItem.rightBarButtonItem = logOutButton
    }
    override func viewDidAppear(_ animated: Bool) {
        if fourthClick != false {
            self.fourthClick = false
            Choice.remove(at: 3)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tutorialSegueID"{
            if segue.destination is TutorialView {
                let vc = segue.destination as? TutorialView
                vc?.Choice = Choice
                vc?.USER = USER
            }
        }else if segue.identifier == "exampleSegueID"{
            if segue.destination is ExampleView {
                let vc = segue.destination as? ExampleView
                vc?.Choice = Choice
                vc?.USER = USER
            }
            
        }else if segue.identifier == "practiceSegueID"{
            if segue.destination is PracticeView {
                    let vc = segue.destination as? PracticeView
                    vc?.Choice = Choice
                    vc?.USER = USER
            }
        }else if segue.identifier == "testSegueID"{
            if segue.destination is TestView {
                let vc = segue.destination as? TestView
                vc?.Choice = Choice
                vc?.USER = USER
            }
        }
        
    }
    @objc func logOutButtonTapped() {
        let request = NSMutableURLRequest(url: NSURL(string: UpLoadLogOut)! as URL)
        request.httpMethod = "POST"
        let postString = "logout=\(0)&user=\(USER)"
        request.httpBody = postString.data(using:String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with:request as URLRequest){
            data,response, error in
            if error != nil{
                print ("Error Starts:")
                print("error=\(error)")
                return
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginID") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        }
        task.resume()
    }
    
    @objc func BackButtonTapped() {
        
        if secondClick == false{
            //code goes here
            switch Choice[0]{
                case "Statistics":
                    BackTo(StatTitle: "Statistics", GeneTitle: "Genetics", PhysiTitle: "Physiology",ExButOne:"Settings",ExButTwo:" ",ExButThree:" ", click: "first",rmv: 0)
                    ExButtonTwo.isHidden = true
                case "Genetics":
                    BackTo(StatTitle: "Statistics", GeneTitle: "Genetics", PhysiTitle: "Physiology",ExButOne:"Settings",ExButTwo:" ",ExButThree:" ", click: "first", rmv:0)
                    ExButtonTwo.isHidden = true
                case "Physiology":
                    BackTo(StatTitle: "Statistics", GeneTitle: "Genetics", PhysiTitle: "Physiology",ExButOne:"Settings",ExButTwo:" ",ExButThree:" ", click: "first",rmv:0)
                    ExButtonTwo.isHidden = true
                default:
                    break
            }
            self.navigationItem.leftBarButtonItem = nil
        }else{
            if thirdClick == false{
                //code goes here
                switch Choice[1]{
                    case "Probability":
                        BackTo(StatTitle: "Probability", GeneTitle: "Chi-Square", PhysiTitle: " ",ExButOne:" ",ExButTwo:"Settings",ExButThree:" ", click: "second",rmv:1)
                    case "Chi-Square":
                        BackTo(StatTitle: "Probability", GeneTitle: "Chi-Square", PhysiTitle: " ",ExButOne:" ",ExButTwo:"Settings",ExButThree:" ", click: "second",rmv:1)
                    case "Monohybrid":
                        BackTo(StatTitle: "Monohybrid", GeneTitle: "Hardy-Weinberg", PhysiTitle: "Dihybrid Cross",ExButOne:" ",ExButTwo:"Settings",ExButThree:" ", click: "second",rmv:1)
                    case "Hardy-Weinberg":
                        BackTo(StatTitle: "Monohybrid", GeneTitle: "Hardy-Weinberg", PhysiTitle: "Dihybrid Cross",ExButOne:" ",ExButTwo:"Settings",ExButThree:" ", click: "second",rmv:1)
                    case "Dihybrid Cross":
                        BackTo(StatTitle: "Monohybrid", GeneTitle: "Hardy-Weinberg", PhysiTitle: "Dihybrid Cross",ExButOne:" ",ExButTwo:"Settings",ExButThree:" ", click: "second",rmv: 1)
                    case "Bioenergetics":
                        BackTo(StatTitle: "Bioenergetics", GeneTitle: "Surface Area", PhysiTitle: " ",ExButOne:" ",ExButTwo:"Settings",ExButThree:" ", click: "second",rmv:1)
                    case "Surface Area":
                        BackTo(StatTitle: "Bioenergetics", GeneTitle: "Surface Area", PhysiTitle: " ",ExButOne:" ",ExButTwo:"Settings",ExButThree:" ", click: "second",rmv:1)
                    default:
                        break
                }
            }else{
                if fourthClick == false{
                    //code goes here
                    if Choice[2] != nil{
                        ExButtonOne.isHidden = false
                        Physiology.isHidden = false
                        BackTo(StatTitle: "Tutorial", GeneTitle: "Example Problems", PhysiTitle: "Practice Problems",ExButOne:"Test Problems",ExButTwo:" ",ExButThree:" ", click: "third", rmv: 2)
                    }
                }
            }
        }
        
        
    }
    
    func BackTo(StatTitle:String,GeneTitle:String,PhysiTitle:String,ExButOne:String,ExButTwo:String,ExButThree:String,click:String,rmv:Int){ // NEED TO ADD NEW BUTTONS HERE
        Statstics.setTitle(StatTitle, for: .normal)
        Genetics.setTitle(GeneTitle, for: .normal)
        Physiology.setTitle(PhysiTitle, for: .normal)
        ExButtonOne.setTitle(ExButOne, for: .normal)
        ExButtonTwo.setTitle(ExButTwo, for: .normal)
        ExButtonThree.setTitle(ExButThree, for: .normal)
        switch click {
            case "first":
                self.firstClick = false

            case "second":
                self.secondClick = false

            case "third":
                self.thirdClick = false
            default:
                break
        }
        Choice.remove(at: rmv)
    }
    
    
    
    //----------------------------------------------------HEADER------------------------------------------------------------------
    //----------------------------------------------------HEADER------------------------------------------------------------------
    //----------------------------------------------------HEADER------------------------------------------------------------------
    
    //statisticsChoice = Button 1 in menu
    //geneticsChoice = Button 2 in menu
    //physiologyChoice = Button 3 in menu
    
    @IBAction func statisticsChoice(_ sender: Any) {
        if firstClick == false{
            //What you see when you first click Statistics:
            ExButtonTwo.isHidden = false
            Statstics.setTitle("Probability", for: .normal)
            Genetics.setTitle("Chi-Square", for: .normal)
            Physiology.setTitle(" ", for: .normal)
            ExButtonOne.setTitle(" ", for: .normal)
            ExButtonTwo.setTitle("Settings", for: .normal)
            //Setting.setTitle("Back", for: .normal)
            let BackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(BackButtonTapped))
            self.navigationItem.leftBarButtonItem = BackButton
            Choice.append("Statistics")
            self.firstClick = true
        }else{
            
            if secondClick == false{
                //What you see when you click Probability, Monohybrid, or Bioenergetics:
                Statstics.setTitle("Tutorial", for: .normal)
                Genetics.setTitle("Example Problems", for: .normal)
                Physiology.setTitle("Practice Problems", for: .normal)
                ExButtonOne.setTitle("Test Problems", for: .normal)
                switch Choice[0]{
                    case "Statistics":
                        Choice.append("Probability")
                        break
                    case "Genetics":
                        Choice.append("Monohybrid")
                        break
                    case "Physiology":
                        Choice.append("Bioenergetics")
                        break
                    default:
                        break
                }
                self.secondClick = true
            }else{
                if thirdClick == false{
                    //What you see after you click on Tutorial:
                    Choice.append("Tutorial")
                    Statstics.setTitle("Level 1", for: .normal)
                    if Choice[1] == "Monohybrid" || Choice[1] == "Surface Area" {
                        Physiology.isHidden = false
                        Genetics.setTitle("Level 2", for: .normal)
                        Physiology.setTitle("Level 3", for: .normal)
                        ExButtonTwo.isHidden = false
                    }else{
                        Genetics.setTitle("Level 2", for: .normal)
                        Physiology.setTitle("Level 3", for: .normal)
                    }
                    ExButtonOne.setTitle(" ", for: .normal)
                    ExButtonOne.isHidden = true
                    //ExButtonTwo.isHidden = true
                    ExButtonThree.isHidden = true
                    self.thirdClick = true
                    /*switch Choice[0]{
                        case "Statistics":
                           /* let storyboard = UIStoryboard(name:"Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "TutorialID")as! TutorialView
                            self.navigationController?.pushViewController(vc, animated: true)*/
                            break
                        case "Genetics":
                            /*let storyboard = UIStoryboard(name:"Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "TutorialID")as! TutorialView
                            self.navigationController?.pushViewController(vc, animated: true)*/
                            break
                        case "Physiology":
                            /*let storyboard = UIStoryboard(name:"Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "TutorialID")as! TutorialView
                            self.navigationController?.pushViewController(vc, animated: true)*/
                            break
                        default:
                            break
                    }*/
                }else{
                    if fourthClick == false{
                        switch Choice[2]{
                            case "Example Problems":
                                //this means they want a level 1 problem
                                Choice.append("1")
                                self.fourthClick = true
                                self.performSegue(withIdentifier: "exampleSegueID", sender: self)
                                break
                            case "Practice Problems":
                                //this means they want a level 1 problem
                                Choice.append("1")
                                self.fourthClick = true
                                self.performSegue(withIdentifier: "practiceSegueID", sender: self)
                                break
                            case "Test Problems":
                                //this means they want a level 1 problem
                                Choice.append("1")
                                self.fourthClick = true
                                self.performSegue(withIdentifier: "testSegueID", sender: self)
                                break
                            case "Tutorial":
                                Choice.append("1")
                                self.fourthClick = true
                                self.performSegue(withIdentifier: "tutorialSegueID", sender: self)
                                break
                            default:
                                break
                        }
                    }
                }
            }
        }
        
        print(Choice)
    }
    
    @IBAction func geneticsChoice(_ sender: Any) {
        if firstClick == false{
            //What you see when you click on Genetics button:
            ExButtonTwo.isHidden = false
            Statstics.setTitle("Monohybrid", for: .normal)
            Genetics.setTitle("Hardy-Weinberg", for: .normal)
            Physiology.setTitle("Dihybrid Cross", for: .normal)
            ExButtonOne.setTitle(" ", for: .normal)
            ExButtonTwo.setTitle("Settings", for: .normal)
            //Setting.setTitle("Back", for: .normal)
            let BackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(BackButtonTapped))
            self.navigationItem.leftBarButtonItem = BackButton
            Choice.append("Genetics")
            self.firstClick = true
        }else{
            if secondClick == false{
                //What you see when you click on Chi-Square, Hardy-Weinberg, or Surface Area:
                switch Choice[0]{
                    case "Statistics":
                        Statstics.setTitle("Tutorial", for: .normal)
                        Genetics.setTitle("Example Problems", for: .normal)
                        Physiology.setTitle("Practice Problems", for: .normal)
                        ExButtonOne.setTitle("Test Problems", for: .normal)
                        Choice.append("Chi-Square")
                        self.secondClick = true
                    case "Genetics":
                        Statstics.setTitle("Tutorial", for: .normal)
                        Genetics.setTitle("Example Problems", for: .normal)
                        Physiology.setTitle("Practice Problems", for: .normal)
                        ExButtonOne.setTitle("Test Problems", for: .normal)
                        Choice.append("Hardy-Weinberg")
                        self.secondClick = true
                        break
                    case "Physiology":
                        Statstics.setTitle("Tutorial", for: .normal)
                        Genetics.setTitle("Example Problems", for: .normal)
                        Physiology.setTitle("Practice Problems", for: .normal)
                        ExButtonOne.setTitle("Test Problems", for: .normal)
                        Choice.append("Surface Area")
                        self.secondClick = true
                    break
                    default:
                        break
                    }
                
            }else{
                if thirdClick == false{
                    //What you see when you click on Example Problems in any of the previously stated 
                        Choice.append("Example Problems")
                        Statstics.setTitle("Level 1", for: .normal)
                        Genetics.setTitle("Level 2", for: .normal)
                        Physiology.setTitle("Level 3", for: .normal)
                        ExButtonOne.setTitle(" ", for: .normal)
                        ExButtonOne.isHidden = true
                        //ExButtonTwo.isHidden = true
                        ExButtonThree.isHidden = true
                        self.thirdClick = true
                    
                }else{
                    
                    if fourthClick == false{
                        /*
                        if (Choice[1] == "Monohybrid" || Choice[1] == "Surface Area") && (Choice[2] == "Tutorial") {
                            let storyboard = UIStoryboard(name:"Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "SettingID")as! SettingsView
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
 */
                            switch Choice[2]{
                                case "Example Problems":
                                    //this means they want a level 2 problem
                                    Choice.append("2")
                                    self.fourthClick = true
                                    self.performSegue(withIdentifier: "exampleSegueID", sender: self)
                                    break
                                case "Practice Problems":
                                    //this means they want a level 2 problem
                                    Choice.append("2")
                                    self.fourthClick = true
                                    self.performSegue(withIdentifier: "practiceSegueID", sender: self)
                                    break
                                case "Test Problems":
                                    //this means they want a level 2 problem
                                    Choice.append("2")
                                    self.fourthClick = true
                                    self.performSegue(withIdentifier: "testSegueID", sender: self)
                                    break
                                case "Tutorial":
                                    Choice.append("2")
                                    self.fourthClick = true
                                    self.performSegue(withIdentifier: "tutorialSegueID", sender: self)
                                    break
                                default:
                                    break
                            }
                        }
                    }
                }
                
            }
        }

       // print(Choice)
        
    
    
    @IBAction func physiologyChoice(_ sender: Any) {
        if firstClick == false{
            ExButtonTwo.isHidden = false
            Statstics.setTitle("Bioenergetics", for: .normal)
            Genetics.setTitle("Surface Area", for: .normal)
            Physiology.setTitle("", for: .normal)
            ExButtonOne.setTitle(" ", for: .normal)
            ExButtonTwo.setTitle("Settings", for: .normal)
            let BackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(BackButtonTapped))
            self.navigationItem.leftBarButtonItem = BackButton
            //Setting.setTitle("Back", for: .normal)
            Choice.append("Physiology")
            self.firstClick = true
        }else{
            if secondClick == false{
                switch Choice[0]{
                    case "Statistics":
                        break
                    case "Genetics":
                        Statstics.setTitle("Tutorial", for: .normal)
                        Genetics.setTitle("Example Problems", for: .normal)
                        Physiology.setTitle("Practice Problems", for: .normal)
                        ExButtonOne.setTitle("Test Problems", for: .normal)
                        Choice.append("Dihybrid Cross")
                        secondClick = true
                        break
                    case "Physiology":
                        break
                    default:
                        break
                }
            }else{
                if thirdClick == false{
                    Choice.append("Practice Problems")
                    Statstics.setTitle("Level 1", for: .normal)
                    Genetics.setTitle("Level 2", for: .normal)
                    Physiology.setTitle("Level 3", for: .normal)
                    ExButtonOne.setTitle(" ", for: .normal)
                    ExButtonOne.isHidden = true
                    //ExButtonTwo.isHidden = true
                    ExButtonThree.isHidden = true
                    self.thirdClick = true
                }else{
                    if fourthClick == false{
                        switch Choice[2]{
                            case "Practice Problems":
                                //this means they want a level 3 problem
                                Choice.append("3")
                                self.fourthClick = true
                                self.performSegue(withIdentifier: "practiceSegueID", sender: self)
                                break
                            case "Example Problems":
                                //this means they want a level 3 problem
                                Choice.append("3")
                                self.fourthClick = true
                                self.performSegue(withIdentifier: "exampleSegueID", sender: self)
                                break
                            case "Test Problems":
                                //this means they want a level 3 problem
                                Choice.append("3")
                                self.fourthClick = true
                                self.performSegue(withIdentifier: "testSegueID", sender: self)
                                break
                            case "Tutorial":
                                Choice.append("3")
                                self.fourthClick = true
                                self.performSegue(withIdentifier: "tutorialSegueID", sender: self)
                                break
                            default:
                                break
                        }
                    }
                }
            }
        }
        
        
        print(Choice)
    }

    @IBAction func ExtraButtonOne(_ sender: Any) {
        if firstClick == false{
            //The button is now Settings
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SettingID")as! SettingsView
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            if secondClick == false{
                return
            }else{
                if thirdClick == false{
                    Choice.append("Test Problems")
                    Statstics.setTitle("Level 1", for: .normal)
                    Genetics.setTitle("Level 2", for: .normal)
                    Physiology.setTitle("Level 3", for: .normal)
                    ExButtonOne.setTitle(" ", for: .normal)
                    ExButtonOne.isHidden = true
                    //ExButtonTwo.isHidden = true
                    ExButtonThree.isHidden = true
                    self.thirdClick = true
                }
            }
        }
        
        
    }
    
    @IBAction func ExtraButtonTwo(_ sender: Any) {
        if firstClick == false {
            //The button is not visible
            return
        }else{
            if secondClick == false{
                //The button is now Settings
                let storyboard = UIStoryboard(name:"Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SettingID")as! SettingsView
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                if thirdClick == false{
                    /*//The button is now Settings
                    let storyboard = UIStoryboard(name:"Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SettingID")as! SettingsView
                    self.navigationController?.pushViewController(vc, animated: true)*/
                }else{
                    if fourthClick == false{
                        //The button is now Settings
                        let storyboard = UIStoryboard(name:"Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "SettingID")as! SettingsView
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func ExtraButtonThree(_ sender: Any) {
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}













class TeacherMainMenuView: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
   
    
   
    
    
    let UpLoadLogOut = "http://learningexpressapp.com/Application/up/sendLogOut.php"
    var USER = String()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var studentTable: UITableView!
    
    
    var tables = [TableStats]()
    var counter = 0
    let downloadAssesment = "http://learningexpressapp.com/Application/down/pullStudentData/pullData.php"
    
    var assess = [""]
    var userID = [""]
    var section = [""]
    var level = [""]
    var attempt = [""]
    var time = [""]
    var score = [""]
    var studentData = [""]
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         downloadJSON{
         print("Successful")
         self.tableView.reloadData()
         
         }
         */
        tableView.delegate = self
        tableView.dataSource = self
        getStudentInfo()
        
        
        //LogUserOut
        let logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonTapped))
        self.navigationItem.rightBarButtonItem = logOutButton
        // retriveData(assessID: assess, user_id: userID, section: section, Level: level, userAttempts: attempt, userTime: time, userScore: score)
        
        
    }
    
    
    func getStudentInfo(){
        guard let url = URL(string: downloadAssesment) else{ return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else {return}
            // let dataAsString = String(data: data, encoding: .utf8)
            //print(dataAsString!)
            do{
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as! [[String]]
                
                //print("responseString=\(responseJSON)")//prints 1 or 0 success chance
                for i in 0..<responseJSON.count{
                    
        
                    self.assess.insert(responseJSON[i][0], at: i)
                    self.userID.insert(responseJSON[i][1],at:i)
                    self.section.insert(responseJSON[i][2],at:i)
                    self.level.insert(responseJSON[i][3],at:i)
                    self.attempt.insert(responseJSON[i][4],at:i)
                    self.time.insert(responseJSON[i][5],at:i)
                    self.score.insert(responseJSON[i][6],at:i)
                    
                    
                    //print(self.assess[i])
                    //print(self.userID[i])
                    //print(self.section[i])
                    //print(self.level[i])
                    //print(self.attempt[i])
                    //print(self.score[i])
                    
                    
                   
                    
                 
                }
                
                
            }catch{
                print("ERROR")
                
            }
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
            
            }.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.userID.count - 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "StudentCell")
        
        cell.textLabel?.text = "    User ID: "+userID[indexPath.row]+"    Section: "+section[indexPath.row]+"    Level: "+level[indexPath.row]+"    Attempt: "+attempt[indexPath.row]+"    Time: "+time[indexPath.row]+"    Score: "+score[indexPath.row]
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "StudentSegueID", sender: self)
        
    }
    
   
    
    
    
    
    
    
   /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StudentSegueID"{
            if let destination = segue.destination as? StudentView {
                destination.table = tables[(tableView.indexPathForSelectedRow?.row)!]
            }
        }
    }
    
    func downloadJSON(completed: @escaping () -> ()) {
        
        let url = URL(string: "http://learningexpressapp.com/Application/down/pullStudentData/pullData.php")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                do{
                    self.tables = try JSONDecoder().decode([TableStats].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("JSON Error")
                }
            }
            }.resume()
    }
    
    */
    
    
    
    
    @objc func logOutButtonTapped() {
        let request = NSMutableURLRequest(url: NSURL(string: UpLoadLogOut)! as URL)
        request.httpMethod = "POST"
        let postString = "logout=\(0)&user=\(USER)"
        request.httpBody = postString.data(using:String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with:request as URLRequest){
            data,response, error in
            if error != nil{
                print ("Error Starts:")
                print("error=\(error)")
                return
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginID") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        }
        task.resume()
    }
    
    
}
