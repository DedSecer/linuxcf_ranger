#! /usr/bin/sh

#update file from github and make hard link to your config directory
#-n to set ln_cmd 
#-g to set no git pull

ra_path="${HOME}/.config/ranger"
ln_cmd='ln -i'

while [ -n "$1" ]
do 

	case ${1} in
		-n)
			ln_cmd=${2}
			shift
			;;
		-g)
			git_pull=false
			;;
		*)
			echo "Unknown Option '${1}'"
			exit 1
			;;
	esac
	shift
done

function lnr() {
	#a function to make hardlinked_subtree excluding ud_ln.sh
	#${1}:from path , ${2}:to path , ${3}:ln_cmd

	if test -d ${1}; then
		for file in `ls ${1}` ; do
			mkdir -p ${2}
			lnr ${1}/${file} ${2}/${file} "${3}"
			done	
	
	elif test -f ${1}; then
		[ ${1} == './ud_ln.sh' ] || ${3} ${1} ${2}
	fi		
}

${git_pull} && git pull ; git submodule update --init

lnr . ${ra_path} "${ln_cmd}"
