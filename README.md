# Necessary and Sufficient Conditions for Observability of SLAM-based Microphone Array Calibration and Sound Source Localization

This is supplementary code for our paper 
```
Daobilige Su, He Kong, Salah Sukkarieh, Shoudong Huang, “Necessary and Sufficient Conditions for Observability of SLAM-based Microphone Array Calibration and Sound Source Localization”.
```

---

# Code
To run code, simply execute “main.m” file in Matlab. Tested in Matlab2018B, but should work with all Matlab versions after 2015A.

After successful execution, The following results shown below should show on Matlab console.
```
==================================================================
VI. ILLUSTRATIVE RESULTS
 
==================================================================
A. Cases when observability is guaranteed/impossible
 
------------------------------------------------------------------
Fig.4(a)
----------
O_r = [O_3^1;O_3^2;O_5^3]: 
    0.0011   -0.0007         0
    0.0017   -0.0021         0
    0.0013   -0.0008   -0.0025

rank(O_r) = 3
----------
G_2:
    0.0028    0.0009         0    1.0000    1.0000
    0.0029    0.0002         0    1.0000    2.0000
    0.0029   -0.0006         0    1.0000    3.0000
    0.0027   -0.0012         0    1.0000    4.0000
   -0.0002   -0.0028   -0.0008    1.0000   21.0000

rank(G_2) = 5
----------
rank(F) = 38, with column number of 38
----------
rank(J_G) = 275, with column number of 275
 
------------------------------------------------------------------
Fig.4(b)
----------
O_r = [O_3^1;O_3^2;O_5^3]: 
         0   -0.0013         0
    0.0002   -0.0013   -0.0001
   -0.0004   -0.0004   -0.0006

rank(O_r) = 3
----------
G_2:
   -0.0012   -0.0008    0.0025    1.0000    1.0000
   -0.0011   -0.0015    0.0023    1.0000    2.0000
   -0.0007   -0.0020    0.0021    1.0000    3.0000
   -0.0002   -0.0023    0.0018    1.0000    4.0000
    0.0003   -0.0024    0.0016    1.0000    5.0000

rank(G_2) = 5
----------
rank(F) = 38, with column number of 38
----------
rank(J_G) = 182, with column number of 182
 
------------------------------------------------------------------
Fig.5(a)
----------
O_r = [O_3^1;O_3^2;O_5^3]: 
    0.0011   -0.0007         0
    0.0016   -0.0026         0
    0.0026         0   -0.0029

rank(O_r) = 3
----------
G_2:
    0.0028    0.0009         0    1.0000    1.0000
    0.0029         0         0    1.0000    2.0000
    0.0029         0         0    1.0000    3.0000
    0.0029         0         0    1.0000    4.0000
   -0.0029         0         0    1.0000    6.0000

rank(G_2) = 4
----------
rank(F) = 34, with column number of 38
----------
rank(J_G) = 67, with column number of 71
 
------------------------------------------------------------------
Fig.5(c)
----------
O_r = [O_3^1;O_3^2;O_5^3]: 
   -0.0007   -0.0019         0
   -0.0004   -0.0016         0
   -0.0003         0   -0.0013

rank(O_r) = 3
----------
G_2:
   -0.0029         0         0    1.0000    9.0000
   -0.0029         0         0    1.0000   10.0000
   -0.0029         0         0    1.0000   11.0000
   -0.0029   -0.0003         0    1.0000   12.0000
   -0.0029   -0.0003   -0.0003    1.0000   13.0000

rank(G_2) = 4
----------
rank(F) = 36, with column number of 38
----------
rank(J_G) = 72, with column number of 74
 
==================================================================
B. Cases with only time offsets or clock drifts
 
------------------------------------------------------------------
Fig.5(c) with only time offset
----------
O_r = [O_3^1;O_3^2;O_5^3]: 
   -0.0007   -0.0019         0
   -0.0004   -0.0016         0
   -0.0003         0   -0.0013

rank(O_r) = 3
----------
G_2:
   -0.0029         0         0    1.0000
   -0.0029         0         0    1.0000
   -0.0029   -0.0003         0    1.0000
   -0.0029   -0.0003   -0.0003    1.0000

rank(G_2) = 3
----------
rank(F) = 29, with column number of 31
----------
rank(J_G) = 65, with column number of 67
 
------------------------------------------------------------------
Fig.5(c) with only clock drift
----------
O_r = [O_3^1;O_3^2;O_5^3]: 
   -0.0007   -0.0019         0
   -0.0004   -0.0016         0
   -0.0003         0   -0.0013

rank(O_r) = 3
----------
G_2:
   -0.0029         0         0   10.0000
   -0.0029         0         0   11.0000
   -0.0029   -0.0003         0   12.0000
   -0.0029   -0.0003   -0.0003   13.0000

rank(G_2) = 4
----------
rank(F) = 31, with column number of 31
----------
rank(J_G) = 67, with column number of 67
 
------------------------------------------------------------------
Fig.5(b) with only clock drift
----------
O_r = [O_3^1;O_3^2;O_5^3]: 
   -0.0007   -0.0019         0
   -0.0004   -0.0016         0
   -0.0003         0   -0.0013

rank(O_r) = 3
----------
G_2:
   -0.0029         0         0    9.0000
   -0.0029         0         0   10.0000
   -0.0029         0         0   11.0000
   -0.0029   -0.0003         0   12.0000

rank(G_2) = 3
----------
rank(F) = 27, with column number of 31
----------
rank(J_G) = 60, with column number of 64
 
==================================================================
C. Impact of eigenvalues of FIM on observability and convergence
of the system
 
Check plotting of Fig.6(b) below.
 
==================================================================
VII. EXPERIMENTAL RESULTS
 
------------------------------------------------------------------
Fig.8(a)
----------
O_r = [O_3^1;O_3^4;O_5^50]: 
   -0.0009   -0.0005         0
   -0.0010   -0.0006         0
   -0.0001   -0.0004   -0.0015

rank(O_r) = 3
----------
G_2:
    0.0015    0.0026         0    1.0000    1.0000
    0.0015    0.0026         0    1.0000    2.0000
   -0.0018   -0.0023         0    1.0000   30.0000
    0.0012   -0.0027         0    1.0000   50.0000
    0.0028   -0.0008         0    1.0000   70.0000

rank(G_2) = 4
----------
rank(F) = 24, with column number of 28
----------
rank(J_G) = 312, with column number of 316
 
------------------------------------------------------------------
Fig.8(b)
----------
This step will take a while (up to 1 min), please be patient ...
 
O_r = [O_3^1;O_3^4;O_5^50]: 
   -0.0009   -0.0005         0
   -0.0010   -0.0006         0
   -0.0001   -0.0004   -0.0015

rank(O_r) = 3
----------
G_2:
    0.0015    0.0026         0    1.0000    1.0000
   -0.0018   -0.0023         0    1.0000   30.0000
    0.0012   -0.0027         0    1.0000   50.0000
    0.0028   -0.0008         0    1.0000   70.0000
    0.0007    0.0001   -0.0029    1.0000  130.0000

rank(G_2) = 5
----------
rank(F) = 28, with column number of 28
----------
rank(J_G) = 715, with column number of 715
 
==================================================================
Plotting figures in Fig.4, Fig.6 and Fig.8
 
------------------------------------------------------------------
Plot Fig.4(a) in Fig. 1.
------------------------------------------------------------------
Plot Fig.4(b) in Fig. 2.
------------------------------------------------------------------
Plot Fig.6(a) in Fig. 3.
------------------------------------------------------------------
Plot Fig.6(b) in Fig. 4.
------------------------------------------------------------------
Plot Fig.8(b) in Fig. 5.
==================================================================
Finish
 
==================================================================
>> 
```

![Fig.4(a)](/blob/master/plots/fig4a.png)
![Fig.4(b)](./blob/master/plots/fig4b.png)
![Fig.6(a)](blob/master/plots/fig6a.png)
![Fig.6(b)](https://github.com/daobilige-su/obs-mic-array-calib/blob/master/plots/fig6b.png)
![Fig.8(b)](github.com/daobilige-su/obs-mic-array-calib/blob/master/plots/fig8b.png)

---

# Acknowledgement
The is code partially based on SLAM open course provided by Prof. Dr. Cyrill Stachniss from University of Bonn, Germany.
