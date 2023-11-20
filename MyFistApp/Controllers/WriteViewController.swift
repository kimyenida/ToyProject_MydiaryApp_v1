//
//  WriteViewController.swift
//  MyFistApp
//
//  Created by Admin iMBC on 11/17/23.
//

import UIKit

protocol SendDiaryProtocol{
    func sendDiary(title:String, content:String)
}
class WriteViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var titleTF: UITextField!
    var diarydelegate : SendDiaryProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotification()
        titleTF.attributedPlaceholder = NSAttributedString(string: "제목을 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        contentLabel.delegate = self
        contentLabel.backgroundColor = .white
        contentLabel.text = "내용을 입력하세요"
        contentLabel.textColor = UIColor.lightGray
        contentLabel.layer.borderWidth = 0.5
        contentLabel.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
    }
    
    @IBAction func exitBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
//        self.contentLabel.resignFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentLabel.text.isEmpty{
            contentLabel.text = "내용을 입력하세요"
            contentLabel.textColor = .lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentLabel.textColor == UIColor.lightGray{
            contentLabel.text = nil
            contentLabel.textColor = .black
        }
    }
    
    private func setupNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillshow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillhide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc fileprivate func keyboardWillshow(_ notification: Notification){
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset = contentLabel.contentInset
        contentInset.bottom = keyboardFrame.size.height
        contentLabel.contentInset = contentInset
        contentLabel.scrollIndicatorInsets = contentLabel.contentInset
        
    }
    
    @objc fileprivate func keyboardwillhide(_ notification: Notification){
        contentLabel.contentInset = UIEdgeInsets.zero
        contentLabel.scrollIndicatorInsets = contentLabel.contentInset
        
    }
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        if titleTF.text == nil || titleTF.text == "" || contentLabel.text == nil || contentLabel.text.isEmpty || contentLabel.textColor == UIColor.lightGray{
            print("nono data")
            return
        }
        diarydelegate?.sendDiary(title: titleTF.text!, content: contentLabel.text)
        self.dismiss(animated: true)
        
    }
}
