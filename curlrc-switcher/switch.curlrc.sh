#!/usr/bin/env bash
showHelp() {
	echo -e "\nThis script displays and changes the contents of \"$BASE_FILE\" files in your home directory.  It:\n"
	echo "  * Looks for files in your home directory with a \"${BASE_FILE}-*\" name"
	echo "  * Presents a numerically indexed Options menu of these files"
	echo "  * Allows you to select a file to display its contents and/or copy it into the \"$BASE_FILE\" file"
	echo -e "\nIf the first line of a \"${BASE_FILE}-*\" file is prefixed by \"###\", then that line is considered to"
	echo -e "be a description and included in the menu of files.\n"
	exit 0
}
getCommentFromFirstLine() {
	COMMENT=$(head -1 $1)
	if ! [[ "$COMMENT" =~ ^### ]]; then
		COMMENT=""
	else
		COMMENT=$(echo "$COMMENT" | sed -E 's/^### *//')
		COMMENT=" / $COMMENT"
	fi
}
getFilename() {
	FILENAME=$(echo "$1" | sed -E 's#^.*/##')
}
displayOptions() {
	FILE_OPTIONS=()
	I=0
	while read FILE
	do
		[ "$I" -eq "0" ] && echo -e "\nOptions:"
		getCommentFromFirstLine "$FILE"
		getFilename $FILE
		echo "  $I: $FILENAME$COMMENT"
		FILE_OPTIONS[ $I ]="$FILE"        
		(( I++ ))
	done < <(ls -1 ~/$BASE_FILE ~/$BASE_FILE-* 2> /dev/null)
	(( I-- ))
	[ "$I" -lt "0" ] && { echo "Sorry, no $BASE_FILE files found"; exit 1; }
	echo "  !: Re-display this Options menu"
	echo -e "  ?: Show additional Usage instructions\n"
}
displayUsage() {
	echo -e "\nUsage:"
	echo "  * Enter an option's number to copy that file's contents into $BASE_FILE"
	echo "    - Additionally append \"?\" to show that file's contents"
	echo "    - Additionally append \"?X\" to show that file's contents with an obfuscated Fastly-Key"
	echo "  * Enter an exclamation point to re-display the Options"
	echo "  * Enter a question mark to show these Usage instructions"
	echo "  * Enter nothing, i.e. hit return, to exit this script"
	echo -e "\nNote:"
	echo "  * The file options include a filename and a description in parentheses"
	echo -e "  * The description is extracted from first line of the file if it begins with \"###\"\n"
}
BASE_FILE=".curlrc"
[ "$#" -ne "0" ] && showHelp
getCommentFromFirstLine ~/$BASE_FILE
displayOptions
CHOICE_RANGE="0"
[ "$I" -gt "0" ] && CHOICE_RANGE="$CHOICE_RANGE-$I"
while true
do 
	read -p "Choose an option [$CHOICE_RANGE]: " CHOICE_PLUS
	[ "$CHOICE_PLUS" == "" ] && exit 0
	[ "$CHOICE_PLUS" == "!" ] && { displayOptions; continue; }
	[ "$CHOICE_PLUS" == "?" ] && { displayUsage; continue; }
	if [[ "$CHOICE_PLUS" =~ [0-9]+(\?X?)? ]]; then
		CHOICE=$(echo "$CHOICE_PLUS" | sed -E 's/\?.*$//')
		if [[ "$CHOICE" -ge "0" && "$CHOICE" -le "$I" ]]; then
			getFilename ${FILE_OPTIONS[ $CHOICE ]}
			if [[ "$CHOICE_PLUS" =~ \?$ ]]; then # Show selected file's contents
				echo -e "\nContents of $FILENAME:"
				cat ${FILE_OPTIONS[ $CHOICE ]}
				echo ""
			elif [[ "$CHOICE_PLUS" =~ \?X$ ]]; then # Show selected file's contents with obfuscated Fastly-Key
				echo -e "\nContents of $FILENAME:"
				cat ${FILE_OPTIONS[ $CHOICE ]} | sed -E 's/[0-9a-z]{32}/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/'
				echo ""
			elif [ "$CHOICE" -eq 0 ]; then # Do nothing since current file was re-chosen
				echo -e "\n$BASE_FILE left unchanged"
				exit 0
			else # Copy contents of selected file to .curlrc file
				sed "1 s/$/ [Copied $(date)]/" ${FILE_OPTIONS[ $CHOICE ]} > ~/$BASE_FILE
				echo -e "\nContents of $FILENAME copied to $BASE_FILE\n"
				exit 0
			fi
		fi
	fi
done