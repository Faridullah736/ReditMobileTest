//
//  TextMatche.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 26, 2018

import Foundation
import SwiftyJSON


class TextMatche : NSObject, NSCoding{

    var fragment : String!
    var matches : [Matche]!
    var objectType : String!
    var objectUrl : String!
    var property : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        fragment = json["fragment"].stringValue
        matches = [Matche]()
        let matchesArray = json["matches"].arrayValue
        for matchesJson in matchesArray{
            let value = Matche(fromJson: matchesJson)
            matches.append(value)
        }
        objectType = json["object_type"].stringValue
        objectUrl = json["object_url"].stringValue
        property = json["property"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
        var dictionary = [String:Any]()
        if fragment != nil{
        	dictionary["fragment"] = fragment
        }
        if matches != nil{
        var dictionaryElements = [[String:Any]]()
        for matchesElement in matches {
        	dictionaryElements.append(matchesElement.toDictionary())
        }
        dictionary["matches"] = dictionaryElements
        }
        if objectType != nil{
        	dictionary["object_type"] = objectType
        }
        if objectUrl != nil{
        	dictionary["object_url"] = objectUrl
        }
        if property != nil{
        	dictionary["property"] = property
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		fragment = aDecoder.decodeObject(forKey: "fragment") as? String
		matches = aDecoder.decodeObject(forKey: "matches") as? [Matche]
		objectType = aDecoder.decodeObject(forKey: "object_type") as? String
		objectUrl = aDecoder.decodeObject(forKey: "object_url") as? String
		property = aDecoder.decodeObject(forKey: "property") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if fragment != nil{
			aCoder.encode(fragment, forKey: "fragment")
		}
		if matches != nil{
			aCoder.encode(matches, forKey: "matches")
		}
		if objectType != nil{
			aCoder.encode(objectType, forKey: "object_type")
		}
		if objectUrl != nil{
			aCoder.encode(objectUrl, forKey: "object_url")
		}
		if property != nil{
			aCoder.encode(property, forKey: "property")
		}

	}

}
