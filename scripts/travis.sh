#!/bin/bash
# https://docs.travis-ci.com/user/customizing-the-build/#Implementing-Complex-Build-Steps
set -ev

npm install
if [ "${TRAVIS_MODE}" = "buildLib" ]; then
	npm run buildlib
elif [ "${TRAVIS_MODE}" = "buildDist" ]; then
	npm run builddist
elif [ "${TRAVIS_MODE}" = "unitTests" ]; then
	npm run test
elif [ "${TRAVIS_MODE}" = "funcTests" ]; then
	npm run builddist
	n=0
	maxRetries=3
	until [ $n -ge ${maxRetries} ]
	do
		if [ $n -gt 0 ]; then
			echo "Retrying... Attempt: $((n+1))"
		fi
		npm run testfunc && break
		n=$[$n+1]
	done
	if [ ${n} = ${maxRetries} ]; then
		exit 1
	fi
else
	echo "Unknown travis mode: ${TRAVIS_MODE}" 1>&2
	exit 1
fi
