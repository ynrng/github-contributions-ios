//
//  GitHubContributionsViewModel.swift
//  GitHubContributionsWidget
//
//  Created by Ander Goig on 23/10/2020.
//

import Foundation
import NetworkKit

struct GitHubContributionsViewModel {
    private let contributions: [GitHub.Contribution]
    private let configuration: ConfigurationIntent

    var theme: Theme {
        configuration.theme
    }

    var isPureBlackEnabled: Bool {
        configuration.pureBlack?.boolValue ?? false
    }

    var username: String? {
        configuration.username
    }

    var showPlaceholders: Bool {
        contributions.isEmpty
    }

    var topLeadingText: String? {
        username
    }
    
    var topTrailingText: String? {
        decideStrikingText()
    }

    var showError: Bool {
        username != .none && contributions.isEmpty
    }

    var lastContributionDate: Date? {
        contributions.last?.date
    }
    
    func decideStrikingText() -> String? {
        guard let lastContribution = contributions.last else { return NSLocalizedString("striking-fail-text", comment: "")}
        let lastLevel = lastContribution.level
//        return NSLocalizedString("striking-suc-text", comment: "")
//        let lastDate = lastContribution.date
//        let today = Date()
//        if today == lastDate
        return lastLevel.rawValue > 0 ? NSLocalizedString("striking-suc-text", comment: "") :  NSLocalizedString("striking-fail-text", comment: "")
    }

    func contributionLevels(rowsCount: Int, columnsCount: Int) -> [[GitHub.Contribution.Level]] {
        guard let lastDate = lastContributionDate else { return [] }
        let tilesCount = rowsCount * columnsCount - (rowsCount - Calendar.current.component(.weekday, from: lastDate))
        return contributions.suffix(tilesCount).map(\.level).chunked(into: rowsCount)
    }

    init(contributions: [GitHub.Contribution], configuration: ConfigurationIntent) {
        self.contributions = contributions
        self.configuration = configuration
    }
}
