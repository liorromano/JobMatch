
import Foundation
import FirebaseDatabase

class Chat {
    
    var key:String?
    var cid:String!
    var bid:String!
    var cname:String!
    var bname:String!
    var date:String!
    var lastTxt:String!
    
    init (cid:String, bid:String,cname:String,bname:String,key:String? = nil ,date:String="",lastTxt:String="") {
        self.key=key
        self.cid = cid
        self.bid = bid
        self.cname=cname
        self.bname=bname
        self.date=date
        self.lastTxt=lastTxt
    }
    
    
    init(json:Dictionary<String,Any>){
        
        key = json["key"] as? String
        cid = json["cid"] as! String
        bid = json["bid"] as! String
        cname = json["cname"] as! String
        bname = json["bname"] as! String
        lastTxt = json["lastTxt"] as! String
        date = json["date"] as! String
        
    }
    
    func toJson() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["key"] = key
        json["cid"] = cid
        json["bid"] = bid
        json["cname"] = cname
        json["bname"] = bname
        json["lastTxt"] = lastTxt
        json["date"] = date
        return json
    }

}
