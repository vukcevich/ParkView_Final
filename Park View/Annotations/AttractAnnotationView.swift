//
//  AttractAnnotationView.swift
//  Park View
//
//  Created by Marijan Vukcevich on 8/30/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import Foundation
import MapKit


class AttractionAnnotationView: MKAnnotationView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        guard let attractAnnotation = self.annotation as? AttractionAnnotation else {
            return
        }
        
        image = attractAnnotation.type.image()
    }
    
}
