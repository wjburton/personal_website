---
title: "Problem Solving: Part I"
date: 2020-06-20T08:11:46-07:00
math: true
description: George Polya's "How to Solve It"
draft: false
---


In exploring how to efficiently solve data science problems (typically requiring some stastical, mathematical, or algorthmic solution), I wanted to first dig into George Polya's "How To Solve It".

***

<p align="center">
<a target="_blank"  href="https://www.amazon.com/gp/product/069116407X/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=069116407X&linkCode=as2&tag=willjburton-20&linkId=7bd598715e98cd6e3def63f9f960894e"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=069116407X&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=willjburton-20" ></a><img src="//ir-na.amazon-adsystem.com/e/ir?t=willjburton-20&l=am2&o=1&a=069116407X" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
</p>

<p align="center">
<a target="_blank" href="https://www.amazon.com/gp/product/069116407X/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=069116407X&linkCode=as2&tag=willjburton-20&linkId=5c3c5c2420e56c3fead6b709708c0b46">How to Solve It: A New Aspect of Mathematical Method (Princeton Science Library)</a><img src="//ir-na.amazon-adsystem.com/e/ir?t=willjburton-20&l=am2&o=1&a=069116407X" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
</p>

***

I learned about this book during an algorithms class I took at the [Bradfield School of Computer Science](https://bradfieldcs.com/). George Polya was a famous mathematics professor at Stanford and his book provides a general framework for solving problems through a series of questioning. 

The core component of the book is "The List" which is a thought process / series of questions someone should ask themselves while going from problem to solution. I've copied the list verbatim below. 


*** 

**Understand the problem**

1.1 What is the unknown?   
1.2 What are the data?   
1.3 What is the condition?  
1.4 Is it possible to satisfy the condition?  
1.5 Is the condition sufficient to determine the unknown? or is it insufficient? or redundant? or contradictory?  

**Devising a Plan**

2.1 Have you seen it before?  
2.2 Or have you seen the same problem in a slightly different form?  
2.3 Do you know a related problem?  
2.4 Do you know a theorem that could be useful?  
2.5 Here is a problem related to your and solved before, can you use it? Could you use its result?  Could you use its method?  
2.6 Should you introduce some auxiliary element in order to make its use possible?  
2.7 Could you restate the problem?  
2.8 Could you restate it differently?  
2.9 Can you imagine a more accessible related problem? A more general problem? A more special problem? An analagous problem?  
2.13 Could you solve a part of the problem?  
2.14 Keep only a part of the condition and drop the other part, how far is the unknown then determined?  how can it vary?  
2.15 Could you derive something useful from the data?  
2.16 Could you think of other data appropriate to determine the unknown?  
2.17 Could you change the unknown or the data, or both if necessary, so that the new unknown and the new data are nearer to each other?  
2.18 Did you use all the data?  
2.19 Did you use the whole condition?  
2.20 Have you taken into account all essential notions involved in the problem?  

**Carrying out the Plan**  
3.1 Check each step -- can you see clearly that the step is correct?  
3.2 Can you prove that it is correct?  

**Looking Back**  
4.1 Can you check the result?  
4.2 Can you check the argument?  
4.3 Can you derive the result differently?  
4.4 Can you see it at a glance?  
4.5 Can you use the result, or the method, for some other problems?  

*** 


Now we have a list.. but a list isn't going to solve our problems by itself. It still takes hard work, trial and error, time, and sometimes luck (as noted by Polya).

In order to test out the thought process I also purchased <a target="_blank" href="https://www.amazon.com/gp/product/B00CWR50OU/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B00CWR50OU&linkCode=as2&tag=willjburton-20&linkId=ff98e16a7a3d72c202ae065dbf5d160e">The Stanford Mathematics Problem Book </a><img src="//ir-na.amazon-adsystem.com/e/ir?t=willjburton-20&l=am2&o=1&a=B00CWR50OU" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />to provide a problem set to practice on.

"For 20 years, from 1946 to 1965, the Department of Mathematics at Stanford University conducted a competitive examination for highshool seniors. The immediate and principal purpose of the examination was to identify, among each year's high school graduates, singularly capable students and attract them to Stanford." The problems I'm using are selected out of this book and they also show up in "How to Solve It".


***

**Problem 3. From "How to Solve It"**

Bob has 10 pockets and 44 silver dollars. He wants to put his dollars into his pockets so distributed that each pocket contains a different number of dollars.  
A) Can he do so?  
B) Generalize the problem, considering p pockets and n dolllars. The problem is most interesting when $$ n=\frac{(p+1)(p-2)}{2} $$
Why?


**Understanding the Problem**  
Data: 10 pockets, 44 silver dollars  
Unknown: Amount of quarters in each pocket  
Condition: Each pocket must have a different number of quarters  

My line of questioning:
To answer can he do so, what is the minimum number of quarters for this to be achievable?
0+1+2+...+9 = 45.  He would need 45 quarters to make this possible.

**Create a Plan**

Draw a figure (fill in a table) plotting n and p under the function provided. Do I notice anything?   

**Carrying out the Plan**

```r
p <- 1:90
n <- ((p+1)*(p-2))/2
min_quarters_required <- ((p-1)*p)/2
df <- data.frame(p,n,min_quarters_required)
```

![](images/silver_dollars_table.png)


We are always one silver dollar short to achieve a unique number in each pocket.


A) No <br>
B) Under this function of n, we are always short a single quarter


***

**Problem 5. From "How to Solve It."**

Among grandfather's papers a bill was found:
72 turkeys $\_67.9\_ 
The first and last digit of the number that obviously represented the total price of those fowls are replaced here by blanks, for they have faded and are now illegible. 
What are the faded digits and what was the price of one turkey?


**Understanding the Problem**

What is the unknown? The first and last digit
What are the data? 
1. 72 turkeys were bought  
2. The total price was $\_67.9\_  
3. Assumption is the price does not include tax. This would make the problem much more difficult since states tax at different rates and you would no longer have the divisibility constraint providing the obvious solution.  

What is the condition? No condition was provided, but because of an understanding on pricing and receipts, I can set the following constraints:  
1. The first digit is between 1 and 9.  The digit would not have been included if it were 0.  
2. The total price multiplied by 100 must be divisible by 72. There was no rounding applied to the final price.  

Is the condition sufficient to satisfy the unknown?
Yes, only if one of the total prices * 100 is divisible by 72


**Create a Plan**

"Draw a Picture" 
Given the condition, it appears the only way to solve it is to find a number in the possible solution range that when multiplied by 100 is divisible by 72 I created a table containing all possible prices, which will have the same number of rows as the number of combinations of these two integers,10*9 = 90 combinations.

**Carrying out the Plan**

```r
df = data.frame()
for(first_digit in c(1:9)){
  for(last_digit in c(0:9)){
    add = data.frame(first_digit, last_digit,  total = 100*first_digit + 67.90 + last_digit/100)
    add = add%>%mutate(ppt = total/72)
    df = rbind(df,add)
  }
}
```

![](images/price_per_turkey.png)


When multiplied by 100, only one of the possible total prices was divisible by 72 which was 367.92, making the price per turkey $5.11.

**Looking Back**  
Can you check the result? Yes, it was the only potential option given the alternatives. 
The answer is not gauranteed to be right, but there is no way to determined that. It is possible that there was tax and a rounding that occurred such that 
the number was not divisible by 72. In this case there would be no way of knowing.


***





