# INFO 5302 Assignment 1 Social Explorer
<img src='http://hanax.github.io/whatyouvemissedwhenyouarecoding/assets/images/logo.png' width='200px'/>

http://hanax.co/whatyouvemissedwhenyouarecoding

Made by [Thomas Yang](http://thomas-yang.me) and [Hannah Xue](http://hanax.co)

## What this is about
See what's going on in the world while you are coding and making commits to GitHub. We tried to make some crazy coders reflect more on how much beauty they have missed through mindblowing visuals (beautiful photos, floating descriptions, etc).
* Login with your GitHub account.
* Visualize your GitHub daily commits by month.
* Browse Flickr photos, taken exactly at when and where you made each commit. 
  * The number of the photos correlated with commit number.
* Hovering on pictures for previewing, and clicking for details.

## Requirements details
* APIs: GitHub API, Flickr API
* API endpoints: GitHub user profile, GitHub commit numbers and time for each commit, Flickr photos filtered by time and location
* Data scale: Any user can login our web application with their GitHub account. 
* We tried public data from the popular GitHub account [taylorotwell](http://github.com/taylorotwell) who has around 7k commits in the past year and a screenshot of results are shown below:

![taylorotwell](http://hanax.github.io/whatyouvemissedwhenyouarecoding/assets/readme_files/taylorotwell.jpg)

* A screenshot of the results of [Hannah Xue](http://github.com/hanax) who has around 700 commits in the past year are as below:

![hanax](http://hanax.github.io/whatyouvemissedwhenyouarecoding/assets/readme_files/hanax.jpg)

## Technical details
* CoffeeScript / JavaScript / Node.js / Firebase / various other web techniques (webpack, gulp, jade, stylus, etc)
* Open-source API wrapper on Node.js: [node-flickrapi](https://github.com/Pomax/node-flickrapi) / [node-github](https://github.com/mikedeboer/node-github)
* All code in this repo are original.

## Local deployment
```sh
# Clone the project to local
git clone git@github.com:hanax/whatyouvemissedwhenyouarecoding.git
# Install the required package
npm install
# Compile the source code and serve the file
gulp serve
# Open browser and visit http://localhost:5000
```
