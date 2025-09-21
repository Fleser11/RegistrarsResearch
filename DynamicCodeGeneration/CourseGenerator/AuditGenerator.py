#Creates a course file and an audit file from the course catalog and the audit json file

import json
import re
from itertools import islice
import CourseFileGenerator

class AuditGenerator:
    """Generates the audit file from the audit json file."""


    def __init__(self, audit_json_path: str):
        """Initializes the AuditGenerator with the audit json file.

        Args:
            audit_json_path (str): The path to the audit json file.
        """
        self.audit_file_str= audit_json_path
        self.audit = json.load(open(audit_json_path, 'r'))
        self.CourseFileGenerator = CourseFileGenerator.CourseFileGenerator()


    def format_reqs_str(reqs: str, audit_file: str | None, subAudit: str) -> str:
        """Formats the reqs string to add the in reqs statement.

        Args:
            reqs (str): The original reqs string

        Returns:
            str: The formatted reqs string
        """

        #replaces all non with a C with ones without the C
        reqs = re.sub(r'(?<!abstract_)([A-Za-z][A-Za-z]+[0-9]{4})(\(C\))?', fr'\1', reqs)

        #if there is an audit file prefixes with the name
        if audit_file:
            reqs = re.sub(r'(abstract_[a-zA-Z0-9]*)', f"{audit_file}_" + fr'\1 in {subAudit}', reqs)
        else:
            reqs = re.sub(r'(abstract_[a-zA-Z0-9]*)', fr'\1 in {subAudit}', reqs)

        return reqs

    def generate_audit_file(self, output_file_name: str, course_file_name: str):
        """Generates the audit file from the audit json file. 
        Args:
            output_file_name (str): The name of the output file.
            course_file_name (str): The name of the course file.
        """
        
        header = f"open {course_file_name.removesuffix(".als")}\n"

        #header is always the same (for now anyhow)
        header += """

pred prereqsMet[c: Course]{
	all p: c.prereqs | once p in passedCourses
}

pred doNothing{
    #semCourses <= 6
	always semCourses' = semCourses
}

pred semester {
	all c: semCourses' | prereqsMet[c]
	#semCourses <= 6
	no k : semCourses' | once k in semCourses
}

fact{
	no semCourses.prereqs
	semCourses' != semCourses
	always Course' = Course
	always{
		semester
		or
		always doNothing
	}
}

"""

        #collects all the subaudits
        subAudits = []
        body = ""
        audit = self.audit
        while True: #reads through all of the subAudits and requires each of the courses in each one

            #adds each audit block to the body
            for name, subAudit in audit["subAudit"].items():

                #uses a unique name of the audit code and the name of the subAudit
                subAudits.append(audit["info"]["code"]+"_"+name)
                body += f"sig {audit["info"]["code"]+"_"+name} in Course {"{}\nfact {"}\n"
                
                #switches between two modes of either including all the courses or just specified ones and requiring a specific cardinality
                if subAudit["cardinality"] == "ALL":#adds all the courses
                    for i, course in enumerate(subAudit["courses"]):
                        if course.startswith("abstract_"):
                            body += f"{"and" if i > 0 else ""} (some c: {audit["info"]["code"]}_{course}| c in {audit["info"]["code"]+"_"+name})\n"
                        else:
                            body += f'{"and" if i > 0 else ""} ({AuditGenerator.format_reqs_str(course, audit["info"]["code"], audit["info"]["code"]+"_"+name)})\n'
                else: #adds all of the courses and requires the cardinality
                    body += f'#{audit["info"]["code"]+"_"+name} = {subAudit["cardinality"]}\n'
                    body += re.sub(r'(abstract_[a-zA-Z0-9]*)', f"{audit["info"]["code"]}_" + r'\1', f'{audit["info"]["code"]+"_"+name} in (' + " + ".join(subAudit["courses"])+")\n")
                    # body += f'({AuditGenerator.format_reqs_str(subAudit["courses"][0], audit["info"]["code"])})\n'
                    # for course in islice(subAudit["courses"], 1, None):
                    #     body += f'or ({AuditGenerator.format_reqs_str(course, audit["info"]["code"])})\n'
                body += "}\n"
            if "path" not in audit["link"]:
                break
            else:
                audit = json.load(open(audit["link"]["path"], 'r'))

            # body += {
                    
            # }

        pred = "pred complete {\n"
        for sub in subAudits:
            pred += f"all c: {sub} | once c in passedCourses\n"

        # subAudits = [x+".reqs" for x in subAudits]
        pred += "    disj[" + ",".join(subAudits) + "]\n}\n"

        run = """
run {eventually complete} for 74 Course, exactly 8 steps"""
            

        #Puts all of the major components of the audit file
        with open(output_file_name, 'w') as output_file:
            output_file.write(header)
            output_file.write(body)
            output_file.write(pred)
            output_file.write(run)

    def generate_model(self, output_file_name):
        """Generates the model from the audit json file. Doing both the course file and the audit file.

        Args:
            output_file_name (str): The name of the output file.
        """

        self.CourseFileGenerator.generate_course_file(f"courses_{output_file_name}", self.audit_file_str)
        self.generate_audit_file(output_file_name, f"courses_{output_file_name}")


if __name__ == "__main__":
    auditGen = AuditGenerator("FullCSAlloyModel/SCS22022.audit.json")
    auditGen.generate_model("audit.als")
