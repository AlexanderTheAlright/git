# Load necessary library
library(haven)

# Read the datasets
political_institutions_path <- "git/gitalec/issp/xxxx. political_institutions_database_2020.csv"
un_gini_path <- "git/gitalec/issp/xxx. un_gini_2019.csv"
issp_inequality_path <- "git/gitalec/issp/xx. issp_inequality_2019.dta"

political_institutions <- read.csv(political_institutions_path)
un_gini <- read.csv(un_gini_path)
issp_inequality <- read_stata(issp_inequality_path)

# Rename country columns to 'country' and convert to lowercase
political_institutions$country <- tolower(political_institutions$country_name)
un_gini$country <- tolower(un_gini$Country.or.Area)
issp_inequality$country <- tolower(issp_inequality$country)

# Filter the political institutions data for the year 2018
political_institutions_2018 <- subset(political_institutions, year == 2018)

# Select only relevant columns (including the new 'country' column)
political_institutions_2018 <- political_institutions_2018[, c("country", "execcrls")]
un_gini <- un_gini[, c("country", "Value")]

# Merge the political institutions data with the ISSP Inequality data
issp_inequality_merged <- merge(issp_inequality, political_institutions_2018,
                                by = "country", all.x = TRUE)

# Merge the UN GINI data with the ISSP Inequality data
df <- merge(issp_inequality_merged, un_gini, by = "country", all.x = TRUE)

# View the unified dataset
head(df)




