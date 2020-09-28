#!/bin/bash

dllog=data/incoming/download.$$.log
exec > $dllog

echo "Downloading URL: https://www.youtube.com/watch?v=fQVhppRP4Wo"
sleep 3
cat <<EOF
[youtube] fQVhppRP4Wo: Downloading webpage
[download] Destination: The foxes  that say HEHEHE.mp4
[download]   0.0% of 16.98MiB at Unknown speed ETA Unknown ETA
[download]   0.0% of 16.98MiB at Unknown speed ETA Unknown ETA
[download]   0.0% of 16.98MiB at Unknown speed ETA Unknown ETA
EOF
sleep 0.5
cat <<EOF
[download]   0.1% of 16.98MiB at 10.85MiB/s ETA 00:01
[download]   0.2% of 16.98MiB at 18.87MiB/s ETA 00:00
EOF
sleep 0.5
cat <<EOF
[download]   0.4% of 16.98MiB at 14.19MiB/s ETA 00:01
[download]   0.7% of 16.98MiB at 20.44MiB/s ETA 00:00
EOF
sleep 0.5
cat <<EOF
[download]   1.5% of 16.98MiB at  6.45MiB/s ETA 00:02
[download]   2.9% of 16.98MiB at 11.97MiB/s ETA 00:01
EOF
sleep 0.5
cat <<EOF
[download]   5.9% of 16.98MiB at 20.27MiB/s ETA 00:00
[download]  11.8% of 16.98MiB at 30.78MiB/s ETA 00:00
EOF
sleep 0.5
cat <<EOF
[download]  23.6% of 16.98MiB at 38.21MiB/s ETA 00:00
EOF
sleep 0.5
cat <<EOF
[download]  47.1% of 16.98MiB at 40.67MiB/s ETA 00:00
[download]  70.7% of 16.98MiB at 46.46MiB/s ETA 00:00
EOF
sleep 0.5
cat <<EOF
[download]  94.2% of 16.98MiB at 46.40MiB/s ETA 00:00
EOF
sleep 0.5
cat <<EOF
[download] 100.0% of 16.98MiB at 48.50MiB/s ETA 00:00
[download] 100% of 16.98MiB in 00:00
EOF
sleep 0.5
cat <<EOF
Downloaded: The foxes  that say HEHEHE.mp4
Title: The foxes  that say HEHEHE
Hash: 9db6ffabc824f3fdb2db214bfc0970f64ce53e96e449a4e9adef5f2c4bf1f237
Date: 2020-09-27 23:22:38
DONE
EOF

# Allow some time for the web client to pick this up, then clean up
sleep 2
rm $dllog
rm -f $(dirname $dllog)/$$.evt
