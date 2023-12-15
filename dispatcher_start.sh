#!/bin/bash

: '
MIT License

Copyright (c) 2018 Wiktor Niesiobędzki

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
'

set -e -o pipefail

DISPATCHER_ARGS=("--osm-base" "--db-dir=/db/db")
if [[ "${OVERPASS_META}" == "attic" ]]; then
	DISPATCHER_ARGS+=("--attic")
elif [[ "${OVERPASS_META}" == "yes" ]]; then
	DISPATCHER_ARGS+=("--meta")
fi

if [[ -n ${OVERPASS_RATE_LIMIT} ]]; then
	DISPATCHER_ARGS+=("--rate-limit=${OVERPASS_RATE_LIMIT}")
fi

if [[ -n ${OVERPASS_TIME} ]]; then
	DISPATCHER_ARGS+=("--time=${OVERPASS_TIME}")
fi
if [[ -n ${OVERPASS_SPACE} ]]; then
	DISPATCHER_ARGS+=("--space=${OVERPASS_SPACE}")
fi

DISPATCHER_ARGS+=("--allow-duplicate-queries=yes")

find /db/db -type s -print0 | xargs -0 --no-run-if-empty rm && /app/bin/dispatcher "${DISPATCHER_ARGS[@]}"
