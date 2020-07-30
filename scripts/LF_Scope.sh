#!/bin/ksh

set -o noclobber -o noglob -o nounset -o pipefail
IFS='
'

## Script arguments
FILE_PATH="${1}"         # Full path of the highlighted file
PV_WIDTH="$(( $(tput cols)*11 / 16 -3 ))"          # Width of the preview pane (number of fitting characters)
#PV_WIDTH="${3}"          # Width of the preview pane (number of fitting characters)
## shellcheck disable=SC2034 # PV_HEIGHT is provided for convenience and unused
set +o nounset
PV_HEIGHT="${2}"         # Height of the preview pane (number of fitting characters)
set -o nounset
#IMAGE_CACHE_PATH="${4}"  # Full path that should be used to cache image preview
#PV_IMAGE_ENABLED="${5}"  # 'True' if image previews are enabled, 'False' otherwise.
#PV_IMAGE_ENABLED="False"  # 'True' if image previews are enabled, 'False' otherwise.

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"

## Settings
HIGHLIGHT_SIZE_MAX=262143  # 256KiB
HIGHLIGHT_TABWIDTH=${HIGHLIGHT_TABWIDTH:-8}
HIGHLIGHT_STYLE=${HIGHLIGHT_STYLE:-pablo}
HIGHLIGHT_WRAP='-V' # -W:fill with tabs, -V simple
HIGHLIGHT_OPTIONS="--replace-tabs=${HIGHLIGHT_TABWIDTH} --style=${HIGHLIGHT_STYLE} ${HIGHLIGHT_WRAP} -J ${PV_WIDTH} ${HIGHLIGHT_OPTIONS:-}"
#OPENSCAD_IMGSIZE=${RNGR_OPENSCAD_IMGSIZE:-1000,1000}
#OPENSCAD_COLORSCHEME=${RNGR_OPENSCAD_COLORSCHEME:-Tomorrow Night}

handle_extension() {
    case "${FILE_EXTENSION_LOWER}" in
        ## Archive
        a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
        rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
            atool --list -- "${FILE_PATH}" && exit 5
            bsdtar --list --file "${FILE_PATH}" && exit 5
            exit 1;;
        rar)
            ## Avoid password prompt by providing empty password
            unrar lt -p- -- "${FILE_PATH}" && exit 5
            exit 1;;
        7z)
            ## Avoid password prompt by providing empty password
            7z l -p -- "${FILE_PATH}" && exit 5
            exit 1;;

        ## PDF
        pdf)
            ## Preview as text conversion
            TEXT=$(pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - | \
              fmt -w "$(tput cols)")
            pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - | \
              fmt -w "$(tput cols)"
	    if [[ -n $TEXT ]]; then
	    	echo "$TEXT" && exit 5
	    else
		mutool draw -F txt -i -- "${FILE_PATH}" 1-10 | \
		  fmt -w "${PV_WIDTH}" && exit 5
		mediainfo "${FILE_PATH}" && exit 5
		exiftool "${FILE_PATH}" && exit 5
	    fi ;;
#            exit 1;;

        ## BitTorrent
        torrent)
            transmission-show -- "${FILE_PATH}" && exit 5
            exit 1;;

        ## OpenDocument
        odt|ods|odp|sxw)
            ## Preview as text conversion
            odt2txt "${FILE_PATH}" && exit 5
            ## Preview as markdown conversion
            pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
            exit 1;;

        ## XLSX
        xlsx)
            ## Preview as csv conversion
            ## Uses: https://github.com/dilshod/xlsx2csv
            xlsx2csv -- "${FILE_PATH}" && exit 5
            exit 1;;

        ## HTML
        htm|html|xhtml)
            ## Preview as text conversion
            w3m -dump "${FILE_PATH}" && exit 5
            lynx -dump -- "${FILE_PATH}" && exit 5
            elinks -dump "${FILE_PATH}" && exit 5
            pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
            ;;

        ## JSON
        json)
            jq --color-output . "${FILE_PATH}" && exit 5
            ;;

        ## Direct Stream Digital/Transfer (DSDIFF) and wavpack aren't detected
        ## by file(1).
        dff|dsf|wv|wvc)
            mediainfo "${FILE_PATH}" && exit 5
            exiftool "${FILE_PATH}" && exit 5
            ;; # Continue with next handler on failure
    esac
}

handle_mime() {
    local mimetype="${1}"
    case "${mimetype}" in
        ## RTF and DOC
        text/rtf|*msword)
            ## Preview as text conversion
            ## note: catdoc does not always work for .doc files
            ## catdoc: http://www.wagner.pp.ru/~vitus/software/catdoc/
            catdoc -- "${FILE_PATH}" && exit 5
            exit 1;;

        ## DOCX, ePub, FB2 (using markdown)
        ## You might want to remove "|epub" and/or "|fb2" below if you have
        ## uncommented other methods to preview those formats
        *wordprocessingml.document|*/epub+zip|*/x-fictionbook+xml)
            ## Preview as markdown conversion
            pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
            exit 1;;

        ## XLS
        *ms-excel)
            ## Preview as csv conversion
            ## xls2csv comes with catdoc:
            ##   http://www.wagner.pp.ru/~vitus/software/catdoc/
            xls2csv -- "${FILE_PATH}" && exit 5
            exit 1;;

        ## Text
        text/* | */xml)
            ## Syntax highlight
            if [[ "$( stat --printf='%s' -- "${FILE_PATH}" )" -gt "${HIGHLIGHT_SIZE_MAX}" ]]; then
#                exit 2
                head -${PV_HEIGHT}
            fi
            if [[ "$( tput colors )" -ge 256 ]]; then
                local highlight_format='xterm256'
            else
                local highlight_format='ansi'
            fi
            [[ ${FILE_PATH} = *rc ]] && SYNTAX='--syntax=sh' || SYNTAX=
            env HIGHLIGHT_OPTIONS="${HIGHLIGHT_OPTIONS}" highlight \
                --out-format="${highlight_format}" \
                --line-range=1-${PV_HEIGHT} \
                $SYNTAX --force -- "${FILE_PATH}" && exit 5
            env COLORTERM=8bit bat --color=always --style="plain" \
                -- "${FILE_PATH}" && exit 5
            exit 2;;

        ## DjVu
        image/vnd.djvu)
            ## Preview as text conversion (requires djvulibre)
            djvutxt "${FILE_PATH}" | fmt -w "${PV_WIDTH}" && exit 5
            mediainfo "${FILE_PATH}" && exit 5
            exiftool "${FILE_PATH}" && exit 5
            exit 1;;

        ## Video and audio and Image
        video/* | audio/* | image/*)
            mediainfo "${FILE_PATH}" && exit 5
            exiftool "${FILE_PATH}" && exit 5
            exit 1;;
    esac
}

handle_fallback() {
    echo '----- File Type Classification -----' && file --dereference --brief -- "${FILE_PATH}"  | sed 's/,\ /\n/g' && exit 5
    exit 1
}


MIMETYPE="$( file --dereference --brief --mime-type -- "${FILE_PATH}")"
handle_extension
handle_mime "${MIMETYPE}"
handle_fallback

exit 1
