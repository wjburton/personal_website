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
df &lt;- read_csv(&quot;C:\\Users\\wjbur\\Documents\\kaggle\\train.csv&quot;)</code></pre>
<p>Missingness checks: Age is 20% missing and Cabin is the largest offender at 77% missing</p>
<pre class="r"><code>df %&gt;%
  summarise_all(funs(sum(is.na(.))/n()))</code></pre>
<pre><code>## # A tibble: 1 x 12
##   PassengerId Survived Pclass  Name   Sex   Age SibSp Parch Ticket  Fare Cabin
##         &lt;dbl&gt;    &lt;dbl&gt;  &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt;  &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt;
## 1           0        0      0     0     0 0.199     0     0      0     0 0.771
## # ... with 1 more variable: Embarked &lt;dbl&gt;</code></pre>
<p>About 38% of the passengers survived</p>
<pre class="r"><code>df$Survived %&gt;% table() %&gt;% prop.table()</code></pre>
<pre><code>## .
##         0         1 
## 0.6161616 0.3838384</code></pre>
<p>Decent amount of the population in each class</p>
<pre class="r"><code>df$Pclass %&gt;% table() %&gt;% prop.table()</code></pre>
<pre><code>## .
##         1         2         3 
## 0.2424242 0.2065095 0.5510662</code></pre>
<p>More male than female</p>
<pre class="r"><code>df$Sex %&gt;% table() %&gt;% prop.table()</code></pre>
<pre><code>## .
##   female     male 
## 0.352413 0.647587</code></pre>
<p>There are a good bit of missing values but the distribution looks reasonable, no crazy outliers</p>
<pre class="r"><code>df %&gt;% ggplot(aes(x = Age)) + geom_histogram()</code></pre>
<pre><code>## Warning: Removed 177 rows containing non-finite values (stat_bin).</code></pre>
<p><img src="" width="672" /></p>
<p>Most people had no siblings or spouses, data again reasonable</p>
<pre class="r"><code>df$SibSp %&gt;% table() %&gt;% prop.table()</code></pre>
<pre><code>## .
##           0           1           2           3           4           5 
## 0.682379349 0.234567901 0.031425365 0.017957351 0.020202020 0.005611672 
##           8 
## 0.007856341</code></pre>
<p>Similarly, most people did not have parents or children</p>
<pre class="r"><code>df$Parch %&gt;% table() %&gt;% prop.table()</code></pre>
<pre><code>## .
##           0           1           2           3           4           5 
## 0.760942761 0.132435466 0.089786756 0.005611672 0.004489338 0.005611672 
##           6 
## 0.001122334</code></pre>
<p>One outlier for Fare, but again, distribution looks about how I would expect</p>
<pre class="r"><code>ggplot(data = df, aes(x=Fare)) + geom_histogram()</code></pre>
<p><img src="" width="672" /></p>
<p>In Cabin, it looks like the letters could be indicators for levels of the ship -- this could be important to extract. The numbers could also represent positition on the ship. Ie. 36 could consistently be on the bow on all levels and the bow could have been harder to escape from.</p>
<pre class="r"><code>df$Cabin %&gt;% table() %&gt;% sample(10)</code></pre>
<pre><code>## .
## E121  D45  E44  B18  F38  B79  D19  C87  C85  C82 
##    2    1    2    2    1    1    1    1    1    1</code></pre>
<p>People largely came from Southhampton</p>
<pre class="r"><code>df$Embarked %&gt;% table() %&gt;% prop.table()</code></pre>
<pre><code>## .
##          C          Q          S 
## 0.18897638 0.08661417 0.72440945</code></pre>
<p>In name we do have title which could be useful for extraction. Maybe Doctors were less likely to survive, or married women more likely to survive than single women.</p>
<pre class="r"><code>df$Name %&gt;% table() %&gt;% sample(10)</code></pre>
<pre><code>## .
##           Maisner, Mr. Simon   Carter, Mr. William Ernest 
##                            1                            1 
## Hegarty, Miss. Hanora &quot;Nora&quot;           Gale, Mr. Shadrach 
##                            1                            1 
##        Yousseff, Mr. Gerious Rush, Mr. Alfred George John 
##                            1                            1 
##    Brewe, Dr. Arthur Jackson   Fortune, Miss. Mabel Helen 
##                            1                            1 
##       Celotti, Mr. Francesco             Duane, Mr. Frank 
##                            1                            1</code></pre>
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
<p>Clean up/create new variables identified through initial exploration</p>
<pre class="r"><code>df &lt;- df %&gt;% 
      mutate(cabin_level = stringr::str_extract(Cabin, '[A-Z]'),
             title = stringr::str_extract(Name,&quot;[A-Za-z]+\\.&quot;))</code></pre>
<p>We could gain additional value if Master, or the distinction between Miss and Mrs are important. The others likely have too small of a sample size to draw conclusions from.</p>
<pre class="r"><code>df$title %&gt;% table()</code></pre>
<pre><code>## .
##     Capt.      Col. Countess.      Don.       Dr. Jonkheer.     Lady.    Major. 
##         1         2         1         1         7         1         1         2 
##   Master.     Miss.     Mlle.      Mme.       Mr.      Mrs.       Ms.      Rev. 
##        40       182         2         1       517       125         1         6 
##      Sir. 
##         1</code></pre>
<p>There may be some benefit here, but given this variable is largely missing it probably won't provide that much benefit.</p>
<pre class="r"><code>df$cabin_level %&gt;% table()</code></pre>
<pre><code>## .
##  A  B  C  D  E  F  G  T 
## 15 47 59 33 32 13  4  1</code></pre>
<div id="variable-associations-with-the-response" class="section level3">
<h3>Variable Associations with the Response</h3>
<pre class="r"><code>df %&gt;% colnames()</code></pre>
<pre><code>##  [1] &quot;PassengerId&quot; &quot;Survived&quot;    &quot;Pclass&quot;      &quot;Name&quot;        &quot;Sex&quot;        
##  [6] &quot;Age&quot;         &quot;SibSp&quot;       &quot;Parch&quot;       &quot;Ticket&quot;      &quot;Fare&quot;       
## [11] &quot;Cabin&quot;       &quot;Embarked&quot;    &quot;cabin_level&quot; &quot;title&quot;</code></pre>
<p>As expected, the higher class a passenger was, the more likely they were to survive</p>
<pre class="r"><code>pclass_tbl &lt;- table(df$Survived, df$Pclass)
chisq.test(pclass_tbl)</code></pre>
<pre><code>## 
##  Pearson's Chi-squared test
## 
## data:  pclass_tbl
## X-squared = 102.89, df = 2, p-value &lt; 2.2e-16</code></pre>
<pre class="r"><code>prop.table(pclass_tbl, 2)</code></pre>
<pre><code>##    
##             1         2         3
##   0 0.3703704 0.5271739 0.7576375
##   1 0.6296296 0.4728261 0.2423625</code></pre>
<p>As expected, Females were far more likely to survive with the male death rate close to 81%</p>
<pre class="r"><code>sex_tbl &lt;- table(df$Survived, df$Sex)
chisq.test(sex_tbl)</code></pre>
<pre><code>## 
##  Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  sex_tbl
## X-squared = 260.72, df = 1, p-value &lt; 2.2e-16</code></pre>
<pre class="r"><code>prop.table(sex_tbl, 2)</code></pre>
<pre><code>##    
##        female      male
##   0 0.2579618 0.8110919
##   1 0.7420382 0.1889081</code></pre>
<p>Age</p>
<pre class="r"><code>plot_continuous(df$Age, n = 50, response = df$Survived, max_poly_degree = 1,
                log_odds = F, jitter_height = .025, variable_name = 'Age')</code></pre>
<pre><code>## `summarise()` ungrouping output (override with `.groups` argument)</code></pre>
<p><img src=""/></p>
<p>For a fare of 0, what is the probability?</p>
<pre class="r"><code>df&lt;- df %&gt;% mutate(fare_mod = ifelse(Fare == 0, 7, Fare))

plot_continuous(log(df$fare_mod), n = 50, response = df$Survived, max_poly_degree = 1,
                log_odds = F, jitter_height = .025, variable_name = 'Fare')</code></pre>
<pre><code>## `summarise()` ungrouping output (override with `.groups` argument)</code></pre>
<p><img src="<<pre class="r"><code>df %&gt;% 
group_by(SibSp, Survived) %&gt;% 
summarise(n = n()) %&gt;% 
spread(SibSp, n) %&gt;% 
summarise_all(funs(./sum(., na.rm = TRUE)))</code></pre>
<pre><code>## `summarise()` regrouping output by 'SibSp' (override with `.groups` argument)</code></pre>
<pre><code>## # A tibble: 2 x 8
##   Survived   `0`   `1`   `2`   `3`   `4`   `5`   `8`
##      &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt;
## 1        0 0.655 0.464 0.536  0.75 0.833     1     1
## 2        1 0.345 0.536 0.464  0.25 0.167    NA    NA</code></pre>
<p>Very similar associations between sibsp and Parch</p>
<pre class="r"><code>df %&gt;% 
group_by(Parch, Survived) %&gt;% 
summarise(n = n()) %&gt;% 
spread(Parch, n) %&gt;% 
summarise_all(funs(./sum(., na.rm = TRUE)))</code></pre>
<pre><code>## `summarise()` regrouping output by 'Parch' (override with `.groups` argument)</code></pre>
<pre><code>## # A tibble: 2 x 8
##   Survived   `0`   `1`   `2`   `3`   `4`   `5`   `6`
##      &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt;
## 1        0 0.656 0.449   0.5   0.4     1   0.8     1
## 2        1 0.344 0.551   0.5   0.6    NA   0.2    NA</code></pre>
<p>The Embarked locations don't seem to be very important, and would also require more investigation to be able to explain why one location changes the survivability likelihood</p>
<pre class="r"><code>df %&gt;% 
group_by(Embarked, Survived) %&gt;% 
summarise(n = n()) %&gt;% 
spreasummarise_all(funs(./sum(., na.rm = TRUE)))</code></pre>
<pre><code>## `summarise()` regrouping output by 'Embarked' (override with `.groups` argument)</code></pre>
<pre><code>## # A tibble: 2 x 5
##   Survived     C     Q     S ##      &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt;  &lt;dbl&gt;
## 1        0 0.446 0.610 0.663     NA
## 2        1 0.554 0.390 0.337      1</code></pre>
<p>It looks like married women have a better chance of surviving than single women and on the ma<pre class="r"><code>df %&gt;% 
group_by(title, Survived) %&gt;% 
summarise(n = n()) %&gt;% 
spread(title, n) %&gt;% 
summarise_all(funs(./sum(., na.rm = TRUE)))</code></pre>
<pre><code>## `summarise()` regrouping output by 'title' (override with `.groups` argument)</code></pre>
<pre><code>## # A tibble: 2 x 18
##   Survived Capt.  Col. Countess.  Don.   Dr. Jonkheer. Lady. Major. Master.
##      &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt;     &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt;     &lt;dbl&gt; &lt;dbl&gt;  &lt;dbl&gt;   &## 1        0     1   0.5        NA     1 0.571         1    NA    0.5   0.425
## 2        1    NA   0.5         1    NA 0.429        NA     1    0.5   0.575
## # ... with 8 more variables: Miss. &lt;dbl&gt;, Mlle. &lt;dbl&gt;, Mme. &lt;dbl&gt;, Mr. &lt;dbl&gt;,
## #   Mrs. &lt;dbl&gt;, Ms. &lt<<pre class="r"><code>df %&gt;% 
group_by(cabin_level, Survived) %&gt;% 
summarise(n = n()) %&gt;% 
spread(cabin_level, n) %&gt;% 
summarise_all(funs(./sum(., na.rm = TRUE)))</code></pre>
<pre><code>## `summarise()` regrouping output by 'cabin_level' (override with `.groups` argument)</code></pre>
<pre><code>## # A tibble: 2 x 10
##   Survived     A     B     C     D     E     F     G     T `&lt;NA&gt;`
##      &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt;  &lt;dbl&gt;
## 1        0 0.533 0.255 0.407 0.242  0.25 0.385   0.5     1  0.700
## 2        1 0.467 0.745 0.593 0.758  0.75 0.615   0.5    NA  0.300</code></pre>
<p>Alright, I've done some base level exploration here, but enough to build a fairly simple and explainable model</p>
<p>Intuition so far says that ge<<<pre class="r"><code># dr is classified as male here as 1906 had# baseline will be a normal male in 2nd class
train_df &lt;- df %&gt;% 
  mutate(title  = stringr::str_extract(Name,&quot;[A-Za-z]+\\.&quot;),
         fare_mod = log(ifelse(Fare == 0, 7, Fare)),
         Survived = factor(Survived),
         age_mod = ifelse(is.na(Age),mean(df$Age, na.rm = TRUE),           female_married = ifelse(female_single == 0 &amp; Sex == 'female',1,0),
         first_class = ifelse(Pclass == 1, 1, 0),
         third_class = ifelse(Pclass == 3, 1, 0)) </code></pre>
<p>Testing a couple of model options</p>
<pre class="r"><code>mod_fare &lt;- glm(Survived~fare_mod + first_class + third_class + male_spe           data = train_df,
           family = 'binomial')

mod_no_fare &lt;- glm(Survived~ first_class + third_class + male_special + female_single + female_married + age_mod, 
           data = train_df,
           family = 'binomial')</code></pre>
<p>At a high level, the model looks pretty good so far. I may wa<pre class="r"><code>summary(mod_fare)</code></pre>
<pre><code>## 
## Call:
## glm(formula = Survived ~ fare_mod + first_class + third_class + 
##     male_special + female_single + female_married + age_mod, 
##     family = &quot;binomial&quot;, data = train_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.4199  -0.6200  -0.3842   0.5818   2.5169  
## 
## Coefficients:
##                 Estimate Std. Error z value Pr(&gt;|z|)    
## (Intercept)     0.057356   0.544728   0.105 0.916143    
## fare_mod       -0.264081   0.150355  -1.756 0.079023 .  
## first_class     1.471140   0.332662   4.422 9.76e-06 ***
## third_class    -1.251446   0.244278  -5.123 3.01e-07 ***
## male_special    1.838673   0.366809   5.013 5.37e-07 ***
## female_single   2.724527   0.234758  11.606  &lt; 2e-16 ***
## female_married  3.316174   0.289746  11.445  &lt; 2e-16 ***
## age_mod        -0.027031   0.008214  -3.291 0.000999 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1186.66  on 890  degrees of freedom
## Residual deviance:  774.04  on 883  degrees of freedom
## AIC: 790.04
## 
## Number of Fisher Scoring iterations: 5</code></pre>
<pre class="r"><code>summary(mod_no_fare)</code></pre>
<pre><code>## 
## Call:
## glm(formula = Survived ~ first_class + third_class + male_special + 
##     female_single + female_married + age_mod, family = &quot;binomial&quot;, 
##     data = train_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.4815  -0.6470  -0.3803   0.5909   2.4571  
## 
## Coefficients:
##                 Estimate Std. Error z value Pr(&gt;|z|)    
## (Intercept)    -0.716318   0.323568  -2.214  0.02684 *  
## first_class     1.136089   0.269495   4.216 2.49e-05 ***
## third_class    -1.140522   0.234173  -4.870 1.11e-06 ***
## male_special    1.694949   0.352369   4.810 1.51e-06 ***
## female_single   2.661523   0.231850  11.479  &lt; 2e-16 ***
## female_married  3.171657   0.274677  11.547  &lt; 2e-16 ***
## age_mod        -0.024704   0.008057  -3.066  0.00217 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1186.66  on 890  degrees of freedom
## Residual deviance:  777.19  on 884  degrees of freedom
## AIC: 791.19
## 
## Number of Fisher Scoring iterations: 5</code></pre>
<pre class="r"><code>fare_probs &lt;- predict(mod_fare, train_df, type = 'response')
no_fare_probs &lt;- predict(mod_no_fare, train_df, type = 'response')</code></pre>
<p>Test Performance</p>
<pre class="r"><code>#Calculate Ensemble ROC curve
logistic_roc_fare &lt;- calculate_ROC(probs = fare_probs, response = train_df$Survived, name =  'Fare')</code></pre>
<pre><code>## Setting levels: control = 0, case = 1</code></pre>
<pre><code>## Setting direction: controls &lt; cases</code></pre>
<pre class="r"><code>logistic_roc_no_fare &lt;- calculate_ROC(probs = no_fare_probs, response = train_df$Survived, name =  'No Fare')</code></pre>
<pre><code>## Setting levels: control = 0, case = 1
## Setting direction: controls &lt; cases</code></pre>
<pre class="r"><code>rocs &lt;- rbind(logistic_roc_fare, logistic_roc_no_fare)</code></pre>
<pre class="r"><code>ggplot(rocs, aes(x = M1SPEC, y = SENSIT)) + geom_line(aes(color = name), lwd = 1.3, alpha= 0.5) + 
  geom_abline(slope = 1, intercept = 0) + xlim(0,1) + ylim(0,1) + ggtitle('logistic  ROC Curve') + 
  theme(plot.title = element_text(hjust = 0.5))</code></pre>
<p><img src="">
t<###<(<<<<###   PassengerId = col_double(),
##   Pclass = col_double(),
##   Name = col_character(),
##   Sex = col_character(),
##   Age = col_double(),
##   SibSp = col_double(),
##   Parch = col_double(),
##   Ticket = col_character(),
##   Fare = col_double(),
##   Cabin = col_character(),
##   Embarked = col_character()
## )</code></pre>
<pre class="r"><code>test_df_clean &lt;- test_df %&gt;% 
  mutate(title  = stringr::str_extract(Name,&quot;[A-Za-z]+\\.&quot;),
         fare_mod = log(ifelse(Fare == 0, 7, Fare)),
         age_mod = ifelse(is.na(Age),mean(df$Age, na.rm = TRUE), Age),
         male_special = ifelse(tolower(title) %in% c('col.','dr.','master.', 'major.', 'sir.') &amp; Sex == 'male', 1,0),
         female_single = ifelse(tolower(title) %in% c('miss.','ms.', 'mlle.', 'mme.') &amp; Sex == 'female',1,0),
         female_married = ifelse(female_single == 0 &amp; Sex == 'female',1,0),
         first_class = ifelse(Pclass == 1, 1, 0),
         third_class = ifelse(Pclass == 3, 1, 0))

submission_df &lt;- data.frame(PassengerId = test_df_clean$PassengerId, 
                            Survived = ifelse(predict(mod_no_fare, test_df_clean, type = 'response') &gt;= 0.5,1,0))

write.csv(submission_df, 'submission_file.csv', row.names = F)</code></pre>
<p>This submission puts the model at an accuracy score of 78.46%, close to the 80.1% I saw in the training set! In Addition, this model only took two hours to build from exploration to final result. With this submission, we ranked 2,195 out of 16,886 - Landing this result in the top 12.5% of submissions.</p>
<p>At this point I have likely gotten most of the value without putting in a ton of additional effort to squeak out a few more percentage points.</p>
</div>





