//
//  Matche.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 26, 2018

import Foundation
import SwiftyJSON


class Matche : NSObject, NSCoding{

    var indices : [Int]!
    var text : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        indices = [Int]()
        let indicesArray = json["indices"].arrayValue
        for indicesJson in indicesArray{
            indices.append(indicesJson.intValue)
        }
        text = json["text"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
        var dictionary = [String:Any]()
        if indices != nil{
        	dictionary["indices"] = indices
        }
        if text != nil{
        	dictionary["text"] = text
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		indices = aDecoder.decodeObject(forKey: "indices") as? [Int]
		text = aDecoder.decodeObject(forKey: "text") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if indices != nil{
			aCoder.encode(indices, forKey: "indices")
		}
		if text != nil{
			aCoder.encode(text, forKey: "text")
		}

	}

}
