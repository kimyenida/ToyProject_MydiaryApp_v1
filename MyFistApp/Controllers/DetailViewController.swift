//
//  DetailViewController.swift
//  MyFistApp
//
//  Created by Admin iMBC on 11/16/23.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var lbDetail: UILabel!
    var data : String = ""
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbDetail.text = data

        self.backBtn.addTarget(self, action: #selector(backbutton), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
 
    @objc private func backbutton(_ sender: Any){
        print("DetailViewController - dismiss")
        self.dismiss(animated: true)
    }

}
