import Cocoa
import Foundation

class AppDelegate: NSObject, NSApplicationDelegate {
    let script = Bundle.main.path(forResource: "neovide-project", ofType: nil)!
    let logFile = "/tmp/neovide-launcher.log"
    var tasks: [Process] = []
    private var hasHandledURL = false

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

        // Wait a brief moment to see if we get a URL open event
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }

            // Only launch HOME if we haven't handled any URLs
            if !self.hasHandledURL {
                log("No URL events received, running script with HOME")
                self.runScript(FileManager.default.homeDirectoryForCurrentUser.path)
            }
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool)
        -> Bool
    {
        return true
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        log("Received URLs: \(urls)")
        hasHandledURL = true
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
        // Preserve existing PATH and append standard locations
        let existingPath = env["PATH"] ?? ""
        let standardPath = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        env["PATH"] = "\(existingPath):\(standardPath)"
        log("Using PATH: \(env["PATH"] ?? "none")")
        task.environment = env

        // Setup pipe to capture output
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        task.arguments = [path]
        log("Running script with path: \(path)")

        do {
            try task.run()

            // Wait for the script to complete or timeout
            DispatchQueue.global(qos: .background).async {
                task.waitUntilExit()

                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8) {
                    self.log("Script output: \(output)")
                }

                DispatchQueue.main.async {
                    NSApp.terminate(nil)
                }
            }

            // Failsafe timeout
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                NSApp.terminate(nil)
            }
        } catch {
            log("Error launching script: \(error)")
            NSApp.terminate(nil)
        }
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
