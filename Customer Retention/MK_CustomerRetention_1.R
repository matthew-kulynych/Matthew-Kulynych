#SPORT CUSTOMER RETENTION MODEL: 
#In this two-week assignment, we delve into the dynamic world of sport customer retention,focusing on a case study involving an NFL team. 
#Retaining loyal and engaged fans is paramount for the long-term success and sustainability of any sports franchise. 
#But this is not always easy as the data often arrives in a challenging format

#This data set was dumped from an NFL team’s ticketing system. 
#The primary goal of the investigation is to understand customer retention, specifically, the factors that predict whether or not a customer (season ticket holders in this case) will return. 
#The team has experienced some success in recent years with achieving two invitations to the playoffs in 2018 and 2019. 
#The team achieved the following win percentages in each season: 2018 (.688), 2019 (.625), 2020 (.250), 2021 (.235), 2022 (.206), 2023 (.429). 
#The data set excludes 2020 given the pandemic year. 

#We will work in 5 descriptive phases for day 1: 
#1) Consider the variable definitions and start to brainstorm predictive variables and our retention or outcome variable. 
#2) Preliminary data cleaning and summarizing 
#3) Add missing data (athletic success) 
#4) Descriptive insights about season ticket purchases
#5) Begin the process of considering what our final baseline model will look like for phase 2. 

#packages utilized 
library(dplyr) #data manipulation, including grouping, summarizing, and filtering data
library(ggplot2) #data vis
library(scales) #enhacning the appearance of plots 

### Load data (change data locations)
library(readxl)
Retention_Dataset <- read_excel("data_folder.xlsx")
View(Retention_Dataset)

data_guide <- read.csv("data_guide.csv")

#Key commands
#apply - applying functions without a loop 
#%>% - pass the output of one function directly into the next,

#First, think about the variables and their definitions.
  #Which variables do you think might be predictive? 
  #Which column represents the retention/outcome variable? 

"""
I think that the team information like playoff_appearance and win_pct are definitely indicative.
I would also think that resale_markup, flag_psl, resale_total_original_cost, and non_resale_scanned_games
would also be very predictive, because they indicate how many games the season ticket holder is actually
attending or how much money they are making when they resell their tickets. This could also be any of
the other resale/attendance related variables. We could also include number of seats bought compared to
the number they resale to see if people are getting multiple tickets and actually going with people.

For the retention/outcome variable, we likely need to create a new variable. Since the data is over multiple
seasons, and each row represents 1 ticket account in 1 season, we can see if the ticket account had season
tickets in each year as a retention variable from year to year. We would put the retained flag in the first
year, since we are looking to if they retain the NEXT year, not the current year
"""

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

"""
We can learn data types if something is a character variable, when we need it to be numeric.
We can also get some general insights into the summary statistics for certain variables (i.e. num_seats)
that are already stored as numbers.
"""

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

"""
We can see the quantities of each for the factor level variables to understand the distribution.
For instance, there are 24870 Club ticket records, 4643 suite ticket records, etc.

We could maybe also bucket on num_seats instead of using it as a numeric variable.
"""

#Third, let's take a moment to add in the athletic success measures to the data set. 
#Customer data sets, however, Work as a group to find the best/most efficient way to do this. 


#Fourth, let's think about some initial season ticket holder customer insights. 
#What do we know about season ticket holder transaction patterns? 
library(dplyr)
library(ggplot2)
aggregated_data <- Retention_factor %>%
  group_by(season_year) %>%
  summarise(num_transactions = n())
ggplot(aggregated_data, aes(x = season_year, y = num_transactions)) +
  geom_line(group = 1, color = "blue") +
  geom_point(color = "blue", size = 3) +  # Increased point size
  labs(title = "Number of Transactions per Year", x = "Year", y = "Number of Transactions") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),    # Centering the title
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()
  )

"""
From 2018 to 2019 there was a huge increase, and a slight decrease between 2019 and 2021.
This is likely related to the COVID pandemic, as people still would be holding out on attending
games due to the pandemic.
It remained steady between 2021 and 2022, but there was another large increase in 2023.
In general, ticket transactions increased over the time period. 
"""

#What do we know about season tickets sold?
aggregated_data2 <- Retention_factor %>%
  filter(FLAG_Comp == 0) %>%
  group_by(season_year) %>%
  summarise(num_transactions = sum(num_seats))
ggplot(aggregated_data2, aes(x = season_year, y = num_transactions)) +
  geom_line(group = 1, color = "blue") +   # the group=1 ensures the line is continuous
  geom_point(color = "blue", size = 3) +
  labs(title = "Total Tickets Sold per Year", x = "Year", y = "Total Tickets Sold") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),    # Centering the title
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()
  )

"""
We see the same trends for tickets sold per year. 

"""


#Which seating class is making a difference? 
ticket_data <- Retention_unique %>%
  filter(FLAG_Comp == 0 & !is.na(Class) & Class != "") %>%
  group_by(season_year, Class) %>%
  summarise(num_tickets = sum(num_seats, na.rm = TRUE), .groups = "drop")

ggplot(ticket_data, aes(x = as.factor(season_year), y = num_tickets, fill = Class)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Number of Tickets Sold per Year by Seat Class",
       x = "Year", y = "Number of Tickets") +
  scale_y_continuous(labels = comma) +  # This line changes the y-axis labels
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),    # Centering the title
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank()
  )

"""
Club level and suite level tickets stayed generally the same, thought there were jumps
between 2018-2019 and 2022-23, as well as a small decline (like with the other plots) between
2019-2021. However, there were much larger increases in general admission tickets sold betwen
2018-2019 and 2022-2023. This does make sense because GA's have more tickets available in general,
but are also generally more affordable. 

"""

#Which seating area is making a difference?
install.packages("scales")
library(scales)

ticket_data <- Retention_unique %>%
  filter(FLAG_Comp == 0 & !is.na(Stadium_Level) & Stadium_Level != "") %>%
  group_by(season_year, Stadium_Level) %>%
  summarise(num_tickets = sum(num_seats, na.rm = TRUE), .groups = "drop")
# Plot a stacked bar chart
ggplot(ticket_data, aes(x = as.factor(season_year), y = num_tickets, fill = Stadium_Level)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Number of Tickets Sold per Year by Stadium Level",
       x = "Year", y = "Number of Tickets") +
  scale_y_continuous(labels = comma) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),    # Centering the title
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank()
  )

"""
Field level and middle level tickets were generally pretty steady across seasons. There
was a large spike between 2018-19 in middle level tickets. We see much more volatile
changes in upper level tickets. There was a large spike between 2018-19, and general decreases 
between 2019-2022. Then, there is another very large spike between 2022-23. Again, this
generally checks out since these tickets are generally cheaper.

"""

#What can we know about first and second year customers? 
# Create a dataset for first year and second year customers
aggregated_data2 <- Retention_unique %>%
  filter(FLAG_Comp == 0) %>%
  filter(season_year %in% c(2021, 2022, 2023)) %>%
  filter(Flag_Rookie_in_Current_Year == 1 | Flag_Rookie_in_Prior_Year == 1) %>%
  group_by(season_year, customer_type = case_when(
    Flag_Rookie_in_Current_Year == 1 ~ "1st Year",
    Flag_Rookie_in_Prior_Year == 1 ~ "2nd Year"
  )) %>%
  summarise(num_transactions = n(), .groups = "drop")

ggplot(aggregated_data2, aes(x = season_year, y = num_transactions, color = customer_type, group = customer_type)) +
  geom_line() +
  geom_point() +
  labs(title = "Number of 1st and 2nd Year Customers", x = "Year", y = "Total Tickets Sold") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),    # Centering the title
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank()        # Removing minor grid lines
  ) +
  scale_color_manual(values = c("1st Year" = "blue", "2nd Year" = "red"))

"""
After 2022, the number of 1st year customers drastically decreased from a generally high
number. Meanwhile, 2nd year ticket customers had a very steady increase across the years.
"""

#Fifth, what types of maneuvers will we have to orchestrate to configure the predictive model? 
#(Hint: 1) preparing season ticket holder customers, 2) how we will handle NAs and 3) preparing our retention variable)

"""
We have to be very careful about making sure we are looking at andn aggregating the customers that
we want to look at. We have to ensure that these are actually season ticket members. In regards
to NAs, we shouldn't just blanket remove them, especially because these are often related to ticket
resales. Instead of just NA, we could potentially set this to 0 since they just didn't resell tickets,
or in some other clean way that makes sense for the variable. Or just factor out for a particular analysis 
if we only want to look at those that resold tickets. Finally, we need to be careful into how we 
place and create the retention variable and that it applies to the proper year (1st year of the 2).

"""