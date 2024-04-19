# BTrend (Basic trend)
Btrend is a tool to write c64 basic without sequence numbers.
To run it you need python3.

## Labels

Use labels in your basic text file to replace the sequence line numer.
The labels must be start with @ and should be ended with the same character (e.g. @start:)

### Label in commands
The labels can be used with the GOTO, GOSUB commands.

e.g.
```
	GOTO @main:
@greeting:
	PRINT "HI":RETURN
@sky:
	PRINT "THE SKY IS BLUE":RETURN
@main:
	GOSUB @greeting:
	GOSUB @sky:
```

## Defines

You can specify replacements and you can use them anywhere.

```
	define {orange}=8
	define {frmColor}=53280
	define {greeting}=HELLO
	POKE {frmColor},{orange}
	PRINT "{greeting}"
```

## Usage

```
btrend -in=<input> -out=<output> [options]

options:
  -v : verbose
  -s : skip comments
  -step=<num> : sequence step
```

e.g. you can create the output with these command
```
python btrend.py -in=dummy.txt -out=dummy.out.txt -s -step=5

(or in linux you can use with python3 ...)
```

## Comments

You can write comments, and you can turn off when you create the output.

```
	# *** DUMMY PROGRAM ***
	PRINT "DUMMY"
	# *** THIS IS THE END ***
```
if you dont turn off the comments the code will contain REM-s.

## Use c64list to create prg from output

Download the c64list, and you can create the prg file from output.

### Example: build a Hello world basic program

Build a basic hello world program.
```
	define {greeting}=HELLO WORLD!
	define {black}=144
	
	PRINT CHR$({black})
@mainCycle:
	# *** START PROGRAM ***
	PRINT "{greeting}"
	GOTO @mainCycle:
```
Save it to the hello.txt, than create the output and prg file.

```
btrend -in=hello.txt -out=hello.out.txt -step=5
c64list hello.out.txt -ovr -prg:hello.prg
```

We can see the ouput file (hello.out.txt), and there will be the line sequences.
```
5 PRINT CHR$(144)
10 REM *** START PROGRAM ***
15 PRINT "HELLO WORLD!"
20 GOTO 10
```
To start the basic program drag and drop the d64 file to vice (smart attach).

## Dirmaster
If you have already one or more prg file, you can create the d64 and put the prg-s into a d64 disc.

