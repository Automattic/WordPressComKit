import Foundation

public struct StatsVisits {
    /// How much time this summary represents
    public let unit: StatsPeriodUnit
    /// End date of the period of time this summary represents
    public let date: NSDate
    
    public let summaryData: [StatsSummary]
    public let summaryDataByDate: [NSDate: StatsSummary]
}