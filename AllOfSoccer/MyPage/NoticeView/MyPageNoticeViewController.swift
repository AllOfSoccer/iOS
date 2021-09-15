//
//  NoticeViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/09/15.
//

import UIKit

class MyPageNoticeViewController: UIViewController {

    @IBOutlet private weak var NoticeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.NoticeTableView.delegate = self
        self.NoticeTableView.dataSource = self
    }
}

extension MyPageNoticeViewController: UITableViewDelegate {

}

extension MyPageNoticeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell", for: indexPath) as? MyPageTableViewCell else {
            return UITableViewCell()
        }

        return cell
    }


}
