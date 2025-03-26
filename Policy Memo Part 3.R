library(ggplot2)

# Main Parameters
GDP_current <- 27.36  # in trillion USD
population <- 0.3349  # in billion people
wealth_top10_current <- 60  # in percentage

# GDP Parameters (2023)
beta_C <- 0.6817  
beta_I <- 0.207  
beta_G <- 0.207  

# Trump policy Changes
tax_rate <- 0.22  # 22%
tariff_increase <- 0.25  # 25% tariff increase
policy_shift_max <- tax_rate + tariff_increase  # Total policy shift

# Elasticity
GDP_elasticity <- beta_C + beta_I + beta_G  
wealth_elasticity <- 0.4 + 0.1  

# Functions
GDP_func <- function(theta) GDP_current * (1 + GDP_elasticity * theta)
Wealth_func <- function(theta) wealth_top10_current * (1 + wealth_elasticity * theta)
GDP_pc_func <- function(theta) GDP_func(theta) / population  

# Data
policy_shift <- seq(0, policy_shift_max, length.out = 100)
GDP_values <- sapply(policy_shift, GDP_func) 
GDP_pc_values <- sapply(policy_shift, GDP_pc_func)
Wealth_values <- sapply(policy_shift, Wealth_func)

# Data frame
data <- data.frame(policy_shift, GDP_values, GDP_pc_values, Wealth_values)

# Change in GDP
ggplot(data, aes(x = policy_shift, y = GDP_values - GDP_current)) +
  geom_line(color = "black", size = 1.2) +
  geom_vline(xintercept = tax_rate, linetype = "dashed", color = "red") +
  geom_vline(xintercept = tariff_increase, linetype = "dashed", color = "red") +
  labs(title = "Change in GDP with Policy Shifts",
       x = "Policy Shift (θ = ΔT + ΔTariff)",
       y = "Change in GDP (trillion USD)") +
  theme_minimal()

# Change in GDP per capita
ggplot(data, aes(x = policy_shift, y = GDP_pc_values)) +
  geom_line(color = "black", size = 1.2, linetype = "dashed") +
  geom_vline(xintercept = tax_rate, linetype = "dashed", color = "red") +
  geom_vline(xintercept = tariff_increase, linetype = "dashed", color = "red") +
  labs(title = "Change in GDP Per Capita with Policy Shifts",
       x = "Policy Shift (θ = ΔT + ΔTariff)",
       y = "GDP Per Capita (thousand USD/person)") +
  theme_minimal()

# Chang in wealth disparity
ggplot(data, aes(x = policy_shift, y = Wealth_values - wealth_top10_current)) +
  geom_line(color = "black", size = 1.2, linetype = "dotdash") +
  geom_vline(xintercept = tax_rate, linetype = "dashed", color = "red") +
  geom_vline(xintercept = tariff_increase, linetype = "dashed", color = "red") +
  labs(title = "Change in Wealth Disparity with Policy Shifts",
       x = "Policy Shift (θ = ΔT + ΔTariff)",
       y = "Change in Wealth Disparity (%)") +
  theme_minimal()

