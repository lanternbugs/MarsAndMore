/*
*  Copyright (C) 2022-2025 Michael R Adams.
*  All rights reserved.
*
* This program can be redistributed and/or modified under
* the terms of the GNU General Public License; either
* version 2 of the License, or (at your option) any later version.
*
*  This code is distributed in the hope that it will
*  be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*/
//
//  Created by Michael Adams on 9/6/25.
//

#if os(iOS)
import UIKit
import SwiftUI
extension UIView {

    func takeScreenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}

class ZoomedWheelChartView: UIScrollView {

    var zoomed: Binding<Bool>?
    let imageView = UIImageView()

    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        setup(image: image)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup(image:  UIImage?) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.contentMode = .scaleAspectFit
        if let image = image {
            imageView.image = image
        }
        addSubview(imageView)
        NSLayoutConstraint.activate([
                        imageView.widthAnchor.constraint(equalTo: widthAnchor),
                          imageView.heightAnchor.constraint(equalTo: heightAnchor),
                          imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                          imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
        

        minimumZoomScale = 1
        maximumZoomScale = 2
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        
        // Setup tap gesture
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
            doubleTapRecognizer.numberOfTapsRequired = 2
            addGestureRecognizer(doubleTapRecognizer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
                self?.zoomIn()
            }
    }
    
    @objc private func doubleTap(_ sender: UITapGestureRecognizer) {
        zoomed?.wrappedValue = false
        let parent = superview
        removeFromSuperview()
        parent?.setNeedsDisplay()
    }
    
    func zoomIn() {
        setZoomScale(2, animated: true)
    }

}

extension ZoomedWheelChartView: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}


#endif
