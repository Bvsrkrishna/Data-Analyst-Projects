# HackerRank Python - Questions and Answers (all 36)

Each problem: **Question**, **Sample input / output**, then the **Answer** (paste into HackerRank).  
Every answer was run against its sample and passed.

---
## Q1. Day0 Hello World
**Question:** Day 0: Hello, World. Read one line of input and print 'Hello, World.' on the first line, then print the input line on the second line.

**Sample input:**
```
Welcome to 30 Days of Code!
```
**Sample output:**
```
Hello, World.
Welcome to 30 Days of Code!
```
**Answer:**
```python
input_string = input()
print("Hello, World.")
print(input_string)
```

---
## Q2. Day1 Data Types
**Question:** Day 1: Data Types. You are given i=4, d=4.0 and s='HackerRank '. Read an integer, a double and a string from input; print i + the integer, d + the double (one decimal place), and s + the string, each on its own line.

**Sample input:**
```
12
4.0
is the best place to learn and practice coding!
```
**Sample output:**
```
16
8.0
HackerRank is the best place to learn and practice coding!
```
**Answer:**
```python
i, d, s = 4, 4.0, "HackerRank "
i2 = int(input())
d2 = float(input())
s2 = input()
print(i + i2)
print(f"{d + d2:.1f}")
print(s + s2)
```

---
## Q3. Day2 Operators
**Question:** Day 2: Operators. Given the meal cost, tip percent and tax percent, print 'The total meal cost is X dollars.' where X is the total cost rounded to the nearest integer.

**Sample input:**
```
12.00
20
8
```
**Sample output:**
```
The total meal cost is 15 dollars.
```
**Answer:**
```python
meal_cost = float(input())
tip_percent = int(input())
tax_percent = int(input())
total = meal_cost * (1 + tip_percent / 100 + tax_percent / 100)
print("The total meal cost is {} dollars.".format(int(total + 0.5)))  # round half up
```

---
## Q4. Day3 Conditionals
**Question:** Day 3: Intro to Conditional Statements. Given n: if n is odd print Weird; if even and 2-5 print Not Weird; if even and 6-20 print Weird; if even and above 20 print Not Weird.

**Sample input:**
```
3
```
**Sample output:**
```
Weird
```
**Answer:**
```python
n = int(input())
if n % 2 == 1:
    print("Weird")
elif 2 <= n <= 5:
    print("Not Weird")
elif 6 <= n <= 20:
    print("Weird")
else:
    print("Not Weird")
```

---
## Q5. Day4 Class Vs Instance
**Question:** Day 4: Class vs. Instance. Write a Person class: if the initial age is negative print 'Age is not valid, setting age to 0.' and use 0. amIOld() prints young (<13), teenager (13-17) or old (18+). yearPasses() adds one year. For each test case, call amIOld, let 3 years pass, call amIOld again, then print a blank line.

**Sample input:**
```
4
-1
10
16
18
```
**Sample output:**
```
Age is not valid, setting age to 0.
You are young.
You are young.

You are young.
You are a teenager.

You are a teenager.
You are old.

You are old.
You are old.
```
**Answer:**
```python
class Person:
    def __init__(self, initialAge):
        if initialAge < 0:
            print("Age is not valid, setting age to 0.")
            self.age = 0
        else:
            self.age = initialAge

    def amIOld(self):
        if self.age < 13:
            print("You are young.")
        elif self.age < 18:
            print("You are a teenager.")
        else:
            print("You are old.")

    def yearPasses(self):
        self.age += 1

t = int(input())
for _ in range(t):
    age = int(input())
    p = Person(age)
    p.amIOld()
    for _ in range(3):
        p.yearPasses()
    p.amIOld()
    print("")
```

---
## Q6. Day5 Loops
**Question:** Day 5: Loops. Given n, print its multiplication table for 1 to 10 in the form 'n x i = result'.

**Sample input:**
```
2
```
**Sample output:**
```
2 x 1 = 2
2 x 2 = 4
2 x 3 = 6
2 x 4 = 8
2 x 5 = 10
2 x 6 = 12
2 x 7 = 14
2 x 8 = 16
2 x 9 = 18
2 x 10 = 20
```
**Answer:**
```python
n = int(input())
for i in range(1, 11):
    print(f"{n} x {i} = {n * i}")
```

---
## Q7. Day6 Lets Review
**Question:** Day 6: Let's Review. For each string, print its even-indexed characters, a space, then its odd-indexed characters.

**Sample input:**
```
2
Hacker
Rank
```
**Sample output:**
```
Hce akr
Rn ak
```
**Answer:**
```python
t = int(input())
for _ in range(t):
    s = input()
    print(s[::2], s[1::2])
```

---
## Q8. Day7 Arrays
**Question:** Day 7: Arrays. Read n and an array of n integers; print the array in reverse order on one line, separated by spaces.

**Sample input:**
```
4
1 4 3 2
```
**Sample output:**
```
2 3 4 1
```
**Answer:**
```python
n = int(input())
arr = input().split()
print(*arr[::-1])
```

---
## Q9. Day8 Dictionaries And Maps
**Question:** Day 8: Dictionaries and Maps. Read n name/phone-number pairs, then query names until input ends. For each query print 'name=number' if found, otherwise 'Not found'.

**Sample input:**
```
3
sam 99912222
tom 11122222
harry 12299933
sam
edward
harry
```
**Sample output:**
```
sam=99912222
Not found
harry=12299933
```
**Answer:**
```python
n = int(input())
phonebook = {}
for _ in range(n):
    name, number = input().split()
    phonebook[name] = number
while True:
    try:
        query = input().strip()
    except EOFError:
        break
    if not query:
        continue
    print(f"{query}={phonebook[query]}" if query in phonebook else "Not found")
```

---
## Q10. Say Hello World With Python
**Question:** Say 'Hello, World!' With Python. Print Hello, World!

**Sample input:**
```

```
**Sample output:**
```
Hello, World!
```
**Answer:**
```python
print("Hello, World!")
```

---
## Q11. Python If Else
**Question:** Python If-Else. Given n: odd -> Weird; even 2-5 -> Not Weird; even 6-20 -> Weird; even above 20 -> Not Weird.

**Sample input:**
```
24
```
**Sample output:**
```
Not Weird
```
**Answer:**
```python
n = int(input())
if n % 2 == 1 or 6 <= n <= 20:
    print("Weird")
else:
    print("Not Weird")
```

---
## Q12. Arithmetic Operators
**Question:** Arithmetic Operators. Read integers a and b; print a+b, a-b and a*b on separate lines.

**Sample input:**
```
1
2
```
**Sample output:**
```
3
-1
2
```
**Answer:**
```python
a = int(input())
b = int(input())
print(a + b)
print(a - b)
print(a * b)
```

---
## Q13. Division
**Question:** Python: Division. Read integers a and b; print integer division a//b on the first line and float division a/b on the second.

**Sample input:**
```
4
3
```
**Sample output:**
```
1
1.3333333333333333
```
**Answer:**
```python
a = int(input())
b = int(input())
print(a // b)
print(a / b)
```

---
## Q14. Loops
**Question:** Loops. Given n, print the square of every integer from 0 to n-1, one per line.

**Sample input:**
```
3
```
**Sample output:**
```
0
1
4
```
**Answer:**
```python
n = int(input())
for i in range(n):
    print(i ** 2)
```

---
## Q15. Write A Function
**Question:** Write a function. Complete is_leap(year): a year is a leap year if divisible by 4, except century years which must be divisible by 400. Print True/False.

**Sample input:**
```
1990
```
**Sample output:**
```
False
```
**Answer:**
```python
def is_leap(year):
    return year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)

year = int(input())
print(is_leap(year))
```

---
## Q16. Print Function
**Question:** Print Function. Given n, print the numbers 1 to n joined together with no spaces (123...n).

**Sample input:**
```
3
```
**Sample output:**
```
123
```
**Answer:**
```python
n = int(input())
print(*range(1, n + 1), sep="")
```

---
## Q17. List Comprehensions
**Question:** List Comprehensions. Given x, y, z, n, print a list of all [i, j, k] with 0<=i<=x, 0<=j<=y, 0<=k<=z whose sum is NOT equal to n, in lexicographic order.

**Sample input:**
```
1
1
1
2
```
**Sample output:**
```
[[0, 0, 0], [0, 0, 1], [0, 1, 0], [1, 0, 0], [1, 1, 1]]
```
**Answer:**
```python
x = int(input())
y = int(input())
z = int(input())
n = int(input())
print([[i, j, k]
       for i in range(x + 1)
       for j in range(y + 1)
       for k in range(z + 1)
       if i + j + k != n])
```

---
## Q18. Find The Runner Up Score
**Question:** Find the Runner-Up Score! Given n scores, print the second-highest distinct score.

**Sample input:**
```
5
2 3 6 6 5
```
**Sample output:**
```
5
```
**Answer:**
```python
n = int(input())
arr = map(int, input().split())
print(sorted(set(arr))[-2])
```

---
## Q19. Nested Lists
**Question:** Nested Lists. Given names and scores of n students, print the name(s) of the student(s) with the second-lowest grade, alphabetically, one per line.

**Sample input:**
```
5
Harry
37.21
Berry
37.21
Tina
37.2
Akriti
41
Harsh
39
```
**Sample output:**
```
Berry
Harry
```
**Answer:**
```python
records = []
for _ in range(int(input())):
    name = input()
    score = float(input())
    records.append([name, score])
second_lowest = sorted({score for _, score in records})[1]
for name in sorted(n for n, s in records if s == second_lowest):
    print(name)
```

---
## Q20. Finding The Percentage
**Question:** Finding the percentage. Given students' marks in 3 subjects and a query name, print that student's average marks to 2 decimal places.

**Sample input:**
```
3
Krishna 67 68 69
Arjun 70 98 63
Malika 52 56 60
Malika
```
**Sample output:**
```
56.00
```
**Answer:**
```python
n = int(input())
student_marks = {}
for _ in range(n):
    name, *line = input().split()
    student_marks[name] = list(map(float, line))
query_name = input()
marks = student_marks[query_name]
print("%.2f" % (sum(marks) / len(marks)))
```

---
## Q21. Lists
**Question:** Lists. Process n commands (insert, print, remove, append, sort, pop, reverse) on a list and print the list whenever 'print' is called.

**Sample input:**
```
12
insert 0 5
insert 1 10
insert 0 6
print
remove 6
append 9
append 1
sort
print
pop
reverse
print
```
**Sample output:**
```
[6, 5, 10]
[1, 5, 9, 10]
[9, 5, 1]
```
**Answer:**
```python
n = int(input())
arr = []
for _ in range(n):
    cmd, *args = input().split()
    if cmd == "insert":
        arr.insert(int(args[0]), int(args[1]))
    elif cmd == "print":
        print(arr)
    elif cmd == "remove":
        arr.remove(int(args[0]))
    elif cmd == "append":
        arr.append(int(args[0]))
    elif cmd == "sort":
        arr.sort()
    elif cmd == "pop":
        arr.pop()
    elif cmd == "reverse":
        arr.reverse()
```

---
## Q22. Tuples
**Question:** Tuples. Given n integers, create a tuple of them and print its hash.

**Sample input:**
```
2
1 2
```
**Sample output:**
```
-3550055125485641917
```
**Answer:**
```python
n = int(input())
integer_list = map(int, input().split())
print(hash(tuple(integer_list)))
```

---
## Q23. Swap Case
**Question:** sWAP cASE. Swap lowercase letters to uppercase and vice versa in a string.

**Sample input:**
```
HackerRank.com presents "Pythonist 2".
```
**Sample output:**
```
hACKERrANK.COM PRESENTS "pYTHONIST 2".
```
**Answer:**
```python
def swap_case(s):
    return s.swapcase()

print(swap_case(input()))
```

---
## Q24. String Split And Join
**Question:** String Split and Join. Split a string on spaces and join the pieces with a hyphen.

**Sample input:**
```
this is a string
```
**Sample output:**
```
this-is-a-string
```
**Answer:**
```python
def split_and_join(line):
    return "-".join(line.split(" "))

print(split_and_join(input()))
```

---
## Q25. Whats Your Name
**Question:** What's Your Name? Read a first and last name and print 'Hello firstname lastname! You just delved into python.'

**Sample input:**
```
Ross
Taylor
```
**Sample output:**
```
Hello Ross Taylor! You just delved into python.
```
**Answer:**
```python
def print_full_name(first, last):
    print(f"Hello {first} {last}! You just delved into python.")

first_name = input()
last_name = input()
print_full_name(first_name, last_name)
```

---
## Q26. Mutations
**Question:** Mutations. Strings are immutable. Given a string, a position and a character, return the string with that position replaced by the character.

**Sample input:**
```
abracadabra
5 k
```
**Sample output:**
```
abrackdabra
```
**Answer:**
```python
def mutate_string(string, position, character):
    return string[:position] + character + string[position + 1:]

s = input()
i, c = input().split()
print(mutate_string(s, int(i), c))
```

---
## Q27. Find A String
**Question:** Find a String. Count how many times a substring occurs in a string, including overlapping occurrences.

**Sample input:**
```
ABCDCDC
CDC
```
**Sample output:**
```
2
```
**Answer:**
```python
def count_substring(string, sub_string):
    count = 0
    for i in range(len(string) - len(sub_string) + 1):  # overlapping matches count
        if string[i:i + len(sub_string)] == sub_string:
            count += 1
    return count

string = input().strip()
sub_string = input().strip()
print(count_substring(string, sub_string))
```

---
## Q28. String Validators
**Question:** String Validators. For a string s, print on 5 lines whether it contains any alphanumeric, alphabetical, digit, lowercase and uppercase characters (True/False).

**Sample input:**
```
qA2
```
**Sample output:**
```
True
True
True
True
True
```
**Answer:**
```python
s = input()
print(any(c.isalnum() for c in s))
print(any(c.isalpha() for c in s))
print(any(c.isdigit() for c in s))
print(any(c.islower() for c in s))
print(any(c.isupper() for c in s))
```

---
## Q29. Text Alignment
**Question:** Text Alignment. Print the HackerRank 'H' logo for a given odd thickness, using ljust, rjust and center.

**Sample input:**
```
5
```
**Sample output:**
```
    H    
   HHH   
  HHHHH  
 HHHHHHH 
HHHHHHHHH
  HHHHH               HHHHH             
  HHHHH               HHHHH             
  HHHHH               HHHHH             
  HHHHH               HHHHH             
  HHHHH               HHHHH             
  HHHHH               HHHHH             
  HHHHHHHHHHHHHHHHHHHHHHHHH   
  HHHHHHHHHHHHHHHHHHHHHHHHH   
  HHHHHHHHHHHHHHHHHHHHHHHHH   
  HHHHH               HHHHH             
  HHHHH               HHHHH             
  HHHHH               HHHHH             
  HHHHH               HHHHH             
  HHHHH               HHHHH             
  HHHHH               HHHHH             
                    HHHHHHHHH 
                     HHHHHHH  
                      HHHHH   
                       HHH    
                        H     
```
**Answer:**
```python
thickness = int(input())
c = "H"
# Top cone
for i in range(thickness):
    print((c * i).rjust(thickness - 1) + c + (c * i).ljust(thickness - 1))
# Top pillars
for i in range(thickness + 1):
    print((c * thickness).center(thickness * 2) + (c * thickness).center(thickness * 6))
# Middle belt
for i in range((thickness + 1) // 2):
    print((c * thickness * 5).center(thickness * 6))
# Bottom pillars
for i in range(thickness + 1):
    print((c * thickness).center(thickness * 2) + (c * thickness).center(thickness * 6))
# Bottom cone
for i in range(thickness):
    print(((c * (thickness - i - 1)).rjust(thickness) + c +
           (c * (thickness - i - 1)).ljust(thickness)).rjust(thickness * 6))
```

---
## Q30. Text Wrap
**Question:** Text Wrap. Wrap a string into lines of at most max_width characters.

**Sample input:**
```
ABCDEFGHIJKLIMNOQRSTUVWXYZ
4
```
**Sample output:**
```
ABCD
EFGH
IJKL
IMNO
QRST
UVWX
YZ
```
**Answer:**
```python
import textwrap

def wrap(string, max_width):
    return textwrap.fill(string, max_width)

string = input()
max_width = int(input())
print(wrap(string, max_width))
```

---
## Q31. Designer Door Mat
**Question:** Designer Door Mat. For an N x M mat (N odd, M = 3N), print the pattern of '.|.' with '-' fill and WELCOME in the middle row.

**Sample input:**
```
7 21
```
**Sample output:**
```
---------.|.---------
------.|..|..|.------
---.|..|..|..|..|.---
-------WELCOME-------
---.|..|..|..|..|.---
------.|..|..|.------
---------.|.---------
```
**Answer:**
```python
n, m = map(int, input().split())
for i in range(1, n, 2):
    print((".|." * i).center(m, "-"))
print("WELCOME".center(m, "-"))
for i in range(n - 2, -1, -2):
    print((".|." * i).center(m, "-"))
```

---
## Q32. String Formatting
**Question:** String Formatting. For every number from 1 to n print decimal, octal, hexadecimal (uppercase) and binary, each padded to the width of the binary form of n.

**Sample input:**
```
17
```
**Sample output:**
```
    1     1     1     1
    2     2     2    10
    3     3     3    11
    4     4     4   100
    5     5     5   101
    6     6     6   110
    7     7     7   111
    8    10     8  1000
    9    11     9  1001
   10    12     A  1010
   11    13     B  1011
   12    14     C  1100
   13    15     D  1101
   14    16     E  1110
   15    17     F  1111
   16    20    10 10000
   17    21    11 10001
```
**Answer:**
```python
def print_formatted(number):
    width = len(bin(number)) - 2
    for i in range(1, number + 1):
        print("{0:{w}d} {0:{w}o} {0:{w}X} {0:{w}b}".format(i, w=width))

print_formatted(int(input()))
```

---
## Q33. Alphabet Rangoli
**Question:** Alphabet Rangoli. Print an alphabet rangoli of the given size.

**Sample input:**
```
3
```
**Sample output:**
```
----c----
--c-b-c--
c-b-a-b-c
--c-b-c--
----c----
```
**Answer:**
```python
def print_rangoli(size):
    import string
    alpha = string.ascii_lowercase
    lines = []
    for i in range(size):
        s = "-".join(alpha[i:size])
        lines.append((s[::-1] + s[1:]).center(4 * size - 3, "-"))
    print("\n".join(lines[:0:-1] + lines))

print_rangoli(int(input()))
```

---
## Q34. Capitalize
**Question:** Capitalize! Capitalize the first letter of every word in a name, keeping the original spacing.

**Sample input:**
```
hello   world 1st
```
**Sample output:**
```
Hello   World 1st
```
**Answer:**
```python
def solve(s):
    return " ".join(word.capitalize() for word in s.split(" "))  # split(" ") keeps spacing

print(solve(input()))
```

---
## Q35. The Minion Game
**Question:** The Minion Game. Stuart scores on substrings starting with consonants, Kevin on substrings starting with vowels. Print the winner and score, or Draw.

**Sample input:**
```
BANANA
```
**Sample output:**
```
Stuart 12
```
**Answer:**
```python
def minion_game(string):
    vowels = "AEIOU"
    stuart = kevin = 0
    n = len(string)
    for i, ch in enumerate(string):
        if ch in vowels:
            kevin += n - i
        else:
            stuart += n - i
    if stuart > kevin:
        print("Stuart", stuart)
    elif kevin > stuart:
        print("Kevin", kevin)
    else:
        print("Draw")

minion_game(input())
```

---
## Q36. Merge The Tools
**Question:** Merge the Tools! Split a string into pieces of length k and print each piece with duplicate characters removed (keeping first occurrences).

**Sample input:**
```
AABCAAADA
3
```
**Sample output:**
```
AB
CA
AD
```
**Answer:**
```python
def merge_the_tools(string, k):
    for i in range(0, len(string), k):
        print("".join(dict.fromkeys(string[i:i + k])))  # unique chars, order kept

s, k = input(), int(input())
merge_the_tools(s, k)
```
