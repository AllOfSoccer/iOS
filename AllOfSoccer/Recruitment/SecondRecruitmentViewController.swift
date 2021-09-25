import UIKit
import RangeSeekSlider

class SecondRecruitmentViewController: UIViewController {

    private var tableViewModel: [Comment] = []
    private var introductionDetailView = IntroductionDetailView()

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()

    @IBOutlet private weak var skillSlider: SkillSlider!
    @IBOutlet private weak var ageRangeSlider: RangeSeekSlider!
    @IBOutlet private var ageSliderLabels: [UILabel]!
    @IBOutlet private var skillSliderLabels: [UILabel]!
    @IBOutlet private weak var introductionTableView: IntrinsicTableView!
    @IBOutlet private weak var informationCheckButton: UIButton!

    @IBAction private func addIntroductionButton(_ sender: RoundButton) {

        self.introductionDetailView.clearView()
        
        guard let navigationController = self.navigationController else { return }
        navigationController.view.addSubview(self.backgroundView)
        self.backgroundView.addSubview(self.introductionDetailView)

        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.introductionDetailView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.backgroundView.topAnchor.constraint(equalTo: navigationController.view.topAnchor, constant: 0),
            self.backgroundView.bottomAnchor.constraint(equalTo: navigationController.view.bottomAnchor, constant: 0),
            self.backgroundView.leadingAnchor.constraint(equalTo: navigationController.view.leadingAnchor, constant: 0),
            self.backgroundView.trailingAnchor.constraint(equalTo: navigationController.view.trailingAnchor, constant: 0),

            self.introductionDetailView.topAnchor.constraint(equalTo: self.backgroundView.topAnchor, constant: 257),
            self.introductionDetailView.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor, constant: -258),
            self.introductionDetailView.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor, constant: 20),
            self.introductionDetailView.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor, constant: -20)
        ])
    }

    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setSkillSlider()
        setIntroductionTableView()
        setIntroductionDetailView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setAgeLabelsLayout()
        setSkillLabelsLayout()
    }


    private func setSkillSlider() {
        self.skillSlider.addTarget(self, action: #selector(skillSliderValueChanged), for: .valueChanged)
    }

    private func setIntroductionTableView() {

        self.introductionTableView.delegate = self
        self.introductionTableView.dataSource = self
    }

    private func setIntroductionDetailView() {

        self.introductionDetailView.delegate = self
    }

    private func setAgeLabelsLayout() {
        let labelPositions =  createLabelXPositions(slider: self.ageRangeSlider)
        setLabelsConstraint(slider: self.ageRangeSlider, labels: self.ageSliderLabels, labelXPositons: labelPositions)
    }

    private func setSkillLabelsLayout() {
        let labelPositions =  createLabelXPositions(slider: self.skillSlider)
        self.setLabelsConstraint(slider: self.skillSlider, labels: self.skillSliderLabels, labelXPositons: labelPositions)
    }

    private func setLabelsConstraint(slider: UIControl ,labels: [UILabel], labelXPositons: [CGFloat]) {
        for index in 0...6 {
            labels[index].translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                labels[index].topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 4),
                labels[index].centerXAnchor.constraint(equalTo: slider.leadingAnchor, constant: labelXPositons[index])
            ])
        }
    }

    private func createLabelXPositions(slider: UIView) -> [CGFloat] {
        let rangeSliderLinePadding: CGFloat = slider == self.ageRangeSlider ? 16 : 0
        let rangeSliderLineWidth = slider.frame.width - (2 * rangeSliderLinePadding)
        let division: CGFloat = 6
        let offset = rangeSliderLineWidth / division
        let firstLabelXPosition = rangeSliderLinePadding

        var arrayLabelXPosition: [CGFloat] = []
        arrayLabelXPosition.append(firstLabelXPosition)
        for index in 1..<7 {
            let offset = (offset * CGFloat(index))
            let labelXPosition = firstLabelXPosition + offset
            arrayLabelXPosition.append(labelXPosition)
        }

        return arrayLabelXPosition
    }

    @objc func skillSliderValueChanged(_ sender: SkillSlider) {
        let values = "(\(sender.value)"
        print("Range slider value changed: \(values)")
    }
}

extension SecondRecruitmentViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // 왼쪽 편집 버튼 안보이게 하고싶을때 false
        return false
    }

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
        // 왼쪽 편집 버튼 안보이게 하고싶을때 .None
        return .none
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.tableViewModel[sourceIndexPath.row]
        self.tableViewModel.remove(at: sourceIndexPath.row)
        self.tableViewModel.insert(movedObject, at: destinationIndexPath.row)
        self.introductionTableView.isEditing = false
        self.introductionTableView.reloadData()
    }
}

extension SecondRecruitmentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IntroductionTableViewCell", for: indexPath) as? IntroductionTableViewCell else {
            return UITableViewCell()
        }

        guard let model = self.tableViewModel[safe: indexPath.row] else { return UITableViewCell() }

        cell.configure(model)
        cell.delegate = self

        return cell
    }
}

extension SecondRecruitmentViewController: IntroductionTableViewCellDelegate {
    func updownButtonDidSelected(_ tableviewCell: IntroductionTableViewCell) {
        self.introductionTableView.isEditing = true
    }

    func removeButtonDidSeleced(_ tableviewCell: IntroductionTableViewCell) {
        self.tableViewModel.removeLast()
        self.introductionTableView.reloadData()
    }
}

extension SecondRecruitmentViewController: IntroductionDetailViewDelegate {
    func cancelButtonDidSelected(_ view: IntroductionDetailView) {

        self.introductionDetailView.removeFromSuperview()
        self.backgroundView.removeFromSuperview()
    }

    func OKButtonDidSelected(_ view: IntroductionDetailView, _ model: [Comment]) {

        DispatchQueue.main.async {
            self.tableViewModel = model
            self.introductionTableView.reloadData()
        }

        self.introductionDetailView.removeFromSuperview()
        self.backgroundView.removeFromSuperview()
    }
}
