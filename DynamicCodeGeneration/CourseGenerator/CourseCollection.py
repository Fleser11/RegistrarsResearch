#Defines what a collection of courses is and defines the catalog

import os
import csv
import dill
import itertools
import re


class CourseCollection:
    """A collection of courses.
    """

    class Course:
        def __init__(self, dept: str, num: int, name: str, credits: float, semesters: str, prereqs: str):
            self.dept = dept
            self.num = num
            self.name = name
            self.credits = credits
            self.semesters = semesters
            self.prereqs = prereqs

        def get_course_alloy(self) -> str:
            """Returns the course in alloy format.

            Returns:
                str: The alloy code for the course.
            """
            
            courseName = self.dept + self.num

            header = f"one sig {courseName} extends {self.dept + "Course"}"+"{}{\n"
            if self.prereqs.find("ALEKS") == -1 and self.prereqs.find("CEEB") == -1:
                body = f"{re.sub(r'([A-Za-z][A-Za-z]+[0-9]{4})(\(C\))?', r'\1 in prereqs', self.prereqs)} \nthis in Course{int(int(self.num)/1000)*1000}\n" + "}" + "\n"
            else:
                body = f"this in Course{int(int(self.num)/1000)*1000}\n" + "}\n"

            return header + body

    def get_course_list(self) -> dict[str, Course]:
        return self._courses
    
    def get_course(self, course: str) -> Course | None:
        """Returns either a course object or None if the course is not in the course catalog.

        Args:
            course (str): the course code

        Returns:
            Course | None: The course object or None if the course is not in the course catalog.
        """
        return self._courses[course] if course in self._courses.keys() else None
    
    def add_course(self, dept: str, num: int, name: str, credits: float, semesters: str, prereqs: str) -> None:
        self._courses[dept + str(num)] = CourseCollection.Course(dept, num, name, credits, semesters, prereqs)

    def _add_Course(self, course: Course, code: str) -> None:
        self._courses[code] = course


    def __init__(self):
        self._courses: dict[str, CourseCollection.Course] = {}


class CourseCatalog(CourseCollection):

    def _load_courses(self) -> dict[str, CourseCollection.Course]:
        """Internal method for loading the courses from the course catalog

        Returns:
            dict[str, Course]: Returns a dictionary of courses.
        """
        if os.path.exists(os.path.dirname(__file__)+"/courses.pkl"):
            return dill.load(open(os.path.dirname(__file__)+"/courses.pkl", "rb"))
        else:
            courseList = {}
            with open(os.path.dirname(__file__)+"/courseCatalog.csv", "r") as f:
                c = csv.reader(f)
                for course in itertools.islice(c, 1, None):
                    courseCode = str(course[0]) + str(course[1])
                    courseList[courseCode] = CourseCollection.Course(course[0], course[1], course[2], course[3], course[4], course[5])
            dill.dump(courseList, open(os.path.dirname(__file__) + "/courses.pkl", "wb"))
            return courseList

    
    

    def __init__(self):
        self._courses = self._load_courses()


if __name__ == "__main__":
    courseGen = CourseCatalog()

    
    CSCourses = ["CS1000","CS1131","CS1121","CS1122","CS1142","CS2311","MA3210",
                "CS2321","CS3000","CS3141","CS3311","CS3331","CS3411","CS3421",
                "CS3425","CS4121","CS4321","HU3120","MA1160","MA2330","MA2720"]
    
    techAndSocietyCourses = ["HU3701", "HU3710","HU3810", "MA4945", "SS3510", 
                             "SS3511", "SS3520", "SS3530","SS3580", "SS3581", 
                             "SS3630", "SS3640", "SS3800", "SS3801"]
    
    concentrationCourses = ["MA2160"]
    

    for course in CSCourses:
        print(courseGen.get_course(course).get_course_alloy())

    for course in techAndSocietyCourses:
        print(courseGen.get_course(course).get_course_alloy())

