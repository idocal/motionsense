import UIKit
import CoreMotion

class timePointObject {
    var userAccX: Int!
    var userAccY: Int!
    var userAccZ: Int!
    
    var attitudeRoll: Int!
    var attitudePitch: Int!
    var attitudeYaw: Int!
    
    var gravityX: Int!
    var gravityY: Int!
    var gravityZ: Int!
    
    var rotX: Int!
    var rotY: Int!
    var rotZ: Int!
    
    init(
        userAccX: Int, userAccY: Int, userAccZ: Int,
        attitudeRoll: Int, attitudePitch: Int, attitudeYaw: Int,
        gravityX: Int, gravityY: Int, gravityZ: Int,
        rotX: Int, rotY: Int, rotZ: Int
        ) {
        self.userAccX = userAccX
        self.userAccY = userAccY
        self.userAccZ = userAccZ
        self.attitudeRoll = attitudeRoll
        self.attitudePitch = attitudePitch
        self.attitudeYaw = attitudeYaw
        self.gravityX = gravityX
        self.gravityY = gravityY
        self.gravityZ = gravityZ
        self.rotX = rotX
        self.rotY = rotY
        self.rotZ = rotZ
    }
}
class ViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    
    // Outlets
    
    @IBOutlet var userAccX: UILabel?
    @IBOutlet var userAccY: UILabel?
    @IBOutlet var userAccZ: UILabel?

    @IBOutlet var attitudeRoll: UILabel?
    @IBOutlet var attitudePitch: UILabel?
    @IBOutlet var attitudeYaw: UILabel?
    
    @IBOutlet var gravityX: UILabel?
    @IBOutlet var gravityY: UILabel?
    @IBOutlet var gravityZ: UILabel?
    
    @IBOutlet var rotX: UILabel?
    @IBOutlet var rotY: UILabel?
    @IBOutlet var rotZ: UILabel?

    
    // Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Motion manager properties
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.gyroUpdateInterval = 0.2
        motionManager.magnetometerUpdateInterval = 0.2
        motionManager.deviceMotionUpdateInterval = 0.2
        
        // Start recording data

//        if(motionManager.isGyroAvailable)
//        {
//            motionManager.startGyroUpdates(to: OperationQueue.main, withHandler: {
//                gyroData,error in
//                let gyro = gyroData!.rotationRate
//                outputRotationData(rotation: gyro)
//                if ((error) != nil){
//                    print("\(error ?? "error in gyro" as! Error)")
//                }
//            })
//        }
//
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {
            dmData,error in
            let attitude = dmData!.attitude
            let userAcceleration = dmData!.userAcceleration
            let gravity = dmData!.gravity
            let gyro = dmData!.rotationRate
//            createTimePointObject
            outputGravityData(gravity: gravity)
            outputAccelerationData(acceleration: userAcceleration)
            outputAttitudeData(attitude: attitude)
            outputRotationData(rotation: gyro)
            if ((error) != nil){
                print("\(error ?? "error in device motion" as! Error)")
            }
        })
        
        func createTimePointObject(
            acceleration: CMAcceleration, attitude: CMAttitude,
            gravity: CMAcceleration, rotation: CMRotationRate){
            
        }
        func outputAccelerationData(acceleration: CMAcceleration) {
            userAccX?.text = "\(acceleration.x).2fg"
            userAccY?.text = "\(acceleration.y).2fg"
            userAccZ?.text = "\(acceleration.z).2fg"
        }
        
        func outputAttitudeData(attitude: CMAttitude) {
            attitudeRoll?.text = "\(attitude.roll).2fr/s"
            attitudePitch?.text = "\(attitude.pitch).2fr/s"
            attitudeYaw?.text = "\(attitude.yaw).2fr/s"
        }
        // todo check the difference between gravity and acceleration
        func outputGravityData(gravity: CMAcceleration) {
            gravityX?.text = "\(gravity.x).2fr/s"
            gravityY?.text = "\(gravity.y).2fr/s"
            gravityZ?.text = "\(gravity.z).2fr/s"
        }
        
        func outputRotationData(rotation: CMRotationRate) {
            rotX?.text = "\(rotation.x).2fr/s"
            rotY?.text = "\(rotation.y).2fr/s"
            rotZ?.text = "\(rotation.z).2fr/s"
        }
        
    }
}

