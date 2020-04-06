#!/bin/sh

#Cornelis Blauwendraat
#December 2019

# sbatch --cpus-per-task=20 --mem=140g --mail-type=END --time=3:00:00 get_05tags_for_META5.sh

cd $PATH1

# example:
# sed -i.bkp 's/^/REMOVE\t/' REMOVE.txt

mkdir TAGS
scp *.tags TAGS/ 

sed -i.bkp 's/^/1\t/' 1:154898185.tags
sed -i.bkp 's/^/1\t/' 1:155135036.tags
sed -i.bkp 's/^/1\t/' 1:155205634.tags
sed -i.bkp 's/^/2\t/' 1:161469054.tags
sed -i.bkp 's/^/3\t/' 1:171719769.tags
sed -i.bkp 's/^/4\t/' 1:205723572.tags
sed -i.bkp 's/^/4\t/' 1:205737739.tags
sed -i.bkp 's/^/5\t/' 1:226916078.tags
sed -i.bkp 's/^/6\t/' 1:232664611.tags
sed -i.bkp 's/^/7\t/' 2:18147848.tags
sed -i.bkp 's/^/8\t/' 2:96000943.tags
sed -i.bkp 's/^/9\t/' 2:102396963.tags
sed -i.bkp 's/^/10\t/' 2:135464616.tags
sed -i.bkp 's/^/11\t/' 2:169110394.tags
sed -i.bkp 's/^/12\t/' 3:18361759.tags
sed -i.bkp 's/^/13\t/' 3:28705690.tags
sed -i.bkp 's/^/14\t/' 3:48748989.tags
sed -i.bkp 's/^/15\t/' 3:122196892.tags
sed -i.bkp 's/^/16\t/' 3:151108965.tags
sed -i.bkp 's/^/17\t/' 3:161077630.tags
sed -i.bkp 's/^/18\t/' 3:182760073.tags
sed -i.bkp 's/^/19\t/' 4:925376.tags
sed -i.bkp 's/^/19\t/' 4:951947.tags
sed -i.bkp 's/^/20\t/' 4:15737348.tags
sed -i.bkp 's/^/21\t/' 4:17968811.tags
sed -i.bkp 's/^/22\t/' 4:77110365.tags
sed -i.bkp 's/^/22\t/' 4:77147969.tags
sed -i.bkp 's/^/22\t/' 4:77198054.tags
sed -i.bkp 's/^/23\t/' 4:90626111.tags
sed -i.bkp 's/^/23\t/' 4:90636630.tags
sed -i.bkp 's/^/24\t/' 4:114369065.tags
sed -i.bkp 's/^/25\t/' 4:170583157.tags
sed -i.bkp 's/^/26\t/' 5:60137959.tags
sed -i.bkp 's/^/27\t/' 5:102365794.tags
sed -i.bkp 's/^/28\t/' 5:134199105.tags
sed -i.bkp 's/^/29\t/' 6:27738801.tags
sed -i.bkp 's/^/30\t/' 6:30108683.tags
sed -i.bkp 's/^/31\t/' 6:32578772.tags
sed -i.bkp 's/^/32\t/' 6:72487762.tags
sed -i.bkp 's/^/33\t/' 6:112243291.tags
sed -i.bkp 's/^/34\t/' 6:133210361.tags
sed -i.bkp 's/^/35\t/' 7:23300049.tags
sed -i.bkp 's/^/36\t/' 7:66009851.tags
sed -i.bkp 's/^/37\t/' 8:11712443.tags
sed -i.bkp 's/^/38\t/' 8:16697593.tags
sed -i.bkp 's/^/39\t/' 8:22525980.tags
sed -i.bkp 's/^/40\t/' 8:130901909.tags
sed -i.bkp 's/^/41\t/' 9:17579690.tags
sed -i.bkp 's/^/41\t/' 9:17727065.tags
sed -i.bkp 's/^/42\t/' 9:34046391.tags
sed -i.bkp 's/^/43\t/' 10:15557406.tags
sed -i.bkp 's/^/44\t/' 10:104015279.tags
sed -i.bkp 's/^/45\t/' 10:121415685.tags
sed -i.bkp 's/^/45\t/' 10:121536327.tags
sed -i.bkp 's/^/46\t/' 11:10558777.tags
sed -i.bkp 's/^/47\t/' 11:83487277.tags
sed -i.bkp 's/^/48\t/' 11:133787001.tags
sed -i.bkp 's/^/49\t/' 12:40614434.tags
sed -i.bkp 's/^/49\t/' 12:40734202.tags
sed -i.bkp 's/^/50\t/' 12:46419086.tags
sed -i.bkp 's/^/51\t/' 12:123326598.tags
sed -i.bkp 's/^/52\t/' 12:133063768.tags
sed -i.bkp 's/^/53\t/' 13:49927732.tags
sed -i.bkp 's/^/54\t/' 13:97865021.tags
sed -i.bkp 's/^/55\t/' 14:37989270.tags
sed -i.bkp 's/^/56\t/' 14:55348869.tags
sed -i.bkp 's/^/57\t/' 14:75373034.tags
sed -i.bkp 's/^/58\t/' 14:88464264.tags
sed -i.bkp 's/^/59\t/' 15:61997385.tags
sed -i.bkp 's/^/60\t/' 16:19277493.tags
sed -i.bkp 's/^/61\t/' 16:28944396.tags
sed -i.bkp 's/^/62\t/' 16:30977799.tags
sed -i.bkp 's/^/63\t/' 16:50736656.tags
sed -i.bkp 's/^/64\t/' 16:52636242.tags
sed -i.bkp 's/^/65\t/' 16:52969426.tags
sed -i.bkp 's/^/66\t/' 17:7355621.tags
sed -i.bkp 's/^/67\t/' 17:40741013.tags
sed -i.bkp 's/^/68\t/' 17:42294337.tags
sed -i.bkp 's/^/68\t/' 17:42434630.tags
sed -i.bkp 's/^/69\t/' 17:43744203.tags
sed -i.bkp 's/^/69\t/' 17:43798308.tags
sed -i.bkp 's/^/70\t/' 17:44866805.tags
sed -i.bkp 's/^/71\t/' 17:59917366.tags
sed -i.bkp 's/^/72\t/' 17:76425480.tags
sed -i.bkp 's/^/73\t/' 18:31304318.tags
sed -i.bkp 's/^/74\t/' 18:40673380.tags
sed -i.bkp 's/^/75\t/' 18:48683589.tags
sed -i.bkp 's/^/76\t/' 19:2341047.tags
sed -i.bkp 's/^/77\t/' 20:6006041.tags
sed -i.bkp 's/^/78\t/' 21:38852361.tags

cp *.tags $PATH2

cd TAGS

cat *.tags > ALL_TAGS.txt


# then annotate with annovar and rs-ids
module load R
R
require("data.table")
tags <- fread("ALL_TAGS.txt",header=F)
annovar <- fread("$PATH3/HRC_ouput_annovar_ALL.txt",header=T)
RS <- fread("$PATH3/HRC_RS_conversion_final.txt",header=T)
MM <- merge(tags,RS,by.x="V2",by.y="POS",all.x = TRUE)
MM2 <- merge(MM,annovar,by.x="ID",by.y="avsnp142",all.x = TRUE)
write.table(MM2,file="annotated_R05_tags_META5.txt",quote=F,row.names=F,sep="\t")












