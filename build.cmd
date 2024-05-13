python.exe btrend.py "-in=dummy.txt" "-out=out.txt" -step=5 -v -s -t
python.exe btrend.py "-in=dummy.txt" "-out=out-plus-comments.txt" -step=5 -v -t
c64list out.txt -ovr -prg:out.prg