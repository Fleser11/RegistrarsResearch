#Parses the HTML file to get all of the courses and put them into the csv


import re
import csv

courseCSV = open("courseCatalog.csv", 'w', newline='')
courseCSVWriter = csv.writer(courseCSV)
courseCSVWriter.writerow(["code", "dept", "number", "name", "credits", "semester", "prereqs", "description"])

catalogIO =  open("DynamicCodeGeneration/CourseGenerator/CourseListParser/courseCatalog.html", 'r')

course = catalogIO.readline()
line : str = catalogIO.readline()

while line:
    if line.find("<h4>") == -1 and line.find("</article>") == -1:
        course = "".join([course, line])
    else:
        print(course)
        header = re.match(r"<h4>([A-Z]*) ([0-9]*T*) - (.*)<\/h4>", course)
        if header:
            print("dept: " + header.group(1))
            print("course number: " + header.group(2))
            print("course name: " + header.group(3))
        else:
            print("No header match")
            raise Exception("No header match")

        description = re.search(r"<p.*?>\n(.*?)\n<\/p>", course)
        if description:
            print("description: " + description.group(1))
        else:
            print("No description match")
            print(course)
            raise Exception("No description match")

        otherInfo = re.search(r"Credits:<\/strong> \n([0-9]*.[0-9]|var)(.|\s)*?Semesters Offered:<\/strong> \n(.*?)<\/li>(.|\s)*?", course)
        
        if otherInfo:
            print("credits: " + otherInfo.group(1))
            print("semesters offered: " + otherInfo.group(3))
        else:
            print("No other info match")
            raise Exception("No other info match")

        

        prereqs = re.search(r"Pre-Requisite\(s\):<\/strong>\s*(.*)", course)

        if prereqs:
            prereqs = re.sub(r'([A-Za-z][A-Za-z]+) ([0-9]{4})', r'\1\2', prereqs.group(1))
            print("prereqs: " + prereqs)
        else:
            print("No prereqs match")

        # print(course)
        courseCSVWriter.writerow([header.group(1) + header.group(2), header.group(1), header.group(2), header.group(3), otherInfo.group(1), otherInfo.group(3), prereqs, description.group(1)])
        course = line
        
    
    line = catalogIO.readline()


