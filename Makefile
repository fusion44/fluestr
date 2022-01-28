help:
	@echo "---------------HELP-----------------"
	@echo "clean: Clean the workspace"
	@echo "generate: Run code generation"
	@echo "run-linux: Run the linux app (debug)"
	@echo "run-chrome: Run the chrome app (debug)"
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


