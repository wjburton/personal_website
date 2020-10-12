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

**The Model Building Mindset**

First off let's talk about models. 
What is a model? by Miriam Webster's definition it is: "A usually miniature representation of something."  For what I'm talking about we can drop the "usually miniature" component. 
There are two examples I want to talk about here:
1. A model car. A model car (or prototype) is a representation of a real car. For example, the Cyber Truck, the one Elon Musk showed off live, was a prototype of the real car. Tesla likely hasn't built a production line for this yet- they're likely still defining specs and components given production constraints. The purpose of these models are the same as a data science model - they are used to make predictions. Maybe for Cyber Truck its purpose is to predict how the public will react to this car if they started mass producing them. Or maybe it is used to understand performance of how the cars perform after driving 300K miles. OR what will happen when I throw a metal ball at the window!! Either way the purpose is to learn something about the actual car before we have the actual car. We are using them to make predictions about what will happen in the future so we want the model to be as close to the real thing as possible. 

<span style="display:block;text-align:center">
<iframe src="https://giphy.com/embed/gLREH1v1Z78tJckuii" width="480" height="272" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/truck-tesla-pickup-gLREH1v1Z78tJckuii">via GIPHY</a></p>
</span>


2. A model to represent lemonade stand profit. If a lemonade stand has total costs of 10 dollars and makes 1 dollar per cup sold, then the mathematical model to represent profit is $$-10 + 1x = profit$$ In this example we are building a mathematical model to represent a real life process. Once we have this model we can start answering questions about that process/phenomena like how many cups do I need to sell to break even, or how many do I need to sell before I can buy an Xbox! 

This is the same thing we do with a "Data Science Model". We are typically building a mathematical or rule based representation (model) of some real life process/phenomena (Though the real life process is often far more complex than the examples which is why we use far more complicated models) so that we can start to answer questions about our process/phenomena. Because we want to create a representation of the real life process, you need to think of what components the model should include and what would make sense. To add onto the lemonade stand example, say we want to predict x, the number of cups sold. We have two variables at our disposal. The number of squirrels in a 100 meter radius, and the temperature outside. When exploring the data you find out that the number of squirrels was the strongest predictor


Say you are a marketing company and you are trying to determine which customers to market to for a new product. What factors are most important to predicting? Well it's likely people who made a recent purchase with us are more likely than people who purchased 10 years ago. It's also likely that people who shop with us 100 times a year are more likely than the users that shop 2 times a year. And lastly, some customers likely have more disposable income and therefore have more capacity to respond to an offer. What I'm describing is a classic Recency Frequency Monetary model, and these are the factors that make sense to the business.



Steps:
1. Understand the business context and typical drivers of the process. If you want to be able to explain your model you need to understand why certain components used are important.
2. Understand your available data. Are there missing values? Are there any unexpected patterns? Do any of the trends not align with the expected definitions?

For example, say you work for Lululemon and sell athletic apparel in an online marketplace. One of the processes you are highly interested in understanding is what types of products people want to buy. Once we have a model to predict product desirability can start asking questions like: If I remove tank tops, what is my revenue impact? or What items should I show Will Burton when he visits the site given I want to maximize revenue? or How many members visiting the site aren't likely to be interested in any of our products (this could be a potential product gap)? 

The point of these two simplified examples is that when we are trying to solve a complex problem like the lululemon example



Since I started at Credit Karma there have been two instances where a project has required a model as a deliverable. 

1. A few months into working at Credit Karma, someone on our leadership team tasked me with building a risk model that was "easy enough to explain to my grandma on the last mile of a half marathon".
2. We have been trying to understand our mortgage funnel and I was tasked with trying to predict which members who start a funnel have the highest efficiency (I'm being purposefully vague) 

When you are thinking about building an explainable model you have to keep in mind that you are trying to build a MODEL of a real life process. In the same way that you can build a model car to represent the lamborghini you always wanted, or a model of 1x-10 

Business example: 
For building an interpretable model
Business Context:


1. Build a quick and dirty complicated model
Build the most accurate model possible
