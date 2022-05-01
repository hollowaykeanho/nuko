#!/bin/bash
################################
# User Variables               #
################################
VERSION="0.2.0"

################################
# App Variables                #
################################
action=""
deb_path=""
workspace_path=""
output_path=""
gpg_id=""
compiler="debuild"
gpg_compile=true
source_only=false
app_name=""
app_output_path=""
debpath=""
ppa=""

print_version() {
	echo $VERSION
}

update_version() {
	if [[ "$version" == "" ]]; then
		echo "[ ERROR ] missing version number."
		exit 1
	fi

	if [[ ! -d "$deb_path" ]]; then
		echo "[ ERROR ] missing debian folder."
		exit 1
	fi
	control_path="${deb_path}/control"

	if [[ ! -f "$control_path" ]]; then
		echo "[ ERROR ] missing deb/control file for update."
		exit 1
	fi

	ret="$(cat "$control_path" | grep "Standards-Version:")"
	if [[ "$ret" == "" ]]; then
		echo "[ ERROR ] missing 'Standard-Version' field."
		exit 1
	fi

	sed -i '/^Standards-Version:/c\'"Standards-Version: $version" \
		"$control_path"
}

verify_gpg() {
	if [[ "$gpg_id" == "" ]]; then
		gpg_compile=false
		return 0
	fi

	ret="$(gpg --list-keys | grep "$gpg_id")"
	if [[ "$ret" == "" ]]; then
		echo "[ WARNING ] - GPG key not found. Compile without GPG."
		gpg_compile=false
		return 0
	fi
}

prepare_workspace_path() {
	if [[ ! -d "$workspace_path" ]]; then
		echo "[ ERROR ] - workspace is not a directory."
		exit 1
	fi

	if [[ ! -d "${workspace_path}/debian" ]]; then
		echo "[ ERROR ] - workspace is not a valid debian directory."
		exit 1
	fi

	app_output_path=$(dirname "$workspace_path")
	app_name=$(basename "$app_output_path")
}

prepare_output_path() {
	if [[ "$output_path" == "" ]]; then
		return 0
	fi

	mkdir -p "$output_path"
}

export_output() {
	ls -p "${app_output_path}" \
		| grep -e '.deb' \
			-e '.build' \
			-e '.changes' \
			-e '.dsc' \
			-e 'tar.gz'  \
		| xargs -I{} cp "${app_output_path}/"{} "${output_path}/."
}

compile() {
	prepare_workspace_path
	verify_gpg
	prepare_output_path

	lastpath="$PWD"
	cd "$workspace_path"

	if [[ "$gpg_compile" == "false" ]]; then
		$compiler -us -uc
	elif [[ "$source_only" == "true" ]]; then
		$compiler -k"$gpg_id" -S
	else
		$compiler -k"$gpg_id"
	fi

	export_output
	cd "$lastpath"
	unset lastpath
}

upstream_launchpad() {
	dput "$ppa" "$deb_path"
}

upstream() {
	echo "$ppa"
	if [[ ! -f "$deb_path" ]]; then
		echo "[ ERROR ] missing .changes file: $deb_path"
		exit 1
	fi

	if [[ "$ppa" != "" ]]; then
		upstream_launchpad
	fi
}

print_help() {
	echo "\
DEBBER
The Debian package semi-automatic script for building and updating .deb
packages.
-------------------------------------------------------------------------------
To use: $ $0 [ACTION] [ARGUMENTS]

ACTIONS
1. -h, --help			print help. Longest help is up
				to this length for terminal
				friendly printout.


2. -v, --version		print app version.


3. -uv, --update-version	update the debian version number in the control
				file.
				COMPULSORY VALUES:
				1. -uv [version number]
				   E.g.:
				     $ program -uv 2.0.1

				COMPULSORY ARGUMENTS:
				1. -deb, --debian [path to debian folder]
				   E.g.:
				     $ program -cp ./debian

				EXAMPLES:
				1. $ program -uv 2.0.1 -deb ./debian


4. -c, --compile		compile the deb for the given parameters.
				COMPULSORY ARGUMENTS:
				1. -w, --workspace-path [path to workspace]
				   provide the workspace path for deb to
				   compile. It is the app directory containing
				   the debian folder.
				   E.g.:
				     $ program -c -w path/to/tmp/app

				2. -o, --output [path to output]
				   provide the output path for exporting the
				   output deb or .changes files. It will
				   create a debs folder to store all the files.
				   E.g.:
				     $ program -c -o path/to/release

				OPTIONAL ARGUMENTS:
				1. -k, --gpg [gpg id]
				   GPG key id to use for PPA repo and signing.
				   E.g.:
				     $ program -c -k AB234AB

				2. -cs, --source-only
				   Compile 'source-only' deb package. E.g.:
				     $ program -c -cs

				EXAMPLES:
				1. $ program \\
					-c \\
					-w ./tmp \\
					-o ./release \\
					-k AB234AB \\
					-cs

				2. $ program \\
					-w ./tmp \\
					-o ./release \\
					-k AB234AB

				3. $ program \\
					-w ./tmp \\
					-o ./release


5. -u, --upstream		upload the .deb file to upstream.
				COMPULSORY VALUE:
				1. -u [path to file]
				  path to the .changes for upstream.
				   E.g.:
				   $ program -u ./path/to/pack_sources.changes

				OPTIONAL ARGUMENTS:
				1. -ppa, --ppa [URL]
				   Ubuntu Launchpad PPA URL. This is to upload
				   the .changes to Ubuntu Launchpad platform.
				   E.g.:
				   $ program -u ./pack_sources.changes \\
					     -ppa account/pparepo
"
}

run_action() {
case "$action" in
"uv")
	update_version
	;;
"c")
	compile
	;;
"u")
	upstream
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
-uv|--update-version)
	action="uv"
	if [[ "$2" != "" ]]; then
		version="$2"
		shift 1
	fi
	shift 1
	;;
-deb|--debian)
	if [[ "$2" != "" ]]; then
		deb_path="$2"
		shift 1
	fi
	shift 1
	;;
-c|--compile)
	action="c"
	shift 1
	;;
-w|--workspace-path)
	if [[ "$2" != "" ]]; then
		workspace_path="$2"
		shift 1
	fi
	shift 1
	;;
-o|--output)
	if [[ "$2" != "" ]]; then
		output_path="$2"
		shift 1
	fi
	shift 1
	;;
-k|--gpg)
	if [[ "$2" != "" ]]; then
		gpg_id="$2"
		shift 1
	fi
	shift 1
	;;
-cs|--source-only)
	source_only=true
	shift 1
	;;
-u|--upstream)
	action="u"
	if [[ "$2" != "" ]]; then
		deb_path="$2"
		shift 1
	fi
	shift 1
	;;
-ppa|--ppa)
	if [[ "$2" != "" ]]; then
		ppa="$2"
		shift 1
	fi
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
