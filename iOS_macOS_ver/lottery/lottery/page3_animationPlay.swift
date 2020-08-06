//
//  page3_animationPlay.swift
//  lottery
//
//  Created by wqhqq on 2020/7/29.
//

import SwiftUI

struct page3_animationPlay: View {
    @EnvironmentObject var PrizeData: Prizes
    var timer = Timer.publish(every: 3, on: .current, in: .common).autoconnect()
    @State var showResult: Int? = nil
    @State var size: CGFloat = 1000
    var body: some View {
        NavigationLink(destination: result().environmentObject(PrizeData), tag: 1, selection: $showResult) {
            GIFView(gifName: "video")
                .onReceive(self.timer) {_ in
                    withAnimation {
                        self.showResult = 1
                        self.timer.upstream.connect().cancel()
                    }
            }
        }
        .navigationBarTitle(NSLocalizedString("ING", comment: ""))
        .navigationBarBackButtonHidden(true)
    }
}

struct result: View {
    @EnvironmentObject var PrizeData: Prizes
    @State var showAlert = false
    @State var filePathInput = ""
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                ForEach(self.PrizeData.PrizeList_cacu) { prize in
                    SingleResult(index: prize.id)
                        .environmentObject(self.PrizeData)
                        .frame(height: 80)
                        .animation(.spring())
                }.animation(.spring())
                Spacer()
                Button(action: {
                    self.showAlert = true
                }) {
                    HStack {
                        Text(NSLocalizedString("CPR", comment: ""))
                        Image(systemName: "square.and.arrow.down.fill")
                    }
                }.background(AlertControl(show: self.$showAlert, title: "Save", message: "Input file name."))
            }.padding(.horizontal)
                .animation(.spring())
        }.navigationBarTitle(NSLocalizedString("NBLR", comment: ""))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton_p3().environmentObject(PrizeData))
    }
}

struct backButton_p3: View {
    @State var back: Int? = nil
    @EnvironmentObject var PrizeData: Prizes
    var body: some View {
        NavigationLink(destination: page2_add(PrizeData: PrizeData), tag: 1, selection: $back) {
            HStack {
                Button(action: {
                    self.back = 1
                }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                }
                Text(NSLocalizedString("ADDT", comment: ""))
                    .font(.headline)
            }
        }.transition(.slide)
    }
}

struct AlertControl: UIViewControllerRepresentable {

    @State var textString: String = ""
    @Binding var show: Bool

    var title: String
    var message: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertControl>) -> UIViewController {
        return UIViewController() // holder controller - required to present alert
    }

    func updateUIViewController(_ viewController: UIViewController, context: UIViewControllerRepresentableContext<AlertControl>) {
        guard context.coordinator.alert == nil else { return }
        if self.show {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            context.coordinator.alert = alert

            alert.addTextField { textField in
                textField.placeholder = "Enter some text"
                textField.text = self.textString            // << initial value if any
                textField.delegate = context.coordinator    // << use coordinator as delegate
                textField.font = UIFont(name: "PingFangTC-Regular", size: 20)
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                // your action here
            })
            alert.addAction(UIAlertAction(title: "Save", style: .destructive) { _ in
                if self.textString != "" {
                    var path = ""
                    if #available(iOS 13.0, *) {
                        path = NSHomeDirectory() + "/Documents/\(self.textString).csv"
                    }
                    if #available(OSX 10.15, *)
                    {
                        path = "/Users/Shared/\(self.textString).csv"
                    }
                    try? readyToCopy.write(toFile: path, atomically: true, encoding: .utf8)
                }
            })

            DispatchQueue.main.async { // must be async !!
                viewController.present(alert, animated: true, completion: {
                    self.show = false  // hide holder after alert dismiss
                    context.coordinator.alert = nil
                })
            }
        }
    }

    func makeCoordinator() -> AlertControl.Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var alert: UIAlertController?
        var control: AlertControl
        init(_ control: AlertControl) {
            self.control = control
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text as NSString? {
                self.control.textString = text.replacingCharacters(in: range, with: string)
            } else {
                self.control.textString = ""
            }
            return true
        }
    }
}
