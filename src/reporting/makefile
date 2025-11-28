DATA = ../../data
TEMP = ../../data/temp
FINAL = ../../data/final

all: $(FINAL)/efteling_live_queue.csv $(FINAL)/efteling_his_complete.csv $(FINAL)/efteling_his_merged.csv

$(TEMP)/his_queue.csv: 1_Webscrape_queue_preprocessing.R $(DATA)/efteling_rides_all_years.csv
	Rscript --vanilla $<

$(TEMP)/his_info_and_weather.csv: 2_Webscrape_parkinfo_preprocessing.R $(DATA)/efteling_parkinfo_all_years.csv
	Rscript --vanilla $<

$(TEMP)/his_merged.csv: 3_Webscrape_merging.R $(TEMP)/his_info_and_weather.csv $(TEMP)/his_queue.csv
	Rscript --vanilla $<

$(TEMP)/live_queue.csv: 4_API_preprocessing.R $(DATA)/efteling_queue_data.csv
	Rscript --vanilla $<

$(FINAL)/efteling_live_queue.csv $(FINAL)/efteling_his_merged.csv: 5_AligningDataStreams.R $(TEMP)/his_merged.csv $(TEMP)/live_queue.csv
	Rscript --vanilla $<

$(FINAL)/efteling_his_complete.csv: 6_FeatureEngineering.R $(FINAL)/efteling_his_merged.csv
	Rscript --vanilla $<

clean:
	Rscript -e "unlink('../../data/temp', recursive = TRUE)"

.PHONY: all clean