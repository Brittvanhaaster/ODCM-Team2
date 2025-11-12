Theme Park Queues and Weather  
Data documentation template  

1.		Motivation1 

1.1	What primary business problem motivated the creation of this dataset (“data context”)? How does the dataset offer insights into new phenomena, contribute to developing new models, or streamline gathering essential information? Why is this dataset valuable to the broader research community or industry stakeholders? Please list potential research questions or use cases of your dataset.  

Waiting –one has to do it continuously. Whether that is for everyday activities like waiting for a train of for checking-out groceries, or more unique instances such as waiting before a concert starts or for boarding a theme park attraction. Waiting takes place in two contexts; a utilitarian context which concerns waiting for necessary or functional products or services, while a hedonic context has objectives related to intrinsic pleasure and ‘feeling good’ (Chandon et al., 2000). Current research is typically focused on the utilitarian aspects of life, such as healthcare, retail or public transport (e.g. Michael et al., 2013, Van Riel et al., 2012, Millonig et al., 2012). Since the implication of waiting in a hedonic context is fundamentally different, it is worthwhile to create a dataset on waiting related to a hedonic context. Additionally, current research widely adopts a psychological perspective, for example by investigating the discrepancy between the actual wait time and how long someone psychologically perceives a queue to be (Bielen and Demoulin’s, 2007). As such, academic relevance could be yielded by focusing on a hedonic context while adopting a macro-scaled approach.  

A suitable hedonic context to study is a theme park –where waiting is inevitable (Gnoth et al., 2007; Heger et al., 2009), and argued to be the main frustration of visitors (Brown et al., 2013; Daniels et al., 2017; Hernandez-Maskivker et al., 2016). Unsurprisingly, waiting has a a significant negative impact on the overall pleasure of the overall theme park experience (Li, 2010; Torres et al., 2019). An additional benefit of theme parks is that queue times are constantly monitored and communicated to guests, which allows for opportunities in extracting a historical data set on wait times. 

Social relevance of the present study’s focus can be maximised by further including seasonality, which is an important factor in driving marketing and operational decisions in theme parks (Anton Clave, 2007). Typically, holidays and the summer period are considered ‘high season’. In particular, weather conditions play an important role in the amount of guests a theme park welcomes. For example, Cornelis (2017) visualised the effect of temperature on guest attendance. Nevertheless, what is considered optimal weather is subjective, and difficult to generalise on a micro-level. On the contrary, inspecting the effect of weather conditions on theme park queues on a macro-level would provide theme park managers with actionable insights. Resultingly, this allows theme park managers to more efficiently allocate resources (e.g. operating staff) to enhance capacity. Indirectly, this would minimise the crowd perception of theme park guests while queueing, which is evidenced to have a massive impact on guest satisfaction. 

In conclusion, the present study proved both academic as well as social relevance by obtaining a dataset that contains information on queue times and weather conditions for a theme park in answering the research question; 

 

“What is the influence of weather conditions on queue times of theme park attractions?”  

As this research question can be considered broad to a certain extent, the dataset would allow to answer specific sub-questions. For example, the results can be aggregated on a park-level or attraction level. Alternatively, it could be used to see whether queue times for indoor and outdoor attractions differ based on weather conditions. Moreover, trends in queue times over time can be tracked to assess popularity of older and newer rides. 

Practical implications of the dataset include the opportunity to for example notify visitors of low queue times through the app in order to spread visitors more throughout the park. Additionally, historical data could be taken further by incorporating a predictive queue modelling feature in a theme park’s app. 

 

 

 

1.2	Please compare the various websites and APIs you assessed relevant to your data context. A table may help to compare data sources. Why did you choose your specific data source? Discuss the research fit, extraction method (e.g., web scraping vs. APIs), efficiency of resource use, and any other factors that made it emerge as the best choice. For tips, see challenges 1.1 and 1.2 in Boegershausen et al. 2022. 

When selecting APIs and data extraction methods, this study followed best practices derived from Boegerhauseen et al. (2022). Solutions and best practices were grouped into five categories utilised to access the quality of the data extraction method. The categories are research relevance, transparency and documentation, update frequency, reproducibility, and ethical and legal compliance, which will be further discussed below. 

Research relevance. Boegerhauseen et al. (2022) emphasise that researchers must ensure that their data sources allow for a valid operationalisation of theoretical constructs (Xu, Zhang, and Zhou, 2020). This is covered in the column “Research fit” in table 1 and 2. Here it is examined whether each API of web scraping is relevant to studying queue times. 

Transparency and documentation. According to Boegerhauseen et al. (2022), researchers should examine API and web scraping documentation carefully to understand variations in available data and ensure data transparency. Documentation with accessible and clear documentation should be prioritized, because they allow for transparent data collection and reduce ambiguity in how variables and data are structured. Boegerhauseen et al. (2022) state that extracting data via APIs is generally more scalable and poses fewer legal risks than web scraping. This is covered in the column “Description”and “Extraction method” in table 1 and 2.  

Reliability and stability. It is important to rely on API’s and data sources to be both stable and actively maintained to prevent issues like data loss and interruptions. As emphazised by Boegerhaussen et al. (2022), relying on interfaces that are updated regularly improves long-term compatibility. Therefore, the “reliability” column is added to tables 1 and 2. 

Update frequency. Priority was given to APIs that update regularly enough to record hourly and daily dynamics. The validity may be diminished if the frequency of data extraction is not in line with the psychological processes of interest (Boegerhaussen et al., 2022). To ensure validity, the column “Update Frequency” will be checked in tables 1 and 2.  

Reproducibility. Clear documentation must be kept during the data collection process to ensure accuracy and completeness. Through these steps, use, reuse, and replicability is ensured (Boegershausen et al., 2022). This is reflected in the “Extraction method” and “Research fit” columns, where the use of code-based APIs and well-documented client libraries enables transparent, replicable, and automated data collection.  

Ethical and legal compliance. The sources need assessment in relation to terms of service and relevant standards of ethical conduct. Data should be collected through official and documented API’s, and web scraping is used when no official interface was available. Boegershausen et al. (2022) emphasized the importance of not creating fake accounts and inspecting robots.txt to ensure compliance with the policies of the sourced platform. This criterion is reflected in the columns “Extraction method” and “Limitation” in tables 1 and 2, where legal and ethical considerations are explicitly addressed. 

 

Table 1: Assessing Data Options for Theme Park Queue Times 

Description  

Extraction method  

Description  

Research fit  

Reliability  

Update frequenccy  

Limitations  

Theme Park Queue  

(https://queue-times.com/parks) 

Queue times API  

Offering waiting time and current ride status  

Researching the flow of visitors in the parks  

High: Collection from different themepark feeds  

Updated every 5 minutes  

Small parks not included  

Theme park queue times  

(https://themeparks.wiki) 

Themeparks Parks API  

Open-source module providing structured real-time data on rides, shows, restaurants from the major global parks  

Excellent fit, offering real time crowd flow within the parks  

High, reliable in an active developer community  

Real-time (minutes)  

RequiresAPI configuration and credentials for certain parks  

Waitingtimes.app API  

(https://www.wartezeiten.app) 

Warzeiten.app API  

Offering ride and waittimes for selected themeparks  

Useful for cross-country comparison of park attendance patterns   

Moderate: Less transparent about their data sourcing  

Every few mintues  

Limited to selected parks, accuracy may vary  

Theme Parks Wiki 

(https://themeparks.wiki/api ) 

ThemeParks.wiki Python Client  

Retrieves live data, park schedules and entity metadata through code intergration  

Good for automated data collection and reproducible research.   

High: uses stable endpoints from ThemeParks backed, and open source.   

Updated every few minutes   

Dependent on upstream feeds, client maintenance varies.  

  

Themepark Queue times  

(https://github.com/cubehouse/themeparks) 

Themeparks API  

Provides a list of supported parks and some basic meta data  

Good for initial data discovery  

Its open, but is part of deprecated preview that could become outdated  

Real-time acces when queried  

Limited data depth 

 

Table 2: Assessing Data Options for Weather 

Description  

Extraction method  

Description  

Research fit   

Reliability  

Update frequency  

Limitations  

Wheater 

(https://www.knmi.nl) 

  

KNMI Web Scraping  

Official Dutch Wheather service providing temperature, precipitation, and wind observation from local weather stations  

Excellent for Dutch based parks  

High – government based source  

Every 10 minutes to hourly  

Page structure changes, making it harder to scrape and needs to be in line with robot.txt  

Timeanddate/weather  

(https://www.timeanddate.com/weather/) 

Web scraping  

Provide weather forecast, sunrise/sunset and historic data per city  

Good to parse with BeautifulSoup  

High: stable and widely used  

Every 30-60 minutes  

Respect robot.txt   

Wheather 

(https://www.weather.gov/documentation/services-web-api)  

weather.gov API  

REST API provided by the U.S. Governmentn, offering current weather conditions, forecasts, and alerts across the United States  

Good fit for studies focused in the U.S.  

High, official government source  

Every few minutes  

Only U.S. Coverage  

Open_meteo API  

(https://open-meteo.com)  

Open-Meteo API  

Free, open-source API with forecasts, hourly and historical weather data globally.  

Good for large-scale reproducible weather analysis.   

High: stable endpoints, open documentation, and transparent data sources.   

Every hour.   

Some advanced features only in premium versions. Free versions can only be utilized for non-commercial use.  

WeatherAPI.com 

(https://www.weatherapi.com)  

WeatherAPI.com API   

Provides real-time weather, forecasts, historical data, and global coverage.  

Good for detailed temporal analysis.   

High: large user base and clear documentation   

Very frequent, e.g. 15-minute interval weather forecasts.  

Free tier has usage limits, might require API key and payment for scale.   

 

 

After accessing the different data sources and comparing them to the five quality categories, table 1 and 2 illustrate how each API or web scraping aligns with the best practices and solutions as discussed by Boegershausen et al. (2022).  

Evaluating the theme park and weather data options, it can be concluded that APIs are able to provide greater transparency, consistency, and ethical compliance compared to web scraping methods. They offer access to data under clear usage policies, which help mitigate scalability limitations and legal risks associated with webscraping.  

Of the theme park data options, Theme Parks Wiki was selected, because of its real-time, detailed queue times and attraction data for the major team parks and shows a well-maintained python client that is open-source code. This will ensure a stable and reproducible data collection flow. The API endpoints that are accessed by the client are backed by a developer community. This ensures that the data is reliable and frequently updated, in this case every few minutes. Compared to some of the other sources, the data offering is more extensive on the ride level, crucial for analysing weather dealing with indoor and outdoor waiting lines. Lastly, the open source offers a lot of transparency in the data extraction method, encouraging great adaptation for future research. Overall, the Themepark_python environment of Theme Parks Wiki has great research fit, reliable data and ease of intergration making it the best choice for this project 

Looking at the weather data options, when the web scrapings are excluded, the Weather.gov API, Open-Meteo API, and the WeatherAPI.com remain. The Open-Meteo API was selected as the preferred data source, since it aligns best with the five quality criteria. The other weather API, such as WeatherAPI.com, were reliable but required an authentication key, had limited functionality for free users, and enforced rate limits. These restrictions have a negative impact on the reproducibility of the data collection process and reduce accessibility. The other API, Weather.gov, provides meteorological and accurate data but is restricted to the United States. This geographical restriction makes this API less suitable for analysis, since it requires global coverage. 

 

 

1.3	Who created this dataset (e.g., which team). Mention you are students of the Marketing Analytics program at Tilburg University. 

This project is set up as part of the course Online Data Collection & Management of the Master of Science Marketing Analytics program at Tilburg University, based in The Netherlands. The project is implemented by: 

Britt van Haaster 

Isah Huijbregts 

Lars van der Kroft 

Amanda van Lankveld 

Amy Quist 

Stefan Valentijn 

2.		Data Extraction Plan 

2.1	Please describe your data extraction plan in such a way that another researcher or team could replicate your data collection process. Which information to extract from which pages, how to sample, at which frequency to extract the data, and how to process the data during the collection. In your description, explain how you tackled the various validity, legal/ethical, and technical challenges. See Boegershausen et al. (2022, challenges 2.1-2.4) for tips. 

As previously identified, APIs will be used to construct a dataset that comprises a) historical theme park queue times and b) weather conditions. For feasibility, the focus is on one theme park: The Efteling. As such, the former API will gather the historical queue time information per attraction of the theme park. On the other hand, the latter API will gather the historical weather conditions per day. Nevertheless, the APIs chosen can also be specified to other theme parks and have therefore been chosen, so additional data can be added using the same methodology. 

Extraction design  

Variables obtained through the theme park API include the theme park name (Efteling), attraction name (e.g. Carnaval Festival), a queue time in minutes (e.g. 20), the timestamp at which that queue time was sampled in Unix timestamp format and the respective date. Variables from the weather API include information about the (average?) temperature, humidity, rain, and wind of a particular day. 

The queue data was extracted every 5 minutes, consistent with the API’s refresh rate and with Boegershausen et al. (2022) guidance to align data frequency with the psychological processes under study. The refresh rate of retrieving the weather data is synced to that of the queue times to allow a joint dataset. Data only gets extracted during the opening times of the theme park, which can be web scraped from this historic calender(?). For the time frame, summer 2022 – summer 2025 is chosen, given that the COVID-period had a significant impact on the park’s capacity and queue times. 

Data is automatically scraped, collected, and merged into Python. Each entry of new data comes with a time stamp, for easy analysis and for the synchronization of weather data and queue time data.  

But how will we exactly scrape the data? With the “ThemeParks_Python” API, it is easily possible to track live waiting times from specific rides in a themepark of choice. This makes it also relevant to later on replicate our research for a different theme park. 

For the weather data, we would have to set the latitude and longitude to the correct measurements of the midpoint of the Efteling. Then we can select all the hourly weather variables that are intersting for our case (temperature, rain, wind). Finally, we can manipulate the date button to extract the information for all of our variables. 

 

Validity, legal and ethical considerations 

All data is collected via officially documented APIs, ensuring compliance with the providers in terms of service and ethical standards for web scraping. The data sets do not contain personal information and will only contain observational data. For transparency and traceability, time stamps are added, and raw API responses are stored.  

Technical challenges  

The sample size of our project seems very big as we can go back into the past as much as beneficial to get the best results. As the data set can become quite large, possible storage issues might happen which need to be resolved. 2 other technical challenges that might come up would be related to time. Firstly, the Efteling does not have the same opening hours during the whole year, which might cause problems. Secondly, we would have to see what might happen when a ride gets closed during the day or has already been closed due to the misfunctioning of the ride. These 2 challenges might impact the reliability of the research.  

 

2.2	Does the dataset contain data that might be considered confidential or sensitive (e.g., personal data such as usernames or IP addresses, data that reveals racial or ethnic origins, sexual orientations, religious beliefs, political opinions or union memberships, financial or health data, biometric or genetic data, social security numbers, passwords, etc.)? If so, please provide a description. 

The dataset does not include any confidential or sensitive personal data. It includes no names, usernames, IP addresses, contact details, or any other identifiable or sensitive information.  The dataset only contains aggregated and anonymised observational data related to queue times and weather conditions in a theme park setting.  

 

2.3 If the dataset relates to people, is it possible to identify individuals (i.e., one or more natural persons), either directly or indirectly (i.e., in combination with other data) from the dataset? If so, please describe how. 

It is not possible to identify any individuals, either directly or indirectly, from the dataset. The data is collected and processed in an aggregated and anonymised way, ensuring that no natural person can be identified or linked to specific observations. It is a publicly availbale dataset of queue times and weather conditions, without collecting or storing any visitor data. Thus, the dataset is not able to be used to identify any visitors. 

 

3.		Data Extraction Process 

3.1	When was the data collected?  

 

3.2 	Please describe any technical challenges you encountered while scaling your data collection. How did you resolve them? Please provide a clear explanation of the debugging process (see Boegershausen et al. 2022, challenge 3.1). 

 

3.3 	What measures or monitoring systems were in place to ensure and validate the quality of the extracted data? Can you describe how these monitoring systems functioned? (see Boegershausen et al. 2022, challenge 3.2). 

 

3.4 	Can you specify the infrastructure you used for the deployment and execution of your data collection? 

 

4.		Preprocessing, cleaning, labeling 

4.1 After collecting the data, did you perform any data processing? If yes, please provide specific examples and explain the reasoning behind each step. 

 

4.2 Were any measures implemented to ensure privacy, such as anonymizing user data? Please describe the methods used. 

 

4.3 How did you address and clean out any implausible or erroneous observations in the dataset? 

 

4.4 Did you modify the data structure for long-term storage, like rearranging the dataset or renaming columns for clarity? If so, provide details on these changes and their rationale. 

 

4.5 What potential threats or biases could arise from your pre-processing steps? Please elaborate on any risks associated with the modifications made to the data and how they might impact the dataset's integrity or utility. 

 

5.		Data inspection 

5.1	Please provide a variety of meaningful summary statistics and plots. For example, consider means/SDs for continuous variables, frequency distributions for categorical variables or – in the case of plots – bar charts, line plots, or histograms. This part of the documentation is intended to illustrate the richness of the collected data. 

 

5.2	Is any information missing from individual instances? If so, please describe why this information is missing (e.g., because it was unavailable). This does not include intentionally removed information but might include, e.g., redacted text. 

 

6.		Reference List 

Guyt, J. Y., Datta, H., & Johannes Boegershausen. (2024). Unlocking the Potential of Web Data for Retailing Research. Journal of Retailing. https://doi.org/10.1016/j.jretai.2024.02.002 

 

Xu, Heng, Nan Zhang, and Le Zhou (2020), “Validity Concerns in 

Research Using Organic Data,” Journal of Management, 46 (7), 

1257–74. 

 

Backup links 

https://themeparks.wiki/api 

https://api.themeparks.wiki/docs/preview/#/parks/getParks 

https://github.com/themeparks/parksapi 

https://github.com/ThemeParks/ThemeParks_Python 

https://queue-times.com/nl/pages/api 

 

 
