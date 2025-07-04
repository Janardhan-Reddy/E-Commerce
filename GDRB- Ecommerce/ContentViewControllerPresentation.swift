//
//  ContentViewControllerPresentation.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 14/12/22.
//

import UIKit

enum ContentViewControllerPresentation {
    case embed(ContentViewController)
    case push(UIViewController)
    case modal(UIViewController)
}
