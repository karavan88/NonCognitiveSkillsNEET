#-------------------------------------------------------------------
# Project: Non-Cognitive Skills of NEET
# Organization: SFedU Future Skills Research Lab
# Objective: to produce BFI scores for HSE RLMS individual data
# Author: Garen Avanesian, Valeria Egorova
# Date: 10 Nov 2023
#-------------------------------------------------------------------



# Replace NAs in the data file for non-cognitive skills
data_nc <- 
  non_cogn%>%
  replace_with_na_all(condition = ~.x %in% c(88888888, 99999996, 99999997, 99999998, 99999999))

openness <- c("o1", "o2", "o3")
con <- c("c1", "c2", "c3")
ex <- c("e1", "e2", "e3")
ag <- c("a1", "a2", "a3")
neur <- c("n1", "n2", "n3")
grit <- c("g1", "g2", "g3")

# Calculate BFI scores
data_non_c <- 
  data_nc%>%
  mutate(o1 = 5 - j445.3,
         o2 = 5 - j445.11,
         o3 = 5 - j445.14,
         c1 = 5 - j445.2,
         c2 = j445.12,
         c3 = 5 - j445.17,
         e1 = 5 - j445.1,
         e2 = j445.4, 
         e3 = 5 - j445.20,
         a1 = 5 - j445.9,
         a2 = 5 - j445.16,
         a3 = 5 - j445.19,
         n1 = 5 - j445.5,
         n2 = j445.10,
         n3 = j445.18,
         g1 = 5 - j445.6,
         g2 = 5 - j445.8,
         g3 = 5 - j445.13)%>%
  mutate(O = scale(rowMeans(select(., all_of(openness)), na.rm = T),center = TRUE, scale = TRUE),
         C = scale(rowMeans(select(., all_of(con)), na.rm = T),center = TRUE, scale = TRUE),
         E = scale(rowMeans(select(., all_of(ex)), na.rm = T),center = TRUE, scale = TRUE),
         A = scale(rowMeans(select(., all_of(ag)), na.rm = T),center = TRUE, scale = TRUE),
         N = scale(rowMeans(select(., all_of(neur)), na.rm = T),center = TRUE, scale = TRUE),
         G = scale(rowMeans(select(., all_of(grit)), na.rm = T),center = TRUE, scale = TRUE)) %>%
  select(idind,  O, C, E, A, N, G)





