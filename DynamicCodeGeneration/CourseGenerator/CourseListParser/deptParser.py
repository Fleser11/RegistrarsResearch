#Finds all the departments in the course catalog and writes them to a CSV file

import csv
import re

catalogFile = open("courseCatalog.html", 'r')
deptCSV = open("deptCatalog.csv", 'w', newline='')
deptCSVWriter = csv.writer(deptCSV)
deptCSVWriter.writerow(["Key", "Name"])

line = catalogFile.readline()

while line:
    dept = re.match(r"<h3>([A-Z]*?)-(.*?)<\/h3>", line)
    if dept:
        deptCSVWriter.writerow([dept.group(1), dept.group(2).replace("&amp;", "&")])
    line = catalogFile.readline()