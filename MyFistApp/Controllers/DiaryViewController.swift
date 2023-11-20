//
//  DiaryViewController.swift
//  MyFistApp
//
//  Created by Admin iMBC on 11/16/23.
//

import UIKit
import CoreData

class DiaryViewController: UIViewController, SendDiaryProtocol {
    // WriteViewController의 delegate 프로토콜 함수 정의
    func sendDiary(title: String, content: String) {
        print("title: \(title), content: \(content)")
        self.save(board: title, memo: content)
        self.mytableview.reloadData()
    }
    
    var people: [NSManagedObject] = []
    let uemail : String = UserDefaults.standard.string(forKey: "email") ?? ""
    @IBOutlet weak var logoutBtn: UIButton!
    let uid : String = UserDefaults.standard.string(forKey: "id") ?? ""

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var mytableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DiaryViewController - useremail", uemail)
        // Do any additional setup after loading the view.
        self.mytableview.backgroundColor = .white
        self.addBtn.layer.cornerRadius = 15
        let myTableViewCell = UINib(nibName: String(describing: MyTableViewCell.self), bundle: nil)
        self.mytableview.register(myTableViewCell, forCellReuseIdentifier: "myTableViewCell")
        
        self.mytableview.rowHeight = UITableView.automaticDimension
        self.mytableview.estimatedRowHeight = 120
        
        self.mytableview.delegate = self
        self.mytableview.dataSource = self
    }
    @IBAction func logoutBtnClicked(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "pwd")
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.setValue(false, forKey: "autologin")
        self.dismiss(animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchItems()
        
    }
    @IBAction func addBtnClicked(_ sender: UIButton) {
        guard let writeviewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as? WriteViewController else {return}
        writeviewcontroller.diarydelegate = self
        writeviewcontroller.modalPresentationStyle = .fullScreen
        self.present(writeviewcontroller, animated: true)
        
    }
    
    
}
extension DiaryViewController:UITableViewDelegate{
   
    
}
extension DiaryViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailviewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {return}
        
        let person:NSManagedObject = people[indexPath.row]
        detailviewcontroller.data = person.value(forKey: "content") as? String ?? "데이터없음"
        detailviewcontroller.modalPresentationStyle = .fullScreen
        self.present(detailviewcontroller, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let deleteAction = UIContextualAction(style: .destructive, title: "delete", handler: {(ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            context.delete(self.people[indexPath.row])
            self.people.remove(at: indexPath.row)
            do{
                try context.save()
            }catch{
                print("error saving context \(error)")
            }
            self.mytableview.reloadData()
        
            success(true)
        })
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
   

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //테이블 뷰의 셀 갯수
        //return self.contentArray.count
        return people.count
        
    }
    
    // 각 셀에 대한 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mytableview.dequeueReusableCell(withIdentifier: "myTableViewCell", for: indexPath) as!
        MyTableViewCell
        let person:NSManagedObject = people[indexPath.row]
        cell.contentLabel.text = person.value(forKey: "title") as? String
        cell.dateLabel.text = person.value(forKey: "date") as? String
        cell.emailLabel.text = uemail
        cell.idLabel.text = uid
        return cell
    }
    
    
    //coredata method
    func save(board:String, memo: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Diary", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        person.setValue(memo, forKey: "content")
        person.setValue(board, forKey: "title")
        person.setValue(uemail, forKey: "email")
        let datetoday = Date()
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분 ss초"
        let result = dataFormatter.string(from: datetoday)
        
        person.setValue(result, forKey: "date")
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Diary")
        if uemail == ""{
            return
        }
        let predicate = NSPredicate(format: "email == %@", uemail)
        fetchRequest.predicate = predicate
        do{
            people = try managedContext.fetch(fetchRequest)
            people.reverse()
        } catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}
