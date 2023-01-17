

####################################################### DATA PREPROCESSING ###################################################################
# ANALYSE DE SURVIE DANS R : Audrey data
library("survival")
library("ggplot2")
library("survminer")
library('gtsummary')
library('FactoMineR')
library(maxstat)
require(dplyr)

set.seed(7)
myTable <- read.csv('../../data/working_data/final_df.csv',  na.strings=c("","NA"))

# PREPROCESS STATUS
myTable$PROG1 = as.numeric(as.vector(myTable$PROG1))
myTable$PROG2 = as.numeric(as.vector(myTable$PROG2))
myTable$DCD1 = as.numeric(as.vector(myTable$DCD1))
myTable$DCD2 = as.numeric(as.vector(myTable$DCD2))

# PREPROCESS TIMES
myTable$ID <- as.vector(myTable$ID)
myTable$PFS1 <- as.numeric(as.vector(myTable$PFS1/30.41))
myTable$PFS2 <- as.numeric(as.vector(myTable$PFS2/30.41))
myTable$OS1 <- as.numeric(as.vector(myTable$OS1/30.41))
myTable$OS2 <- as.numeric(as.vector(myTable$OS2/30.41))

# LIMITER LE TIME A 2.5 ANS (30 MOIS)
myTable$PFS1 <- ifelse(myTable$PFS1>30,30,myTable$PFS1)
myTable$PROG1 <- ifelse(myTable$PFS1>30,0,myTable$PROG1)

myTable$PFS2 <- ifelse(myTable$PFS2>30,30,myTable$PFS2)
myTable$PROG2 <- ifelse(myTable$PFS2>30,0,myTable$PROG2)

myTable$OS1 <- ifelse(myTable$OS1>30,30,myTable$OS1)
myTable$DCD1 <- ifelse(myTable$OS1>30,0,myTable$DCD1)

myTable$OS2 <- ifelse(myTable$OS2>30,30,myTable$OS2)
myTable$DCD2 <- ifelse(myTable$OS2>30,0,myTable$DCD2)

# TYPEOF
myTable$DICH_AGE = as.character(myTable$DICH_AGE)
myTable$KPS1 = as.character(myTable$KPS1)
myTable$KPS2 = as.character(myTable$KPS2)
myTable$loc2_bis = as.character(myTable$loc2_bis)
myTable$loc1_bis = as.character(myTable$loc1_bis)
myTable$EPILEPSIE = as.character(myTable$EPILEPSIE)
myTable$AEG = as.character(myTable$AEG)
myTable$DEFICIT = as.character(myTable$DEFICIT)
myTable$COMORBIDITY = as.character(myTable$COMORBIDITY)

####################################################### STAT DESCRIPTIVE###################################################################
#data = myTable %>% select(SEXE,AGE,DICH_AGE,COMORBIDITY,EPILEPSIE,AEG,DEFICIT,CTC2,
#                          loc1_bis,loc2_bis,COTE,IDH,MGMT,KPS1,KPS2,BIOPSIE1,TYPECHIR1_bis,
#                          TYPECHIR2,COMPLICATION1,COMPLICATION2,DECES,GROUP)

data = myTable %>% select(GROUP,AGE, PFS1,PROG1,PFS2,PROG2,OS1,DCD1,OS2,DCD2)
table = tbl_summary(data, by = GROUP,type = all_continuous() ~ "continuous2",statistic = all_continuous() ~ c("{N_nonmiss}","{median} ({p25}, {p75})","{min}, {max}"),missing = "no") %>% add_p(pvalue_fun = ~style_pvalue(.x, digits = 2))%>%add_n()%>% add_q(method="BH") 
table

# ---- Par GROUP  ----
table = tbl_summary(data, by=GROUP) %>%
  add_n() %>%  add_p() %>% add_q(method="BH") %>%
  modify_header(label = "**Variable**") %>% # update the column header
  bold_labels() 

table

chisq.test(myTable$COTE[-which(myTable$COTE=='DG')], myTable$GROUP[-which(myTable$COTE=='DG')])

####################################################### BOXPLOT ###################################################################
myTable$GROUP <- as.factor(myTable$GROUP)
p <- ggplot(myTable, aes(x=GROUP, y=OS1, fill=GROUP)) +
  geom_boxplot(notch=TRUE,outlier.colour="red", outlier.shape=8,outlier.size=4) +
  stat_summary(fun.y=mean, geom="point", shape=23, size=4) +
  geom_jitter(shape=16, position=position_jitter(0.2))+
  theme(legend.position="top")

####################################################### CHOOSE TIME AND STATUS ###################################################################
myTable$time= as.numeric(myTable$PFS1)
myTable$status= as.numeric(myTable$PROG1)
xlab = 'PFS1-month-'
main = 'ALL INDIVIDUS'

####################################################### KAPLAN MEIER ###################################################################
data = rad_df %>% select(SEXE,DICH_AGE,COMORBIDITY,EPILEPSIE,AEG,DEFICIT,CTC2,
                         loc1_bis,loc2_bis,COTE,IDH,MGMT, KPS2, TYPECHIR1_bis,COMPLICATION1,COMPLICATION2)

pval_df <- c()
for (i in colnames(data)){
  print(i)
  rad_df$COL <- rad_df[,i]
  diff <- survdiff(Surv(time, status) ~ COL,data=rad_df)
  pval <- pchisq(diff$chisq, length(diff$n)-1, lower.tail = FALSE)
  pval_df <- rbind(pval_df,cbind(round(pval, 3)))
  p <- ggsurvplot(survfit(Surv(time, status) ~ COL,data=rad_df),
                  legend = "bottom",legend.title = i,
                  pval=TRUE,risk.table = TRUE,
                  surv.median.line = 'h',
                  xlab = xlab,
                  ggtheme = theme_light())
  print(p)
  
}
pval_df = as.data.frame(pval_df)
rownames(pval_df) <- colnames(data)

# km par groupe
rad_df <- filter(myTable,GROUP %in% 'rad' )
surg_df <- filter(myTable,GROUP %in% 'surg' )
ggsurvplot(survfit(Surv(PFS1, PROG1) ~ KPS2,data=surg_df),
           legend = "bottom",
           pval=TRUE,risk.table = TRUE,
           surv.median.line = 'h',
           xlab = xlab,
           ggtheme = theme_light())


####################################################### UNIVARIATE ###################################################################
# WITH r METHOD
tbl_uv_ex2 <-tbl_uvregression(myTable[,c(2:23)],method = coxph,y = Surv(myTable$time,myTable$status),exponentiate = TRUE)
tbl_uv_ex2

# MANUALY
Cox_univ <-  c()
for (i in 2:21)
{
  print(colnames(myTable)[i])
  temp <- myTable[,c(32,33,i)] # 26 (PFS) 27 (PROG)
  a <- summary(coxph(Surv(temp$time,temp$status)~temp[,3],data=temp)) 
  Cox_univ <- rbind(Cox_univ,cbind(colnames(myTable)[i],a$conf.int[,1],a$conf.int[,3],a$conf.int[,4],a$coefficients[,5]))
}
Cox_univ <- as.data.frame(Cox_univ)
colnames(Cox_univ) <- c("VAR","HR","lower","upper","Cox_univ")

####################################################### MULTIVARIATE ###################################################################

modele_cont <- coxph(Surv(myTable$time,myTable$status)~ COMORBIDITY+TYPECHIR2+TYPECHIR1_bis, data= myTable)
myTable_without_na=myTable[complete.cases(myTable[,c('COMORBIDITY','TYPECHIR2','TYPECHIR1_bis')]), ] 
myTable_without_na$pred <- modele_cont$linear.predictors
c <- median(myTable_without_na$pred, na.rm=T)
myTable_without_na$pred_dicho <- relevel(as.factor(ifelse(myTable_without_na$pred>c,"high","low")), ref='low')
km <- survfit(Surv(time,status)~pred_dicho,data=myTable_without_na)
ggsurvplot(km, data=myTable_without_na, pval=FALSE,risk.table = TRUE, surv.median.line = 'h',xlab = xlab,ggtheme = theme_light())
modele_cont_dich <- coxph(Surv(myTable_without_na$time,myTable_without_na$status)~ pred_dicho, data= myTable_without_na)

#DISPLAY RESULTS
summary(modele_cont)
print('#'*100)
summary(modele_cont_dich)


####################################################### INTERATIONS WITH GROUP ###################################################################
my_var <- list('BIOPSIE1', 'loc1_bis', 'loc2_bis', 'TYPECHIR1_bis')
for (COL in my_var){
  print(COL)
  myTable$interest_var = myTable[,COL]
  modele_cont <- coxph(Surv(myTable$time,myTable$status)~ interest_var*GROUP, data= myTable)
  print(summary(modele_cont))
}



####################################################### DECISION TREE ###################################################################
myTable$time = ifelse(myTable$time==0,1,myTable$time)
tfit = rpart(formula = Surv(time, status) ~ SEXE+DICH_AGE+COMORBIDITY+EPILEPSIE+AEG+DEFICIT+CTC2+loc1_bis+loc2_bis+COTE+IDH+MGMT+KPS1+KPS2+BIOPSIE1+TYPECHIR1_bis+TYPECHIR2+COMPLICATION1+COMPLICATION2, data = myTable, control=rpart.control(minsplit=30, cp=0.01))
plot(tfit); text(tfit)
(tfit2 <- as.party(tfit))
plot(tfit2)


####################################################### KM AVEC LES GROUPES DES DIFFERENTS NOEUDS  ###################################################################
id_node=vector(le=nrow(myTable))
id_node[which(myTable$TYPECHIR2=='NON')]="Node1"
id_node[which(myTable$TYPECHIR2 %in% c('EST', 'ET') & myTable$COMORBIDITY %in% c(0, 2))]="Node2"
id_node[which(myTable$TYPECHIR2 %in% c('EST', 'ET') & myTable$COMORBIDITY == 1)]="Node3"

myt2=data.frame(myTable[-which(id_node=="FALSE"),],node=id_node[-which(id_node=="FALSE")])
fit<- survfit(Surv(time, status) ~ node, data = myt2)
ggsurvplot(fit, data = myt2,
           surv.median.line = "hv", # Add medians survival
           legend.title = "Pred group",
           legend.labs = c("TYPECHIR2=NON", "TYPECHIR2=EST/ET & COMORBIDITY=0/2","TYPECHIR2=EST/ET & COMORBIDITY=1"),
           pval = TRUE,
           conf.int = FALSE,
           risk.table = TRUE,
           tables.height = 0.2,
           tables.theme = theme_cleantable(),
           palette = "jco",
           ggtheme = theme_bw()
)


modele_cont <- coxph(Surv(myt2$time,myt2$status)~ node, data= myt2)
summary(modele_cont)






























