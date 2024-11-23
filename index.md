<center><img src="images/tutorial_title.png" alt="Img"></center>

<sub>Image: https://www.pexels.com/photo/sparrows-sitting-on-windowsill-14749635/ & https://ourcodingclub.github.io/</sub>

*Created by Abigail Haining (28/11/24)*

----

### Tutorial Aims:

#### <a href="#section1 "> 1) What is ANOVA and Tukey's Test?</a>

#### <a href="#section2"> 2) Research question and hypothesis</a>

#### <a href="#section3"> 3) Data manipulation</a>

#### <a href="#section4"> 4) Data visualisation</a>

#### <a href="#section5"> 5) Running a one-way ANOVA</a>

#### <a href="#section6"> 6) Running Tukey's HSD</a>

#### <a href="#section7"> 7) Communicating model results</a>

---------------------------

Often in ecological and environmental research you will need to compare groups of data to see if there is a difference between the groups. This could be comparing plant growth between different soil types or water quality in different rivers for example. In this tutorial we will look at the difference in house sparrow (*Passer domesticus*) abundance between different habitats.

You may have used a T-test before which compares the means across two groups to see if there is a statistically significant difference. If you want to compare more than two groups you can use a one-way ANOVA and to further analyse the results of the ANOVA you can perform a post-hoc test. 

__In tutorial you will learn how to:__
- Load and prepare data for analysis in RStudio
- Understand when and why to use a one-way ANOVA and Tukey's test
- Perform a one-way ANOVA and Tukey's test
- Interpret the outputs from these tests
- Recognise assumptions of these tests
- Visualise the data and outputs
- Report findings

You can get all of the resources for this tutorial from <a href="https://github.com/EdDataScienceEES/tutorial-Abigail-Louise.git" target="_blank">this GitHub repository</a>. Clone and download the repo as a zip file, then unzip it.

<a name="section1"></a>

## 1) What is ANOVA and Tukey's Test?

An ANOVA which stands for "ANalysis Of VAriance" is a statistical method used to compare the means across three or more groups. It considers the variability both within each group and between them to determine statistical significance.

If the overall p-value from the ANOVA is less than the significannce level you have specified then we can say at least one of the means of the groups is different from the others. However, this does not tell us which groups differ from each other. This is where a post hoc test comes in to test which groups are different from each other. 

One of the most commonly used post-hoc tests is Tukey's HSD test, which stands for "Tukey's Honest Significant Difference" test. It makes pairwise comparisons between the means of each group - this means it compares every possible pair of group means to determine if there is a statistically significant difference between them. 

You have probably heard of Type I (false positive) and Type II (false negative) errors before. Well, Tukey's test controls for Type I errors by controlling the family-wise error rate which is the probability of making at least one Type 1 error when performing multiple statistical tests.

<a name="section2"></a>

## 2. Research question and hypothesis

<center><img src="images/sparrow.png" alt="Img", height = 400></center>
<sub>Image: https://www.pexels.com/photo/house-sparrow-on-a-tree-branch-in-spring-nature-29423562/</sub>


You can add more text and code, e.g.

```r
# Create fake data
x_dat <- rnorm(n = 100, mean = 5, sd = 2)  # x data
y_dat <- rnorm(n = 100, mean = 10, sd = 0.2)  # y data
xy <- data.frame(x_dat, y_dat)  # combine into data frame
```

Here you can add some more text if you wish.

```r
xy_fil <- xy %>%  # Create object with the contents of `xy`
	filter(x_dat < 7.5)  # Keep rows where `x_dat` is less than 7.5
```

And finally, plot the data:

```r
ggplot(data = xy_fil, aes(x = x_dat, y = y_dat)) +  # Select the data to use
	geom_point() +  # Draw scatter points
	geom_smooth(method = "loess")  # Draw a loess curve
```

At this point it would be a good idea to include an image of what the plot is meant to look like so students can check they've done it right. Replace `IMAGE_NAME.png` with your own image file:

<center> <img src="{{ site.baseurl }}/IMAGE_NAME.png" alt="Img" style="width: 800px;"/> </center>


<a name="section3"></a>

## 3) Data manipulation

At the beginning of your tutorial you can ask people to open `RStudio`, create a new script by clicking on `File/ New File/ R Script` set the working directory and load some packages, for example `ggplot2` and `dplyr`. You can surround package names, functions, actions ("File/ New...") and small chunks of code with backticks, which defines them as inline code blocks and makes them stand out among the text, e.g. `ggplot2`.

When you have a larger chunk of code, you can paste the whole code in the `Markdown` document and add three backticks on the line before the code chunks starts and on the line after the code chunks ends. After the three backticks that go before your code chunk starts, you can specify in which language the code is written, in our case `R`.

To find the backticks on your keyboard, look towards the top left corner on a Windows computer, perhaps just above `Tab` and before the number one key. On a Mac, look around the left `Shift` key. You can also just copy the backticks from below.

```r
# Set the working directory (enter your own filepath here)
setwd("C:/Users/abiga/OneDrive/3rd year/Data Science in EES/tutorial-Abigail-Louise")

# You can check where your working directory is using:
getwd()

# Load packages
library(tidyverse)
library(broom)
```


<a name="section4"></a>

## 4) Data visualisation

It is good practice to visualise your data before undertaking any data analysis.

<a name="section5"></a>

## 5) Running a one-way ANOVA

<a name="section6"></a>

## 6) Running Tukey's HSD

<a name="section7"></a>

## 7) Communicating model results

More text, code and images.

This is the end of the tutorial. Summarise what the student has learned, possibly even with a list of learning outcomes. In this tutorial we learned:

##### - how to generate fake bivariate data
##### - how to create a scatterplot in ggplot2
##### - some of the different plot methods in ggplot2

We can also provide some useful links, include a contact form and a way to send feedback.

For more on `ggplot2`, read the official <a href="https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf" target="_blank">ggplot2 cheatsheet</a>.

Everything below this is footer material - text and links that appears at the end of all of your tutorials.

<hr>
<hr>

#### Check out our <a href="https://ourcodingclub.github.io/links/" target="_blank">Useful links</a> page where you can find loads of guides and cheatsheets.

#### If you have any questions about completing this tutorial, please contact us on ourcodingclub@gmail.com

#### <a href="INSERT_SURVEY_LINK" target="_blank">We would love to hear your feedback on the tutorial, whether you did it in the classroom or online!</a>

<ul class="social-icons">
	<li>
		<h3>
			<a href="https://twitter.com/our_codingclub" target="_blank">&nbsp;Follow our coding adventures on Twitter! <i class="fa fa-twitter"></i></a>
		</h3>
	</li>
</ul>

### &nbsp;&nbsp;Subscribe to our mailing list:
<div class="container">
	<div class="block">
        <!-- subscribe form start -->
		<div class="form-group">
			<form action="https://getsimpleform.com/messages?form_api_token=de1ba2f2f947822946fb6e835437ec78" method="post">
			<div class="form-group">
				<input type='text' class="form-control" name='Email' placeholder="Email" required/>
			</div>
			<div>
                        	<button class="btn btn-default" type='submit'>Subscribe</button>
                    	</div>
                	</form>
		</div>
	</div>
</div>
