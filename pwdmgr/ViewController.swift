//
//  ViewController.swift
//  pwd1203
//
//  Created by altair21 on 2017/7/25.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var preLabel: UILabel!
    @IBOutlet weak var genBtn: UIButton!
    @IBOutlet weak var undoBtn: UIButton!
    @IBOutlet weak var jumpBtn: UIButton!
    
    let titlePrefix = ["学富五车","满腹经纶","才高八斗","学贯中西","博学多才","博古通今","鸟语花香","百花齐放","繁花似锦","桃红柳绿","春色满园","春意盎然","秋高气爽","丹桂飘香","天高云淡","红叶似火","金风送爽","硕果累累","美如冠玉","眉清目秀","闭月羞花","国色天香","如花似玉","鹤发童颜","坐立不安","心急如焚","焦急万分","心急火燎","迫在眉睫","危在旦夕","千钧一发","燃眉之急","火上眉梢","刻不容缓","数九寒冬","寒气逼人","冰天雪地","天寒地冻","滴水成冰","鹅毛大雪","冥思苦想","东张西望","抓耳挠腮","聚精会神","专心致志","左顾右盼","一泻千里","惊涛骇浪","波峰浪谷","浊浪排空","波澜壮阔","风急浪高","排忧解难","甜言蜜语","诗情画意","搭窝筑巢","扶危济困","雕梁画栋","喜上眉梢","喜闻乐见","喜形于色","喜笑颜开","喜气洋洋","喜出望外","欢天喜地","开天辟地","惊天动地","瞻前顾后","南腔北调","南征北战","朝思暮想","朝令夕改","朝秦暮楚","早出晚归","危在旦夕","朝夕相处","前赴后继","冲锋陷阵","赴汤蹈火","视死如归","奋不顾身","舍生忘死","妙语连珠","出口成章","伶牙俐齿","侃侃而谈","口若悬河","滔滔不绝","鹅毛大雪","粉妆玉砌","冰天雪地","银装素裹","大雪初霁","雪虐风饕","浮想联翩","异想天开","朝思暮想","思前想后","冥思苦想","痴心妄想","一泻千里","风驰电掣","健步如飞","快步流星","稍纵即逝","瞬息万变","强取豪夺","挑肥拣瘦","顺手牵羊","取之不尽","拾金不昧","表里如一","言行一致","光明正大","光明磊落","路不拾遗","安步当车","寸步难行","跋山涉水","奔走相告","步履维艰","蹑手蹑脚","粲然一笑","哄堂大笑","眉开眼笑","捧腹大笑","破涕为笑","嫣然一笑","瓢泼大雨","狂风暴雨","滂沱大雨","暴雨如注","倾盆大雨","妙手回春","华佗再世","扁鹊重生","悬壶济世","杏林高手","出类拔萃","卓尔不群","非同凡响","凤毛麟角","鹤立鸡群","伸手不见五指","谦受益","莫须有","十年树木，百年树人","绝无仅有","独一无二","沧海一粟","寥寥无几","凤毛麟角","盖世无双","人山人海","比肩继踵","万人空巷","座无虚席","门庭若市","高朋满座","一丝不苟","全神贯注","兢兢业业","勤勤恳恳","聚精会神","废寝忘食","重峦叠嶂","崇山峻岭","悬崖峭壁","连绵起伏","峰峦雄伟","危峰兀立"]
    let locationMgr = CLLocationManager()
    
    var curPwd: String? {
        set {
            if let pwd = newValue {
                label.text = pwd
                UserDefaults.standard.set(pwd, forKey: Keys.UserDefault.current)
                
                // remove out of date notifications
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                
                addLocationNoti()
                addEveryWeekNoti()
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
        
        locationMgr.desiredAccuracy = kCLLocationAccuracyHundredMeters  // 低耗电
        locationMgr.requestAlwaysAuthorization()
        locationMgr.allowsBackgroundLocationUpdates = true
        locationMgr.delegate = self
        
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
        content.body = UserDefaults.standard.string(forKey: Keys.UserDefault.current) ?? "居然没有？！把开发者拖出去枪毙！"
        let request = UNNotificationRequest(identifier: Identifier.Push.everyday, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func addLocationNoti() {
        let centerLoc = CLLocationCoordinate2D(latitude: Location.latitude, longitude: Location.longitude)
        let region = CLCircularRegion(center: centerLoc, radius: 200, identifier: Identifier.Region.home)
        let content = UNMutableNotificationContent()
        content.title = "今天\(titlePrefix[Int(arc4random_uniform(UInt32(titlePrefix.count)))])的密码是这个"
        content.body = UserDefaults.standard.string(forKey: Keys.UserDefault.current) ?? "居然没有？！把开发者拖出去枪毙！"
        region.notifyOnExit = false
        region.notifyOnEntry = true
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
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

