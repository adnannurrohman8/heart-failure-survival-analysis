# Heart Failure Survival Analysis using Extended Cox Regression

Analisis kesintasan (*survival analysis*) untuk memodelkan faktor-faktor klinis yang memengaruhi risiko mortalitas pada pasien gagal jantung menggunakan **Cox Proportional Hazards** dan **Extended Cox Model** (*time-transform* covariate) di bahasa pemrograman R.

## Latar Belakang & Tujuan

Gagal jantung merupakan kondisi klinis serius dengan tingkat mortalitas yang tinggi. Proyek ini bertujuan untuk:

1. Mengidentifikasi variabel klinis yang berpengaruh signifikan terhadap waktu ketahanan hidup pasien gagal jantung.

2. Mengevaluasi asumsi *Proportional Hazards* (PH) menggunakan residu Schoenfeld.

3. Menangani kovariat yang melanggar asumsi PH dengan pemodelan efek bergantung waktu (*time-dependent coefficient*).

## Dataset

Dataset yang digunakan adalah **Heart Failure Clinical Records** yang terdiri dari **299 pasien** dengan **96 kejadian kematian** (*death events*) selama periode observasi (`time` dalam hari).

* **Variabel Respons:** `time` (durasi tindak lanjut dalam hari) dan `DEATH_EVENT` ($1 =$ meninggal, $0 =$ tersensor).

* **Kovariat Klinis:** `age`, `anaemia`, `creatinine_phosphokinase`, `diabetes`, `ejection_fraction`, `high_blood_pressure`, `platelets`, `serum_creatinine`, `serum_sodium`, `sex`, dan `smoking`.

## Metodologi & Alur Pemodelan

1. **Model Penuh (`regcox`):** Estimasi parameter Cox PH awal dengan seluruh 11 kovariat.

2. **Seleksi Kovariat (`regcox2`):** Penyederhanaan model menjadi 6 prediktor utama berdasarkan signifikansi parsial (`age`, `anaemia`, `creatinine_phosphokinase`, `ejection_fraction`, `high_blood_pressure`, `serum_creatinine`).

3. **Uji Asumsi Proportional Hazards (`cox.zph`):** Ditemukan bahwa variabel `ejection_fraction` melanggar asumsi PH ($p = 0.024$), sehingga efeknya tidak konstan sepanjang waktu.

4. **Extended Cox Model (`regcox3` & `regcox4`):** Menerapkan fungsi transformasi waktu $g(t) = \ln(t)$ melalui fungsi `tt(ejection_fraction)` untuk memodelkan perubahan risiko secara logaritmik terhadap waktu.

5. **Evaluasi & Seleksi Model Akhir:** Membandingkan kelayakan model menggunakan *Akaike Information Criterion* (AIC) dan *Concordance Index*.

## Ringkasan Hasil Utama

### Perbandingan Model

| Model | Deskripsi | df | Concordance | Likelihood Ratio Test | AIC | 
| ----- | ----- | ----- | ----- | ----- | ----- | 
| **`regcox2`** | Cox PH (6 kovariat tanpa `tt`) | 6 | 0.738 | $77.02$ ($p = 1 \times 10^{-14}$) | 953.39 | 
| **`regcox4`** | **Extended Cox (`tt(ejection_fraction)`)** | **6** | **0.737** | $80.22$ **(**$p = 3 \times 10^{-15}$**)** | **950.19** | 

Model akhir (**`regcox4`**) dipilih karena seluruh prediktor signifikan pada taraf $\alpha = 5\%$ dan menghasilkan nilai AIC yang lebih rendah ($\Delta \text{AIC} = 3.20$).

### Interpretasi Faktor Risiko Model Akhir (`regcox4`)

* **Usia (`age`):** $\text{HR} = 1.0450$ ($p = 7.47 \times 10^{-7}$) — Setiap kenaikan usia 1 tahun meningkatkan risiko kematian sebesar $4.50\%$.

* **Anemia (`anaemia`):** $\text{HR} = 1.5198$ ($p = 0.0499$) — Pasien dengan anemia memiliki risiko kematian $1.52\times$ lebih tinggi.

* **Creatinine Phosphokinase:** $\text{HR} = 1.0002$ ($p = 0.0422$) — Kenaikan kadar enzim CPK berkorelasi positif dengan peningkatan laju *hazard*.

* **Tekanan Darah Tinggi (`high_blood_pressure`):** $\text{HR} = 1.6258$ ($p = 0.0225$) — Pasien hipertensi memiliki risiko kematian $1.63\times$ lebih tinggi.

* **Serum Creatinine:** $\text{HR} = 1.4169$ ($p = 1.07 \times 10^{-7}$) — Setiap kenaikan $1\text{ mg/dL}$ kreatinin serum meningkatkan risiko kematian sebesar $41.69\%$.

* **Ejection Fraction (`tt(ejection_fraction)`):** $\hat{\gamma} = -0.01427$ ($p = 7.87 \times 10^{-8}$) — Efek protektif *ejection fraction* berubah terhadap waktu mengikuti $\text{HR}(t) = \exp(-0.01427 \cdot \ln(t))$, di mana kenaikan $1\%$ fraksi ejeksi menurunkan risiko kematian sekitar $3.23\%$ pada hari ke-10 ($t=10$) dan $6.36\%$ pada hari ke-100 ($t=100$).

## Struktur Repositori

```text
heart-failure-survival-analysis/
├── data/
│   └── heart_failure_clinical_records_dataset.csv
├── scripts/
│   └── survival_analysis.R
├── .gitignore
└── README.md
```

## Cara Menjalankan Analisis

1. *Clone* repositori ini ke komputer lokal Anda:

   ```bash
   git clone https://github.com/adnanrrohman25/heart-failure-survival-analysis.git
   cd heart-failure-survival-analysis
   ```

2. Pastikan paket `survival` sudah terpasang di R:

   ```r
   install.packages("survival")
   ```

3. Jalankan skrip analisis utama:

   ```r
   source("scripts/survival_analysis.R")
   ```

## Referensi

* Chicco, D., & Jurman, G. (2020). *Machine learning can predict survival of patients with heart failure from serum creatinine and ejection fraction alone*. BMC Medical Informatics and Decision Making, 20(16).

* Therneau, T. M., & Grambsch, P. M. (2000). *Modeling Survival Data: Extending the Cox Model*. Springer.
