#!/bin/bash
################################
# User Variables               #
################################
VERSION="0.2.0"

################################
# App Variables                #
################################
action=""
version=""
priority="low"
reference_branch=""
target_branch="master"
app_name="${PWD##*/}"
snaps="snaps"
debs="debians"

# manta path
manta_path="$PWD"
manta_release_path="$manta_path/release"
manta_workspace_path="$manta_path/tmp"
manta_src_path="$manta_path/manta"
manta_cfg_path="$manta_src_path/manta.cfg"
manta_changelog_md_path="$manta_path/CHANGELOG.md"
manta_snap_path="$manta_src_path/SNAP"
manta_deb_path="$manta_src_path/DEBIAN"
manta_upstream=()

# changelog
changelogger_script="./scripts/changelogger.bash"

# snapcraft
snap_script="./scripts/snapper.bash"

# deb
deb_script="./scripts/debber.bash"
deb_ppa=""

clean() {
	if [[ "$1" != "" ]]; then
		rm -rf "$1"
	else
		rm -rf "$manta_release_path" "$manta_workspace_path"
	fi
}

base_check() {
	if [[ ! -d "$manta_src_path" ]]; then
		echo "[ ERROR ] - not at repo's base path."
		exit 1
	fi
}

source_cfg() {
	if [[ -f "$manta_cfg_path" ]]; then
		source "$manta_cfg_path"
	fi
}

assemble_files() {
	:
}

prepare() {
	base_check
	export SRC_PATH="$PWD"
	export DEST_PATH="$manta_workspace_path"
	source_cfg
}

completed() {
	unset SRC_PATH
	unset DEST_PATH
}

build_prepare() {
	mkdir -p "$manta_workspace_path"
	mkdir -p "$manta_release_path"
}

build_snap() {
	# prepare
	snap_release_path="${manta_release_path}/${snaps}"
	clean "$manta_workspace_path"
	mkdir -p "$manta_workspace_path"
	cp -r "$manta_snap_path" "${manta_workspace_path}/snap"
	assemble_files

	# compile
	$snap_script -c -w "$manta_workspace_path" -o "$snap_release_path"
}

build_deb() {
	original_dest_path="$DEST_PATH"

	for distribution in ${deb_distributions[@]}; do
		distro="${distribution%%-*}"
		series="${distribution#*-}"
		package="$name-$version"
		deb_workspace_path="$manta_workspace_path/$package"
		deb_release_path="${manta_release_path}/${debs}/${series}"
		DEST_PATH="$deb_workspace_path"

		# prepare
		clean "$manta_workspace_path"
		mkdir -p "$deb_workspace_path"
		cp -r "$manta_deb_path" "${deb_workspace_path}/debian"
		$changelogger_script -s "${deb_workspace_path}/debian" \
				     -k "DISTSERIES=$series" \
				     -k "DISTTAG=$distro"

		# compile
		assemble_files
		$deb_script -c  --workspace-path "$deb_workspace_path" \
				--output "$deb_release_path" \
				--gpg "$gpg_id"

		ls "$deb_workspace_path" \
			| grep -v "debian" \
			| xargs -I{} rm -rf "$deb_workspace_path/{}"

		assemble_files
		$deb_script -c  --workspace-path "$deb_workspace_path" \
				--output "$deb_release_path" \
				--gpg "$gpg_id" \
				--source-only
	done

	DEST_PATH="$original_dest_path"
	unset original_dest_path
}

build() {
	prepare
	build_prepare

	if [[ -d "$manta_snap_path" ]]; then
		build_snap
	fi

	if [[ -d "$manta_deb_path" ]]; then
		build_deb
	fi

	completed
}

upstream_prepare() {
	if [[ "${#manta_upstream[@]}" == "0" ]]; then
		exit 1
	fi

	if [[ ! -d "$manta_release_path" ]]; then
		echo "[ ERROR ] invalid release path."
		exit 1
	fi

	snap_release_path="${manta_release_path}/${snaps}"
	deb_release_path="${manta_release_path}/${debs}"
}

upstream_snap() {
	spins=($(ls "$snap_release_path" | grep ".snap"))
	for spin in "${spins[@]}"; do
		$snap_script -u "$snap_release_path/$spin"
	done
}

upstream_deb() {
	if [[ "$deb_ppa" == "" ]]; then
		echo "[ ERROR ] missing deb ppa for upstream."
		return 1
	fi

	series=($(ls "$deb_release_path"))

	for series in "${series[@]}"; do
		series_path="${deb_release_path}/${series}"
		changes_path="$(ls "$series_path" | grep "source.changes")"
		changes_path="${series_path}/${changes_path}"

		if [[ ! -f "$changes_path" ]]; then
			echo "\
[ INFO ] missing source.changes for ${debs}/${series}."
			continue
		fi

		$deb_script -u "$changes_path" -ppa "$deb_ppa"
	done
}

upstream() {
	prepare
	upstream_prepare
	for package in "${manta_upstream[@]}"; do
		case "$package" in
		"$snaps")
			upstream_snap
			;;
		"$debs")
			upstream_deb
			;;
		*)
			;;
		esac
	done
	completed
}

release_changelog() {
	$changelogger_script \
		--update "$version" \
		--reference "$reference_branch" \
		--target "$target_branch" \
		--priority "$priority" \
		--markdown "$manta_changelog_md_path" \
		--debian "$manta_deb_path"
}

release_snap() {
	$snap_script \
		--update-version "$version" \
		--snap "$manta_snap_path"
}

release_deb() {
	$deb_script \
		--update-version "$version" \
		--debian "$manta_deb_path"
}

release() {
	prepare
	release_changelog
	release_snap
	release_deb
	completed
}

print_version() {
	echo "$VERSION"
}

print_help() {
	echo "\
MANTA
The one script that builds and release this software semi-automatically.
-------------------------------------------------------------------------------
To use: $0 [ACTION] [ARGUMENTS]

ACTIONS
1. -h, --help			print help. Longest help is up
				to this length for terminal
				friendly printout.

2. -v, --version		print app version.

3. -r, --release		prepare relaeses documentations.
				COMPULSORY ARGUMENTS:
				1. -ref, --reference [reference branch name]
				   git branch name containing the latest.
				   e.g. -r 1.0.1 -ref next

				OPTIONAL ARGUMENTS:
				1. -p, --priority [low/medium/high]
				   either 'low, 'medium', or 'high'. Default
				   is low.
				   e.g. -r 1.0.1 -p high

				2. -tgt, --target [target branch name]
				   git branch name for merging changes. Default
				   is master.
				   e.g. -r 1.0.1 -tgt master

				EXAMPLES:
				1. $ manta -r 1.0.1 -ref next
				2. $ manta -r 1.0.1 -ref next -p high
				3. $ manta -r 1.0.1 \\
					-ref next \\
					-tgt master \\
					-p high

4. -b, --build			build the software packages.

5. -u, --upstream		upstream program to distributions.
				OPTIONAL VALUES:
				1. -u [path to results]
				   path to the results folder containing all
				   the compiled packages. Manta will proceed
				   to identify each vendor and upstream them
				   accordingly.

				OPTIONAL ARGUMENTS:
				1. -deb, --debian [PPA URL]
				   Ubuntu Launchpad PPA URL. This is to upload
				   all debian source.changes into the Ubuntu
				   launchpad.
				   e.g. -u -deb ppa:name/repo

				2. -snap, --snapcraft
				   Snapcraft upload. This is to upload all
				   .snap packages to Snapcraft.io.
				   e.g. -u -snap

6. -c, --clean			clean up workspace.
"
}

run_action() {
case "$action" in
"r")
	release
	;;
"b")
	build
	;;
"u")
	upstream
	;;
"c")
	clean
	;;
"h")
	print_help
	;;
"v")
	print_version
	;;
*)
	echo "[ ERROR ] - invalid command."
	return 1
	;;
esac
}

process_parameters() {
while [[ $# != 0 ]]; do
case "$1" in
-r|--release)
	action="r"
	if [[ "$2" != "" ]]; then
		version="$2"
		shift 1
	fi
	shift 1
	;;
-p|--priority)
	if [[ "$2" != "" ]]; then
		priority="$2"
		shift 1
	fi
	shift 1
	;;
-ref|--reference)
	if [[ "$2" != "" ]]; then
		reference_branch="$2"
		shift 1
	fi
	shift 1
	;;
-tgt|--target)
	if [[ "$2" != "" ]]; then
		target_branch="$2"
		shift 1
	fi
	shift 1
	;;
-b|--build)
	action="b"
	shift 1
	;;
-u|--upstream)
	action="u"
	if [[ "$2" != "" && "${2:0:1}" != "-" ]]; then
		manta_release_path="$2"
		shift 1
	fi
	shift 1
	;;
-deb|--debian)
	manta_upstream+=("$debs")
	if [[ "$2" != "" && "${2:0:1}" != "-" ]]; then
		deb_ppa="$2"
		shift 1
	fi
	shift 1
	;;
-snap|--snapcraft)
	manta_upstream+=("$snaps")
	shift 1
	;;
-c|--clean)
	action="c"
	shift 1
	;;
-h|--help)
	action="h"
	shift 1
	;;
-v|--version)
	action="v"
	shift 1
	;;
*)
	shift 1
	;;
esac
done
}

main() {
	process_parameters $@
	if [[ $? != 0 ]]; then
		exit 1
	fi

	run_action
	if [[ $? != 0 ]]; then
		exit 1
	fi
}

if [[ $BASHELL_TEST_ENVIRONMENT != true ]]; then
	main $@
fi
