//
//  Constants.swift
//  Pods-TestSamba_Tests
//
//  Created by ShashiMukul Chakrawarti on 18/04/18.
//

import Foundation

public struct Constants{
    
}

public enum BaseUrl : String
{
    case debug = "https://gabbar.happly.in"
    case production = "https://crm.happilyunmarried.com/"
}

public enum EndPoint : String
{
    case debug = "/sambha/track.png"
    case production = "crm/sambha/track.png"
}

public struct Session
{
    public static var customerId : String = ""
    public static var isAnonSession : String = ""
    public static var anonId : String = ""
    public static var referrer : String = ""
}
