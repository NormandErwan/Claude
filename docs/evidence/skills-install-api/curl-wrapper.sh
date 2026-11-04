#!/bin/bash
echo "$@" >> /tmp/claude-0/-home-user-Claude/c4cd3ce2-1a14-5ea2-9285-b152eaca02c1/scratchpad/inst-test/curl.log
exec /usr/bin/curl "$@"
