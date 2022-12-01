//
//  ImageCache.swift
//  SMI
//
//  Created by Zied Gannoun on 30/11/2022.
//

import UIKit
import Foundation
public class ImageCache {
    
    public static let publicCache = ImageCache()
    private var cachedImages = [NSURL: UIImage]()
    private var loadingResponses = [NSURL:  [(IndexPath?, UIImage?) -> Swift.Void]   ]()
//    private var loadingResponses = [NSURL:  ["String":[(IndexPath?, UIImage?) -> Swift.Void]]()   ]()
//    private var loadingResponses = [NSURL: [(IndexPath?, UIImage?) -> Swift.Void], String:String]()
//    var emptyDict:NSMutableDictionary = [:]
//    private var loadingResponses = [AnyHashable: AnyHashable]()
    
    
    var myDict = [Int: Int]()
    
//    private var loadingResponse = [(IndexPath?, UIImage?) -> Swift.Void]
    
    public final func image(url: NSURL) -> UIImage? {
        return cachedImages[url]
    }

    // Returns the cached image if available, otherwise asynchronously loads and caches it.
    final func load(url: NSURL, indexPath: IndexPath?, completion: @escaping (IndexPath?, UIImage?) -> Swift.Void) {
        
        
        
        // Check for a cached image.
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(indexPath, cachedImage)
            }
            return
        }
        
        
        // Go fetch the image.
        URLSession.shared.dataTask( with: url as URL, completionHandler: {
            (data, response, error) -> Void in

            
            guard let responseData = data, let image = UIImage(data: responseData),
                error == nil else {
                DispatchQueue.main.async {
                    completion(indexPath, nil)

                }
                return
            }
            // Cache the image.
            self.cachedImages[url] = image
            DispatchQueue.main.async {
                completion(indexPath, image)
            }
            

            // epmty the blocks array after returning and caching the image
            self.loadingResponses[url]?.removeAll()
            self.loadingResponses[url] = nil
            
        }).resume()

        
    }
        
}
