For coding variants "tags" were first created using get_05tags_for_META5_HRC.sh
And then annotation_of_tags.sh was used to annotate
These are in GWAS BROWSER/Coding variants

Then use annotated_R05_tags_META5.txt to compare with GWAS_catalogv1.0.2-associations.xlsx


frequencies of cases and controls were created like this:
cd /data/LNG/CORNELIS_TEMP/PD_FINAL_PLINK_2018
# Among remaining phenotypes, 21478 are cases and 24388 are controls.
plink --bfile HARDCALLS_PD_september_2018_no_cousins --extract /data/CARD/GENERAL/META5_GRS_chr_bp.txt --model
plink --bfile HARDCALLS_PD_september_2018_no_cousins --extract /data/CARD/GENERAL/META5_GRS_chr_bp.txt --assoc