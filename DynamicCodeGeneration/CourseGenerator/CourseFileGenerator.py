#Generates the courseFile for the course, creates narrow scoping of courses
#Also parses a audit json file to get the course information


# import CourseCollection as CourseCollection
import CourseCollection
import json
import re


class CourseFileGenerator:
    def __init__(self, *args):
        if len(args) == 1 and isinstance(args[0], CourseCollection):
            self.courseCatalog = args[0]
        elif len(args) == 0:
            self.courseCatalog = CourseCollection.CourseCatalog()


    def load_course_prereqs_recursive(self, courseCollection: CourseCollection.CourseCollection, course: str) -> list[str]:

        if not courseCollection.get_course(course):

            if not self.courseCatalog.get_course(course):                
                print(f"Course {course} not found in course catalog.")
                courseMatch = re.search(r"([a-zA-Z][a-zA-Z]+)([0-9][0-9][0-9][0-9])", course)
                if courseMatch:
                    courseCollection.add_course(courseMatch.group(1), courseMatch.group(2), "", 0, "", "")
                else:
                    print(f"Course {course} not of valid course format.")
                return
            else:
                courseCollection._add_Course(self.courseCatalog.get_course(course), course)
        
        course : CourseCollection.CourseCollection.Course = courseCollection.get_course(course)
        for prereq in re.findall(r"([a-zA-Z][a-zA-Z]+[0-9][0-9][0-9][0-9])", course.prereqs):
            if not courseCollection.get_course(prereq):
                courseCollection._add_Course(self.courseCatalog.get_course(prereq), prereq)
            self.load_course_prereqs_recursive(courseCollection, prereq)

        

    def create_course_collection(self, auditJson: str) -> tuple[CourseCollection.CourseCollection, list[str]]:
        """_summary_

        Args:
            auditJson (str): _description_

        Returns:
            tuple[CourseCollection.CourseCollection, CourseCollection.CourseCollection]: _description_
        """

        normalCourseCollection = CourseCollection.CourseCollection()
        abstractCourses = []

        link = auditJson
        while True:
            with open(link, "r") as f:
                audit = json.load(f)
                for subAudit in audit["subAudit"].values():
                    for course in subAudit["courses"]:
                        for x in re.findall(r"(?<!abstract_)([a-zA-Z][a-zA-Z]+[0-9][0-9][0-9][0-9])", course):
                            self.load_course_prereqs_recursive(normalCourseCollection, x)
                        for x in re.findall(r"(abstract_[a-zA-Z0-9]*)", course):
                            abstractCourses.append(audit["info"]["code"]+"_"+x)
                if "path" not in audit["link"]:
                    break
                else:
                    link = audit["link"]["path"]

        return (normalCourseCollection, abstractCourses)


    def generate_course_file(self, outputFile: str, auditJson: str):
        """Generates the course file for the course.

        Args:
            outputFile (str): The name of the output file.
            auditJson (str): The name of the audit json file.
        """

        courseCollection, abstractCourses = self.create_course_collection(auditJson)

        depts = []

        body = ""
        for code, course in courseCollection.get_course_list().items():
            if course.dept not in depts:
                depts.append(course.dept)
                body += f"abstract sig {course.dept}Course extends Course{{}}\n"
            body += course.get_course_alloy()

        for course in abstractCourses:
            body += f"sig {course} extends Course{{}}\n"


        header = """
abstract sig Course {
    prereqs: set Course
}

var sig semCourses in Course{}
var sig takenCourses in semCourses{}
var sig passedCourses in takenCourses{}

sig Course1000 in Course{}
sig Course2000 in Course{}
sig Course3000 in Course{}
sig Course4000 in Course{}
fact {
    disj[Course1000, Course2000, Course3000, Course4000]
    all c: semCourses | c in (Course1000 + Course2000 + Course3000 + Course4000)    
}

"""


        with open(outputFile, "w") as f:
            f.write(header)
            f.write(body)
            f.write("\n")



if __name__ == "__main__":
    courseFileGen = CourseFileGenerator()
    courseFileGen.generate_course_file("SCS2Course.als", "FullCSAlloyModel/SCS22022.audit.json")