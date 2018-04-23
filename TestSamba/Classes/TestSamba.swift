//
//  TestSamba.swift
//  Pods-TestSamba_Tests
//
//  Created by ShashiMukul Chakrawarti on 17/04/18.
//

import Foundation

public final class TestSamba
{
    public var debug : Bool = false
    public static let sharedInstance = TestSamba()
    private init()
    {
        
    }
    
    public func recognize(customerId : String)
    {
        if customerId == ""
        {
            let randomId = generateRandomId()
            Session.customerId = randomId
            Session.anonId = ""
            Session.isAnonSession = "true"
        }
        else
        {
            Session.customerId = customerId
            Session.anonId = ""
            Session.isAnonSession = "false"
        }
    }
    
    public func recognize()
    {
        let randomId = generateRandomId()
        Session.customerId = randomId
        Session.anonId = ""
        Session.isAnonSession = "true"
    }
    
    private func generateRandomId() -> String
    {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let length = 48
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    public func track(event : String, data : [String : Any])
    {
        makePixel(eventName: event, eventData: data)
    }
    
    public func track(event : String)
    {
        makePixel(eventName: event, eventData: nil)
    }
    
    public func register(event : String, data : [String : Any])
    {
        self.track(event: event, data: data)
    }
    
    public func login(event : String, data : [String : Any])
    {
        self.track(event: event, data: data)
    }
    
    private func makePixel(eventName : String, eventData : [String : Any]?)
    {
        let time = round((Date().timeIntervalSince1970) * 1000)
        let timestamp = String(format : "%.0f",time)
        //print("timestamp \(timestamp)")
        var urlParamDict : [String : Any]? = nil
        if eventData != nil
        {
            urlParamDict = ["isAnonSession" : Session.isAnonSession, "id" : Session.customerId, "anonId" : Session.anonId, "eventToTrack" : eventName, "params" : eventData ?? "", "timestamp" : timestamp, "referrer" : Session.referrer]
        }
        else
        {
            urlParamDict = ["isAnonSession" : Session.isAnonSession, "id" : Session.customerId, "anonId" : Session.anonId, "eventToTrack" : eventName, "params" : "", "timestamp" : timestamp, "referrer" : Session.referrer]
        }
        var request : Request
        if self.debug
        {
            request = Request.init(base: BaseUrl.debug, endpoint: EndPoint.debug, urlParams: urlParamDict, headers: nil)
        }
        else
        {
            request = Request.init(base: BaseUrl.production, endpoint: EndPoint.production, urlParams: urlParamDict, headers: nil)
        }
        //let request = Request.init(base: BaseUrl.debug, endpoint: EndPoint.debug, urlParams: urlParamDict, headers: nil)
        let networkManager = NetworkManager.init()
        networkManager.execute(request: request, completionData: { (data : [String : Any], statusCode : Int) in
            
        })
    }
}
