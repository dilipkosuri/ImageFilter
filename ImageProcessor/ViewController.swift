//
//  ViewController.swift
//  ImageProcessor
//
//  Created by Dilip Kosuri on 22/08/03.
//  Copyright © 2022 Dilip Kosuri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var viewTap: UIView!
    @IBOutlet weak var processingTextMessage: UILabel!
    @IBOutlet weak var compareFilter: UIButton!
    var applyFilterCompleted: Bool?

    var image: UIImage = UIImage(named: "snapshot")!
    var grayScaledImageView: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        compareFilter.isEnabled = false
        print("Background color")
        compareFilter.isEnabled = false
        compareFilter.alpha = 0.2
    }

    @IBAction func applyFilter(_ sender: UIButton) {
        if applyFilterCompleted ?? false {
            return
        } else {
            let filterObject = Filterer()
            grayScaledImageView = filterObject.applyFilter(.grayscale, to: image) ?? UIImage()

            self.animateImageView(&self.imageView, to: &grayScaledImageView!)

            applyFilterCompleted = true
            compareFilter.isEnabled = true
            compareFilter.alpha = 0.6
        }
    }

    func toggleImage(_ showGrayscaledImage: Bool) -> UIImage? {
        if showGrayscaledImage {
            return grayScaledImageView
        } else {
            return image
        }
    }

    func animateImageView(_ from: inout UIImageView, to: inout UIImage) {
        let fadeAnim:CABasicAnimation = CABasicAnimation(keyPath: "data: contents");

        fadeAnim.fromValue = from
        fadeAnim.toValue   = to
        fadeAnim.duration  = 0.8

        from.layer.add(fadeAnim, forKey: "data: contents")
        from.image = to
    }

    @IBAction func compareTheOriginalImage(_ sender: UIButton) {
        imageView.image = toggleImage(false)
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) { [weak self] in
            guard let self = self else {return}
            var image = self.toggleImage(true) ?? UIImage()
            self.animateImageView(&self.imageView, to: &image)
        }
    }
}

