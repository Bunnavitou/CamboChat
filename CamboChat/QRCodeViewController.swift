//
//  QRCodeViewController.swift
//  CamboChat
//
//  Created by Yoman on 12/29/15.
//  Copyright © 2015 Yoman. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    
    @IBOutlet weak var imgQRCode: UIImageView!
    
    var qrcodeImage: CIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        let data = "yoman".dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter!.setValue(data, forKey: "inputMessage")
        filter!.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrcodeImage = filter!.outputImage
        
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        
        imgQRCode.image = UIImage(CIImage: transformedImage)
    }

    @IBAction func BackAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
