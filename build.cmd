python.exe btrend.py "-in=dummy.txt" "-out=out.txt" -step=5 -s -t -p
python.exe btrend.py "-in=dummy.txt" "-out=out-plus-comments.txt" -step=5 -t -p
c64list out.txt -ovr -prg:out.prg -crunch