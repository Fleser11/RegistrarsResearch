import json
import re
from itertools import islice
import CourseFileGenerator

class AuditGenerator:

    def __init__(self, audit_json_path: str):
        self.audit_file_str= audit_json_path
        self.audit = json.load(open(audit_json_path, 'r'))
        self.CourseFileGenerator = CourseFileGenerator.CourseFileGenerator()


    def format_reqs_str(reqs: str, audit_file: str | None) -> str:
        """Formats the reqs string to add the in reqs statement.

        Args:
            reqs (str): The original reqs string

        Returns:
            str: The formatted reqs string
        """

        reqs = re.sub(r'(?<!abstract_)([A-Za-z][A-Za-z]+[0-9]{4})(\(C\))?', r'\1 in reqs', reqs)

        if audit_file:
            reqs = re.sub(r'(abstract_[a-zA-Z0-9]*)', f"{audit_file}_" + r'\1 in reqs', reqs)
        else:
            reqs = re.sub(r'(abstract_[a-zA-Z0-9]*)', r'\1 in reqs', reqs)

        return reqs

    def generate_audit_file(self, output_file_name: str, course_file_name: str):

        header = f"open {course_file_name.removesuffix(".als")}\n"

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

abstract sig AuditBlock{
	reqs: set Course
}
"""

        
        subAudits = []
        body = ""
        audit = self.audit
        while True:
            for name, subAudit in audit["subAudit"].items():
                subAudits.append(audit["info"]["code"]+"_"+name)
                body += f"one sig {audit["info"]["code"]+"_"+name} extends AuditBlock {"{}{"}\n"
                if subAudit["cardinality"] == "ALL":
                    for i, course in enumerate(subAudit["courses"]):
                        if course.startswith("abstract_"):
                            body += f"{"and" if i > 0 else ""} (some c: {audit["info"]["code"]}_{course}| c in reqs)\n"
                        else:
                            body += f'{"and" if i > 0 else ""} ({AuditGenerator.format_reqs_str(course, audit["info"]["code"])})\n'
                else:
                    body += f'#reqs = {subAudit["cardinality"]}\n'
                    body += re.sub(r'(abstract_[a-zA-Z0-9]*)', f"{audit["info"]["code"]}_" + r'\1', 'reqs in (' + " + ".join(subAudit["courses"])+")\n")
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

        pred = """
pred complete{
    all c: AuditBlock.reqs | once c in passedCourses

"""
        subAudits = [x+".reqs" for x in subAudits]
        pred += "    disj[" + ",".join(subAudits) + "]\n}\n"

        run = """
run {eventually complete} for 74 Course, exactly 8 steps"""
            

        with open(output_file_name, 'w') as output_file:
            output_file.write(header)
            output_file.write(body)
            output_file.write(pred)
            output_file.write(run)

    def generate_model(self, output_file_name):
        self.CourseFileGenerator.generate_course_file(f"courses_{output_file_name}", self.audit_file_str)
        self.generate_audit_file(output_file_name, f"courses_{output_file_name}")


if __name__ == "__main__":
    auditGen = AuditGenerator("FullCSAlloyModel/SCS22022.audit.json")
    auditGen.generate_model("audit.als")
