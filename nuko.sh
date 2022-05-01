#!/bin/bash
################################
# User Variables               #
################################
VERSION="0.2.1"
ADB="${ADB}"
DEBUG=false

################################
# App Variables                #
################################
model=""
action=""
program=""
nukolib_path="./nukolib"
datafile="data"
apps=()

# deb path
if [[ ! -d "$nukolib_path" ]]; then
	nukolib_path="/usr/lib/nukolib"
	program="$0"
fi

# snapcraft
if [[ "$SNAP" != "" ]]; then
	nukolib_path="$SNAP/lib/nukolib"
	program="$(basename $0)"
fi


print_help() {
	if [[ "$program" == "" ]]; then
		program="$0"
	fi

	echo "\
              _
  _ __  _   _| | _____
 | '_ \\| | | | |/ / _ \\
 | | | | |_| |   < (_) |
 |_| |_|\\__,_|_|\\_\\___/

It's time to nuke all the bloatware from our Android phone/tablet without
rooting. Nuko needs ADB to interact with your device.
-------------------------------------------------------------------------------
To use: $ $0 [ACTION] [ARGUMENTS]

ACTIONS
1. -h, --help			print help. Longest help is up
				to this length for terminal
				friendly printout.

2. -v, --version		print app version.

3. -r, --run			runs the nuke on your platform
				using the given ADB.
				COMPULSORY ARGUMENTS/ENVIRONMENT VARIABLES:
				1.a. -adb, --adb /path/to/adb
				1.b. ADB=/path/to/adb
					select the adb program
					for interacting with
					the phone/tablet.

			example:
			\$ $0 -r -adb /path/to/adb
			OR
			\$ export ADB=/path/to/adb
			\$ $0 -r

ARGUMENTS
1. -d, --debug			runs nuko as a debug mode. It will
				use echo instead of ADB communications.
				Useful for dumping the list.

"
}

print_version() {
	echo $VERSION
}

test_adb() {
	echo -n "Initializing ADB silo...."
	if [[ ! -f "$ADB" ]]; then
		echo "[ ERROR ] ADB is not a file."
		echo "          Is that an ADB?"
		return 1
	fi
	echo "[ READY ]"

	echo -n "Authenticating ADB access..."
	ret="$( $ADB --help 2>&1 | grep "Android Debug Bridge" )"
	if [[ "$ret" == "" ]]; then
		echo "[ ERROR ] ADB is not an Android Debug Bridge."
		echo "          Are you sending the correct ADB?"
		return 1
	fi
	echo "[ READY ]"

	echo -n "Initializing System..."
	ret="$($ADB shell getprop ro.product.name)"
	if [[ "$ret" == "" ]]; then
		echo "[ ERROR ] ADB fails to communicate with device."
		echo "          Please set-up the ADB server using kill-server"
		echo "          and start server"
		return 1
	fi
	echo "[ READY ]"
	echo ""
	return 0
}

get_model() {
	model="$($ADB shell getprop ro.product.manufacturer)"
	model="${model}/$($ADB shell getprop ro.product.name)"
	if [[ "$model" == "/" ]]; then
		model=""
	fi
}

get_apps_list() {
	get_model
	if [[ "$model" == "" ]]; then
		echo "[ ERROR ] unknown device."
		return 1
	fi

	list_path="$nukolib_path/$model/$datafile"
	if [[ ! -f "$list_path" ]]; then
		echo "[ ERROR ] unsupported device: [$model]"
		return 1
	fi

	source "$list_path"
}

remove_app() {
	if [[ "$DEBUG" == "true" ]]; then
		echo "DEBUG."
	else
		$ADB shell pm uninstall --user 0 "$1"
	fi
}

remove_all_apps() {
	for app in ${apps[@]}; do
		echo -n "removing ${app}... "
		remove_app "$app"
	done
}

early_warning() {
	echo "\
+-----------------------------------------------+
| __        ___    ____  _   _ ___ _   _  ____  |
| \ \      / / \  |  _ \| \ | |_ _| \ | |/ ___| |
|  \ \ /\ / / _ \ | |_) |  \| || ||  \| | |  _  |
|   \ V  V / ___ \|  _ <| |\  || || |\  | |_| | |
|    \_/\_/_/   \_\_| \_\_| \_|___|_| \_|\____| |
|                                               |
+-----------------------------------------------+
Nuko will remove bloatware applications not limited to keyboard applications.
Before the nuking starts, please **DO** the following:

1. Login your Play Store and Google Account
2. Install a keyboard
    2.1. If the keyboard is the factory version, install an alternative version
         temporarily. You can install it back after the nuke.
3. Enable USB Debugging.

NUKE INFO
+-----------------------------------------------+
Target          : $model
List Prepared By: $maintainer_full_name
Email           : $maintainer_email
List Status     : $maintainer_status

Once you are done, press:

  launch             abort
╔═════════╗      ╔══════════╗
║  ENTER  ║      ║ CTRL + C ║
╚═════════╝      ╚══════════╝"
	read -s ret
	echo '
                                                   ,:
                                                 ," |
                                                /   :
                                             --"   /
                                             \/ />/
                                             / <//_\
                                          __/   /
                                          )"-. /
                                          ./  :\
                                           /." "
                                         "/"
                                         +
                                        "
                                      `.
                                  .-"-
                                 (    |
                              . .-"  ".
                             ( (.   )8:
                         ."    / (_  )
                          _. :(.   )8P  `
                      .  (  `-" (  `.   .
                       .  :  (   .a8a)
                      /_`( "a `a. )""
                  (  (/  .  " )=="
                 (   (    )  .8"   +
                   (`"8a.( _(   (
                ..-. `8P    ) `  )  +
              -"   (      -ab:  )
            "    _  `    (8P"Ya
          _(    (    )b  -`.  ) +
         ( 8)  ( _.aP" _a   \( \   *
       +  )/    (8P   (88    )  )
          (a:f   "     `"       `
'
}

run_action() {
case "$action" in
"h")
	print_help
	;;
"r")
	test_adb
	if [[ $? != 0 ]]; then
		return 1
	fi

	get_apps_list
	if [[ $? != 0 ]]; then
		return 1
	fi
	early_warning
	remove_all_apps debug
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
-h|--help)
	action="h"
	shift 1
	;;
-d|--debug)
	DEBUG=true
	shift 1
	;;
-adb|--adb)
	ADB="$2"
	shift 2
	;;
-r|--run)
	action="r"
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
