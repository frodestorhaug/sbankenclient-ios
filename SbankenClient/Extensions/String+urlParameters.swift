//
//  String+urlParameters.swift
//  SbankenClient
//
//  Created by Terje Tjervaag on 08/10/2017.
//  Copyright © 2017 SBanken. All rights reserved.
//

// https://stackoverflow.com/a/27724627

extension String {
    
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// - returns: Returns percent-escaped string.
    
    func addingPercentEncodingForURLQueryValue() -> String? {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
        
        return addingPercentEncoding(withAllowedCharacters: allowed)
    }
    
}

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// - returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = map { key, value -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
}

public extension CharacterSet {
    
    public static let urlQueryParameterAllowed = CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: "&?"))
    
    public static let urlQueryDenied           = CharacterSet.urlQueryAllowed.inverted()
    public static let urlQueryKeyValueDenied   = CharacterSet.urlQueryParameterAllowed.inverted()
    public static let urlPathDenied            = CharacterSet.urlPathAllowed.inverted()
    public static let urlFragmentDenied        = CharacterSet.urlFragmentAllowed.inverted()
    public static let urlHostDenied            = CharacterSet.urlHostAllowed.inverted()
    
    public static let urlDenied                = CharacterSet.urlQueryDenied
        .union(.urlQueryKeyValueDenied)
        .union(.urlPathDenied)
        .union(.urlFragmentDenied)
        .union(.urlHostDenied)
    
    
    public func inverted() -> CharacterSet {
        var copy = self
        copy.invert()
        return copy
    }
}



public extension String {
    func urlEncoded(denying deniedCharacters: CharacterSet = .urlDenied) -> String? {
        return addingPercentEncoding(withAllowedCharacters: deniedCharacters.inverted())
    }
}
