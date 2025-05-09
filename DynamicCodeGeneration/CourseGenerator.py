import os
import csv
import pickle
import itertools
import re


class CourseGenerator:

    class Course:
        def __init__(self, dept: str, num: int, name: str, credits: float, semesters: str, prereqs: str):
            self.dept = dept
            self.num = num
            self.name = name
            self.credits = credits
            self.semesters = semesters
            self.prereqs = prereqs

    def _load_courses(self) -> dict[str, Course]:
        """Internal method for loading the courses from the course catalog

        Returns:
            dict[str, Course]: Returns a dictionary of courses.
        """
        if os.path.exists("courses.pkl"):
            return pickle.load(open("courses.pkl", "rb"))
        else:
            courseList = {}
            with open("courseCatalog.csv", "r") as f:
                c = csv.reader(f)
                for course in itertools.islice(c, 1, None):
                    courseCode = str(course[0]) + str(course[1])
                    courseList[courseCode] = CourseGenerator.Course(course[0], course[1], course[2], course[3], course[4], course[5])
            pickle.dump(courseList, open("courses.pkl", "wb"))
            return courseList

    
    def get_course_alloy(self, course: str | Course) -> str:
        """Gets the Alloy code for a course.

        Args:
            course (str | Course): Course object or string representing the course code.

        Raises:
            IndexError: Raised if course is a str and not in the course catalog.
            TypeError: Raised if course is not a string or Course object.

        Returns:
            str: Alloy code for the course.
        """
        #formats input for consistency, and performs sanity checks
        if isinstance(course, str):
            if course not in self._courses:
                raise IndexError(f"Course {course} not in course catalog")
            courseName = course
            course: CourseGenerator.Course = self._courses[course]
        elif isinstance(course, CourseGenerator.Course):
            courseName = course.dept + course.num
        else:
            raise TypeError("Course must be a string or Course object")

        header = f"one sig {courseName} extends {course.dept + "Course"}"+"{}{\n"
        body = f"{re.sub(r'([A-Za-z][A-Za-z]+) ([0-9]{4})', r'\1\2 in prereqs', course.prereqs)} \nthis in Course{int(int(course.num)/1000)*1000}\n" + "}"

        return header + body



    def __init__(self):
        self._courses = self._load_courses()


if __name__ == "__main__":
    courseGen = CourseGenerator()
    CSCourses = ["CS1000","CS1131","CS1121","CS1122","CS1142","CS2311","MA3210",
                "CS2321","CS3000","CS3141","CS3311","CS3331","CS3411","CS3421",
                "CS3425","CS4121","CS4321","HU3120","MA1160","MA2330","MA2720"]
    
    techAndSocietyCourses = ["HU3701", "HU3710","HU3810", "MA4945", "SS3510", 
                             "SS3511", "SS3520", "SS3530","SS3580", "SS3581", 
                             "SS3630", "SS3640", "SS3800", "SS3801"]
    
    courseGen.Course()

    for course in CSCourses:
        print(courseGen.get_course_alloy(course))

    for course in techAndSocietyCourses:
        print(courseGen.get_course_alloy(course))

