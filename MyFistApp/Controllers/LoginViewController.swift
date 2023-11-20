//
//  ViewController.swift
//  MyFistApp
//
//  Created by Admin iMBC on 11/13/23.
// 다이어리앱

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var autologinSwitch: UISwitch!
    var useremail:String?
    var userpw:String?
    var userid:String?
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginbtn: UIButton!
    let image = UIImage(systemName: "arrow.up.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)

    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "autologin") == true{
            let data1 = defaults.string(forKey: "email")
            let data2 = defaults.string(forKey: "pwd")
            let data3 = defaults.string(forKey: "id")
            if let email = data1, let pwd = data2, let id = data3 {
                print(email )
                print(pwd )
                print(id )
                guard let diaryVC = self.storyboard?.instantiateViewController(withIdentifier:"diaryVC") as? DiaryViewController else{return}
                diaryVC.modalPresentationStyle = .fullScreen
                self.present(diaryVC, animated: true)
                print("자동로그인 성공쓰")
                return
            }

        }
        
        
      

    

    }
    
    deinit {
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        autologinSwitch.isOn = UserDefaults.standard.bool(forKey: "autologin")

        self.emailTextField.text = ""
        self.pwTextField.text = ""
        
        settingTF()
        self.navigationController?.isNavigationBarHidden = true
        
        loginbtn.addTarget(self, action: #selector(touchupLogin), for: .touchUpInside)
    
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }


    private func settingTF() {
        emailTextField.delegate = self
        pwTextField.delegate = self
        
        
        loginbtn.layer.cornerRadius = 10
        
        emailTextField.setClearButton(mode: .whileEditing)
        pwTextField.setClearButton(mode: .whileEditing)
        emailTextField.setTextFieldStyle(holdertext: "이메일")
        pwTextField.setTextFieldStyle(holdertext: "비밀번호")
 
    }
    
    @objc fileprivate func touchupLogin(){
        var uemail:String = ""
        var upassword:String = ""
        var uid:String = ""
        
        // 텍스트필드에 적힌 이메일과 비번
        guard let validationEmail = emailTextField.text, let validationPWD = pwTextField.text else{
            return}
       
        if validationPWD == "" && validationEmail == ""{
            let alerts = UIAlertController(title: "로그인 실패", message: "이메일 혹은 비밀번호를 모두 입력하세요", preferredStyle: .alert)
            let actions = UIAlertAction(title: "OK", style: .default, handler: nil)
            alerts.addAction(actions)
            present(alerts, animated: true, completion: nil)
            return
        }
        guard let appDelegate:AppDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        let predicate = NSPredicate(format: "email == %@", validationEmail)
        fetchRequest.predicate = predicate
        do{
            let result = try managedContext.fetch(fetchRequest)
            for data in result {
                uemail = data.value(forKey: "email") as! String
                upassword = data.value(forKey: "password") as! String
                uid = data.value(forKey: "id") as! String
                print("----------------")
                print(uemail)
                print(upassword)
                print(uid)
                print("----------------")
            }
        } catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if validationEmail == uemail && validationPWD == upassword{
            print("로그인성공 다 들어맞음")
//            if autologinSwitch.isOn{
                UserDefaults.standard.set(uid, forKey: "id")
                UserDefaults.standard.set(uemail, forKey: "email")
                UserDefaults.standard.set(upassword, forKey: "pwd")
                guard let diaryVC = self.storyboard?.instantiateViewController(withIdentifier:"diaryVC") as? DiaryViewController else{return}
                diaryVC.modalPresentationStyle = .fullScreen
                self.present(diaryVC, animated: true)
//            }
            
        }
        else{
            //실패
            var alert = UIAlertController(title: "로그인 실패", message: "이메일 혹은 비밀번호가 틀립니다", preferredStyle: .alert)
            var action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func autologinSwitchClicked(_ sender: UISwitch) {
        if autologinSwitch.isOn{
            print("자동로그인 설정합니다!")
            UserDefaults.standard.setValue(true, forKey: "autologin")

        } else{
            print("자동로그인 해제")
            UserDefaults.standard.setValue(false, forKey: "autologin")

        }
    }
    
}

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        textField.layer.borderWidth = 1.5
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0.5
        

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.text != "", pwTextField.text != ""{
            pwTextField.resignFirstResponder()
            return true
        }
        else if emailTextField.text != ""{
            pwTextField.becomeFirstResponder()
            return true
        }
        return false
    }
 

}
