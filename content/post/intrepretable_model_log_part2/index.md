---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Interpretable and Explainable Modeling, Part 2."
subtitle: "A Working Example"
summary: ""
authors: []
tags: []
categories: []
date: 2020-10-26T07:14:10-07:00
lastmod: 2020-10-26T07:14:10-07:00
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

In this post I'll be going through code step by step to build an interpretable and explainable model for the Titanic Dataset. I first found this dataset back around 2012-2013 on Kaggle, when the site was still in its infancy.

Problem Background (pulled from Kaggle)
>The sinking of the Titanic is one of the most infamous shipwrecks in history.
>
>On April 15, 1912, during her maiden voyage, the widely considered “unsinkable” RMS Titanic sank after colliding with an iceberg. Unfortunately, there weren’t enough lifeboats for everyone onboard, resulting in the death of 1502 out of 2224 passengers and crew.
>
>While there was some element of luck involved in surviving, it seems some groups of people were more likely to survive than others.
>
>In this challenge, we ask you to build a predictive model that answers the question: “what sorts of people were more likely to survive?” using passenger data (ie name, age, gender, socio-economic class, etc).


Kaggle also provides a data dictionary here! Ah, such a nice convenience that can be so rare in the real world. The availabla data includes:
* **survival** - Survival	0 = No, 1 = Yes
* **pclass** - Ticket class	1 = 1st, 2 = 2nd, 3 = 3rd
* **sex** - Sex	
* **Age** -	Age in years	
* **sibsp** - # of siblings / spouses aboard the Titanic	
* **parch** - # of parents / children aboard the Titanic	
* **ticket** - Ticket number	
* **fare** - Passenger fare	
* **cabin** - Cabin number	
* **embarked** - Port of Embarkation C = Cherbourg, Q = Queenstown, S = Southampton

Alright, I have the data and the problem, let's start going through the list of steps posed in my previous post.:

**1. Understand the business context and typical drivers of the process**
Without a SME available, I'll rely on my knowledge of sociology to think of reasonable drivers. The problem is around predicting who will die in a disaster situation. But there is another important component that makes the titanic different than other disasters. In this case there were decisions made by humans about who would get to go on a life boat. So part of the survivability is based on who society would have  prioritized when loading up the boats.
A couple initial thoughts around the data available:

  * **sex** - Women were likely prioritized over men
  * **age** - Young children likely prioritized 
  * **age** - Elderly potentially de-prioritized
  * **ticket** - Ticket number doesn't seem like it will be useful (though I can think of a couple stretch reasons)
  * **embarked** - Porential that the different cities had different cultures associated making one port more likely than another port (could also be wealth/gender/age differences)
  * **pclass**, **fare** - Wealthy were likely prioritized over the poor 
  * **cabin** - Certain cabins may have had a harder time reaching the life boats due to location on the boat. 
  * **sibsp**, **parch** - Can't think of great reasons why large families vs small families would 


**2. Understand your data available**
Unless I wanted to seek out alternative data, this is all Kaggle provides.


**3. Explore the data**  
Given the data is relatively small, say < 25 columns, I always start out with a univariate analysis. This includes looking at the variable distributions and noting any interesting observations or potential mutations.

**Univariate Analysis**
<pre class="r"><code>library(tidyverse)
#library(tidymodels)
df &lt;- read_csv(&quot;C:\\Users\\wjbur\\Documents\\kaggle\\train.csv&quot;)</code></pre>
<p>About 38% of the passengers survived</p>
<pre class="r"><code>df$Survived %&gt;% table() %&gt;% prop.table()</code></pre>
<pre><code>## .
##         0         1 
## 0.6161616 0.3838384</code></pre>

Work to be continued...
