//
//  TestSamba.swift
//  Pods-TestSamba_Tests
//
//  Created by ShashiMukul Chakrawarti on 17/04/18.
//

import Foundation

public final class TestSamba
{
    public static let sharedInstance = TestSamba()
    private init()
    {
        
    }
    
    public func start()
    {
        print("this is samba start method")
    }
    
    public func testMethod()
    {
        print("This is a method")
    }
}
