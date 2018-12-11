#!/usr/bin/env bash

set -x

logger()
{
    echo "$(date +'%b %d %T')" ${1} | tee -a /log/transcode.log
}

transcode()
{
    timestamp=${1}
    name=${2}

    uid=$(pwgen -A1 6)

    logger "${uid}: detected \"${name}\" at ${timestamp}"

    if [[ -d "/watch/${name}" ]]; then
        mv "/watch/${name}" /deferred
        logger "${uid}: defer multi-file torrent for human check"
    elif [[ -f "/watch/${name}" ]]; then
        if [[ ${name##*.} = 'avi' ]]; then
            mv "/watch/${name}" /output
            logger "${uid}: original file moved to target location"

            logger "${uid}: transcoding original file"

            output=${name%.avi}.m4v

            if [[ -f "/temp/${output}" ]]; then
                rm -f "/temp/${output}"
                logger "${uid}: delete stalled file from previous transcoding"
            fi

            HandBrakeCLI \
                --input "/output/${name}" --output "/temp/${output}" \
                --preset "Apple 1080p30 Surround" --crop 0:0:0:0 --optimize

            if [[ $? -eq 0 ]]; then
                mv -f "/temp/${output}" /output

                name_size=$(stat -c%s "/output/${name}")
                output_size=$(stat -c%s "/output/${output}")

                logger "${uid}: transcoded and changed by $((output_size-name_size)) bytes"

                rm -f "/output/${name}"
                logger "${uid}: original file removed"
            else
                rm -f "/temp/${output}"
                logger "${uid}: error transcoding, tempfile deleted"
            fi
        fi
    fi
}

while true; do
    name="$(ls -tr /watch | head -1)"

    if [[ ${name} ]]; then
        transcode "$(date +'%FT%TZ')" ${name}
    else
        break
    fi
done

inotifywait -m /watch -e moved_to --timefmt '%FT%TZ' --format '%T %f' | \
    while read timestamp name; do
        transcode ${timestamp} ${name}
    done
