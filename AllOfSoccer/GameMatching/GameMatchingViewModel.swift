//
//  GameMatchingViewModel.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2022/01/09.
//

import Foundation

enum MatchingMode {
    case teamMatching
    case manMatching
}

enum CollecionviewType: String {
    case HorizontalCalendarView
    case FilterTagCollectionView
}

enum FilterType: CaseIterable {
    case location
    case game

    var tagTitle: String {
        switch self {
        case .location: return "장소"
        case .game: return "경기 종류"
        }
    }

    var filterList: [String] {
        switch self {
        case .location: return ["서울", "경기-북부", "경기-남부", "인천/부천", "기타지역"]
        case .game: return ["11 vs 11", "풋살"]
        }
    }
}

protocol GameMatchingPresenter: AnyObject {
    func reloadMatchingList()
    func showErrorMessage()
}

class GameMatchingViewModel {

    internal weak var presenter: GameMatchingPresenter?

    //중현: 생성하는 시점에 viewModel을 fetch
    init() {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                try await self.fetchMatchingList()
                self.presenter?.reloadMatchingList()
            } catch {
                self.presenter?.showErrorMessage()
            }
        }
    }

    private func fetchMatchingList() async throws {
        self.matchingListViewModel = [GameMatchListViewModel.mockData,
                                      GameMatchListViewModel.mockData1,
                                      GameMatchListViewModel.mockData2]
    }

    // MARK: - Properties
    internal private(set) var selectedDate: [Date] = []

    internal var count: Int {
        self.matchingListViewModel.count
    }

    internal func fetchViewModel(indexPath: IndexPath) -> GameMatchListViewModel {
        self.matchingListViewModel[indexPath.row]
    }

    private var matchingListViewModel: [GameMatchListViewModel] = []

    internal var formalStrSelectedDate: [String] {
        let strSelectedDate = self.selectedDate.map { self.changeDateToString($0) }
        return strSelectedDate
    }

    // MARK: - Function
    internal func append(_ dates: [Date], _ date: Date?) {

        if let date = date {
            self.selectedDate.append(date)
        } else {
            self.selectedDate = dates
        }
    }

    internal func delete(_ date: Date) {
        let deselectedDateStr = self.changeDateToString(date)

        let selectedDateArry = self.selectedDate.map { $0.changedSringFromDate }

        guard let indexOfDate = selectedDateArry.firstIndex(of: deselectedDateStr) else { return }
        self.selectedDate.remove(at: indexOfDate)
    }
}

extension GameMatchingViewModel {
    private func changeDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")

        let changedSelectedDate = dateFormatter.string(from: date)

        return changedSelectedDate
    }
}
