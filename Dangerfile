warn("Big PR, try to keep changes smaller if you can") if git.lines_of_code > 500

xcode_summary.ignored_files = 'Pods/**'
xcode_summary.inline_mode = true
xcode_summary.report 'xcodebuild.json'

swiftlint.config_file = '.swiftlint.yml'
swiftlint.max_num_violations = 20
swiftlint.lint_files fail_on_error: true
swiftlint.lint_files inline_mode: true
swiftlint.lint_files
