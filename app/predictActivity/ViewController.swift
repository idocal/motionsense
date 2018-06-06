import UIKit
import CoreMotion


var WINDOW_SIZE = 7

var model = activityPredictor()

// Math functions

func calcMedian(array: [Double]) -> Double {
    let sorted = array.sorted()
    if sorted.count % 2 == 0 {
        return Double((sorted[(sorted.count / 2)] + sorted[(sorted.count / 2) - 1])) / 2
    } else {
        return Double(sorted[(sorted.count - 1) / 2])
    }
}

extension Array where Element == Double{
    
    func sum() -> Element {
        return self.reduce(0, +)
    }
    
    func avg() -> Element {
        return self.sum() / Element(self.count)
    }
    
    func std() -> Element {
        let mean = self.avg()
        let v = self.reduce(0, { $0 + ($1-mean)*($1-mean) })
        return sqrt(v / (Element(self.count) - 1))
    }
    
}

//func calcSum(array: [Double]) -> Double {
//    return Double(array.sum())
//}
//
//func calcAverage(array: [Double]) -> Double {
//    return Double(array.avg())
//}
//
//func calcMin(array: [Double]) -> Double {
//    return Double(array.min())
//}
//
//func calcMax(array: [Double]) -> Double {
//    return Double(array.max())
//}
//
//func calcStd(array: [Double]) -> Double {
//    return Double(array.std())
//}

// Objects that we might use

class timePointObject {
    var userAccX: Double!
    var userAccY: Double!
    var userAccZ: Double!
    
    var attitudeRoll: Double!
    var attitudePitch: Double!
    var attitudeYaw: Double!
    
    var gravityX: Double!
    var gravityY: Double!
    var gravityZ: Double!
    
    var rotX: Double!
    var rotY: Double!
    var rotZ: Double!
    
    init(
        userAccX: Double, userAccY: Double, userAccZ: Double,
        attitudeRoll: Double, attitudePitch: Double, attitudeYaw: Double,
        gravityX: Double, gravityY: Double, gravityZ: Double,
        rotX: Double, rotY: Double, rotZ: Double
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

class predictInputsObject{
    var attitude_roll_sld_mean: Double!
    var attitude_pitch_sld_mean: Double!
    var attitude_yaw_sld_mean: Double!
    var gravity_x_sld_mean: Double!
    var gravity_y_sld_mean: Double!
    var gravity_z_sld_mean: Double!
    var rotationRate_x_sld_mean: Double!
    var rotationRate_y_sld_mean: Double!
    var rotationRate_z_sld_mean: Double!
    var userAcceleration_x_sld_mean: Double!
    var userAcceleration_y_sld_mean: Double!
    var userAcceleration_z_sld_mean: Double!
    var attitude_roll_sld_sum: Double!
    var attitude_pitch_sld_sum: Double!
    var attitude_yaw_sld_sum: Double!
    var gravity_x_sld_sum: Double!
    var gravity_y_sld_sum: Double!
    var gravity_z_sld_sum: Double!
    var rotationRate_x_sld_sum: Double!
    var rotationRate_y_sld_sum: Double!
    var rotationRate_z_sld_sum: Double!
    var userAcceleration_x_sld_sum: Double!
    var userAcceleration_y_sld_sum: Double!
    var userAcceleration_z_sld_sum: Double!
    var attitude_roll_sld_median: Double!
    var attitude_pitch_sld_median: Double!
    var attitude_yaw_sld_median: Double!
    var gravity_x_sld_median: Double!
    var gravity_y_sld_median: Double!
    var gravity_z_sld_median: Double!
    var rotationRate_x_sld_median: Double!
    var rotationRate_y_sld_median: Double!
    var rotationRate_z_sld_median: Double!
    var userAcceleration_x_sld_median: Double!
    var userAcceleration_y_sld_median: Double!
    var userAcceleration_z_sld_median: Double!
    var attitude_roll_sld_min: Double!
    var attitude_pitch_sld_min: Double!
    var attitude_yaw_sld_min: Double!
    var gravity_x_sld_min: Double!
    var gravity_y_sld_min: Double!
    var gravity_z_sld_min: Double!
    var rotationRate_x_sld_min: Double!
    var rotationRate_y_sld_min: Double!
    var rotationRate_z_sld_min: Double!
    var userAcceleration_x_sld_min: Double!
    var userAcceleration_y_sld_min: Double!
    var userAcceleration_z_sld_min: Double!
    var attitude_roll_sld_max: Double!
    var attitude_pitch_sld_max: Double!
    var attitude_yaw_sld_max: Double!
    var gravity_x_sld_max: Double!
    var gravity_y_sld_max: Double!
    var gravity_z_sld_max: Double!
    var rotationRate_x_sld_max: Double!
    var rotationRate_y_sld_max: Double!
    var rotationRate_z_sld_max: Double!
    var userAcceleration_x_sld_max: Double!
    var userAcceleration_y_sld_max: Double!
    var userAcceleration_z_sld_max: Double!
    var attitude_roll_sld_std: Double!
    var attitude_pitch_sld_std: Double!
    var attitude_yaw_sld_std: Double!
    var gravity_x_sld_std: Double!
    var gravity_y_sld_std: Double!
    var gravity_z_sld_std: Double!
    var rotationRate_x_sld_std: Double!
    var rotationRate_y_sld_std: Double!
    var rotationRate_z_sld_std: Double!
    var userAcceleration_x_sld_std: Double!
    var userAcceleration_y_sld_std: Double!
    var userAcceleration_z_sld_std: Double!
    init(attitude_roll_sld_mean: Double, attitude_pitch_sld_mean: Double, attitude_yaw_sld_mean: Double, gravity_x_sld_mean: Double, gravity_y_sld_mean: Double, gravity_z_sld_mean: Double, rotationRate_x_sld_mean: Double, rotationRate_y_sld_mean: Double, rotationRate_z_sld_mean: Double, userAcceleration_x_sld_mean: Double, userAcceleration_y_sld_mean: Double, userAcceleration_z_sld_mean: Double, attitude_roll_sld_sum: Double, attitude_pitch_sld_sum: Double, attitude_yaw_sld_sum: Double, gravity_x_sld_sum: Double, gravity_y_sld_sum: Double, gravity_z_sld_sum: Double, rotationRate_x_sld_sum: Double, rotationRate_y_sld_sum: Double, rotationRate_z_sld_sum: Double, userAcceleration_x_sld_sum: Double, userAcceleration_y_sld_sum: Double, userAcceleration_z_sld_sum: Double, attitude_roll_sld_median: Double, attitude_pitch_sld_median: Double, attitude_yaw_sld_median: Double, gravity_x_sld_median: Double, gravity_y_sld_median: Double, gravity_z_sld_median: Double, rotationRate_x_sld_median: Double, rotationRate_y_sld_median: Double, rotationRate_z_sld_median: Double, userAcceleration_x_sld_median: Double, userAcceleration_y_sld_median: Double, userAcceleration_z_sld_median: Double, attitude_roll_sld_min: Double, attitude_pitch_sld_min: Double, attitude_yaw_sld_min: Double, gravity_x_sld_min: Double, gravity_y_sld_min: Double, gravity_z_sld_min: Double, rotationRate_x_sld_min: Double, rotationRate_y_sld_min: Double, rotationRate_z_sld_min: Double, userAcceleration_x_sld_min: Double, userAcceleration_y_sld_min: Double, userAcceleration_z_sld_min: Double, attitude_roll_sld_max: Double, attitude_pitch_sld_max: Double, attitude_yaw_sld_max: Double, gravity_x_sld_max: Double, gravity_y_sld_max: Double, gravity_z_sld_max: Double, rotationRate_x_sld_max: Double, rotationRate_y_sld_max: Double, rotationRate_z_sld_max: Double, userAcceleration_x_sld_max: Double, userAcceleration_y_sld_max: Double, userAcceleration_z_sld_max: Double, attitude_roll_sld_std: Double, attitude_pitch_sld_std: Double, attitude_yaw_sld_std: Double, gravity_x_sld_std: Double, gravity_y_sld_std: Double, gravity_z_sld_std: Double, rotationRate_x_sld_std: Double, rotationRate_y_sld_std: Double, rotationRate_z_sld_std: Double, userAcceleration_x_sld_std: Double, userAcceleration_y_sld_std: Double, userAcceleration_z_sld_std: Double) {
        self.attitude_roll_sld_mean = attitude_roll_sld_mean
        self.attitude_pitch_sld_mean = attitude_pitch_sld_mean
        self.attitude_yaw_sld_mean = attitude_yaw_sld_mean
        self.gravity_x_sld_mean = gravity_x_sld_mean
        self.gravity_y_sld_mean = gravity_y_sld_mean
        self.gravity_z_sld_mean = gravity_z_sld_mean
        self.rotationRate_x_sld_mean = rotationRate_x_sld_mean
        self.rotationRate_y_sld_mean = rotationRate_y_sld_mean
        self.rotationRate_z_sld_mean = rotationRate_z_sld_mean
        self.userAcceleration_x_sld_mean = userAcceleration_x_sld_mean
        self.userAcceleration_y_sld_mean = userAcceleration_y_sld_mean
        self.userAcceleration_z_sld_mean = userAcceleration_z_sld_mean
        self.attitude_roll_sld_sum = attitude_roll_sld_sum
        self.attitude_pitch_sld_sum = attitude_pitch_sld_sum
        self.attitude_yaw_sld_sum = attitude_yaw_sld_sum
        self.gravity_x_sld_sum = gravity_x_sld_sum
        self.gravity_y_sld_sum = gravity_y_sld_sum
        self.gravity_z_sld_sum = gravity_z_sld_sum
        self.rotationRate_x_sld_sum = rotationRate_x_sld_sum
        self.rotationRate_y_sld_sum = rotationRate_y_sld_sum
        self.rotationRate_z_sld_sum = rotationRate_z_sld_sum
        self.userAcceleration_x_sld_sum = userAcceleration_x_sld_sum
        self.userAcceleration_y_sld_sum = userAcceleration_y_sld_sum
        self.userAcceleration_z_sld_sum = userAcceleration_z_sld_sum
        self.attitude_roll_sld_median = attitude_roll_sld_median
        self.attitude_pitch_sld_median = attitude_pitch_sld_median
        self.attitude_yaw_sld_median = attitude_yaw_sld_median
        self.gravity_x_sld_median = gravity_x_sld_median
        self.gravity_y_sld_median = gravity_y_sld_median
        self.gravity_z_sld_median = gravity_z_sld_median
        self.rotationRate_x_sld_median = rotationRate_x_sld_median
        self.rotationRate_y_sld_median = rotationRate_y_sld_median
        self.rotationRate_z_sld_median = rotationRate_z_sld_median
        self.userAcceleration_x_sld_median = userAcceleration_x_sld_median
        self.userAcceleration_y_sld_median = userAcceleration_y_sld_median
        self.userAcceleration_z_sld_median = userAcceleration_z_sld_median
        self.attitude_roll_sld_min = attitude_roll_sld_min
        self.attitude_pitch_sld_min = attitude_pitch_sld_min
        self.attitude_yaw_sld_min = attitude_yaw_sld_min
        self.gravity_x_sld_min = gravity_x_sld_min
        self.gravity_y_sld_min = gravity_y_sld_min
        self.gravity_z_sld_min = gravity_z_sld_min
        self.rotationRate_x_sld_min = rotationRate_x_sld_min
        self.rotationRate_y_sld_min = rotationRate_y_sld_min
        self.rotationRate_z_sld_min = rotationRate_z_sld_min
        self.userAcceleration_x_sld_min = userAcceleration_x_sld_min
        self.userAcceleration_y_sld_min = userAcceleration_y_sld_min
        self.userAcceleration_z_sld_min = userAcceleration_z_sld_min
        self.attitude_roll_sld_max = attitude_roll_sld_max
        self.attitude_pitch_sld_max = attitude_pitch_sld_max
        self.attitude_yaw_sld_max = attitude_yaw_sld_max
        self.gravity_x_sld_max = gravity_x_sld_max
        self.gravity_y_sld_max = gravity_y_sld_max
        self.gravity_z_sld_max = gravity_z_sld_max
        self.rotationRate_x_sld_max = rotationRate_x_sld_max
        self.rotationRate_y_sld_max = rotationRate_y_sld_max
        self.rotationRate_z_sld_max = rotationRate_z_sld_max
        self.userAcceleration_x_sld_max = userAcceleration_x_sld_max
        self.userAcceleration_y_sld_max = userAcceleration_y_sld_max
        self.userAcceleration_z_sld_max = userAcceleration_z_sld_max
        self.attitude_roll_sld_std = attitude_roll_sld_std
        self.attitude_pitch_sld_std = attitude_pitch_sld_std
        self.attitude_yaw_sld_std = attitude_yaw_sld_std
        self.gravity_x_sld_std = gravity_x_sld_std
        self.gravity_y_sld_std = gravity_y_sld_std
        self.gravity_z_sld_std = gravity_z_sld_std
        self.rotationRate_x_sld_std = rotationRate_x_sld_std
        self.rotationRate_y_sld_std = rotationRate_y_sld_std
        self.rotationRate_z_sld_std = rotationRate_z_sld_std
        self.userAcceleration_x_sld_std = userAcceleration_x_sld_std
        self.userAcceleration_y_sld_std = userAcceleration_y_sld_std
        self.userAcceleration_z_sld_std = userAcceleration_z_sld_std
    }
}


class ViewController: UIViewController {
    
    // Sliding windows for sensors data
    
    var userAccXArray: [Double] = []
    var userAccYArray: [Double] = []
    var userAccZArray: [Double] = []
    
    var attitudeRollArray: [Double] = []
    var attitudePitchArray: [Double] = []
    var attitudeYawArray: [Double] = []
    
    var gravityXArray: [Double] = []
    var gravityYArray: [Double] = []
    var gravityZArray: [Double] = []
    
    var rotXArray: [Double] = []
    var rotYArray: [Double] = []
    var rotZArray: [Double] = []
    
    var motionManager = CMMotionManager()
    
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
    
    @IBOutlet var predictResult: UILabel!
    
    
    
    // Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Motion manager properties
        
        motionManager.deviceMotionUpdateInterval = 0.1
        
        // Start recording data
        
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {
            dmData,error in
            let attitude = dmData!.attitude
            let userAcceleration = dmData!.userAcceleration
            let gravity = dmData!.gravity
            let gyro = dmData!.rotationRate
            
            // handle the incoming data
            updateSlidingWindowArrays(acceleration: userAcceleration, attitude: attitude,
                                      gravity: gravity,rotation: gyro)
            // create inputs object for the model with the aggregated data
            let predictInputsObject = createPredictInputsObject()
            
            // predict
            let prediction = predictTheActivity(input: predictInputsObject)
            
            // output to the main screen
            outputGravityData(gravity: gravity)
            outputAccelerationData(acceleration: userAcceleration)
            outputAttitudeData(attitude: attitude)
            outputRotationData(rotation: gyro)
            outputPrediction(res: prediction)
            
            if ((error) != nil){
                print("\(error ?? "error in device motion" as! Error)")
            }
        })
        
        func updateSlidingWindowArrays(
            acceleration: CMAcceleration, attitude: CMAttitude,
            gravity: CMAcceleration, rotation: CMRotationRate){
            slidingWindowHandler(array: &userAccXArray, point: acceleration.x)
            slidingWindowHandler(array: &userAccYArray, point: acceleration.y)
            slidingWindowHandler(array: &userAccZArray, point: acceleration.z)
            
            slidingWindowHandler(array: &attitudeRollArray, point: attitude.roll)
            slidingWindowHandler(array: &attitudePitchArray, point: attitude.pitch)
            slidingWindowHandler(array: &attitudeYawArray, point: attitude.yaw)
            
            slidingWindowHandler(array: &gravityXArray, point: gravity.x)
            slidingWindowHandler(array: &gravityYArray, point: gravity.y)
            slidingWindowHandler(array: &gravityZArray, point: gravity.z)
            
            
            slidingWindowHandler(array: &rotXArray, point: rotation.x)
            slidingWindowHandler(array: &rotYArray, point: rotation.y)
            slidingWindowHandler(array: &rotZArray, point: rotation.z)
            
        }
        
        func createPredictInputsObject () -> predictInputsObject {
//        func createPredictInputsObject () -> Int64 {
        
            let attitude_roll_sld_mean = attitudeRollArray.avg()
            let attitude_pitch_sld_mean = attitudePitchArray.avg()
            let attitude_yaw_sld_mean = attitudeYawArray.avg()
            let gravity_x_sld_mean = gravityXArray.avg()
            let gravity_y_sld_mean = gravityYArray.avg()
            let gravity_z_sld_mean = gravityZArray.avg()
            let rotationRate_x_sld_mean = rotXArray.avg()
            let rotationRate_y_sld_mean = rotYArray.avg()
            let rotationRate_z_sld_mean = rotZArray.avg()
            let userAcceleration_x_sld_mean = userAccXArray.avg()
            let userAcceleration_y_sld_mean = userAccYArray.avg()
            let userAcceleration_z_sld_mean = userAccZArray.avg()
            let attitude_roll_sld_sum = attitudeRollArray.sum()
            let attitude_pitch_sld_sum = attitudePitchArray.sum()
            let attitude_yaw_sld_sum = attitudeYawArray.sum()
            let gravity_x_sld_sum = gravityXArray.sum()
            let gravity_y_sld_sum = gravityYArray.sum()
            let gravity_z_sld_sum = gravityZArray.sum()
            let rotationRate_x_sld_sum = rotXArray.sum()
            let rotationRate_y_sld_sum = rotYArray.sum()
            let rotationRate_z_sld_sum = rotZArray.sum()
            let userAcceleration_x_sld_sum = userAccXArray.sum()
            let userAcceleration_y_sld_sum = userAccYArray.sum()
            let userAcceleration_z_sld_sum = userAccZArray.sum()
            let attitude_roll_sld_median = calcMedian(array: attitudeRollArray)
            let attitude_pitch_sld_median = calcMedian(array: attitudePitchArray)
            let attitude_yaw_sld_median = calcMedian(array: attitudeYawArray)
            let gravity_x_sld_median = calcMedian(array: gravityXArray)
            let gravity_y_sld_median = calcMedian(array: gravityYArray)
            let gravity_z_sld_median = calcMedian(array: gravityZArray)
            let rotationRate_x_sld_median = calcMedian(array: rotXArray)
            let rotationRate_y_sld_median = calcMedian(array: rotYArray)
            let rotationRate_z_sld_median = calcMedian(array: rotZArray)
            let userAcceleration_x_sld_median = calcMedian(array: userAccXArray)
            let userAcceleration_y_sld_median = calcMedian(array: userAccYArray)
            let userAcceleration_z_sld_median = calcMedian(array: userAccZArray)
            let attitude_roll_sld_min = attitudeRollArray.min()
            let attitude_pitch_sld_min = attitudePitchArray.min()
            let attitude_yaw_sld_min = attitudeYawArray.min()
            let gravity_x_sld_min = gravityXArray.min()
            let gravity_y_sld_min = gravityYArray.min()
            let gravity_z_sld_min = gravityZArray.min()
            let rotationRate_x_sld_min = rotXArray.min()
            let rotationRate_y_sld_min = rotYArray.min()
            let rotationRate_z_sld_min = rotZArray.min()
            let userAcceleration_x_sld_min = userAccXArray.min()
            let userAcceleration_y_sld_min = userAccYArray.min()
            let userAcceleration_z_sld_min = userAccZArray.min()
            let attitude_roll_sld_max = attitudeRollArray.max()
            let attitude_pitch_sld_max = attitudePitchArray.max()
            let attitude_yaw_sld_max = attitudeYawArray.max()
            let gravity_x_sld_max = gravityXArray.max()
            let gravity_y_sld_max = gravityYArray.max()
            let gravity_z_sld_max = gravityZArray.max()
            let rotationRate_x_sld_max = rotXArray.max()
            let rotationRate_y_sld_max = rotYArray.max()
            let rotationRate_z_sld_max = rotZArray.max()
            let userAcceleration_x_sld_max = userAccXArray.max()
            let userAcceleration_y_sld_max = userAccYArray.max()
            let userAcceleration_z_sld_max = userAccZArray.max()
            let attitude_roll_sld_std = attitudeRollArray.std()
            let attitude_pitch_sld_std = attitudePitchArray.std()
            let attitude_yaw_sld_std = attitudeYawArray.std()
            let gravity_x_sld_std = gravityXArray.std()
            let gravity_y_sld_std = gravityYArray.std()
            let gravity_z_sld_std = gravityZArray.std()
            let rotationRate_x_sld_std = rotXArray.std()
            let rotationRate_y_sld_std = rotYArray.std()
            let rotationRate_z_sld_std = rotZArray.std()
            let userAcceleration_x_sld_std = userAccXArray.std()
            let userAcceleration_y_sld_std = userAccYArray.std()
            let userAcceleration_z_sld_std = userAccZArray.std()
            
            return predictInputsObject(attitude_roll_sld_mean: attitude_roll_sld_mean,
                                       attitude_pitch_sld_mean: attitude_pitch_sld_mean,
                                       attitude_yaw_sld_mean: attitude_yaw_sld_mean,
                                       gravity_x_sld_mean: gravity_x_sld_mean,
                                       gravity_y_sld_mean: gravity_y_sld_mean,
                                       gravity_z_sld_mean: gravity_z_sld_mean,
                                       rotationRate_x_sld_mean: rotationRate_x_sld_mean,
                                       rotationRate_y_sld_mean: rotationRate_y_sld_mean,
                                       rotationRate_z_sld_mean: rotationRate_z_sld_mean,
                                       userAcceleration_x_sld_mean: userAcceleration_x_sld_mean,
                                       userAcceleration_y_sld_mean: userAcceleration_y_sld_mean,
                                       userAcceleration_z_sld_mean: userAcceleration_z_sld_mean,
                                       attitude_roll_sld_sum: attitude_roll_sld_sum,
                                       attitude_pitch_sld_sum: attitude_pitch_sld_sum,
                                       attitude_yaw_sld_sum: attitude_yaw_sld_sum,
                                       gravity_x_sld_sum: gravity_x_sld_sum,
                                       gravity_y_sld_sum: gravity_y_sld_sum,
                                       gravity_z_sld_sum: gravity_z_sld_sum,
                                       rotationRate_x_sld_sum: rotationRate_x_sld_sum,
                                       rotationRate_y_sld_sum: rotationRate_y_sld_sum,
                                       rotationRate_z_sld_sum: rotationRate_z_sld_sum,
                                       userAcceleration_x_sld_sum: userAcceleration_x_sld_sum,
                                       userAcceleration_y_sld_sum: userAcceleration_y_sld_sum,
                                       userAcceleration_z_sld_sum: userAcceleration_z_sld_sum,
                                       attitude_roll_sld_median: attitude_roll_sld_median,
                                       attitude_pitch_sld_median: attitude_pitch_sld_median,
                                       attitude_yaw_sld_median: attitude_yaw_sld_median,
                                       gravity_x_sld_median: gravity_x_sld_median,
                                       gravity_y_sld_median: gravity_y_sld_median,
                                       gravity_z_sld_median: gravity_z_sld_median,
                                       rotationRate_x_sld_median: rotationRate_x_sld_median,
                                       rotationRate_y_sld_median: rotationRate_y_sld_median,
                                       rotationRate_z_sld_median: rotationRate_z_sld_median,
                                       userAcceleration_x_sld_median: userAcceleration_x_sld_median,
                                       userAcceleration_y_sld_median: userAcceleration_y_sld_median,
                                       userAcceleration_z_sld_median: userAcceleration_z_sld_median,
                                       attitude_roll_sld_min: attitude_roll_sld_min!,
                                       attitude_pitch_sld_min: attitude_pitch_sld_min!,
                                       attitude_yaw_sld_min: attitude_yaw_sld_min!,
                                       gravity_x_sld_min: gravity_x_sld_min!,
                                       gravity_y_sld_min: gravity_y_sld_min!,
                                       gravity_z_sld_min: gravity_z_sld_min!,
                                       rotationRate_x_sld_min: rotationRate_x_sld_min!,
                                       rotationRate_y_sld_min: rotationRate_y_sld_min!,
                                       rotationRate_z_sld_min: rotationRate_z_sld_min!,
                                       userAcceleration_x_sld_min: userAcceleration_x_sld_min!,
                                       userAcceleration_y_sld_min: userAcceleration_y_sld_min!,
                                       userAcceleration_z_sld_min: userAcceleration_z_sld_min!,
                                       attitude_roll_sld_max: attitude_roll_sld_max!,
                                       attitude_pitch_sld_max: attitude_pitch_sld_max!,
                                       attitude_yaw_sld_max: attitude_yaw_sld_max!,
                                       gravity_x_sld_max: gravity_x_sld_max!,
                                       gravity_y_sld_max: gravity_y_sld_max!,
                                       gravity_z_sld_max: gravity_z_sld_max!,
                                       rotationRate_x_sld_max: rotationRate_x_sld_max!,
                                       rotationRate_y_sld_max: rotationRate_y_sld_max!,
                                       rotationRate_z_sld_max: rotationRate_z_sld_max!,
                                       userAcceleration_x_sld_max: userAcceleration_x_sld_max!,
                                       userAcceleration_y_sld_max: userAcceleration_y_sld_max!,
                                       userAcceleration_z_sld_max: userAcceleration_z_sld_max!,
                                       attitude_roll_sld_std: attitude_roll_sld_std,
                                       attitude_pitch_sld_std: attitude_pitch_sld_std,
                                       attitude_yaw_sld_std: attitude_yaw_sld_std,
                                       gravity_x_sld_std: gravity_x_sld_std,
                                       gravity_y_sld_std: gravity_y_sld_std,
                                       gravity_z_sld_std: gravity_z_sld_std,
                                       rotationRate_x_sld_std: rotationRate_x_sld_std,
                                       rotationRate_y_sld_std: rotationRate_y_sld_std,
                                       rotationRate_z_sld_std: rotationRate_z_sld_std,
                                       userAcceleration_x_sld_std: userAcceleration_x_sld_std,
                                       userAcceleration_y_sld_std: userAcceleration_y_sld_std,
                                       userAcceleration_z_sld_std: userAcceleration_z_sld_std)
            
        }
        func predictTheActivity (input: predictInputsObject) -> Int64 {
            do {
                let prediction = try model.prediction(attitude_roll_sld_mean: input.attitude_roll_sld_mean,
                                                      attitude_pitch_sld_mean: input.attitude_pitch_sld_mean,
                                                      attitude_yaw_sld_mean: input.attitude_yaw_sld_mean,
                                                      gravity_x_sld_mean: input.gravity_x_sld_mean,
                                                      gravity_y_sld_mean: input.gravity_y_sld_mean,
                                                      gravity_z_sld_mean: input.gravity_z_sld_mean,
                                                      rotationRate_x_sld_mean: input.rotationRate_x_sld_mean,
                                                      rotationRate_y_sld_mean: input.rotationRate_y_sld_mean,
                                                      rotationRate_z_sld_mean: input.rotationRate_z_sld_mean,
                                                      userAcceleration_x_sld_mean: input.userAcceleration_x_sld_mean,
                                                      userAcceleration_y_sld_mean: input.userAcceleration_y_sld_mean,
                                                      userAcceleration_z_sld_mean: input.userAcceleration_z_sld_mean,
                                                      attitude_roll_sld_sum: input.attitude_roll_sld_sum,
                                                      attitude_pitch_sld_sum: input.attitude_pitch_sld_sum,
                                                      attitude_yaw_sld_sum: input.attitude_yaw_sld_sum,
                                                      gravity_x_sld_sum: input.gravity_x_sld_sum,
                                                      gravity_y_sld_sum: input.gravity_y_sld_sum,
                                                      gravity_z_sld_sum: input.gravity_z_sld_sum,
                                                      rotationRate_x_sld_sum: input.rotationRate_x_sld_sum,
                                                      rotationRate_y_sld_sum: input.rotationRate_y_sld_sum,
                                                      rotationRate_z_sld_sum: input.rotationRate_z_sld_sum,
                                                      userAcceleration_x_sld_sum: input.userAcceleration_x_sld_sum,
                                                      userAcceleration_y_sld_sum: input.userAcceleration_y_sld_sum,
                                                      userAcceleration_z_sld_sum: input.userAcceleration_z_sld_sum,
                                                      attitude_roll_sld_median: input.attitude_roll_sld_median,
                                                      attitude_pitch_sld_median: input.attitude_pitch_sld_median,
                                                      attitude_yaw_sld_median: input.attitude_yaw_sld_median,
                                                      gravity_x_sld_median: input.gravity_x_sld_median,
                                                      gravity_y_sld_median: input.gravity_y_sld_median,
                                                      gravity_z_sld_median: input.gravity_z_sld_median,
                                                      rotationRate_x_sld_median: input.rotationRate_x_sld_median,
                                                      rotationRate_y_sld_median: input.rotationRate_y_sld_median,
                                                      rotationRate_z_sld_median: input.rotationRate_z_sld_median,
                                                      userAcceleration_x_sld_median: input.userAcceleration_x_sld_median,
                                                      userAcceleration_y_sld_median: input.userAcceleration_y_sld_median,
                                                      userAcceleration_z_sld_median: input.userAcceleration_z_sld_median,
                                                      attitude_roll_sld_min: input.attitude_roll_sld_min,
                                                      attitude_pitch_sld_min: input.attitude_pitch_sld_min,
                                                      attitude_yaw_sld_min: input.attitude_yaw_sld_min,
                                                      gravity_x_sld_min: input.gravity_x_sld_min,
                                                      gravity_y_sld_min: input.gravity_y_sld_min,
                                                      gravity_z_sld_min: input.gravity_z_sld_min,
                                                      rotationRate_x_sld_min: input.rotationRate_x_sld_min,
                                                      rotationRate_y_sld_min: input.rotationRate_y_sld_min,
                                                      rotationRate_z_sld_min: input.rotationRate_z_sld_min,
                                                      userAcceleration_x_sld_min: input.userAcceleration_x_sld_min,
                                                      userAcceleration_y_sld_min: input.userAcceleration_y_sld_min,
                                                      userAcceleration_z_sld_min: input.userAcceleration_z_sld_min,
                                                      attitude_roll_sld_max: input.attitude_roll_sld_max,
                                                      attitude_pitch_sld_max: input.attitude_pitch_sld_max,
                                                      attitude_yaw_sld_max: input.attitude_yaw_sld_max,
                                                      gravity_x_sld_max: input.gravity_x_sld_max,
                                                      gravity_y_sld_max: input.gravity_y_sld_max,
                                                      gravity_z_sld_max: input.gravity_z_sld_max,
                                                      rotationRate_x_sld_max: input.rotationRate_x_sld_max,
                                                      rotationRate_y_sld_max: input.rotationRate_y_sld_max,
                                                      rotationRate_z_sld_max: input.rotationRate_z_sld_max,
                                                      userAcceleration_x_sld_max: input.userAcceleration_x_sld_max,
                                                      userAcceleration_y_sld_max: input.userAcceleration_y_sld_max,
                                                      userAcceleration_z_sld_max: input.userAcceleration_z_sld_max,
                                                      attitude_roll_sld_std: input.attitude_roll_sld_std,
                                                      attitude_pitch_sld_std: input.attitude_pitch_sld_std,
                                                      attitude_yaw_sld_std: input.attitude_yaw_sld_std,
                                                      gravity_x_sld_std: input.gravity_x_sld_std,
                                                      gravity_y_sld_std: input.gravity_y_sld_std,
                                                      gravity_z_sld_std: input.gravity_z_sld_std,
                                                      rotationRate_x_sld_std: input.rotationRate_x_sld_std,
                                                      rotationRate_y_sld_std: input.rotationRate_y_sld_std,
                                                      rotationRate_z_sld_std: input.rotationRate_z_sld_std,
                                                      userAcceleration_x_sld_std: input.userAcceleration_x_sld_std,
                                                      userAcceleration_y_sld_std: input.userAcceleration_y_sld_std,
                                                      userAcceleration_z_sld_std: input.userAcceleration_z_sld_std)
                return prediction.classLabel
            } catch let error as NSError {
                print (error)
            }
            return 0
        }
        //        func createTimePointObject(
        //            acceleration: CMAcceleration, attitude: CMAttitude,
        //            gravity: CMAcceleration, rotation: CMRotationRate){
        //            return timePointObject(
        //                acceleration.x,acceleration.y,acceleration.z,
        //                attitude.roll, attitude.pitch, attitude.yaw,
        //                gravity.x, gravity.y, gravity.z,
        //                rotation.x, rotation.y, rotation.z
        //            )
        //        }
        
        //
        //        func predictActivity( ) {
        //
        //        }
        
        func slidingWindowHandler (array: inout [Double], point: Double ) -> Void {
            array.append(point)
            if (array.count > WINDOW_SIZE) {
                array.remove(at: 0)
            }
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
        
        func outputPrediction(res: Int64) {
            predictResult?.text = "\(modelResToString(intRes: res))"
        }
        
        func modelResToString(intRes: Int64) -> String{
            let activities: [Int64: String] = [0: "Walking", 1: "Sitting", 2: "Standing",
                                               3: "Going Upstairs", 4: "Jogging", 5: "Going Downstairs"]
            return activities[intRes]!
        }
        
        // stuff that I haven't deleted yet
        //        motionManager.accelerometerUpdateInterval = 0.1
        //        motionManager.gyroUpdateInterval = 0.1
        //        motionManager.magnetometerUpdateInterval = 0.1
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
        
    }
}

