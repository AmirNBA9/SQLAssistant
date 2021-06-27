
DECLARE @Date DATETIME = '2016-09-05 00:01:02.333'
SELECT FORMAT(@Date, N'dddd, MMMM dd, yyyy hh:mm:ss tt')


/*
Argument Output
yyyy 	2016
yy 	16
MMMM 	September
MM 	09
M 	9
dddd 	Monday
ddd 	Mon
dd 	05
d 	5
HH 	00
H 	0
hh 	12
h 	12
mm 	01
m 	1
ss 	02
s 	2
tt 	AM
t 	A
fff 	333
ff 	33
f 	3
*/

DECLARE @Date DATETIME = '2016-09-05 00:01:02.333'
SELECT FORMAT(@Date, N'U')

/*
Single Argument Output
D 	Monday, September 05, 2016
d 	9/5/2016
F 	Monday, September 05, 2016 12:01:02 AM
f 	Monday, September 05, 2016 12:01 AM
G 	9/5/2016 12:01:02 AM
g 	9/5/2016 12:01 AM
M 	September 05
O 	2016-09-05T00:01:02.3330000
R 	Mon, 05 Sep 2016 00:01:02 GMT
s 	2016-09-05T00:01:02
T 	12:01:02 AM
t 	12:01 AM
U 	Monday, September 05, 2016 4:01:02 AM
u 	2016-09-05 00:01:02Z
Y 	September, 2016
*/

-- The above list is using the en-US culture. A different culture can be specified for the FORMAT() via the third parameter:
DECLARE @Date DATETIME = '2016-09-05 00:01:02.333'
SELECT FORMAT(@Date, N'U', 'zh-cn')
