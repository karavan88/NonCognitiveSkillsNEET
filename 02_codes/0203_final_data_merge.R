#-------------------------------------------------------------------
# Project: Non-Cognitive Skills of NEET
# Organization: SFedU Future Skills Research Lab
# Objective: Merge of multiple datasets into the final data for the study
# Author: Garen Avanesian, Valeria Egorova
# Date: 10 Nov 2023
#-------------------------------------------------------------------


data_neet <- 
  data_hi %>%
  filter(age >= 15 & age <= 24)%>%
  left_join(data_non_c) %>%
  left_join(ses_data) %>%
  mutate(ses = factor(ses),
         area = factor(area),
         gender = factor(gender),
         h_edu = factor(h_edu)) %>%
  select(idind, area, gender, age, NEET, h_edu, higher_edu,  u_inwgt, self_p_SES, 
         uid_h, Unemployed, O, C, E, A, N, G, ses, uj62)%>%
  drop_na()

# we need to save a maser data into the output folder. 
saveRDS(file.path(outData, "rlms_neet_youth.rds"))