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

## Command line usage

```
btrend -in=<input> -out=<output> [options]

options:
  -v : verbose
  -s : skip comments
  -step=<num> : sequence step
  -t : turn on test mode
  -p : turn on pack mode
	    pack mode: the marked rows will be grouped in one row
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

## Hexadecimal and binary numbers

There are binary and hexadecimal number types:
```
b'0110 : 4 bit binary number
B'00100010 : 8 bit binary number
h'A7 : 1 byte hexadecimal number
H'D020 : 2 byte hexadecimal address
```

## WHEN vs. IF

In case of the "if statement" (like 'IF condition THEN ...'), you must
create labels to skip the statements block, and you must use reverse condition in that case too.\
e.g.
```
A=4
IF A>=5 THEN GOTO @SKIP1:
PRINT "THE A < 5"
PRINT "..."
@SKIP1:
```

With WHEN keyword you can create a statement block without any label, and
you dont have to specify reverse condition.\
Certainly you must specify the end of statements (with SKIP keyword)
e.g.:
```
A=4
WHEN A<5
	PRINT "THE A < 5"
	PRINT "..."
SKIP

WHEN A>20
	PRINT "THE A > 20"
SKIP

```
### ELSE and NESTED WHEN ... SKIP blocks
You can also use ELSE command in WHEN ... SKIP block, but it is not mandatory.
```
number MyFavNumber
	MyFavNumber=7
	
	WHEN MyFavNumber > 5
		PRINT "FAV.NUM > 5"
	ELSE
		PRINT "FAV.NUM <= 5"
	SKIP
```

You can use nested WHEN blocks, and you must use WHEN blocks in specific tabbed position.

```
number MyFavNumber
	MyFavNumber=7
	
	WHEN MyFavNumber > 5
		PRINT "FAV.NUM > 5"

		WHEN MyFavNumber < 10
			PRINT "FAV.NUM < 10"
		ELSE
			PRINT "FAV.NUM >= 10"
		SKIP

	ELSE
		PRINT "FAV.NUM <= 5"
	SKIP
```
Important: 
- You must use four spaces as a tab
- You can use tab instead of spaces, but it is not suggested


## Methods

Methods are runnable subroutines that have parameters. A method declaration contains a subroutine name and parameters, and with a CALL command you can run the subroutine.

```
define {screenMap}=H'0400
define {colorMap}=H'D800
number XPos
number YPos
number Char
number Color

	GOTO @Start:

METHOD PutCharacter XPos,YPos,Char,Color
	POKE {screenMap}+(YPos*40)+XPos,Char
	POKE {colorMap}+(YPos*40)+XPos,Color
	RETURN

@Start:
	CALL PutCharacter 3,7,h'13
	CALL PutCharacter 3,8,h'10
	CALL PutCharacter 3,9,h'11
	CALL PutCharacter 3,10,h'12
```
Important: 
- METHOD and CALL is always one line command.
- If you would like to use a multi dimensional array value (like Num(1,3) etc.. ) as parameter, use ; instead of comma. The program will split the parameters by comma, and the nested phrases with commas may cause confusion. 
(e.g. 1,2,Cube(3,4,7) are incorrect parameter values, and the correct are 1,2,Cube(3;4;7)  )
- The parameters in METHOD declaration must be variables, like num,string,ref. The program don't use stack because it would be slower. Regardless, you'd like to use stack, you must create a dim array buffer and the push,pop routines for this.

## Structures

Structures is complex types, and you can create instances from that types. \
e.g. There is a product type, and you can create one or more products, but all have the same properties.

You can declare the type with "struct \<name\> \<maximum instance\>", and you must specify 
the properties.

```
struct Product 100
	Title ""
	Type ""
	Quantity 0
---
```
You can specify other default values to the properties (not like "" or 0).\
The struct definition ends with --- mark. \

### Creating instances

You need to declare a ref variable, and you can refer on an instance with this variable.
The command of new instance creating is "NEW \<struct name\> AS \<ref name\>"
```
ref product
	NEW Product AS product
```
Important: Don't use "NEW.. AS .." with another command(s) in same line.

But how we could get a property value?

There is a shorter and longer version for that.
The longer version is that you write the struct name, the short version is that you use WITH
keyword.

Format of longer version: \<struct name\>.\<property name\>(\<ref name\>)
```
ref product
	NEW Product AS product
	Product.Title(product) = "IMPACT DRILL"
	Product.Quantity(product) = 40
```

Format of shorter version: \<alias name\>.\<property name\>(\<ref name\>)
```
ref product
	NEW Product AS product
	WITH P Product
	P.Title(product) = "IMPACT DRILL"
	P.Quantity(product) = 40
```
As you can see above, you can use abbreviations with "WITH" keyword.
If you'd like to clear the abbrevations, use "CLRWITH" keyword.
e.g.
```
	WITH P Product
	WITH C Customer
	...
	CLRWITH

	WITH P Player
	...
```

### Instance arrays
It's very simple to create instance array. You need to declare the array with "DIM".
```
ref products
ref product
    DIM products(3)

    WITH P Product

    X=0
    NEW Product AS product
    P.Name(product)="IMPACT DRILL"	
	...
	products(X) = product

    X=1
    NEW Product AS product
    P.Name(product)="SCREWDRIVER"
	...
	products(X) = product	
```

### Free/Clear object instance

If you'd like to clear instance use "FREE \<struct name\> \<instance ref\>"

```
	FOR X=0 TO 2
		FREE Product products(X)
	NEXT
	
	FREE Customer customer
```

### Check if instance exists

There is an array that tells existing/non-existing instances. You can use \<struct name\>.$(\<ref name\>)
```
	WITH P Product
    NEW Product AS product
    P.Name(product)="IMPACT DRILL"	

	WHEN P.$(product)=1
		PRINT P.Name(product)+" IS EXIST"
	SKIP

	FREE Product product

	WHEN P.$(product)<>1
		PRINT "THE PRODUCT IS NOT EXIST"
	SKIP
```
Important: The \$ sign doesn't mean that it would be a string. (The '\$' is a special property name of instances)

### Join ojbects

If you'd like to join 2 struct objects, you can use 'ref' as property type.

```
struct Product 50
    Name ""
	Customer ref
    Ordered 0
---

struct Customer 50
    Name ""
    Address ""
---

ref product
ref customer
	
	WITH P Product
	WITH C Customer
	
	NEW Customer AS customer
	C.Name(customer)="HARVEY SUTTON"

	NEW Product AS product
	P.Title(product) = "IMPACT DRILL"
	P.Customer(product) = customer
```

### Arrays in struct

You can use array in struct instance. If you specify (n) as default value it will be an array.
```
struct PokerPlayer 4
    Name ""
    Cards1 (2)
    Cards2 (2)
---


ref player
    NEW PokerPlayer AS player

    WITH P PokerPlayer
    P.Name(player)="SAM MAY"
    
    P.Cards1(player,0)=7
    P.Cards2(player,0)=1
    
    P.Cards1(player,1)=12
    P.Cards2(player,1)=4

string CardNums
string CardSuites
    CardNums="00 2 3 4 5 6 7 8 910 J Q K A"
    CardSuites=CHR$(97)+CHR$(115)+CHR$(120)+CHR$(122)
number CardNum
number CardSuit
    PRINT P.Name(player)+"'S POKER CARDS:" 
    CardNum=P.Cards1(player,0) : CardSuit=P.Cards2(player,0)
    PRINT "  "+MID$(CardSuites,CardSuit,1)+MID$(CardNums,CardNum*2,2)
    CardNum=P.Cards1(player,1) : CardSuit=P.Cards2(player,1)
    PRINT "  "+MID$(CardSuites,CardSuit,1)+MID$(CardNums,CardNum*2,2)

    CLRWITH
```
As you can see the array will be actually a 2 dimensional array .\
1st dimension is the instance reference value\
2nd dimension is the array index number\

## Enumerations

You can create enumeration with enum keyword. A variable with number type can have an enum value.
The enumerated values will be replaced with a sequence number (e.g. enum Color Red,Green,Blue,Yellow -> Color.Red will be 1 and Color.Blue will be 3)

```
number startDelivery
number destination

enum Continent Europe,Asia,Africa,America,Australia

	WITH C Continent
	startDelivery = C.Asia
	destination = C.Europe

	WHEN startDelivery=C.Asia AND destination=C.Europe
	PRINT "SHIP DELIVERY"
	SKIP
	WHEN startDelivery=C.America AND destination=C.Australia
	PRINT "PLANE DELIVERY"
	SKIP

	CLRWITH	
```

## PACK mode

You can mark blocks, that you would like to group in one row. Mark the block with [] and [/].
Certainly, you can also use the : but in that case it will be one long row in the source.


You can turn on or off this function with -p command option.

e.g.
```
number Num
number Fact

    GOTO @PackExample:

METHOD PrintFact Fact
        []
    Num=1
    FOR X=1 TO Fact
        Num=Num*X
    NEXT
    PRINT STR$(Fact)+"! = "+STR$(Num)
    RETURN
        [/]

@PackExample:
    CALL PrintFact 3
    CALL PrintFact 5
    CALL PrintFact 11

```
Important: 
- Dont use [] & [/] with one row commands,GOTO or GOSUB or labels (e.g. WHEN,CALL,number,@GoHere: etc.. )
- Dont use [] & [/] with more than 15-20 commands, because there is a limit on the size of row
- Use this function only if you'd like to optimize or speed up the basic program. Don't use it for other cases, becasue it will be uneffective, and harder to read.

## Use c64list to create prg from output

Download the c64list, and you can create the prg file from output.
```
python.exe btrend.py "-in=dummy.txt" "-out=out.txt" -step=5 -s -t
c64list out.txt -ovr -prg:out.prg
```

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

The most easiest way to run or test .prg, drag and drop it into a running vice emulator window.

## Examples

The dummy.txt in here contains almost every type of examples.

## Speed up your basic program with Blitz

The basic programs are very slow in general that's why it is recommended to speed up.\
The most simplier method is that you rebuild it with blitz.

https://commodore.software/downloads/download/53-basic-compilers/1016-blitz


Create an empty d64 image with dirmaster ; Disk / New / D64\
Import your prg file into d64 image ; File / Import \
Save the d64 image ; Disk / Save (or Save as)

Start the blitz on VICE.\
Choose 1. (1 side Floppy)\
Attach your d64 image (attach only, dont start the prg)\
Type the program name (without .prg)\
If the progress is ready, reset and start your program
 (usually the name is C/\<prg name\> )

Optionally, you can export the new prg with dirmaster (File / Export) and you can delete the old slow prg file from d64.



