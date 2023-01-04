build_runner:
	@echo "Building..."
	flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs
	@echo "Done."

new_icons:
	flutter pub get && flutter pub run flutter_launcher_icons:main 

upgrade_all_dep: 
	flutterfire update && flutter pub upgrade --major-versions

lint_fix:
	dart fix --apply

lint:
	dart analyze && dart fix --dry-run

test:
	flutter test

# Path: makefile