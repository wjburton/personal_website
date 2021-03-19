---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Interpretable and Explainable Modeling, Pt 2."
subtitle: "A Step by Step Example"
summary: "Building an interpretable and explainable model on the Titanic dataset, while obtaining a top tier kaggle score."
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
  preview_only: True

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

<figure>
<a title="See page for author, Public domain, via Wikimedia Commons" href="https://commons.wikimedia.org/wiki/File:Titanic_the_sinking.jpg"><img width="777777712" alt="Titanic the sinking" src="https://upload.wikimedia.org/wikipedia/commons/4/4f/Titanic_the_sinking.jpg"></a>
<figcaption> Sinking of the Titanic, 15 April, 1912 
</figure>

In this post I'll be going through code step by step to build an interpretable and explainable model for the famous Titanic Dataset. I first ran into this dataset back around 2012-2013 on [Kaggle](https://www.kaggle.com/), when the site was still in its infancy.

Problem Background (pulled from Kaggle)
>The sinking of the Titanic is one of the most infamous shipwrecks in history.
>
>On April 15, 1912, during her maiden voyage, the widely considered “unsinkable” RMS Titanic sank after colliding with an iceberg. Unfortunately, there weren’t enough lifeboats for everyone on board, resulting in the death of 1502 out of 2224 passengers and crew.
>
>While there was some element of luck involved in surviving, it seems some groups of people were more likely to survive than others.
>
>In this challenge, we ask you to build a predictive model that answers the question: “what sorts of people were more likely to survive?” using passenger data (ie name, age, gender, socio-economic class, etc).


Kaggle also provides a data dictionary here! Such a nice convenience that can be a rarity in the real world. The availabla data includes the following variables:
* **survival** - Survival	0 = No, 1 = Yes
* **pclass** - Ticket class	1 = 1st, 2 = 2nd, 3 = 3rd
* **sex** - Sex	
* **age** -	Age in years	
* **sibsp** - # of siblings / spouses aboard the Titanic	
* **parch** - # of parents / children aboard the Titanic	
* **ticket** - Ticket number	
* **fare** - Passenger fare	
* **cabin** - Cabin number	
* **embarked** - Port of Embarkation C = Cherbourg, Q = Queenstown, S = Southampton

Alright, I have the problem and the data, let's start going through the list of steps outlined in my previous post.

**1. Understand the business context and typical drivers of the process**
Without a subject matter expert available, I'll rely on my knowledge of sociology to think of reasonable drivers. The problem is around predicting who will die in a disaster situation. But there is another important component that makes the titanic different than other disasters. In this case there were decisions made by humans about who would have a spot on a life boat. So part of the survivability is based on who society would have prioritized when loading up the boats.
I have a couple of initial thoughts around the available data:

  * **sex** - Women were likely prioritized over men.
  * **age** - Young children likely prioritized, and elderly potentially de-prioritized. Or maybe elderly would have generally struggled to make it to a boat in this situation.
  * **ticket** - Ticket number doesn't seem like it will be useful, though there could be a pattern with the numbers.  
  * **embarked** - There is a potential that the different cities had different cultures associated making one port more likely than another port (could also be wealth/gender/age differences at each location).
  * **pclass**, **fare** - Wealthy were likely prioritized over the poor. 
  * **cabin** - Certain cabins may have had a harder time reaching the life boats due to location on the Titanic. 
  * **sibsp**, **parch** - Can't think of great reasons why large families vs small families would have a better chance of survival.

 The general story that makes sense, before looking at the data, is that there are three primary components that impact survivability: Gender, Income, and Age. At this point I'm trying to piece together a model in my head and construct a story that can be easily explained to stakeholders (though of course, the data has to tell the same story). 

<br>

**2. Understand the available data**  
Unless I wanted to seek out alternative data, this is all Kaggle provides.

<br>

**3. Explore the data**  
Given the data is relatively small, say < 25 columns, I always start out with a univariate analysis. This includes looking at the variable distributions and noting any interesting observations or potential mutations required. All analysis in this post uses R.

<details><summary>1. Univariate Analysis (click to expand) </summary>

***

<pre class="r"><code>library(tidyverse)
df &lt;- read_csv(&quot;C:\\Users\\wjbur\\Documents\\kaggle\\train.csv&quot;)</code></pre>
<p> Start out with missingness checks: Age is 20% missing and Cabin is the largest offender at 77% missing</p>
<pre class="r"><code>df %&gt;%
  summarise_all(funs(sum(is.na(.))/n()))</code></pre>
<pre><code>## # A tibble: 1 x 12
##   PassengerId Survived Pclass  Name   Sex   Age SibSp Parch Ticket  Fare Cabin
##         &lt;dbl&gt;    &lt;dbl&gt;  &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt;  &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt;
## 1           0        0      0     0     0 0.199     0     0      0     0 0.771
## # ... with 1 more variable: Embarked &lt;dbl&gt;</code></pre>

Now I'll go through each variable's distribution 

*Survived* <br>
<p>About 38% of the passengers survived</p>
<pre class="r"><code>df$Survived %&gt;% table() %&gt;% prop.table()</code></pre>
<pre><code>## Survived
##         0         1 
## 0.6161616 0.3838384</code></pre>

*Pclass*

<p>Decent amount of the population in each class</p>
<pre class="r"><code>df$Pclass %&gt;% table() %&gt;% prop.table()</code></pre>
<pre><code>## Ticket Class 
##         1         2         3 
## 0.2424242 0.2065095 0.5510662</code></pre>

*Sex*
<p>More men on board than women</p>
<pre class="r"><code>df$Sex %&gt;% table() %&gt;% prop.table()</code></pre>
<pre><code>##   female     male 
## 0.352413 0.647587</code></pre>

*Age*
<p>For Age, though about 20% of the values are missing the distribution looks reasonable, no crazy outliers</p>
<pre class="r"><code>df %&gt;% ggplot(aes(x = Age)) + geom_histogram()</code></pre>

<span style="display:block;text-align:center">![](./age.png)</span>

*SibSp*
<p>Most people had no siblings or spouses</p>
<pre class="r"><code>df$SibSp %&gt;% table() %&gt;% prop.table()</code></pre>
<pre><code>##           0           1           2           3           4           5 
## 0.682379349 0.234567901 0.031425365 0.017957351 0.020202020 0.005611672 
##           8 
## 0.007856341</code></pre>

*Parch*
<p>Similarly to SibSp, most people did not have parents or children</p>
<pre class="r"><code>df$Parch %&gt;% table() %&gt;% prop.table()</code></pre>
<pre><code>##           0           1           2           3           4           5 
## 0.760942761 0.132435466 0.089786756 0.005611672 0.004489338 0.005611672 
##           6 
## 0.001122334</code></pre>

*Fare*
<p>One outlier for Fare, but overall, distribution looks about how I would expect</p>
<pre class="r"><code>ggplot(data = df, aes(x=Fare)) + geom_histogram()</code></pre>

<span style="display:block;text-align:center">![](./fare.png)</span>

*Cabin*
<p>For Cabin, it looks like the letters could be indicators for levels of the ship -- this could be important to extract. The numbers could also represent positition on the ship. Ie. 36 could consistently be on the bow across all levels and the bow could have been harder to escape from. or F could represent an even deeper 3rd class ticket than E. Though even with additional exploration here, the variable is nearly 80% missing.</p>
<pre class="r"><code>df$Cabin %&gt;% table() %&gt;% sample(10)</code></pre>
<pre><code>## Cabin 
## E121  D45  E44  B18  F38  B79  D19  C87  C85  C82 
##    2    1    2    2    1    1    1    1    1    1</code></pre>

<p> Extracting cabin letter, there may be some benefit here, but given this variable is largely missing it probably won't provide that much benefit.</p>

<pre class="r"><code>df &lt;- df %&gt;% 
      mutate(cabin_level = stringr::str_extract(Cabin, '[A-Z]')) </code></pre>

<pre class="r"><code>df$cabin_level %&gt;% table()</code></pre>
<pre><code>##  A  B  C  D  E  F  G  T 
## 15 47 59 33 32 13  4  1</code></pre>

*Embarked*
<p>People largely came from Southhampton</p>
<pre class="r"><code>df$Embarked %&gt;% table() %&gt;% prop.table()</code></pre>
<pre><code>##          C          Q          S 
## 0.18897638 0.08661417 0.72440945</code></pre>

*Name*
<p>In name, we do have title which could be useful for extraction. Maybe doctors were less likely to survive, or married women more likely to survive than single women.</p>
<pre class="r"><code>df$Name %&gt;% table() %&gt;% sample(10)</code></pre>
<pre><code>##           Maisner, Mr. Simon   Carter, Mr. William Ernest 
##                            1                            1 
## Hegarty, Miss. Hanora &quot;Nora&quot;           Gale, Mr. Shadrach 
##                            1                            1 
##        Yousseff, Mr. Gerious Rush, Mr. Alfred George John 
##                            1                            1 
##    Brewe, Dr. Arthur Jackson   Fortune, Miss. Mabel Helen 
##                            1                            1 
##       Celotti, Mr. Francesco             Duane, Mr. Frank 
##                            1                            1</code></pre>

*Title* (Extracted variable)
<pre class="r"><code>df &lt;- df %&gt;% 
      mutate(title = stringr::str_extract(Name,&quot;[A-Za-z]+\\.&quot;))</code></pre>
<p>We could gain additional value if Master, or the distinction between Miss and Mrs are important. The others likely have too small of a sample size to draw conclusions from.</p>
<pre class="r"><code>df$title %&gt;% table()</code></pre>
<pre><code>## .
##     Capt.      Col. Countess.      Don.       Dr. Jonkheer.     Lady.    Major. 
##         1         2         1         1         7         1         1         2 
##   Master.     Miss.     Mlle.      Mme.       Mr.      Mrs.       Ms.      Rev. 
##        40       182         2         1       517       125         1         6 
##      Sir. 
##         1</code></pre>

*Ticket*
<p>There could be some more exploration later on to analyze ticket number or to see if the Prefix's like CA are important. When looking at the full table there were a decent amount of tickets to start with PC, C.A., A/5, SOTON, SC, F.C.C. It is unclear what these mean at this point. There are also duplicated ticket numbers, which could be indicating a group purchase.</p>
<pre class="r"><code>df$Ticket %&gt;% table() %&gt;% sample(20)</code></pre>
<pre><code>## .
##        PC 17760          230080        A/5. 851      C.A. 33111      A./5. 2152 
##               3               3               1               1               1 
## SC/AH Basle 541         3101281           29103          349225          113514 
##               1               1               1               1               1 
##           36963          349228        PC 17612            2683 SOTON/OQ 392089 
##               1               1               1               1               1 
##           65303            2686          113788           29751          113510 
##               1               1               1               1               1</code></pre>


**Done with Univariate Analysis**

***

</details>
 <br>

After a univatiate analysis, I then want to look at each variables association with the response, what I'm calling bivariate analysis. This will be a critical component to be able to explain the model.

<details><summary>2. Bivariate Analysis </summary>

***

*Pclass vs Survived* <br>
As expected, the higher class a passenger was, the more likely they were to survive.
<pre class="r"><code>pclass_tbl &lt;- table(df$Survived, df$Pclass)
chisq.test(pclass_tbl)</code></pre>
<pre><code>##  Pearson's Chi-squared test
## 
## data:  pclass_tbl
## X-squared = 102.89, df = 2, p-value &lt; 2.2e-16</code></pre>
<pre class="r"><code>prop.table(pclass_tbl, 2)</code></pre>
<pre><code>##             1         2         3
##   0 0.3703704 0.5271739 0.7576375
##   1 0.6296296 0.4728261 0.2423625</code></pre>

*Sex vs Survived*

<p>As expected, Females were far more likely to survive with the male death rate close to 81% while the female death rate was about 26%.</p>
<pre class="r"><code>sex_tbl &lt;- table(df$Survived, df$Sex)
chisq.test(sex_tbl)</code></pre>
<pre><code>##  Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  sex_tbl
## X-squared = 260.72, df = 1, p-value &lt; 2.2e-16</code></pre>
<pre class="r"><code>prop.table(sex_tbl, 2)</code></pre>
<pre><code>##        female      male
##   0 0.2579618 0.8110919
##   1 0.7420382 0.1889081</code></pre>

*Age vs Survived* <br>

As expected, the older a passenger was, the less likely they were to survive.
<pre class="r"><code>plot_continuous(df$Age, n = 50, response = df$Survived, max_poly_degree = 1,
                log_odds = F, jitter_height = .025, variable_name = 'Age')</code></pre>

<span style="display:block;text-align:center">![](./age_vs_survived.png)</span>

This chart is built by a custom R function I wrote. The blue points represent the actual data points, 0's (bottom) and 1's (top). The black dots represent an aggregation of the blue points. The blue line represents a fitted logistic regression curve (while the line looks linear, if you were to extend the x-axis, you would find that it follows an S curve). I use this chart all the time to understand variable relationships with the response.

*Fare vs Survived*

As expected, a higher fare price resulted in a higher likelihood of survival.
<pre class="r"><code>## Replacing 0 with 7 so that 0 ticket values aren't predicted far less than a ticket with an actual value. It wasn't clear if 0 could be a missing indicator either.
## As a quick and dirty method, I'll just modify the values to 7 which is on the lower tail of fare values.
df&lt;- df %&gt;% mutate(fare_mod = ifelse(Fare == 0, 7, Fare))

plot_continuous(log(df$fare_mod), n = 50, response = df$Survived, max_poly_degree = 1,
                log_odds = F, jitter_height = .025, variable_name = 'Fare')</code></pre>

<span style="display:block;text-align:center">![](./fare_vs_survived.png)</span>

*SibSp vs Survived* <br>

While the Chi-Squared test shows there is a significant difference in survivability among these levels, there is not a consistent trend (With one additional sibling or spouse we don't see a consistent increase or decrease in survivability) or an obvious reason as to why this is an important variable. 
<pre class="r"><code>sibsp_tbl &lt;- table(df$Survived, df$SibSp)
chisq.test(sibsp_tbl)</code></pre>
<pre><code>##  Pearson's Chi-squared test
## 
## data:  sibsp_tbl
## X-squared = 37.272, df = 6, p-value = 1.559e-06</code></pre>
<pre class="r"><code>prop.table(sibsp_tbl, 2)</code></pre>
<pre><code>##             0         1         2         3         4         5         8
##   0 0.6546053 0.4641148 0.5357143 0.7500000 0.8333333 1.0000000 1.0000000
##   1 0.3453947 0.5358852 0.4642857 0.2500000 0.1666667 0.0000000 0.0000000</code></pre>

*Parch vs Survived* <br>

Similarly to SibSp, the Chi-Squared test shows there is a significant difference in survivability these levels, but there is no clear trend or obvious reason as to why this could be happening.
<pre class="r"><code>parch_tbl &lt;- table(df$Survived, df$Parch)
chisq.test(parch_tbl)</code></pre>
<pre><code>##  Pearson's Chi-squared test
## 
## data:  parch_tbl
## X-squared = 27.926, df = 6, p-value = 9.704e-05</code></pre>
<pre class="r"><code>prop.table(parch_tbl, 2)</code></pre>
<pre><code>##             0         1         2         3         4         5         6
##   0 0.6563422 0.4491525 0.5000000 0.4000000 1.0000000 0.8000000 1.0000000
##   1 0.3436578 0.5508475 0.5000000 0.6000000 0.0000000 0.2000000 0.0000000</code></pre>

*Embarked vs Survived* <br>

<p>While the Chi-Squared test shows there is a significant difference in survivability among these levels they don't seem to be very important, and would also require more investigation to be able to explain why one location changes the survival likelihood. </p>
<pre class="r"><code>embarked_tbl &lt;- table(df$Survived, df$Embarked)
chisq.test(embarked_tbl)</code></pre>
<pre><code>## Pearson's Chi-squared test
## 
## data:  embarked_tbl
## X-squared = 26.489, df = 2, p-value = 1.77e-06</code></pre>
<pre class="r"><code>prop.table(embarked_tbl, 2)</code></pre>
<pre><code>##      C         Q         S
##   0 0.4464286 0.6103896 0.6630435
##   1 0.5535714 0.3896104 0.3369565</code></pre>

*Title vs Survived* <br>

<p>It looks like married women have a better chance of surviving than single women and on the male side, other titles aside from plain Mr. (especially more prestigious titles) had much higher survival rate. </p>
<pre class="r"><code>title_tbl &lt;- table(df$Survived, df$title)
chisq.test(title_tbl)</code></pre>
<pre><code>## Pearson's Chi-squared test
## 
## data:  title_tbl
## X-squared = 300.02, df = 16, p-value &lt; 2.2e-16</code></pre>
<pre class="r"><code>prop.table(title_tbl, 2)</code></pre>
<pre><code>##         Capt.      Col. Countess.      Don.       Dr. Jonkheer.     Lady.
##   0 1.0000000 0.5000000 0.0000000 1.0000000 0.5714286 1.0000000 0.0000000
##   1 0.0000000 0.5000000 1.0000000 0.0000000 0.4285714 0.0000000 1.0000000
##    
##        Major.   Master.     Miss.     Mlle.      Mme.       Mr.      Mrs.
##   0 0.5000000 0.4250000 0.3021978 0.0000000 0.0000000 0.8433269 0.2080000
##   1 0.5000000 0.5750000 0.6978022 1.0000000 1.0000000 0.1566731 0.7920000
##    
##           Ms.      Rev.      Sir.
##   0 0.0000000 1.0000000 0.0000000
##   1 1.0000000 0.0000000 1.0000000</code></pre>

*Cabin vs Survived* <br>

<p>These don't follow a clear trend, are highly missing, aren't super explainable, and aren't stat sig.</p>
<pre class="r"><code>cabin_tbl &lt;- table(df$Survived, df$cabin_level)
chisq.test(cabin_tbl)</code></pre>
<pre><code>##  Pearson's Chi-squared test
## 
## data:  cabin_tbl
## X-squared = 10.301, df = 7, p-value = 0.1722</code></pre>
<pre class="r"><code>prop.table(cabin_tbl, 2)</code></pre>
<pre><code>##             A         B         C         D         E         F         G
##   0 0.5333333 0.2553191 0.4067797 0.2424242 0.2500000 0.3846154 0.5000000
##   1 0.4666667 0.7446809 0.5932203 0.7575758 0.7500000 0.6153846 0.5000000
##    
##             T
##   0 1.0000000
##   1 0.0000000</code></pre>

***

</details>
<br>

I've done a base level of exploration here, enough to have a decent grasp on the variables and an understanding of their usefulness.
Intuition matched the data (whew -- this often doesn't happen). Sex is largely important, and title can provide another useful split within a gender. Wealth is an important factor which will be indicated by either pclass or fare, and I'm skeptical that including both will be much more beneficial than selecting only one. Age was also important, as expected.

At this point if I can build a model around Age, Sex, and Wealth, the model should be robust and explainable. The other variables may add some value but if they aren't largely beneficial, the additional complexity probably isn't worth adding in.

<br>

**4. Build a list of variable modifications identified during exploration.** 
* Impute $7 for $0 amounts and then log scale. A log scale is important to properly model the relationship. The $7 imputation is a quick and dirty method to not allow outlier values to add bias to a model fit.
* Exctract title from name and create binary flags for 1. prestigious male titles, 2. married women, 3. single women
* Impute mean age for missing age values

This list is typically much longer, but this data was relatively clean and had a limited number of columns.

<br>

**5. Clean data through learnings in the exploration phase. (The result will be the final training and testing datasets)**


<details><summary> Cleaning Code </summary>
<pre class="r"><code># dr is classified as male here as 1906 had a very low % of female medical practicioners
# baseline will be a normal male in 2nd class

train_df <- df %>% 
  mutate(title  = stringr::str_extract(Name,"[A-Za-z]+\\."),
         fare_mod = log(ifelse(Fare == 0, 7, Fare)),
         Survived = factor(Survived),
         age_mod = ifelse(is.na(Age),mean(df$Age, na.rm = TRUE), Age),
         male_special = ifelse(tolower(title) %in% c('col.','dr.','master.', 'major.', 'sir.') & Sex == 'male', 1,0),
         female_single = ifelse(tolower(title) %in% c('miss.', 'mlle.', 'mme.') & Sex == 'female',1,0),
         female_married = ifelse(female_single == 0 & Sex == 'female',1,0),
         first_class = ifelse(Pclass == 1, 1, 0),
         third_class = ifelse(Pclass == 3, 1, 0),
         Embarked = ifelse(is.na(Embarked),"S",Embarked), #Replacing missing embarked with most common location
         Embarked = factor(Embarked),
         Sex = factor(Sex),
         title = factor(title)) %>% 
  select(-one_of('Pclass', 'PassengerId', 'Name', 'Ticket', 'Cabin', 'cabin_level', "Age"))


test_df <- read_csv('test.csv')

test_df_clean <- test_df %>% 
  mutate(title  = stringr::str_extract(Name,"[A-Za-z]+\\."),
         fare_mod = log(ifelse(Fare == 0, 7, Fare)),
         age_mod = ifelse(is.na(Age),mean(df$Age, na.rm = TRUE), Age),
         male_special = ifelse(tolower(title) %in% c('col.','dr.','master.', 'major.', 'sir.') & Sex == 'male', 1,0),
         female_single = ifelse(tolower(title) %in% c('miss.', 'mlle.', 'mme.') & Sex == 'female',1,0),
         female_married = ifelse(female_single == 0 & Sex == 'female',1,0),
         first_class = ifelse(Pclass == 1, 1, 0),
         third_class = ifelse(Pclass == 3, 1, 0),
         Embarked = ifelse(is.na(Embarked),"S",Embarked), #Replacing missing embarked with most common location
         Embarked = factor(Embarked),
         Sex = factor(Sex),
         title = factor(title)) %>% 
  select(-one_of('Pclass', 'PassengerId', 'Name', 'Ticket', 'Cabin', "Age"))

</code></pre>


</details>

<br>

**6. Build preliminary models** <br>
In this step I'm building a variety of models to get an understanding of the range of performance across model types. I'm also determing which set of variables should be used and which to cut out.

<details><summary> Preliminary Modeling </summary>

Build forwards, backwards, and stepwise logistic regression models

<pre class="r"><code>#define full logistic model
full_logistic_mod <- glm(Survived ~ ., data = train_df %>% select(-one_of("Sex", "title")), family = binomial)

#define empty model
nothing <- glm(Survived ~ 1,data =  train_df %>% select(-one_of("Sex", "title")), family = binomial)

#preform backwards, forwards, and stepwise selection, while optimizing AIC
backwards <-stats::step(full_logistic_mod, trace = 0) # Backwards selection is the default
forwards <- stats::step(nothing,
                 scope=list(lower=formula(nothing),upper=formula(full_logistic_mod)), direction="forward", trace = 0)
stepwise <- stats::step(nothing, list(lower=formula(nothing),upper=formula(full_logistic_mod)),
                 direction="both",trace=0)
	
</code></pre>
The automated regression models ended up all the same and each only dropped one variable, embarked. It's a little odd to me that even after accounting for age, wealth, and gender, that sibling and parent counts were still considered important. Though, from past experience, these automated techniques are generally more inclusive than I'd want to be. To be clear, at this point I'm not fully ignoring those variables. If the data says they are important then I can't just ignore them.

Now I'll create more flexible and complex models using XGboost and Random Forest. I'm not doing any tuning here, just using defaults. The solution I deliver will not be with these model types, but it is good to know what the performance range can be. They can tell me if a simple model obviously doesn't capture the patterns in the data. For example, if AUC with logistic regression is 0.65 and XGboost is 0.85 then clearly logistic regression is missing out on an important pattern.

<pre class="r"><code>library(xgboost)
#XGboost model
response <- train_df$Survived %>% as.character() %>% as.numeric
train_mat <- model.matrix(~.+0,data = train_df %>% select(-Survived), with = F)

#Preparing Matrix
dtrain <- xgb.DMatrix(data = train_mat,label = response)

#Want to use cross validation to measure performance since XGboost can be prone to overfitting
xgbcv <- xgb.cv(data = dtrain
                ,nrounds = 100
                ,nfold = 5
                ,showsd = T
                ,stratified = T
                ,print_every_n = 5
                ,early_stop_round = 20
                ,eval_metric = "auc"
                ,booster = "gbtree"
                ,objective = "binary:logistic"
)

#At 21 rounds XGboost had a test AUC of 0.874
xgb_mod <- xgb.train(
          ,data = dtrain
          ,nrounds = 21
          ,print_every_n = 10
          ,eval_metric = "auc"
)

</code></pre>

</details>
 
<br>

**7. Build the final model**

Step 8. as described previously doesn't apply in this case, so all that is left to do is present the model to stakeholders (Kaggle).


The submission puts the model at an accuracy score of 78.46%, close to the 80.1% I saw in the training set. This score lands the interpretable and explainable model in the top 12.5% of all submissions. In explaining the model I can






submission_df &lt;- data.frame(PassengerId = test_df_clean$PassengerId, 
                            Survived = ifelse(predict(mod_no_fare, test_df_clean, type = 'response') &gt;= 0.5,1,0))

write.csv(submission_df, 'submission_file.csv', row.names = F)</code></pre>
<p>At this point I have likely gotten most of the value without putting in a ton of additional effort to squeak out a few more percentage points.</p>
</div>





