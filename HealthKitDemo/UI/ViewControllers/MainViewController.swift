//
//  MainViewController.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 5/24/21.
//

import Foundation
import CareKit
import SwiftUI

class MainViewController: OCKDailyPageViewController {
    
    @Environment(\.storeManager) private var manager

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.title = "Jump to Today"
        
//        navigationItem.rightBarButtonItem =
//            UIBarButtonItem(title: "Care Team", style: .plain, target: self,
//                            action: #selector(presentContactsListViewController))
    }
    

    // This will be called each time the selected date changes.
    // Use this as an opportunity to rebuild the content shown to the user.
    override func dailyPageViewController(_ dailyPageViewController: OCKDailyPageViewController,
                                          prepare listViewController: OCKListViewController, for date: Date) {

        let identifiers = ["diabetes"]
        var query = OCKTaskQuery(for: date)
        query.ids = identifiers
        query.excludesTasksWithNoEvents = true

        storeManager.store.fetchAnyTasks(query: query, callbackQueue: .main) { result in
            switch result {
            case .failure(let error): print("Error: \(error)")
            case .success(let tasks):
                
                // Create a card for the diabetes survey task if there are events for it on this day.
                if tasks.first(where: { $0.id == "diabetes" }) != nil {
                    
                    let surveyCard = SurveyViewController(
                        viewSynchronizer: SurveyViewSynchronizer(),
                        taskID: "diabetes",
                        eventQuery: OCKEventQuery(for: Date()),
                        storeManager: self.manager)
                    
                    listViewController.appendViewController(surveyCard, animated: false)
                } else {
                    print("Couldn't find diabetes task for \(date)")
                }
                
                // Create a plot comparing nausea to medication adherence.
                let surveySeries = OCKDataSeriesConfiguration(
                    taskID: "diabetes",
                    legendTitle: "Survey Answers",
                    gradientStartColor: .systemGray2,
                    gradientEndColor: .systemGray,
                    markerSize: 5,
                    eventAggregator: OCKEventAggregator.countOutcomeValues)

                let insightsCard = OCKCartesianChartViewController(
                    plotType: .bar,
                    selectedDate: date,
                    configurations: [surveySeries],
                    storeManager: self.manager)

                insightsCard.chartView.headerView.titleLabel.text = "How You Felt"
                insightsCard.chartView.headerView.detailLabel.text = "This Week"
                insightsCard.chartView.headerView.accessibilityLabel = "How You Felt, This Week"
                listViewController.appendViewController(insightsCard, animated: false)
            }
        }
    }
}
