/* Workflow:
 1) Receive the session's predictions from the "Recording" window
 2) Smooth predicitions array using majority vote
 3) Create and display graph of the session activity
 */

import UIKit

import Charts

var MAJORITY_VOTE_WINDOW = 5

class summaryViewController: UIViewController {
    @IBAction func startOverButton(_ sender: Any) {
        performSegue(withIdentifier: "startOver", sender: self)
    }
    var predictionsArray: [Int8] = []
    var finalPredictionsArray: [Int8] = []
    
    @IBOutlet var myText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // creating final predictions using majority voter
        majorityVoter()
        // calculating the length of each activity
        let activies = activityAmountCalc()
        // creating a chart displaying the activities
        setupPieChart()
        fillChart(arr: activies)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // calculating what is the mode of an array and how many times does it appear
    func mostFrequent<T: Hashable>(array: [T]) -> (value: T, count: Int)? {
        
        let counts = array.reduce(into: [:]) { $0[$1, default: 0] += 1 }
        
        if let (value, count) = counts.max(by: { $0.1 < $1.1 }) {
            return (value, count)
        }
        
        // array was empty
        return nil
    }

    func majorityVoter () {
        // Smoothing the predictions using a majority vote
        let predictionsArrayLength = self.predictionsArray.count
        
        if (predictionsArrayLength <= MAJORITY_VOTE_WINDOW) {
            // nothing to smooth here
            self.finalPredictionsArray = self.predictionsArray
            return
        }
        for i in 0..<(predictionsArrayLength - MAJORITY_VOTE_WINDOW) {
            let subArrayForSmoothing = Array(self.predictionsArray[i..<(i + MAJORITY_VOTE_WINDOW)])
            
            // checking the mode of the subarray and how many times does he appears
            let majorityVote = mostFrequent(array: subArrayForSmoothing)
            
            if (Double((majorityVote?.count)!) >= (0.4*Double(MAJORITY_VOTE_WINDOW))){
                // appending the majority vote if a certain value is the mode for at least 40% of the values
                self.finalPredictionsArray.append((majorityVote?.value)!)
            } else {
                // appending the original prediction
                self.finalPredictionsArray.append(self.predictionsArray[i])
            }
        }
        for i in (predictionsArrayLength - MAJORITY_VOTE_WINDOW)..<predictionsArrayLength{
            // appending the remaining values
            self.finalPredictionsArray.append(self.predictionsArray[i])
        }
    }

    // calculate amount of each activity
    
    func activityAmountCalc () -> [String: Double]{
        let total = self.finalPredictionsArray.count

        var walkingCnt = 0
        var sittingCnt = 0
        var standingCnt = 0
        var stairsCnt = 0
        var joggingCnt = 0
        
        for item in self.finalPredictionsArray{
            switch(item) {
                case (0):
                    walkingCnt += 1
                case (1):
                    sittingCnt += 1
                case (2):
                    standingCnt += 1
                case (3):
                    stairsCnt += 1
                case (4):
                    joggingCnt += 1
            default:
                ()
            }
        }
        let walkingKeyname:String = "Walking " + String(Double(walkingCnt) / Double(10)) + "\n Seconds"
        let sittingKeyname:String = "Sitting " + String(Double(sittingCnt) / Double(10)) + "\n Seconds"
        let standingKeyname:String = "Standing " + String(Double(standingCnt) / Double(10)) + "\n Seconds"
        let stairsKeyname:String = "Using stairs " + String(Double(stairsCnt) / Double(10)) + "\n Seconds"
        let joggingKeyname:String = "Jogging " + String(Double(joggingCnt) / Double(10)) + "\n Seconds"

        let activities: [String: Double] = [walkingKeyname:(Double(walkingCnt) / Double(total))*100,
                                            sittingKeyname: (Double(sittingCnt) / Double(total))*100,
                                            standingKeyname: (Double(standingCnt) / Double(total))*100,
                                            stairsKeyname: (Double(stairsCnt) / Double(total))*100,
                                            joggingKeyname: (Double(joggingCnt) / Double(total))*100]
        return activities
        
    }
    
    // chart functions
    
    lazy var pieChart: PieChartView = {
        let p = PieChartView()
        p.translatesAutoresizingMaskIntoConstraints = false
        p.noDataText = "No date to display"
        p.legend.enabled = false
        p.chartDescription?.text = ""
        p.drawHoleEnabled = false
        p.delegate = self as? ChartViewDelegate
        return p
    }()
    
    func setupPieChart() {
        view.addSubview(pieChart)
        pieChart.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        pieChart.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        pieChart.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        pieChart.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func fillChart(arr: [String: Double]) {
        var dataEntries = [PieChartDataEntry]()
        for (key, val) in arr {
            let percent = Double(val) / 100.0
            if (percent > 0){
                let entry = PieChartDataEntry(value: percent, label: key)
                dataEntries.append(entry)
            }
        }
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = ChartColorTemplates.material()
        chartDataSet.sliceSpace = 1
        chartDataSet.selectionShift = 5
        
        let chartData = PieChartData(dataSet: chartDataSet)
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        chartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        pieChart.data = chartData
    }
    
}
