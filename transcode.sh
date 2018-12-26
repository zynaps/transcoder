#!/usr/bin/env bash

# TODO: clean exit on system signals
# TODO: log failures and deferred to system journal
# TODO: move unknown files in /watch to deferred

set -x

while true; do
    mv /watch/*.avi /output; mv /watch/*/ /deferred

    name="$(ls -t /output/*.avi | head -1 | sed -e s#^/output/##)"

    if [[ ${name} ]]; then
        output=${name%.avi}.m4v

        [[ -f "/temp/${output}" ]] && rm -f "/temp/${output}"

        unset SUBTITLES_OPTS

        subtitles=${name%.avi}.srt

        if [[ -f "/output/${subtitles}" ]]; then
            SUBTITLES_OPTS="--srt-file /output/${subtitles} --srt-codeset=UTF-8 --srt-default"
        fi

        HandBrakeCLI \
            --input "/output/${name}" --output "/temp/${output}" \
            --preset "Apple 1080p30 Surround" --crop 0:0:0:0 --optimize \
            --verbose=0 ${SUBTITLES_OPTS}

        if [[ $? -eq 0 ]]; then
            mv -f "/temp/${output}" /output && rm -f "/output/${name}" "/output/${subtitles}"
        else
            rm -f "/temp/${output}" && mv -f "/output/${name}" "/output/${subtitles}" /deferred
        fi
    else
        inotifywait -e moved_to /watch
    fi
done
