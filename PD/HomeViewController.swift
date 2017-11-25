//
//  HomeViewController.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/10/17.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIToolbarDelegate, UIPickerViewDelegate {


    @IBOutlet weak var totalVolLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBAction func doneBtn(_ sender: Any) {
        textField.endEditing(false)
    }

    
//    @IBOutlet weak var dateSelecter: UILabel!
    var toolBar: UIToolbar!
    var myDatePicker: UIDatePicker!
    
      // 濃度　　　　// 注液量
     // 注液時間　　// 注液終了
     // 排液開始　　// 排液時間
     // 排液量　　　// 排液の状態
     // 体重、血圧等

    var postArray: [PostData] = []
//    var data: Data!
  
    // Realmインスタンス取得
    let realm = try! Realm()
    
    var rlmArray = try! Realm().objects(Data.self).sorted(byKeyPath: "startPouring", ascending: true)
    
    
    var data: Data!
    var postData: PostData!
    
    @IBAction func add(_ sender: Any) {
/*        let measureViewController = self.storyboard?.instantiateViewController(withIdentifier: "Measure") as! MeasureViewController
        measureViewController.data = data
        self.present(measureViewController, animated: true, completion: nil) */
        textField.text = ""
        rlmArray = try! Realm().objects(Data.self).sorted(byKeyPath: "startPouring", ascending: false)
        tableView.reloadData()
        print("All Data = \(rlmArray)")
    }
    
    // 日付変更時の呼び出しメソッド
    func selectDateFilter() {
        let find = textField.text
        //let predicate = NSPredicate(format: "data.findDate = %@", find!)
        let predicate = NSPredicate(format: "findDate = %@", find!)
        rlmArray = realm.objects(Data.self).filter(predicate)
        tableView.reloadData()
        self.totalVolLabel.text = totalVolume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe_right))
        rightSwipe.delegate = self as? UIGestureRecognizerDelegate
        rightSwipe.direction = .right
            tableView.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe_left))
        leftSwipe.delegate = self as? UIGestureRecognizerDelegate
        leftSwipe.direction = .left
        tableView.addGestureRecognizer(leftSwipe)

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // テーブルセルのタップを無効にする
 //       tableView.allowsSelection = false

        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        self.tableView.estimatedRowHeight = 360
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        // 入力欄の設定
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateString:String = formatter.string(from: Date())
        // (from: NSData() as Data)は古いNSData()をDataに変換して使っているため、上記でOK
        textField.text = dateString
        print(dateString)
        selectDateFilter()
        
        
        
        // UIDatePickerの設定
        let myDatePicker: UIDatePicker = UIDatePicker()
        myDatePicker.addTarget(self, action:#selector(changedDateEvent(sender: )), for: .valueChanged)
        myDatePicker.datePickerMode = UIDatePickerMode.date
        textField.inputView = myDatePicker
        
        // UIToolBarの設定
        toolBar = UIToolbar()
        toolBar.sizeToFit()
 //       let toolBarBtn = UIBarButtonItem(title: "done", style: Plain, target: self, action: "doneBtn")
      //  toolBarBtn.items = [toolBarBtn]
        toolBar.tag = 1
        textField.inputAccessoryView = toolBar
        
        print("count: \(rlmArray.count)")
        print("viewDidLoad_rlmArray = \(rlmArray)")
        
        selectDateFilter()
    }

    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizerSumultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func changedDateEvent(sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let selectDate: String = dateFormatter.string(from: sender.date)
        print("DEBUG: selectDate = \(selectDate)")
        textField.text = selectDate as String
        selectDateFilter()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rlmArray.count
    }
    
    // 各セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能なcell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! PostTableViewCell
    //    cell.setPostData(postData: postArray[indexPath.row])
        
        // Cellに値を設定
        
        let data = rlmArray[indexPath.row]
        cell.densityLabel.text = data.density
        
        let pv = data.pouringVolume.description
        cell.PVolumeLabel.text = pv
        let wv = data.wasteVolume.description
        cell.WVolumeLabel.text = wv
        cell.wasteLabel.text = data.liquidWaste
//        cell.fDateText.text = data.findDate
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let stpp:String = formatter.string(from: data.stopPouring as Date)
        cell.stopPLabel.text = stpp
        
        let sttw:String = formatter.string(from: data.startWaste as Date)
        cell.startWLabel.text = sttw
        
        cell.PtimeLabel.text = data.pouringTime
        cell.WtimeLabel.text = data.wasteTime
        cell.idText.text = String(data.id)
        cell.weight.text = String(data.weight)
        cell.etc.text = data.bloodPressure
        cell.etc.isEditable = false
        cell.stockPlace.text = data.stockPlace

/*        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy/MM/dd"
        let fd:String = formatter2.string(from: data.date)
        cell.fDateText.text = fd   */
        cell.fDateText.text = data.findDate
        cell.differenceText.text = String(data.difference)
        
        _ = data.weight.description
//        etc.text =  (bp) + "\n" +  (data.bloodPressure)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // Auto Layoutでセルの高さを動的に変更
        return UITableViewAutomaticDimension
    }
    
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toScroll", sender: nil)
        
/*        let ScrollViewController = self.storyboard?.instantiateViewController(withIdentifier: "Scroll") as! ScrollViewController
        
        ScrollViewController.data = data
        present(ScrollViewController, animated: true, completion: nil)  */
    }
    
    // セルが削除可能 > 不可
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        //return UITableViewCellEditingStyle.delete
        if tableView.isEditing {
            return .delete
        }
        return .none
    }

    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func chagedLabelDate(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let x:String = formatter.string(from: Date())
        textField.text = x
    }
    
    func doneBtn() {
        textField.resignFirstResponder()
    }
    
    // スワイプ時の呼び出しメソッド　　左右で日付を増減する
    func swipe_left() {
/*        if textField.text != "" {
            print("before: \(textField)")
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let d:Date = formatter.date(from: textField.text!)! + 1
            let dateString:String = formatter.string(from: d)
            textField.text = dateString
            print("after: \(textField)")
            print("swipe right!")
            selectDateFilter()    */
            
    
            print("swipe_left")
            if textField.text != "" {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                
                let d:Date = formatter.date(from: textField.text!)!
                let tomorrow = NSCalendar.current.date(byAdding: .day, value: 1, to: d)
                let dateString:String = formatter.string(from: tomorrow!)
                textField.text = dateString
                
                selectDateFilter()
            }
        }

    func swipe_right() {
        if textField.text != "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let d:Date = formatter.date(from: textField.text!)! - 1
            let dateString:String = formatter.string(from: d)
            textField.text = dateString
            print("swipe right!")
            selectDateFilter()
        }
    }

    func totalVolume() -> String {
        var  total = 0
        
        // dataの配列から、differenceの合計を計算
        rlmArray.forEach { (data:Data) in
            if data.pouringVolume != 0 {
                total += data.difference
            }
        }
        print("total: \(String(total))")
        return String(total)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let _:ScrollViewController = segue.destination as! ScrollViewController
        
        if segue.identifier == "toScroll" {
            let indexPath = self.tableView.indexPathForSelectedRow
            
            if let nav = segue.destination as? UINavigationController {
                if let scrollVC = nav.topViewController as? ScrollViewController {
                    
           //         scrollVC.x = self.textField.text!
                    scrollVC.data = rlmArray[indexPath!.row]
                    scrollVC.postdata = postData
                    print("HomeVC: postData  \(postData)")
                    
                    print("toScroll によるSegue")
                    print("toScroll data = \(rlmArray[indexPath!.row])")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.totalVolLabel.text = totalVolume()
        
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
