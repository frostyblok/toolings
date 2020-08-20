### Table of Contents

1. [Introduction](#introduction)
2. [Setup](#setup)
3. [Technology Overview](#technology-overview)


----


# Introduction
This repository is for the Rails-based app that helps doctors with immediate medical information on their phones, helping them provide the right treatment at the right moment. With our mobile app, we make their jobs easier and save them time, so they can dedicate more time to their real job, helping patients. We started with an idea from two doctors in 2012, and we are now by far the most popular medical information app in 8 countries and expanding, with an enthusiastic and growing team of 21 people.

## Application Overview

#### Why?
The mobile app this tools tries to solve for is available in 8 countries and languages (because it's strongly dependent on local medical sources - none of which is in English). An important part of the app are ​tools​. Functionality of a tool can be to calculate risk of a disease, to calculate an intermediate score needed for drug dosing, to monitor disease progression etc.

Tools in mobile apps are not implemented natively, they are described using a declarative language - every tool has a specification in JSON​ ​(called ​tool JSON spec​). The spec describes:
- UI elements (e.g. "yes/no picker" or "numeric input field between 30 - 300"),
- their behaviour (e.g. "If answer to question 3 is NO, hide questions 4 and 5"),
- calculation of result (e.g. "1 point for each YES answer, result is HIGH RISK if total is
over 4 points").

This tool spec is then served to mobile apps through the API.
These tool specs need to be translated into all 8 languages. Automatic translation already exists (merging translations into tool spec template) but has proven to be error-prone. Since this is medical content, it's very important to have detailed control over every change on tool spec before it starts being served through the API. For this, we decided to use the familiar GitHub feature ​Pull Requests​.


----


# Setup
Here's how to get the app running on your local computer for development:

### Prerequisites
You must have the following to run this app:
1. Postgres 10
2. Ruby 2.6.6
3. Rails 5.2.4


### Installation
Follow these instructions to setup your local development environment after cloning the application:

1. Copy the contents of `config/application-example.yml` to a new file in the config folder like so `config/application.yml` and Fill in the relevant details and set appropriate user permissions.
2. Run `bundle install && bundle exec rake db:setup`. Then run `rails server` to run your rails server. These chained commands must pass for successful installation.

Note: The app makes use of both Figaro and Rails credentials for storing environment variables. Run `Rails credentials:edit` to set appropriate variables.

By default it runs at http://localhost:3000. You can also run the server through RubyMine so you can use the debugger and step through code.

If you're also running other Rails apps, you'll want to run this on another port so you don't conflict with other servers. To do that you can run `rails server -p 3003` for example to run the rails server on port 3003.

If everything ran properly you should be able to see a standard Rails Getting Started when you go to http://localhost:3003 (or whatever your port is) in your browser.

## Setup the webhook for Lokalise API
If you want to test installing the Extra Verification App onto a Shopify store you'll need to create a development app in Shopify. Here's how to do it:

#### 1. Setup ngrok.io
Signup at ngrok.io and install the app into your computer. Then run it with `./ngrok http 3003` (if your port number is `3003` for your rails app).


After setting this up you should be able to access your rails app from `https://app-url.ngrok.io`.

Update your `application.yml` file with your ngrok URLs. For example if your ngrok URL is `https://5e9a04666d6d.ngrok.io` then you should have this in your `config/application.yml`:
```
BASE_APP_URL="https://5e9a04666d6d.ngrok.io"
```

#### 2. Create a Webhook
Create a Lokalise webhook to listen to translation changes.

To do this for Lokalise simply go to `your-ngrok-url/create_lokalise_webhook` eg: `https://5e9a04666d6d.ngrok.io/create_lokalise_webhook`


----


# Technology Overview
#### Tech used:
Make sure you read up on and understand these technologies before diving into the application:
* Rails 5.2
* Figaro
* Octokit 4.0
* Ruby Lokalise API
* Postgres
