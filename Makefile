help:
	@echo "---------------HELP-----------------"
	@echo "clean: Clean the workspace"
	@echo "generate: Run code generation"
	@echo "run-linux: Run the linux app (debug)"
	@echo "run-chrome: Run the chrome app (debug)"
	@echo "release: Build release binaries"
	@echo "------------------------------------"

clean:
	flutter clean

run-linux:
	flutter run -d linux

run-chrome:
# Clean the workspace, if the app was run in desktop 
# mode before, web won't work without a cleanup
	flutter clean
	flutter run -d chrome

generate:
	flutter packages pub run build_runner build --delete-conflicting-outputs


release:
	flutter clean
	flutter packages get
	flutter packages pub run build_runner build --delete-conflicting-outputs
	flutter build web --release --base-href '/fluestr-canvas/'
	flutter build apk --split-per-abi
	flutter build linux --release

