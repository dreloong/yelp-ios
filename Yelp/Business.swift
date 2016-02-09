//
//  Business.swift
//  Yelp
//
//  Created by Xiaofei Long on 2/8/16.
//  Copyright © 2016 Xiaofei Long. All rights reserved.
//

import Foundation

class Business: NSObject {

    let address: String
    let categories: String?
    let distance: String?
    let imageUrl: NSURL?
    let name: String?
    let ratingImageUrl: NSURL?
    let reviewCount: NSNumber?

    init(dictionary: NSDictionary) {
        var address = ""
        if let location = dictionary["location"] as? NSDictionary {
            let addresses = location["address"] as? NSArray
            if addresses != nil && addresses!.count > 0 {
                address = addresses![0] as! String
            }

            let neighborhoods = location["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
        }
        self.address = address

        let categories = dictionary["categories"] as? [[String]]
        self.categories = categories != nil
            ? categories!.map({category in category[0]}).joinWithSeparator(", ")
            : nil

        let distanceInMeters = dictionary["distance"] as? NSNumber
        let milesPerMeter = 0.000621371
        distance = distanceInMeters != nil
            ? String(format: "%.2f mi", milesPerMeter * distanceInMeters!.doubleValue)
            : nil

        let imageUrlString = dictionary["image_url"] as? String
        imageUrl = imageUrlString != nil ? NSURL(string: imageUrlString!) : nil

        let ratingImageUrlString = dictionary["rating_img_url_large"] as? String
        ratingImageUrl = ratingImageUrlString != nil
            ? NSURL(string: ratingImageUrlString!)
            : nil

        name = dictionary["name"] as? String
        reviewCount = dictionary["review_count"] as? NSNumber
    }

    class func businesses(dictionaries dictionaries: [NSDictionary]) -> [Business] {
        return dictionaries.map({dictionary in Business(dictionary: dictionary)})
    }

    class func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }

    class func searchWithTerm(
        term: String,
        sort: YelpSortMode?,
        categories: [String]?,
        deals: Bool?,
        completion: ([Business]!, NSError!) -> Void
    ) -> Void {
        YelpClient.sharedInstance.searchWithTerm(
            term,
            sort: sort,
            categories: categories,
            deals: deals,
            completion: completion
        )
    }

}
