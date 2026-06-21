# Sports Analytics Projects Repository

## 👋 Introduction
Welcome! I’m **Matthew Kulynych**, an aspiring sports analyst and data scientist specializing in sports business and performance analytics. My work focuses on transforming raw sports data into actionable insights through modeling, visualization, and data storytelling. This repository showcases projects I’ve both completed and are currently involved in across multiple sport and sport business domains, reflecting my technical skills and ability to create real-world insights and applications.

---

## 📬 Contact
- **Email:** matthewkulynych@gmail.com (personal), mkulynyc@iu.edu (school)  
- **LinkedIn:** [linkedin.com/in/matthewkulynych](https://www.linkedin.com/in/matthewkulynych)

---

## 📄 Resume
Looking for a detailed overview of my skills and experience?  
- 👉 [View my Resume](MK-Resume.pdf)
- 👉 [Download my Resume (PDF)](https://github.com/matthew-kulynych/Matthew-Kulynych/raw/main/MK-Resume.pdf)

---

## 🛠 Skills
- **Programming & Data Analysis:** Python, R, SQL, Java, C++    
- **Data Visualization:** Tableau, RShiny, RPubs, Dash, ggplot2, matplotlib, ggrepel, annotation design, Streamlit, plotly and interactive plots
- **Machine Learning:** Linear regression, logistic regression, generalized linear models, regression trees/forests, various clustering and classification techniques, elastic net regression
- **CRM Reporting**: Salesforce, NPSP and NPC integrations
- **Database Design:** MySQL, schema modeling, ER diagrams
- **Web Scraping:** BeautifulSoup, Selenium
- **Microsoft Suite:** PowerPoint, Excel, Word, Access
- **Sports Analytics:** Tactical analysis, scouting reports, performance modeling  
- **Collaboration:** GitHub, Team-based problem solving, project communication  

---

## 📂 Repository Projects
This repo contains code, documentation, and datasets for projects I’ve built. Highlights include:

- **NFL Game Analysis**
  
  This project contains 2 game analyses from the 2025-26 NFL season. I utilized the nflreadr package to read in and examine play-by-play data for the Week 1 game between the Colts and Dolphins, and the Week 2 game between the Giants and Cowboys. From here, the Colts/Dolphins game file contains some extra information about the process of cleaning and understanding the data, before driving a few key insights from the game. The Giants/Cowboys file is focused just on deriving game insights, such as red zone efficiency on an individual player level.

- **Customer Retention**

  Here, I worked with a season ticketing dataset to predict and determine what factors are most important to the retention of a season ticket holder. I utilized a random forest model for my predictions, and commented on the strength/accuracy of the model as well as the feature importance. The 1st R file is primarily about understanding and cleaning the data, while the 2nd R file builds on this to run the model predictions.

- **Marketing, Budgeting, and Scheduling Optimization**

  This folder contains some simple Excel files in which I used mathematical optimization with solver to determine the best way to organize budgets and schedules based on pre-determined constraints. 

- **MLS Salary Prediction Model**  

  In this project from my Junior year at Wake Forest University, I used Major League Soccer salary and performance data from Kaggle ([kaggle.com/datasets/viv6369/mls-season-2021-players-stats-and-their-salaries?selecct+Stats_description.txt](https://www.kaggle.com/datasets/viv6369/mls-season-2021-players-stats-and-their-salaries?select=Stats_description.txt)) to predict how much a player should be earning based on past performances. This project aimed to find both undervalued players that a team could sign to improve their performance for a smaller fee as well as overvalued players who are not worth the expensive wages they command.

- **European Soccer Database Design**  

  In this project, I showcased my knowlesge in both the design and application of SQL databases to create a 1-stop hub for player and team performance data, transfers, contract information, standings, and even club staff information. Currently, one needs to navigate through multiple links and websites to extract this information, but this database is designed to house all of this information in a single location. The files in this repository currently only contain the database schema and design process, as I am still in the process of data extraction. 

- **Division I Athletics Staff Scraper**  

  This project was done in collaboration with Dr. David Pierce's research at IU Indianapolis, through the Sports Innovation Institute. It is a python-based web scraping project in which I will extract all staff members in the athletic departments at all NCAA Division 1 schools, organized by conference. I primarily utilized the BeautifulSoup4 package alongside the requests package to extract the information from a variety of web formats. If the data was loaded dynamically via JavaScript, though, I would fall back on Selenium to properly allow for the data to load and be extracted. The folder contains a general "outline" for how I have debugged my scrapers, tested each school, and exported the data for each conference in Jupyter notebooks, alongside a few example conferences. There are also a few example full conference notebooks. This folder alongside this README file will be adjusted when the project is fully completed.

---

## 🔗 Other Projects
In addition to the files here, I’ve worked on several projects linked externally:

- **NFL Big Data Bowl 2026 - Hit 'Em In Stride** – [kaggle.com/code/mkulynych/hit-em-in-stride-final](https://www.kaggle.com/code/mkulynych/hit-em-in-stride-final) For the 2026 NFL Big Data Bowl, we decided to explore the importance of hitting the receiver in stride on deeper passes. Specifically, we wanted to see how it related to efficiency metrics, creating explosive plays, and which quarterbacks were the best at hitting their receiver in stride. We defined "in-stride" based on the receiver's pre and post throw acceleration, and "in-stride" throws were considered to be those where the receiver's acceleration did not change a lot immediately before and after the throw. In May 2026 we were selected to present our project to members of the Indianapolis Colts player and business analytics staff as well as former Colts receiver Bill Brooks. We received insightful feedback and answered both technical and sport-related questions from the team through this special experience. Feel free to read through our Kaggle notebook for our motivation, methods, results, and applications!

- **Wake Forest Men’s Soccer Match Analyses** – I auuthored weekly tactical and performance breakdowns published in the *Old Gold & Black* newspaper at Wake Forest University for the men's soccer team. Here is the link to all of my articles! [wfuogb.com/staff_name/matthew-kulynych/](https://wfuogb.com/staff_name/matthew-kulynych/)

---


