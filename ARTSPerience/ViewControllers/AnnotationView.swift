//
//  AnnotationView.swift
//  ARTSPerience
//
//  Created by Hafiz on 06/01/2018.
//  Copyright © 2018 Derp. All rights reserved.
//

import UIKit
import HDAugmentedReality
import SDWebImage

protocol AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView)
}

class AnnotationView: ARAnnotationView {
    
    var titleLabel = UILabel()
    var distanceLabel = UILabel()
    var imageView = UIImageView()
    var placeImageView = UIImageView()
    var delegate: AnnotationViewDelegate?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        loadUI()
    }
    
    func loadUI() {
        
        titleLabel.removeFromSuperview()
        distanceLabel.removeFromSuperview()
        imageView.removeFromSuperview()
        placeImageView.removeFromSuperview()
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        imageView.image = #imageLiteral(resourceName: "bubble")
        self.addSubview(imageView)
        
        placeImageView = UIImageView(frame: CGRect(x: 25, y: 36, width: 100, height: 78))
        placeImageView.contentMode = .scaleAspectFill
        placeImageView.rounded(radius: 4)
        self.addSubview(placeImageView)
        
        titleLabel = UILabel(frame: CGRect(x: 25, y: 18, width: 100, height: 18))
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .white
        self.addSubview(titleLabel)
        
        distanceLabel = UILabel(frame: CGRect(x: 25, y: placeImageView.frame.origin.y + placeImageView.frame.height, width: 97, height: 17))
        distanceLabel.textColor = .white
        distanceLabel.textAlignment = .right
        distanceLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(distanceLabel)
        
        if let annotation = annotation {
            titleLabel.text = annotation.title
            placeImageView.sd_setImage(with: annotation.identifier?.url, placeholderImage: #imageLiteral(resourceName: "sample"), completed: nil)
            let distance = annotation.distanceFromUser
            if distance > 1000 {
                distanceLabel.text = String(format: "%.2f km", distance/1000)
            }
            else {
                distanceLabel.text = String(format: "%.2f m", distance)
            }
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTouch(annotationView: self)
        
        print("didTouch")
    }
}
