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

## Variables 

You can specify variables with longer name.
This logical names will be a short c64 variable version, like A1,BC or G7$.
You can specify two types, number or string.

```
	number IsReady
	number WeatherIsSunny
	string GreetingText

	IsReady=1
	WeatherIsSunny=1
	GreetingText = "I AM READY"
	IF IsReady=1 AND WeatherIsSunny=1 THEN PRINT GreetingText
```
Warning: Dont use short or similar variable names like Element and Elementalist,
because the program use string replace routin.
(if Element=4 and Elementalist=23 then the output will be 4alist=23 !)
If you insists on using these names, you had better using prefix and/or postfix
```
(e.g. _Element_ , _Elementalist_)
```

## Usage

```
btrend -in=<input> -out=<output> [options]

options:
  -v : verbose
  -s : skip comments
  -step=<num> : sequence step
  -t : turn on test mode
```

e.g. you can create the output with these command
```
python btrend.py -in=dummy.txt -out=dummy.out.txt -s -step=5

(or in linux you can use with python3 ...)
```
## Includes or usings
There are two solutions to include more files, before the building.\
The 'using' means that you can insert another file content to the beginning of the file,
but the 'include' will insert the file content into the position of 'include'.

### Using
```
using "path to file"
e.g.
using "lib/include.txt"
...
```

### Include
```
include "path to file"
e.g.
...
include "lib/include.txt"
...
```
### Test mode
You can enable or disable specific rows depends on test mode.\
The test mode could be turned on with /t option.
- ? \<commands\> : this row is enable if test mode is on
- ! \<commands\> : this row is disable if test mode is on

```
	! PRINT "THIS TEXT IS NOT VISIBLE IN TEST MODE!"
	? PRINT "THIS TEXT IS VISIBLE ONLY IN TEST MODE!"
	PRINT "THIS TEXT IS VISIBLE WHETHER TEST IS ON OR OFF"
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

Build a basic hello world test program.
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

