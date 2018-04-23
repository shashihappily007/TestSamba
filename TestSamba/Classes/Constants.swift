//
//  Constants.swift
//  Pods-TestSamba_Tests
//
//  Created by ShashiMukul Chakrawarti on 18/04/18.
//

import Foundation

internal enum BaseUrl : String
{
    case debug = "https://gabbar.happly.in"
    case production = "https://crm.happilyunmarried.com/"
}

internal enum EndPoint : String
{
    case debug = "/sambha/track.png"
    case production = "crm/sambha/track.png"
}

internal struct Session
{
    public static var customerId : String = ""
    public static var isAnonSession : String = ""
    public static var anonId : String = ""
    public static var referrer : String = ""
}
