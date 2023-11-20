//
//  RegisterViewController.swift
//  MyFistApp
//
//  Created by Admin iMBC on 11/13/23.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {

    var people: [NSManagedObject] = []
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var idvalid:Bool = false
    var pwvalid:Bool = false
    var emailvalid:Bool = false
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var pwTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var goToLoginBtn: UIButton!
    
    
    @IBOutlet weak var idTFDescription: UILabel!
    
    @IBOutlet weak var emailTFDescription: UILabel!
    @IBOutlet var defalutHiddenCollection: [UILabel]!
    @IBOutlet weak var pwTFDescription: UILabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for label in defalutHiddenCollection{
            label.isHidden = true
        }
        settingTF()
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    @IBAction func goToLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func settingTF() {
        registerBtn.layer.cornerRadius = 10
        emailTF.becomeFirstResponder()
        emailTF.setClearButton(mode: .whileEditing)
        
        emailTF.setTextFieldStyle(holdertext: "이메일")
        pwTF.setTextFieldStyle(holdertext: "비밀번호")
        idTF.setTextFieldStyle(holdertext: "아이디")
        
        pwTF.setClearButton(mode: .whileEditing)
        idTF.setClearButton(mode: .whileEditing)
        
    }
    @IBAction func registerBtnClicked(_ sender: UIButton) {
        print("RegisterViewController - registerBtnClicked() called!!!!!!!!!")
        if idvalid && emailvalid && pwvalid{
            print("모두 정확한 정보임!")

            self.save(email: self.emailTF.text!, id: self.idTF.text!, password: self.pwTF.text!)
            self.navigationController?.popViewController(animated: true)
            
        } else{
            let alert = UIAlertController(title: "알림", message: "모든 항목을 올바르게 입력해주세요", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default, handler: nil)
            alert.addAction(yes)
            present(alert, animated: true, completion: nil)
            //            print("모든 항목을 올바르게 입력해주세요!")
            //            print(idvalid,"idvalid")
            //            print(emailvalid,"emailvalid")
            //            print(pwvalid,"pwvalid")
        }
    }
    
    @IBAction func idTFType(_ sender: UITextField) {
        idTFDescription.isHidden = false
        
        let userword = idTF.text?.lowercased()
        idTF.text = userword
        
        let mincount = 5
        let maxcount = 12
        let count = userword!.count
        
        switch count{
        case 0:
            idTFDescription.text = "아이디는 필수입력 정보입니다"
            idvalid = false
        case 1..<mincount:
            idTFDescription.text = "아이디는 5글자 이상이어야 합니다"
            idvalid = false
        case mincount...maxcount:
            let idPattern = "^[a-z0-9_]{\(mincount),\(maxcount)}$"
            let isValidPattern = (userword!.range(of: idPattern, options: .regularExpression) != nil)
            if isValidPattern{
                idTFDescription.text = "조건에 맞는 아이디입니다"
                idTFDescription.isHidden = true
                idvalid = true
            } else{
                idTFDescription.text = "소문자, 숫자, 빼기(-), 밑줄(_)만 사용할 수 있습니다."
                idvalid = false
            }
        default:
            idvalid = false
            idTFDescription.text = "아이디는 12글자 이하이어야 합니다."
        }
        
    }
    @IBAction func emailTFType(_ sender: UITextField) {
        emailTFDescription.isHidden = false
        let emailPattern = #"^[a-zA-Z0-9+-\_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$"#
        let isValidPattern = (emailTF.text!.range(of: emailPattern, options: .regularExpression) != nil)
        
        if emailTF.text!.isEmpty{
            emailTFDescription.text = "이메일은 필수로 입력해야 합니다"
            emailvalid = false
        } else if isValidPattern{
            emailTFDescription.text = "조건에 맞는 이메일 입니다"
            emailTFDescription.isHidden = true
            emailvalid = true
        } else{
            emailTFDescription.text = "올바르지 않은 이메일 형식입니다"
            emailvalid = false
        }
        
    }
    
    @IBAction func pwTFType(_ sender: UITextField) {
        pwTFDescription.isHidden = false
        
        let mincount = 8
        let maxcount = 16
        let count = pwTF.text!.count
        
        switch count{
        case 0:
            pwTFDescription.text = "비밀번호는 필수입력 정보입니다"
            pwvalid = false
        case 1..<mincount:
            pwTFDescription.text = "비밀번호는 8글자 이상이어야 합니다"
            pwvalid = false
        case mincount...maxcount:
            let pwPattern = #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{\#(mincount),\#(maxcount)}$"#
            let isValidPattern = (pwTF.text!.range(of: pwPattern, options: .regularExpression) != nil)
            if isValidPattern{
                pwTFDescription.text = "조건에 맞는 비밀번호입니다"
                pwTFDescription.isHidden = true
                pwvalid = true
            } else{
                pwTFDescription.text = "영어알파벳, 숫자, 특수문자가 필수로 입력되어야 합니다"
                pwvalid = false
            }
        default:
            pwvalid = false
            pwTFDescription.text = "비밀번호는 16글자 이하이어야 합니다."
        }
    }
    //coredata method
    func save(email:String, id: String, password:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        person.setValue(email, forKey: "email")
        person.setValue(password, forKey: "password")
        person.setValue(id, forKey: "id")
        do{
            try managedContext.save()
            people.append(person)
        } catch let error as NSError{
            print("could not save. \(error), \(error.userInfo)")
        }
    }

    func fetchItems(){
        guard let appDelegate:AppDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        //let predicate = NSPredicate(format: "board == %@", "순대")
        //fetchRequest.predicate = predicate
        do{
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}
