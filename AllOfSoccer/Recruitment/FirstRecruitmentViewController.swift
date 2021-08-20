//
//  RecruitmentViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/08/10.
//

import UIKit

class FirstRecruitmentViewController: UIViewController {

    @IBOutlet private weak var recruitmentTableView: UITableView!
    @IBOutlet private weak var addTeamButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.recruitmentTableView.delegate = self
        self.recruitmentTableView.dataSource = self
        self.recruitmentTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
}

extension FirstRecruitmentViewController: UITableViewDelegate {

}

extension FirstRecruitmentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecruitmentTableViewCell", for: indexPath) as? RecruitmentTableViewCell else { return UITableViewCell() }

        return cell
    }
}
