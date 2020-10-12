---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Interpretable Modeling"
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

Over the few years working in a data science role, one of the areas I've found the most success is in building explainable models. In this post particularly I'll be focusing on binary prediction models.

### What is a model?

First off let's talk about models. 
What is a model? by Miriam Webster's definition it is: "A usually miniature representation of something."  For what I'm talking about we can drop the "usually miniature" component. 
There are two examples I want to talk about here:
1. A model car. A model car (or prototype) is a representation of a real car. For example, the Cyber Truck, the one Elon Musk showed off live, was a prototype of the real car. Tesla likely hasn't built a production line for this yet- they're likely still defining specs and components given production constraints. The purpose of these models are the same as a data science model - they are used to make predictions. Maybe for Cyber Truck its purpose is to predict how the public will react to this car if they started mass producing them. Or maybe it is used to understand performance of how the cars perform after driving 300K miles. OR what will happen when I throw a metal ball at the window!! Either way the purpose is to learn something about the actual car before we have the actual car. We are using them to make predictions about what will happen in the future so we want the model to be as close to the real thing as possible. 

<span style="display:block;text-align:center">
<iframe src="https://giphy.com/embed/gLREH1v1Z78tJckuii" width="480" height="272" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/truck-tesla-pickup-gLREH1v1Z78tJckuii">via GIPHY</a></p>
</span>


2. A model to represent lemonade stand profit. If a lemonade stand has total costs of 10 dollars and makes 1 dollar per cup sold, then the mathematical model to represent profit is $$-10 + 1x = profit$$ In this example we are building a mathematical model to represent a real life process. Once we have this model we can start answering questions about that process/phenomena like how many cups do I need to sell to break even, or how many do I need to sell before I can buy an Xbox! 

This is the same thing we do with a "Data Science Model". We are typically building a mathematical or rule based representation (model) of some real life process/phenomena (Though the real life process is often far more complex than the examples which is why we use far more complicated models) so that we can start to answer questions about our process/phenomena. Because we want to create a representation of the real life process, you need to think of what components the model should include and what would make sense. To add onto the lemonade stand example, say we want to predict x, the number of cups sold. We have two variables at our disposal. The number of squirrels in a 100 meter radius, and the temperature outside. When exploring the data you find out that the number of squirrels was the strongest predictor and because of this you build the model only on the number of squirrels. What have you just done?? Do you think squirrel count provides an accurate representation of lemonade sales? While it was useful to predicting in the past it is important to understand how/why it fits into the model. This is a little crazy of an example, but I kid you not, one time I saw someone use client name as a variable for building a churn model.  NAME?? how can the name of someone (ex. bob vs sam) be predictive of churn? Before dropping all possible variables into XGboost clapping your hands together and saying done, you really need to take the time to understand what you are trying to model, and physically model it to the best of your ability. This takes time.

### What is an interpretable model?
An interpretable model in a data science context is a model in which you can really understand how it works why it is making certain predictions. To categorize commonly used models (again focusing on binary predictions): <br>

These are not exhaustive lists <br>
**Interpretable**
* Decision Tree
* Logistic Regression
* K-nearest neighbors

**Not Interpretable** (commonly called black box)
* Support vector machines
* Neural networks
* Random Forest
* Gradient boosting (common form of this is Extreme gradient boosting)


### When to build an interpretable model
Basically you should work on an interpretable model any time you think it is important to be able to explain predictions, or which factors are most important and why. In most problems I've worked on it has been desired to have an interpretable model. Here's a few places it's been required in my experience:
* Risk modeling - we needed to be able to tell the stakeholder specific pockets of high risk individuals defined by a few variable cuts. The model needed to be "easy enough to explain to my grandma on the last mile of a half marathon".
* Pricing - when we price the partner we need to be able to explain why they are paying more for certain leads.
* Fraud - we need to know why people are being rejected for something.

So far, the only places I've seen black box models in production was when the modeling task was repeated across multiple products and relationships are constantly changing (i.e. a recommendation engine on a platform that constantly changes). It's a type of problem where you really couldn't have explainable models as it would be too expensive to manually build those every time. 






**How to build an interpretable model** <br>
Steps: <br>
1. Understand the business context and typical drivers of the process. If you want to be able to explain your model you need to understand why certain components used are important. This should be completed in the beginning through conversations with subject matter experts.
2. Understand your available data. Are there missing values? Are there any unexpected patterns? Do any of the trends not align with the expected definitions?
3. Explore the data 

Since I started at Credit Karma there have been two instances where a project has required a model as a deliverable. 

Business example: 
For building an interpretable model
Business Context:


1. Build a quick and dirty complicated model
Build the most accurate model possible
