//
//  ViewController.swift
//  pwd1203
//
//  Created by altair21 on 2017/7/25.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var preLabel: UILabel!
    @IBOutlet weak var genBtn: UIButton!
    @IBOutlet weak var undoBtn: UIButton!
    @IBOutlet weak var jumpBtn: UIButton!
    
    var curPwd: String? {
        set {
            if let pwd = newValue {
                label.text = pwd
                UserDefaults.standard.set(pwd, forKey: Keys.UserDefault.current)
            }
        }
        get {
            return UserDefaults.standard.string(forKey: Keys.UserDefault.current)
        }
    }
    var prePwd: String? {
        set {
            if let pwd = newValue {
                preLabel.text = pwd
                UserDefaults.standard.set(pwd, forKey: Keys.UserDefault.previous)
            }
        }
        get {
            return UserDefaults.standard.string(forKey: Keys.UserDefault.previous)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        label.text = curPwd
        preLabel.text = prePwd
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addEverydayNoti() {
        var date = DateComponents()
        date.hour = 20
        date.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = "十分牛逼的当前密码是这个"
        content.body = UserDefaults.standard.string(forKey: Keys.UserDefault.current) ?? "居然没有，把开发者拖出去枪毙"
        let request = UNNotificationRequest(identifier: Identifier.Push.everyday, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func addEveryWeekNoti() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7 * 24 * 60 * 60, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = "To be, or not to be"
        content.body = "这个密码已经使用超过一周了，一周时间内裤都换了几条了，密码怎么还不换？"
        let request = UNNotificationRequest(identifier: Identifier.Push.everyWeek, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    @IBAction func genBtnTapped(_ sender: Any) {
        let random = arc4random() % 1000000
        prePwd = curPwd
        curPwd = String(format: "%06d", random)
        
        // remove out of date notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        addEverydayNoti()
        addEveryWeekNoti()
    }
    
    @IBAction func undoTapped(_ sender: Any) {
        if prePwd == nil || prePwd == "" {
            return
        }
        curPwd = prePwd
        prePwd = ""
    }
    
    @IBAction func jumpTapped(_ sender: Any) {
        if let url = URL(string: "ziroom://") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

