#!/usr/bin/env python3

# advanced example!

# Loading Relevant Libraries
import csv
import json
from pprint import pprint


# load input1.csv (expenditures) and input2.json (legislators)
with open('input1.csv') as f:
	dictread = csv.DictReader(f)
	expenditures = list(dictread)

with open('input2.json') as f:
	legislators = json.load(f)

#pprint (legislators)


# we will merge the two datasets based on bioguide id

# create a mapping (dict) of legislators where the key is bioguide id
# and the value is the whole legislator dict
map = {}
for person in legislators:
	bioguide= person["id"]["bioguide"]
	map[bioguide]=person

#pprint(map)

cost_group_by_cat_and_party={}
# loop through the expenditures 
for cost in expenditures:
#filter down to those where the bioguide id exists	
	if cost['BIOGUIDE_ID']:
		cat = cost['CATEGORY']
		amt = float(cost['AMOUNT'])
		bioguide = cost['BIOGUIDE_ID']
			# look up the bioguide in the legislator mapping we created above
		if bioguide in map:
			# after finding the legislator, check the legislator's party in his/her last term
			person = map[bioguide]
			party = person['terms'][-1]['party'] #[-1] gets the most recent party afiliation
			# group by sum the AMOUNT based on CATEGORY and party: 
			if cat in cost_group_by_cat_and_party:
				if party in cost_group_by_cat_and_party[cat]:
					# loop through the rows and sum together the AMOUNT for each combination of CATEGORY and party
					cost_group_by_cat_and_party[cat][party] += amt
				else:
					cost_group_by_cat_and_party[cat][party] = amt
			else:
				cost_group_by_cat_and_party[cat]={}
				cost_group_by_cat_and_party[cat][party] = amt

# if the bioguide doesn't exist in the mapping, skip it

#pprint(cost_group_by_cat_and_party)

output=[]
for key in cost_group_by_cat_and_party:
	value = cost_group_by_cat_and_party[key]
	value['label'] = key
	output.append(value)

#pprint(output)
with open('output.json', 'w') as f:
    json.dump(output, f, indent=2)
