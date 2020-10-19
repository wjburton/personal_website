---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Interpretable and Explainable Modeling"
subtitle: ""
summary: ""
authors: []
tags: []
categories: []
date: 2020-10-11T07:23:31-07:00
lastmod: 2020-10-11T07:23:31-07:00
featured: false
draft: false
math: true

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

Over the few years working in a data science role, one of the areas I've found the most success is in building interpretable and explainable models. Interpretable because I can explain how it arrives at a prediction, explainable because I can explain why certain variables were important. In this post particularly I'll be focusing on binary prediction models.

### What is a model?

First off let's talk about models. 
What is a model? by Miriam Webster's definition it is: "A usually miniature representation of something."  For what I'm talking about we can drop the "usually miniature" component. 
There are two examples I want to talk about here:
1. A model car. A model car (or prototype) is a representation of a real car. For example, the Cyber Truck, the one Elon Musk showed off live, was a prototype of the real car. Tesla likely hasn't built a production line for this yet- they're likely still defining specs and components given production constraints. The purpose of these models are the same as a data science model - they are used to make predictions. Maybe for Cyber Truck its purpose is to predict how the public will react to this car if they started mass producing them. Or maybe it is used to understand performance of how the cars perform after driving 300K miles. OR what will happen when I throw a metal ball at the window!! Either way the purpose is to learn something about the actual car before we have the actual car. We are using them to make predictions about what will happen in the future so we want the model to be as close to the real thing as possible. 

<span style="display:block;text-align:center">
<iframe src="https://giphy.com/embed/gLREH1v1Z78tJckuii" width="480" height="272" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/truck-tesla-pickup-gLREH1v1Z78tJckuii">via GIPHY</a></p>
</span>


2. A model to represent lemonade stand profit. If a lemonade stand has total costs of 10 dollars and makes 1 dollar per cup sold, then the mathematical model to represent profit is $$-10 + 1x = profit$$ In this example we are building a mathematical model to represent a real life process. Once we have this model we can start answering questions about that process/phenomena like how many cups do I need to sell to break even, or how many do I need to sell before I can buy an Xbox! 

This is the same thing we do with a "Data Science Model". We are typically building a mathematical or rule based representation (model) of some real life process/phenomena so that we can start to answer questions about our process/phenomena. Because we want to create a representation of the real life process, for an interpretable and explainable model you need to think of what components make sense to include in the model.

To add onto the lemonade stand example, say we want to predict x, the number of cups sold. We have two variables at our disposal. The number of squirrels in a 100 meter radius, and the temperature outside. When exploring the data you find out that the number of squirrels was the strongest predictor and because of this you build the model only on the number of squirrels. What have you just done?? Do you think squirrel count provides an accurate representation of lemonade sales? While it was useful to predicting in the past it is important to understand how/why it fits into the model when building an interpretable and explainable model. 

OK, the squirrel example is a little crazy, but I kid you not, one time I saw someone use client name as a variable for building a churn model.  NAME?? how can the name of someone (ex. bob vs sam) be predictive of churn? Before dropping all possible variables into XGboost clapping your hands together and saying done, you really need to take the time to understand what you are trying to model, think about what variables would make sense to use, and physically model it to the best of your ability. This takes time.

### What is an interpretable model?
An interpretable model in a data science context is a model that allows you to understand exactly how it arrives at its predictions (in a reasonable amount of time). To categorize commonly used models (again focusing on binary predictions): <br>

*These are not exhaustive lists* <br>
**Interpretable**
* Decision Tree
* Logistic Regression
* K-nearest neighbors

**Not Interpretable** (commonly called black box)
* Support vector machines
* Neural networks
* Random Forest
* Gradient boosting (common form of this is Extreme gradient boosting)

**The explainable component** is built in using business knowledge. It is the difference between building a churn model based off nonsensical variables like client name vs variables that someone can easily rationalize from a business context.

### When to build an interpretable and explainable model?
Basically you should built an interpretable model any time you think it is important to explain predictions or to understand which factors are most important and why. Most problems I've worked on have required an interpretable and explainable model. A couple examples include:
* Risk modeling - We needed to be able to tell the stakeholder specific pockets of high risk individuals defined by a few variable cuts. The model needed to be "easy enough to explain to my grandma on the last mile of a half marathon" as described by the primary stakeholder.
* Pricing - We needed to be able to explain to partners why we were charging more for some leads and less for others.
* Fraud - We needed to know why some people would be rejected and others approved.

So far, the only places I've seen black box models in production was in cases where the modeling task was repeated across multiple products and the variable associations with the response were constantly changing (i.e. a recommendation engine on a platform that constantly changes). It's a type of problem where you really couldn't have interpretable and explainable models as it would be too expensive to manually build those every time. 


### How to build an interpretable model <br>
[In Progress]
Steps: <br>
1. Understand the business context and typical drivers of the process. If you want to be able to explain your model you need to understand why certain variables used are important. This should be completed in the beginning through conversations with subject matter experts (SME's).
2. Understand your available data. Working with SME's still, understand what variables would be useful and track down all the data sources.
3. Explore the data.  
    * Are there missing values?
    * Are there any unexpected patterns?
    * Do any of the trends not align with the expected definitions? Ex. we would never expect a variable above a certain value, yet we see those values.
    * Are there any values that seem like indicators of missingness? Ex. In the workplace I have seen -9, -8, -6, -5, -1, 4, 99999, and 0, all refer to some type of missing value. Ignoring these can really deteriorate model performance.
    * What are the variable distributions?  Are any highly skewed? Are there any outliers?
    * Which variables are highly correlated? and which are likely telling you the same information? (Ex. VantageScore, FICO9, FICO4, these are all correlated and measure risk. You can probably just use one of these)
    * What are the covariate's relationship with the response?
 <br> <br>
4. Build a list of variable modifications identified during exploration. Examples include:
    * Income is highly skewed, I'll perform a log transform here.
    * Industry codes A & B have the same % of the response, I can collapse these factor levels into a single level given it makes sense from a business context.
    * Site visits has many 99999 values, I will need to impute the median value here and understand what 99999 actually means. <br> <br>
	
5. Build preliminary models. In this step you can do things 






Business example: 
For building an interpretable model
Business Context:


1. Build a quick and dirty complicated model
Build the most accurate model possible
