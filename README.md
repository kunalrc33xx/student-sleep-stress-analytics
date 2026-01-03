# Sleep Helps, Stress Decides: The Real Driver of Student Success

![Status](https://img.shields.io/badge/Status-Completed-success)
![Tools](https://img.shields.io/badge/Tools-R_|_Excel_|_Regression_Analysis-blue)
![Focus](https://img.shields.io/badge/Focus-People_Analytics_|_Public_Health-purple)

## Executive Summary
**The Myth:** "More study hours + Less sleep = Better Grades."
**The Reality:** Our analysis of university student data reveals that **Academic Pressure**, not sleep deprivation, is the primary driver of performance—but negatively.

**The Project:** We analyzed the relationship between lifestyle choices (sleep, study hours) and outcomes (CGPA, Depression, Stress) using a Kaggle dataset of university students. The goal was to identify the "Sweet Spot" for student well-being and performance.

**Key Impact:**
* Identified **7-8 hours** as the optimal sleep window, correlating with the highest CGPA (**7.71/10**) and lowest stress (**3.11/5**).
* Discovered that **Academic Pressure** is the strongest predictor of performance (p < 0.001), heavily outweighing study hours.
* Modeled a "Mental Health Cliff": The probability of depression rises from **20%** at low pressure to **86%** at maximum pressure.

---

## Key Findings & Visuals

### 1. The Sleep "Sweet Spot"
We grouped students by sleep duration to find the optimal balance.
* **< 5 Hours:** Avg CGPA 7.65 | Pressure 3.22 (Worst)
* **7-8 Hours:** Avg CGPA 7.71 | Pressure 3.11 (Best)
* **> 8 Hours:** Avg CGPA 7.68 | Pressure 3.14
* *Insight:* Diminishing returns exist at both extremes. 7-8 hours is the statistical optimum.

### 2. The "Pressure" Paradox (Regression Analysis)
Using Multiple Linear Regression, we controlled for variables to find the true drivers of CGPA.
* **Academic Pressure:** Significant negative coefficient (Higher pressure = Lower Grades).
* **Study Hours:** Surprisingly weak correlation with CGPA when pressure is high.
* *Takeaway:* Reducing stress is more effective for grade improvement than merely increasing study hours.

### 3. Geographic & Demographic Risk
* **Metro Cities (Bangalore/Delhi):** Students here report significantly higher academic pressure than those in smaller towns.
* **Degree Type:** Engineering and Medical students showed the highest baseline stress levels.

---

## Strategic Recommendations

Based on the data, we proposed a "Wellness-First" Academic Policy:
1.  **Prioritize Health:** Shift institutional focus from "Study Hours" to "Stress Reduction."
2.  **Target High-Risk Segments:** Deploy specific mental health interventions for students in Metro hubs and intense degree programs (Engineering).
3.  **Systemic Change:** Implement "Academic Forgiveness" policies or wellness days during finals to mitigate pressure spikes.

---

## Tools & Methodology
* **Statistical Analysis:** Multiple Linear Regression, Descriptive Statistics (in **R** & **Excel**).
* **Data Processing:** Pivot Tables, Data Cleaning, Variable Transformation.
* **Visualization:** PowerPoint & Excel Charts.

---
*This project was conducted as part of the BUDT730: Data Models and Decisions course at the University of Maryland.*
