#!/bin/bash
python3 btrend.py "-in=dummy.txt" "-out=out.txt" -step=5 -s
python3 btrend.py "-in=dummy.txt" "-out=out-plus-comments.txt" -step=5
