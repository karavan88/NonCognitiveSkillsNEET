#-------------------------------------------------------------------
# Project: Non-Cognitive Skills of NEET
# Organization: SFedU Future Skills Research Lab
# Objective: Prepare a dataset for the analysis
# Author: Garen Avanesian, Valeria Egorova
# Date: 10 Nov 2023
#-------------------------------------------------------------------

# Read the script to uploaded necessary libraries
source(file.path(rcodes, "0200_load_packages.R"))

# Read files 
non_cogn  <- read_sav(file.path(inputData, "ind_25_noncognitive_for_all.sav"))
hi        <- read_sav(file.path(inputData, "r25i_os_32.sav"))
hh        <- read_sav(file.path(inputData,"r25h_os41.sav"))


# Process data
data_hh <- 
  hh %>%
  select(uf14, ub1.o, ua3, UID_H) %>%
  replace_with_na_all(condition = ~.x %in% c(99999996, 99999997, 99999998, 99999999))%>%
  mutate(x = uf14/ub1.o,
         number_of_fmem = ub1.o,
         windex = percent_rank(x),
         Income = uf14,
         family = ua3,
         uid_h = UID_H,
         windex5 = case_when(windex <= 0.20 ~ 1,
                             windex > 0.20 & windex <= 0.40 ~ 2,
                             windex > 0.4 & windex <= 0.60 ~ 3,
                             windex >= 0.61 & windex <= 0.80 ~ 4,
                             windex > 0.8  ~ 5,
                             T ~ as.numeric(NA)))

data_sel <- 
  hi %>%
  select(idind, uredid_i, status, uh5, uj1, uj72.5c, uj72.5e, u_age, uj1.1.3, uj13.2, uj57, uid_h,
         uj60,uj13.2, uj161.3y, uj161.3m, 
         uj70.2, uj72.1a, uj72.2a , uj72.3a, uj72.4a, uj72.5a, uj72.6a,uj72.18a, uj81,
         u_inwgt, u_diplom, uh3, uj65, uj62, 
         um20.7, uj322, uj72.171, uj65, um3, um71,
         um81, um80, uj161.3y) %>%
  replace_with_na_all(condition = ~.x %in% c(88888888, 99999996, 99999997, 99999998, 99999999))

data_hi = 
  data_sel %>%
  mutate(area = case_when(status %in% c(1,2) ~ "urban",
                          status %in% c(3,4) ~ "rural",
                          T ~ as.character(NA)),
         gender = ifelse(uh5 == 1, "male", "female"),
         age = u_age,
         Not_in_school = ifelse(uj70.2 == 2, 1, 0),
         Not_in_courses = ifelse(uj72.1a != 2, 1, 0),
         Not_in_ptu_non_usec = ifelse(uj72.2a !=2, 1, 0),
         Not_in_ptu_usec = ifelse(uj72.3a !=2, 1, 0),
         Not_in_tech = ifelse(uj72.4a != 2, 1, 0),
         Not_in_uni = ifelse(uj72.5a !=2, 1, 0),
         Not_in_postgrad = ifelse(uj72.6a !=2, 1, 0),
         h_edu = case_when(u_diplom %in% c(1,2,3) ~ "1. No school",
                           u_diplom == 4 ~"2. School",
                           u_diplom == 5 ~"3. Professional school",
                           u_diplom == 6 ~ "4. Higher education"),
         higher_edu = ifelse(h_edu == "4. Higher education", 1, 0),
         Not_working  = ifelse(uj1 == 5, 1, 0),
         Not_seeking_empl = ifelse(uj81 == 2, 1, 0),
         Months = case_when(!is.na(uj161.3m)  ~ uj161.3m/12, T ~0),
         life_satis = uj65,
         self_p_SES = case_when(uj62 %in% c(1:3) ~ 1,
                                uj62 %in% c(4:6) ~ 2,
                                uj62 %in% c(7:9) ~ 3,
                                T ~ as.numeric(NA))) %>%
  mutate(Not_in_education = ifelse(Not_in_school %in% c(1, NA) & Not_in_courses %in% c(1, NA)  & 
                                     Not_in_ptu_non_usec %in% c(1, NA)  &
                                     Not_in_ptu_usec %in% c(1, NA)  & Not_in_tech %in% c(1, NA)  & 
                                     Not_in_uni %in% c(1, NA)  & 
                                     Not_in_postgrad %in% c(1, NA), 1, 0),
         Unemployed = ifelse(Not_working == 1 & Not_seeking_empl == 1, 1, 0),
         family = uh3
         ) %>%
  mutate(
    NEET = ifelse(Not_in_education ==1 &  Not_working == 1, 1, 0),
    Salary = uj13.2,
    EXP = uj161.3y+Months) %>%
  select(idind,  uredid_i, area, gender,  age, Salary,uid_h , 
         Not_in_school, Not_in_courses , Not_in_ptu_non_usec, 
         Not_in_ptu_usec ,Not_in_tech , Not_in_uni , 
         Not_in_postgrad , Not_in_education, 
         Not_working, Not_seeking_empl, Unemployed, EXP, 
         NEET, h_edu, higher_edu, family,u_inwgt, life_satis,
         self_p_SES, uj62)%>%
  filter(age >=15 & age <=24)

# We need to produce based on household dataset SES variable 
ses_data = 
  data_hh %>%
  select(uid_h, Income, number_of_fmem , windex, windex5,  x) %>%
  mutate(Income1 = ifelse(is.na(Income), median(Income, na.rm = T), Income),
         hh_pers = ifelse(is.na(number_of_fmem), median(number_of_fmem, na.rm = T), number_of_fmem)) %>%
  mutate(Income_pc = Income1/number_of_fmem) %>%
  mutate(ses = ntile(Income_pc, 5)) %>%
  select(uid_h, ses)

