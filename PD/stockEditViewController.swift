//
//  stockEditViewController.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/11/18.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseAuth
import FirebaseDatabase
import UserNotifications


class stockEditViewController: UIViewController {
    
    @IBOutlet weak var densityT: UILabel!
    @IBOutlet weak var homeIn: UITextField!
    @IBOutlet weak var homeA: UITextField!
    @IBOutlet weak var homeN: UITextField!
    @IBOutlet weak var NextD: UIDatePicker!
    @IBOutlet weak var homeU: UILabel!
    @IBOutlet weak var homeData: UITextView!
    @IBOutlet weak var nextDay: UILabel!
    
    @IBOutlet weak var ohterIn: UITextField!
    @IBOutlet weak var otherA: UITextField!
    @IBOutlet weak var otherN: UITextField!
    @IBOutlet weak var otherU: UILabel!
    @IBOutlet weak var otherData: UITextView!

    @IBOutlet weak var idText: UILabel!

    
    let realm = try! Realm()
    var data: Data!
    var listD: ListD!
    var homeUse: Int!
    var otherUse: Int!
    var homeNow: Int!
    var otherNow: Int!
    
    
    @IBAction func homeStock(_ sender: Any) {
        let newAll:Int = listD.homeAllStock +  Int(self.homeIn.text!)!
        homeA.text = String(newAll)
        let newNow:Int = newAll - Int(self.homeU.text!)!
        homeN.text = String(newNow)
    
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateString:String = formatter.string(from: Date())
        let testString:String = formatter.string(from: NextD.date as Date)
        print("日付は　\(testString)")
        if let hi = self.homeIn.text {
            if let hd = self.homeData.text {
                homeData.text = "\(dateString) : \(hi) \n" + "\(hd)"
            }
        }
        try! realm.write {
            self.listD.homeAllStock = Int(self.homeA.text!)!
            self.listD.home = self.homeData.text
            self.realm.add(self.listD, update: true)
        }
        
        homeIn.text = ""
        dismissKeyboard()
    }

    @IBAction func homeOne(_ sender: Any) {
        let newAll:Int = listD.homeAllStock - 1
        homeA.text = String(newAll)
        let newNow:Int = newAll - Int(self.homeU.text!)!
        homeN.text = String(newNow)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let dateString:String = formatter.string(from: Date())
        if let hd = self.homeData.text {
                homeData.text = "\(dateString) : -1 \n" + "\(hd)"
        }
        
        homeIn.text = ""
        try! realm.write {
            self.listD.homeAllStock = Int(self.homeA.text!)!
            self.listD.home = self.homeData.text
            self.realm.add(self.listD, update: true)
        }

    }

    @IBAction func otherStock(_ sender: Any) {
        let newAll:Int = listD.otherAllStock +  Int(self.ohterIn.text!)!
        otherA.text = String(newAll)
        let newNow:Int = newAll - Int(self.otherU.text!)!
        otherN.text = String(newNow)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateString:String = formatter.string(from: Date())
        let testString:String = formatter.string(from: NextD.date as Date)
        print("日付は　\(testString)")
        if let hi = self.ohterIn.text {
            if let hd = self.otherData.text {
                otherData.text = "\(dateString) : \(hi) \n" + "\(hd)"
            }
        }
        try! realm.write {
            self.listD.otherAllStock = Int(self.otherA.text!)!
            self.listD.other = self.otherData.text
            self.realm.add(self.listD, update: true)
        }
        
        homeIn.text = ""
        dismissKeyboard()
    }
    
    @IBAction func otherOne(_ sender: Any) {
        let newAll:Int = listD.otherAllStock - 1
        otherA.text = String(newAll)
        let newNow:Int = newAll - Int(self.otherU.text!)!
        otherN.text = String(newNow)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let dateString:String = formatter.string(from: Date())
        if let hd = self.otherData.text {
            otherData.text = "\(dateString) : -1 \n" + "\(hd)"
        }
        
        ohterIn.text = ""
        try! realm.write {
            self.listD.otherAllStock = Int(self.otherA.text!)!
            self.listD.other = self.otherData.text
            self.realm.add(self.listD, update: true)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景をタップしたらキーボードを閉じる
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        print("StockEdit  listD = \(listD)")
        // 濃度
        densityT.text = listD.listDensity
        // home 総入庫量
        homeA.text = String(listD.homeAllStock)
        // home 使用量
        if let hu = homeUse {
            homeU.text = String(hu)
        }
        // home 現在の在庫
        NextD.date = listD.homeDate as Date
        if let h = homeNow {
            print("homeNow = \(h),   \(homeNow)")
            homeN.text = "\(h)"
        }
        // other 総入庫量
        otherA.text = "\(listD.otherAllStock)"
        // other 現在の在庫
        if let on = otherNow {
            otherN.text = String(on)
        }
        // other 使用量
        if let ou = otherUse {
            otherU.text = String(ou)
        }
        // 履歴
        homeData.text = listD.home
        otherData.text = listD.other
        // id
        idText.text = String(listD.id)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let testString:String = formatter.string(from: NextD.date as Date)
        nextDay.text = testString
        

        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        // キーボードを閉じる
        view.endEditing(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.listD.homeAllStock = Int(self.homeA.text!)!
            self.listD.home = self.homeData.text!
            self.listD.otherAllStock = Int(self.otherA.text!)!
            self.listD.other = self.otherData.text!
            
            self.listD.homeDate = self.NextD.date as Date
            self.realm.add(self.listD, update: true)
        }
        setNotification(listD: listD)
        
        super.viewWillDisappear(animated)
    }
    
    // ローカル通知を登録
    func setNotification(listD: ListD) {
        let content = UNMutableNotificationContent()
        content.title = "透析液　配達日"
        content.body = "入庫してください。"
        content.sound = UNNotificationSound.default()
        
        // ローカル通知が発動するtriggerを作成
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: listD.homeDate as Date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成
        let request = UNNotificationRequest.init(identifier: String(listD.id), content: content, trigger: trigger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録OK")
               // errorがnilならローカル通知登録成功
               // errorが存在すればerrorを表示
        }
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/--------------")
                print(request)
                print("/--------------")
            }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
