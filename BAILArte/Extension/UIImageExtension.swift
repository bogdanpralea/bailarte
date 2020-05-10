//
//  UIImageExtension.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 11/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit

public enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

extension UIImage {
    public func toBase64(format: ImageFormat) -> String? {
        var imageData: Data?

        switch format {
        case .png:
            imageData = self.pngData()
        case .jpeg(let compression):
            imageData = self.jpegData(compressionQuality: compression)
        }

        return imageData?.base64EncodedString()
    }
    
    public func convertBase64ToImage(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imageData)!
    }
}
