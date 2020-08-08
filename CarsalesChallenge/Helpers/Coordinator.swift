//  Created by Gagandeep Singh on 9/8/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.

import UIKit

protocol Coordinator: AnyObject {
    var rootViewController: UIViewController { get }
    var childCoordinators: [Coordinator] { get set }
}
