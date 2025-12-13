#SPORT CUSTOMER RETENTION MODEL: 

#Retaining loyal and engaged fans is paramount for the long-term success and sustainability of any sports franchise. 
#But this is not always easy as the data often arrives in a challenging format

#This data set was dumped from an NFL team’s ticketing system. 
#The primary goal of the investigation is to understand customer retention, specifically, the factors that predict whether or not a customer (season ticket holders in this case) will return. 
#The team has experienced some success in recent years with achieving two invitations to the playoffs in 2018 and 2019. 
#The team achieved the following win percentages in each season: 2018 (.688), 2019 (.625), 2020 (.250), 2021 (.235), 2022 (.206), 2023 (.429). 
#The data set excludes 2020 given the pandemic year. 

#packages utilized 
library(dplyr) #data manipulation, including grouping, summarizing, and filtering data
library(ggplot2) #data vis
library(scales) #enhacning the appearance of plots 

### Load data (change data locations)
library(readxl)
Retention_Dataset <- read_excel("data_folder.xlsx")
View(Retention_Dataset)

#Key commands
#apply - applying functions without a loop 
#%>% - pass the output of one function directly into the next,

#First, think about the variables and their definitions.
  #Which variables do you think might be predictive? 
  #Which column represents the retention/outcome variable? 

#Second, let's consider some preliminary data cleaning and summarizing. 

# Count the number of duplicate rows
num_duplicates <- sum(duplicated(Retention_Dataset))
# Print the result
print(num_duplicates)
# Finding duplicate rows
duplicate_rows <- Retention_Dataset[duplicated(Retention_Dataset), ]
# Display duplicate rows
print(duplicate_rows) 
# Remove only one occurrence of each duplicate row, keeping the first occurrence
Retention_unique <- Retention_Dataset[!duplicated(Retention_Dataset), ]
# Display the data frame with only one instance of each row
View(Retention_unique)

summary(Retention_unique)
#What does the summary help us understand about each variable? 
#Specifically consider row_name, resale variables and team success measures 

# Convert all character columns to factors
Retention_factor <- Retention_unique
Retention_factor[] <- lapply(Retention_unique, function(x) if (is.character(x)) as.factor(x) else x)
# What other variables might be best considered as factors? 

# Check the structure to confirm conversion
str(Retention_factor)

#Summarize the variables with factor levels 
factor_summary <- sapply(Retention_factor[sapply(Retention_factor, is.factor)], summary)

# Display the summary
factor_summary
#What does the summary help us understand about the variables with factor levels? 

#We will reconstruct our dataframe from day 1 and continue in steps toward our model 

summary(Retention_factor) 
#There are NAs present - why should we not remove them now? 
str(Retention_factor)

# Step 1: Remove unnecessary accounts
# Removes accounts with 'acct_id' equal to "0" or marked as comp accounts (FLAG_Comp == 1).
Retention_remove <- Retention_factor[!(Retention_factor$acct_id == "0" | Retention_factor$FLAG_Comp == 1), ]
# Question: Why is it necessary to filter out accounts with 'acct_id' equal to "0"?

"""
These may just be single ticket purchases, or weirdly flagged data records (e.g. box office purchases). 
They may not be from the same customer, so we may incorrectly flag them as a returning customer. 

"""

# Step 2: Select customer grouping of interest
# Filters to only include customers with Flag_Personal_or_Business_STM == 1 and those that previously purchased
Retention_cust <- Retention_remove[Retention_remove$Flag_Personal_or_Business_STM == 1, ]
# Question: What does setting Flag_Personal_or_Business_STM == 1 help us achieve?

"""
These customers are ones who bought for business use, for instance taking a client to a game. They could also
be for personal use, but don't really fit in with the rest of the data.
"""

# Step 3: Create a subset with baseline variables
# Selects specific columns of interest for the model.
CRmodeldata <- Retention_cust[c(1, 2, 6, 9:13, 22:23, 25:26, 31, 33:36)]

# Step 4: Convert columns to numeric
# Ensures selected columns are numeric, important for any calculations.
CRmodeldata$Non_Resale_Num_Games <- as.numeric(as.character(CRmodeldata$Non_Resale_Num_Games))
CRmodeldata$Non_Resale_Scanned_Games <- as.numeric(as.character(CRmodeldata$Non_Resale_Scanned_Games))
CRmodeldata$Resale_Markup <- as.numeric(as.character(CRmodeldata$Resale_Markup))
# Question: Why might it be necessary to convert these variables to numeric?

"""
This is important because these we care about the numeric or the monetary value of these variables,
and shouldn't be treating them as a group. For resale_markup, for instance, this is an actual resale
price, so treating this as a factor is inappropriate. We also care about the number of games attended
or not more as the number rather than as a group of all ticket records where X number of
games were resold or attended by the ticket holder.

"""

# Step 5: Identify accounts with multiple records in one year
# Define years of consideration
years <- c(2018, 2019, 2021, 2022, 2023)
# Storing the number of repeats for each year in a list
repeat_acct_by_year <- list()
# Loop through each year to find repeated account IDs within that year (this is what was missing)
for (year in years) {
# Filter the data for the current year
data_filtered_year <- subset(CRmodeldata, season_year == year)
# Count the occurrences of account IDs for the current year
acct_id_counts_year <- table(data_filtered_year$acct_id)
# Find account IDs that repeat (appear more than once) in the current year
repeat_acct_id_year <- acct_id_counts_year[acct_id_counts_year > 1]
# Store the count of repeated account IDs for this year in the list
repeat_acct_by_year[[as.character(year)]] <- length(repeat_acct_id_year)
}
# Print the number of repeated account IDs for each year
print(repeat_acct_by_year)
#Question: what do we know about consumer behavior?

"""
There is a huge spike in customers who have repeating records between 2018-2019.
Then, there is a slight decrease to a steady number of around 7500-7800 in the following
years. This could indicate that customers are buying tickets at separate times rather
than all at once in these later years.

"""

# Step 6: Create unique season-account identifiers
CRmodeldata <- CRmodeldata %>%
  mutate(season_acct_id = paste0(season_year, "_", acct_id))
#Account repeats in one year 
#Define the years of interest
years_of_interest <- c(2018, 2019, 2021, 2022, 2023)
# Filter the dataset for the specified years
data_filtered <- subset(CRmodeldata, season_year %in% years_of_interest)
# Count occurrences of each acc_id in the filtered data
acct_id_counts <- table(data_filtered$acct_id)
# Find repeated acc_id (those with counts > 1)
repeat_acct_id <- acct_id_counts[acct_id_counts > 1]
# Number of repeat acc_id
num_repeat_acct_id <- length(repeat_acct_id)
# Print the result
print(num_repeat_acct_id)

# Step 7: Summarize by most frequent characteristics and totals
# Here we calculate summaries like total seats and most frequent attributes for each account-season.

Model_dataID <- CRmodeldata %>%
  group_by(season_acct_id) %>%
  mutate(total_num_seats = sum(num_seats, na.rm = TRUE)) %>%
  mutate(Most_Frequent_Class = names(sort(table(Class), decreasing = TRUE)[1])) %>%
  mutate(Most_Frequent_Stadium_Classification = names(sort(table(Classification), decreasing = TRUE)[1])) %>%
  mutate(Most_Frequent_Stadium_Level = names(sort(table(Stadium_Level), decreasing = TRUE)[1])) %>%
  mutate(Most_Frequent_Stadium_Side = names(sort(table(Stadium_Side), decreasing = TRUE)[1])) %>%
  mutate(Most_Frequent_Field_View = names(sort(table(Field_View), decreasing = TRUE)[1])) %>%
  mutate(total_num_non_resale = sum(Non_Resale_Num_Games, na.rm = TRUE)) %>%
  mutate(total_num_non_resale_scanned = sum(Non_Resale_Scanned_Games, na.rm = TRUE)) %>%
  mutate(avg_resale_markup = if_else(all(is.na(Resale_Markup)), NA_real_, mean(Resale_Markup, na.rm = TRUE))) %>%
  mutate(Flag_Rookie_in_Current_Year = if_else(any(Flag_Rookie_in_Current_Year == 1), 1, 0)) %>%
  ungroup()
# Question: Why do we calculate totals and most frequent values instead of using individual records?

"""
This gives us a more general overview of what is happening in the data as a summary. This
gives us a look at the customer as a whole over the season, rather than at each buying record.
By summarizing like this, we can see the general behavior over the season for a particular
customer, rather than sampling 1 record of them buying a ticket.

"""

# Step 8: Select relevant columns and create a final summary dataset
Model_datafinal <- Model_dataID %>% select(
  c('season_year', 'acct_id', 'season_acct_id', 'total_num_seats', 
    'Most_Frequent_Class', 'Most_Frequent_Stadium_Classification', 
    'Most_Frequent_Stadium_Level', 'Most_Frequent_Stadium_Side', 
    'Most_Frequent_Field_View', 'total_num_non_resale', 
    'total_num_non_resale_scanned', 'avg_resale_markup', 
    'Win_Pct', 'Playoff_Appearance', 'Playoff_Win', 'Hwin_Pct', 'Flag_Rookie_in_Current_Year'))

Model_datafinalcollapsed <- Model_datafinal %>%
  group_by(season_acct_id) %>%
  summarise(across(everything(), first), .groups = 'drop') %>%
  mutate(across(starts_with("Most_Frequent"), as.factor))
# Question: Why do we execute the prior code block?


"""
This aggregates and condenses the data into a more useable form. It ensures that we are grouping
by the account id (individual customer) for the season, creating the summary, and ensuring that 
the variables where we care about their most frequent type is actually a factor. Thus,
we can look at the number of occurrences per group for each of these factors.

"""

# Step 9: Create the dependent variable 'Retained' for retention analysis
Model_dataF <- Model_datafinalcollapsed
Model_dataF$Retained <- 0  # Initialize 'Retained' column as 0

mark_retained <- function(data, year1, year2) {
  acct_id_both_years <- intersect(
    data %>% filter(season_year == year1) %>% pull(acct_id),
    data %>% filter(season_year == year2) %>% pull(acct_id)
  )
  data %>% mutate(Retained = ifelse(season_year == year1 & acct_id %in% acct_id_both_years, 1, Retained))
}

Model_dataF <- mark_retained(Model_dataF, 2018, 2019)
Model_dataF <- mark_retained(Model_dataF, 2019, 2021)
Model_dataF <- mark_retained(Model_dataF, 2021, 2022)
Model_dataF <- mark_retained(Model_dataF, 2022, 2023)

# Step 10: Remove 2023 data and set 'Retained' as a factor
Model_dataC <- Model_dataF %>%
  filter(season_year != 2023) %>%
  mutate(Retained = as.factor(Retained))
# Question: Why do we remove 2023 data before modeling?


"""
We don't have the information for how these customers retained in the 2024 season,
so we can't assign a Retained flag for this year. This is because we put it in the
first year of the pair, to see if they retained in the next year. But we do this
after we calculate 2022, so we can see if the customer was a ticket holder in both
of these years that we have data for.

"""

Model_dataC<-na.omit(Model_dataC)

#Step 11 Set the train and test data set 
set.seed(42)  
sample_index <- sample(1:nrow(Model_dataC), 0.7 * nrow(Model_dataC))
train_data <- Model_dataC[sample_index, ]
test_data <- Model_dataC[-sample_index, ]

# Load necessary libraries
if (!require("randomForest")) install.packages("randomForest", dependencies = TRUE)
if (!require("caret")) install.packages("caret", dependencies = TRUE)
if (!require("tidyverse")) install.packages("tidyverse", dependencies = TRUE)
if (!require("dplyr")) install.packages("dplyr", dependencies = TRUE)
library(randomForest)
library(caret)
library(dplyr)
library(tidyverse)

#Step 12: Random forests construction 
Retention_rf <- randomForest(train_data$Retained ~ 
                               total_num_seats +
                               Most_Frequent_Class +
                               Most_Frequent_Stadium_Classification + 
                               Most_Frequent_Stadium_Level + 
                               Most_Frequent_Stadium_Side + 
                               Most_Frequent_Field_View +  
                               total_num_non_resale +
                               total_num_non_resale_scanned +
                               avg_resale_markup +
                               Win_Pct +
                               Playoff_Appearance +
                               Playoff_Win +
                               Hwin_Pct, 
                             data = train_data, 
                             ntree = 500, 
                             mtry = sqrt(ncol(train_data) - 1), 
                             importance = TRUE)

# Step 13: Make predictions and evaluate model accuracy
predictions <- predict(Retention_rf, test_data)
confusionMatrix(predictions, test_data$Retained)
# Question: What does the confusion matrix tell us about model accuracy?

"""
For records where the customer actually was a retained customer, the model is good
at predicting them to repeat 98.5% of the time (specificity). It has an overall
model accuracy of 82.5%. However, it is very poor at predicting customers who did not
actually retain. It only predicted those correctly 7.3% (sensitivity) of the time. There seem to be 
many more records where the customer did retain than when they didn't, so this could
have led to the over-classification as retained.

We could instead try to make sure the training and test sets have the proper proportion
of each class in the training and test set as a potential solution.

"""

# Step 14: Check and plot variable importance
importance_values <- importance(Retention_rf)
print(importance_values)
varImpPlot(Retention_rf)
# Question: Which variables appear most important for predicting retention?


"""
total_num_non_resale, total_num_non_resale_scanned, avg_resale_markup, total_num_seats,
and Most_Frequent_Stadium_Level seem to be the most important variables. These are the variables
related to how many of the games the ticket holder is actually attending or reselling, how much
money they make on resales, the number of seats bought, and what area they most frequently bought in.
These are the top 5 variables for both MeanDecreaseAccuracy and MeanDecreaseGini. However, it is important
to note that the total number of seats and the variables related to ticket resale are way more important 
in terms of predicting actual retained customers over non retained customers (class imbalance).

"""



### NEW CODE FOR SPRINT CHALLENGE 3

### Need to run up through creating Model_dataC and omitting NAs above. I altered the code to include
### the rookie flag in CRModeldata, and include it in the mutation for Model_dataID

# Step 1: Define rookies vs veterans
Model_dataF <- Model_dataF %>%
  mutate(Customer_Type = ifelse(Flag_Rookie_in_Current_Year == 1, "Rookie", "Veteran"))

# Step 2: Calculate retention rates by season and type
retention_rates <- Model_dataF %>%
  filter(season_year != 2018, season_year != 2023) %>%   # drop first and last year
  group_by(season_year, Customer_Type) %>%
  summarise(Retention_Rate = mean(as.numeric(Retained)), .groups = "drop")


# Step 3: Plot grouped bar chart
ggplot(retention_rates, aes(x = as.factor(season_year),
                            y = Retention_Rate,
                            fill = Customer_Type)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = scales::percent(Retention_Rate, accuracy = 0.1)),
            position = position_dodge(width = 0.9),
            vjust = -0.3, size = 3.5) +   # adjust vjust/size as needed
  scale_y_continuous(labels = scales::percent_format()) +
  labs(title = "Rookie vs Veteran Retention Rates by Season",
       x = "Season Year",
       y = "Retention Rate",
       fill = "Customer Type") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

### Retention Rates by stadium attributes

# Filter rookies only
rookie_data <- Model_dataF %>%
  filter(Flag_Rookie_in_Current_Year == 1,
         season_year != 2018,
         season_year != 2023)

# Calculate retention rate by Stadium Level
rookie_retention_level <- rookie_data %>%
  group_by(Most_Frequent_Stadium_Level) %>%
  summarise(Retention_Rate = mean(as.numeric(Retained)), .groups = "drop")

# Plot with labels above bars
ggplot(rookie_retention_level, aes(x = Most_Frequent_Stadium_Level, y = Retention_Rate, fill = Most_Frequent_Stadium_Level)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = percent(Retention_Rate, accuracy = 0.1)),
            vjust = -0.3, size = 3.5) +
  scale_y_continuous(labels = percent_format()) +
  labs(title = "Rookie Retention Rate by Stadium Level",
       x = "Stadium Level",
       y = "Retention Rate") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = "none")


### Modeling

# Set up rookie data set
rookie_data <- Model_dataC %>%
  filter(Flag_Rookie_in_Current_Year == 1)

## Handling class imbalance, setting up model
set.seed(42)
train_index <- createDataPartition(rookie_data$Retained, p = 0.7, list = FALSE)
train_data_rookie <- rookie_data[train_index, ]
test_data_rookie  <- rookie_data[-train_index, ]
train_data_rookie$Retained <- factor(train_data_rookie$Retained, levels = c("0","1"))
test_data_rookie$Retained  <- factor(test_data_rookie$Retained, levels = c("0","1"))

# Training model control
ctrl <- trainControl(method = "repeatedcv",
                     number = 5,        # 5-fold CV
                     repeats = 3,       # repeat 3 times
                     classProbs = TRUE, # needed for ROC
                     summaryFunction = twoClassSummary)

# Upsample the underrepresented class
rookie_balanced <- upSample(
  x = train_data_rookie[, -which(names(train_data_rookie) == "Retained")],
  y = train_data_rookie$Retained
)
colnames(rookie_balanced)[ncol(rookie_balanced)] <- "Retained"

# Rename factor levels
train_data_rookie$Retained <- factor(train_data_rookie$Retained,
                                     levels = c("0","1"),
                                     labels = c("Churn","Retained"))

test_data_rookie$Retained <- factor(test_data_rookie$Retained,
                                    levels = c("0","1"),
                                    labels = c("Churn","Retained"))

rookie_balanced$Retained <- factor(rookie_balanced$Retained,
                                   levels = c("0","1"),
                                   labels = c("Churn","Retained"))

# Fit the model
rf_rookie_up <- train(Retained ~ total_num_seats +
                        Most_Frequent_Class +
                        Most_Frequent_Stadium_Classification +
                        Most_Frequent_Stadium_Level +
                        Most_Frequent_Stadium_Side +
                        Most_Frequent_Field_View +
                        total_num_non_resale +
                        total_num_non_resale_scanned +
                        avg_resale_markup +
                        Win_Pct +
                        Playoff_Appearance +
                        Playoff_Win +
                        Hwin_Pct,
                      data = rookie_balanced,
                      method = "rf",
                      trControl = ctrl,
                      metric = "ROC",       # optimize for ROC/AUC
                      preProcess = c("center", "scale"),
                      tuneLength = 5)       # try 5 values of mtry

# Predictions on test set
pred_up <- predict(rf_rookie_up, test_data_rookie)

# Confusion matrix (focus on churners as positive class)
confusionMatrix(pred_up, test_data_rookie$Retained, positive = "Churn")

# ROC/AUC
library(pROC)
prob_up <- predict(rf_rookie_up, test_data_rookie, type = "prob")
roc_up <- roc(test_data_rookie$Retained, prob_up[, "Churn"])
plot(roc_up)
auc(roc_up)

# Variable Importance
# Get variable importance
importance_rookie <- varImp(rf_rookie_up, scale = TRUE)

# Print importance table
print(importance_rookie)

# Plot importance
plot(importance_rookie, top = 15)   # show top 15 features

