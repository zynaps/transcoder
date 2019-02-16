#!/usr/bin/env bash

# TODO: clean exit on system signals

set -x

while true; do
    ls *.avi | while read input; do
        [[ -f "${input}.lock" ]] && continue

        subtitles=${input%.avi}.srt

        if [[ -f "${subtitles}" ]]; then
            SUBTITLES_OPTS="--srt-file ${subtitles} --srt-codeset=UTF-8 --srt-default"
        else
            unset SUBTITLES_OPTS
        fi

        output=${input%.avi}.m4v

        HandBrakeCLI \
            --input "${input}" --output "${output}.tmp" \
            --preset "Apple 1080p30 Surround" --crop 0:0:0:0 --optimize \
            --verbose ${SUBTITLES_OPTS} \
        |& tr '\r' '\n' | tee "${input}.lock"

        if [[ ${PIPESTATUS[0]} -eq 0 ]]; then
            mv -f "${output}.tmp" "${output}"
            rm -f "${input}" "${subtitles}" "${input}.lock"
        else
            rm -f "${output}.tmp"
        fi
    done

    sleep 60
done
