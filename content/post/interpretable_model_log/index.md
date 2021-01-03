---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Interpretable and Explainable Modeling, Part 1."
subtitle: ""
summary: "What is interpretable and explainable modeling, and how do you do it?"
authors: [Will Burton]
tags: [Data Science, Modeling]
categories: [Data Science, Modeling]
date: 2020-10-11T07:23:31-07:00
lastmod: 2020-10-11T07:23:31-07:00
featured: false
draft: false
math: true

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: "A model simple enough for a child to understand"
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

Over the past few years working in a data science role, one of the areas I've found the most success in is building interpretable and explainable models. Interpretable because I can explain how it arrives at a prediction, explainable because I can clearly describe why certain variables were important. In this post I'll be focusing on models that predict a binary target.

### What is a model?

First off let's talk about models. 
What is a model? by Miriam Webster's definition it is: "A usually miniature representation of something."  For what I'm talking about we can drop the "usually miniature" component. 
There are two examples I want to talk about here:
1. A model car. A model car (or prototype) is a representation of a real car. For example, the Cyber Truck, the one Elon Musk showed off live, was a prototype of the real car. Tesla likely hasn't built a production line for this yet- they're likely still defining specs and components given production constraints. The purpose of these models are the same as a data science model - they are used to make predictions. Maybe for Cyber Truck its purpose is to predict how the public will react to this car if they started mass producing them. Or maybe it is used to understand performance of how the cars perform after driving 300K miles. OR what will happen when I throw a metal ball at the window!! Either way the purpose is to learn something about the actual car before we have the actual car. We are using them to make predictions about what will happen in the future so we want the model to be as close to the real thing as possible. 

<span style="display:block;text-align:center">
<iframe src="https://giphy.com/embed/gLREH1v1Z78tJckuii" width="480" height="272" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/truck-tesla-pickup-gLREH1v1Z78tJckuii">via GIPHY</a></p>
</span>


2. A model to represent lemonade stand profit. If a lemonade stand has total costs of 10 dollars and makes 1 dollar per cup sold, then the mathematical model to represent profit is $$-10 + 1x = profit$$ In this example we are building a mathematical model to represent a real life process. Once we have this model we can start answering questions about that process/phenomena like how many cups do I need to sell to break even, or how many do I need to sell before I can buy an Xbox! 

<span style="display:block;text-align:center">
<iframe src="https://giphy.com/embed/3o7aTvTXlhr9PuWg1i" width="480" height="270" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/dram-music-video-cash-machine-3o7aTvTXlhr9PuWg1i">via GIPHY</a></p>
</span>

This is the same thing we do with a "Data Science Model". We are typically building a mathematical or rule based representation (model) of some real life process/phenomena so that we can start to answer questions about our process/phenomena. Because we want to create a representation of the real life process, for an interpretable and explainable model you need to think of what components make sense to include in the model.

To add onto the lemonade stand example, say we want to predict x, the number of cups sold. We have two variables at our disposal. The number of squirrels in a 100 meter radius, and the temperature outside. When exploring the data you find out that the number of squirrels was the strongest predictor and because of this you build the model only on the number of squirrels. What have you just done?? Do you think squirrel count provides an accurate representation of lemonade sales? While it was useful to predicting in the past it is important to understand how/why it fits into the model when building an interpretable and explainable model. 

OK, the squirrel example is a little crazy, but one time I saw someone use client name as a variable for building a churn model.  NAME?? how can the name of someone (ex. bob vs sam) be predictive of churn? Before dropping all possible variables into XGboost clapping your hands together and saying done, take the time to understand what you are trying to model, think about what variables make sense to use, and physically model it to the best of your ability. This takes time.

### What is an interpretable model?
An interpretable model in a data science context is a model that allows you to understand exactly how it arrives at its predictions (in a reasonable amount of time). To categorize commonly used models (again focusing on binary predictions): <br>

*These are not exhaustive lists* <br>
**Interpretable**
* Decision Tree
* Logistic Regression
* K-Nearest Neighbors

**Not Interpretable** (commonly called black box)
* Support Vector Machines
* Neural Networks
* Random Forest
* Gradient Boosting (common form of this is extreme gradient boosting-xgboost for short)

**The explainable component** is built in using business knowledge. It is the difference between building a churn model based off nonsensical variables like client name vs variables that someone can easily rationalize from a business context.

### When to build an interpretable and explainable model?
A interpretable model should be built any time it is important to explain predictions or to understand which factors are most important and why. Most problems I've worked on have required an interpretable and explainable model. A couple examples include:
* Risk modeling - We needed to be able to tell the stakeholder specific pockets of high risk individuals defined by a few variable cuts. The model needed to be "easy enough to explain to my grandma on the last mile of a half marathon" as described by the primary stakeholder.
* Pricing - We needed to be able to explain to stakeholders why we were charging more for some leads and less for others.
* Fraud - We needed to know why some people would be rejected and others approved.

So far, the only places I've seen black box models in production was in cases where the modeling task was repeated across multiple products and the variable associations with the response were constantly changing (ex. a recommendation engine on a platform that constantly changes). It's a type of problem where you really couldn't have interpretable and explainable models as it would be too expensive to manually build those every time. 


### How to build an interpretable and explainable model? <br>
**Steps** <br>
1. **Understand the business context and typical drivers of the process.** If you want to be able to explain your model you need to understand why certain variables used are important. This should be completed in the beginning through conversations with subject matter experts (SME's).
2. **Understand the
available data.** Working with SME's still, understand what variables could be useful and track down all the data sources.
3. **Explore the data.**
    * Are there missing values?
    * Are there any unexpected patterns?
    * Do any of the trends or values not align with the expected definitions? Ex. we would never expect a variable above a certain value, yet we see those values. Or we would expect weight to be correlated with price, yet we do not.
    * Are there any values that seem like indicators of missingness? Ex. In the workplace I have seen -9, -8, -6, -5, -1, 4, 99999, and 0, all refer to some type of missing or special value. Ignoring these can really deteriorate model performance.
    * What are the variable distributions?  Are any highly skewed? Are there any outliers?
    * Which variables are highly correlated? and which are likely telling you the same information? (Ex. VantageScore, FICO9, FICO4, these are all correlated and measure risk. You can probably just use one of these)
    * What are the covariate's relationship with the response?
    * ... There are many additional unlisted exploration exercises here, the idea here is to feel like you have a strong grasp of the data so when you start modeling there aren't many surprises.
 <br> <br>

4. **Build a list of variable modifications identified during exploration.** Examples include:
    * Income is highly skewed, I'll perform a log transform here.
    * Industry codes A & B have the same % of the response, I can collapse these factor levels into a single level given it makes sense from a business context.
    * Site visits has many 99999 values, I will need to impute new values here and understand what 99999 actually means. <br> <br>
   
	These modifications are meant to either change an existing variable or make a new variable for the purpose to make it easier to model relationships. This step does require some background knowledge around what transformations improve the ability to model a relationship.

<br>

5. **Clean data through learnings in the exploration phase. (The result will be the final training and testing datasets)**
    * This includes making the variable modifications that were identified like log scaling and factor level collapsing.
    * Handle missing values, either impute or exclude columns that are highly missing. If you think there is a possibility they are not missing at random, then create a binary indicator variable flagged 1 for those missing values.
    * If you noticed more complex relationships with the response you could make 2nd order or higher level terms. Ex. income, income^2, income^3, ...
    * Truncate variables that are really thin after a certain range. Ex. If you see income >500K is very rare AND it doesn't seem to influence the response at that point, then you can truncate the data to 500K
    * If you have a particularly large dataset, start to select individual variables out of the highly correlated variables. For example, if you have FICO4, FICO9, FICO8, Transunion VantageScore, Equifax VantageScore then you may just want to include only one of these in modeling. You can use business knowledge here to select a single one (say you know one is the industry standard), or you could run them through some type of variable importance and select the top one. Either way, since they are highly correlated you likely won't be missing out on much by selecting a single one and it will make the modeling process easier later on.
      * If you have say 1000 variables, one of the tricks I've used is hierarchical clustering using correlation as the distance metric. This can create groups in an automated way and help you identify the variables that are largely correlated. <br> <br>
	
5. **Build preliminary models.**
   In this step you're trying to get a sense of predictive performance across a variety of model types. Determine if the variables you expected to be the most important remain the most important. 
    * Run a forwards, backwards, stepwise regression: what variables were kept? Were they consistent? What were the AUC's? The point here is not to pick a final model, but to get a sense of what a typical automated model looks like.
    * Run data through an xgboost or random forest: what was the AUC? and what variables were most important based on variable importance. Did you see a large improvement in the performance metric compared to regression? If so maybe there are more complex relationships at play here.
    * Build a regression model without automated variable selection -- use business knowledge. Take the Occam's Razor approach: out of all competing solutions with comparable accuracy, the simplest one is usually the best.
      * Try out the variables you think should be the most useful based on the relationships seen in the exploration phase. Based on the first two most important variables, how much improvement do you get from the third variable? Is the improvement in accuracy worth the additional complexity? What about after adding the 4th variable, still worth the additional complexity? 
    * Build a decision tree. Are the same variables being used now as were in regression? How does the decision tree AUC compare to Logistic regression? Is the decision tree easy to explain and justify? <br> <br>

6. **Build the final model**
    * Through the preliminary modeling exercises decide between which interpretable model you want to use. I typically lean on logistic regression, but if the data is better structured for a tree (and can still be easily explained) then go with that.
    * At this point, you have a good idea of the accuracy range you can achieve with the data from the most complicated model in step 5. to the simplest. You also have an understanding of the accuracy improvement each additional variable adds. Build the simplest and easiest to explain model that meets all the business constraints and make sure the accuracy is somewhere within the acceptable range. 
    <br> <br>

7. **Can you answer yes to the following questions?**
    * Does the model make sense from a business context and is it easy to explain? 
    * Does it perform better than what you currently have?
    * Do you have a decent idea of how it can go wrong?
    * Will this data and its sources be stable over time?
    * Does it meet all the business requirements?
  
**Then you're DONE!** "All models are wrong, but some are useful" - George Box. You can always improve model performance by tweaking a variable, searching for another data source, modifying the regularization, etc. Once you have a model that solves the problem for the time being, then don't worry about the fact that if you just work a little harder then maybe you can improve the accuracy. This can always be improved and if the business requirements change then you can go back and make modifications.

Part 2. is a working example on how to build an interpretable and explainable model using the classic Titanic dataset.
