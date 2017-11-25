//
//  StockViewController.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/10/17.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseAuth
import FirebaseDatabase

class StockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Realmインスタンス取得
    let realm = try! Realm()
    
    var denArray = try! Realm().objects(ListD.self).sorted(byKeyPath: "id", ascending: false)
    
    var listD: ListD!
    var data: Data!
    var homeUse: Int!
    var otherUse: Int!
    var homeNow: Int!
    var otherNow: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // テーブルセルのタップを無効にする
        //tableView.allowsSelection = false
        
/*        // 背景をタップしたらdismissKeyboardメソッドを呼ぶ
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
 */
        let nib = UINib(nibName: "StockTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "stockCell")
        tableView.rowHeight = 220  //UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
    }
    
    // キーボードを閉じる
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return denArray.count
    }
    
    // 各セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath as IndexPath) as! StockTableViewCell
        cell.setData(listD: denArray[indexPath.row])
        
        // Cellに値を設定
        var homeUseValue: Int
        var homeAllValue: Int
        var homeNowValue: Int

        let listD = denArray[indexPath.row]
        let den = listD.listDensity
        
        if den == "キャップ" {
            let predicates = [NSPredicate(format: "stockPlace = %@", argumentArray: ["Home"])]
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            let homeArray = try! Realm().objects(Data.self).filter(predicate)
            homeUseValue = homeArray.count
            homeAllValue = listD.homeAllStock
            homeNowValue = listD.homeAllStock - homeArray.count
        } else {
            let predicates = [
                NSPredicate(format: "density = %@", argumentArray: [den]),
                NSPredicate(format: "stockPlace = %@", argumentArray: ["Home"])
            ]
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            let homeArray = try! Realm().objects(Data.self).filter(predicate)
            homeUseValue = homeArray.count
            homeAllValue = listD.homeAllStock
            homeNowValue = listD.homeAllStock - homeArray.count
        }
        
        cell.homeUse.text = "\(homeUseValue)"
        cell.homeAll.text = "\(homeAllValue)"
        cell.homeNow.text = "\(homeNowValue)"
        homeUse = homeUseValue
        
        cell.idText.text = String(listD.id)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let testString:String = formatter.string(from: listD.homeDate as Date)
        cell.homeNext.text = testString
        
        // Other
        var otherUseValue: Int
        var otherAllValue: Int
        var otherNowValue: Int
        
        if den == "キャップ" {
            let predicates = [NSPredicate(format: "stockPlace = %@", argumentArray: ["Other"])]
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            let otherArray = try! Realm().objects(Data.self).filter(predicate)
            otherUseValue = otherArray.count
            otherAllValue = listD.otherAllStock
            otherNowValue = listD.otherAllStock - otherArray.count
        } else {
            let predicates = [
                NSPredicate(format: "density = %@", argumentArray: [den]),
                NSPredicate(format: "stockPlace = %@", argumentArray: ["Other"])
            ]
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            let otherArray = try! Realm().objects(Data.self).filter(predicate)
            otherUseValue = otherArray.count
            otherAllValue = listD.otherAllStock
            otherNowValue = listD.otherAllStock - otherArray.count
        }
        
        cell.otherUse.text = "\(otherUseValue)"
        cell.otherAll.text = "\(otherAllValue)"
        cell.otherNow.text = "\(otherNowValue)"
        otherUse = otherUseValue
        
        
/*   //     let data = denArray[indexPath.row]
        let listD = denArray[indexPath.row]
        let den = listD.listDensity
        
        print("cellに値を設定 listD = \(listD)")

        if den == "キャップ" {
            let predicates = [NSPredicate(format: "stockPlace = %@", argumentArray: ["Home"])]
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            let homeArray = try! Realm().objects(Data.self).filter(predicate)
            cell.homeUse.text = homeArray.count.description
            cell.homeAll.text = listD.homeAllStock.description      // 入庫総数
            homeUse = homeArray.count
            print(homeUse)
            let hNow = listD.homeAllStock -
            homeUse
            cell.homeNow.text = String(hNow)
            
        } else {
            let predicates = [
            NSPredicate(format: "density = %@", argumentArray: [den]),
            NSPredicate(format: "stockPlace = %@", argumentArray: ["Home"])
            ]
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            let homeArray = try! Realm().objects(Data.self).filter(predicate)
            cell.homeUse.text = homeArray.count.description
            homeUse = homeArray.count
            print(homeUse)
            cell.homeAll.text = listD.homeAllStock.description      // 入庫総数
            let hNow = listD.homeAllStock -
            homeUse
            cell.homeNow.text = String(hNow)
        }
        
        print("listD = \(listD)")
        print("den = \(den)")
   //     print("homeArray = \(homeArray)")
        cell.densityText.text = listD.listDensity
        
        
        
        
 //       cell.homeData.text = listD.home  // 履歴
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let hNext:String = formatter.string(from: listD.homeDate as Date)
        cell.homeNext.text = hNext    // 次回入庫日
        cell.idText.text = String(listD.id)
        
        // cell.homeNow.text = (listD.homeAllStock -)
   //     cell.homeData.isEditable = false
        
        if den == "キャップ" {
            let predicates = [NSPredicate(format: "stockPlace = %@", argumentArray: ["Other"])]
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            let homeArray = try! Realm().objects(Data.self).filter(predicate)
            cell.otherUse.text = homeArray.count.description
            
        } else {
            let predicates = [
                NSPredicate(format: "density = %@", argumentArray: [den]),
                NSPredicate(format: "stockPlace = %@", argumentArray: ["Other"])
            ]
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            let homeArray = try! Realm().objects(Data.self).filter(predicate)
            cell.otherUse.text = homeArray.count.description
        }
        
        cell.otherAll.text = listD.otherAllStock.description      // 入庫総数
        let oNow = Int(cell.otherAll.text!)! - Int(cell.otherUse.text!)!
        cell.homeNow.text = String(oNow)
//        cell.otherData.text = listD.other  // 履歴
    //    cell.otherData.isEditable = false
     //   cell.homeStock.addTarget(self,action:#selector(stockButton(sender:event:)), for: UIControlEvents.touchUpInside)
 */
        
        return cell
    }
    
/*    // セル内のstockボタンがタップされた時のメソッド
    func stockButton(sender: UIButton, event:UIEvent) {
        print("home Stockボタンがタップされました。")
        // タップされたセルのインデックス
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let cell = tableView.cellForRow(at: indexPath!) as! StockTableViewCell
        var all: Int
        all = Int(cell.homeAll.text!)! + Int(cell.homeIn.text!)!
        cell.homeAll.text = all.description
        
        print("all = \(all)")
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let day: String = dateFormatter.string(from: Date())
        cell.homeData.text = "home: \(day)): \(String(describing: cell.homeIn.text)) \n"
        cell.homeIn.text = "0"
        try! realm.write {
            let cell = tableView.cellForRow(at: indexPath!) as! StockTableViewCell
            let listD = denArray[(indexPath?.row)!]
            
            print("listD = \(listD)")
            
            if cell.homeAll.text != nil {
                listD.homeAllStock = 20  //Int(all)
            }
            self.listD.home = cell.homeData.text
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let date = dateFormatter.date(from: cell.homeData.text)
            self.listD.homeDate = date!
            print("date! = \(String(describing: date))")
            
        }
        
        
    } */

    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // Auto Layoutでセルの高さを動的に変更
        return UITableViewAutomaticDimension
    }
    
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cellをタップ")
        let cell = tableView.cellForRow(at: indexPath) as! StockTableViewCell
        homeNow = Int(cell.homeNow.text!)
        otherNow = Int(cell.otherNow.text!)
        performSegue(withIdentifier: "cellSegue", sender: nil)

    }
    
    // セルが編集の時削除可能　＞＞　削除不可
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue で遷移")
        let stockEditViewController:stockEditViewController = segue.destination as! stockEditViewController
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow

            stockEditViewController.listD = denArray[(indexPath?.row)!]
            stockEditViewController.homeUse = homeUse
            stockEditViewController.otherUse = otherUse
            stockEditViewController.homeNow = homeNow
            print("moto homeNow = \(homeNow)")
            stockEditViewController.otherNow = otherNow
            
            
            
            
        }
    }
    
    
    /*       // セルをタップされたら何もせずに選択状態を解除する
     tableView.deselectRow(at: indexPath as IndexPath, animated: true)   */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
