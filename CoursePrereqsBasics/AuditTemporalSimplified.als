
module AuditTemporalSimplified




sig Course{
	prereq: set Course
}

fact{
	prereq = {
		A1000 -> A2000
		+ A1000 -> A2020
		+ A2000 -> A4000
		+ A2020 -> A4000
	}	
}

one sig A1000, A2000, A2020, A4000  in Course{}

var sig semCourses in Course{}

pred prerequisites[c: Course]{
	all p: prereq.c | once p in semCourses
}


pred semester{
	all s: semCourses' | prerequisites[s]
}

pred doNothing{
	no semCourses
}

fact{
	no semCourses
	always Course' = Course
	always{
		semester
	}
}


pred audit{
	eventually A4000 in semCourses
}

run audit for 4

