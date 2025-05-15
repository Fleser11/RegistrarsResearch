module AuditTemporal

open coursesTemporal

pred prereqsMet[c: Course]{
	all p: c.prereqs | once p in passedCourses
}

pred doNothing{
	no semCourses
}

pred semester {
	all c: semCourses' | prereqsMet[c]
	#semCourses <= 4
	no k : semCourses' | once k in semCourses
}

fact{
	no semCourses
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

one sig Core extends AuditBlock{}
{
	((CS1000+CS1121+CS1122+CS2321) in reqs)
	and (one c:(CS2311 + MA3210)| c in reqs)
}

one sig GenEdCore extends AuditBlock{}
{
	(UN1015 + UN1025) in reqs
	and (one c: (HUCourse)| c in reqs)
}

one sig TechandSociety extends AuditBlock{}
{
	one c: (SS3510 + SS3520)| c in reqs
}

one sig TechElectives extends AuditBlock{}{
	#reqs = 3
	some c: ((MACourses & (Course2000 + Course3000 + Course4000)) + EE2111 + EE2174) | c in reqs
}

one sig Concentration extends AuditBlock{}{
	one c: (CSCourse & Course4000) | c in reqs
	and
	(MA2160) in reqs
	and
	one m: (MACourses & (Course3000 + Course4000)) | m in reqs
}	


pred complete{
	all c: Core.reqs | once c in passedCourses
	and
	all c: GenEdCore.reqs | once c in passedCourses
	and
	all c: TechandSociety.reqs | once c in passedCourses
	and
	all c: TechElectives.reqs | once c in passedCourses
	and
	all c: Concentration.reqs | once c in passedCourses
	and
	disj[Core.reqs, GenEdCore.reqs, TechandSociety.reqs, TechElectives.reqs, Concentration.reqs]
	
}


run {eventually complete} for 20




