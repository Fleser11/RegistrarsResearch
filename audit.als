open courses_audit


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
one sig SCS22022_core extends AuditBlock {}{
 (CS1000 in reqs)
and (CS1131 in reqs or (CS1121 in reqs and CS1122 in reqs))
and (CS1142 in reqs)
and (CS2311 in reqs or MA3210 in reqs)
and (CS2321 in reqs)
and (CS3000 in reqs)
and (CS3141 in reqs)
and (CS3311 in reqs)
and (CS3331 in reqs)
and (CS3411 in reqs)
and (CS3421 in reqs)
and (CS3425 in reqs)
and (CS4121 in reqs)
and (CS4321 in reqs)
and (HU3120 in reqs)
and (MA1160 in reqs or MA1161 in reqs)
and (MA2330 in reqs)
and (MA2720 in reqs or MA3710 in reqs)
}
one sig SCS22022_TechAndSociety extends AuditBlock {}{
#reqs = 1
reqs in (HU3701 + HU3710 + HU3810 + MA4945 + SS3510 + SS3511 + SS3520 + SS3530 + SS3580 + SS3581 + SS3630 + SS3640 + SS3800 + SS3801)
}
one sig SCS22022_LabScience extends AuditBlock {}{
#reqs = 2
reqs in (SCS22022_abstract_BL + SCS22022_abstract_CH + SCS22022_abstract_PH + SCS22022_abstract_KIP + SCS22022_abstract_FW + SCS22022_abstract_GE + SCS22022_abstract_SS)
}
one sig SCS22022_ConcentrationRequirement extends AuditBlock {}{
 (some c: SCS22022_abstract_CS4000a| c in reqs)
and (some c: SCS22022_abstract_CS4000b| c in reqs)
and (MA2160 in reqs)
and (some c: SCS22022_abstract_MA3000| c in reqs)
}
one sig SCS22022_TechElectives extends AuditBlock {}{
#reqs = 3
reqs in (SCS22022_abstract_TechElective)
}
one sig SCS22022_FreeElectives extends AuditBlock {}{
#reqs = 3
reqs in (SCS22022_abstract_FreeElective)
}
one sig GenEd_core extends AuditBlock {}{
 (UN1015 in reqs)
and (UN1025 in reqs)
and (some c: GenEd_abstract_CriticalCreativeThinking| c in reqs)
and (some c: GenEd_abstract_SocialEthicalResponsibility| c in reqs)
}
one sig GenEd_HASS extends AuditBlock {}{
 (some c: GenEd_abstract_CommComp| c in reqs)
and (some c: GenEd_abstract_HumanditiesFineArts| c in reqs)
and (some c: GenEd_abstract_SocialandBehavioralSciences| c in reqs)
and (some c: GenEd_abstract_HASS| c in reqs)
}

pred complete{
    all c: AuditBlock.reqs | once c in passedCourses

    disj[SCS22022_core.reqs,SCS22022_TechAndSociety.reqs,SCS22022_LabScience.reqs,SCS22022_ConcentrationRequirement.reqs,SCS22022_TechElectives.reqs,SCS22022_FreeElectives.reqs,GenEd_core.reqs,GenEd_HASS.reqs]
}

run {eventually complete} for 74 Course, exactly 8 steps