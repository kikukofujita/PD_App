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
    
    var rlmArray = try! Realm().objects(Data.self).sorted(byKeyPath: "date", ascending: false)
    
    var data: Data!
    var postData: PostData!
    
    @IBAction func add(_ sender: Any) {
        let measureViewController = self.storyboard?.instantiateViewController(withIdentifier: "Measure") as! MeasureViewController
        measureViewController.data = data
        self.present(measureViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self

        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // 入力欄の設定
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateString:String = formatter.string(from: Date())
        // (from: NSData() as Data)は古いNSData()をDataに変換して使っているため、上記でOK
        textField.text = dateString
        print(dateString)
        
        
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
    }

    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func changedDateEvent(sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let selectDate: String = dateFormatter.string(from: sender.date)
        print("DEBUG: selectDate = \(selectDate)")
        textField.text = selectDate as String
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    // 各セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能なcell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! PostTableViewCell
        cell.setPostData(postData: postArray[indexPath.row])
        
        // Cellに値を設定
        let data = postArray[indexPath.row]
        cell.densityLabel.text = data.density
        let pv = data.pouringVolume?.description
        cell.PVolumeLabel.text = pv
        let wv = data.wasteVolume?.description
        cell.WVolumeLabel.text = wv
        cell.wasteLabel.text = data.liquidWaste
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let stpp:String = formatter.string(from: data.stopPouring! as Date)
        cell.stopPLabel.text = stpp
        
        let sttw:String = formatter.string(from: data.startWaste! as Date)
        cell.startWLabel.text = sttw
        
        _ = data.weight?.description
//        etc.text =  (bp) + "\n" +  (data.bloodPressure)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // Auto Layoutでセルの高さを動的に変更
        return UITableViewAutomaticDimension
    }
    
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let MeasureViewController = self.storyboard?.instantiateViewController(withIdentifier: "Measure") as! MeasureViewController
        
        MeasureViewController.data = data
        present(MeasureViewController, animated: true, completion: nil)
    }
    
    // セルが削除可能
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
