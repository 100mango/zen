

//
//import Darwin
//
////let arguments: [String] = Array(CommandLine.arguments.dropFirst())
////
////guard let numberString = arguments.first else {
////    print("no argument")
////    exit(1)
////}
////
////guard let number = UInt(numberString) else {
////    print("no unsigned number")
////    exit(1)
////}
////
////print(UInt.random(in: 0...number))
////exit(0)
//
//import ArgumentParser
//
//struct Random: ParsableCommand {
//    @Argument(help: "unsigned number")
//    var highValue: UInt
//
//    func run() {
//        print(UInt.random(in: 0...highValue))
//    }
//}
//
//Random.main()

//import AppKit
//
//NSApplication.shared.setActivationPolicy(.accessory)
//
//func selectFile() -> URL? {
//    let dialog = NSOpenPanel()
//    dialog.allowedFileTypes = ["jpg", "png"]
//    guard dialog.runModal() == .OK else { return nil }
//    return dialog.url
//}
//
//print (selectFile()?.absoluteString ?? "")

import SwiftUI

struct App: SwiftUI.App {
    @State var filename = "Filename"
    @State var showFileChooser = false

  var body: some Scene {
    WindowGroup {
        HStack {
              Text(filename)
              Button ("select File")
              {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                if panel.runModal() == .OK {
                    self.filename = panel.url?.lastPathComponent ?? "<none>"
                }
              }
            }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .windowStyle(HiddenTitleBarWindowStyle())
  }
}
App.main()
