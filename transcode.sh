#!/usr/bin/env bash

set -x

while true; do
    mv /watch/*.avi /output; mv /watch/*/ /deferred

    name="$(ls -t /output/*.avi | head -1 | sed -e s#^/output/##)"

    if [[ ${name} ]]; then
        output=${name%.avi}.m4v

        [[ -f "/temp/${output}" ]] && rm -f "/temp/${output}"

        HandBrakeCLI \
            --input "/output/${name}" --output "/temp/${output}" \
            --preset "Apple 1080p30 Surround" --crop 0:0:0:0 --optimize \
            --verbose=0

        if [[ $? -eq 0 ]]; then
            mv -f "/temp/${output}" /output && rm -f "/output/${name}"
        else
            rm -f "/temp/${output}" && mv "/output/${name}" /deferred
        fi
    else
        inotifywait -e moved_to /watch
    fi
done
