#! /usr/bin/python3

from thefuzz import process, fuzz

with open("profils_names.csv") as fp:
    prn = fp.readlines()

prn = [x.strip() for x in prn]

with open("config_vars_names.csv") as fc:
    cvn = fc.readlines()

cvn = [x.strip() for x in cvn]

for profil in prn:
    match_ratios = process.extract(profil, cvn, scorer=fuzz.token_set_ratio)
#    print(profil)
    #print(profil, match_ratios)
    for prn_match_cvn in match_ratios:
      print(profil, prn_match_cvn) 

