import Cocoa
import Foundation

class AppDelegate: NSObject, NSApplicationDelegate {
    let script = Bundle.main.path(forResource: "neovide-project", ofType: nil)!
    let logFile = "/tmp/neovide-launcher.log"
    var tasks: [Process] = []

    func log(_ message: String) {
        let timestamp = DateFormatter.localizedString(
            from: Date(), dateStyle: .none, timeStyle: .medium)
        let logMessage = "[\(timestamp)] \(message)\n"
        if let data = logMessage.data(using: .utf8) {
            if let handle = try? FileHandle(forWritingTo: URL(fileURLWithPath: logFile)) {
                handle.seekToEndOfFile()
                handle.write(data)
                handle.closeFile()
            } else {
                try? logMessage.write(toFile: logFile, atomically: true, encoding: .utf8)
            }
        }
    }

    func applicationWillFinishLaunching(_ notification: Notification) {
        // Make app completely invisible
        NSApp.setActivationPolicy(.prohibited)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        log("App launched with args: \(CommandLine.arguments)")
        if CommandLine.arguments.count <= 1 {
            log("No arguments, running script with HOME")
            runScript(FileManager.default.homeDirectoryForCurrentUser.path)
        }
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        log("Received URLs: \(urls)")
        for url in urls {
            handlePath(url.path)
        }
    }

    func handlePath(_ path: String) {
        log("Handling path: \(path)")
        // Convert to absolute path
        let absolutePath = (path as NSString).standardizingPath
        log("Absolute path: \(absolutePath)")
        runScript(absolutePath)
    }

    func runScript(_ path: String) {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: script)

        var env = ProcessInfo.processInfo.environment
        env["PATH"] = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        task.environment = env

        task.arguments = [path]
        log("Running script with path: \(path)")

        do {
            try task.run()
            tasks.append(task)
            tasks = tasks.filter { !$0.isRunning }
        } catch {
            log("Error launching script: \(error)")
        }
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
