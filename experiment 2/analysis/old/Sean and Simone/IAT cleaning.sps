* Encoding: UTF-8.
* This SPSS script wwas designed to analyze IAT data produced 
* gathered using the basic IAT Inquisit sample script, 'IAT.exp'.
* It was adapted from Tony Greenwald's Generic IAT SPSS syntax.
* The analysis computes D measures with the built-in error
* penalty as described in:
* Greenwald, A. G, Nosek, B. A., & Banaji, M. R. (2003).  Understanding 
*  and using the Implicit Association Test: I. An improved scoring algorithm.  
*  Journal of Personality and Social Psychology, 85, 197-216.

* TODO: change IAT.dat to the name of your data file.

GET TRANSLATE FILE = 'iat.dat'
  /TYPE=TAB /MAP /FIELDNAMES .

VALUE LABELS blocknum
 1 'Target practice'
 2 'Attribute practice'
 3 'First pairing practice'
 5 'First pairing test'
 6 'Reversed target practice'
 7 'Second pairing practice'
 9 'Second pairing test' .

IF (MOD(subject,2) = 1) ORDER = 1 .
IF (MOD(subject,2) = 0) ORDER = 2 .

COMPUTE PAIRING = 0.
IF ((ORDER=1) and (blocknum=3|blocknum=5)) PAIRING = 1.
IF ((ORDER=1) and (blocknum=7|blocknum=9)) PAIRING = 2.
IF ((ORDER=2) and (blocknum=7|blocknum=9)) PAIRING = 1.
IF ((ORDER=2) and (blocknum=3|blocknum=5)) PAIRING = 2.

COMPUTE TEST = 0.
IF (blocknum=3|blocknum=7) TEST = 1.
IF (blocknum=5|blocknum=9) TEST = 2.

VALUE LABELS 
   TEST 0 'single-task practice' 1 '1st combined block' 2 '2nd combined block'
 / correct 0 'error' 1 'correct' .

VARIABLE LABELS 
   correct  "0=error, 1=correct"
 / blocknum "block number"
 / trialnum "trial number"
 / ORDER "order of combined tasks"
 / PAIRING "paired categories"
 / TEST "1st or 2nd combined block".

VALUE LABELS 
   PAIRING 
    0 'single task practice'
    1 'compatible'
    2 'incompatible'
 / ORDER 
    1 'compatible first' 
    2 'incompatible first'.
COMPUTE error = 100*(1 - correct).

* Save data to re-use for computing other measures .
SAVE OUTFILE = 'C:\Users\pp05admin\Google Drive\Projects Ghent 2017\EC_Color\Results_Study1\temp.sav'  .

DESCRIPTIVES ALL . 

SUMMARIZE TABLES latency BY TEST BY PAIRING.

GET FILE = 'C:\Users\pp05admin\Google Drive\Projects Ghent 2017\EC_Color\Results_Study1\temp.sav' .
* Use data for Blocks 3,5,7, and 9 (i.e., TEST = 1 or 2) .
SELECT IF (TEST=1 OR TEST=2) .

* Mark trials with latency < 300 ms (for possible subject discard) .
COMPUTE FLAG_300 = 0 .
IF (LATENCY < 300) FLAG_300 = 1 .
* Mark trials with latency < 400 ms (to provide a count of these) .
COMPUTE FLAG_400 = 0 .
IF (LATENCY < 400) FLAG_400 = 1 .
* Mark trials with latency > 10000 ms (to provide a count of these) .
COMPUTE FLAG_10K = 0 .
IF (LATENCY GT 10000) FLAG_10K = 1 .

* Following line can be used to check frequencies of fast & slow responses & errors .
FREQUENCIES FLAG_300 FLAG_400 FLAG_10K ERROR .

* Record criteria for potential use in subject discards .
* This count can later be used as the basis for subject discard .
AGGREGATE OUTFILE = 'C:\Users\pp05admin\Google Drive\Projects Ghent 2017\EC_Color\Results_Study1\CRITERIA.SAV'
 / BREAK = SUBJECT ORDER
 / PCT_300 = PGT(FLAG_300,0) 
 / PCT_400 = PGT(FLAG_400,0)
 / PCT_10K = PGT(FLAG_10K,0)
 / AVELTNCY ERRORPCT = MEAN (LATENCY ERROR)
 / NTRIALS = N .

* Drop trials slower than 10000 ms for LATENCY .
SELECT IF (LATENCY LE 10000) .

* The following line deletes latencies less than 300. To prevent these trials from being
* discarded, add an asterisk before the next line to comment it out.
* SELECT IF (LATENCY GE 300) .

DESCRIPTIVES ALL.

* The following aggregate command computes block means and SDs needed for the D measures.
AGGREGATE OUTFILE = *
 / BREAK = SUBJECT BLOCKNUM ORDER PAIRING TEST
 / MEAN_LAT MEAN_ERR = MEAN(latency error) / SD_LAT = SD(latency)
 / NTRIALS = N .

DESCRIPTIVES ALL.

*Save this as a record of this stage of analysis .
SAVE OUTFILE = 'C:\Users\pp05admin\Google Drive\Projects Ghent 2017\EC_Color\Results_Study1\BIEP.ALL_MEANS&SDs.SAV' .

IF (PAIRING = 1) N1 = NTRIALS .
IF (PAIRING = 2) N2 = NTRIALS .
IF (PAIRING = 1) M1 = MEAN_LAT .
IF (PAIRING = 2) M2 = MEAN_LAT .
IF (PAIRING = 1) ERR1 = MEAN_ERR .
IF (PAIRING = 2) ERR2 = MEAN_ERR .
IF (PAIRING = 1) SD1 = SD_LAT .
IF (PAIRING = 2) SD2 = SD_LAT .

AGGREGATE OUTFILE = *
 / BREAK = SUBJECT ORDER TEST 
 / M1 M2 ERR1 ERR2 N1 N2 SD1 SD2 =
  FIRST(M1 M2 ERR1 ERR2 N1 N2 SD1 SD2) .

*Save this as a record of this stage of analysis .
SAVE OUTFILE = 'C:\Users\pp05admin\Google Drive\Projects Ghent 2017\EC_Color\Results_Study1\BIEP.MEANS&SDS.SAV' .

IF(TEST=1) ERR1a = ERR1 .
IF(TEST=1) ERR2a = ERR2 .
IF(TEST=2) ERR1b = ERR1 .
IF(TEST=2) ERR2b = ERR2 .

* These are the numerator components in millisecond units.
IF(TEST=1) M1a = M1 .
IF(TEST=1) M2a = M2 .
IF(TEST=2) M1b = M1 .
IF(TEST=2) M2b = M2 .

IF(TEST=1) SD1a = SD1 .
IF(TEST=1) SD2a = SD2 .
IF(TEST=2) SD1b = SD1 .
IF(TEST=2) SD2b = SD2 .

IF(TEST=1) N1a = N1 .
IF(TEST=1) N2a = N2 .
IF(TEST=2) N1b = N1 .
IF(TEST=2) N2b = N2 .

COMPUTE D_asis_num = M2 - M1.

*Use SD based on all responses (StanDevX) as denominator for D_biep .
COMPUTE D_asis_denom = SQRT( ( ((N1-1) * SD1**2 + (N2-1) * SD2**2)
                   + ((N1+N2) * ((M1-M2)**2) / 4) ) / (N1 + N2 - 1) ) .

IF (TEST=1) D_BIEP_a = D_asis_num / D_asis_denom .
IF (TEST=2) D_BIEP_b = D_asis_num / D_asis_denom .
IF (TEST=1) Na = N1+N2 .
IF (TEST=2) Nb = N1+N2 .

DESCRIPTIVES ALL . 

AGGREGATE OUTFILE = *
 / BREAK = SUBJECT ORDER
 / D_biep_a D_biep_b M1a M2a M1b M2b ERR1a ERR2a ERR1b ERR2b Na Nb = 
   FIRST(D_biep_a D_biep_b M1a M2a M1b M2b ERR1a ERR2a ERR1b ERR2b Na Nb).

VARIABLE LABELS
   D_biep_a 'd score 1st blocks'
 / D_biep_b 'd score 2nd blocks' 
 / Na '# trials, 1st combined blocks'
 / Nb '# trials, 2nd combined blocks'
 / M1a 'Mn Lat. 1st block, pairing 1'
 / M2a 'Mn Lat. 1st block, pairing 2' 
 / M1b 'Mn Lat. 2nd block, pairing 1' 
 / M2b 'Mn Lat. 2nd block, pairing 2' 
 / ERR1a 'Error %  1st block, pairing 1'
 / ERR2a 'Error %  1st block, pairing 2' 
 / ERR1b 'Error %  2nd block, pairing 1' 
 / ERR2b 'Error %  2ns block, pairing 2' 
 / SUBJECT 'Session ID' .

COMPUTE ERR_1 = (ERR1a + ERR1b) / 2 .
COMPUTE ERR_2 = (ERR2a + ERR2b) / 2 .
 
VARIABLE LABELS
   ERR_1 'Error % for Pairing 1 (both combined tasks)'
 / ERR_2 'Error % for Pairing 2 (both combined tasks)' .

*Compute unweighted combination of measures based on first and second blocks
  of combined tasks.
* !! Do this even if there are fewer trials in the first block because the 
*  first block has been found to have as good or better validity, even with 
*  fewer trials (see Greenwald, Nosek, & Banaji, JPSP 2003) .

COMPUTE D_biep = (D_biep_a + D_biep_b) / 2 .
VARIABLE LABELS
   D_biep   'd score all blocks' .


*************************************************************
** TO REVERSE THE SCORING OF THE IAT, REMOVE THE ASTERISKS **
** FROM THE NEXT FOUR COMMAND LINES.                       **
************************************************************* .

* COMPUTE D_biep = 0 - D_biep .
* COMPUTE D_biep_a = 0 - D_biep_a .
* COMPUTE D_biep_b = 0 - D_biep_b .
* VARIABLE LABELS
    D_biep   'd score all blocks' 
  / D_biep_a 'd score 1st blocks'
  / D_biep_b 'd score 2nd blocks' .

FORMAT D_biep D_BIEP_a D_BIEP_b D_BIEP (F6.3) SUBJECT (F7.0) 
    Na Nb (F4.0) M1a M2a M1b M2b (F7.1)
    ERR1a ERR2a ERR1b ERR2b ERR_1 ERR_2 (F5.1) .

SAVE OUTFILE = 'C:\Users\pp05admin\Google Drive\Projects Ghent 2017\EC_Color\Results_Study1\D_BIEP_temp.SAV' .
DESCRIPTIVES  ALL .

**************************************************************.
**** STEP 3: COMBINE MEASURES AND SAVE ****.
**************************************************************.

*Add labels to CRITERIA.SAV .
GET FILE = 'C:\Users\pp05admin\Google Drive\Projects Ghent 2017\EC_Color\Results_Study1\CRITERIA.SAV' .
VARIABLE LABELS
   PCT_300 '% latencies below 300 ms'
 / PCT_400 '% latencies below 400 ms'
 / PCT_10K '% latencies above 10,000 ms'
 / AVELTNCY 'Overall average latency (ms)'
 / ERRORPCT 'Overall % errors' 
 / NTRIALS 'Total # of combined-task trials' .

FORMAT AVELTNCY (F7.1) PCT_300 PCT_400 PCT_10K ERRORPCT (F6.1) SUBJECT (F7.0) .

SAVE OUTFILE = 'C:\Users\pp05admin\Google Drive\Projects Ghent 2017\EC_Color\Results_Study1\CRITERIA.SAV' .

*Combine and save .
MATCH FILES FILE = 'C:\Users\pp05admin\Google Drive\Projects Ghent 2017\EC_Color\Results_Study1\D_BIEP_temp.SAV' / 
FILE = 'C:\Users\pp05admin\Google Drive\Projects Ghent 2017\EC_Color\Results_Study1\CRITERIA.SAV' /BY SUBJECT  .

SAVE OUTFILE = 'C:\Users\pp05admin\Google Drive\Projects Ghent 2017\EC_Color\Results_Study1\D_BIEP.SAV' .

* Note: No subjects have yet been discarded.  However, each record contains .
* three variables that might be used for discard .
* PCT_300 = overall % of responses with latencies below 300 ms .
* ERRORPCT = overall error % .
* AVELTNCY = overall average latency .
* [Note that 'aveltncy' was computed _BEFORE_ discard of latencies above 10000 ms] .

GET FILE = 'C:\Users\pp05admin\Google Drive\Projects Ghent 2017\EC_Color\Results_Study1\D_BIEP.SAV' .
DESCRIPTIVES ALL .
