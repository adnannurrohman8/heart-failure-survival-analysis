library(survival)

#dataset 
data <- read.csv("heart_failure_clinical_records_dataset.csv")
head(data)
event = data$DEATH_EVENT

#regresi cox ph
regcox <- coxph(Surv(time, event)~age+
                  anaemia+
                  creatinine_phosphokinase +
                  diabetes+
                  ejection_fraction+
                  high_blood_pressure+
                  platelets+
                  serum_creatinine+
                  serum_sodium+
                  sex+
                  smoking, data = data)
summary(regcox)
cox.zph(regcox)

regcox2 <- coxph(
  Surv(time, event) ~ age +
    anaemia +
    creatinine_phosphokinase +
    ejection_fraction +
    high_blood_pressure +
    serum_creatinine,
  data = data)
summary(regcox2)
cox.zph(regcox2)

regcox3 <- coxph(
  Surv(time, event) ~ age +
    anaemia +
    creatinine_phosphokinase +
    ejection_fraction +
    tt(ejection_fraction) +
    high_blood_pressure +
    serum_creatinine,
  data = data,
  tt = function(x, t, ...) x * log(t)
)
summary(regcox3)

regcox4 <- coxph(
  Surv(time, event) ~ age +
    anaemia +
    creatinine_phosphokinase +
    tt(ejection_fraction) +
    high_blood_pressure +
    serum_creatinine,
  data = data,
  tt = function(x, t, ...) x * log(t)
)
summary(regcox4)

AIC(regcox2, regcox4)
