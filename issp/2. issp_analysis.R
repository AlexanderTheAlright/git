# Load necessary library
library(MASS)  # for polr (ordinal logistic regression)
library(haven) # for reading in data
library(readr)
library(tidyr)
library(broom)
library(knitr)
library(stargazer)
library(ggplot2)

# load in dataset

# Drop NA values from df in the relevant variables
df <- df %>%
  drop_na("perceivedinequality",
          "gini",
          "age",
          "sex",
          "education",
          "sss",
          "survey_mode",
          "left",
          "execrlc")

# create opposed variable
df$opposed <- ifelse(df$execrlc == "Right" & df$left == 1, 1, 0)

# make sure 'perceivedinequality' and 'age' are numeric
df$perceivedinequality <- factor(df$perceivedinequality, ordered = TRUE)
df$age <- as.numeric(as.character(df$age))

# Assuming 'df' is your data frame
model_gini <- polr(perceivedinequality ~ gini + age + sex + education + sss + survey_mode, data = df, Hess = TRUE)
model_left <- polr(perceivedinequality ~ left + age + sex + education + sss + survey_mode, data = df, Hess = TRUE)
model_opposed <- polr(perceivedinequality ~ opposed + age + sex + education + sss + survey_mode, data = df, Hess = TRUE)
model_combined <- polr(perceivedinequality ~ gini + left + opposed + age + sex + education + sss + survey_mode, data = df, Hess = TRUE)

# Sensitivity analyses
# Interaction between gini and age
model_gini_interaction <- polr(perceivedinequality ~ gini*age + sex + education + sss + survey_mode, data = df, Hess = TRUE)

# Interaction between left and opposed in the combined model
model_combined_interaction <- polr(perceivedinequality ~ gini + left*opposed + age + sex + education + sss + survey_mode, data = df, Hess = TRUE)

# Model without sss and survey_mode
model_gini_simplified <- polr(perceivedinequality ~ gini + age + sex + education, data = df, Hess = TRUE)

# Model with only gini, left, and opposed
model_selective <- polr(perceivedinequality ~ gini + left + opposed, data = df, Hess = TRUE)

# Put into table
stargazer(model_gini, model_left, model_opposed, model_combined,
          type = "text",
          out = "y. regression_results.txt",
          column.labels = c("Model Gini", "Model Left", "Model Opposed", "Model Combined"),
          digits = 3)

# Means of perceived inequality by country
df %>%
  group_by(country_code) %>%
  summarize(mean_perceivedinequality = mean(perceivedinequality, na.rm = TRUE)) %>%
  ggplot(aes(x = country_code, y = mean_perceivedinequality)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  labs(title = "Average Perceived Inequality by Country",
       x = "Country Code",
       y = "Average Perceived Inequality (1 to 4)")





