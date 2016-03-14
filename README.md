# INFO 5302 Assignment 1 Social Explorer
<img src='http://hanax.github.io/whatyouvemissedwhenyouarecoding/assets/images/logo.png' width='200px'/>

http://hanax.co/whatyouvemissedwhenyouarecoding

Made by [Thomas Yang](http://thomas-yang.me) and [Hannah Xue](http://hanax.co)

## What this is about
See what's going on in the world while you are coding and making commits to GitHub
* Login with your GitHub account.
* Visualize your daily commit number by month.
* See beautiful pictures from Flickr, taken exactly at when and where you made each commit.
* Hovering on pictures for previewing, and clicking for details.

## Requirements details
* APIs: GitHub API, Flickr API
* API endpoints: GitHub user profile, GitHub commit numbers and time for each commit, Flickr photos filtered by time and location
* Data scale: Any user can login with their GitHub account. 
* We tried public data from the popular GitHub account [taylorotwell](http://github.com/taylorotwell) who has around 7k commits in the past year and a screenshot of results are shown below:

![taylorotwell](http://hanax.github.io/whatyouvemissedwhenyouarecoding/assets/readme_files/taylorotwell.jpg)

* A screenshot of the results of [Hannah Xue](http://github.com/hanax) who has around 700 commits in the past year are as below:

![hanax](http://hanax.github.io/whatyouvemissedwhenyouarecoding/assets/readme_files/hanax.jpg)

## Technical details
* CoffeeScript(JavaScript) / Node.js / various other web techniques (gulp, jade, stylus, etc)
* Open-source api wrapper on Node.js: [node-flickrapi](https://github.com/Pomax/node-flickrapi) / [node-github](https://github.com/mikedeboer/node-github)

## Local deployment
```
# Install the required package
npm install
# Compile the source code and serve on http://localhost:5000
gulp serve
```
