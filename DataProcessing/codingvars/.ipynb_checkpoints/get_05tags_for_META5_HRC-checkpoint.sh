#!/bin/sh


#Cornelis Blauwendraat
#December 2019


# sbatch --cpus-per-task=20 --mem=140g --mail-type=END --time=3:00:00 get_05tags_for_META5.sh

cd $PATH1
mkdir TEMPO
cd TEMPO

echo 1:154898185 > 1:154898185.txt
echo 1:155135036 > 1:155135036.txt
echo 1:155205634 > 1:155205634.txt
echo 1:161469054 > 1:161469054.txt
echo 1:171719769 > 1:171719769.txt
echo 1:205723572 > 1:205723572.txt
echo 1:205737739 > 1:205737739.txt
echo 1:226916078 > 1:226916078.txt
echo 1:232664611 > 1:232664611.txt
echo 2:18147848 > 2:18147848.txt
echo 2:96000943 > 2:96000943.txt
echo 2:102396963 > 2:102396963.txt
echo 2:135464616 > 2:135464616.txt
echo 2:169110394 > 2:169110394.txt
echo 3:18361759 > 3:18361759.txt
echo 3:28705690 > 3:28705690.txt
echo 3:48748989 > 3:48748989.txt
echo 3:122196892 > 3:122196892.txt
echo 3:151108965 > 3:151108965.txt
echo 3:161077630 > 3:161077630.txt
echo 3:182760073 > 3:182760073.txt
echo 4:925376 > 4:925376.txt
echo 4:951947 > 4:951947.txt
echo 4:15737348 > 4:15737348.txt
echo 4:17968811 > 4:17968811.txt
echo 4:77110365 > 4:77110365.txt
echo 4:77147969 > 4:77147969.txt
echo 4:77198054 > 4:77198054.txt
echo 4:90626111 > 4:90626111.txt
echo 4:90636630 > 4:90636630.txt
echo 4:114369065 > 4:114369065.txt
echo 4:170583157 > 4:170583157.txt
echo 5:60137959 > 5:60137959.txt
echo 5:102365794 > 5:102365794.txt
echo 5:134199105 > 5:134199105.txt
echo 6:27738801 > 6:27738801.txt
echo 6:30108683 > 6:30108683.txt
echo 6:32578772 > 6:32578772.txt
echo 6:72487762 > 6:72487762.txt
echo 6:112243291 > 6:112243291.txt
echo 6:133210361 > 6:133210361.txt
echo 7:23300049 > 7:23300049.txt
echo 7:66009851 > 7:66009851.txt
echo 8:11712443 > 8:11712443.txt
echo 8:16697593 > 8:16697593.txt
echo 8:22525980 > 8:22525980.txt
echo 8:130901909 > 8:130901909.txt
echo 9:17579690 > 9:17579690.txt
echo 9:17727065 > 9:17727065.txt
echo 9:34046391 > 9:34046391.txt
echo 10:15557406 > 10:15557406.txt
echo 10:104015279 > 10:104015279.txt
echo 10:121415685 > 10:121415685.txt
echo 10:121536327 > 10:121536327.txt
echo 11:10558777 > 11:10558777.txt
echo 11:83487277 > 11:83487277.txt
echo 11:133787001 > 11:133787001.txt
echo 12:40614434 > 12:40614434.txt
echo 12:40734202 > 12:40734202.txt
echo 12:46419086 > 12:46419086.txt
echo 12:123326598 > 12:123326598.txt
echo 12:133063768 > 12:133063768.txt
echo 13:49927732 > 13:49927732.txt
echo 13:97865021 > 13:97865021.txt
echo 14:37989270 > 14:37989270.txt
echo 14:55348869 > 14:55348869.txt
echo 14:75373034 > 14:75373034.txt
echo 14:88464264 > 14:88464264.txt
echo 15:61997385 > 15:61997385.txt
echo 16:19277493 > 16:19277493.txt
echo 16:28944396 > 16:28944396.txt
echo 16:30977799 > 16:30977799.txt
echo 16:50736656 > 16:50736656.txt
echo 16:52636242 > 16:52636242.txt
echo 16:52969426 > 16:52969426.txt
echo 17:7355621 > 17:7355621.txt
echo 17:40741013 > 17:40741013.txt
echo 17:42294337 > 17:42294337.txt
echo 17:42434630 > 17:42434630.txt
echo 17:43744203 > 17:43744203.txt
echo 17:43798308 > 17:43798308.txt
echo 17:44866805 > 17:44866805.txt
echo 17:59917366 > 17:59917366.txt
echo 17:76425480 > 17:76425480.txt
echo 18:31304318 > 18:31304318.txt
echo 18:40673380 > 18:40673380.txt
echo 18:48683589 > 18:48683589.txt
echo 19:2341047 > 19:2341047.txt
echo 20:6006041 > 20:6006041.txt
echo 21:38852361 > 21:38852361.txt

cd $PATH2


plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/1:154898185.txt --chr 1 --out ../TEMPO/1:154898185
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/1:154898185.txt --chr 1 --out ../TEMPO/1:154898185
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/1:155135036.txt --chr 1 --out ../TEMPO/1:155135036
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/1:155205634.txt --chr 1 --out ../TEMPO/1:155205634
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/1:161469054.txt --chr 1 --out ../TEMPO/1:161469054
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/1:171719769.txt --chr 1 --out ../TEMPO/1:171719769
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/1:205723572.txt --chr 1 --out ../TEMPO/1:205723572
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/1:205737739.txt --chr 1 --out ../TEMPO/1:205737739
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/1:226916078.txt --chr 1 --out ../TEMPO/1:226916078
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/1:232664611.txt --chr 1 --out ../TEMPO/1:232664611
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/2:18147848.txt --chr 2 --out ../TEMPO/2:18147848
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/2:96000943.txt --chr 2 --out ../TEMPO/2:96000943
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/2:102396963.txt --chr 2 --out ../TEMPO/2:102396963
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/2:135464616.txt --chr 2 --out ../TEMPO/2:135464616
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/2:169110394.txt --chr 2 --out ../TEMPO/2:169110394
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/3:18361759.txt --chr 3 --out ../TEMPO/3:18361759
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/3:28705690.txt --chr 3 --out ../TEMPO/3:28705690
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/3:48748989.txt --chr 3 --out ../TEMPO/3:48748989
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/3:122196892.txt --chr 3 --out ../TEMPO/3:122196892
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/3:151108965.txt --chr 3 --out ../TEMPO/3:151108965
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/3:161077630.txt --chr 3 --out ../TEMPO/3:161077630
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/3:182760073.txt --chr 3 --out ../TEMPO/3:182760073
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/4:925376.txt --chr 4 --out ../TEMPO/4:925376
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/4:951947.txt --chr 4 --out ../TEMPO/4:951947
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/4:15737348.txt --chr 4 --out ../TEMPO/4:15737348
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/4:17968811.txt --chr 4 --out ../TEMPO/4:17968811
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/4:77110365.txt --chr 4 --out ../TEMPO/4:77110365
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/4:77147969.txt --chr 4 --out ../TEMPO/4:77147969
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/4:77198054.txt --chr 4 --out ../TEMPO/4:77198054
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/4:90626111.txt --chr 4 --out ../TEMPO/4:90626111
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/4:90636630.txt --chr 4 --out ../TEMPO/4:90636630
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/4:114369065.txt --chr 4 --out ../TEMPO/4:114369065
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/4:170583157.txt --chr 4 --out ../TEMPO/4:170583157
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/5:60137959.txt --chr 5 --out ../TEMPO/5:60137959
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/5:102365794.txt --chr 5 --out ../TEMPO/5:102365794
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/5:134199105.txt --chr 5 --out ../TEMPO/5:134199105
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/6:27738801.txt --chr 6 --out ../TEMPO/6:27738801
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/6:30108683.txt --chr 6 --out ../TEMPO/6:30108683
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/6:32578772.txt --chr 6 --out ../TEMPO/6:32578772
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/6:72487762.txt --chr 6 --out ../TEMPO/6:72487762
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/6:112243291.txt --chr 6 --out ../TEMPO/6:112243291
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/6:133210361.txt --chr 6 --out ../TEMPO/6:133210361
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/7:23300049.txt --chr 7 --out ../TEMPO/7:23300049
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/7:66009851.txt --chr 7 --out ../TEMPO/7:66009851
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/8:11712443.txt --chr 8 --out ../TEMPO/8:11712443
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/8:16697593.txt --chr 8 --out ../TEMPO/8:16697593
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/8:22525980.txt --chr 8 --out ../TEMPO/8:22525980
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/8:130901909.txt --chr 8 --out ../TEMPO/8:130901909
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/9:17579690.txt --chr 9 --out ../TEMPO/9:17579690
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/9:17727065.txt --chr 9 --out ../TEMPO/9:17727065
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/9:34046391.txt --chr 9 --out ../TEMPO/9:34046391
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/10:15557406.txt --chr 10 --out ../TEMPO/10:15557406
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/10:104015279.txt --chr 10 --out ../TEMPO/10:104015279
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/10:121415685.txt --chr 10 --out ../TEMPO/10:121415685
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/10:121536327.txt --chr 10 --out ../TEMPO/10:121536327
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/11:10558777.txt --chr 11 --out ../TEMPO/11:10558777
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/11:83487277.txt --chr 11 --out ../TEMPO/11:83487277
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/11:133787001.txt --chr 11 --out ../TEMPO/11:133787001
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/12:40614434.txt --chr 12 --out ../TEMPO/12:40614434
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/12:40734202.txt --chr 12 --out ../TEMPO/12:40734202
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/12:46419086.txt --chr 12 --out ../TEMPO/12:46419086
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/12:123326598.txt --chr 12 --out ../TEMPO/12:123326598
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/12:133063768.txt --chr 12 --out ../TEMPO/12:133063768
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/13:49927732.txt --chr 13 --out ../TEMPO/13:49927732
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/13:97865021.txt --chr 13 --out ../TEMPO/13:97865021
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/14:37989270.txt --chr 14 --out ../TEMPO/14:37989270
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/14:55348869.txt --chr 14 --out ../TEMPO/14:55348869
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/14:75373034.txt --chr 14 --out ../TEMPO/14:75373034
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/14:88464264.txt --chr 14 --out ../TEMPO/14:88464264
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/15:61997385.txt --chr 15 --out ../TEMPO/15:61997385
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/16:19277493.txt --chr 16 --out ../TEMPO/16:19277493
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/16:28944396.txt --chr 16 --out ../TEMPO/16:28944396
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/16:30977799.txt --chr 16 --out ../TEMPO/16:30977799
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/16:50736656.txt --chr 16 --out ../TEMPO/16:50736656
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/16:52636242.txt --chr 16 --out ../TEMPO/16:52636242
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/16:52969426.txt --chr 16 --out ../TEMPO/16:52969426
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/17:7355621.txt --chr 17 --out ../TEMPO/17:7355621
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/17:40741013.txt --chr 17 --out ../TEMPO/17:40741013
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/17:42294337.txt --chr 17 --out ../TEMPO/17:42294337
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/17:42434630.txt --chr 17 --out ../TEMPO/17:42434630
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/17:43744203.txt --chr 17 --out ../TEMPO/17:43744203
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/17:43798308.txt --chr 17 --out ../TEMPO/17:43798308
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/17:44866805.txt --chr 17 --out ../TEMPO/17:44866805
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/17:59917366.txt --chr 17 --out ../TEMPO/17:59917366
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/17:76425480.txt --chr 17 --out ../TEMPO/17:76425480
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/18:31304318.txt --chr 18 --out ../TEMPO/18:31304318
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/18:40673380.txt --chr 18 --out ../TEMPO/18:40673380
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/18:48683589.txt --chr 18 --out ../TEMPO/18:48683589
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/19:2341047.txt --chr 19 --out ../TEMPO/19:2341047
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/20:6006041.txt --chr 20 --out ../TEMPO/20:6006041
plink --bfile HARDCALLS_PD_september_2018_no_cousins --tag-r2 0.5 --memory 135000 --threads 19 --show-tags ../TEMPO/21:38852361.txt --chr 21 --out ../TEMPO/21:38852361

