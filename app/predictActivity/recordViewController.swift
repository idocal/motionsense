import UIKit
import CoreMotion


var WINDOW_SIZE = 20

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

class Session {
 // All the data regarding a single session
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
    
    var predictionsArray: [Int8] = []
 
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
}

class recordViewController: UIViewController {
    
    @IBAction func stopRecording(_ sender: Any) {
        performSegue(withIdentifier: "stopRecording", sender: self)
    }
    var currentSession = Session()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : summaryViewController = segue.destination as! summaryViewController
        destVC.predictionsArray = self.currentSession.predictionsArray
    }
    
    var motionManager = CMMotionManager()
    
    @IBOutlet var predictResult: UILabel!
    
    // Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Motion manager properties
        
        motionManager.deviceMotionUpdateInterval = 0.1

        // initiallize session
//        currentSession = Session()

        // start recording
        
        // stop button clicked
            // finish session
            // smooth predicitions array
            // create graph of the session
        
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
        
            self.currentSession.predictionsArray.append(Int8(prediction))
            
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
            slidingWindowHandler(array: &currentSession.userAccXArray, point: acceleration.x)
            slidingWindowHandler(array: &currentSession.userAccYArray, point: acceleration.y)
            slidingWindowHandler(array: &currentSession.userAccZArray, point: acceleration.z)
            
            slidingWindowHandler(array: &currentSession.attitudeRollArray, point: attitude.roll)
            slidingWindowHandler(array: &currentSession.attitudePitchArray, point: attitude.pitch)
            slidingWindowHandler(array: &currentSession.attitudeYawArray, point: attitude.yaw)
            
            slidingWindowHandler(array: &currentSession.gravityXArray, point: gravity.x)
            slidingWindowHandler(array: &currentSession.gravityYArray, point: gravity.y)
            slidingWindowHandler(array: &currentSession.gravityZArray, point: gravity.z)
            
            
            slidingWindowHandler(array: &currentSession.rotXArray, point: rotation.x)
            slidingWindowHandler(array: &currentSession.rotYArray, point: rotation.y)
            slidingWindowHandler(array: &currentSession.rotZArray, point: rotation.z)
            
        }
        
        func createPredictInputsObject () -> predictInputsObject {
//        func createPredictInputsObject () -> Int64 {
        
            let attitude_roll_sld_mean = currentSession.attitudeRollArray.avg()
            let attitude_pitch_sld_mean = currentSession.attitudePitchArray.avg()
            let attitude_yaw_sld_mean = currentSession.attitudeYawArray.avg()
            let gravity_x_sld_mean = currentSession.gravityXArray.avg()
            let gravity_y_sld_mean = currentSession.gravityYArray.avg()
            let gravity_z_sld_mean = currentSession.gravityZArray.avg()
            let rotationRate_x_sld_mean = currentSession.rotXArray.avg()
            let rotationRate_y_sld_mean = currentSession.rotYArray.avg()
            let rotationRate_z_sld_mean = currentSession.rotZArray.avg()
            let userAcceleration_x_sld_mean = currentSession.userAccXArray.avg()
            let userAcceleration_y_sld_mean = currentSession.userAccYArray.avg()
            let userAcceleration_z_sld_mean = currentSession.userAccZArray.avg()
            let attitude_roll_sld_sum = currentSession.attitudeRollArray.sum()
            let attitude_pitch_sld_sum = currentSession.attitudePitchArray.sum()
            let attitude_yaw_sld_sum = currentSession.attitudeYawArray.sum()
            let gravity_x_sld_sum = currentSession.gravityXArray.sum()
            let gravity_y_sld_sum = currentSession.gravityYArray.sum()
            let gravity_z_sld_sum = currentSession.gravityZArray.sum()
            let rotationRate_x_sld_sum = currentSession.rotXArray.sum()
            let rotationRate_y_sld_sum = currentSession.rotYArray.sum()
            let rotationRate_z_sld_sum = currentSession.rotZArray.sum()
            let userAcceleration_x_sld_sum = currentSession.userAccXArray.sum()
            let userAcceleration_y_sld_sum = currentSession.userAccYArray.sum()
            let userAcceleration_z_sld_sum = currentSession.userAccZArray.sum()
            let attitude_roll_sld_median = calcMedian(array: currentSession.attitudeRollArray)
            let attitude_pitch_sld_median = calcMedian(array: currentSession.attitudePitchArray)
            let attitude_yaw_sld_median = calcMedian(array: currentSession.attitudeYawArray)
            let gravity_x_sld_median = calcMedian(array: currentSession.gravityXArray)
            let gravity_y_sld_median = calcMedian(array: currentSession.gravityYArray)
            let gravity_z_sld_median = calcMedian(array: currentSession.gravityZArray)
            let rotationRate_x_sld_median = calcMedian(array: currentSession.rotXArray)
            let rotationRate_y_sld_median = calcMedian(array: currentSession.rotYArray)
            let rotationRate_z_sld_median = calcMedian(array: currentSession.rotZArray)
            let userAcceleration_x_sld_median = calcMedian(array: currentSession.userAccXArray)
            let userAcceleration_y_sld_median = calcMedian(array: currentSession.userAccYArray)
            let userAcceleration_z_sld_median = calcMedian(array: currentSession.userAccZArray)
            let attitude_roll_sld_min = currentSession.attitudeRollArray.min()
            let attitude_pitch_sld_min = currentSession.attitudePitchArray.min()
            let attitude_yaw_sld_min = currentSession.attitudeYawArray.min()
            let gravity_x_sld_min = currentSession.gravityXArray.min()
            let gravity_y_sld_min = currentSession.gravityYArray.min()
            let gravity_z_sld_min = currentSession.gravityZArray.min()
            let rotationRate_x_sld_min = currentSession.rotXArray.min()
            let rotationRate_y_sld_min = currentSession.rotYArray.min()
            let rotationRate_z_sld_min = currentSession.rotZArray.min()
            let userAcceleration_x_sld_min = currentSession.userAccXArray.min()
            let userAcceleration_y_sld_min = currentSession.userAccYArray.min()
            let userAcceleration_z_sld_min = currentSession.userAccZArray.min()
            let attitude_roll_sld_max = currentSession.attitudeRollArray.max()
            let attitude_pitch_sld_max = currentSession.attitudePitchArray.max()
            let attitude_yaw_sld_max = currentSession.attitudeYawArray.max()
            let gravity_x_sld_max = currentSession.gravityXArray.max()
            let gravity_y_sld_max = currentSession.gravityYArray.max()
            let gravity_z_sld_max = currentSession.gravityZArray.max()
            let rotationRate_x_sld_max = currentSession.rotXArray.max()
            let rotationRate_y_sld_max = currentSession.rotYArray.max()
            let rotationRate_z_sld_max = currentSession.rotZArray.max()
            let userAcceleration_x_sld_max = currentSession.userAccXArray.max()
            let userAcceleration_y_sld_max = currentSession.userAccYArray.max()
            let userAcceleration_z_sld_max = currentSession.userAccZArray.max()
            let attitude_roll_sld_std = currentSession.attitudeRollArray.std()
            let attitude_pitch_sld_std = currentSession.attitudePitchArray.std()
            let attitude_yaw_sld_std = currentSession.attitudeYawArray.std()
            let gravity_x_sld_std = currentSession.gravityXArray.std()
            let gravity_y_sld_std = currentSession.gravityYArray.std()
            let gravity_z_sld_std = currentSession.gravityZArray.std()
            let rotationRate_x_sld_std = currentSession.rotXArray.std()
            let rotationRate_y_sld_std = currentSession.rotYArray.std()
            let rotationRate_z_sld_std = currentSession.rotZArray.std()
            let userAcceleration_x_sld_std = currentSession.userAccXArray.std()
            let userAcceleration_y_sld_std = currentSession.userAccYArray.std()
            let userAcceleration_z_sld_std = currentSession.userAccZArray.std()
            
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
            currentSession.userAccX?.text = "\(acceleration.x).2fg"
            currentSession.userAccY?.text = "\(acceleration.y).2fg"
            currentSession.userAccZ?.text = "\(acceleration.z).2fg"
        }
        
        func outputAttitudeData(attitude: CMAttitude) {
            currentSession.attitudeRoll?.text = "\(attitude.roll).2fr/s"
            currentSession.attitudePitch?.text = "\(attitude.pitch).2fr/s"
            currentSession.attitudeYaw?.text = "\(attitude.yaw).2fr/s"
        }
        // todo check the difference between gravity and acceleration
        func outputGravityData(gravity: CMAcceleration) {
            currentSession.gravityX?.text = "\(gravity.x).2fr/s"
            currentSession.gravityY?.text = "\(gravity.y).2fr/s"
            currentSession.gravityZ?.text = "\(gravity.z).2fr/s"
        }
        
        func outputRotationData(rotation: CMRotationRate) {
            currentSession.rotX?.text = "\(rotation.x).2fr/s"
            currentSession.rotY?.text = "\(rotation.y).2fr/s"
            currentSession.rotZ?.text = "\(rotation.z).2fr/s"
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

